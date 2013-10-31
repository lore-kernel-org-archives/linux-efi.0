From: Borislav Petkov <bp@alien8.de>
Subject: [PATCH 01/11] efi: Simplify EFI_DEBUG
Date: Thu, 31 Oct 2013 17:24:59 +0100
Message-ID: <1383236709-19716-2-git-send-email-bp@alien8.de>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux EFI <linux-efi@vger.kernel.org>
Cc: Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Matt Fleming <matt@console-pimps.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

... and lose one #ifdef .. #endif sandwich.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/platform/efi/efi.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 1d3372ac9c66..f396163b0402 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -51,7 +51,7 @@
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
 
-#define EFI_DEBUG	1
+#define EFI_DEBUG
 
 #define EFI_MIN_RESERVE 5120
 
@@ -398,9 +398,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-#if EFI_DEBUG
 static void __init print_efi_memmap(void)
 {
+#ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	void *p;
 	int i;
@@ -415,8 +415,8 @@ static void __init print_efi_memmap(void)
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
-}
 #endif  /*  EFI_DEBUG  */
+}
 
 void __init efi_reserve_boot_services(void)
 {
@@ -696,10 +696,7 @@ void __init efi_init(void)
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
