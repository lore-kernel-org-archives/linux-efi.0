From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 RESEND 1/2] x86/mm/KASLR: EFI region is mistakenly
 included into KASLR VA space for randomization
Date: Fri, 24 Mar 2017 11:05:23 +0800
Message-ID: <20170324030523.GA4069@dhcp-128-65.nay.redhat.com>
References: <1490239655-20902-1-git-send-email-bhe@redhat.com>
 <1490239655-20902-2-git-send-email-bhe@redhat.com>
 <20170324022953.GA3715@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170324022953.GA3715-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This should also cc linux-efi

On 03/24/17 at 10:29am, Dave Young wrote:
> Hi, Baoquan
> 
> On 03/23/17 at 11:27am, Baoquan He wrote:
> > Currently KASLR is enabled on three regions: the direct mapping of physical
> > memory, vamlloc and vmemmap. However EFI region is also mistakenly included
> > for VA space randomization because of misusing EFI_VA_START macro and
> > assuming EFI_VA_START < EFI_VA_END.
> > 
> > The EFI region is reserved for EFI runtime services virtual mapping which
> > should not be included in kaslr ranges. It will be re-used by kexec/kdump
> > kernel, the mistake may cause failure when jump to kexec/kdump kernel if
> > vmemmap allocation stomps on the allocated efi mapping region.
> 
> No need to mention kexec/kdump in changelog although it is true that
> kexec kernel will use the persistent efi runtime mapping. The main point
> is it is wrong to use the reserved vm space for efi.

Explain more about this:

It is a general issue instead of a kexec/kdump issue and it is a real
bug. Although efi has its own page tables, it will still sync kernel
page tables along with the mapping of efi reserved area. So if vmalloc
etc use the vm space of efi reserved area, then some of them will be
missed when efi sync the low kernel page tables..

> 
> Also I think this patch can be sent as a standalone patch, no need to be
> a patch series. For the second patch I think it depends on efi
> maintainer's opinion, personally I think only this simple fix for kaslr only
> will be better.
> 
> > 
> > In Documentation/x86/x86_64/mm.txt, we can see:
> >   ffffffef00000000 - fffffffeffffffff (=64 GB) EFI region mapping space
> > EFI use the space from -4G to -64G thus EFI_VA_START > EFI_VA_END
> > Here EFI_VA_START = -4G, and EFI_VA_END = -64G
> > 
> > Changing EFI_VA_START to EFI_VA_END in mm/kaslr.c fixes this problem.
> > 
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #4.8+
> > Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Reviewed-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Acked-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> > Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org> 
> > Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> > Cc: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> > Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
> > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > Cc: Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>
> > ---
> >  arch/x86/mm/kaslr.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
> > index 887e571..aed2064 100644
> > --- a/arch/x86/mm/kaslr.c
> > +++ b/arch/x86/mm/kaslr.c
> > @@ -48,7 +48,7 @@ static const unsigned long vaddr_start = __PAGE_OFFSET_BASE;
> >  #if defined(CONFIG_X86_ESPFIX64)
> >  static const unsigned long vaddr_end = ESPFIX_BASE_ADDR;
> >  #elif defined(CONFIG_EFI)
> > -static const unsigned long vaddr_end = EFI_VA_START;
> > +static const unsigned long vaddr_end = EFI_VA_END;
> >  #else
> >  static const unsigned long vaddr_end = __START_KERNEL_map;
> >  #endif
> > @@ -105,7 +105,7 @@ void __init kernel_randomize_memory(void)
> >  	 */
> >  	BUILD_BUG_ON(vaddr_start >= vaddr_end);
> >  	BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_ESPFIX64) &&
> > -		     vaddr_end >= EFI_VA_START);
> > +		     vaddr_end >= EFI_VA_END);
> >  	BUILD_BUG_ON((IS_ENABLED(CONFIG_X86_ESPFIX64) ||
> >  		      IS_ENABLED(CONFIG_EFI)) &&
> >  		     vaddr_end >= __START_KERNEL_map);
> > -- 
> > 2.5.5
> > 
> 
> Thanks
> Dave
