From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: fix boundary checking in efi_high_alloc()
Date: Tue, 24 Feb 2015 15:17:05 +0000
Message-ID: <CAKv+Gu8w0HLneR9x3TQ56rzrLk+=qnqxi83usuG5CLaSxpBEHQ@mail.gmail.com>
References: <1424405883-19842-1-git-send-email-yinghai@kernel.org>
	<20150223133215.GA19367@codeblueprint.co.uk>
	<20150223141501.GG9714@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150223141501.GG9714@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>, Roy Franz <roy.franz@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 23 February 2015 at 14:15, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi Matt,
>
>> From 1e7295b5d4c5226a160a9167e61b581e388f7f9a Mon Sep 17 00:00:00 2001
>> From: Yinghai Lu <yinghai@kernel.org>
>> Date: Thu, 19 Feb 2015 20:18:03 -0800
>> Subject: [PATCH] efi/libstub: Fix boundary checking in efi_high_alloc()
>>
>> While adding support loading kernel and initrd above 4G to grub2 in legacy
>> mode, I was referring to efi_high_alloc().
>> That will allocate buffer for kernel and then initrd, and initrd will
>> use kernel buffer start as limit.
>>
>> During testing found two buffers will be overlapped when initrd size is
>> very big like 400M.
>>
>> It turns out efi_high_alloc() boundary checking is not right.
>> end - size will be the new start, and should not compare new
>> start with max, we need to make sure end is smaller than max.
>>
>> [ Basically, with the current efi_high_alloc() code it's possible to
>>   allocate memory above 'max', because efi_high_alloc() doesn't check
>>   that the tail of the allocation is below 'max'.
>>
>>   If you have an EFI memory map with a single entry that looks like so,
>>
>>    [0xc0000000-0xc0004000]
>>
>>   And want to allocate 0x3000 bytes below 0xc0003000 the current code
>>   will allocate [0xc0001000-0xc0004000], not [0xc0000000-0xc0003000]
>>   like you would expect. - Matt ]
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: <stable@vger.kernel.org>
>
> I've convinced myself that the new logic is sound, and with this patch
> applied atop of v4.0-rc1 I don't see regressions on the platforms I have
> access to. So:
>
> Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> Tested-by: Mark Rutland <mark.rutland@arm.com>
>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> Ard, Leif:
>
> On a related note, I think that the logic for deciding where to place
> the kernel and DTB isn't quite right. The kernel needs to be in the same
> naturally-aligned 512M region as the DTB in order to be able to map it,
> but the kernel could get relocated above the max address we'll consider
> for the DTB if there isn't sufficient space for the kernel between
> dram_base and dram_base + 512M.
>

It also assumes that dram_base itself is 512M aligned, which may not
necessarily be the case, so yes, that logic seems broken.

> We should try to use the fixmap to map the DTB so it can be located
> anywhere in physical memory. That will make things easier for the stub
> and other loaders.
>

Yes, that would be useful, but I think it shouldn't be /that/ hard to
fix the stub

-- 
Ard.

>> ---
>>  drivers/firmware/efi/libstub/efi-stub-helper.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> index 9bd9fbb5bea8..c927bccd92bd 100644
>> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> @@ -170,12 +170,12 @@ again:
>>               start = desc->phys_addr;
>>               end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
>>
>> -             if ((start + size) > end || (start + size) > max)
>> -                     continue;
>> -
>> -             if (end - size > max)
>> +             if (end > max)
>>                       end = max;
>>
>> +             if ((start + size) > end)
>> +                     continue;
>> +
>>               if (round_down(end - size, align) < start)
>>                       continue;
>>
>> --
>> 1.9.3
>>
>> --
>> Matt Fleming, Intel Open Source Technology Center
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
