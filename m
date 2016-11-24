From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Thu, 24 Nov 2016 14:23:16 +0000
Message-ID: <CAKv+Gu-SXX_Vv1Wi1Nm=5vdaXSS0MBp20QBpQVacSKPLfdH0-A@mail.gmail.com>
References: <20161109195132.GZ22012@rric.localdomain>
 <20161117142528.GJ22855@arm.com>
 <20161117151805.GJ2151@rric.localdomain>
 <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
 <20161123211538.GH10776@rric.localdomain>
 <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
 <20161124134238.GI10776@rric.localdomain>
 <CAKv+Gu_Ug3XOD6jy5xziy1pS7WV=TC0RLD4j3DT6nytujQDzRQ@mail.gmail.com>
 <20161124135151.GJ10776@rric.localdomain>
 <CAKv+Gu9qB7P2epMGdwFJ3vJR3vt-bBxU0nKwmKdpaOpTKdqzzA@mail.gmail.com>
 <20161124141149.GE2213@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161124141149.GE2213@rric.localdomain>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Robert Richter <robert.richter@cavium.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Robert Richter <rric@kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 24 November 2016 at 14:11, Robert Richter <robert.richter@cavium.com> wrote:
> On 24.11.16 13:58:30, Ard Biesheuvel wrote:
>> On 24 November 2016 at 13:51, Robert Richter <robert.richter@cavium.com> wrote:
>> > On 24.11.16 13:44:31, Ard Biesheuvel wrote:
>> >> On 24 November 2016 at 13:42, Robert Richter <robert.richter@cavium.com> wrote:
>> >> > On 23.11.16 21:25:06, Ard Biesheuvel wrote:
>> >> >> Why? MEMREMAP_WB is used often, among other things for mapping
>> >> >> firmware tables, which are marked as NOMAP, so in these cases, the
>> >> >> linear address is not mapped.
>> >> >
>> >> > If fw tables are mapped wb, that is wrong and needs a separate fix.
>> >> >
>> >>
>> >> Why is that wrong?
>> >
>> > The whole issue with mapping acpi tables is not marking them cachable,
>> > what wb does.
>>
>> What 'issue'?
>>
>> > Otherwise we could just use linear mapping for those mem
>> > ranges.
>> >
>>
>> Regions containing firmware tables are owned by the firmware, and it
>> is the firmware that tells us which memory attributes we are allowed
>> to use. If those attributes include WB, it is perfectly legal to use a
>> cacheable mapping. That does *not* mean they should be covered by the
>> linear mapping. The linear mapping is read-write-non-exec, for
>> instance, and we may prefer to use a read-only mapping and/or
>> executable mapping.
>
> Ok, I am going to fix try_ram_remap().
>

Thanks. Could you also add an arm64 version of page_is_ram() that uses
memblock_is_memory() while you're at it? I think using memblock
directly in try_ram_remap() may not be the best approach

> Are there other concerns with this patch?
>

I think we all agree that pfn_valid() should return whether a pfn has
a struct page associated with it, the debate is about whether it makes
sense to allocate struct pages for memory that the kernel does not
own. But given that it does not really hurt to do so for small holes,
I think your suggestion makes sense.

Should we be doing anything more to ensure that those pages are not
dereferenced inadvertently? Is there a page flag we should be setting?
