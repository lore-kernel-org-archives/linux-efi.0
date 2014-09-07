From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: [PATCH 2/4] x86/efi: Unexport add_efi_memmap variable
Date: Sun,  7 Sep 2014 19:42:15 +0200
Message-ID: <1410111737-5220-3-git-send-email-minipli@googlemail.com>
References: <1410111737-5220-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410111737-5220-1-git-send-email-minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Paul Jackson <pj-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This variable was accidentally exported, even though it's only used in
this compilation unit and only during initialization.

Remove the bogus export, make the variable static instead and mark it
as __initdata.

Fixes: 200001eb140e ("x86 boot: only pick up additional EFI memmap...")
Cc: Paul Jackson <pj-sJ/iWh9BUns@public.gmane.org>
Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
---
 arch/x86/include/asm/efi.h  |    1 -
 arch/x86/platform/efi/efi.c |    4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 8aee01536c6c..b07ecf332bdf 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -86,7 +86,6 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 
 #endif /* CONFIG_X86_32 */
 
-extern int add_efi_memmap;
 extern struct efi_scratch efi_scratch;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94fef30..9e43b0f3d891 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -78,9 +78,7 @@ static int __init setup_noefi(char *arg)
 }
 early_param("noefi", setup_noefi);
 
-int add_efi_memmap;
-EXPORT_SYMBOL(add_efi_memmap);
-
+static int add_efi_memmap __initdata;
 static int __init setup_add_efi_memmap(char *arg)
 {
 	add_efi_memmap = 1;
-- 
1.7.10.4
