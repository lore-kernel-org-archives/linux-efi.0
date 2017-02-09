From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] efi: arm-stub: Correct FDT and initrd allocation rules
 for arm64
Date: Thu, 9 Feb 2017 11:01:13 -0700
Message-ID: <75121ecb-5ee6-202d-8cfa-a90d323d1bc5@codeaurora.org>
References: <1486635389-26974-1-git-send-email-ard.biesheuvel@linaro.org>
 <dcd9e959-eb73-6703-2d23-06065e4ccaf6@codeaurora.org>
 <CAKv+Gu8Lr2KmEgJU4_GA8qm5_OZfYZECH0-=OBTDJ=1-5fAsnw@mail.gmail.com>
 <5595ed30-3c97-8d7b-154a-9af474a4e22c@codeaurora.org>
 <CAKv+Gu9fwzgbfGosVcGGqJHLhW=79LWhg4vS4MWEtTdBEHbNUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9fwzgbfGosVcGGqJHLhW=79LWhg4vS4MWEtTdBEHbNUw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2/9/2017 10:45 AM, Ard Biesheuvel wrote:
> On 9 February 2017 at 17:41, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>> On 2/9/2017 10:16 AM, Ard Biesheuvel wrote:
>>>
>>> On 9 February 2017 at 17:06, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>>>>
>>>> On 2/9/2017 3:16 AM, Ard Biesheuvel wrote:
>>>>>
>>>>>
>>>>> On arm64, we have made some changes over the past year to the way the
>>>>> kernel itself is allocated and to how it deals with the initrd and FDT.
>>>>> This patch brings the allocation logic in the EFI stub in line with
>>>>> that,
>>>>> which is necessary because the introduction of KASLR has created the
>>>>> possibility for the initrd to be allocated in a place where the kernel
>>>>> may not be able to map it. (This is currently a theoretical scenario,
>>>>> since it only affects systems where the size of RAM exceeds the size of
>>>>> the linear mapping.)
>>>>>
>>>>> So adhere to the arm64 boot protocol, and make sure that the initrd is
>>>>> fully inside a 1GB aligned 32 GB window that covers the kernel as well.
>>>>>
>>>>> The FDT may be anywhere in memory on arm64 now that we map it via the
>>>>> fixmap, so we can lift the address restriction there completely.
>>>>>
>>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>>> ---
>>>>
>>>>
>>>>
>>>> I'll give this a test on our platform that was running into the current
>>>> limitation - probably this weekend.
>>>>
>>>> I reviewed the code and its ok, but I do have one question.  Do we need
>>>> to
>>>> handle the case where initrd ends up below the kernel?
>>>>
>>>> Lets assume KALSR puts the kernel somewhere up high in DDR, after the
>>>> 32GB
>>>> mark in DDR.  Now lets assume the unlikely scenario that the initrd won't
>>>> fit anywhere after 32GB, but will fit before 32GB.  Per my understanding
>>>> of
>>>> efi_high_alloc, it will put the initrd before the 32GB mark, which will
>>>> be
>>>> outside of the window where the kernel is.
>>>>
>>>
>>> The 32 GB does not have to be 32 GB aligned, only 1 GB aligned. So as
>>> long as the follow expression holds, we should be fine
>>>
>>>
>>> align(max(kernel_end, initrd_end), 1g) - align_down (min
>>> (kernel_start, initrd_start), 1g) <= 32g
>>
>>
>> Yes, and I argue there is a possibility (we'll call it extremely remote)
>> where that may not hold.  My question is, do we care about that possibility,
>> and if so, do we do anything about it?
>>
>
> We allocate top down, so we start at align_down(base_of_image, 1g) +
> 32g, and go down until we hit a region that first our initrd. We will
> disregard the region that the kernel occupies, but below that, we will
> just proceed until we find a slot. This effectively means we have a 63
> GB window, with the kernel in the middle, where we can load the initrd
> and adhere to the boot protocol. I don't see how we could end up in
> the situation where we load the kernel somewhere, and both the 31 GB
> before *and* after are completely occupied.
>

No we don't.  We do not allocate top down.  Please look at efi_high_alloc.

Efi_high_alloc iterates though the memory map, low to high.  It looks to 
see if a slot can hold the allocation, and the slot does not exceed the 
specified max.  If so, efi_high_alloc retains a reference to the slot. 
Then efi_high_alloc continues iterating though the map, until the end. 
efi_high_alloc only stores a reference to the most recently valid slot, 
which would be the highest slot in the map.

My system can have 256GB (or more) of RAM.  It is possible, however 
remote, that the initrd and kernel can be more than 64GB away from each 
other.

Lets assume KASLR puts the kernel at 250GB.  Lets assume, for whatever 
reason, we can't fit the initrd above 150GB (there was just enough room 
to jam kernel there somwhow, but firmware is consuming the rest, maybe 
it put rootfs there via NFIT).  efi_high_alloc will put the initrd at 
some point just below 150GB, because it iterates low to high, and 150GB 
will be below the max of 250GB where the kernel is.  This will result in 
the initrd and kernel being ~100GB away in this example, which violates 
the requirements stated in Booting.txt

I see the situation is possible, but I admit it is remote.  If you want 
to ignore it, fine.  I would be happy with that so long as the 
assumption is documented so that if it is ever somehow violated in the 
real world, we know what broke.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
