From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Date: Sat, 26 Apr 2014 15:28:21 +0800
Message-ID: <20140426072821.GA2286@darkstar.redhat.com>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
 <20140425115345.GC26088@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140425115345.GC26088-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 04/25/14 at 12:53pm, Matt Fleming wrote:
> On Thu, 24 Apr, at 05:36:58PM, Dave Young wrote:
> > earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"
>  
> Are you sure it hangs and it's not just that nothing is output to the
> console after that point?

There's other kernel messages without appending ,keep.

Also console=ttyS0 does not work with earlyprintk=efi,keep, removing ,keep it works well.

> 
> > Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> > Thus efi earlyconsole can not be kept.
>  
> Urgh, good point, that's a bug. However I'm sure I've had this working
> in the past and have in fact used it to debug stuff.
> 
> Could you try and fix this up so it works with 'keep'?

Will do. I want use ioremap when it is available but it's hard to decide
where to add the code.

I'm thinking to do below:
1. ioremap the whole framebuffer like: efi_fb = ioremap(lfb_base, lfb_size) in the
   function efi_enter_virtual_mode because ioremap should be usable then.

2. add two functions for earlyprintk use (scrollup, write, etc.) 
__init_refok void * get_vaddr(unsigned long start, unsigned long len)
{
	unsigned long base;

	base = boot_params.screen_info.lfb_base;
	if (efi_fb)
		return (efi_fb + start - base);
	else
		return early_ioremap(start, len);
}

__init_refok void put_vaddr(void *addr, unsigned long len)
{
	if (!efi_fb)
		early_iounmap(addr, len);
}

But it does not sound good to add the ioremap in enter virtual mode funtion.   

Please help if you have any other better idea.

Thanks
Dave
