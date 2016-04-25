From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 11/40] arm64: efi: Apply strict permissons for UEFI Runtime Services regions
Date: Mon, 25 Apr 2016 21:06:43 +0100
Message-ID: <1461614832-17633-12-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Recent UEFI versions expose permission attributes for runtime services
memory regions, either in the UEFI memory map or in the separate memory
attributes table. This allows the kernel to map these regions with
stricter permissions, rather than the RWX permissions that are used by
default. So wire this up in our mapping routine.

Note that in the absence of permission attributes, we still only map
regions of type EFI_RUNTIME_SERVICE_CODE with the executable bit set.
Also, we base the mapping attributes of EFI_MEMORY_MAPPED_IO on the
type directly rather than on the absence of the EFI_MEMORY_WB attribute.
This is more correct, but is also required for compatibility with the
upcoming support for the Memory Attributes Table, which only carries
permission attributes, not memory type attributes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm64/kernel/efi.c | 54 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b6abc852f2a1..33a6da160a50 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -17,22 +17,48 @@
 
 #include <asm/efi.h>
 
-int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
+/*
+ * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
+ * executable, everything else can be mapped with the XN bits
+ * set. Also take the new (optional) RO/XP bits into account.
+ */
+static __init pteval_t create_mapping_protection(efi_memory_desc_t *md)
 {
-	pteval_t prot_val;
+	u64 attr = md->attribute;
+	u32 type = md->type;
 
-	/*
-	 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
-	 * executable, everything else can be mapped with the XN bits
-	 * set.
-	 */
-	if ((md->attribute & EFI_MEMORY_WB) == 0)
-		prot_val = PROT_DEVICE_nGnRE;
-	else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
-		 !PAGE_ALIGNED(md->phys_addr))
-		prot_val = pgprot_val(PAGE_KERNEL_EXEC);
-	else
-		prot_val = pgprot_val(PAGE_KERNEL);
+	if (type == EFI_MEMORY_MAPPED_IO)
+		return PROT_DEVICE_nGnRE;
+
+	if (WARN_ONCE(!PAGE_ALIGNED(md->phys_addr),
+		      "UEFI Runtime regions are not aligned to 64 KB -- buggy firmware?"))
+		/*
+		 * If the region is not aligned to the page size of the OS, we
+		 * can not use strict permissions, since that would also affect
+		 * the mapping attributes of the adjacent regions.
+		 */
+		return pgprot_val(PAGE_KERNEL_EXEC);
+
+	/* R-- */
+	if ((attr & (EFI_MEMORY_XP | EFI_MEMORY_RO)) ==
+	    (EFI_MEMORY_XP | EFI_MEMORY_RO))
+		return pgprot_val(PAGE_KERNEL_RO);
+
+	/* R-X */
+	if (attr & EFI_MEMORY_RO)
+		return pgprot_val(PAGE_KERNEL_ROX);
+
+	/* RW- */
+	if (attr & EFI_MEMORY_XP || type != EFI_RUNTIME_SERVICES_CODE)
+		return pgprot_val(PAGE_KERNEL);
+
+	/* RWX */
+	return pgprot_val(PAGE_KERNEL_EXEC);
+}
+
+int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
+{
+	pteval_t prot_val = create_mapping_protection(md);
 
 	create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
 			   md->num_pages << EFI_PAGE_SHIFT,
-- 
2.7.3
