From: Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] Documentation/efi-stub.txt: Fix a typo
Date: Wed, 21 Oct 2015 15:26:44 +0300
Message-ID: <1445430404-1908-1-git-send-email-joonas.lahtinen@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Linux EFI (Extensible Firmware Interface) development" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In the command invocation "initrd=\Kernels\..." should really read
"initrd=\Ramdisks\..." instead.

Signed-off-by: Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 Documentation/efi-stub.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/efi-stub.txt b/Documentation/efi-stub.txt
index 7747024..e1ee764 100644
--- a/Documentation/efi-stub.txt
+++ b/Documentation/efi-stub.txt
@@ -68,7 +68,7 @@ fs0:>
 to boot with the initrd-large.img file if the current working
 directory is fs0:\Kernels, the following command must be used,
 
-	fs0:\Kernels> bzImage.efi initrd=\Kernels\initrd-large.img
+	fs0:\Kernels> bzImage.efi initrd=\Ramdisks\initrd-large.img
 
 Notice how bzImage.efi can be specified with a relative path. That's
 because the image we're executing is interpreted by the EFI shell,
-- 
2.4.3
