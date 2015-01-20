From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efi: rtc-efi: mark UIE as unsupported
Date: Tue, 20 Jan 2015 15:46:27 +0000
Message-ID: <20150120154627.GZ12079@codeblueprint.co.uk>
References: <1421152133-28506-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1421152133-28506-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 13 Jan, at 12:28:53PM, Ard Biesheuvel wrote:
> Tools like hwclock attempt to enable the RTC update interrupt (UIE) to
> maximize the accuracy of the reported time value. The EFI rtc does not
> have interrupt capability so this is a pointless exercise to begin with,
> but the generic RTC framework ends up issuing a SetWakeupTime() Runtime
> Services call before drawing that conclusion on its own.
> 
> Instead, we can mark UIE as unsupported at driver probe time. The net
> result is the same, but without the spurious SetWakeupTime() call.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/rtc/rtc-efi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> index b37b0c80bd5a..cb989cd00b14 100644
> --- a/drivers/rtc/rtc-efi.c
> +++ b/drivers/rtc/rtc-efi.c
> @@ -218,6 +218,7 @@ static int __init efi_rtc_probe(struct platform_device *dev)
>  	if (IS_ERR(rtc))
>  		return PTR_ERR(rtc);
>  
> +	rtc->uie_unsupported = 1;
>  	platform_set_drvdata(dev, rtc);
>  
>  	return 0;

Looks fine to me. Picked up in the EFI tree for v3.20. Thanks Ard.

-- 
Matt Fleming, Intel Open Source Technology Center
