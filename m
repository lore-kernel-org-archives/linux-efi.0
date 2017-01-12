From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 2/4] efi/x86: move efi bgrt init code to early init code
Date: Thu, 12 Jan 2017 17:56:49 +0800
Message-ID: <20170112095649.GA5045@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.909117564@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170112094214.909117564@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

[snip]
> --- linux-x86.orig/drivers/acpi/bgrt.c
> +++ linux-x86/drivers/acpi/bgrt.c

[snip]
>  
> @@ -84,9 +85,17 @@ static int __init bgrt_init(void)
>  {
>  	int ret;
>  
> -	if (!bgrt_image)
> +	if (!bgrt_tab.image_address)
>  		return -ENODEV;
>  
> +	bgrt_image = memremap(bgrt_tab.image_address, bgrt_image_size,
> +			      MEMREMAP_WB);
> +	if (!bgrt_image) {
> +		pr_notice("Ignoring BGRT: failed to map image memory\n");
> +		bgrt_image = NULL;
> +		return -ENOMEM;
> +	}
> +

Oops, later error path need unmap bgrt_image, will update in next
version after collecting more comments.

Also bgrt_image = NULL is useless, will drop it.

>  	bin_attr_image.private = bgrt_image;
>  	bin_attr_image.size = bgrt_image_size;
>  

Thanks
Dave
