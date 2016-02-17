From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 02/13] efi/runtime-wrappers: Run UEFI Runtime Services with interrupts enabled
Date: Wed, 17 Feb 2016 12:35:55 +0000
Message-ID: <1455712566-16727-3-git-send-email-matt@codeblueprint.co.uk>
References: <1455712566-16727-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455712566-16727-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

The UEFI spec allows Runtime Services to be invoked with interrupts
enabled. The only reason we were disabling interrupts was to prevent
recursive calls into the services on the same CPU, which will lead to
deadlock. However, the only context where such invocations may occur
legally is from efi-pstore via efivars, and that code has been updated
to call a non-blocking alternative when invoked from a non-interruptible
context.

So instead, update the ordinary, blocking UEFI Runtime Services wrappers
to execute with interrupts enabled. This aims to prevent excessive interrupt
latencies on uniprocessor platforms with slow variable stores.

Note that other OSes such as Windows call UEFI Runtime Services with
interrupts enabled as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 71 +++++++++++++--------------------
 1 file changed, 28 insertions(+), 43 deletions(-)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 7b8b2f2702ca..de6953039af6 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -63,23 +63,21 @@ static DEFINE_SPINLOCK(efi_runtime_lock);
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_time, tm, tc);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
 static efi_status_t virt_efi_set_time(efi_time_t *tm)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_time, tm);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -87,23 +85,21 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 					     efi_bool_t *pending,
 					     efi_time_t *tm)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
 static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_wakeup_time, enabled, tm);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -113,13 +109,12 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
 			       data);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -127,12 +122,11 @@ static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_next_variable, name_size, name, vendor);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -142,13 +136,12 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
 			       data);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -157,15 +150,14 @@ virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
 				  u32 attr, unsigned long data_size,
 				  void *data)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
+	if (!spin_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
 	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
 			       data);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -175,16 +167,15 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 						 u64 *remaining_space,
 						 u64 *max_variable_size)
 {
-	unsigned long flags;
 	efi_status_t status;
 
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(query_variable_info, attr, storage_space,
 			       remaining_space, max_variable_size);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -194,29 +185,27 @@ virt_efi_query_variable_info_nonblocking(u32 attr,
 					 u64 *remaining_space,
 					 u64 *max_variable_size)
 {
-	unsigned long flags;
 	efi_status_t status;
 
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
+	if (!spin_trylock(&efi_runtime_lock))
 		return EFI_NOT_READY;
 
 	status = efi_call_virt(query_variable_info, attr, storage_space,
 			       remaining_space, max_variable_size);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	unsigned long flags;
 	efi_status_t status;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_next_high_mono_count, count);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -225,26 +214,23 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 					    unsigned long count,
 					    unsigned long sg_list)
 {
-	unsigned long flags;
 	efi_status_t status;
 
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(update_capsule, capsules, count, sg_list);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
@@ -253,16 +239,15 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 						u64 *max_size,
 						int *reset_type)
 {
-	unsigned long flags;
 	efi_status_t status;
 
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
 			       reset_type);
-	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock(&efi_runtime_lock);
 	return status;
 }
 
-- 
2.6.2
