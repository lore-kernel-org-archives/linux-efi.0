From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] efi: remove duplicate 'const' specifiers
Date: Thu, 11 May 2017 13:43:17 +0200
Message-ID: <20170511114337.2803599-1-arnd@arndb.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

gcc-7 shows a harmless warning:

drivers/firmware/efi/libstub/secureboot.c:19:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]
 static const efi_char16_t const efi_SecureBoot_name[] = {
drivers/firmware/efi/libstub/secureboot.c:22:27: error: duplicate 'const' declaration specifier [-Werror=duplicate-decl-specifier]

Removing one of the specifiers gives us the expected behavior.

Fixes: de8cb458625c ("efi: Get and store the secure boot status")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/firmware/efi/libstub/secureboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 8c34d50a4d80..959777ec8a77 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -16,10 +16,10 @@
 
 /* BIOS variables */
 static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
-static const efi_char16_t const efi_SecureBoot_name[] = {
+static const efi_char16_t efi_SecureBoot_name[] = {
 	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
 };
-static const efi_char16_t const efi_SetupMode_name[] = {
+static const efi_char16_t efi_SetupMode_name[] = {
 	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
 };
 
-- 
2.9.0
