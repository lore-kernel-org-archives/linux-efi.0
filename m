From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: Dump the EFI page table
Date: Tue, 14 Jan 2014 09:36:51 +0800
Message-ID: <20140114013651.GA4327@dhcp-16-126.nay.redhat.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
 <1389473370-1940-3-git-send-email-bp@alien8.de>
 <20140113160018.GJ3256@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140113160018.GJ3256-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/13/14 at 04:00pm, Matt Fleming wrote:
> On Sat, 11 Jan, at 09:49:28PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> > 
> > This is very useful for debugging issues with the recently added
> > pagetable switching code for EFI virtual mode.
> > 
> > Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index d62ec87a2b26..c34be4ce94c9 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -54,6 +54,7 @@
> >  #include <asm/rtc.h>
> >  
> >  #define EFI_DEBUG
> > +#undef EFI_PGT_DBG
> 
> Should this be a Kconfig option? Hacking source files to enable debug
> isn't the best idea. Plus you could make it depend on X86_PTDUMP.

I have same feeling, either a new Kconfig option or just print it while
ptdump_to_dmesg is true by default without extra Kconfig.

Thanks
Dave
