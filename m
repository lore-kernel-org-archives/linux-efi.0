From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 03/11] efi/fdt: Simplify get_fdt flow
Date: Thu, 29 Nov 2018 18:12:22 +0100
Message-ID: <20181129171230.18699-4-ard.biesheuvel@linaro.org>
References: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Reorganize get_fdt lookup loop, clearly showing that:
- Nothing is done for table entries that do not have fdt_guid
- Once an entry with fdt_guid is found, break out of the loop

No functional changes.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/fdt.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a3614f9b5f75..0dc7b4987cc2 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -370,23 +370,24 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 {
 	efi_guid_t fdt_guid = DEVICE_TREE_GUID;
 	efi_config_table_t *tables;
-	void *fdt;
 	int i;
 
-	tables = (efi_config_table_t *) sys_table->tables;
-	fdt = NULL;
+	tables = (efi_config_table_t *)sys_table->tables;
 
 	for (i = 0; i < sys_table->nr_tables; i++) {
-		if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
-			fdt = (void *) tables[i].table;
-			if (fdt_check_header(fdt) != 0) {
-				pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
-				return NULL;
-			}
-			*fdt_size = fdt_totalsize(fdt);
-			break;
+		void *fdt;
+
+		if (efi_guidcmp(tables[i].guid, fdt_guid) != 0)
+			continue;
+
+		fdt = (void *)tables[i].table;
+		if (fdt_check_header(fdt) != 0) {
+			pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
+			return NULL;
 		}
+		*fdt_size = fdt_totalsize(fdt);
+		return fdt;
 	}
 
-	return fdt;
+	return NULL;
 }
-- 
2.19.1
