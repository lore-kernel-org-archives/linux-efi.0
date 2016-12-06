From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 3/4] x86/efi: Add support for EFI_MEMORY_ATTRIBUTES_TABLE
Date: Tue,  6 Dec 2016 11:16:02 -0800
Message-ID: <1481051763-8705-4-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jlee@suse.com, bp@alien8.de, ricardo.neri@intel.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, ravi.v.shankar@intel.com, fenghua.yu@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

UEFI v2.6 introduces EFI_MEMORY_ATTRIBUTES_TABLE which describes memory
protections that may be applied to EFI Runtime code and data regions by
kernel. This enables kernel to map these regions more strictly thereby
increasing security. Presently, the only valid bits for attribute field
of a memory descriptor are EFI_MEMORY_RO and EFI_MEMORY_XP, hence use
these bits to update mappings in efi_pgd.

UEFI specification recommends to use this feature instead of
EFI_PROPERTIES_TABLE and hence while updating efi mappings we first
check for EFI_MEMORY_ATTRIBUTES_TABLE and if it's present we update
mappings according to this table and hence disregarding
EFI_PROPERTIES_TABLE even if it's published by firmware. We consider
EFI_PROPERTIES_TABLE only when EFI_MEMORY_ATTRIBUTES_TABLE is absent.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/platform/efi/efi_64.c | 64 +++++++++++++++++++++++++++++++++++-------
 drivers/firmware/efi/memattr.c |  5 +++-
 2 files changed, 58 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 58b0f801f66f..de12d9f5cfc3 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -368,10 +368,44 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 	efi_setup = phys_addr + sizeof(struct setup_data);
 }
 
-void __init efi_runtime_update_mappings(void)
+static int __init efi_update_mappings(efi_memory_desc_t *md, unsigned long pf)
 {
 	unsigned long pfn;
 	pgd_t *pgd = efi_pgd;
+	int err1, err2;
+
+	/* Update the 1:1 mapping */
+	pfn = md->phys_addr >> PAGE_SHIFT;
+	err1 = kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages, pf);
+	if (err1) {
+		pr_err("Error while updating 1:1 mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, md->virt_addr);
+	}
+
+	err2 = kernel_map_pages_in_pgd(pgd, pfn, md->virt_addr, md->num_pages, pf);
+	if (err2) {
+		pr_err("Error while updating VA mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, md->virt_addr);
+	}
+
+	return err1 || err2;
+}
+
+static int __init efi_update_mem_attr(struct mm_struct *mm, efi_memory_desc_t *md)
+{
+	unsigned long pf = 0;
+
+	if (md->attribute & EFI_MEMORY_XP)
+		pf |= _PAGE_NX;
+
+	if (!(md->attribute & EFI_MEMORY_RO))
+		pf |= _PAGE_RW;
+
+	return efi_update_mappings(md, pf);
+}
+
+void __init efi_runtime_update_mappings(void)
+{
 	efi_memory_desc_t *md;
 
 	if (efi_enabled(EFI_OLD_MEMMAP)) {
@@ -380,6 +414,24 @@ void __init efi_runtime_update_mappings(void)
 		return;
 	}
 
+	/*
+	 * Use EFI Memory Attribute Table for mapping permissions if it
+	 * exists, since it is intended to supersede EFI_PROPERTIES_TABLE.
+	 */
+	if (efi_enabled(EFI_MEM_ATTR)) {
+		efi_memattr_apply_permissions(NULL, efi_update_mem_attr);
+		return;
+	}
+
+	/*
+	 * EFI_MEMORY_ATTRIBUTES_TABLE is intended to replace
+	 * EFI_PROPERTIES_TABLE. So, use EFI_PROPERTIES_TABLE to update
+	 * permissions only if EFI_MEMORY_ATTRIBUTES_TABLE is not
+	 * published by firmware. Even if we find a buggy implementation of
+	 * EFI_MEMORY_ATTRIBUTES_TABLE don't fall back to
+	 * EFI_PROPERTIES_TABLE because of the same above mentioned reason.
+	 */
+
 	if (!efi_enabled(EFI_NX_PE_DATA))
 		return;
 
@@ -400,15 +452,7 @@ void __init efi_runtime_update_mappings(void)
 			(md->type != EFI_RUNTIME_SERVICES_CODE))
 			pf |= _PAGE_RW;
 
-		/* Update the 1:1 mapping */
-		pfn = md->phys_addr >> PAGE_SHIFT;
-		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages, pf))
-			pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
-				   md->phys_addr, md->virt_addr);
-
-		if (kernel_map_pages_in_pgd(pgd, pfn, md->virt_addr, md->num_pages, pf))
-			pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
-				   md->phys_addr, md->virt_addr);
+		efi_update_mappings(md, pf);
 	}
 }
 
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index 402197460507..8986757eafaf 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -175,8 +175,11 @@ int __init efi_memattr_apply_permissions(struct mm_struct *mm,
 				md.phys_addr + size - 1,
 				efi_md_typeattr_format(buf, sizeof(buf), &md));
 
-		if (valid)
+		if (valid) {
 			ret = fn(mm, &md);
+			if (ret)
+				pr_err("Error updating mappings, skipping subsequent md's\n");
+		}
 	}
 	memunmap(tbl);
 	return ret;
-- 
2.1.4
