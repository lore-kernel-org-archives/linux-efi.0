From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: rtc-efi: export platform:rtc-efi as module alias
Date: Sun, 14 Sep 2014 14:58:52 +0100
Message-ID: <20140914135852.GI18582@console-pimps.org>
References: <1410423640-1499-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1410423640-1499-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing rtc maintainer, list and akpm)

On Thu, 11 Sep, at 10:20:40AM, Ard Biesheuvel wrote:
> When the rtc-efi driver is built as a module, we already register the
> EFI rtc as a platform device if UEFI Runtime Services are enabled.
> To wire it up to udev, and let the module be loaded automatically, we
> need to export the 'platform:rtc-efi' alias from the module.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/rtc/rtc-efi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> index 8225b89de810..59a55e7abf78 100644
> --- a/drivers/rtc/rtc-efi.c
> +++ b/drivers/rtc/rtc-efi.c
> @@ -235,3 +235,4 @@ module_platform_driver_probe(efi_rtc_driver, efi_rtc_probe);
>  MODULE_AUTHOR("dann frazier <dannf-VXdhtT5mjnY@public.gmane.org>");
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("EFI RTC driver");
> +MODULE_ALIAS("platform:rtc-efi");
> -- 
> 1.8.3.2

I haven't picked up any rtc-efi patches before. They appear to have gone
through akpm in the past.

Andrew, would you mind picking this one up?

-- 
Matt Fleming, Intel Open Source Technology Center
