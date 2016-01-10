From: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
Subject: [PATCH -next] efi: Do not include asm/efi.h if not needed
Date: Sun, 10 Jan 2016 07:35:28 -0800
Message-ID: <1452440128-15134-1-git-send-email-linux@roeck-us.net>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit f7d924894265 ("arm64/efi: refactor EFI init and runtime code
for reuse by 32-bit ARM") adds an include of asm/efi.h to efi.c.
This causes a build failure for ia64, where asm/efi.h does not exist.

drivers/firmware/efi/efi.c:28:21: fatal error:
	asm/efi.h: No such file or directory

asm/efi.h does not define or declare anything used by efi.c, thus
including it should not be needed.

Fixes: f7d924894265 ("arm64/efi: refactor EFI init and runtime code for reuse by 32-bit ARM")
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cffa89b3317b..027ca212179f 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -25,8 +25,6 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
-#include <asm/efi.h>
-
 struct efi __read_mostly efi = {
 	.mps			= EFI_INVALID_TABLE_ADDR,
 	.acpi			= EFI_INVALID_TABLE_ADDR,
-- 
2.1.4
