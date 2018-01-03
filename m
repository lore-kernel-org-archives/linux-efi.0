From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH] MAINTAINERS: Remove Matt Fleming as EFI co-maintainer
Date: Wed,  3 Jan 2018 09:44:17 +0000
Message-ID: <20180103094417.6353-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Instate Ard Biesheuvel as the sole EFI maintainer and leave other folks
as maintainers for the EFI test driver and efivarfs file system.

Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 MAINTAINERS | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Ard, if you want to add yourself as co-maintainer of the EFI test
driver or efivarfs, please go ahead. I'm sure no one would object.

diff --git a/MAINTAINERS b/MAINTAINERS
index d4fdcb12616c..9a41aa072e6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5150,15 +5150,13 @@ F:	sound/usb/misc/ua101.c
 EFI TEST DRIVER
 L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 M:	Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
-M:	Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
 S:	Maintained
 F:	drivers/firmware/efi/test/
 
 EFI VARIABLE FILESYSTEM
 M:	Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
 M:	Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
-M:	Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
 L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 F:	fs/efivarfs/
@@ -5319,7 +5317,6 @@ S:	Supported
 F:	security/integrity/evm/
 
 EXTENSIBLE FIRMWARE INTERFACE (EFI)
-M:	Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
 M:	Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
 L:	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git
-- 
2.14.2
