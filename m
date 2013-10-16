From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86 efi: efi reverve boot service fix
Date: Wed, 16 Oct 2013 15:11:22 +0800
Message-ID: <20131016071122.GB18241@dhcp-16-126.nay.redhat.com>
References: <20131016070301.GA26752@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131016070301.GA26752-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

typo, fix hpa's mail address..

On 10/16/13 at 03:03pm, Dave Young wrote:
> 
> Current code check boot service region with kernel text region by: 
> start+size >= __pa_symbol(_text)
> The end of the above region should be start + size - 1 instead.
> 
> I see this problem in ovmf + Fedora 19 grub boot:
> text start: 1000000 md start: 800000 md size: 800000
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/arch/x86/platform/efi/efi.c
> +++ linux-2.6/arch/x86/platform/efi/efi.c
> @@ -440,7 +440,7 @@ void __init efi_reserve_boot_services(vo
>  		 * - Not within any part of the kernel
>  		 * - Not the bios reserved area
>  		*/
> -		if ((start+size >= __pa_symbol(_text)
> +		if ((start + size - 1 >= __pa_symbol(_text)
>  				&& start <= __pa_symbol(_end)) ||
>  			!e820_all_mapped(start, start+size, E820_RAM) ||
>  			memblock_is_region_reserved(start, size)) {
