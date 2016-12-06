From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 2/4] efi: Introduce EFI_MEM_ATTR bit and set it from memory attributes table
Date: Tue,  6 Dec 2016 11:16:01 -0800
Message-ID: <1481051763-8705-3-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jlee@suse.com, bp@alien8.de, ricardo.neri@intel.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, ravi.v.shankar@intel.com, fenghua.yu@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

UEFI v2.6 introduces a configuration table called
EFI_MEMORY_ATTRIBUTES_TABLE which provides additional information about
efi runtime regions. Currently this table describes memory protections
that may be applied to EFI Runtime code and data regions by kernel.
Allocate a EFI_XXX bit to keep track of whether this feature is
published by firmware or not.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/firmware/efi/memattr.c | 1 +
 include/linux/efi.h            | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index 236004b9a50d..402197460507 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -43,6 +43,7 @@ int __init efi_memattr_init(void)
 
 	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
 	memblock_reserve(efi.mem_attr_table, tbl_size);
+	set_bit(EFI_MEM_ATTR, &efi.flags);
 
 unmap:
 	early_memunmap(tbl, sizeof(*tbl));
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a07a476178cd..41047ea555e3 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1063,6 +1063,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
+#define EFI_MEM_ATTR		10	/* Did firmware publish EFI_MEMORY_ATTRIBUTES table? */
 
 #ifdef CONFIG_EFI
 /*
-- 
2.1.4
