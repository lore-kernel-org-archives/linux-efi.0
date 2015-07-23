From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [edk2] [PATCH v3] arm64/efi: prefer AllocatePages() over
	efi_low_alloc() for vmlinux
Date: Thu, 23 Jul 2015 15:25:06 +0200
Message-ID: <1437657906-20034-1-git-send-email-ard.biesheuvel@linaro.org>
References: <55B0D4E4.9030403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <edk2-devel-bounces@lists.01.org>
In-Reply-To: <55B0D4E4.9030403@redhat.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=unsubscribe>
List-Post: <mailto:edk2-devel@lists.01.org>
List-Help: <mailto:edk2-devel-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/edk2-devel>,
 <mailto:edk2-devel-request@lists.01.org?subject=subscribe>
Errors-To: edk2-devel-bounces@lists.01.org
Sender: "edk2-devel" <edk2-devel-bounces@lists.01.org>
To: lersek@redhat.com, matt.fleming@intel.com, leif.lindholm@linaro.org, haojian.zhuang@linaro.org, edk2-devel@lists.01.org
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

Hello Haojian,

Apologies for the noise ...

Could you please try *this* version v3 instead? v2 is just the same patch as
before ...

-- 
Ard.

-------8<---------

When allocating memory for the kernel image, try the AllocatePages()
boot service to obtain memory at the preferred offset of
'dram_base + TEXT_OFFSET', and only revert to efi_low_alloc() if that
fails. This is the only way to allocate at the base of DRAM if DRAM
starts at 0x0, since efi_low_alloc() refuses to allocate at 0x0.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
v3:
- set *reserve_addr before calling AllocatePages()

 arch/arm64/kernel/efi-stub.c | 47 ++++++++++++++++----
 1 file changed, 39 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index f5374065ad53..c8df74d14368 100644
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
@@ -23,21 +23,52 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table,
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
+	unsigned long nr_pages;
 
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
+		*reserve_addr = dram_base + TEXT_OFFSET;
+		nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
+			   EFI_PAGE_SIZE;
+		status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
+					EFI_LOADER_DATA, nr_pages,
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
