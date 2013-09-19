From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 01/11] efi: Simplify EFI_DEBUG
Date: Thu, 19 Sep 2013 16:54:44 +0200
Message-ID: <1379602494-26684-2-git-send-email-bp@alien8.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379602494-26684-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

... and lose one #ifdef .. #endif sandwich.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed127096..7cec1e9e5494 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,7 +51,7 @@
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
 
-#define EFI_DEBUG	1
+#define EFI_DEBUG
 
 #define EFI_MIN_RESERVE 5120
 
@@ -402,9 +402,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-#if EFI_DEBUG
 static void __init print_efi_memmap(void)
 {
+#ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	void *p;
 	int i;
@@ -419,8 +419,8 @@ static void __init print_efi_memmap(void)
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
-}
 #endif  /*  EFI_DEBUG  */
+}
 
 void __init efi_reserve_boot_services(void)
 {
@@ -774,10 +774,7 @@ void __init efi_init(void)
 		x86_platform.set_wallclock = efi_set_rtc_mmss;
 	}
 #endif
-
-#if EFI_DEBUG
 	print_efi_memmap();
-#endif
 }
 
 void __init efi_late_init(void)
-- 
1.8.4
