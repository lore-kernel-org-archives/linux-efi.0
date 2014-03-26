From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 5/5] xen: Put EFI machinery in place
Date: Wed, 26 Mar 2014 13:12:14 +0000
Message-ID: <20140326131214.GC24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-6-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395781076-12000-6-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tang Liang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 25 Mar, at 09:57:56PM, Daniel Kiper wrote:
> Put EFI machinery for Xen in place.
> 
> This patch is based on Jan Beulich and Tang Liang work.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Tang Liang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jan Beulich <jbeulich-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/xen/enlighten.c |   10 ++
>  drivers/xen/Kconfig      |    3 +
>  drivers/xen/Makefile     |    1 +
>  drivers/xen/efi.c        |  425 ++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 439 insertions(+)
>  create mode 100644 drivers/xen/efi.c

[...]

> +static void __init efi_init_xen(void)
> +{
> +	efi_char16_t vendor_c16[100];
> +	char vendor[ARRAY_SIZE(vendor_c16)];
> +	int ret, i;
> +	struct xen_platform_op op;
> +	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
> +
> +	efi = efi_xen;
> +	op.cmd = XENPF_firmware_info;
> +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> +
> +	/*
> +	 * Show what we know for posterity
> +	 */
> +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
> +	info->vendor.bufsz = sizeof(vendor_c16);
> +	set_xen_guest_handle(info->vendor.name, vendor_c16);
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (!ret) {
> +		for (i = 0; i < sizeof(vendor) - 1 && vendor_c16[i]; ++i)
> +			vendor[i] = vendor_c16[i];
> +		vendor[i] = '\0';
> +	} else
> +		pr_err("Could not get the firmware vendor!\n");
> +

Is there a reason that you can't just populate an efi_system_table_t
object, which could be used by efi_init(), so that we can save you the
trouble of duplicating all of this code?

> +/*
> + * Convenience functions to obtain memory types and attributes
> + */
> +static u32 efi_mem_type_xen(unsigned long phys_addr)
> +{
> +	struct xen_platform_op op;
> +	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
> +
> +	op.cmd = XENPF_firmware_info;
> +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> +	op.u.firmware_info.index = XEN_FW_EFI_MEM_INFO;
> +	info->mem.addr = phys_addr;
> +	info->mem.size = 0;
> +	return HYPERVISOR_dom0_op(&op) ? 0 : info->mem.type;
> +}

Same idea here. Unless you expect the EFI memory map to change at runtime
(and it's not clear to me whether that wouldn't cause other things to
explode) you'd be better off building a struct efi_memory_map and using
the existing generic functions.

-- 
Matt Fleming, Intel Open Source Technology Center
