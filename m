From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 31/42] x86, efi: Copy SETUP_EFI data and access directly
Date: Fri, 24 Jul 2015 10:07:48 +0800
Message-ID: <20150724020748.GB5508@dhcp-128-11.nay.redhat.com>
References: <1436300428-21163-1-git-send-email-yinghai@kernel.org>
 <1436300428-21163-32-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1436300428-21163-32-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi,

On 07/07/15 at 01:20pm, Yinghai Lu wrote:
> The copy will be in __initdata, and it is small.
> 
> We can use pointer to access the setup_data instead of using early_memmap
> everywhere.

Looks good to me except one issue about missing checking memremap return value.
see the comment inline

> 
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---

[snip]

> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -295,9 +295,17 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  	return (void __iomem *)__va(phys_addr);
>  }
>  
> +static struct efi_setup_data efi_setup_data __initdata;
> +
>  void __init parse_efi_setup(u64 phys_addr, u32 data_len)
>  {
> -	efi_setup = phys_addr + sizeof(struct setup_data);
> +	struct efi_setup_data *data;
> +
> +	data = early_memremap(phys_addr + sizeof(struct setup_data),
> +			      sizeof(*data));

There should be a checking for return value here..

> +	efi_setup_data = *data;
> +	early_memunmap(data, sizeof(*data));
> +	efi_setup = &efi_setup_data;
>  }
>  

[snip]

Thanks
Dave
