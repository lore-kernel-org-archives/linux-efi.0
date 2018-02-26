From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/2] efi/esrt: mark ESRT memory region as nomap
Date: Mon, 26 Feb 2018 15:07:11 +0000
Message-ID: <CAKv+Gu9WUU6_YoOr1ZptxyoTi0pbKUUPVhFX9DOvDbTw3Bsz-A@mail.gmail.com>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <1519414953-5478-3-git-send-email-tbaicar@codeaurora.org> <CAKv+Gu8bYzctzXKdYVDUDte=KoCPS1bzVoA6JYmidbc0ZrcZ+A@mail.gmail.com>
 <9e3fa182-0635-108f-590b-6f1966bdabe0@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <9e3fa182-0635-108f-590b-6f1966bdabe0@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>
Cc: James Morse <james.morse@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Hugo <jhugo@codeaurora.org>, Sameer Goel <sgoel@codeaurora.org>, Timur Tabi <timur@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On 26 February 2018 at 15:06, Tyler Baicar <tbaicar@codeaurora.org> wrote:
> Hello Ard,
>
>
> On 2/24/2018 3:03 AM, Ard Biesheuvel wrote:
>>
>> Hi Tyler,
>>
>> On 23 February 2018 at 19:42, Tyler Baicar <tbaicar@codeaurora.org> wrote:
>>>
>>> The ESRT memory region is being exposed as System RAM in /proc/iomem
>>> which is wrong because it cannot be overwritten. This memory is needed
>>> for kexec kernels in order to properly initialize ESRT, so if it is
>>> overwritten it will cause ESRT failures in the kexec kernel. Mark this
>>> region as nomap so that it is not overwritten.
>>>
>> This is not the right fix. We should only mark regions NOMAP if it is
>> uncertain whether the firmware may have a mapping of the same region
>> with mismatched attributes. NOMAP regions punch holes in the linear
>> region, increasing its TLB footprint significantly, so we should avoid
>> them if we can.
>
> Thanks for the explanation, that makes sense.
>>
>> This same issue has come up in relation to mapping ACPI tables after
>> kexec. This should simply be a matter of ensuring that all
>> memblock_reserve()d region appear as such in /proc/iomem rather than
>> as 'System RAM'
>
> Do you know why this memory region would be coming up as System RAM rather
> than reserved if we're
> calling memblock_reserve() on it in efi_mem_reserve()?
>

I don't think there is any special handling of memblock_reserve()'d
regions at all at the moment.
