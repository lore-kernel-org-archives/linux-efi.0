From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 2/7] efi: Move utf16_strlen() to efi.h
Date: Fri,  8 Feb 2013 20:59:13 +0000
Message-ID: <1360357158-8168-3-git-send-email-matt@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357158-8168-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

There are two places where utf16_strlen() is used - we only need one
implementation.

Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efivars.c     | 17 -----------------
 drivers/firmware/google/gsmi.c | 19 ++++---------------
 include/linux/efi.h            | 17 +++++++++++++++++
 3 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 24585c3..029a5fe 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -162,23 +162,6 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 			  efi_char16_t *variable_name,
 			  efi_guid_t *vendor_guid);
 
-/* Return the number of unicode characters in data */
-static unsigned long
-utf16_strnlen(efi_char16_t *s, size_t maxlength)
-{
-	unsigned long length = 0;
-
-	while (*s++ != 0 && length < maxlength)
-		length++;
-	return length;
-}
-
-static inline unsigned long
-utf16_strlen(efi_char16_t *s)
-{
-	return utf16_strnlen(s, ~0UL);
-}
-
 /*
  * Return the number of bytes is the length of this string
  * Note: this is NOT the same as the number of unicode characters
diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 91ddf0f..c409a75 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -288,17 +288,6 @@ static int gsmi_exec(u8 func, u8 sub)
 	return rc;
 }
 
-/* Return the number of unicode characters in data */
-static size_t
-utf16_strlen(efi_char16_t *data, unsigned long maxlength)
-{
-	unsigned long length = 0;
-
-	while (*data++ != 0 && length < maxlength)
-		length++;
-	return length;
-}
-
 static efi_status_t gsmi_get_variable(efi_char16_t *name,
 				      efi_guid_t *vendor, u32 *attr,
 				      unsigned long *data_size,
@@ -311,7 +300,7 @@ static efi_status_t gsmi_get_variable(efi_char16_t *name,
 	};
 	efi_status_t ret = EFI_SUCCESS;
 	unsigned long flags;
-	size_t name_len = utf16_strlen(name, GSMI_BUF_SIZE / 2);
+	size_t name_len = utf16_strnlen(name, GSMI_BUF_SIZE / 2);
 	int rc;
 
 	if (name_len >= GSMI_BUF_SIZE / 2)
@@ -380,7 +369,7 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
 		return EFI_BAD_BUFFER_SIZE;
 
 	/* Let's make sure the thing is at least null-terminated */
-	if (utf16_strlen(name, GSMI_BUF_SIZE / 2) == GSMI_BUF_SIZE / 2)
+	if (utf16_strnlen(name, GSMI_BUF_SIZE / 2) == GSMI_BUF_SIZE / 2)
 		return EFI_INVALID_PARAMETER;
 
 	spin_lock_irqsave(&gsmi_dev.lock, flags);
@@ -408,7 +397,7 @@ static efi_status_t gsmi_get_next_variable(unsigned long *name_size,
 
 		/* Copy the name back */
 		memcpy(name, gsmi_dev.name_buf->start, GSMI_BUF_SIZE);
-		*name_size = utf16_strlen(name, GSMI_BUF_SIZE / 2) * 2;
+		*name_size = utf16_strnlen(name, GSMI_BUF_SIZE / 2) * 2;
 
 		/* copy guid to return buffer */
 		memcpy(vendor, &param.guid, sizeof(param.guid));
@@ -434,7 +423,7 @@ static efi_status_t gsmi_set_variable(efi_char16_t *name,
 			      EFI_VARIABLE_BOOTSERVICE_ACCESS |
 			      EFI_VARIABLE_RUNTIME_ACCESS,
 	};
-	size_t name_len = utf16_strlen(name, GSMI_BUF_SIZE / 2);
+	size_t name_len = utf16_strnlen(name, GSMI_BUF_SIZE / 2);
 	efi_status_t ret = EFI_SUCCESS;
 	int rc;
 	unsigned long flags;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7a9498a..231d046 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -719,6 +719,23 @@ static inline void memrange_efi_to_native(u64 *addr, u64 *npages)
 	*addr &= PAGE_MASK;
 }
 
+/* Return the number of unicode characters in data */
+static inline unsigned long
+utf16_strnlen(efi_char16_t *s, size_t maxlength)
+{
+	unsigned long length = 0;
+
+	while (*s++ != 0 && length < maxlength)
+		length++;
+	return length;
+}
+
+static inline unsigned long
+utf16_strlen(efi_char16_t *s)
+{
+	return utf16_strnlen(s, ~0UL);
+}
+
 #if defined(CONFIG_EFI_VARS) || defined(CONFIG_EFI_VARS_MODULE)
 /*
  * EFI Variable support.
-- 
1.7.11.7
