From: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH 3/3] x86, efi: Early use of boot service memory
Date: Mon, 11 Nov 2013 19:15:58 -0700
Message-ID: <1384222558-38527-4-git-send-email-jerry.hoemann@hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jerry.hoemann-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Extend the kernel parameter add_efi_memmap to have additional
optional arguement "correct."   EFI memmaps that are "correct"
aren't accessed by platform firmware after a call to Exit Boot
Services.

Signed-off-by: Jerry Hoemann <jerry.hoemann-VXdhtT5mjnY@public.gmane.org>
---
 Documentation/kernel-parameters.txt |  8 ++++++++
 arch/x86/platform/efi/efi.c         | 13 +++++++++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fcbb736..ae1bde6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -346,6 +346,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	add_efi_memmap	[EFI; X86] Include EFI memory map in
 			kernel's map of available physical RAM.
 
+	add_efi_memmap=	[EFI; X86] Include EFI memory map in
+			kernel's map of available physical RAM.
+			Additional Modifies:
+
+			correct: Platform firmware correctly doesn't reuse
+			boot service code or data segments after Exit Boot
+			Services.
+
 	agp=		[AGP]
 			{ off | try_unsupported }
 			off: disable AGP support
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c7e22ab..0cb1cce 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -103,6 +103,10 @@ EXPORT_SYMBOL(add_efi_memmap);
 static int __init setup_add_efi_memmap(char *arg)
 {
 	add_efi_memmap = 1;
+	if (arg && strstr(arg, "correct")) {
+		pr_info("%s: setting EFI_MEMMAP_CORRECT\n", __func__);
+		set_bit(EFI_MEMMAP_CORRECT, &x86_efi_facility);
+	}
 	return 0;
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
@@ -422,6 +426,8 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
+static int	efi_boot_services_reservations;
+
 void __init efi_reserve_boot_services(void)
 {
 	void *p;
@@ -449,8 +455,10 @@ void __init efi_reserve_boot_services(void)
 			memblock_dbg("Could not reserve boot range "
 					"[0x%010llx-0x%010llx]\n",
 						start, start+size-1);
-		} else
+		} else {
 			memblock_reserve(start, size);
+			efi_boot_services_reservations++;
+		}
 	}
 }
 
@@ -467,7 +475,7 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_is_native())
+	if (!efi_is_native() || !efi_boot_services_reservations)
 		return;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
@@ -484,6 +492,7 @@ void __init efi_free_boot_services(void)
 			continue;
 
 		free_bootmem_late(start, size);
+		efi_boot_services_reservations--;
 	}
 
 	efi_unmap_memmap();
-- 
1.7.11.3
