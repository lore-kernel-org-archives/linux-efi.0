From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Date: Fri, 21 Jun 2013 07:34:43 +0100
Message-ID: <20130621063443.GC5386@console-pimps.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130619161827.GF28300@pd.tnic>
 <20130619162115.GA28119@srcf.ucam.org>
 <20130619163804.GG28300@pd.tnic>
 <20130619164822.GA28240@srcf.ucam.org>
 <20130619165902.GH28300@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130619165902.GH28300-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 19 Jun, at 06:59:02PM, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 05:48:22PM +0100, Matthew Garrett wrote:
> > > Ok, so it sounds like we want to *always* create both mappings but,
> > > depending on what we want, to shove down SetVirtualAddressMap a
> > > different set. And the 1:1 map will be the optional one which we give
> > > SetVirtualAddressMap only when user wants it, i.e. when booting with
> > > "efi=1:1_map".
> > 
> > Yup, I think that sounds ideal.
> 
> Crap, I got completely sidetracked. The 1:1 mappings go in a different
> pagetable (real_mode_header->trampoline_pgd) than the kernel one
> (i.e. init_mm.pgd). However, the ->trampoline_pgd has all mappings
> anyway, which means that if we want to do EFI runtime calls with the
> high mappings but *also* have the 1:1 mappings established, we should
> *always* switch to that pagetable when doing those calls.
> 
> hpa, MattF, agreed?

Yep.

-- 
Matt Fleming, Intel Open Source Technology Center
