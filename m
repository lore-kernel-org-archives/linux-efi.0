From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v2 1/2] efi/fdt: Indentation fix
Date: Mon, 29 Oct 2018 10:15:41 +0000
Message-ID: <1540808142-33208-2-git-send-email-julien.thierry@arm.com>
References: <1540808142-33208-1-git-send-email-julien.thierry@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540808142-33208-1-git-send-email-julien.thierry@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, ard.biesheuvel@linaro.org, joe@perches.com, Julien Thierry <julien.thierry@arm.com>
List-Id: linux-efi@vger.kernel.org

Closing bracket seems to end a for statement when it is actually ending
the contained if. Add some brackets to have clear delimitation of each
scope.

No functional change/fix, just fix the indentation.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/fdt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 8830fa6..8b6696e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -372,7 +372,7 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 	tables = (efi_config_table_t *) sys_table->tables;
 	fdt = NULL;
 
-	for (i = 0; i < sys_table->nr_tables; i++)
+	for (i = 0; i < sys_table->nr_tables; i++) {
 		if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
 			fdt = (void *) tables[i].table;
 			if (fdt_check_header(fdt) != 0) {
@@ -381,7 +381,8 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 			}
 			*fdt_size = fdt_totalsize(fdt);
 			break;
-	 }
+		}
+	}
 
 	return fdt;
 }
-- 
1.9.1
