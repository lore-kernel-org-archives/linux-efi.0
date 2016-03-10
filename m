From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/8] efi/arm: populate screen_info based on data provided by the UEFI stub
Date: Thu, 10 Mar 2016 12:40:08 +0700
Message-ID: <1457588408-19309-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457588408-19309-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Unlike on arm64, where we can simply access the screen_info struct directly,
ARM requires an intermediate step to get the information discovered by the
GOP code in the UEFI stub into the screen_info struct.

So retrieve the dedicated config table we invented for this purpose, and
put its contents into the core kernel's copy of struct screen_info.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/kernel/efi.c           | 24 ++++++++++++++++++++
 drivers/firmware/efi/arm-init.c |  6 +++++
 2 files changed, 30 insertions(+)

diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
index ff8a9d8acfac..8d1119259654 100644
--- a/arch/arm/kernel/efi.c
+++ b/arch/arm/kernel/efi.c
@@ -6,11 +6,35 @@
  * published by the Free Software Foundation.
  */
 
+#define pr_fmt(fmt)     "efi: " fmt
+
 #include <linux/efi.h>
+#include <linux/screen_info.h>
 #include <asm/efi.h>
 #include <asm/mach/map.h>
 #include <asm/mmu_context.h>
 
+static const efi_guid_t __initconst si_tbl = LINUX_ARM32_SCREEN_INFO_TABLE_GUID;
+
+void __init efi_find_screen_info(efi_config_table_t *tbl, u32 num_tables)
+{
+	struct screen_info *si;
+
+	while (num_tables--) {
+		if (efi_guidcmp(tbl->guid, si_tbl) == 0) {
+			si = early_memremap_ro(tbl->table, sizeof(*si));
+			if (!si) {
+				pr_warn("Failed to remap screen_info config table\n");
+				return;
+			}
+			screen_info = *si;
+			early_memunmap(si, sizeof(*si));
+			break;
+		}
+		tbl++;
+	}
+}
+
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	struct map_desc desc = {
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index eca9b4f826ee..689bf65f8ddf 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -112,6 +112,12 @@ static int __init uefi_init(void)
 	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
 					 sizeof(efi_config_table_t), NULL);
 
+	if (IS_ENABLED(CONFIG_ARM)) {
+		extern void efi_find_screen_info(efi_config_table_t *, u32);
+
+		efi_find_screen_info(config_tables, efi.systab->nr_tables);
+	}
+
 	early_memunmap(config_tables, table_size);
 out:
 	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
-- 
1.9.1
