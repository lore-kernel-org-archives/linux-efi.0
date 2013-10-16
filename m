From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86 efi: efi reverve boot service fix
Date: Wed, 16 Oct 2013 16:24:03 +0800
Message-ID: <20131016082402.GA27678@dhcp-16-126.nay.redhat.com>
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com>
 <20131016071122.GB18241@dhcp-16-126.nay.redhat.com>
 <525E4076.2070107@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <525E4076.2070107-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 10/16/13 at 12:29am, H. Peter Anvin wrote:
> On 10/16/2013 12:11 AM, Dave Young wrote:
> >>
> >> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> >> +++ linux-2.6/arch/x86/platform/efi/efi.c
> >> @@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
> >>  		 * - Not within any part of the kernel
> >>  		 * - Not the bios reserved area
> >>  		*/
> >> -		if ((start+size >= __pa_symbol(_text)
> >> +		if ((start + size - 1 >= __pa_symbol(_text)
> >>  				&& start <= __pa_symbol(_end)) ||
> >>  			!e820_all_mapped(start, start+size, E820_RAM) ||
> >>  			memblock_is_region_reserved(start, size)) {
> 
> It would be better to change >= to >.

Both are fine to me, will resend with '>'
