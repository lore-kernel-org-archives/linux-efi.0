From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/11] efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
Date: Sat, 21 Sep 2013 17:59:15 +0200
Message-ID: <20130921155914.GH2737@rocoto.smurfnet.nu>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-3-git-send-email-bp@alien8.de>
 <20130920104249.GA21381@console-pimps.org>
 <20130921152139.GG2737@rocoto.smurfnet.nu>
 <20130921154143.GC1587@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130921154143.GC1587-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 21, 2013 at 05:41:43PM +0200, Borislav Petkov wrote:
> On Sat, Sep 21, 2013 at 05:21:39PM +0200, Leif Lindholm wrote:
> 
> > It will probably not be a problem on the stub side, and it's not used
> > in many places but it would break efi_lookup_mapped_address(),
> > efi_range_is_wc() and memrange_efi_to_native() for use by arm64.
> > At least the first of these would be a problem.
> 
> Ok, maybe the generic header include/linux/efi.h might be a problem but
> the rest are changes to arch/x86/ which should have no effect whatsoever
> on any other arch.

Indeed - my concerns are restricted to include/linux/efi.h and
drivers/firmware/efi.c.

> Or are you planning to move some of it into generic code?

I think some of the stub code is moved to generic in Roy's/Mark's
patches - but then the stub shouldn't be an issue as in UEFI we have
4K pages.

/
    Leif
