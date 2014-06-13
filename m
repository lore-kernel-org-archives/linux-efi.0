From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: fix pointer type errors in fdt_uefi_find_params()
Date: Fri, 13 Jun 2014 16:54:59 +0200
Message-ID: <1402671299-22493-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Fix two instances of pointer type errors, a harmless one where a const void*
value is assigned to a non-const void* variable, and a not-so-harmless one where
we pass a pointer to unsigned long where a pointer to int is expected.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd36deb619fa..fe737832a882 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -353,8 +353,8 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 				       int depth, void *data)
 {
 	struct param_info *info = data;
-	void *prop, *dest;
-	unsigned long len;
+	void const *prop, *dest;
+	int len;
 	u64 val;
 	int i;
 
-- 
1.8.3.2
