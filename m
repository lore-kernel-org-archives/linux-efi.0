From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: [PATCH 1/2] Remove EFI memmap quirk for UV
Date: Mon, 16 Nov 2015 11:59:40 -0600
Message-ID: <1447696781-159611-1-git-send-email-athorlton@sgi.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
EFI memmap mechanism.  We have a BIOS fix for this issue now, so we no
longer need this quirk in the kernel.  This commit removes the quirk
from the function in question.

Signed-off-by: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Acked-by: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
Acked-by: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>
Cc: Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

---
 arch/x86/platform/efi/quirks.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380d..96b417c 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -259,12 +259,6 @@ void __init efi_apply_memmap_quirks(void)
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
-
-	/*
-	 * UV doesn't support the new EFI pagetable mapping yet.
-	 */
-	if (is_uv_system())
-		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 }
 
 /*
-- 
1.8.5.6
