From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] efi/arm64: unmap the kernel during runtime service calls
Date: Mon, 29 Jan 2018 14:55:48 +0000
Message-ID: <CAKv+Gu-KEXJet4TdRcGBAtOH-ty79_izHcH4mu7Y7xF5UtOWsw@mail.gmail.com>
References: <20180125103131.19168-1-ard.biesheuvel@linaro.org> <bdba264b-6619-6e9f-2849-d9d82a820ab0@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <bdba264b-6619-6e9f-2849-d9d82a820ab0-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Joakim Bech <joakim.bech-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Graeme Gregory <graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29 January 2018 at 14:51, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
> On 1/25/2018 3:31 AM, Ard Biesheuvel wrote:
>
>> Note that capsule update has been omitted. This is a bit involved, and
>> I'd rather get some feedback before burning too many cycles on that. All
>> other services should be functional, with the caveat that EFI variable
>> names are now limited to 1024 [wide] characters, and UEFI variables
>> themselves to 64 KB.
>>
>
> I'm curious, why these limitations?
>

Because mapping and unmapping things on the fly in the UEFI page
tables is a bit complicated, although I need to do something of the
kind for capsules anyway, so once I solve that, we can use the same
approach for variables.

> We don't have any concern about the name length limitation at this time, but
> the variable size one is concerning.
>
> We have a feature which creates a variable greater than 64KB that we want to
> utilize from Linux.  The size limitation would seem to prevent that.
>

Well, the limit itself is rather arbitrary, and putting >64 KB into
the fault tolerant, write ahead logging NOR flash seems mildly
inappropriate to me. But you are right, the spec currently has no such
limitations, so ideally, nor should the OS.
