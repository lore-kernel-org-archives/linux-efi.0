From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH] efi/libstub: arm*: double cast memory_map to hide compiler warning
Date: Tue, 20 Dec 2016 13:52:07 +0000
Message-ID: <20161220135207.32492-1-james.morse@arm.com>
References: <20161220113956.GB2225@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220113956.GB2225-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, kbuild-all-JC7UmRfGjtg@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

"efi/libstub: arm*: Pass latest memory map to the kernel" added a new
call to update fdt in-place. This caused a new warning on 32bit ARM:

../drivers/firmware/efi/libstub/fdt.c: In function 'allocate_new_fdt_and_exit_boot':
../drivers/firmware/efi/libstub/fdt.c:303:9: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
         (u64)memory_map, (u32)map_size);
         ^

Cast to an integer of native pointer size first.

Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
---
I guess this too needs to go to stable unless you intend to squash it?

 drivers/firmware/efi/libstub/fdt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 6d33d70..9b11b05 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -300,7 +300,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		efi_set_virtual_address_map_t *svam;
 
 		status = update_fdt_memmap((void *)*new_fdt_addr,
-					   (u64)memory_map, (u32)map_size);
+					   (u64)(unsigned long)memory_map,
+					   (u32)map_size);
 		if (status != EFI_SUCCESS) {
 			/*
 			 * The kernel won't get far without the memory map, but
-- 
2.10.1
