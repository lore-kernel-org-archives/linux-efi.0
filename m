From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 2/2] efi/arm*: esrt: add missing call to
 efi_esrt_init()
Date: Fri, 15 Jul 2016 16:22:15 +0100
Message-ID: <20160715152215.GE2406@codeblueprint.co.uk>
References: <1468263646-28184-1-git-send-email-ard.biesheuvel@linaro.org>
 <1468263646-28184-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468263646-28184-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Jul, at 09:00:46PM, Ard Biesheuvel wrote:
> ESRT support is built by default for all architectures that define
> CONFIG_EFI. However, this support was not wired up yet for ARM/arm64,
> since efi_esrt_init() was never called. So add the missing call.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-init.c | 1 +
>  1 file changed, 1 insertion(+)

Thanks Ard, applied and queued up for v4.9 on top of the EFI memmap
refactoring.
