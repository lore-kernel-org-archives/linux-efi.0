From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 03/11] arm64: Use core efi=debug instead of uefi_debug command line parameter
Date: Mon, 12 Oct 2015 14:56:06 +0100
Message-ID: <1444658174-23378-4-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Mark Salter <msalter@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Leif Lindholm <leif.lindholm@linaro.org>

Now that we have an efi=debug command line option in the core code, use
this instead of the arm64-specific uefi_debug option.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/arm/uefi.txt |  2 --
 arch/arm64/kernel/efi.c    | 19 +++++--------------
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
index d60030a1b909..7b3fdfe0f7ba 100644
--- a/Documentation/arm/uefi.txt
+++ b/Documentation/arm/uefi.txt
@@ -60,5 +60,3 @@ linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
 --------------------------------------------------------------------------------
 linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
 --------------------------------------------------------------------------------
-
-For verbose debug messages, specify 'uefi_debug' on the kernel command line.
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e8ca6eaedd02..612ad5ec1d2e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -51,15 +51,6 @@ static struct mm_struct efi_mm = {
 	INIT_MM_CONTEXT(efi_mm)
 };
 
-static int uefi_debug __initdata;
-static int __init uefi_debug_setup(char *str)
-{
-	uefi_debug = 1;
-
-	return 0;
-}
-early_param("uefi_debug", uefi_debug_setup);
-
 static int __init is_normal_ram(efi_memory_desc_t *md)
 {
 	if (md->attribute & EFI_MEMORY_WB)
@@ -171,14 +162,14 @@ static __init void reserve_regions(void)
 	efi_memory_desc_t *md;
 	u64 paddr, npages, size;
 
-	if (uefi_debug)
+	if (efi_enabled(EFI_DBG))
 		pr_info("Processing EFI memory map:\n");
 
 	for_each_efi_memory_desc(&memmap, md) {
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
-		if (uefi_debug) {
+		if (efi_enabled(EFI_DBG)) {
 			char buf[64];
 
 			pr_info("  0x%012llx-0x%012llx %s",
@@ -194,11 +185,11 @@ static __init void reserve_regions(void)
 
 		if (is_reserve_region(md)) {
 			memblock_reserve(paddr, size);
-			if (uefi_debug)
+			if (efi_enabled(EFI_DBG))
 				pr_cont("*");
 		}
 
-		if (uefi_debug)
+		if (efi_enabled(EFI_DBG))
 			pr_cont("\n");
 	}
 
@@ -210,7 +201,7 @@ void __init efi_init(void)
 	struct efi_fdt_params params;
 
 	/* Grab UEFI information placed in FDT by stub */
-	if (!efi_get_fdt_params(&params, uefi_debug))
+	if (!efi_get_fdt_params(&params, efi_enabled(EFI_DBG)))
 		return;
 
 	efi_system_table = params.system_table;
-- 
2.1.0
