From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is
 occupied
Date: Mon, 14 Jul 2014 14:40:48 -0400
Message-ID: <1405363248.25580.12.camel@deneb.redhat.com>
References: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405351521-12010-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-07-14 at 17:25 +0200, Ard Biesheuvel wrote:
> If we fail to relocate the kernel Image to its preferred offset of TEXT_OFFSET
> bytes above the base of DRAM, accept the lowest alternative mapping available
> instead of aborting. We may lose a bit of memory at the low end, but we can
> still proceed normally otherwise.

This breaks APM Mustang because the spin-table holding pen for secondary
CPUs is marked as reserved memory in the TEXT_OFFSET area and the kernel
placement using your patch makes it unreachable by kernel. Here is a
patch I've been working with to solve the same problem:

From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Thu, 10 Jul 2014 09:25:30 -0400
Subject: [PATCH] arm64/efi: try to handle firmware located below kernel

The rule for arm64 kernel image placement is that it must be located
TEXT_OFFSET bytes past a 2MiB boundary. The kernel itself will use the
TEXT_OFFSET sized area for initial page tables but that area is not
part of the kernel image itself.

The current EFI stub code finds the base of DRAM from the EFI memmap
and relocates the kernel to dram_base+TEXT_OFFSET. This assumes that
the low memory is not being used and the kernel relocation simply
fails if the base memory allocation fails.

At least one vendor has firmware which occupies memory near dram_base
so kernel relocations always fail. This patch attempts to work with
such firmware by searching the EFI memmap for the lowest available
memory which may be used for the kernel image. There are several
pitfalls remaining which may lead to boot failure:

  * The stub does not allocate the TEXT_OFFSET region, so it is
    required that the firmware not be using that area for anything
    which may interfere or overlap with the initial kernel page
    tables. We can't simply include that area in our search for
    available memory because firmware using the spin-table method
    for booting secondary CPUs may place the CPU pen in an out of
    the way part of that region and mark it as reserved memory.

  * The current code requires FDT to be placed within first 512MiB
    of DRAM (with the kernel below it). This requirement can be
    removed in the future, but would involve changes to generic
    stub code shared by other architectures.

Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c | 45 +++++++++++++++++++++++++++++++++++++-------
 arch/arm64/kernel/efi.c      | 19 ++++++++++++++++---
 2 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 60e98a63..f5da27f 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -54,21 +54,53 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 					efi_loaded_image_t *image)
 {
 	efi_status_t status;
-	unsigned long kernel_size, kernel_memsize = 0;
+	unsigned long kernel_size, kernel_memsize;
+	unsigned long desired_base = dram_base + TEXT_OFFSET;
+	unsigned long desired_end;
+	unsigned long map_size;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
 
 	/* Relocate the image, if required. */
 	kernel_size = _edata - _text;
-	if (*image_addr != (dram_base + TEXT_OFFSET)) {
-		kernel_memsize = kernel_size + (_end - _edata);
+	kernel_memsize = kernel_size + (_end - _edata);
+
+	desired_end = desired_base + kernel_size;
+
+	/* find lowest available address for kernel to live */
+	status = efi_get_memory_map(sys_table, (efi_memory_desc_t **)&map.map,
+				    &map_size, &map.desc_size, NULL, NULL);
+	if (status == EFI_SUCCESS) {
+		map.map_end = map.map + map_size;
+		for_each_efi_memory_desc(&map, md) {
+			unsigned long start, end, offset;
+			if (!(md->attribute & EFI_MEMORY_WB))
+				continue;
+			if (md->type != EFI_CONVENTIONAL_MEMORY)
+				continue;
+			start = md->phys_addr;
+			end = start + (md->num_pages << EFI_PAGE_SHIFT);
+			offset = start & (SZ_2M - 1);
+			if (offset < TEXT_OFFSET)
+				start += (TEXT_OFFSET - offset);
+			else if (offset > TEXT_OFFSET)
+				start = ALIGN(start, SZ_2M) + TEXT_OFFSET;
+			if (start < end && (start + kernel_memsize) <= end) {
+				desired_base = start;
+				break;
+			}
+		}
+	}
+
+	if (*image_addr != desired_base) {
 		status = efi_relocate_kernel(sys_table, image_addr,
 					     kernel_size, kernel_memsize,
-					     dram_base + TEXT_OFFSET,
-					     PAGE_SIZE);
+					     desired_base, PAGE_SIZE);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to relocate kernel\n");
 			return status;
 		}
-		if (*image_addr != (dram_base + TEXT_OFFSET)) {
+		if (*image_addr != desired_base) {
 			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
 			efi_free(sys_table, kernel_memsize, *image_addr);
 			return EFI_ERROR;
@@ -76,6 +108,5 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 		*image_size = kernel_memsize;
 	}
 
-
 	return EFI_SUCCESS;
 }
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 453b7f8..2bc6469 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -180,9 +180,18 @@ static __init void reserve_regions(void)
 		if (is_reserve_region(md) ||
 		    md->type == EFI_BOOT_SERVICES_CODE ||
 		    md->type == EFI_BOOT_SERVICES_DATA) {
-			memblock_reserve(paddr, size);
-			if (uefi_debug)
-				pr_cont("*");
+			if (paddr < PHYS_OFFSET) {
+				if ((paddr + size) > PHYS_OFFSET) {
+					size -= (PHYS_OFFSET - paddr);
+					memblock_reserve(PHYS_OFFSET, size);
+					if (uefi_debug)
+						pr_cont("**");
+				}
+			} else {
+				memblock_reserve(paddr, size);
+				if (uefi_debug)
+					pr_cont("*");
+			}
 		}
 
 		if (uefi_debug)
@@ -273,6 +282,10 @@ static void __init free_boot_services(void)
 			continue;
 		}
 
+		/* Don't free anything below kernel */
+		if (md->phys_addr < PHYS_OFFSET)
+			continue;
+
 		/*
 		 * We want to free memory from this region.
 		 */
-- 
1.8.3.1



> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> This is a proposed bug fix for arm64 platforms that fail to boot through EFI
> due to the fact that some bits of EFI itself are occupying the low end of DRAM. 
> 
> Note that this code now triggers an 'unused function' warning for
> efi_relocate_kernel(), as that is no longer used. This warning will disappear
> automatically once the already queued up EFISTUB refactoring patches will
> get merged for 3.17.
> 
>  arch/arm64/kernel/efi-stub.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> index 60e98a639ac5..5165b3accefe 100644
> --- a/arch/arm64/kernel/efi-stub.c
> +++ b/arch/arm64/kernel/efi-stub.c
> @@ -60,20 +60,16 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>  	kernel_size = _edata - _text;
>  	if (*image_addr != (dram_base + TEXT_OFFSET)) {
>  		kernel_memsize = kernel_size + (_end - _edata);
> -		status = efi_relocate_kernel(sys_table, image_addr,
> -					     kernel_size, kernel_memsize,
> -					     dram_base + TEXT_OFFSET,
> -					     PAGE_SIZE);
> +		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
> +				       SZ_2M, reserve_addr);
>  		if (status != EFI_SUCCESS) {
>  			pr_efi_err(sys_table, "Failed to relocate kernel\n");
>  			return status;
>  		}
> -		if (*image_addr != (dram_base + TEXT_OFFSET)) {
> -			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
> -			efi_free(sys_table, kernel_memsize, *image_addr);
> -			return EFI_ERROR;
> -		}
> -		*image_size = kernel_memsize;
> +		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
> +		       kernel_size);
> +		*image_addr = *reserve_addr + TEXT_OFFSET;
> +		*reserve_size = kernel_memsize;
>  	}
> 
> 
