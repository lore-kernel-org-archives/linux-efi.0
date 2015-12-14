From: ard <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 3/7] efi: runtime-wrappers: add a nonblocking version of QueryVariableInfo
Date: Mon, 14 Dec 2015 11:40:27 +0100
Message-ID: <1450089631-26791-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1450089631-26791-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450089631-26791-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

This introduces a new runtime wrapper for the QueryVariableInfo() UEFI
Runtime Service, which gives up immediately rather than spins on failure
to grab the efi_runtime spinlock.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/runtime-wrappers.c | 22 ++++++++++++++++++++
 include/linux/efi.h                     |  1 +
 2 files changed, 23 insertions(+)

diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 228bbf910461..e9f2867f0d91 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -230,6 +230,27 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 	return status;
 }
 
+static efi_status_t
+virt_efi_query_variable_info_nonblocking(u32 attr,
+					 u64 *storage_space,
+					 u64 *remaining_space,
+					 u64 *max_variable_size)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
+		return EFI_NOT_READY;
+
+	status = efi_call_virt(query_variable_info, attr, storage_space,
+			       remaining_space, max_variable_size);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
+}
+
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
 	unsigned long flags;
@@ -300,6 +321,7 @@ void efi_native_runtime_setup(void)
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.query_variable_info_nonblocking = virt_efi_query_variable_info_nonblocking;
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8706e0aabedc..ad1e177ba48e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -849,6 +849,7 @@ extern struct efi {
 	efi_set_variable_t *set_variable;
 	efi_set_variable_t *set_variable_nonblocking;
 	efi_query_variable_info_t *query_variable_info;
+	efi_query_variable_info_t *query_variable_info_nonblocking;
 	efi_update_capsule_t *update_capsule;
 	efi_query_capsule_caps_t *query_capsule_caps;
 	efi_get_next_high_mono_count_t *get_next_high_mono_count;
-- 
2.5.0
