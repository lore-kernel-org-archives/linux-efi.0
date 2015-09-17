From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub parameters
Date: Thu, 17 Sep 2015 19:43:40 +0800
Message-ID: <55FAA76C.4070607@huawei.com>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: xen-devel@lists.xen.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, freebsd-arm@freebsd.org, matt.fleming@intel.com, ard.biesheuvel@linaro.org, leif.lindholm@linaro.org, ian.campbell@citrix.com, stefano.stabellini@eu.citrix.com, julien.grall@citrix.com, jbeulich@suse.com, christoffer.dall@linaro.org, peter.huangpeng@huawei.com, shannon.zhao@linaro.org
List-Id: linux-efi@vger.kernel.org

Hi,

>From the comments on this patch, IIUC, we don't object to the change
brought by this patch. What we didn't reach an agreement is how to
support runtime service for Dom0. Right? If so, I think this patch
doesn't conflict with adding support for runtime service in the future.
So could we move this patch forward? Then I could continue working on
adding ARM ACPI support on Xen.

Any comments?

Thanks,
-- 
Shannon

On 2015/9/10 16:41, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> These EFI stub parameters are used to internal communication between EFI
> stub and Linux kernel and EFI stub creates these parameters. But for Xen
> on ARM when booting with UEFI, Xen will create a minimal DT providing
> these parameters for Dom0 and Dom0 is not only Linux kernel, but also
> other OS (such as FreeBSD) which will be used in the future. So here
> we plan to standardize the names by dropping the prefix "linux," and
> make them common to other OS. Also this will not break the compatibility
> since these parameters are used to internal communication between EFI
> stub and kernel.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
> Look at [1] for the discussion about this in Xen ML. The purpose of this
> patch is to standardize the names to make Linux ARM kernel work on Xen
> with UEFI. Also it hopes other OS(e.g. FreeBSD), which will be used as
> Dom0 on Xen, could support this mechanism as well.
> 
> [1]http://lists.xenproject.org/archives/html/xen-devel/2015-08/msg02250.html
> 
>  Documentation/arm/uefi.txt         | 10 +++++-----
>  drivers/firmware/efi/efi.c         | 10 +++++-----
>  drivers/firmware/efi/libstub/fdt.c | 10 +++++-----
>  3 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> index d60030a..8c83243 100644
> --- a/Documentation/arm/uefi.txt
> +++ b/Documentation/arm/uefi.txt
> @@ -45,18 +45,18 @@ following parameters:
>  ________________________________________________________________________________
>  Name                      | Size   | Description
>  ================================================================================
> -linux,uefi-system-table   | 64-bit | Physical address of the UEFI System Table.
> +uefi-system-table         | 64-bit | Physical address of the UEFI System Table.
>  --------------------------------------------------------------------------------
> -linux,uefi-mmap-start     | 64-bit | Physical address of the UEFI memory map,
> +uefi-mmap-start           | 64-bit | Physical address of the UEFI memory map,
>                            |        | populated by the UEFI GetMemoryMap() call.
>  --------------------------------------------------------------------------------
> -linux,uefi-mmap-size      | 32-bit | Size in bytes of the UEFI memory map
> +uefi-mmap-size            | 32-bit | Size in bytes of the UEFI memory map
>                            |        | pointed to in previous entry.
>  --------------------------------------------------------------------------------
> -linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
> +uefi-mmap-desc-size       | 32-bit | Size in bytes of each entry in the UEFI
>                            |        | memory map.
>  --------------------------------------------------------------------------------
> -linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
> +uefi-mmap-desc-ver        | 32-bit | Version of the mmap descriptor format.
>  --------------------------------------------------------------------------------
>  linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
>  --------------------------------------------------------------------------------
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index d6144e3..3878715 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -481,11 +481,11 @@ static __initdata struct {
>  	int offset;
>  	int size;
>  } dt_params[] = {
> -	UEFI_PARAM("System Table", "linux,uefi-system-table", system_table),
> -	UEFI_PARAM("MemMap Address", "linux,uefi-mmap-start", mmap),
> -	UEFI_PARAM("MemMap Size", "linux,uefi-mmap-size", mmap_size),
> -	UEFI_PARAM("MemMap Desc. Size", "linux,uefi-mmap-desc-size", desc_size),
> -	UEFI_PARAM("MemMap Desc. Version", "linux,uefi-mmap-desc-ver", desc_ver)
> +	UEFI_PARAM("System Table", "uefi-system-table", system_table),
> +	UEFI_PARAM("MemMap Address", "uefi-mmap-start", mmap),
> +	UEFI_PARAM("MemMap Size", "uefi-mmap-size", mmap_size),
> +	UEFI_PARAM("MemMap Desc. Size", "uefi-mmap-desc-size", desc_size),
> +	UEFI_PARAM("MemMap Desc. Version", "uefi-mmap-desc-ver", desc_ver)
>  };
>  
>  struct param_info {
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index ef5d764..e94589a 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -118,31 +118,31 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>  	/* Add FDT entries for EFI runtime services in chosen node. */
>  	node = fdt_subnode_offset(fdt, 0, "chosen");
>  	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)sys_table);
> -	status = fdt_setprop(fdt, node, "linux,uefi-system-table",
> +	status = fdt_setprop(fdt, node, "uefi-system-table",
>  			     &fdt_val64, sizeof(fdt_val64));
>  	if (status)
>  		goto fdt_set_fail;
>  
>  	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
> -	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
> +	status = fdt_setprop(fdt, node, "uefi-mmap-start",
>  			     &fdt_val64,  sizeof(fdt_val64));
>  	if (status)
>  		goto fdt_set_fail;
>  
>  	fdt_val32 = cpu_to_fdt32(map_size);
> -	status = fdt_setprop(fdt, node, "linux,uefi-mmap-size",
> +	status = fdt_setprop(fdt, node, "uefi-mmap-size",
>  			     &fdt_val32,  sizeof(fdt_val32));
>  	if (status)
>  		goto fdt_set_fail;
>  
>  	fdt_val32 = cpu_to_fdt32(desc_size);
> -	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-size",
> +	status = fdt_setprop(fdt, node, "uefi-mmap-desc-size",
>  			     &fdt_val32, sizeof(fdt_val32));
>  	if (status)
>  		goto fdt_set_fail;
>  
>  	fdt_val32 = cpu_to_fdt32(desc_ver);
> -	status = fdt_setprop(fdt, node, "linux,uefi-mmap-desc-ver",
> +	status = fdt_setprop(fdt, node, "uefi-mmap-desc-ver",
>  			     &fdt_val32, sizeof(fdt_val32));
>  	if (status)
>  		goto fdt_set_fail;
> 

