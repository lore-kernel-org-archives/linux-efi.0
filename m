From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3 1/5] efi: Add efi_init_ops variable
Date: Wed, 26 Mar 2014 12:56:23 +0000
Message-ID: <20140326125623.GA24856@console-pimps.org>
References: <1395781076-12000-1-git-send-email-daniel.kiper@oracle.com>
 <1395781076-12000-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395781076-12000-2-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Tang Liang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 25 Mar, at 09:57:52PM, Daniel Kiper wrote:
> Add efi_init_ops variable which allows us to replace
> EFI init functions on Xen with its specific stuff.
> 
> This patch is based on Jan Beulich and Tang Liang work.
> 
> Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Tang Liang <liang.tang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/ia64/kernel/efi.c      |   30 +++++++++++++++++++++---------
>  arch/x86/platform/efi/efi.c |   18 +++++++++++++-----
>  drivers/firmware/efi/efi.c  |   26 ++++++++++++++++++++++++++
>  include/linux/efi.h         |    8 ++++++++
>  4 files changed, 68 insertions(+), 14 deletions(-)

[...]

> @@ -1118,6 +1118,14 @@ u64 efi_mem_attributes(unsigned long phys_addr)
>  	return 0;
>  }
>  
> +struct efi_init_ops efi_init_ops = {
> +	.efi_init = efi_init_generic,
> +	.efi_reserve_boot_services = efi_reserve_boot_services_generic,
> +	.efi_enter_virtual_mode = efi_enter_virtual_mode_generic,
> +	.efi_mem_type = efi_mem_type_generic,
> +	.efi_mem_attributes = efi_mem_attributes_generic
> +};

Please don't create another struct of EFI function pointers.

After this we'll have 3 global efi structures defintions and 4 global
efi objects on x86,

  - struct efi_early [in the boot stub]
  - struct efi ['efi_phys' before/'efi' after SetVirtualAddressMap()]
  - struct efi_init_ops [for the benefit of xen]

I have a big problem with exposing .efi_reserve_boot_services as an API.

Also, the fact that in later patches you're copying chunks of the x86
virt_*() funtions suggests to me that this has been implemented at the
wrong layer, because it actively discourages sharing code between x86
and Xen.

-- 
Matt Fleming, Intel Open Source Technology Center
