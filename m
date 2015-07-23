From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] arm64/efi: prefer AllocatePages() over efi_low_alloc() for vmlinux
Date: Thu, 23 Jul 2015 15:23:07 +0200
Message-ID: <1437657787-19946-1-git-send-email-ard.biesheuvel@linaro.org>
References: <55B0D4E4.9030403@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55B0D4E4.9030403-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, edk2-devel-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello Haojian,

Could you please try this version instead?

-- 
Ard.

-------8<---------

When allocating memory for the kernel image, try the AllocatePages()
boot service to obtain memory at the preferred offset of
'dram_base + TEXT_OFFSET', and only revert to efi_low_alloc() if that
fails. This is the only way to allocate at the base of DRAM if DRAM
starts at 0x0, since efi_low_alloc() refuses to allocate at 0x0.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
v2:
- set *reserve_addr before calling AllocatePages()

 arch/arm64/kernel/efi-stub.c | 45 ++++++++++++++++----
 1 file changed, 37 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index f5374065ad53..894cad555955 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -13,7 +13,7 @@
 #include <asm/efi.h>
 #include <asm/sections.h>
 
-efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table,
+efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 					unsigned long *image_addr,
 					unsigned long *image_size,
 					unsigned long *reserve_addr,
@@ -23,21 +23,50 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table,
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
+	unsigned long pgnum;
 
 	/* Relocate the image, if required. */
 	kernel_size = _edata - _text;
 	if (*image_addr != (dram_base + TEXT_OFFSET)) {
 		kernel_memsize = kernel_size + (_end - _edata);
-		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
-				       SZ_2M, reserve_addr);
+
+		//
+		// First, try a straight allocation at the preferred offset.
+		// This will work around the issue where, if dram_base == 0x0,
+		// efi_low_alloc() refuses to allocate at 0x0 (to prevent the
+		// address of the allocation to be mistaken for a FAIL return
+		// value or a NULL pointer). It will also ensure that, on
+		// platforms where the [dram_base, dram_base + TEXT_OFFSET)
+		// interval is partially occupied by the firmware (like on APM
+		// Mustang), we can still place the kernel at the address
+		// 'dram_base + TEXT_OFFSET'.
+		//
+		pgnum = round_up(kernel_memsize, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+		status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
+					EFI_LOADER_DATA, pgnum,
+					(efi_physical_addr_t *)reserve_addr);
+		if (status == EFI_SUCCESS) {
+			memcpy((void *)*reserve_addr, (void *)*image_addr,
+			       kernel_size);
+			*image_addr = *reserve_addr;
+			*reserve_size = kernel_memsize;
+		} else {
+			status = efi_low_alloc(sys_table_arg,
+					       kernel_memsize + TEXT_OFFSET,
+					       SZ_2M, reserve_addr);
+
+			if (status == EFI_SUCCESS) {
+				memcpy((void *)*reserve_addr + TEXT_OFFSET,
+				       (void *)*image_addr,
+				       kernel_size);
+				*image_addr = *reserve_addr + TEXT_OFFSET;
+				*reserve_size = kernel_memsize + TEXT_OFFSET;
+			}
+		}
 		if (status != EFI_SUCCESS) {
-			pr_efi_err(sys_table, "Failed to relocate kernel\n");
+			pr_efi_err(sys_table_arg, "Failed to relocate kernel\n");
 			return status;
 		}
-		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
-		       kernel_size);
-		*image_addr = *reserve_addr + TEXT_OFFSET;
-		*reserve_size = kernel_memsize + TEXT_OFFSET;
 	}
 
 
-- 
1.9.1
