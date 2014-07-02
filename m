From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] efi: implement mandatory locking for UEFI Runtime Services
Date: Wed,  2 Jul 2014 12:10:02 +0200
Message-ID: <1404295802-28030-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1404295802-28030-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404295802-28030-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

According to section 7.1 of the UEFI spec, Runtime Services are not fully
reentrant, and there are particular combinations of calls that need to be
serialized.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 109 +++++++++++++++++++++++++++++---
 1 file changed, 99 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 10daa4bbb258..6588d054af99 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -15,10 +15,50 @@
  */
 
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
+ * The first two are disregarded here, as SetVirtualAddressMap() is called
+ * only once, and very early, and ConvertPointer() is not exposed at all.
+ */
+static DEFINE_MUTEX(var_ro_mutex);
+static DEFINE_MUTEX(var_rw_mutex);
+
+/*
  * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
  * the EFI specification requires that callers of the time related runtime
  * functions serialize with other CMOS accesses in the kernel, as the EFI time
@@ -78,14 +118,25 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+	efi_status_t status;
+
+	mutex_lock(&var_ro_mutex);
+	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
+			       data);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt(get_next_variable, name_size, name, vendor);
+	efi_status_t status;
+
+	mutex_lock(&var_ro_mutex);
+	status = efi_call_virt(get_next_variable, name_size, name, vendor);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -94,7 +145,15 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+	efi_status_t status;
+
+	mutex_lock(&var_ro_mutex);
+	mutex_lock(&var_rw_mutex);
+	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
+			       data);
+	mutex_unlock(&var_rw_mutex);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 static efi_status_t virt_efi_query_variable_info(u32 attr,
@@ -102,16 +161,28 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 						 u64 *remaining_space,
 						 u64 *max_variable_size)
 {
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(query_variable_info, attr, storage_space,
-			     remaining_space, max_variable_size);
+	mutex_lock(&var_ro_mutex);
+	status = efi_call_virt(query_variable_info, attr, storage_space,
+			       remaining_space, max_variable_size);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	return efi_call_virt(get_next_high_mono_count, count);
+	efi_status_t status;
+
+	mutex_lock(&var_ro_mutex);
+	mutex_lock(&var_rw_mutex);
+	status = efi_call_virt(get_next_high_mono_count, count);
+	mutex_unlock(&var_rw_mutex);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 static void virt_efi_reset_system(int reset_type,
@@ -119,17 +190,30 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
+	unsigned long flags;
+
+	mutex_lock(&var_rw_mutex);
+	spin_lock_irqsave(&rtc_lock, flags);
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
+	spin_unlock_irqrestore(&rtc_lock, flags);
+	mutex_unlock(&var_rw_mutex);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 					    unsigned long count,
 					    unsigned long sg_list)
 {
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(update_capsule, capsules, count, sg_list);
+	mutex_lock(&var_ro_mutex);
+	mutex_lock(&var_rw_mutex);
+	status = efi_call_virt(update_capsule, capsules, count, sg_list);
+	mutex_unlock(&var_rw_mutex);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
@@ -137,11 +221,16 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 						u64 *max_size,
 						int *reset_type)
 {
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			     reset_type);
+	mutex_lock(&var_ro_mutex);
+	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			       reset_type);
+	mutex_unlock(&var_ro_mutex);
+	return status;
 }
 
 void efi_native_runtime_setup(void)
-- 
1.8.3.2
