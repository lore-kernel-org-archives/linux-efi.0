From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] efi/libstub/fdt: Standardize the names of EFI stub
 parameters
Date: Thu, 10 Sep 2015 10:52:09 +0100
Message-ID: <20150910095208.GA29293@leverpostej>
References: <1441874516-11364-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1441874516-11364-1-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <Ian.Campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org" <xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org>, "julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org" <julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, "freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org" <freebsd-arm-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "jbeulich-IBi9RG/b67k@public.gmane.org" <jbeulich-IBi9RG/b67k@public.gmane.org>, "peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, stefano.stabellini-mvvWK6WmYck@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

I'm not necessarily opposed to the renaming, but I think that this is
the least important thing to standardize for this to work.

On Thu, Sep 10, 2015 at 09:41:56AM +0100, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> These EFI stub parameters are used to internal communication between EFI
> stub and Linux kernel and EFI stub creates these parameters. But for Xen
> on ARM when booting with UEFI, Xen will create a minimal DT providing
> these parameters for Dom0 and Dom0 is not only Linux kernel, but also
> other OS (such as FreeBSD) which will be used in the future.

Currently the Linux EFI stub and kernel have a symbiotic relationship,
because they're intimately coupled and we don't have kexec (yet) on EFI
platforms to loosen that coupling.

If an agent other than the (kernel-specific) stub is going to provide
this to the kernel, then we need more specified than just the property
names.

That at least includes the following:

* The state of boot services (we currently have the EFI stub call
  ExitBootServices(), and I believe this is crucial to the plan for
  kexec).

* The state of the address map (we currently have the EFI stub call
  SetVirtualAddressMap()).

* The virtual address range(s) that SetVirtualAddressMap() may map
  elements to (this logic is currently in the EFI stub, and this matches
  the expectations of the kernel that it is tied to).

> So here we plan to standardize the names by dropping the prefix
> "linux," and make them common to other OS. Also this will not break
> the compatibility since these parameters are used to internal
> communication between EFI stub and kernel.

For the moment this is true, but will not be once we have kexec, so
there's a dependency (or anti-dependency) there.

> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> Look at [1] for the discussion about this in Xen ML. The purpose of this
> patch is to standardize the names to make Linux ARM kernel work on Xen
> with UEFI. Also it hopes other OS(e.g. FreeBSD), which will be used as
> Dom0 on Xen, could support this mechanism as well.
> 
> [1]http://lists.xenproject.org/archives/html/xen-devel/2015-08/msg02250.html

Per this post, it looks like to pass a DTB to the kernel Xen already
needs to know it's a Linux kernel...

I wasn't aware that there was a common standard for arm(64) kernels
other than a PE/COFF EFI application.

Does Xen not talk to EFI itself and/or give the kernel a virtual EFI
interface?

Thanks,
Mark.

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
> -- 
> 2.0.4
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
