From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 01/14] efi: Move efi_status_to_err() to drivers/firmware/efi/
Date: Wed, 30 Aug 2017 21:13:43 +0200
Message-ID: <da99d306c14f65a0092415fc581b57b2446c642c.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>

commit 806b0351c9ff9890c1ef0ba2c46237baef49ac79 upstream.

Move efi_status_to_err() to the architecture independent code as it's
generally useful in all bits of EFI code where there is a need to
convert an efi_status_t to a kernel error value.

Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1461614832-17633-27-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c  | 33 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/vars.c | 33 ---------------------------------
 include/linux/efi.h         |  2 ++
 3 files changed, 35 insertions(+), 33 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3b52677f459a..33d60992a580 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -663,3 +663,36 @@ u64 __weak efi_mem_attributes(unsigned long phys_addr)
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
index 6f182fd91a6d..38e36526ba02 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -318,39 +318,6 @@ check_var_size(u32 attributes, unsigned long size)
 	return fops->query_variable_store(attributes, size);
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
index 47be3ad7d3e5..774e9a0d49f1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -999,6 +999,8 @@ static inline void
 efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
 #endif
 
+extern int efi_status_to_err(efi_status_t status);
+
 /*
  * Variable Attributes
  */
-- 
2.12.3
