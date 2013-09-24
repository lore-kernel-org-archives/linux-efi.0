From: "Borislav Petkov" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Tue, 24 Sep 2013 16:56:49 +0200 (CEST)
Message-ID: <e39e1065bddc2afee2cb6eed957e3ba8.squirrel@www.skyhub.de>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, September 24, 2013 2:45 pm, Dave Young wrote:
> Think again about this, how about 1:1 map them from a base address
> like -64G phy_addr -> (-64G + phy_addr), in this way we can avoid
> depending on the previous region size.

Right, how we layout the regions is arbitrary as long as we start at
the same VA and use the same regions, in the same order and of the same
size...

> For the zero region problem, we can resolve it as a standalone
> problem.

... however, we still need to understand why it fails mapping the boot
services region as some implementations apparently do call boot services
even after ExitBootServices(). IOW, we need that region mapped in the
kexec'ed kernel too.

Thanks.

-- 
Regards/Gruss,
Boris.
