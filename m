From: Robert Richter <robert.richter@cavium.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Thu, 24 Nov 2016 14:42:38 +0100
Message-ID: <20161124134238.GI10776@rric.localdomain>
References: <20161017185801.GT25086@rric.localdomain>
 <20161027160136.GD24290@arm.com>
 <20161028091905.GM22012@rric.localdomain>
 <20161107210514.GP20591@arm.com>
 <20161109195132.GZ22012@rric.localdomain>
 <20161117142528.GJ22855@arm.com>
 <20161117151805.GJ2151@rric.localdomain>
 <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
 <20161123211538.GH10776@rric.localdomain>
 <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Robert Richter <rric@kernel.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 23.11.16 21:25:06, Ard Biesheuvel wrote:
> Why? MEMREMAP_WB is used often, among other things for mapping
> firmware tables, which are marked as NOMAP, so in these cases, the
> linear address is not mapped.

If fw tables are mapped wb, that is wrong and needs a separate fix.

> > If you think pfn_valid() is wrong here, I am happy to send a patch
> > that fixes this by using page_is_ram(). In any case, the worst case
> > that may happen is to behave the same as v4.4, we might fix then the
> > wrong use of pfn_valid() where it is not correctly used to check for
> > ram.
> >
> 
> page_is_ram() uses string comparisons to look for regions called
> 'System RAM'. Is that something we can tolerate for each pfn_valid()
> calll?
> 
> Perhaps the solution is to reimplement page_is_ram() for arm64 using
> memblock_is_memory() instead, But that still means we need to modify
> the generic memremap() code first to switch to it before changing the
> arm64 implementation of pfn_valid

No, that's not the solution. pfn_valid() should just check if there is
a valid struct page, as other archs do. And if there is a mis-use of
pfn_valid() to check for ram, only that calls should be fixed to use
page_is_ram(), however this is implemented, or something appropriate.
But I don't see any problematic code, and if so, I will fix that.

-Robert
