From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 3/3] efi: replace runtime services spinlock with semaphore
Date: Mon, 11 Jul 2016 16:59:25 +0200
Message-ID: <1468249165-25523-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1468249165-25523-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468249165-25523-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The purpose of the efi_runtime_lock is to prevent concurrent calls into
the firmware. There is no need to use spinlocks here, as long as we ensure
that runtime service invocations from an atomic context (i.e., EFI pstore)
cannot block.

So use a semaphore instead, and use down_trylock() in the nonblocking case.
We don't use a mutex here because the mutex_trylock() function must not
be called from interrupt context, whereas the down_trylock() can.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
--
v2: rebased onto v4.7-rc3
    handle EFI_ABORT in efi_status_to_err()
---
 drivers/firmware/efi/efi.c              |  3 +
 drivers/firmware/efi/runtime-wrappers.c | 81 ++++++++++++--------
 include/linux/efi.h                     |  1 +
 3 files changed, 53 insertions(+), 32 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index ccd0095b91a1..d8fa0487f39a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -665,6 +665,9 @@ int efi_status_to_err(efi_status_t status)
 	case EFI_NOT_FOUND:
 		err = -ENOENT;
 		break;
+	case EFI_ABORTED:
+		err = -EINTR;
+		break;
 	default:
 		err = -EINVAL;
 	}
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 6a364f525a4f..35a3a5b2e99a 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -14,11 +14,13 @@
  * This file is released under the GPLv2.
  */
 
+#define pr_fmt(fmt)	"efi: " fmt
+
 #include <linux/bug.h>
 #include <linux/efi.h>
 #include <linux/irqflags.h>
 #include <linux/mutex.h>
-#include <linux/spinlock.h>
+#include <linux/semaphore.h>
 #include <linux/stringify.h>
 #include <asm/efi.h>
 
@@ -81,20 +83,21 @@ void efi_call_virt_check_flags(unsigned long flags, const char *call)
  * +------------------------------------+-------------------------------+
  *
  * Due to the fact that the EFI pstore may write to the variable store in
- * interrupt context, we need to use a spinlock for at least the groups that
+ * interrupt context, we need to use a lock for at least the groups that
  * contain SetVariable() and QueryVariableInfo(). That leaves little else, as
  * none of the remaining functions are actually ever called at runtime.
- * So let's just use a single spinlock to serialize all Runtime Services calls.
+ * So let's just use a single lock to serialize all Runtime Services calls.
  */
-static DEFINE_SPINLOCK(efi_runtime_lock);
+static DEFINE_SEMAPHORE(efi_runtime_lock);
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(get_time, tm, tc);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -102,9 +105,10 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(set_time, tm);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -114,9 +118,10 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -124,9 +129,10 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(set_wakeup_time, enabled, tm);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -138,10 +144,11 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
 			       data);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -151,9 +158,10 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(get_next_variable, name_size, name, vendor);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -165,10 +173,11 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
 			       data);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -179,12 +188,12 @@ virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
 {
 	efi_status_t status;
 
-	if (!spin_trylock(&efi_runtime_lock))
+	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
 	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
 			       data);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -199,10 +208,11 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(query_variable_info, attr, storage_space,
 			       remaining_space, max_variable_size);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -217,12 +227,12 @@ virt_efi_query_variable_info_nonblocking(u32 attr,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	if (!spin_trylock(&efi_runtime_lock))
+	if (down_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
 	status = efi_call_virt(query_variable_info, attr, storage_space,
 			       remaining_space, max_variable_size);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -230,9 +240,10 @@ static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
 	efi_status_t status;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(get_next_high_mono_count, count);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -241,9 +252,13 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock)) {
+		pr_warn("failed to invoke the reset_system() runtime service:\n"
+			"could not get exclusive access to the firmware\n");
+		return;
+	}
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
@@ -255,9 +270,10 @@ static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(update_capsule, capsules, count, sg_list);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
@@ -271,10 +287,11 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	spin_lock(&efi_runtime_lock);
+	if (down_interruptible(&efi_runtime_lock))
+		return EFI_ABORTED;
 	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
 			       reset_type);
-	spin_unlock(&efi_runtime_lock);
+	up(&efi_runtime_lock);
 	return status;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a618bbf00c72..5b2ed8b4e76c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -38,6 +38,7 @@
 #define EFI_WRITE_PROTECTED	( 8 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_OUT_OF_RESOURCES	( 9 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_NOT_FOUND		(14 | (1UL << (BITS_PER_LONG-1)))
+#define EFI_ABORTED		(21 | (1UL << (BITS_PER_LONG-1)))
 #define EFI_SECURITY_VIOLATION	(26 | (1UL << (BITS_PER_LONG-1)))
 
 typedef unsigned long efi_status_t;
-- 
1.9.1
