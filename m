From: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 1/2] x86, efi: rename print_efi_memmap() to efi_print_memmap()
Date: Wed, 30 Sep 2015 19:20:00 +0900
Message-ID: <1443608400-37744-1-git-send-email-izumi.taku@jp.fujitsu.com>
References: <1443608292-37686-1-git-send-email-izumi.taku@jp.fujitsu.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443608292-37686-1-git-send-email-izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch renames print_efi_memmap() to efi_print_memmap() and
make it global function so that we can invoke it outside of
arch/x86/platform/efi/efi.c

Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 arch/x86/include/asm/efi.h  | 1 +
 arch/x86/platform/efi/efi.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index ab5f1d4..f8b93d6 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -103,6 +103,7 @@ extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int __init efi_memblock_x86_reserve_range(void);
 extern pgd_t * __init efi_call_phys_prolog(void);
 extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
+extern void __init efi_print_memmap(void);
 extern void __init efi_unmap_memmap(void);
 extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1db84c0..1f95caf 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -222,7 +222,7 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-static void __init print_efi_memmap(void)
+void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
@@ -524,7 +524,7 @@ void __init efi_init(void)
 		return;
 
 	if (efi_enabled(EFI_DBG))
-		print_efi_memmap();
+		efi_print_memmap();
 
 	efi_esrt_init();
 }
-- 
1.8.3.1
