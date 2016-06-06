From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] x86/efi: remove unused variable efi
Date: Mon,  6 Jun 2016 15:32:11 +0100
Message-ID: <1465223531-15661-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H . Peter Anvi" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Remove unused variable efi, it is never used. Fixes clang build
warning:

arch/x86/boot/compressed/eboot.c:803:2: warning: Value stored to
  'efi' is never read

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 52fef60..ff574da 100644
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
2.8.1
