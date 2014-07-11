From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3] efi: implement mandatory locking for UEFI Runtime Services
Date: Fri, 11 Jul 2014 09:09:16 +0200
Message-ID: <1405062556-14540-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

According to section 7.1 of the UEFI spec, Runtime Services are not fully
reentrant, and there are particular combinations of calls that need to be
serialized. Use a spinlock to serialize all Runtime Services with respect
to all others, even if this is more than strictly needed.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
v3:
Keep value of in_nmi() cached in local scope to help the compiler understand
that it cannot change while the function is active

v2:
So this is v2 of the UEFI Runtime Services serialization patch: this time, I use
a single spinlock rather than a set of mutexes, resulting in all services to be
serialized with respect to all others. Also added handling of NMI state, as this
results in some of the restrictions being lifted (x86, ia64 only)

 arch/x86/include/asm/efi.h              |   2 +
 drivers/firmware/efi/runtime-wrappers.c | 175 +++++++++++++++++++++++++++++---
 2 files changed, 165 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 1eb5f6433ad8..35f67a253e33 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -86,6 +86,8 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 
 #endif /* CONFIG_X86_32 */
 
+#define efi_in_nmi()	in_nmi()
+
 extern int add_efi_memmap;
 extern struct efi_scratch efi_scratch;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 10daa4bbb258..55ac6d7eac1b 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -14,11 +14,76 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/bug.h>
 #include <linux/efi.h>
-#include <linux/spinlock.h>             /* spinlock_t */
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <asm/efi.h>
 
 /*
+ * According to section 7.1 of the UEFI spec, Runtime Services are not fully
+ * reentrant, and there are particular combinations of calls that need to be
+ * serialized.
+ *
+ * Table 31. Rules for Reentry Into Runtime Services
+ * +------------------------------------+-------------------------------+
+ * | If previous call is busy in	| Forbidden to call		|
+ * +------------------------------------+-------------------------------+
+ * | Any				| SetVirtualAddressMap()	|
+ * +------------------------------------+-------------------------------+
+ * | ConvertPointer()			| ConvertPointer()		|
+ * +------------------------------------+-------------------------------+
+ * | SetVariable()			| ResetSystem()			|
+ * | UpdateCapsule()			|				|
+ * | SetTime()				|				|
+ * | SetWakeupTime()			|				|
+ * | GetNextHighMonotonicCount()	|				|
+ * +------------------------------------+-------------------------------+
+ * | GetVariable()			| GetVariable()			|
+ * | GetNextVariableName()		| GetNextVariableName()		|
+ * | SetVariable()			| SetVariable()			|
+ * | QueryVariableInfo()		| QueryVariableInfo()		|
+ * | UpdateCapsule()			| UpdateCapsule()		|
+ * | QueryCapsuleCapabilities()		| QueryCapsuleCapabilities()	|
+ * | GetNextHighMonotonicCount()	| GetNextHighMonotonicCount()	|
+ * +------------------------------------+-------------------------------+
+ * | GetTime()				| GetTime()			|
+ * | SetTime()				| SetTime()			|
+ * | GetWakeupTime()			| GetWakeupTime()		|
+ * | SetWakeupTime()			| SetWakeupTime()		|
+ * +------------------------------------+-------------------------------+
+ *
+ * Instead of adding locks for each of the groups, we add a single spinlock
+ * that serializes all runtime services calls with respect to all others.
+ */
+static DEFINE_SPINLOCK(efi_runtime_lock);
+
+/*
+ * Some runtime services calls can be reentrant under NMI, even if the table
+ * above says they are not.
+ *
+ * Table 32. Functions that may be called after Machine Check ,INIT and NMI
+ * +----------------------------+------------------------------------------+
+ * | Function			| Called after Machine Check, INIT and NMI |
+ * +----------------------------+------------------------------------------+
+ * | GetTime()			| Yes, even if previously busy.		   |
+ * | GetVariable()		| Yes, even if previously busy		   |
+ * | GetNextVariableName()	| Yes, even if previously busy		   |
+ * | QueryVariableInfo()	| Yes, even if previously busy		   |
+ * | SetVariable()		| Yes, even if previously busy		   |
+ * | UpdateCapsule()		| Yes, even if previously busy		   |
+ * | QueryCapsuleCapabilities()	| Yes, even if previously busy		   |
+ * | ResetSystem()		| Yes, even if previously busy		   |
+ * +----------------------------+------------------------------------------+
+ *
+ * In order to prevent deadlocks under NMI, the wrappers for these functions
+ * only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
+ */
+#ifndef efi_in_nmi
+#define efi_in_nmi()	(0)
+#endif
+
+/*
  * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
  * the EFI specification requires that callers of the time related runtime
  * functions serialize with other CMOS accesses in the kernel, as the EFI time
@@ -30,10 +95,17 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	unsigned long flags;
 	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
 
-	spin_lock_irqsave(&rtc_lock, flags);
+	if (!__in_nmi) {
+		spin_lock_irqsave(&rtc_lock, flags);
+		spin_lock(&efi_runtime_lock);
+	}
 	status = efi_call_virt(get_time, tm, tc);
-	spin_unlock_irqrestore(&rtc_lock, flags);
+	if (!__in_nmi) {
+		spin_unlock(&efi_runtime_lock);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+	}
 	return status;
 }
 
@@ -42,8 +114,11 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 	unsigned long flags;
 	efi_status_t status;
 
+	BUG_ON(efi_in_nmi());
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_time, tm);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -55,8 +130,11 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 	unsigned long flags;
 	efi_status_t status;
 
+	BUG_ON(efi_in_nmi());
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -66,8 +144,11 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	unsigned long flags;
 	efi_status_t status;
 
+	BUG_ON(efi_in_nmi());
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_wakeup_time, enabled, tm);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -78,14 +159,33 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+	unsigned long flags;
+	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
+
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
+			       data);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt(get_next_variable, name_size, name, vendor);
+	unsigned long flags;
+	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
+
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(get_next_variable, name_size, name, vendor);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -94,7 +194,17 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+	unsigned long flags;
+	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
+
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
+			       data);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -102,16 +212,32 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 						 u64 *remaining_space,
 						 u64 *max_variable_size)
 {
+	unsigned long flags;
+	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(query_variable_info, attr, storage_space,
-			     remaining_space, max_variable_size);
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(query_variable_info, attr, storage_space,
+			       remaining_space, max_variable_size);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	return efi_call_virt(get_next_high_mono_count, count);
+	unsigned long flags;
+	efi_status_t status;
+
+	BUG_ON(efi_in_nmi());
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(get_next_high_mono_count, count);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static void virt_efi_reset_system(int reset_type,
@@ -119,17 +245,33 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
+	unsigned long flags;
+	bool __in_nmi = efi_in_nmi();
+
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 					    unsigned long count,
 					    unsigned long sg_list)
 {
+	unsigned long flags;
+	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(update_capsule, capsules, count, sg_list);
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(update_capsule, capsules, count, sg_list);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
@@ -137,11 +279,20 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 						u64 *max_size,
 						int *reset_type)
 {
+	unsigned long flags;
+	efi_status_t status;
+	bool __in_nmi = efi_in_nmi();
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			     reset_type);
+	if (!__in_nmi)
+		spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			       reset_type);
+	if (!__in_nmi)
+		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 void efi_native_runtime_setup(void)
-- 
1.8.3.2
