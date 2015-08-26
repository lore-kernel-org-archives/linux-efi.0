From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] unify efi debug output across architectures
Date: Wed, 26 Aug 2015 15:46:38 +0200
Message-ID: <CAKv+Gu9rePiKwk63+tppYWKW-3VV7OmKekteUra57zowejfQqw@mail.gmail.com>
References: <1440595498-30630-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440595498-30630-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 August 2015 at 15:24, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> efi didn't use to have much in the way of kernel command line options,
> until some point last year. Then once the efi= option was added, it has
> been expanded on.
>
> x86 had an efi=debug option added, but that would be a useful thing
> across all efi architectures.
>
> arm64 efi support (predating efi=debug) came with its own 'uefi_debug'
> option, and passed along a special verbosity flag when calling into
> some not-strictly-arch-specific functions in core efi code.
>
> So:
> - Move efi=debug into core code, to be usable by all architectures
> - Change arm64 efi code to use 'efi=debug' instead of 'uefi_debug'
> - Rework arm64 interface to core code to drop special verbosity flag
>

For the series:

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> Leif Lindholm (3):
>   efi/x86: move efi=debug option parsing to core
>   arm64: use core efi=debug instead of uefi_debug command line parameter
>   efi/arm64: clean up efi_get_fdt_params() interface
>
>  Documentation/arm/uefi.txt  |  2 --
>  arch/arm64/kernel/efi.c     | 19 +++++--------------
>  arch/x86/platform/efi/efi.c |  2 --
>  drivers/firmware/efi/efi.c  |  9 +++++----
>  include/linux/efi.h         |  2 +-
>  5 files changed, 11 insertions(+), 23 deletions(-)
>
> --
> 2.1.4
>
