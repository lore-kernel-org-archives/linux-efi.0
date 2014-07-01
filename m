From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/5] efistub: convert into static library
Date: Tue, 1 Jul 2014 20:55:20 +0200
Message-ID: <CAKv+Gu8eN4s9V6=mmQFpMDKuuMRE0y5T6pxk27=BLMFRX1O57w@mail.gmail.com>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
	<20140701183906.GH7539@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140701183906.GH7539-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 July 2014 20:39, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Thu, 26 Jun, at 04:23:32PM, Ard Biesheuvel wrote:
>> This is v2 of the series to change the #include "../../../../xxx.c" pattern
>> into a static library linked into either the kernel (arm64) or a separate boot
>> decompressor (x86, ARM).
>>
>> Changes since v1:
>> - added patch #1 to change EFI_ERROR, it is not a result code defined by UEFI so
>>   it should only be returned by get_dram_base() and efi_entry()
>> - added a section to libstub Makefile to clean CFLAGS of stack protecter and
>>   other options that are inappropriate for the stub
>> - rebased onto the UEFI Runtime Services NEON patches (re)posted earlier today
>>
>> Ard Biesheuvel (5):
>>   efi/arm64: avoid EFI_ERROR as a generic return code
>>   efi/x86: efistub: move shared dependencies to <asm/efi.h>
>>   efi/arm64: efistub: move shared dependencies to <asm/efi.h>
>>   efi: efistub: refactor stub components
>>   efi: efistub: convert into static library
>
> Thanks Ard. I've picked these up.
>

OK, thanks. One tiny snag that I would like to fix up once we have
some Acks to add: I just noticed that i removed the 'static' from
handle_kernel_image()'s definition from arm64 in 4/5, but removed it
from the forward declaration in 5/5, which likely breaks bisect for
arm64 if you happen to end up right in the middle.

Regards,
Ard.
