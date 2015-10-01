From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] efi: remove UEFIv2.5 properties table from
 /sys/firmware/efi/systab
Date: Thu, 1 Oct 2015 11:15:05 +0800
Message-ID: <20151001031505.GA8264@localhost.localdomain>
References: <1443624196-31630-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443624196-31630-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 09/30/15 at 04:43pm, Ard Biesheuvel wrote:
> As pointed out by Dave Young, /sys/firmware/efi/systab violates the
> sysfs one-value-per-file policy already, so adding more data items
> to it should be avoided. So let's remove the PROP= line that lists
> the address of the recently introduced Properties Table before it
> appears in a release.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> 
> Matt pointed out that there still needs to be a way for kexec/x86 to
> access this data, since it needs to pass it on to the kexec kernel.
> That is way out of my area of expertise, so I will leave it to you
> to come up with something suitable there.
> 
>  drivers/firmware/efi/efi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 2eb31e28a35c..3804ecd4a77a 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -109,8 +109,6 @@ static ssize_t systab_show(struct kobject *kobj,
>  		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
>  	if (efi.uga != EFI_INVALID_TABLE_ADDR)
>  		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
> -	if (efi.properties_table != EFI_INVALID_TABLE_ADDR)
> -		str += sprintf(str, "PROP=0x%lx\n", efi.properties_table);
>  
>  	return str - buf;
>  }

Ard, thanks, it looks good to me.

Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
