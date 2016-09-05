From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 5/6] efi/libstub: Use efi_exit_boot_services() in FDT
Date: Mon,  5 Sep 2016 15:42:36 +0100
Message-ID: <20160905144237.2361-6-matt@codeblueprint.co.uk>
References: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160905144237.2361-1-matt@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jeffrey Hugo <jhugo@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

The FDT code directly calls ExitBootServices.  This is inadvisable as the
UEFI spec details a complex set of errors, race conditions, and API
interactions that the caller of ExitBootServices must get correct.  The
FDT code does not handle EFI_INVALID_PARAMETER as required by the spec,
which causes intermittent boot failures on the Qualcomm Technologies
QDF2432.  Call the efi_exit_boot_services() helper intead, which handles
the EFI_INVALID_PARAMETER scenario properly.

Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/libstub/fdt.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index bec0fa8d8746..a6a93116a8f0 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -152,6 +152,27 @@ fdt_set_fail:
 #define EFI_FDT_ALIGN EFI_PAGE_SIZE
 #endif
 
+struct exit_boot_struct {
+	efi_memory_desc_t *runtime_map;
+	int *runtime_entry_count;
+};
+
+static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
+				   struct efi_boot_memmap *map,
+				   void *priv)
+{
+	struct exit_boot_struct *p = priv;
+	/*
+	 * Update the memory map with virtual addresses. The function will also
+	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
+	 * entries so that we can pass it straight to SetVirtualAddressMap()
+	 */
+	efi_get_virtmap(*map->map, *map->map_size, *map->desc_size,
+			p->runtime_map, p->runtime_entry_count);
+
+	return EFI_SUCCESS;
+}
+
 /*
  * Allocate memory for a new FDT, then add EFI, commandline, and
  * initrd related fields to the FDT.  This routine increases the
@@ -183,6 +204,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	efi_status_t status;
 	int runtime_entry_count = 0;
 	struct efi_boot_memmap map;
+	struct exit_boot_struct priv;
 
 	map.map =	&runtime_map;
 	map.map_size =	&map_size;
@@ -257,16 +279,11 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		}
 	}
 
-	/*
-	 * Update the memory map with virtual addresses. The function will also
-	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
-	 * entries so that we can pass it straight into SetVirtualAddressMap()
-	 */
-	efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
-			&runtime_entry_count);
-
-	/* Now we are ready to exit_boot_services.*/
-	status = sys_table->boottime->exit_boot_services(handle, mmap_key);
+	sys_table->boottime->free_pool(memory_map);
+	priv.runtime_map = runtime_map;
+	priv.runtime_entry_count = &runtime_entry_count;
+	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
+					exit_boot_func);
 
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
-- 
2.9.3
