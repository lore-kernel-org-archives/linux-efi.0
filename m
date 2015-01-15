From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] efi: small leak on error
Date: Thu, 15 Jan 2015 20:24:28 +0800
Message-ID: <20150115122428.GC16485@darkstar.redhat.com>
References: <20150115092121.GA17976@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115092121.GA17976@mwanda>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/15/15 at 12:21pm, Dan Carpenter wrote:
> The "> 0" here should ">= 0" so we free map_entries[0].
> 
> Fixes: 926172d46038 ('efi: Export EFI runtime memory mapping to sysfs')
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> 
> diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
> index 018c29a..87b8e3b 100644
> --- a/drivers/firmware/efi/runtime-map.c
> +++ b/drivers/firmware/efi/runtime-map.c
> @@ -191,7 +191,7 @@ int __init efi_runtime_map_init(struct kobject *efi_kobj)
>  
>  	return 0;
>  out_add_entry:
> -	for (j = i - 1; j > 0; j--) {
> +	for (j = i - 1; j >= 0; j--) {
>  		entry = *(map_entries + j);
>  		kobject_put(&entry->kobj);
>  	}

Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks
Dave
