From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] arm64/efi: base UEFI mapping permissions on region
 attributes
Date: Tue, 30 Jun 2015 10:50:48 -0400
Message-ID: <1435675848.21009.10.camel@redhat.com>
References: <1435659443-17625-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1435659443-17625-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435659443-17625-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2015-06-30 at 12:17 +0200, Ard Biesheuvel wrote:

> Currently, we infer the UEFI memory region mapping permissions
> from the memory region type (i.e., runtime services code are
> mapped RWX and runtime services data mapped RW-). This appears to
> work fine but is not entirely UEFI spec compliant. So instead, use
> the designated permission attributes to decide how these regions
> should be mapped.
>=20
> Since UEFIv2.5 introduces a new EFI_MEMORY_RO permission attribute,
> and redefines EFI_MEMORY_WP as a cacheability attribute, use only
> the former as a read-only attribute. For setting the PXN bit, the
> corresponding EFI_MEMORY_XP attribute is used.
>=20
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 32 +++++++++++++-------
>  1 file changed, 21 insertions(+), 11 deletions(-)
>=20
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index ab21e0d58278..5dcab58d5d30 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -247,20 +247,30 @@ static bool __init efi_virtmap_init(void)
>  		memrange_efi_to_native(&paddr, &npages);
>  		size =3D npages << PAGE_SHIFT;
> =20
> -		pr_info("  EFI remap 0x%016llx =3D> %p\n",
> -			md->phys_addr, (void *)md->virt_addr);
> -
> -		/*
> -		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
> -		 * executable, everything else can be mapped with the XN bits
> -		 * set.
> -		 */
>  		if (!is_normal_ram(md))
>  			prot =3D __pgprot(PROT_DEVICE_nGnRE);
> -		else if (md->type =3D=3D EFI_RUNTIME_SERVICES_CODE)
> -			prot =3D PAGE_KERNEL_EXEC;
>  		else
> -			prot =3D PAGE_KERNEL;
> +			prot =3D PAGE_KERNEL_EXEC;
> +
> +		/*
> +		 * On 64 KB granule kernels, only use strict permissions when
> +		 * the region does not share a 64 KB page frame with another
> +		 * region at either end.
> +		 */
> +		if (!IS_ENABLED(CONFIG_ARM64_64K_PAGES) ||
> +		    !(md->virt_addr % PAGE_SIZE ||
> +		      (md->phys_addr + md->num_pages * EFI_PAGE_SIZE) % PAGE_SIZE)=
) {

I think this would read easier with:

		    (PAGE_ALIGNED(md->virt_addr) &&
		      PAGE_ALIGNED(md->phys_addr + md->num_pages * EFI_PAGE_SIZE))) {

> +
> +			if (md->attribute & EFI_MEMORY_RO)
> +				prot |=3D __pgprot(PTE_RDONLY);
> +			if (md->attribute & EFI_MEMORY_XP)
> +				prot |=3D __pgprot(PTE_PXN);
> +		}
> +
> +		pr_info("  EFI remap 0x%016llx =3D> %p (R%c%c)\n",
> +			md->phys_addr, (void *)md->virt_addr,
> +			prot & __pgprot(PTE_RDONLY) ? '-' : 'W',
> +			prot & __pgprot(PTE_PXN) ? '-' : 'X');

You can't maninulate pgprot_t directly like that. It will
break STRICT_MM_TYPECHECKS. You need to use __pgprot_modify()
and/or pgprot_val().

arch/arm64/kernel/efi.c: In function =E2=80=98efi_virtmap_init=E2=80=99=
:
arch/arm64/kernel/efi.c:266:10: error: invalid operands to binary | (ha=
ve =E2=80=98pgprot_t=E2=80=99 and =E2=80=98pgprot_t=E2=80=99)
     prot |=3D __pgprot(PTE_RDONLY);
          ^
   ...
  =20
(In trying that, I see there are a number of other places which
need some STRICT_MM_TYPECHECKS fixing)

> =20
>  		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
>  	}
