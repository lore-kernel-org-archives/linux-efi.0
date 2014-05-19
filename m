From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Date: Mon, 19 May 2014 23:02:55 +0200
Message-ID: <20140519210255.GC3529@olila.local.net-space.pl>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
 <537A2A28.4010903@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <537A2A28.4010903-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, May 19, 2014 at 04:58:32PM +0100, David Vrabel wrote:
> On 16/05/14 21:41, Daniel Kiper wrote:
> > Introduce EFI_DIRECT flag. If it is set this means that Linux
> > Kernel has direct access to EFI infrastructure. If not then
> > kernel runs on EFI platform but it has not direct control
> > on EFI stuff. This functionality is used in Xen dom0.
>
> This is backwards.  It should flag should indicate the weird platform
> not the standard, default one.

Do you wish EFI_NO_DIRECT? I understand your idea but I would like to avoid this
name because it is quite difficult to read e.g. !efi_enabled(EFI_NO_DIRECT).
You must think a bit to know what is going on. However, maybe you have a better idea?

> You also need to explain why this is needed rather than presenting a
> more complete EFI interface to PV guests.  And you should explain why
> each use is necessary.

OK.

> > +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> > +							unsigned long size)
> > +{
> > +	if (efi_enabled(EFI_DIRECT))
> > +		return early_ioremap(phys_addr, size);
> > +
> > +	return (__force void __iomem *)phys_addr;
> > +}
>
> Er...  Perhaps you mean BUG_ON(!efi_enabled(EFI_DIRECT))? Or return NULL?

It is correct. As I said earlier: in case of !efi_enabled(EFI_DIRECT) some
structures are created artificially and they live in virtual address space.
So that is why they should not be mapped.

> > --- a/include/linux/efi.h
> > +++ b/include/linux/efi.h
> > @@ -893,12 +893,13 @@ extern int __init efi_setup_pcdp_console(char *);
> >   * possible, remove EFI-related code altogether.
> >   */
> >  #define EFI_BOOT		0	/* Were we booted from EFI? */
> > -#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
> > -#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
> > -#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
> > -#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
> > -#define EFI_64BIT		5	/* Is the firmware 64-bit? */
> > -#define EFI_ARCH_1		6	/* First arch-specific bit */
> > +#define EFI_DIRECT		1	/* Can we access EFI directly? */
> > +#define EFI_SYSTEM_TABLES	2	/* Can we use EFI system tables? */
> > +#define EFI_CONFIG_TABLES	3	/* Can we use EFI config tables? */
> > +#define EFI_RUNTIME_SERVICES	4	/* Can we use runtime services? */
> > +#define EFI_MEMMAP		5	/* Can we use EFI memory map? */
> > +#define EFI_64BIT		6	/* Is the firmware 64-bit? */
> > +#define EFI_ARCH_1		7	/* First arch-specific bit */
>
> Unnecessary shuffling of these values.  Why didn't you stick it after
> EFI_64BIT?

I was going to have EFI_DIRECT close to EFI_BOOT which is quite generic
and platform independent name like EFI_BOOT. However, I do not insist
on having it in that place.

Daniel
