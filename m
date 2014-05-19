From: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
Date: Mon, 19 May 2014 22:46:57 +0200
Message-ID: <20140519204657.GB3529@olila.local.net-space.pl>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
 <537A23A50200007800013A7F@mail.emea.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <537A23A50200007800013A7F-tRfBTM6QL9aeHWOVceGJHFaTQe2KTcn/@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, May 19, 2014 at 02:30:45PM +0100, Jan Beulich wrote:
> >>> On 16.05.14 at 22:41, <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > @@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
> >  	efi_unmap_memmap();
> >  }
> >
> > +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> > +							unsigned long size)
> > +{
> > +	if (efi_enabled(EFI_DIRECT))
> > +		return early_ioremap(phys_addr, size);
> > +
> > +	return (__force void __iomem *)phys_addr;
>
> Now that surely needs some explanation: I can't see how this can
> ever be correct, Xen or not being completely irrelevant.

I hope that efi_enabled(EFI_DIRECT) is obvious. However, in case of
!efi_enabled(EFI_DIRECT) some structures are created artificially
and they live in virtual address space. So that is why they should
not be mapped. If you wish I could add relevant comment here.

Daniel
