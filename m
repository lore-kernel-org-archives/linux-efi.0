From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi: fdt: avoid FDT manipulation after ExitBootServices()
Date: Wed,  1 Feb 2017 17:45:02 +0000
Message-ID: <1485971102-23330-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1485971102-23330-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485971102-23330-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: leif.lindholm@linaro.org, mark.rutland@arm.com, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: linux-arm-kernel@lists.infradead.org, riku.voipio@linaro.org, matt@codeblueprint.co.uk, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Some AArch64 UEFI implementations disable the MMU in ExitBootServices(),
after which unaligned accesses to RAM are no longer supported.

Commit abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the
kernel") fixed an issue in the memory map handling of the stub FDT code,
but inadvertently created an issue with such firmwares, by moving some
of the FDT manipulation to after the invocation of ExitBootServices().
Given that the stub's libfdt implementation uses the ordinary, accelerated
string functions, which rely on hardware handling of unaligned accesses,
manipulating the FDT with the MMU off may result in alignment faults.

So fix the situation by moving the update_fdt_memmap() call into the
callback function invoked by efi_exit_boot_services() right before it
calls the ExitBootServices() UEFI service (which is arguably a better
place for it anyway)

Note that disabling the MMU in ExitBootServices() is not compliant with
the UEFI spec, and carries great risk due to the fact that switching from
cached to uncached memory accesses halfway through compiler generated code
(i.e., involving a stack) can never be done in a way that is architecturally
safe.

Cc: <stable@vger.kernel.org>
Fixes: abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the kernel")
Tested-by: Riku Voipio <riku.voipio@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
