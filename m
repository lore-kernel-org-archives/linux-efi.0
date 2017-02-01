From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: fdt: avoid FDT manipulation after ExitBootServices()
Date: Wed,  1 Feb 2017 13:11:33 +0000
Message-ID: <1485954693-25750-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some AArch64 UEFI implementations disable the MMU in ExitBootServices(),
after which unaligned accesses to RAM are no longer supported.

Commit abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the
kernel") fixed an issue in the memory map handling of the stub FDT code,
but inadvertently created an issue with such firmwares, by moving some
of the FDT manipulation to after the invocation of ExitBootServices().
However, the stub's libfdt implementation uses the ordinary, accelerated
string functions, which rely on hardware handling of unaligned accesses,
resulting in alignment faults when executed with the MMU off.

Whether disabling the MMU in ExitBootServices() complies with the UEFI
spec is unclear, but it is a reality we have to deal with, given that
it wasn't a problem before commit abfb7b686a3e was applied.

So fix the situation by moving the update_fdt_memmap() into the callback
invoked by efi_exit_boot_services() right before it hits the button.

Fixes: abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the kernel")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/fdt.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 921dfa047202..260c4b4b492e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -187,6 +187,7 @@ static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
 struct exit_boot_struct {
 	efi_memory_desc_t *runtime_map;
 	int *runtime_entry_count;
+	void *new_fdt_addr;
 };
 
 static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
@@ -202,7 +203,7 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 	efi_get_virtmap(*map->map, *map->map_size, *map->desc_size,
 			p->runtime_map, p->runtime_entry_count);
 
-	return EFI_SUCCESS;
+	return update_fdt_memmap(p->new_fdt_addr, map);
 }
 
 /*
@@ -300,22 +301,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 
 	priv.runtime_map = runtime_map;
 	priv.runtime_entry_count = &runtime_entry_count;
+	priv.new_fdt_addr = (void *)*new_fdt_addr;
 	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
 					exit_boot_func);
 
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
 
-		status = update_fdt_memmap((void *)*new_fdt_addr, &map);
-		if (status != EFI_SUCCESS) {
-			/*
-			 * The kernel won't get far without the memory map, but
-			 * may still be able to print something meaningful so
-			 * return success here.
-			 */
-			return EFI_SUCCESS;
-		}
-
 		/* Install the new virtual address map */
 		svam = sys_table->runtime->set_virtual_address_map;
 		status = svam(runtime_entry_count * desc_size, desc_size,
-- 
2.7.4
