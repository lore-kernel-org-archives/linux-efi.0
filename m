From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 0/7] ARM/efi minor fixes + stub pre-boot compat checks
Date: Thu, 4 Feb 2016 16:13:01 +0000
Message-ID: <20160204161300.GC17587@leverpostej>
References: <1454601030-9093-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454601030-9093-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, jeremy.linton-5wv7dgnIgG8@public.gmane.org, suzuki.poulose-5wv7dgnIgG8@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 04, 2016 at 04:50:23PM +0100, Ard Biesheuvel wrote:
> Ard Biesheuvel (7):
>   arm64: efistub: drop __init annotation from handle_kernel_image()
>   arm64: vmlinux.lds.S: handle .init.rodata.xxx and .init.bss sections
>   efi: efistub: prevent __init annotations from being used
>   efi: arm-init: use read-only early mappings
>   ARM: efistub: check for LPAE support before booting a LPAE kernel
>   arm64: efistub: check for h/w support before booting a >4 KB granule
>     kernel
>   ARM/arm64: efistub: perform hardware compatibility check

This all looks good to be, so FWIW, for the series:

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

Mark.
