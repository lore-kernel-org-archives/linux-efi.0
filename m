From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] efi/libstub: arm64: set -fpie when building the EFI stub
Date: Thu, 8 Jun 2017 19:18:36 +0000
Message-ID: <CAKv+Gu--WbvmS3EMPSD8sx6yVqgHQJO1r70+SYBRo_WZjUxioQ@mail.gmail.com>
References: <20170518090953.32628-1-ard.biesheuvel@linaro.org>
 <20170518090953.32628-4-ard.biesheuvel@linaro.org> <20170608190804.GG141096@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608190804.GG141096-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Greg Hackmann <ghackmann-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, =?UTF-8?Q?Bernhard_Rosenkr=C3=A4nzer?= <Bernhard.Rosenkranzer-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Grant Grundler <grundler-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 8 June 2017 at 19:08, Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> El Thu, May 18, 2017 at 10:09:53AM +0100 Ard Biesheuvel ha dit:
>
>> Clang may emit absolute symbol references when building in non-PIC mode,
>> even when using the default 'small' code model, which is already mostly
>> position independent to begin with, due to its use of adrp/add pairs
>> that have a relative range of +/- 4 GB. The remedy is to pass the -fpie
>> flag, which can be done safely now that the code has been updated to avoid
>> GOT indirections (which may be emitted due to the compiler assuming that
>> the PIC/PIE code may end up in a shared library that is subject to ELF
>> symbol preemption)
>>
>> Passing -fpie when building code that needs to execute at an a priori
>> unknown offset is arguably an improvement in any case, and given that
>> the recent visibility changes allow the PIC build to pass with GCC as
>> well, let's add -fpie for all arm64 builds rather than only for Clang.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Tested-by: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Thanks Matthias.

For the record, did you test only with Clang?
