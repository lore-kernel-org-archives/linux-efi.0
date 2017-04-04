From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 09/12] efi/libstub: Fix harmless command line parsing bug
Date: Tue,  4 Apr 2017 17:02:45 +0100
Message-ID: <20170404160245.27812-12-ard.biesheuvel@linaro.org>
References: <20170404160245.27812-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404160245.27812-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

When we parse the 'efi=' command line parameter in the stub, we
fail to take spaces into account. Currently, the only way this
could result in unexpected behavior is when the string 'nochunk'
appears as a separate command line argument after 'efi=xxx,yyy,zzz ',
so this is harmless in practice. But let's fix it nonetheless.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 919822b7773d..3290fae0b38f 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -436,14 +436,14 @@ efi_status_t efi_parse_options(char *cmdline)
 	 * Remember, because efi= is also used by the kernel we need to
 	 * skip over arguments we don't understand.
 	 */
-	while (*str) {
+	while (*str && *str != ' ') {
 		if (!strncmp(str, "nochunk", 7)) {
 			str += strlen("nochunk");
 			__chunk_size = -1UL;
 		}
 
 		/* Group words together, delimited by "," */
-		while (*str && *str != ',')
+		while (*str && *str != ' ' && *str != ',')
 			str++;
 
 		if (*str == ',')
-- 
2.9.3
