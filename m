From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 2/5] efi: Dump the EFI page table
Date: Mon, 20 Jan 2014 14:41:21 +0100
Message-ID: <20140120134121.GC3003@pd.tnic>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-3-git-send-email-bp@alien8.de>
 <20140120133802.GA684@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140120133802.GA684-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 20, 2014 at 01:38:02PM +0000, Matt Fleming wrote:
> > +config EFI_PGT_DUMP
> > +	bool "Dump the EFI pagetable"
> > +	depends on EFI && X86_PTDUMP
> > +	---help---
> > +	  Enable this if you want to dump the EFI page table before
> > +	  enabling virtual mode. This can be used to debug miscellaneous
> > +	  issues with the mapping of the EFI runtime regions into that
> > +	  table.
> > +
> 
> Would this be more suitable in arch/x86/Kconfig.debug?

I wanted to keep it close to CONFIG_EFI if we decide to make EFI into a
menu some day but I don't have a strong preference.

Just move it when applying.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
