From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 1/4] efi: Make EFI_MEMORY_ATTRIBUTES_TABLE initialization common across all architectures
Date: Tue,  6 Dec 2016 11:16:00 -0800
Message-ID: <1481051763-8705-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jlee@suse.com, bp@alien8.de, ricardo.neri@intel.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, ravi.v.shankar@intel.com, fenghua.yu@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Since EFI_PROPERTIES_TABLE and EFI_MEMORY_ATTRIBUTES_TABLE deal with
updating memory region attributes, it makes sense to call
EFI_MEMORY_ATTRIBUTES_TABLE initialization function from the same place
as EFI_PROPERTIES_TABLE. This also moves the EFI_MEMORY_ATTRIBUTES_TABLE
initialization code to a more generic efi initialization path rather
than ARM specific efi initialization. This is important because
EFI_MEMORY_ATTRIBUTES_TABLE will be supported by x86 as well.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/firmware/efi/arm-init.c | 1 -
 drivers/firmware/efi/efi.c      | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index f853ad2c4ca0..1027d7b44358 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -250,7 +250,6 @@ void __init efi_init(void)
 	}
 
 	reserve_regions();
-	efi_memattr_init();
 	efi_esrt_init();
 	efi_memmap_unmap();
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 92914801e388..e7d404059b73 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -529,6 +529,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		}
 	}
 
+	efi_memattr_init();
+
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
 		efi_properties_table_t *tbl;
-- 
2.1.4
