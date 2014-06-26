From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/2] efi: preserve NEON registers on UEFI services calls
Date: Thu, 26 Jun 2014 16:22:44 +0200
Message-ID: <CAKv+Gu-1qbn=VagWKkwkr2aJg3k6UcWEqa8EQKGocuaLxb9+Bw@mail.gmail.com>
References: <1403777346-28629-1-git-send-email-ard.biesheuvel@linaro.org>
	<1403791087.755.120.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403791087.755.120.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Olivier Martin <olivier.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 June 2014 15:58, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2014-06-26 at 12:09 +0200, Ard Biesheuvel wrote:
>> The current UEFI implementation for arm64 fails to preserve/restore the contents
>> of the NEON register file,
>
> Does the current implementation actually use NEON registers?
> I know there are some at least, which build with -mgeneral-regs-only
> to keep gcc from using NEON registers.
>

Tianocore/EDK2 does not use -mgeneral-regs-only when building for
AArch64, and my current build shows that, for instance, GCC starts
spilling to FP registers when compiling the LZMA decoder, and it is
likely to do the same for the crypto bits once I start enabling them
(although, interestingly enough, the OpenSSL SHA-1 C implementation
runs 60% faster with -mgeneral-regs-only set)

> Not that that means we don't need this. Just curious.
>

The spec does not forbid it, so we will need it anyhow ...

-- 
Ard.
