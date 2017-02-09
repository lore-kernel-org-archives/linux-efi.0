From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: arm-stub: Correct FDT and initrd allocation rules
 for arm64
Date: Thu, 9 Feb 2017 19:33:58 +0000
Message-ID: <CAKv+Gu9WbBb8DV=UQVn7DbBg4BsmnwHZDXF5syv0gweLqoPkhA@mail.gmail.com>
References: <1486635389-26974-1-git-send-email-ard.biesheuvel@linaro.org>
 <dcd9e959-eb73-6703-2d23-06065e4ccaf6@codeaurora.org>
 <CAKv+Gu8Lr2KmEgJU4_GA8qm5_OZfYZECH0-=OBTDJ=1-5fAsnw@mail.gmail.com>
 <5595ed30-3c97-8d7b-154a-9af474a4e22c@codeaurora.org>
 <CAKv+Gu9fwzgbfGosVcGGqJHLhW=79LWhg4vS4MWEtTdBEHbNUw@mail.gmail.com>
 <75121ecb-5ee6-202d-8cfa-a90d323d1bc5@codeaurora.org>
 <CAKv+Gu8iA3eed6nHXvwez8=fjEvL1M+KzepUyM7cnNeqZSUBhw@mail.gmail.com>
 <CAKv+Gu-EPdcLFBmHoVB4UROrUSkYorgn5a9SX1wpAD_30=1tGw@mail.gmail.com>
 <4460d4cd-5f31-2fa4-359a-a81a6a1c4197@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <4460d4cd-5f31-2fa4-359a-a81a6a1c4197@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Timur Tabi <timur@codeaurora.org>, Leif Lindholm <leif.lindholm@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 9 February 2017 at 19:04, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
> On 2/9/2017 11:26 AM, Ard Biesheuvel wrote:
>>
>> BTW the memory map isn't necessarily sorted per the UEFI spec, so it
>> iterates in what is essentially random order, not low to high.
>
>
> True, I'm used to EDK2, which from what I've seen, keeps it ordered. However
> that's somewhat immaterial to my point that its possible for initrd to be
> far enough from kernel to break booting.txt
>
>>
>>>> It looks to see
>>>> if a slot can hold the allocation, and the slot does not exceed the
>>>> specified max.  If so, efi_high_alloc retains a reference to the slot.
>>>> Then
>>>> efi_high_alloc continues iterating though the map, until the end.
>>>> efi_high_alloc only stores a reference to the most recently valid slot,
>>>> which would be the highest slot in the map.
>>>>
>>>
>>> It is documented as
>>>
>>> /*
>>>  * Allocate at the highest possible address that is not above 'max'.
>>>  */
>>>
>>> and what you describe is pretty much that, no?
>>>
>>>> My system can have 256GB (or more) of RAM.  It is possible, however
>>>> remote,
>>>> that the initrd and kernel can be more than 64GB away from each other.
>>>>
>>>> Lets assume KASLR puts the kernel at 250GB.  Lets assume, for whatever
>>>> reason, we can't fit the initrd above 150GB (there was just enough room
>>>> to
>>>> jam kernel there somwhow, but firmware is consuming the rest, maybe it
>>>> put
>>>> rootfs there via NFIT).
>>>
>>>
>>> So before even booting the kernel, you already have 100 GB of memory
>>> occupied?
>
>
> That is possible, yes.  Likely?  Probably not.  Would our system fail if
> initrd and kernel are father than the prescribed restriction?  No, since the
> system can address all of RAM, we'd probably be fine.
>
>>> As I replied before, you are correct that in this case, you
>>> will not be able to put the initrd within 32 GB of the kernel. But do
>>> note that this 32 GB figure is derived from the linear region size of
>>> a 16k pages kernel with 2 levels of translation, which is a niche
>>> configuration by itself. On a system that has 256 GB of RAM, it is
>>> highly unlikely that you will be using a kernel that can only map 32
>>> GB of it.
>>>
>>> The reason for choosing the 32 GB figure is that it relieves the boot
>>> loader from having to go and figure out what kind of kernel is going
>>> to be executed. Page size can be read from the Image header but the VA
>>> size cannot. So 32 GB was a reasonable number imo.
>
>
> Ok, so the restriction is completely arbitrary and has no real purpose. Ie
> nothing in the kernel will break, so long as you assume the system is not
> configured with more RAM than can be addressed, which doesn't feel
> reasonable to do.
>
> I realize I'm being nitpicky, from my perspective, any issues related to
> efistub are particularly difficult to debug, so if this scenario we've been
> going around about ever popped up, it wouldn't even give you a print that
> happened when you back trace the output trying to figure out why the boot
> failed.
>
> However, it really looks like even if the scenario occurred, there is zero
> realistic expectation anything would break, and its just a violation of some
> document that makes assumptions and should be treated more as guidance to
> try to follow, rather than hard rules.
>

Actually, there is no reason for the stub to adhere 100% to the boot
protocol, and we already violate it deliberately by randomizing the
physical offset with a 64 KB granularity under KASLR, whereas the boot
protocol stipulates that it should be a 2 MB aligned base +
TEXT_OFFSET.

So in this case, I think it is reasonable to take VA_BITS into account
rather than use a hardcoded 32 GB. That will eliminate the problem
completely when you use a 48-bit VA kernel, and will make it highly
unlikely to ever occur on more common 39 and 42 bit VA configurations.

-- 
Ard.
