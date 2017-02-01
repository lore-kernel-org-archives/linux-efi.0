From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: fdt: avoid FDT manipulation after ExitBootServices()
Date: Wed, 1 Feb 2017 13:41:11 +0000
Message-ID: <CAKv+Gu8gUqqczZiZTaoPFn_1Fb2GsjoXK+yzQdxwtyjfR_LGnA@mail.gmail.com>
References: <1485954693-25750-1-git-send-email-ard.biesheuvel@linaro.org> <CAF7UmSyYvmo8k910mJEAYhaOJy9j_bpXw6f+Cj=cS_m_iYiCCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAF7UmSyYvmo8k910mJEAYhaOJy9j_bpXw6f+Cj=cS_m_iYiCCQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 February 2017 at 13:39, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 1 February 2017 at 13:11, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Some AArch64 UEFI implementations disable the MMU in ExitBootServices(),
>> after which unaligned accesses to RAM are no longer supported.
>>
>> Commit abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the
>> kernel") fixed an issue in the memory map handling of the stub FDT code,
>> but inadvertently created an issue with such firmwares, by moving some
>> of the FDT manipulation to after the invocation of ExitBootServices().
>> However, the stub's libfdt implementation uses the ordinary, accelerated
>> string functions, which rely on hardware handling of unaligned accesses,
>> resulting in alignment faults when executed with the MMU off.
>>
>> Whether disabling the MMU in ExitBootServices() complies with the UEFI
>> spec is unclear, but it is a reality we have to deal with, given that
>> it wasn't a problem before commit abfb7b686a3e was applied.
>
> I'm not sure it's unclear, but someone not reading the specification
> and instead looking
> at what the unfortunate LinuxLoader did might incorrectly deduce that
> such is the case.
>
>> So fix the situation by moving the update_fdt_memmap() into the callback
>> invoked by efi_exit_boot_services() right before it hits the button.
>>
>> Fixes: abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the kernel")
>
> I would sort argue against the Fixes: tag, given that I don't consider
> that code to be
> incorrect.
>

Well, that patch ended up in -stable, and is breaking actual systems
that worked 'fine' before.

> I agree that this is a good change regardless.
>

Cheers.
