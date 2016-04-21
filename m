From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] x86/efi: Remove the always true EFI_DEBUG symbol
Date: Thu, 21 Apr 2016 12:09:30 +0100
Message-ID: <1461236970-19275-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@alien8.de>, Robert Elliott <elliott@hpe.com>
List-Id: linux-efi@vger.kernel.org

This symbol is always set which makes it useless. Additionally we have
a kernel command-line switch, efi=debug, which actually controls the
printing of the memory map.

Reported-by: Robert Elliott <elliott@hpe.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
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
