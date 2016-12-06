From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 4/4] efi: Skip parsing of EFI_PROPERTIES_TABLE if EFI_MEMORY_ATTRIBUTES_TABLE is detected
Date: Tue,  6 Dec 2016 11:16:03 -0800
Message-ID: <1481051763-8705-5-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481051763-8705-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jlee@suse.com, bp@alien8.de, ricardo.neri@intel.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, ravi.v.shankar@intel.com, fenghua.yu@intel.com, Sai Praneeth <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

UEFI specification v2.6 recommends not to use
"EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA"
attribute of EFI_PROPERTIES_TABLE. Presently, this is the *only* bit
defined in EFI_PROPERTIES_TABLE. This bit implies that EFI Runtime code
and data regions of an executable image are separate and are aligned as
specified in spec. Please refer to "EFI_PROPERTIES_TABLE" in section 4.6
of UEFI specification v2.6 for more information on this table.

UEFI v2.6 introduces EFI_MEMORY_ATTRIBUTES_TABLE and is intended to
replace EFI_PROPERTIES_TABLE. If EFI_MEMORY_ATTRIBUTES_TABLE is found we
skip updating of efi runtime region mappings based on
EFI_PROPERTIES_TABLE, so let's also skip parsing of EFI_PROPERTIES_TABLE
if we find EFI_MEMORY_ATTRIBUTES_TABLE because we are not using this
table anyways. The only caveat here is, if further versions of UEFI spec
adds some more bits (hence some more attributes) to EFI_PROPERTIES_TABLE
then we might need to parse it again, otherwise there is no good in
doing that. We can also expect that the same attributes might be reflected in
EFI_MEMORY_ATTRIBUTES_TABLE and hence saving us from parsing
EFI_PROPERTIES_TABLE again.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee, Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
---
 drivers/firmware/efi/efi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index e7d404059b73..e6c6feaa4d78 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -531,6 +531,17 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 
 	efi_memattr_init();
 
+	/*
+	 * Since EFI_MEMORY_ATTRIBUTES_TABLE is intended to replace
+	 * EFI_PROPERTIES_TABLE, let's skip parsing of EFI_PROPERTIES_TABLE
+	 * if we find EFI_MEMORY_ATTRIBUTES_TABLE.
+	 * Note: We might need to *re-enable* parsing of EFI_PROPERTIES_TABLE
+	 * if it defines some bits that are not defined in
+	 * EFI_MEMORY_ATTRIBUTES_TABLE.
+	 */
+	if (efi_enabled(EFI_MEM_ATTR))
+		return 0;
+
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
 		efi_properties_table_t *tbl;
-- 
2.1.4
