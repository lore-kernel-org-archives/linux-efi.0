From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire section
Date: Sun, 20 Nov 2016 17:07:44 +0000
Message-ID: <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
 <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain> <20161017185801.GT25086@rric.localdomain>
 <20161027160136.GD24290@arm.com> <20161028091905.GM22012@rric.localdomain>
 <20161107210514.GP20591@arm.com> <20161109195132.GZ22012@rric.localdomain>
 <20161117142528.GJ22855@arm.com> <20161117151805.GJ2151@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161117151805.GJ2151-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 November 2016 at 15:18, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> Thanks for your answer.
>
> On 17.11.16 14:25:29, Will Deacon wrote:
>> On Wed, Nov 09, 2016 at 08:51:32PM +0100, Robert Richter wrote:
>> > Thus, I don't see where my patch breaks code. Even acpi_os_ioremap()
>> > keeps the same behaviour as before since it still uses memblock_is_
>> > memory(). Could you more describe your concerns why do you think this
>> > patch breaks the kernel and moves the problem somewhere else? I
>> > believe it fixes the problem at all.
>>
>> acpi_os_ioremap always ends up in __ioremap_caller, regardless of
>> memblock_is_memory(). __ioremap_caller then fails if pfn_valid is true.
>
> But that's the reason my patch changed the code to use memblock_is_
> map_memory() instead. I was looking into the users of pfn_valid() esp.
> in arm64 code and changed it where required.
>
> This week I looked into the kernel again for code that might break by
> a pfn_valid() change. I found try_ram_remap() in memremap.c that has
> changed behaviour now, but this is explicit for MEMREMAP_WB, so it
> should be fine.
>
> Maybe it might be better to use page_is_ram() in addition to
> pfn_valid() where necessary. This should work now after commit:
>
>  e7cd190385d1 arm64: mark reserved memblock regions explicitly in iomem
>
> I still think pfn_valid() is not the correct use to determine the mem
> attributes for mappings, there are further checks required.
>
> The risk of breaking something with my patch is small and limited only
> to the mapping of efi reserved regions (which is the state of 4.4). If
> something breaks anyway it can easily be fixed by adding more checks
> to pfn_valid() as suggested above.
>

As I noted before, it looks to me like setting CONFIG_HOLES_IN_ZONE is
the correct way to address this. However, doing that does uncover a
bug in move_freepages() where the VM_BUG_ON_PAGE() dereferences struct
page fields before the pfn_valid_within() check, so it seems those
need to be switched around.

Robert, you mentioned that CONFIG_HOLES_IN_ZONE seems inappropriate
for sparsemem. Care to elaborate why?
