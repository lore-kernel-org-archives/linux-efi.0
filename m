From: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Wed, 8 Mar 2017 16:45:13 +0800
Message-ID: <20170308084513.GF18014@x1>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170308081812.GA12600-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, bp-l3A5Bk7waGM@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Forgot cc to Boris, add him.

On 03/08/17 at 04:18pm, Dave Young wrote:
> On 03/08/17 at 03:47pm, Baoquan He wrote:
> > EFI allocate runtime services regions down from EFI_VA_START, -4G.
> > It should be top-down handling.
> > 
> > Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi_64.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > index a4695da..6cbf9e0 100644
> > --- a/arch/x86/platform/efi/efi_64.c
> > +++ b/arch/x86/platform/efi/efi_64.c
> > @@ -47,7 +47,7 @@
> >  #include <asm/pgalloc.h>
> >  
> >  /*
> > - * We allocate runtime services regions bottom-up, starting from -4G, i.e.
> > + * We allocate runtime services regions top-down, starting from -4G, i.e.
> 
> Baoquan, I think original bottom-up is right, it is just considering
> -68G as up, see the x86_64 mm.txt. We regard vmalloc as higher address
> although from mathematics view it is lower then positive addresses.

Thanks for reviewing!

I am not sure. Just in efi_map_region() it gets the starting va to map
'size' big of region by below code:
	efi_va -= size;

-4G and -68G just a trick which makes people understand easily, still we
think kernel text mapping region is in higher addr area then vmalloc. I
personnally think.

Thanks
Baoquan
