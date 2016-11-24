From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire section
Date: Thu, 24 Nov 2016 13:44:31 +0000
Message-ID: <CAKv+Gu_Ug3XOD6jy5xziy1pS7WV=TC0RLD4j3DT6nytujQDzRQ@mail.gmail.com>
References: <20161017185801.GT25086@rric.localdomain> <20161027160136.GD24290@arm.com>
 <20161028091905.GM22012@rric.localdomain> <20161107210514.GP20591@arm.com>
 <20161109195132.GZ22012@rric.localdomain> <20161117142528.GJ22855@arm.com>
 <20161117151805.GJ2151@rric.localdomain> <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
 <20161123211538.GH10776@rric.localdomain> <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
 <20161124134238.GI10776@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161124134238.GI10776-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 November 2016 at 13:42, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> On 23.11.16 21:25:06, Ard Biesheuvel wrote:
>> Why? MEMREMAP_WB is used often, among other things for mapping
>> firmware tables, which are marked as NOMAP, so in these cases, the
>> linear address is not mapped.
>
> If fw tables are mapped wb, that is wrong and needs a separate fix.
>

Why is that wrong?

>> > If you think pfn_valid() is wrong here, I am happy to send a patch
>> > that fixes this by using page_is_ram(). In any case, the worst case
>> > that may happen is to behave the same as v4.4, we might fix then the
>> > wrong use of pfn_valid() where it is not correctly used to check for
>> > ram.
>> >
>>
>> page_is_ram() uses string comparisons to look for regions called
>> 'System RAM'. Is that something we can tolerate for each pfn_valid()
>> calll?
>>
>> Perhaps the solution is to reimplement page_is_ram() for arm64 using
>> memblock_is_memory() instead, But that still means we need to modify
>> the generic memremap() code first to switch to it before changing the
>> arm64 implementation of pfn_valid
>
> No, that's not the solution. pfn_valid() should just check if there is
> a valid struct page, as other archs do. And if there is a mis-use of
> pfn_valid() to check for ram, only that calls should be fixed to use
> page_is_ram(), however this is implemented, or something appropriate.
> But I don't see any problematic code, and if so, I will fix that.
>

memremap() uses pfn_valid() to decide whether some address is covered
by the linear mapping. If we correct pfn_valid() to adhere to your
definition, we will need to fix memremap() first in any case.
