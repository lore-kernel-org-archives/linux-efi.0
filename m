From: Linn Crosetto <linn-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCHv3] x86: EFI stub support for large memory maps
Date: Fri, 27 Sep 2013 17:46:07 -0600
Message-ID: <20130927234607.GA17867@oranje.fc.hp.com>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
 <1379901548-70954-1-git-send-email-linn@hp.com>
 <20130925125840.GK21381@console-pimps.org>
 <20130925224541.GT13098@oranje.fc.hp.com>
 <20130926113400.GM21381@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130926113400.GM21381-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Sep 26, 2013 at 12:34:00PM +0100, Matt Fleming wrote:
> > I might add the following to your merge for semantic reasons:
> > 
> > diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> > index 04b228d..a7677ba 100644
> > --- a/arch/x86/boot/compressed/eboot.c
> > +++ b/arch/x86/boot/compressed/eboot.c
> > @@ -730,6 +730,8 @@ get_map:
> >         boot_params->alt_mem_k = 32 * 1024;
> >  
> >         status = setup_e820(boot_params, e820ext, e820ext_size);
> > +       if (status != EFI_SUCCESS)
> > +               return status;
> >  
> >         return EFI_SUCCESS;
> 
> Aha, nice catch! Though if setup_e820() fails we should be jumping to
> the 'free_mem_map' label so we don't leak the memory map, like so,
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 04b228d..602950b 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -730,8 +730,8 @@ get_map:
>  	boot_params->alt_mem_k = 32 * 1024;
>  
>  	status = setup_e820(boot_params, e820ext, e820ext_size);
> -
> -	return EFI_SUCCESS;
> +	if (status == EFI_SUCCESS)
> +		return status;
>  
>  free_mem_map:
>  	efi_call_phys1(sys_table->boottime->free_pool, mem_map);

Given that we have already successfully called exit_boot_services, can we still
make this call to free_pool?
