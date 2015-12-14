From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Remove EFI memmap quirk for UV2+
Date: Mon, 14 Dec 2015 09:41:58 +0100
Message-ID: <20151214084157.GB28073@gmail.com>
References: <1449867585-189233-1-git-send-email-athorlton@sgi.com>
 <1449867585-189233-2-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1449867585-189233-2-git-send-email-athorlton-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org> wrote:

> Commit a5d90c923bcf ("x86/efi: Quirk out SGI UV") added a quirk to
> efi_apply_memmap_quirks to force SGI UV systems to fall back to the old
> EFI memmap mechanism.  We have a BIOS fix for this issue on all systems
> except for UV1.  This commit fixes up the EFI quirk/MMR mapping code so
> that we only apply the special case to UV1 hardware.
> 
> Signed-off-by: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
> Cc: Hedi Berriche <hedi-sJ/iWh9BUns@public.gmane.org>
> Cc: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
> Cc: Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |  5 ++++-
>  arch/x86/platform/efi/quirks.c     | 17 +++++++++++++----
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
> index 4a13946..96ba195 100644
> --- a/arch/x86/kernel/apic/x2apic_uv_x.c
> +++ b/arch/x86/kernel/apic/x2apic_uv_x.c
> @@ -888,7 +888,10 @@ void __init uv_system_init(void)
>  		return;
>  	}
>  	pr_info("UV: Found %s hub\n", hub);
> -	map_low_mmrs();
> +
> +	/* We now only need to map the MMRs on UV1 */
> +	if (is_uv1_hub())
> +		map_low_mmrs();
>  
>  	m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
>  	m_val = m_n_config.s.m_skt;
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 1c7380d..2d66db8 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -8,6 +8,7 @@
>  #include <linux/memblock.h>
>  #include <linux/bootmem.h>
>  #include <linux/acpi.h>
> +#include <linux/dmi.h>
>  #include <asm/efi.h>
>  #include <asm/uv/uv.h>
>  
> @@ -248,6 +249,16 @@ out:
>  	return ret;
>  }
>  
> +static const struct dmi_system_id sgi_uv1_dmi[] = {
> +	{ NULL, "SGI UV1",
> +		{	DMI_MATCH(DMI_PRODUCT_NAME,	"Stoutland Platform"),
> +			DMI_MATCH(DMI_PRODUCT_VERSION,	"1.0"),
> +			DMI_MATCH(DMI_BIOS_VENDOR,	"SGI.COM"),
> +		}
> +	},
> +	{ } /* NULL entry stops DMI scanning */
> +};
> +
>  void __init efi_apply_memmap_quirks(void)
>  {
>  	/*
> @@ -260,10 +271,8 @@ void __init efi_apply_memmap_quirks(void)
>  		efi_unmap_memmap();
>  	}
>  
> -	/*
> -	 * UV doesn't support the new EFI pagetable mapping yet.
> -	 */
> -	if (is_uv_system())
> +	/* UV2+ BIOS has a fix for this issue.  UV1 still needs the quirk. */
> +	if (dmi_check_system(sgi_uv1_dmi))
>  		set_bit(EFI_OLD_MEMMAP, &efi.flags);
>  }

Ok, this looks good to me and I'll apply it if it looks good to Matt as well.

This also means we cannot (yet) remove the old memmap code from the EFI code, but 
that's the price of compatibility.

Btw., can UV1 users fix this via a BIOS update? In that case feel free to nudge 
your users via something like:

> +	/* UV2+ BIOS has a fix for this issue.  UV1 still needs the quirk. */
> +	if (dmi_check_system(sgi_uv1_dmi)) {
> +		pr_info("x86/uv: Activating EFI memmap workaround.\n");
> +		pr_info("x86/uv: Please upgrade your BIOS to version x.y.z+ to get rid of this message.\n");
>  		set_bit(EFI_OLD_MEMMAP, &efi.flags);

or so. (But only if it's expected of them to upgrade the BIOS to resolve other 
bugs as well - I personally only upgrade BIOSen if absolutely necessary.)

Thanks,

	Ingo
