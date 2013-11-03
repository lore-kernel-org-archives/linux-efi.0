From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi earlyprintk fix
Date: Sun, 3 Nov 2013 20:16:47 +0800
Message-ID: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


there's below one line shift problem:

                     ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
[    0.000000] efi:  

In fact check efi_y and the lfb_height should be compared at the begin of the
loop of early_efi_write

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/x86/platform/efi/early_printk.c
+++ linux-2.6/arch/x86/platform/efi/early_printk.c
@@ -106,6 +106,15 @@ early_efi_write(struct console *con, con
 		if (count > linemax)
 			count = linemax;
 
+		if (efi_y + font->height >= si->lfb_height) {
+			u32 i;
+
+			efi_y -= font->height;
+			early_efi_scroll_up();
+
+			for (i = 0; i < font->height; i++)
+				early_efi_clear_scanline(efi_y + i);
+		}
 		for (h = 0; h < font->height; h++) {
 			unsigned int n, x;
 
@@ -142,15 +151,6 @@ early_efi_write(struct console *con, con
 			efi_y += font->height;
 		}
 
-		if (efi_y + font->height >= si->lfb_height) {
-			u32 i;
-
-			efi_y -= font->height;
-			early_efi_scroll_up();
-
-			for (i = 0; i < font->height; i++)
-				early_efi_clear_scanline(efi_y + i);
-		}
 	}
 }
 
