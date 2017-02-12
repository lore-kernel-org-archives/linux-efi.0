From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi: arm-stub: Round up FDT allocation to mapping
 size
Date: Sun, 12 Feb 2017 13:10:56 -0700
Message-ID: <9355065f-5782-e935-e8dc-9f6c0676b7f2@codeaurora.org>
References: <1486676573-19237-1-git-send-email-ard.biesheuvel@linaro.org>
 <1486676573-19237-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1486676573-19237-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 2/9/2017 2:42 PM, Ard Biesheuvel wrote:
> The FDT is mapped via a fixmap entry that is at least 2 MB in size and
> 2 MB aligned on 4 KB page size kernels.
>
> On UEFI systems, the FDT allocation may share this 2 MB block with a
> reserved region, or another memory region that we should never map,
> unless we account for this in the size of the allocation (the alignment
> is already 2 MB)
>
> So instead of taking guesses at the needed space, simply allocate 2 MB
> immediately. The allocation will be recorded as a EFI_LOADER_DATA, and
> the kernel only memblock_reserve()'s the actual size of the FDT, so the
> unused space will be released to the kernel.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---

Reviewed-By: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

>  arch/arm64/include/asm/efi.h       |  1 +
>  drivers/firmware/efi/libstub/fdt.c | 57 +++++++++-----------
>  2 files changed, 25 insertions(+), 33 deletions(-)
>
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index 342e90d6d204..f642565fc1d0 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -1,6 +1,7 @@
>  #ifndef _ASM_EFI_H
>  #define _ASM_EFI_H
>
> +#include <asm/boot.h>
>  #include <asm/cpufeature.h>
>  #include <asm/io.h>
>  #include <asm/mmu_context.h>
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index 260c4b4b492e..41f457be64e8 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -206,6 +206,10 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
>  	return update_fdt_memmap(p->new_fdt_addr, map);
>  }
>
> +#ifndef MAX_FDT_SIZE
> +#define MAX_FDT_SIZE	SZ_2M
> +#endif
> +
>  /*
>   * Allocate memory for a new FDT, then add EFI, commandline, and
>   * initrd related fields to the FDT.  This routine increases the
> @@ -233,7 +237,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  	u32 desc_ver;
>  	unsigned long mmap_key;
>  	efi_memory_desc_t *memory_map, *runtime_map;
> -	unsigned long new_fdt_size;
>  	efi_status_t status;
>  	int runtime_entry_count = 0;
>  	struct efi_boot_memmap map;
> @@ -262,41 +265,29 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  	       "Exiting boot services and installing virtual address map...\n");
>
>  	map.map = &memory_map;
> +	status = efi_high_alloc(sys_table, MAX_FDT_SIZE, EFI_FDT_ALIGN,
> +				new_fdt_addr, max_addr);
> +	if (status != EFI_SUCCESS) {
> +		pr_efi_err(sys_table,
> +			   "Unable to allocate memory for new device tree.\n");
> +		goto fail;
> +	}
> +
>  	/*
> -	 * Estimate size of new FDT, and allocate memory for it. We
> -	 * will allocate a bigger buffer if this ends up being too
> -	 * small, so a rough guess is OK here.
> +	 * Now that we have done our final memory allocation (and free)
> +	 * we can get the memory map key needed for exit_boot_services().
>  	 */
> -	new_fdt_size = fdt_size + EFI_PAGE_SIZE;
> -	while (1) {
> -		status = efi_high_alloc(sys_table, new_fdt_size, EFI_FDT_ALIGN,
> -					new_fdt_addr, max_addr);
> -		if (status != EFI_SUCCESS) {
> -			pr_efi_err(sys_table, "Unable to allocate memory for new device tree.\n");
> -			goto fail;
> -		}
> -
> -		status = update_fdt(sys_table,
> -				    (void *)fdt_addr, fdt_size,
> -				    (void *)*new_fdt_addr, new_fdt_size,
> -				    cmdline_ptr, initrd_addr, initrd_size);
> +	status = efi_get_memory_map(sys_table, &map);
> +	if (status != EFI_SUCCESS)
> +		goto fail_free_new_fdt;
>
> -		/* Succeeding the first time is the expected case. */
> -		if (status == EFI_SUCCESS)
> -			break;
> +	status = update_fdt(sys_table, (void *)fdt_addr, fdt_size,
> +			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
> +			    initrd_addr, initrd_size);
>
> -		if (status == EFI_BUFFER_TOO_SMALL) {
> -			/*
> -			 * We need to allocate more space for the new
> -			 * device tree, so free existing buffer that is
> -			 * too small.
> -			 */
> -			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
> -			new_fdt_size += EFI_PAGE_SIZE;
> -		} else {
> -			pr_efi_err(sys_table, "Unable to construct new device tree.\n");
> -			goto fail_free_new_fdt;
> -		}
> +	if (status != EFI_SUCCESS) {
> +		pr_efi_err(sys_table, "Unable to construct new device tree.\n");
> +		goto fail_free_new_fdt;
>  	}
>
>  	priv.runtime_map = runtime_map;
> @@ -340,7 +331,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>  	pr_efi_err(sys_table, "Exit boot services failed.\n");
>
>  fail_free_new_fdt:
> -	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
> +	efi_free(sys_table, MAX_FDT_SIZE, *new_fdt_addr);
>
>  fail:
>  	sys_table->boottime->free_pool(runtime_map);
>


-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
