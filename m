From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] x86/efi: initialize status to ensure garbage is not returned on small size
Date: Wed, 20 Jul 2016 11:11:06 +0100
Message-ID: <1469009466-19980-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Although very unlikey, if size is too small or zero, then we end up with
status not being set and returning garbage. Instead, initializing status to
EFI_INVALID_PARAMETER to indicate that size is invalid in the calls to
setup_uga32 and setup_uga64.

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ff574da..ec6d2ef 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -578,7 +578,7 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u32 *handles = (u32 *)uga_handle;;
-	efi_status_t status;
+	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
 	first_uga = NULL;
@@ -623,7 +623,7 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u64 *handles = (u64 *)uga_handle;;
-	efi_status_t status;
+	efi_status_t status = EFI_INVALID_PARAMETER;
 	int i;
 
 	first_uga = NULL;
-- 
2.8.1
