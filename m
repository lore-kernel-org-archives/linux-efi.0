From: =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me-A/3C56C7qwM@public.gmane.org>
Subject: [PATCH] x86/efi-bgrt: Don't ignore the BGRT if the 'valid' bit is 0
Date: Sun, 20 Dec 2015 22:53:11 +0100
Message-ID: <1450648391-4631-1-git-send-email-me@moshe.nl>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, =?UTF-8?q?M=C3=B4she=20van=20der=20Sterre?= <me-A/3C56C7qwM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Unintuitively, the BGRT graphic is apparently meant to be usable if
the valid bit in not set. The valid bit only conveys uncertainty
about the validity in relation to the screen state.

Windows 10 actually uses the BGRT image for its boot screen even if
not 'valid', for example when the user triggered the boot menu.
Because it is unclear if all firmwares will provide a usable graphic
in this case, we now look at the BMP magic number as an additional
check.
---
 arch/x86/platform/efi/efi-bgrt.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index b097066..a243381 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -57,11 +57,6 @@ void __init efi_bgrt_init(void)
 		       bgrt_tab->status);
 		return;
 	}
-	if (bgrt_tab->status != 1) {
-		pr_debug("Ignoring BGRT: invalid status %u (expected 1)\n",
-			 bgrt_tab->status);
-		return;
-	}
 	if (bgrt_tab->image_type != 0) {
 		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
 		       bgrt_tab->image_type);
@@ -80,6 +75,11 @@ void __init efi_bgrt_init(void)
 
 	memcpy(&bmp_header, image, sizeof(bmp_header));
 	memunmap(image);
+	if (bmp_header.id != 0x4d42) {
+		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4d42)\n",
+			bmp_header.id);
+		return;
+	}
 	bgrt_image_size = bmp_header.size;
 
 	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
-- 
2.5.0
