From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] efi: arm64: use -fpie for building the stub
Date: Fri, 9 Jun 2017 09:02:42 +0000
Message-ID: <CAKv+Gu-K9d-Rsy9i4++3Za45tpidZWO+WFcC_UPwt90DCmAhoA@mail.gmail.com>
References: <20170518090953.32628-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518090953.32628-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 May 2017 at 10:09, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Clang requires the stub to be built with -fpie, or it may emit absolute
> symbol references that trigger the absolute relocation detection code and
> cause the build to fail.
>
> The remedy is to set -fpie (#3), but due to stupid ELF symbol preemption
> rules that only apply to shared libraries, this will result in more rather
> than fewer absolute references (i.e., GOT entries), which we have to massage
> away using visibility overrides first. (#1, #2)
>
> Ard Biesheuvel (3):
>   efi/libstub: arm64: use hidden attribute for struct screen_info
>     reference
>   efi/libstub: arm64: force 'hidden' visibility for section markers
>   efi/libstub: arm64: set -fpie when building the EFI stub
>
>  arch/arm64/include/asm/efi.h              |  3 +++
>  drivers/firmware/efi/libstub/Makefile     |  2 +-
>  drivers/firmware/efi/libstub/arm64-stub.c | 10 +++++++++-
>  3 files changed, 13 insertions(+), 2 deletions(-)
>

I have queued these in efi/next, with Matthias's Tested-by
