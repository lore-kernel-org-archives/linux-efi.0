From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 3/7] x86/efi: Remove unused variable efi
Date: Sat, 25 Jun 2016 08:20:26 +0100
Message-ID: <1466839230-12781-4-git-send-email-matt@codeblueprint.co.uk>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466839230-12781-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Remove unused variable efi, it is never used. Fixes clang build
warning:

arch/x86/boot/compressed/eboot.c:803:2: warning: Value stored to
  'efi' is never read

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 52fef606bc54..ff574dad95cc 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -757,7 +757,6 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	struct boot_params *boot_params;
 	struct apm_bios_info *bi;
 	struct setup_header *hdr;
-	struct efi_info *efi;
 	efi_loaded_image_t *image;
 	void *options, *handle;
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
@@ -800,7 +799,6 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	memset(boot_params, 0x0, 0x4000);
 
 	hdr = &boot_params->hdr;
-	efi = &boot_params->efi_info;
 	bi = &boot_params->apm_bios_info;
 
 	/* Copy the second sector to boot_params */
-- 
2.7.3
