From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Wed, 25 Sep 2013 10:36:15 +0800
Message-ID: <20130925023615.GB7434@dhcp-16-126.nay.redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
 <52422A6A.8080305@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52422A6A.8080305-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/24/13 at 05:12pm, H. Peter Anvin wrote:
> On 09/24/2013 07:56 AM, Borislav Petkov wrote:
> > On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
> >> Think again about this, how about 1:1 map them from a base address
> >> like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
> >> depending on the previous region size.
> > 
> > Right, how we layout the regions is arbitrary as long as we start at
> > the same VA and use the same regions, in the same order and of the same
> > size...
> > 
> >> For the zero region problem, we can resolve it as a standalone
> >> problem.
> > 
> > ... however, we still need to understand why it fails mapping the boot
> > services region as some implementations apparently do call boot services
> > even after ExitBootServices(). IOW, we need that region mapped in the
> > kexec'ed kernel too.
> > 
> 
> I am starting to think that we really should explicitly pass along the
> EFI mappings to the secondary kernel.  This will also help if we have to
> change the algorithm in a future kernel.

The 0 size mem region is still a problem even we pass the previous mapping
to 2nd kernel. So will be be enough to 1:1 map on high address and leave the
firmware provided memmap not touched, use a copy of memmap in kernel?

> 
> The most logical way to do this is to define a new setup_data type and
> pass the entire set of physical-to-virtual mappings that way.
> 
> For example:
> 
> struct efi_mapping {
> 	u64 va;			/* Virtual start address */
> 	u64 pa;			/* Physical start address */
> 	u64 len;		/* Length in bytes */
> 	u64 type;		/* Mapping type */
> 	u64 reserved[3];	/* Reserved, must be zero */
> };
> 
> Adding some reserved fields seems like a prudent precaution; the map
> shouldn't be all that large anyway.
> 
> 	-hpa
> 
