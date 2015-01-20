From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: don't look for chosen@0 node on DT platforms
Date: Tue, 20 Jan 2015 16:34:38 +0000
Message-ID: <1421771678-31812-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Due to some scary special case handling noticed in drivers/of, various
bits of the ARM* EFI support patches did duplicate looking for @0
variants of various nodes. Unless on an ancient PPC system, these are
not in fact required. Most instances have become refactored out along
the way, this removes the last one.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b..9fd923a 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -403,8 +403,7 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 	u64 val;
 	int i, len;
 
-	if (depth != 1 ||
-	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
+	if (depth != 1 || strcmp(uname, "chosen") != 0)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
-- 
2.1.4
