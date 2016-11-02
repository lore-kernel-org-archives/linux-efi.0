From: Eugene Korenevsky <ekorenevsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] EFI loader: remove pointless "if" statement
Date: Wed, 2 Nov 2016 18:03:33 +0300
Message-ID: <20161102150333.GA20547@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linn Crosetto <linn-ZPxbGqLxI0U@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

An obvious cleanup. "if" statement does nothing and should be removed.

---
 arch/x86/boot/compressed/eboot.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index cc69e37..202f2aa 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1054,11 +1054,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	/* Historic? */
 	boot_params->alt_mem_k = 32 * 1024;
 
-	status = setup_e820(boot_params, e820ext, e820ext_size);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	return EFI_SUCCESS;
+	return setup_e820(boot_params, e820ext, e820ext_size);
 }
 
 /*
-- 
2.10.2
