From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi: runtime-wrappers: run UEFI Runtime Services with interrupts enabled
Date: Thu,  4 Feb 2016 14:58:47 +0100
Message-ID: <1454594327-5444-1-git-send-email-ard.biesheuvel@linaro.org>
References: <20160203105851.GA22159@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160203105851.GA22159@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mingo@kernel.org, matt@codeblueprint.co.uk, linux-efi@vger.kernel.org, sai.praneeth.prakhya@intel.com
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, luto@kernel.org, a.p.zijlstra@chello.nl, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

OK, since Sai has confirmed that Windows leaves interrupts enabled when
calling the EFI variable store related runtime services, we should be able
to do the same for Linux, or at least be slightly more confident that we
won't have to back out this change later.

@Sai: could you please confirm on-list as well? Thanks.

Below is an updated version of the patch, rebased onto current tip/efi/core,
with the BUG_ON() removed that I left in inadvertently. I also added a mention
in the commit log that Windows leaves interrupts enabled as well. As far as
annotating the definition of efi_runtime_lock is concerned, the existing ~40
lines of documentation should be sufficient imo so I left that as is. Thanks.

--------8<----------------
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 71 ++++++++------------
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
2.5.0
