From: Robert Richter <robert.richter@cavium.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Thu, 17 Nov 2016 16:18:05 +0100
Message-ID: <20161117151805.GJ2151@rric.localdomain>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
 <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain>
 <20161017185801.GT25086@rric.localdomain>
 <20161027160136.GD24290@arm.com>
 <20161028091905.GM22012@rric.localdomain>
 <20161107210514.GP20591@arm.com>
 <20161109195132.GZ22012@rric.localdomain>
 <20161117142528.GJ22855@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20161117142528.GJ22855@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Robert Richter <rric@kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

Thanks for your answer.

On 17.11.16 14:25:29, Will Deacon wrote:
> On Wed, Nov 09, 2016 at 08:51:32PM +0100, Robert Richter wrote:
> > Thus, I don't see where my patch breaks code. Even acpi_os_ioremap()
> > keeps the same behaviour as before since it still uses memblock_is_
> > memory(). Could you more describe your concerns why do you think this
> > patch breaks the kernel and moves the problem somewhere else? I
> > believe it fixes the problem at all.
> 
> acpi_os_ioremap always ends up in __ioremap_caller, regardless of
> memblock_is_memory(). __ioremap_caller then fails if pfn_valid is true.

But that's the reason my patch changed the code to use memblock_is_
map_memory() instead. I was looking into the users of pfn_valid() esp.
in arm64 code and changed it where required.

This week I looked into the kernel again for code that might break by
a pfn_valid() change. I found try_ram_remap() in memremap.c that has
changed behaviour now, but this is explicit for MEMREMAP_WB, so it
should be fine.

Maybe it might be better to use page_is_ram() in addition to
pfn_valid() where necessary. This should work now after commit:

 e7cd190385d1 arm64: mark reserved memblock regions explicitly in iomem

I still think pfn_valid() is not the correct use to determine the mem
attributes for mappings, there are further checks required.

The risk of breaking something with my patch is small and limited only
to the mapping of efi reserved regions (which is the state of 4.4). If
something breaks anyway it can easily be fixed by adding more checks
to pfn_valid() as suggested above.

-Robert
