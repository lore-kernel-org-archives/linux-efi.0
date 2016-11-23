From: Robert Richter <robert.richter@cavium.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Wed, 23 Nov 2016 22:15:38 +0100
Message-ID: <20161123211538.GH10776@rric.localdomain>
References: <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain>
 <20161017185801.GT25086@rric.localdomain>
 <20161027160136.GD24290@arm.com>
 <20161028091905.GM22012@rric.localdomain>
 <20161107210514.GP20591@arm.com>
 <20161109195132.GZ22012@rric.localdomain>
 <20161117142528.GJ22855@arm.com>
 <20161117151805.GJ2151@rric.localdomain>
 <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
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

On 20.11.16 17:07:44, Ard Biesheuvel wrote:
> On 17 November 2016 at 15:18, Robert Richter <robert.richter@cavium.com> wrote:

> > The risk of breaking something with my patch is small and limited only
> > to the mapping of efi reserved regions (which is the state of 4.4). If
> > something breaks anyway it can easily be fixed by adding more checks
> > to pfn_valid() as suggested above.
> >
> 
> As I noted before, it looks to me like setting CONFIG_HOLES_IN_ZONE is
> the correct way to address this. However, doing that does uncover a
> bug in move_freepages() where the VM_BUG_ON_PAGE() dereferences struct
> page fields before the pfn_valid_within() check, so it seems those
> need to be switched around.
> 
> Robert, you mentioned that CONFIG_HOLES_IN_ZONE seems inappropriate
> for sparsemem. Care to elaborate why?

HOLES_IN_ZONE is of rare use in the kernel. I think it was introduced
to save memory for the memmap and only some single systems enable it.
There is no architecture that enables it entirely. For good reasons...

It introduces additional checks. pfn_valid() is usually checked only
once for the whole memmap. There are a number of checks enabled, just
grep for pfn_valid_within. This will increase the number of
pfn_valid() calls by a factor of MAX_ORDER_NR_PAGES, in my config this
is 8k. So, this is not the direction to go.

My patch fixes a regression in the kernel that was introduced by the
nomap implementation. Some systems can not boot anymore, beside of
that the BUG_ON() may occur any time depending only on physical page
access, we need to fix 4.9. Here is a reproducer:

 https://patchwork.kernel.org/patch/9407677/

My patch also does not break memremap(). With my patch applied
try_ram_remap() would return a linear addr for nomap regions. But this
is only called if WB is explicitly requested, so it should not happen.
If you think pfn_valid() is wrong here, I am happy to send a patch
that fixes this by using page_is_ram(). In any case, the worst case
that may happen is to behave the same as v4.4, we might fix then the
wrong use of pfn_valid() where it is not correctly used to check for
ram.

-Robert
