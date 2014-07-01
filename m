From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 0/5] efistub: convert into static library
Date: Tue, 1 Jul 2014 19:39:06 +0100
Message-ID: <20140701183906.GH7539@console-pimps.org>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1403792617-25792-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 26 Jun, at 04:23:32PM, Ard Biesheuvel wrote:
> This is v2 of the series to change the #include "../../../../xxx.c" pattern
> into a static library linked into either the kernel (arm64) or a separate boot
> decompressor (x86, ARM).
> 
> Changes since v1:
> - added patch #1 to change EFI_ERROR, it is not a result code defined by UEFI so
>   it should only be returned by get_dram_base() and efi_entry()
> - added a section to libstub Makefile to clean CFLAGS of stack protecter and 
>   other options that are inappropriate for the stub
> - rebased onto the UEFI Runtime Services NEON patches (re)posted earlier today
> 
> Ard Biesheuvel (5):
>   efi/arm64: avoid EFI_ERROR as a generic return code
>   efi/x86: efistub: move shared dependencies to <asm/efi.h>
>   efi/arm64: efistub: move shared dependencies to <asm/efi.h>
>   efi: efistub: refactor stub components
>   efi: efistub: convert into static library

Thanks Ard. I've picked these up.

-- 
Matt Fleming, Intel Open Source Technology Center
