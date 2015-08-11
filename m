From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 09/16] PM / hibernate: Reserve hibernation key and erase footprints
Date: Tue, 11 Aug 2015 14:16:29 +0800
Message-ID: <1439273796-25359-10-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Add handler to parse the setup data that carrying hibernation key, it
reserves hibernation key by memblock then copies key to a allocated page
in later initcall stage.

And for erasing footprints, the codes in this patch remove setup
data that carried hibernation key, and clean the memory space that
reserved by memblock.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/include/asm/suspend.h  |  4 +++
 arch/x86/kernel/setup.c         | 21 ++++++++++-
 arch/x86/power/Makefile         |  1 +
 arch/x86/power/hibernate_keys.c | 78 +++++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h            |  5 +++
 5 files changed, 108 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/power/hibernate_keys.c

diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
index ab463c4..bb3652a 100644
--- a/arch/x86/include/asm/suspend.h
+++ b/arch/x86/include/asm/suspend.h
@@ -7,8 +7,12 @@
 #ifdef CONFIG_HIBERNATE_VERIFICATION
 #include <linux/suspend.h>
 
+extern void parse_hibernation_keys(u64 phys_addr, u32 data_len);
+
 struct hibernation_keys {
 	unsigned long hkey_status;
 	u8 hibernation_key[HIBERNATION_DIGEST_SIZE];
 };
+#else
+static inline void parse_hibernation_keys(u64 phys_addr, u32 data_len) {}
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 80f874b..b345359 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -112,6 +112,8 @@
 #include <asm/alternative.h>
 #include <asm/prom.h>
 
+#include <asm/suspend.h>
+
 /*
  * max_low_pfn_mapped: highest direct mapped pfn under 4GB
  * max_pfn_mapped:     highest direct mapped pfn over 4GB
@@ -425,10 +427,22 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
+static void __init remove_setup_data(u64 pa_prev, u64 pa_next)
+{
+	struct setup_data *data;
+
+	if (pa_prev) {
+		data = early_memremap(pa_prev, sizeof(*data));
+		data->next = pa_next;
+		early_iounmap(data, sizeof(*data));
+	} else
+		boot_params.hdr.setup_data = pa_next;
+}
+
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
-	u64 pa_data, pa_next;
+	u64 pa_data, pa_next, pa_prev = 0;
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
@@ -450,9 +464,14 @@ static void __init parse_setup_data(void)
 		case SETUP_EFI:
 			parse_efi_setup(pa_data, data_len);
 			break;
+		case SETUP_HIBERNATION_KEYS:
+			parse_hibernation_keys(pa_data, data_len);
+			remove_setup_data(pa_prev, pa_next);
+			break;
 		default:
 			break;
 		}
+		pa_prev = pa_data;
 		pa_data = pa_next;
 	}
 }
diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index a6a198c..ef8d550 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -5,3 +5,4 @@ CFLAGS_cpu.o	:= $(nostackp)
 
 obj-$(CONFIG_PM_SLEEP)		+= cpu.o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o
+obj-$(CONFIG_HIBERNATE_VERIFICATION)	+= hibernate_keys.o
diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
new file mode 100644
index 0000000..357dc0e
--- /dev/null
+++ b/arch/x86/power/hibernate_keys.c
@@ -0,0 +1,78 @@
+/* Hibernation keys handler
+ *
+ * Copyright (C) 2015 Lee, Chun-Yi <jlee@suse.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/suspend.h>
+#include <asm/suspend.h>
+
+/* physical address of hibernation keys from boot params */
+static u64 keys_phys_addr;
+
+/* A page used to keep hibernation keys */
+static struct hibernation_keys *hibernation_keys;
+
+void __init parse_hibernation_keys(u64 phys_addr, u32 data_len)
+{
+	struct setup_data *hibernation_setup_data;
+
+	/* Reserve keys memory, will copy and erase in init_hibernation_keys() */
+	keys_phys_addr = phys_addr + sizeof(struct setup_data);
+	memblock_reserve(keys_phys_addr, sizeof(struct hibernation_keys));
+
+	/* clear hibernation_data */
+	hibernation_setup_data = early_memremap(phys_addr, data_len);
+	if (!hibernation_setup_data)
+		return;
+
+	memset(hibernation_setup_data, 0, sizeof(struct setup_data));
+	early_memunmap(hibernation_setup_data, data_len);
+}
+
+int get_hibernation_key(u8 **hkey)
+{
+	if (!hibernation_keys)
+		return -ENODEV;
+
+	if (!hibernation_keys->hkey_status)
+		*hkey = hibernation_keys->hibernation_key;
+
+	return hibernation_keys->hkey_status;
+}
+
+static int __init init_hibernation_keys(void)
+{
+	struct hibernation_keys *keys;
+	int ret = 0;
+
+	if (!keys_phys_addr)
+		return -ENODEV;
+
+	keys = early_memremap(keys_phys_addr, sizeof(struct hibernation_keys));
+
+	/* Copy hibernation keys to a allocated page */
+	hibernation_keys = (struct hibernation_keys *)get_zeroed_page(GFP_KERNEL);
+	if (hibernation_keys) {
+		*hibernation_keys = *keys;
+	} else {
+		pr_err("PM: Allocate hibernation keys page failed\n");
+		ret = -ENOMEM;
+	}
+
+	/* Erase keys data no matter copy success or failed */
+	memset(keys, 0, sizeof(struct hibernation_keys));
+	early_memunmap(keys, sizeof(struct hibernation_keys));
+	memblock_free(keys_phys_addr, sizeof(struct hibernation_keys));
+	keys_phys_addr = 0;
+
+	return ret;
+}
+
+late_initcall(init_hibernation_keys);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 6ea5c78..7d8f310 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -16,6 +16,11 @@ struct swsusp_info {
 	u8                      signature[HIBERNATION_DIGEST_SIZE];
 } __aligned(PAGE_SIZE);
 
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+/* arch/x86/power/hibernate_keys.c */
+extern int get_hibernation_key(u8 **hkey);
+#endif
+
 /* kernel/power/snapshot.c */
 extern void __init hibernate_reserved_size_init(void);
 extern void __init hibernate_image_size_init(void);
-- 
2.1.4
