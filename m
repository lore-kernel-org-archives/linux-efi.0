From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 02/14] efi: Remove redundant efi_set_variable_nonblocking prototype
Date: Mon,  1 Feb 2016 22:06:56 +0000
Message-ID: <1454364428-494-3-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

There is no need for a separate nonblocking prototype definition
for the SetVariable() UEFI Runtime Service, since it is identical
to the blocking version.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 include/linux/efi.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a866bb1..8706e0aabedc 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -507,10 +507,6 @@ typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char
 typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
 					 u32 attr, unsigned long data_size,
 					 void *data);
-typedef efi_status_t
-efi_set_variable_nonblocking_t(efi_char16_t *name, efi_guid_t *vendor,
-			       u32 attr, unsigned long data_size, void *data);
-
 typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
 				 unsigned long data_size, efi_char16_t *data);
@@ -851,7 +847,7 @@ extern struct efi {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_set_variable_nonblocking_t *set_variable_nonblocking;
+	efi_set_variable_t *set_variable_nonblocking;
 	efi_query_variable_info_t *query_variable_info;
 	efi_update_capsule_t *update_capsule;
 	efi_query_capsule_caps_t *query_capsule_caps;
@@ -1091,7 +1087,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
-	efi_set_variable_nonblocking_t *set_variable_nonblocking;
+	efi_set_variable_t *set_variable_nonblocking;
 	efi_query_variable_store_t *query_variable_store;
 };
 
-- 
2.6.2
