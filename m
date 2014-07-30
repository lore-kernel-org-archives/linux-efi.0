From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [RFC PATCH 04/10] arm64: add EFI little endian constants to
 linker script
Date: Wed, 30 Jul 2014 15:18:05 +0100
Message-ID: <20140730141805.GA15082@console-pimps.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405955785-13477-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405955785-13477-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 21 Jul, at 05:16:19PM, Ard Biesheuvel wrote:
> Similar to how text offset and kernel size are mangled to produce little
> endian constants for the Image header regardless of the endianness of the
> kernel, this adds a number of constants used in the EFI PE/COFF header which
> can only be calculated (and byte swapped) by the linker.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/image.h | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)

Where is this file? I can't find it in Linus' tree.

-- 
Matt Fleming, Intel Open Source Technology Center
