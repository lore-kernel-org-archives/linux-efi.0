From: James Morse <james.morse@arm.com>
Subject: Re: [RFC PATCH] arm64: efi: fix chicken-and-egg problem in memreserve
 code
Date: Tue, 22 Jan 2019 11:32:39 +0000
Message-ID: <abe25b84-4327-c927-6d91-629291a62b69@arm.com>
References: <20190118174324.24715-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20190118174324.24715-1-ard.biesheuvel@linaro.org>
Content-Language: en-GB
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
Cc: mark.rutland@arm.com, linux-efi@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On 18/01/2019 17:43, Ard Biesheuvel wrote:
> Unfortunately, it appears that the recently introduced and repaired
> EFI memreserve code is still broken.
> 
> Originally, we applied all memory reservation passed via the EFI table
> before doing any memblock allocations. However, this turned out to be
> problematic, given that the number of reservations is unbounded, and
> a GICv3 system will reserve a block of memory for each CPU, resulting
> in hundreds of reservations.
> 
> We 'fixed' this by deferring the reservations in the memblock table
> until after we enabled memblock resizing. However, to reach this
> point, we must have mapped DRAM and the kernel, which itself relies
> on some memblock allocations for page tables. Also, memblock resizing
> itself relies on the ability to invoke memblock_alloc() to reallocate
> those tables themselves.
> 
> So this is a nice chicken-and-egg problem which is rather difficult
> to fix cleanly. So instead of a clean solution, I came up with the
> patch below.
> 
> The idea is to set a memblock allocation limit below the lowest
> reservation entry that occurs in the memreserve table. This way,
> we can map DRAM and the kernel and enable memblock resizing without
> running the risk of clobbering those reserved regions. After applying
> all the reservations, the memblock limit restriction is lifted again,
> allowing the boot to proceed normally.

.... how does this interact with kdump? Is it possible the crash-kernel region
is above the lowest reservation entry, meaning there is no usable memory?


> The problem with this approach is that it is not guaranteed that the
> temporary limit will leave enough memory to allocate the page tables
> and resize the memblock reserved array. Since this is only 10s of KBs,
> it is unlikely to break in practice, but some pathological behavior
> may still occur, which is rather nasty :-(

As I understand it, the in-kernel-image memblock_reserved_init_regions is used
early on, because we don't know where the reserved regions of memory are, but
INIT_MEMBLOCK_REGIONS should be big enough to describe them. We trip up when it
isn't big enough, and we can't resize it yet.

... thinking out loud ...

Does reserve_regions() know how big that array needs to be?
(it can count the nomap and persistent reservations, as well as the gaps between
memory banks).

Could we 'allocate' that array to be big enough for everything learnt via EFI in
reserve_regions()? It memblock_remove()s all existing memory, so we know at this
point there aren't existing reservations/allocations.


Thanks,

James
