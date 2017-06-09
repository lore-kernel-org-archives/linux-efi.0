From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: arm: Don't mark ACPI reclaim memory as MEMBLOCK_NOMAP
Date: Fri, 9 Jun 2017 09:01:52 +0000
Message-ID: <CAKv+Gu8sfKu-3E2kQtni7VuRTE-RFivN_suT+GPz2bnNkfMqaw@mail.gmail.com>
References: <20170605080435.2498-1-ard.biesheuvel@linaro.org> <20170605090847.GC4650@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170605090847.GC4650@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 June 2017 at 09:08, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Mon, Jun 05, 2017 at 08:04:35AM +0000, Ard Biesheuvel wrote:
>> On ARM, regions of memory that are described by UEFI as having special
>> significance to the firmware itself are omitted from the linear mapping.
>> This is necessary since we cannot guarantee that alternate mappings of
>> the same physical region will use attributes that are compatible with
>> the ones we use for the linear mapping, and aliases with mismatched
>> attributes are prohibited by the architecture.
>>
>> The above does not apply to ACPI reclaim regions: such regions have no
>> special significance to the firmware, and it is up to the OS to decide
>> whether or not to preserve them after it has consumed their contents,
>> and for how long, after which time the OS can use the memory in any way
>> it likes. In the Linux case, such regions are preserved indefinitely,
>> and are simply treated the same way as other 'reserved' memory types.
>>
>> Punching holes into the linear mapping causes page table fragmentation,
>> which increases TLB pressure, and so we should avoid doing so if we can.
>> So add a special case for regions of type EFI_ACPI_RECLAIM_MEMORY, and
>> memblock_reserve() them instead of marking them MEMBLOCK_NOMAP.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Sounds sane to me. FWIW:
>
> Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>

Thanks.

I have queued this in efi/next
