From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Wed, 25 Sep 2013 10:31:17 +0800
Message-ID: <20130925023117.GA7434@dhcp-16-126.nay.redhat.com>
References: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel-Fq0NhQX/+7ild1e1puMNDg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/24/13 at 04:56pm, Borislav Petkov wrote:
> On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
> > Think again about this, how about 1:1 map them from a base address
> > like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
> > depending on the previous region size.
> 
> Right, how we layout the regions is arbitrary as long as we start at
> the same VA and use the same regions, in the same order and of the same
> size...
> 
> > For the zero region problem, we can resolve it as a standalone
> > problem.
> 
> ... however, we still need to understand why it fails mapping the boot
> services region as some implementations apparently do call boot services
> even after ExitBootServices(). IOW, we need that region mapped in the
> kexec'ed kernel too.

In 1st kernel, the memmap is provided by firmware and unchanged before
we do the mapping, later efi_reserve_boot_services() try to reserve the
mem range, but failed due to conflict with other region (why?), then the
memmap item size is set to 0 (why?).

In 2nd kernel, we use same memmap from firmware, but the boot service
ranges size have been set to 0, thus efi mapping code will mapping runtime
regions to different va from 1st kernel.

--
Thanks
Dave
