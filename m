From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/4] efi: Move efi_status_to_err() to drivers/firmware/efi/
Date: Thu, 17 Mar 2016 12:57:08 +0000
Message-ID: <1458219431-24741-2-git-send-email-matt@codeblueprint.co.uk>
References: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: joeyli <jlee@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

Move efi_status_to_err() to the architecture independent code as it's
generally useful in all bits of EFI code where there is a need to
convert an efi_status_t to a kernel error value.

Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi.c  | 33 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/vars.c | 33 ---------------------------------
 include/linux/efi.h         |  2 ++
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3a69ed5ecfcb..b73222a52a9d 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -637,3 +637,36 @@ u64 __weak efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
+
+int efi_status_to_err(efi_status_t status)
+{
+	int err;
+
+	switch (status) {
+	case EFI_SUCCESS:
+		err = 0;
+		break;
+	case EFI_INVALID_PARAMETER:
+		err = -EINVAL;
+		break;
+	case EFI_OUT_OF_RESOURCES:
+		err = -ENOSPC;
+		break;
+	case EFI_DEVICE_ERROR:
+		err = -EIO;
+		break;
+	case EFI_WRITE_PROTECTED:
+		err = -EROFS;
+		break;
+	case EFI_SECURITY_VIOLATION:
+		err = -EACCES;
+		break;
+	case EFI_NOT_FOUND:
+		err = -ENOENT;
+		break;
+	default:
+		err = -EINVAL;
+	}
+
+	return err;
+}
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 0ac594c0a234..4911d5697844 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -314,39 +314,6 @@ check_var_size_nonblocking(u32 attributes, unsigned long size)
 	return fops->query_variable_store(attributes, size, true);
 }
 
-static int efi_status_to_err(efi_status_t status)
-{
-	int err;
-
-	switch (status) {
-	case EFI_SUCCESS:
-		err = 0;
-		break;
-	case EFI_INVALID_PARAMETER:
-		err = -EINVAL;
-		break;
-	case EFI_OUT_OF_RESOURCES:
-		err = -ENOSPC;
-		break;
-	case EFI_DEVICE_ERROR:
-		err = -EIO;
-		break;
-	case EFI_WRITE_PROTECTED:
-		err = -EROFS;
-		break;
-	case EFI_SECURITY_VIOLATION:
-		err = -EACCES;
-		break;
-	case EFI_NOT_FOUND:
-		err = -ENOENT;
-		break;
-	default:
-		err = -EINVAL;
-	}
-
-	return err;
-}
-
 static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor,
 				struct list_head *head)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c55c452b991a..9c8aae0e3b51 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1023,6 +1023,8 @@ static inline void
 efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
 #endif
 
+extern int efi_status_to_err(efi_status_t status);
+
 /*
  * Variable Attributes
  */
-- 
2.6.2
