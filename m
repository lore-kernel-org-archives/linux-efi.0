From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 10/11] x86/efi: Rename print_efi_memmap() to efi_print_memmap()
Date: Mon, 12 Oct 2015 14:56:13 +0100
Message-ID: <1444658174-23378-11-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Xishi Qiu <qiuxishi@huawei.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Taku Izumi <izumi.taku@jp.fujitsu.com>

This patch renames print_efi_memmap() to efi_print_memmap() and
make it global function so that we can invoke it outside of
arch/x86/platform/efi/efi.c

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h  | 1 +
 arch/x86/platform/efi/efi.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 155162ea0e00..cfee9d4b02af 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -93,6 +93,7 @@ extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int __init efi_memblock_x86_reserve_range(void);
 extern pgd_t * __init efi_call_phys_prolog(void);
 extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
+extern void __init efi_print_memmap(void);
 extern void __init efi_unmap_memmap(void);
 extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4d0ff0f27a99..c69e58fb7f19 100644
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
2.1.0
