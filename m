Return-Path: <SRS0=QuFd=SK=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355CFC282DE
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 09:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0762C20870
	for <linux-efi@archiver.kernel.org>; Mon,  8 Apr 2019 09:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfDHJLH (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Mon, 8 Apr 2019 05:11:07 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:44574 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfDHJLD (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Mon, 8 Apr 2019 05:11:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 390A315AD;
        Mon,  8 Apr 2019 02:11:03 -0700 (PDT)
Received: from [10.1.196.92] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 968D43F718;
        Mon,  8 Apr 2019 02:11:01 -0700 (PDT)
Subject: Re: [PATCH] efi/arm: enable CP15 DMB instructions before cleaning the
 cache
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-efi <linux-efi@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Steve McIntyre <steve.mcintyre@linaro.org>
References: <20190329182418.29592-1-ard.biesheuvel@linaro.org>
 <86y34w668n.wl-marc.zyngier@arm.com>
 <CAKv+Gu_3_nENwrp81r7=wWbbZ6hpdjewppbuy6domXoZe09ujg@mail.gmail.com>
 <86tvfj5t2g.wl-marc.zyngier@arm.com>
 <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
From:   Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 mQINBE6Jf0UBEADLCxpix34Ch3kQKA9SNlVQroj9aHAEzzl0+V8jrvT9a9GkK+FjBOIQz4KE
 g+3p+lqgJH4NfwPm9H5I5e3wa+Scz9wAqWLTT772Rqb6hf6kx0kKd0P2jGv79qXSmwru28vJ
 t9NNsmIhEYwS5eTfCbsZZDCnR31J6qxozsDHpCGLHlYym/VbC199Uq/pN5gH+5JHZyhyZiNW
 ozUCjMqC4eNW42nYVKZQfbj/k4W9xFfudFaFEhAf/Vb1r6F05eBP1uopuzNkAN7vqS8XcgQH
 qXI357YC4ToCbmqLue4HK9+2mtf7MTdHZYGZ939OfTlOGuxFW+bhtPQzsHiW7eNe0ew0+LaL
 3wdNzT5abPBscqXWVGsZWCAzBmrZato+Pd2bSCDPLInZV0j+rjt7MWiSxEAEowue3IcZA++7
 ifTDIscQdpeKT8hcL+9eHLgoSDH62SlubO/y8bB1hV8JjLW/jQpLnae0oz25h39ij4ijcp8N
 t5slf5DNRi1NLz5+iaaLg4gaM3ywVK2VEKdBTg+JTg3dfrb3DH7ctTQquyKun9IVY8AsxMc6
 lxl4HxrpLX7HgF10685GG5fFla7R1RUnW5svgQhz6YVU33yJjk5lIIrrxKI/wLlhn066mtu1
 DoD9TEAjwOmpa6ofV6rHeBPehUwMZEsLqlKfLsl0PpsJwov8TQARAQABtCNNYXJjIFp5bmdp
 ZXIgPG1hcmMuenluZ2llckBhcm0uY29tPokCOwQTAQIAJQIbAwYLCQgHAwIGFQgCCQoLBBYC
 AwECHgECF4AFAk6NvYYCGQEACgkQI9DQutE9ekObww/+NcUATWXOcnoPflpYG43GZ0XjQLng
 LQFjBZL+CJV5+1XMDfz4ATH37cR+8gMO1UwmWPv5tOMKLHhw6uLxGG4upPAm0qxjRA/SE3LC
 22kBjWiSMrkQgv5FDcwdhAcj8A+gKgcXBeyXsGBXLjo5UQOGvPTQXcqNXB9A3ZZN9vS6QUYN
 TXFjnUnzCJd+PVI/4jORz9EUVw1q/+kZgmA8/GhfPH3xNetTGLyJCJcQ86acom2liLZZX4+1
 6Hda2x3hxpoQo7pTu+XA2YC4XyUstNDYIsE4F4NVHGi88a3N8yWE+Z7cBI2HjGvpfNxZnmKX
 6bws6RQ4LHDPhy0yzWFowJXGTqM/e79c1UeqOVxKGFF3VhJJu1nMlh+5hnW4glXOoy/WmDEM
 UMbl9KbJUfo+GgIQGMp8mwgW0vK4HrSmevlDeMcrLdfbbFbcZLNeFFBn6KqxFZaTd+LpylIH
 bOPN6fy1Dxf7UZscogYw5Pt0JscgpciuO3DAZo3eXz6ffj2NrWchnbj+SpPBiH4srfFmHY+Y
 LBemIIOmSqIsjoSRjNEZeEObkshDVG5NncJzbAQY+V3Q3yo9og/8ZiaulVWDbcpKyUpzt7pv
 cdnY3baDE8ate/cymFP5jGJK++QCeA6u6JzBp7HnKbngqWa6g8qDSjPXBPCLmmRWbc5j0lvA
 6ilrF8m5Ag0ETol/RQEQAM/2pdLYCWmf3rtIiP8Wj5NwyjSL6/UrChXtoX9wlY8a4h3EX6E3
 64snIJVMLbyr4bwdmPKULlny7T/R8dx/mCOWu/DztrVNQiXWOTKJnd/2iQblBT+W5W8ep/nS
 w3qUIckKwKdplQtzSKeE+PJ+GMS+DoNDDkcrVjUnsoCEr0aK3cO6g5hLGu8IBbC1CJYSpple
 VVb/sADnWF3SfUvJ/l4K8Uk4B4+X90KpA7U9MhvDTCy5mJGaTsFqDLpnqp/yqaT2P7kyMG2E
 w+eqtVIqwwweZA0S+tuqput5xdNAcsj2PugVx9tlw/LJo39nh8NrMxAhv5aQ+JJ2I8UTiHLX
 QvoC0Yc/jZX/JRB5r4x4IhK34Mv5TiH/gFfZbwxd287Y1jOaD9lhnke1SX5MXF7eCT3cgyB+
 hgSu42w+2xYl3+rzIhQqxXhaP232t/b3ilJO00ZZ19d4KICGcakeiL6ZBtD8TrtkRiewI3v0
 o8rUBWtjcDRgg3tWx/PcJvZnw1twbmRdaNvsvnlapD2Y9Js3woRLIjSAGOijwzFXSJyC2HU1
 AAuR9uo4/QkeIrQVHIxP7TJZdJ9sGEWdeGPzzPlKLHwIX2HzfbdtPejPSXm5LJ026qdtJHgz
 BAb3NygZG6BH6EC1NPDQ6O53EXorXS1tsSAgp5ZDSFEBklpRVT3E0NrDABEBAAGJAh8EGAEC
 AAkFAk6Jf0UCGwwACgkQI9DQutE9ekMLBQ//U+Mt9DtFpzMCIHFPE9nNlsCm75j22lNiw6mX
 mx3cUA3pl+uRGQr/zQC5inQNtjFUmwGkHqrAw+SmG5gsgnM4pSdYvraWaCWOZCQCx1lpaCOl
 MotrNcwMJTJLQGc4BjJyOeSH59HQDitKfKMu/yjRhzT8CXhys6R0kYMrEN0tbe1cFOJkxSbV
 0GgRTDF4PKyLT+RncoKxQe8lGxuk5614aRpBQa0LPafkirwqkUtxsPnarkPUEfkBlnIhAR8L
 kmneYLu0AvbWjfJCUH7qfpyS/FRrQCoBq9QIEcf2v1f0AIpA27f9KCEv5MZSHXGCdNcbjKw1
 39YxYZhmXaHFKDSZIC29YhQJeXWlfDEDq6nIhvurZy3mSh2OMQgaIoFexPCsBBOclH8QUtMk
 a3jW/qYyrV+qUq9Wf3SKPrXf7B3xB332jFCETbyZQXqmowV+2b3rJFRWn5hK5B+xwvuxKyGq
 qDOGjof2dKl2zBIxbFgOclV7wqCVkhxSJi/QaOj2zBqSNPXga5DWtX3ekRnJLa1+ijXxmdjz
 hApihi08gwvP5G9fNGKQyRETePEtEAWt0b7dOqMzYBYGRVr7uS4uT6WP7fzOwAJC4lU7ZYWZ
 yVshCa0IvTtp1085RtT3qhh9mobkcZ+7cQOY+Tx2RGXS9WeOh2jZjdoWUv6CevXNQyOUXMM=
Organization: ARM Ltd
Message-ID: <e602136c-5c60-3165-0862-ea7ae7bfc647@arm.com>
Date:   Mon, 8 Apr 2019 10:11:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu-6n5YGq3AxpCvv-Zo-Fh01vyLoqMbqTPZn+k7MOFVnRw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190408091100.DhgH44jPgs9KUzU1uORmtpX0pj2liwcTec-rejjbGLs@z>

On 07/04/2019 19:19, Ard Biesheuvel wrote:
> On Sun, 31 Mar 2019 at 10:47, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>
>> On Sat, 30 Mar 2019 13:10:58 +0000,
>> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>
>>> On Sat, 30 Mar 2019 at 10:50, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>>
>>>> Hi Ard,
>>>>
>>>> On Fri, 29 Mar 2019 18:24:18 +0000,
>>>> Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>>>>
>>>>> The EFI stub is entered with the caches and MMU enabled by the
>>>>> firmware, and once the stub is ready to hand over to the decompressor,
>>>>> we clean and disable the caches.
>>>>>
>>>>> The cache clean routines use CP15 barrier instructions, which can be
>>>>> disabled via SCTLR. Normally, when using the provided cache handling
>>>>> routines to enable the caches and MMU, this bit is enabled as well.
>>>>> However, but since we entered the stub with the caches already enabled,
>>>>> this routine is not executed before we call the cache clean routines,
>>>>> resulting in undefined instruction exceptions if the firmware never
>>>>> enabled this bit.
>>>>>
>>>>> So set the bit explicitly in the EFI entry code.
>>>>>
>>>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>>> ---
>>>>>  arch/arm/boot/compressed/head.S | 10 ++++++++++
>>>>>  1 file changed, 10 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
>>>>> index 6c7ccb428c07..62a49356fca3 100644
>>>>> --- a/arch/arm/boot/compressed/head.S
>>>>> +++ b/arch/arm/boot/compressed/head.S
>>>>> @@ -1438,6 +1438,16 @@ ENTRY(efi_stub_entry)
>>>>>
>>>>>               @ Preserve return value of efi_entry() in r4
>>>>>               mov     r4, r0
>>>>> +
>>>>> +             @ our cache maintenance code relies on CP15 barrier instructions
>>>>> +             @ but since we arrived here with the MMU and caches configured
>>>>> +             @ by UEFI, we must ensure that the use of those instructions is
>>>>> +             @ enabled in the SCTLR register, since we never executed our own
>>>>> +             @ cache enable routine, which is normally in charge of this.
>>>>> +             mrc     p15, 0, r1, c1, c0, 0   @ read SCTLR
>>>>> +             orr     r1, r1, #(1 << 5)       @ CP15 barrier instructions
>>>>> +             mcr     p15, 0, r1, c1, c0, 0   @ write SCTLR
>>>>> +
>>>>
>>>> To be on the safe side, you could add an isb here. I'm pretty sure it
>>>> is immaterial on any ARMv7 core, but hey, I'm paranoid.
>>>>
>>>
>>> Well, this is actually triggering now under KVM, so I wonder if this
>>> is a regression of some kind on the host side. But the EFI stub
>>> shouldn't use CP15 barriers without enabling them, so we need this
>>> patch in any case.
>>
>> My remark was only about the lack of an ISB instruction after the
>> write to SCTLR, and you're perfectly right to enable CP15BEN.
>>
> 
> Actually, the CP15 ISB is not usable here, and using the v7 ISB breaks
> v6. Would reading back SCTLR suffice?

I don't think it would, at least from an architectural perspective. But
any CPU that has a non RAO/WI SCTLR.CP15BEN must also support the
architected barriers, otherwise it wouldn't be able to flip them back
on. I believe this is the case on all ARMv6 CPUs.

We could write something like:

	mrc	p15, 0, r1, c1, c0, 0	@ read SCTLR
	tst	r1, r1, #(1 << 5)
	bne	1f
	orr	r1, r1, #(1 << 5)	@ CP15 barrier instructions
	mcr	p15, 0, r1, c1, c0, 0	@ write SCTLR
	isb
1:

What do you think?

> 
>> But there is something fishy. Looking at the KVM/arm64 code,
>> SCTLR_EL1.CP15BEN resets to 1. If the barrier undefs in the stubs,
>> something must have cleared it (or the reset code is busted...).
>>
>> I've dumped SCTLR from a guest running EFI (using GDB), and I do see
>> SCTLR.CP15EN being set...
>>
> 
> Yeah. I won't be able to dig into this for a while, but in the mean
> time, I'd like to get a guest fix in in any case.

Absolutely. These are two distinct issues, and the first one definitely
needs addressing.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
