From: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 1/2] efi: Add 'nr_config_table' variable in efi structure
Date: Fri, 23 Jun 2017 00:34:51 +0800
Message-ID: <20170622163451.95748-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The 'nr_config_table' and 'config_table' (alreay in efi structure)
in efi structure provide a way for some driver(e.g. capsule-pstore
goes through the configuration table to extract crash capsules to
aid in debugging) to iterate over the EFI configuration table array.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi.c     | 1 +
 drivers/firmware/efi/arm-init.c | 4 +++-
 drivers/firmware/efi/efi.c      | 1 +
 include/linux/efi.h             | 1 +
 4 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e14d557..94a9d762 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -498,6 +498,7 @@ void __init efi_init(void)
 		return;
 
 	efi.config_table = (unsigned long)efi.systab->tables;
+	efi.nr_config_table = (unsigned long)efi.systab->nr_tables;
 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
 	efi.runtime	 = (unsigned long)efi.systab->runtime;
 
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 80d1a88..9aa748f 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -145,8 +145,10 @@ static int __init uefi_init(void)
 					 sizeof(efi_config_table_t),
 					 arch_tables);
 
-	if (!retval)
+	if (!retval) {
 		efi.config_table = (unsigned long)efi.systab->tables;
+		efi.nr_config_table = (unsigned long)efi.systab->nr_tables;
+	}
 
 	early_memunmap(config_tables, table_size);
 out:
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b372aad..2afd76d 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -48,6 +48,7 @@ struct efi __read_mostly efi = {
 	.fw_vendor		= EFI_INVALID_TABLE_ADDR,
 	.runtime		= EFI_INVALID_TABLE_ADDR,
 	.config_table		= EFI_INVALID_TABLE_ADDR,
+	.nr_config_table	= 0,
 	.esrt			= EFI_INVALID_TABLE_ADDR,
 	.properties_table	= EFI_INVALID_TABLE_ADDR,
 	.mem_attr_table		= EFI_INVALID_TABLE_ADDR,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8269bcb..5c7bc4d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -904,6 +904,7 @@ extern struct efi {
 	unsigned long fw_vendor;	/* fw_vendor */
 	unsigned long runtime;		/* runtime table */
 	unsigned long config_table;	/* config tables */
+	unsigned long nr_config_table; /* the number of config tables */
 	unsigned long esrt;		/* ESRT table */
 	unsigned long properties_table;	/* properties table */
 	unsigned long mem_attr_table;	/* memory attributes table */
-- 
2.9.0.GIT
