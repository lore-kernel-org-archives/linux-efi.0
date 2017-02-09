From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: arm-stub: Correct FDT and initrd allocation rules
 for arm64
Date: Thu, 9 Feb 2017 17:45:54 +0000
Message-ID: <CAKv+Gu9fwzgbfGosVcGGqJHLhW=79LWhg4vS4MWEtTdBEHbNUw@mail.gmail.com>
References: <1486635389-26974-1-git-send-email-ard.biesheuvel@linaro.org>
 <dcd9e959-eb73-6703-2d23-06065e4ccaf6@codeaurora.org>
 <CAKv+Gu8Lr2KmEgJU4_GA8qm5_OZfYZECH0-=OBTDJ=1-5fAsnw@mail.gmail.com>
 <5595ed30-3c97-8d7b-154a-9af474a4e22c@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <5595ed30-3c97-8d7b-154a-9af474a4e22c@codeaurora.org>
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

On 9 February 2017 at 17:41, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
> On 2/9/2017 10:16 AM, Ard Biesheuvel wrote:
>>
>> On 9 February 2017 at 17:06, Jeffrey Hugo <jhugo@codeaurora.org> wrote:
>>>
>>> On 2/9/2017 3:16 AM, Ard Biesheuvel wrote:
>>>>
>>>>
>>>> On arm64, we have made some changes over the past year to the way the
>>>> kernel itself is allocated and to how it deals with the initrd and FDT.
>>>> This patch brings the allocation logic in the EFI stub in line with
>>>> that,
>>>> which is necessary because the introduction of KASLR has created the
>>>> possibility for the initrd to be allocated in a place where the kernel
>>>> may not be able to map it. (This is currently a theoretical scenario,
>>>> since it only affects systems where the size of RAM exceeds the size of
>>>> the linear mapping.)
>>>>
>>>> So adhere to the arm64 boot protocol, and make sure that the initrd is
>>>> fully inside a 1GB aligned 32 GB window that covers the kernel as well.
>>>>
>>>> The FDT may be anywhere in memory on arm64 now that we map it via the
>>>> fixmap, so we can lift the address restriction there completely.
>>>>
>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>> ---
>>>
>>>
>>>
>>> I'll give this a test on our platform that was running into the current
>>> limitation - probably this weekend.
>>>
>>> I reviewed the code and its ok, but I do have one question.  Do we need
>>> to
>>> handle the case where initrd ends up below the kernel?
>>>
>>> Lets assume KALSR puts the kernel somewhere up high in DDR, after the
>>> 32GB
>>> mark in DDR.  Now lets assume the unlikely scenario that the initrd won't
>>> fit anywhere after 32GB, but will fit before 32GB.  Per my understanding
>>> of
>>> efi_high_alloc, it will put the initrd before the 32GB mark, which will
>>> be
>>> outside of the window where the kernel is.
>>>
>>
>> The 32 GB does not have to be 32 GB aligned, only 1 GB aligned. So as
>> long as the follow expression holds, we should be fine
>>
>>
>> align(max(kernel_end, initrd_end), 1g) - align_down (min
>> (kernel_start, initrd_start), 1g) <= 32g
>
>
> Yes, and I argue there is a possibility (we'll call it extremely remote)
> where that may not hold.  My question is, do we care about that possibility,
> and if so, do we do anything about it?
>

We allocate top down, so we start at align_down(base_of_image, 1g) +
32g, and go down until we hit a region that first our initrd. We will
disregard the region that the kernel occupies, but below that, we will
just proceed until we find a slot. This effectively means we have a 63
GB window, with the kernel in the middle, where we can load the initrd
and adhere to the boot protocol. I don't see how we could end up in
the situation where we load the kernel somewhere, and both the 31 GB
before *and* after are completely occupied.
