From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] efi/arm64: unmap the kernel while executing UEFI services
Date: Fri, 26 Jan 2018 17:06:42 +0000
Message-ID: <CAKv+Gu84Dk1ZRicHNWr2SLn1GEpaj1YmekzgjvK4aC5t05TgSw@mail.gmail.com>
References: <20180125103131.19168-1-ard.biesheuvel@linaro.org>
 <20180125103131.19168-5-ard.biesheuvel@linaro.org> <20180126170505.GE16008@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180126170505.GE16008-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Joakim Bech <joakim.bech-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Graeme Gregory <graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 January 2018 at 17:05, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Jan 25, 2018 at 10:31:31AM +0000, Ard Biesheuvel wrote:
>> Now that all UEFI runtime service wrappers ensure that byref
>> arguments are moved into the UEFI marshalling buffer (which
>> is not part of the kernel mapping), we can proceed and unmap
>> the kernel while UEFI runtime service calls are in progress.
>>
>> This is done by setting the EPD1 bit and flushing the TLB of
>> the local CPU. This makes it independent of KPTI or whether
>> non-global mappings are being used.
>
> One snag with this is that it will break SPE, so I'd prefer this behaviour
> to be predicated on kpti so that the arm64_kernel_unmapped_at_el0() check
> in drivers/perf/arm_spe_pmu.c remains valid.
>

The problem with that is that they serve two different purposes: kpti
protects against meltdown, this protects against Spectre variant 1.
