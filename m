From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/2] efi/x86: move UEFI Runtime Services wrappers to generic code
Date: Fri,  4 Jul 2014 19:41:52 +0200
Message-ID: <1404495713-10338-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1404495713-10338-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404495713-10338-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In order for other archs (such as arm64) to be able to reuse the virtual mode
function call wrappers, move them to drivers/firmware/efi/runtime.c.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/Kconfig                        |   1 +
 arch/x86/platform/efi/efi.c             | 144 +---------------------------
 drivers/firmware/efi/Kconfig            |   7 ++
 drivers/firmware/efi/Makefile           |   1 +
 drivers/firmware/efi/runtime-wrappers.c | 161 ++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |   2 +
 6 files changed, 174 insertions(+), 142 deletions(-)
 create mode 100644 drivers/firmware/efi/runtime-wrappers.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index a8f749ef0fdc..4c3f026aa5ce 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1522,6 +1522,7 @@ config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
 	select UCS2_STRING
+	select EFI_RUNTIME_WRAPPERS
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 87fc96bcc13c..36d0835210c3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -104,130 +104,6 @@ static int __init setup_storage_paranoia(char *arg)
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 
-static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(get_time, tm, tc);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_set_time(efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(set_time, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
-					     efi_bool_t *pending,
-					     efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	status = efi_call_virt(set_wakeup_time, enabled, tm);
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
-static efi_status_t virt_efi_get_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
-					  u32 *attr,
-					  unsigned long *data_size,
-					  void *data)
-{
-	return efi_call_virt(get_variable,
-			     name, vendor, attr,
-			     data_size, data);
-}
-
-static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
-					       efi_char16_t *name,
-					       efi_guid_t *vendor)
-{
-	return efi_call_virt(get_next_variable,
-			     name_size, name, vendor);
-}
-
-static efi_status_t virt_efi_set_variable(efi_char16_t *name,
-					  efi_guid_t *vendor,
-					  u32 attr,
-					  unsigned long data_size,
-					  void *data)
-{
-	return efi_call_virt(set_variable,
-			     name, vendor, attr,
-			     data_size, data);
-}
-
-static efi_status_t virt_efi_query_variable_info(u32 attr,
-						 u64 *storage_space,
-						 u64 *remaining_space,
-						 u64 *max_variable_size)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt(query_variable_info, attr, storage_space,
-			     remaining_space, max_variable_size);
-}
-
-static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
-{
-	return efi_call_virt(get_next_high_mono_count, count);
-}
-
-static void virt_efi_reset_system(int reset_type,
-				  efi_status_t status,
-				  unsigned long data_size,
-				  efi_char16_t *data)
-{
-	__efi_call_virt(reset_system, reset_type, status,
-			data_size, data);
-}
-
-static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
-					    unsigned long count,
-					    unsigned long sg_list)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt(update_capsule, capsules, count, sg_list);
-}
-
-static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
-						unsigned long count,
-						u64 *max_size,
-						int *reset_type)
-{
-	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
-		return EFI_UNSUPPORTED;
-
-	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			     reset_type);
-}
-
 static efi_status_t __init phys_efi_set_virtual_address_map(
 	unsigned long memory_map_size,
 	unsigned long descriptor_size,
@@ -847,22 +723,6 @@ void __init old_map_region(efi_memory_desc_t *md)
 		       (unsigned long long)md->phys_addr);
 }
 
-static void native_runtime_setup(void)
-{
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
-	efi.get_variable = virt_efi_get_variable;
-	efi.get_next_variable = virt_efi_get_next_variable;
-	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
-	efi.reset_system = virt_efi_reset_system;
-	efi.query_variable_info = virt_efi_query_variable_info;
-	efi.update_capsule = virt_efi_update_capsule;
-	efi.query_capsule_caps = virt_efi_query_capsule_caps;
-}
-
 /* Merge contiguous regions of the same type and attribute */
 static void __init efi_merge_regions(void)
 {
@@ -1049,7 +909,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 */
 	efi.runtime_version = efi_systab.hdr.revision;
 
-	native_runtime_setup();
+	efi_native_runtime_setup();
 
 	efi.set_virtual_address_map = NULL;
 
@@ -1142,7 +1002,7 @@ static void __init __efi_enter_virtual_mode(void)
 	efi.runtime_version = efi_systab.hdr.revision;
 
 	if (efi_is_native())
-		native_runtime_setup();
+		efi_native_runtime_setup();
 	else
 		efi_thunk_runtime_setup();
 
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index d420ae2d3413..04a7af46736a 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -54,6 +54,13 @@ config EFI_PARAMS_FROM_FDT
 	  the EFI runtime support gets system table address, memory
           map address, and other parameters from the device tree.
 
+config EFI_RUNTIME_WRAPPERS
+	bool
+	help
+	  Selected by the arch if it needs to wrap UEFI Runtime Services calls,
+	  in which case it needs to provide #definitions of efi_call_virt and
+	  __efi_call_virt in <asm/efi.h>
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 9553496b0f43..e1096539eedb 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -6,3 +6,4 @@ obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
+obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
new file mode 100644
index 000000000000..10daa4bbb258
--- /dev/null
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -0,0 +1,161 @@
+/*
+ * runtime-wrappers.c - Runtime Services function call wrappers
+ *
+ * Copyright (C) 2014 Linaro Ltd. <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * Split off from arch/x86/platform/efi/efi.c
+ *
+ * Copyright (C) 1999 VA Linux Systems
+ * Copyright (C) 1999 Walt Drummond <drummond-jCdQPDEk3idBDgjK7y7TUQ@public.gmane.org>
+ * Copyright (C) 1999-2002 Hewlett-Packard Co.
+ * Copyright (C) 2005-2008 Intel Co.
+ * Copyright (C) 2013 SuSE Labs
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/efi.h>
+#include <linux/spinlock.h>             /* spinlock_t */
+#include <asm/efi.h>
+
+/*
+ * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
+ * the EFI specification requires that callers of the time related runtime
+ * functions serialize with other CMOS accesses in the kernel, as the EFI time
+ * functions may choose to also use the legacy CMOS RTC.
+ */
+__weak DEFINE_SPINLOCK(rtc_lock);
+
+static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(get_time, tm, tc);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_set_time(efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(set_time, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
+					     efi_bool_t *pending,
+					     efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&rtc_lock, flags);
+	status = efi_call_virt(set_wakeup_time, enabled, tm);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	return status;
+}
+
+static efi_status_t virt_efi_get_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 *attr,
+					  unsigned long *data_size,
+					  void *data)
+{
+	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
+					       efi_char16_t *name,
+					       efi_guid_t *vendor)
+{
+	return efi_call_virt(get_next_variable, name_size, name, vendor);
+}
+
+static efi_status_t virt_efi_set_variable(efi_char16_t *name,
+					  efi_guid_t *vendor,
+					  u32 attr,
+					  unsigned long data_size,
+					  void *data)
+{
+	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+}
+
+static efi_status_t virt_efi_query_variable_info(u32 attr,
+						 u64 *storage_space,
+						 u64 *remaining_space,
+						 u64 *max_variable_size)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt(query_variable_info, attr, storage_space,
+			     remaining_space, max_variable_size);
+}
+
+static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
+{
+	return efi_call_virt(get_next_high_mono_count, count);
+}
+
+static void virt_efi_reset_system(int reset_type,
+				  efi_status_t status,
+				  unsigned long data_size,
+				  efi_char16_t *data)
+{
+	__efi_call_virt(reset_system, reset_type, status, data_size, data);
+}
+
+static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
+					    unsigned long count,
+					    unsigned long sg_list)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt(update_capsule, capsules, count, sg_list);
+}
+
+static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
+						unsigned long count,
+						u64 *max_size,
+						int *reset_type)
+{
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			     reset_type);
+}
+
+void efi_native_runtime_setup(void)
+{
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8ba4ba8..0ceb816bdfc2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -521,6 +521,8 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      int *reset_type);
 typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
 
+void efi_native_runtime_setup(void);
+
 /*
  *  EFI Configuration Table and GUID definitions
  */
-- 
1.8.3.2
