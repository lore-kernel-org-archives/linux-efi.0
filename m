From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/4] efi/libstub: fix harmless command line parsing bug
Date: Fri, 24 Mar 2017 13:24:07 +0000
Message-ID: <20170324132410.16628-2-ard.biesheuvel@linaro.org>
References: <20170324132410.16628-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170324132410.16628-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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
