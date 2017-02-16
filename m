From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: bgrt: add missing 'return 0' to acpi_parse_bgrt() non-ACPI stub
Date: Thu, 16 Feb 2017 17:38:17 +0000
Message-ID: <1487266697-1551-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The prototype of acpi_parse_bgrt() is to return an int, so this applies
equally to the stub that is emitted when CONFIG_ACPI is not set. So add
the missing return statement there.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/efi-bgrt.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
index 33640cd0e440..e6f624b53c3d 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -15,7 +15,10 @@ extern struct acpi_table_bgrt bgrt_tab;
 #else /* !CONFIG_ACPI_BGRT */
 
 static inline void efi_bgrt_init(struct acpi_table_header *table) {}
-static inline int __init acpi_parse_bgrt(struct acpi_table_header *table) {}
+static inline int __init acpi_parse_bgrt(struct acpi_table_header *table)
+{
+	return 0;
+}
 
 #endif /* !CONFIG_ACPI_BGRT */
 
-- 
2.7.4
