From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] efi: Fix warning of int-to-pointer-cast on x86 32-bit builds
Date: Tue, 27 Oct 2015 11:33:55 +0900
Message-ID: <CAKv+Gu-1MfUJiF5idd0KoziUxhrDStmRwXQZHuX+gwnJvq083g@mail.gmail.com>
References: <1445593826-4578-1-git-send-email-izumi.taku@jp.fujitsu.com>
	<CAKv+Gu8WPvG5rzBB57eK1_Ehj1wB19wR=zzBDRoQbmhRfpCGng@mail.gmail.com>
	<20151026210235.GA3526@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151026210235.GA3526@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>, Ingo Molnar <mingo.kernel.org@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kamezawa.hiroyu@jp.fujitsu.com, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 27 October 2015 at 06:02, Matt Fleming <matt@codeblueprint.co.uk> wrote:
> On Fri, 23 Oct, at 10:37:46AM, Ard Biesheuvel wrote:
>>
>> After looking at the original (already merged) patch 11/11 again, I
>> realize this is still not right: the problem is that efi_memory_map's
>> phys_map member uses a void* type to hold a physical address, which
>> happens to be correct in the normal case even when phys_addr_t is
>> larger than void* (like on ARM with LPAE enabled) since the address it
>> holds is the address of an allocation performed by the firmware, which
>> only uses 1:1 addressable memory.
>>
>> However, overwriting memmap.phys_map with a value produced my
>> memblock_alloc() is problematic, since the allocation may be above 4
>> GB on 32-bit (L)PAE platforms. So the correct way to do this would be
>> to set the memblock limit to 4GB before memblock_alloc() on 32-bit
>> platforms, and restore it afterwards. This is a bit of a kludge,
>> though, and it would be more correct to change the type of
>> efi_memory_map::phys_map to phys_addr_t, although I don't know what
>> the potential fallout of that change is. Matt?
>
> I think that should be fine. The only potentially tricky situation we
> could encounter is where 32-bit x86 firmware uses PAE but the kernel
> is built without support.
>
> But that's not something I've ever seen enabled in the firmware and
> there's a bunch of assumptions in the kernel already that would break
> in that case.
>

Does UEFI even allow that? Even if it can describe memory over 4 GB,
it uses a flat mapping so allocations done by the stub (which
retrieves the memory map) should never reside at addresses over 4 GB.

-- 
Ard.
