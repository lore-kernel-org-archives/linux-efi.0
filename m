From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 09/16] PM / hibernate: Reserve swsusp key and earse footprints
Date: Thu, 16 Jul 2015 22:25:23 +0800
Message-ID: <1437056730-15247-10-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Add handler to parse the setup data that carrying swsusp key, it
reserves swsusp key by memblock then copies key to a allocated page
in later initcall stage.

And for earsing footbprints, the codes in this patch remove setup
data that carried swsusp key, and clean the memory space that
reserved by memblock.

Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 arch/x86/include/asm/suspend.h  |  4 +++
 arch/x86/kernel/setup.c         | 21 ++++++++++-
 arch/x86/power/Makefile         |  1 +
 arch/x86/power/hibernate_keys.c | 79 +++++++++++++++++++++++++++++++++++++++++
 kernel/power/power.h            |  5 +++
 5 files changed, 109 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/power/hibernate_keys.c

diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
index b0c3f68..bec87e3 100644
--- a/arch/x86/include/asm/suspend.h
+++ b/arch/x86/include/asm/suspend.h
@@ -7,8 +7,12 @@
 #ifdef CONFIG_HIBERNATE_VERIFICATION
 #include <linux/suspend.h>
 
+extern void parse_swsusp_keys(u64 phys_addr, u32 data_len);
+
 struct swsusp_keys {
 	unsigned long skey_status;
 	u8 swsusp_key[SWSUSP_DIGEST_SIZE];
 };
+#else
+static inline void parse_swsusp_keys(u64 phys_addr, u32 data_len) {}
 #endif
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 80f874b..5412be0 100644
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
+		case SETUP_SWSUSP_KEYS:
+			parse_swsusp_keys(pa_data, data_len);
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
index 0000000..4a68b86
--- /dev/null
+++ b/arch/x86/power/hibernate_keys.c
@@ -0,0 +1,79 @@
+/* Swsusp keys handler
+ *
+ * Copyright (C) 2015 SUSE Linux Products GmbH. All rights reserved.
+ * Written by Chun-Yi Lee (jlee-IBi9RG/b67k@public.gmane.org)
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
+/* physical address of swsusp keys from boot params */
+static u64 keys_phys_addr;
+
+/* A page used to keep swsusp keys */
+static struct swsusp_keys *swsusp_keys;
+
+void __init parse_swsusp_keys(u64 phys_addr, u32 data_len)
+{
+	struct setup_data *swsusp_setup_data;
+
+	/* Reserve keys memory, will copy and earse in init_hibernate_keys() */
+	keys_phys_addr = phys_addr + sizeof(struct setup_data);
+	memblock_reserve(keys_phys_addr, sizeof(struct swsusp_keys));
+
+	/* clear setup_data */
+	swsusp_setup_data = early_memremap(phys_addr, data_len);
+	if (!swsusp_setup_data)
+		return;
+
+	memset(swsusp_setup_data, 0, sizeof(struct setup_data));
+	early_memunmap(swsusp_setup_data, data_len);
+}
+
+int get_swsusp_key(u8 **skey)
+{
+	if (!swsusp_keys)
+		return -ENODEV;
+
+	if (!swsusp_keys->skey_status)
+		*skey = swsusp_keys->swsusp_key;
+
+	return swsusp_keys->skey_status;
+}
+
+static int __init init_hibernate_keys(void)
+{
+	struct swsusp_keys *keys;
+	int ret = 0;
+
+	if (!keys_phys_addr)
+		return -ENODEV;
+
+	keys = early_memremap(keys_phys_addr, sizeof(struct swsusp_keys));
+
+	/* Copy swsusp keys to a allocated page */
+	swsusp_keys = (struct swsusp_keys *)get_zeroed_page(GFP_KERNEL);
+	if (swsusp_keys) {
+		*swsusp_keys = *keys;
+	} else {
+		pr_err("PM: Allocate swsusp keys page failed\n");
+		ret = -ENOMEM;
+	}
+
+	/* Earse keys data no matter copy success or failed */
+	memset(keys, 0, sizeof(struct swsusp_keys));
+	early_memunmap(keys, sizeof(struct swsusp_keys));
+	memblock_free(keys_phys_addr, sizeof(struct swsusp_keys));
+	keys_phys_addr = 0;
+
+	return ret;
+}
+
+late_initcall(init_hibernate_keys);
diff --git a/kernel/power/power.h b/kernel/power/power.h
index f65fcf7..b8020e9 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -16,6 +16,11 @@ struct swsusp_info {
 } __aligned(PAGE_SIZE);
 
 #ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+/* arch/x86/power/hibernate_keys.c */
+extern int get_swsusp_key(u8 **skey);
+#endif
+
 /* kernel/power/snapshot.c */
 extern void __init hibernate_reserved_size_init(void);
 extern void __init hibernate_image_size_init(void);
-- 
1.8.4.5
