From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire section
Date: Wed, 23 Nov 2016 21:25:06 +0000
Message-ID: <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
References: <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain> <20161017185801.GT25086@rric.localdomain>
 <20161027160136.GD24290@arm.com> <20161028091905.GM22012@rric.localdomain>
 <20161107210514.GP20591@arm.com> <20161109195132.GZ22012@rric.localdomain>
 <20161117142528.GJ22855@arm.com> <20161117151805.GJ2151@rric.localdomain>
 <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com> <20161123211538.GH10776@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161123211538.GH10776-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 November 2016 at 21:15, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> On 20.11.16 17:07:44, Ard Biesheuvel wrote:
>> On 17 November 2016 at 15:18, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>
>> > The risk of breaking something with my patch is small and limited only
>> > to the mapping of efi reserved regions (which is the state of 4.4). If
>> > something breaks anyway it can easily be fixed by adding more checks
>> > to pfn_valid() as suggested above.
>> >
>>
>> As I noted before, it looks to me like setting CONFIG_HOLES_IN_ZONE is
>> the correct way to address this. However, doing that does uncover a
>> bug in move_freepages() where the VM_BUG_ON_PAGE() dereferences struct
>> page fields before the pfn_valid_within() check, so it seems those
>> need to be switched around.
>>
>> Robert, you mentioned that CONFIG_HOLES_IN_ZONE seems inappropriate
>> for sparsemem. Care to elaborate why?
>
> HOLES_IN_ZONE is of rare use in the kernel. I think it was introduced
> to save memory for the memmap and only some single systems enable it.
> There is no architecture that enables it entirely. For good reasons...
>
> It introduces additional checks. pfn_valid() is usually checked only
> once for the whole memmap. There are a number of checks enabled, just
> grep for pfn_valid_within. This will increase the number of
> pfn_valid() calls by a factor of MAX_ORDER_NR_PAGES, in my config this
> is 8k. So, this is not the direction to go.
>

That does sound like a potential issue. But does it cause any slowdown
in practice?

The reality is that CONFIG_HOLES_IN_ZONE perfectly describes the
situation, and so it is still my preferred option if the performance
hit is tolerable.

> My patch fixes a regression in the kernel that was introduced by the
> nomap implementation. Some systems can not boot anymore, beside of
> that the BUG_ON() may occur any time depending only on physical page
> access, we need to fix 4.9. Here is a reproducer:
>
>  https://patchwork.kernel.org/patch/9407677/
>
> My patch also does not break memremap(). With my patch applied
> try_ram_remap() would return a linear addr for nomap regions. But this
> is only called if WB is explicitly requested, so it should not happen.

Why? MEMREMAP_WB is used often, among other things for mapping
firmware tables, which are marked as NOMAP, so in these cases, the
linear address is not mapped.

> If you think pfn_valid() is wrong here, I am happy to send a patch
> that fixes this by using page_is_ram(). In any case, the worst case
> that may happen is to behave the same as v4.4, we might fix then the
> wrong use of pfn_valid() where it is not correctly used to check for
> ram.
>

page_is_ram() uses string comparisons to look for regions called
'System RAM'. Is that something we can tolerate for each pfn_valid()
calll?

Perhaps the solution is to reimplement page_is_ram() for arm64 using
memblock_is_memory() instead, But that still means we need to modify
the generic memremap() code first to switch to it before changing the
arm64 implementation of pfn_valid
