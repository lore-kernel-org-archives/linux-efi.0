From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 04/13] x86/efi: Delete dead code when checking for non-native
Date: Thu, 27 Feb 2014 19:50:51 +0000
Message-ID: <1393530660-12692-5-git-send-email-matt@console-pimps.org>
References: <1393530660-12692-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393530660-12692-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Both efi_free_boot_services() and efi_enter_virtual_mode() are invoked
from init/main.c, but only if the EFI runtime services are available.
This is not the case for non-native boots, e.g. where a 64-bit kernel is
booted with 32-bit EFI firmware.

Delete the dead code.

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 0c8672b3f9a3..5f623f3bcbba 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -452,9 +452,6 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_is_native())
-		return;
-
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
@@ -979,15 +976,6 @@ static void __init kexec_enter_virtual_mode(void)
 	efi.systab = NULL;
 
 	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
-
-	/*
 	* Map efi regions which were passed via setup_data. The virt_addr is a
 	* fixed addr which was used in first kernel of a kexec boot.
 	*/
@@ -1066,15 +1054,6 @@ static void __init __efi_enter_virtual_mode(void)
 
 	efi.systab = NULL;
 
-	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
-
 	efi_merge_regions();
 	new_memmap = efi_map_regions(&count, &pg_shift);
 	if (!new_memmap) {
-- 
1.8.5.3
