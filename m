From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 15/40] x86/efi: Remove the always true EFI_DEBUG symbol
Date: Mon, 25 Apr 2016 21:06:47 +0100
Message-ID: <1461614832-17633-16-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This symbol is always set which makes it useless. Additionally we have
a kernel command-line switch, efi=debug, which actually controls the
printing of the memory map.

Reported-by: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dde46cd78b8f..f93545e7dc54 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -54,8 +54,6 @@
 #include <asm/rtc.h>
 #include <asm/uv/uv.h>
 
-#define EFI_DEBUG
-
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
@@ -222,7 +220,6 @@ int __init efi_memblock_x86_reserve_range(void)
 
 void __init efi_print_memmap(void)
 {
-#ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	int i = 0;
 
@@ -235,7 +232,6 @@ void __init efi_print_memmap(void)
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
-#endif  /*  EFI_DEBUG  */
 }
 
 void __init efi_unmap_memmap(void)
-- 
2.7.3
