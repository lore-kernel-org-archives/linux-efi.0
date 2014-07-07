From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] efi: implement mandatory locking for UEFI Runtime Services
Date: Mon, 7 Jul 2014 22:43:31 +0200
Message-ID: <CAKv+Gu91CQADTQ8KMjXQPwVDvW1XkUYO2E5=Mu=aAtrB8B3q_A@mail.gmail.com>
References: <1404295802-28030-1-git-send-email-ard.biesheuvel@linaro.org>
	<1404295802-28030-2-git-send-email-ard.biesheuvel@linaro.org>
	<20140707202954.GC27474@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140707202954.GC27474-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 7 July 2014 22:29, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Wed, 02 Jul, at 12:10:02PM, Ard Biesheuvel wrote:
>> According to section 7.1 of the UEFI spec, Runtime Services are not fully
>> reentrant, and there are particular combinations of calls that need to be
>> serialized.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/runtime-wrappers.c | 109 +++++++++++++++++++++++++++++---
>>  1 file changed, 99 insertions(+), 10 deletions(-)
>
> Ard, what's going on with this one? I didn't see it resubmitted along
> with v3 of "efi/arm64: handle missing virtual mapping for UEFI System
> Table".
>
> Note that we already have a lock to serialize access to the UEFI
> variable services in the form of __efivars->lock, see
> drivers/firmware/efi/vars.c. It's a spinlock because of the context we
> may need to create variables in from efi_pstore_write().
>

As the patch says, the UEFI spec is very clear on which combinations
of calls are not reentrant.
I don't think the rtc_lock and the efivars->lock quite cover that completely ...
