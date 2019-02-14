From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] arm64: account for GICv3 LPI tables in static
 memblock reserve table
Date: Thu, 14 Feb 2019 17:55:28 +0100
Message-ID: <CAKv+Gu9BpVDg1=2bsR6ouWM2Xw1OZGMOZ4DXv5fQxE=HQXJsRg@mail.gmail.com>
References: <20190213132738.10294-1-ard.biesheuvel@linaro.org>
 <20190213132738.10294-2-ard.biesheuvel@linaro.org>
 <325ae70b-6520-a186-c65f-8ab29a5be3a5@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <325ae70b-6520-a186-c65f-8ab29a5be3a5@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Linux-MM <linux-mm@kvack.org>, James Morse <james.morse@arm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 14 Feb 2019 at 16:48, Marc Zyngier <marc.zyngier@arm.com> wrote:
>
> Hi Ard,
>
> On 13/02/2019 13:27, Ard Biesheuvel wrote:
> > In the irqchip and EFI code, we have what basically amounts to a quirk
> > to work around a peculiarity in the GICv3 architecture, which permits
> > the system memory address of LPI tables to be programmable only once
> > after a CPU reset. This means kexec kernels must use the same memory
> > as the first kernel, and thus ensure that this memory has not been
> > given out for other purposes by the time the ITS init code runs, which
> > is not very early for secondary CPUs.
> >
> > On systems with many CPUs, these reservations could overflow the
> > memblock reservation table, and this was addressed in commit
> > eff896288872 ("efi/arm: Defer persistent reservations until after
> > paging_init()"). However, this turns out to have made things worse,
> > since the allocation of page tables and heap space for the resized
> > memblock reservation table itself may overwrite the regions we are
> > attempting to reserve, which may cause all kinds of corruption,
> > also considering that the ITS will still be poking bits into that
> > memory in response to incoming MSIs.
> >
> > So instead, let's grow the static memblock reservation table on such
> > systems so it can accommodate these reservations at an earlier time.
> > This will permit us to revert the above commit in a subsequent patch.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> >  arch/arm64/include/asm/memory.h | 11 +++++++++++
> >  include/linux/memblock.h        |  3 ---
> >  mm/memblock.c                   | 10 ++++++++--
> >  3 files changed, 19 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> > index e1ec947e7c0c..7e2b13cdd970 100644
> > --- a/arch/arm64/include/asm/memory.h
> > +++ b/arch/arm64/include/asm/memory.h
> > @@ -332,6 +332,17 @@ static inline void *phys_to_virt(phys_addr_t x)
> >  #define virt_addr_valid(kaddr)               \
> >       (_virt_addr_is_linear(kaddr) && _virt_addr_valid(kaddr))
> >
> > +/*
> > + * Given that the GIC architecture permits ITS implementations that can only be
> > + * configured with a LPI table address once, GICv3 systems with many CPUs may
> > + * end up reserving a lot of different regions after a kexec for their LPI
> > + * tables, as we are forced to reuse the same memory after kexec (and thus
> > + * reserve it persistently with EFI beforehand)
> > + */
> > +#if defined(CONFIG_EFI) && defined(CONFIG_ARM_GIC_V3_ITS)
> > +#define INIT_MEMBLOCK_RESERVED_REGIONS       (INIT_MEMBLOCK_REGIONS + 2 * NR_CPUS)
>
> Since GICv3 has 1 pending table per CPU, plus one global property table,
> can we make this 2 * NR_CPUS + 1? Or is that enough already?
>

Ah, I misread the code then. That would mean we'll only need 1 extra
slot per CPU.

So I will change this to

> > +#define INIT_MEMBLOCK_RESERVED_REGIONS       (INIT_MEMBLOCK_REGIONS + NR_CPUS)

considering that INIT_MEMBLOCK_REGIONS defaults to 128, so that one
global table is already accounted for.


> > +#endif
> > +
> >  #include <asm-generic/memory_model.h>
> >
> >  #endif
> > diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> > index 64c41cf45590..859b55b66db2 100644
> > --- a/include/linux/memblock.h
> > +++ b/include/linux/memblock.h
> > @@ -29,9 +29,6 @@ extern unsigned long max_pfn;
> >   */
> >  extern unsigned long long max_possible_pfn;
> >
> > -#define INIT_MEMBLOCK_REGIONS        128
> > -#define INIT_PHYSMEM_REGIONS 4
> > -
> >  /**
> >   * enum memblock_flags - definition of memory region attributes
> >   * @MEMBLOCK_NONE: no special request
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 022d4cbb3618..a526c3ab8390 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -26,6 +26,12 @@
> >
> >  #include "internal.h"
> >
> > +#define INIT_MEMBLOCK_REGIONS                128
> > +#define INIT_PHYSMEM_REGIONS         4
> > +#ifndef INIT_MEMBLOCK_RESERVED_REGIONS
> > +#define INIT_MEMBLOCK_RESERVED_REGIONS       INIT_MEMBLOCK_REGIONS
> > +#endif
> > +
> >  /**
> >   * DOC: memblock overview
> >   *
> > @@ -92,7 +98,7 @@ unsigned long max_pfn;
> >  unsigned long long max_possible_pfn;
> >
> >  static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
> > -static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
> > +static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_RESERVED_REGIONS] __initdata_memblock;
> >  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
> >  static struct memblock_region memblock_physmem_init_regions[INIT_PHYSMEM_REGIONS] __initdata_memblock;
> >  #endif
> > @@ -105,7 +111,7 @@ struct memblock memblock __initdata_memblock = {
> >
> >       .reserved.regions       = memblock_reserved_init_regions,
> >       .reserved.cnt           = 1,    /* empty dummy entry */
> > -     .reserved.max           = INIT_MEMBLOCK_REGIONS,
> > +     .reserved.max           = INIT_MEMBLOCK_RESERVED_REGIONS,
> >       .reserved.name          = "reserved",
> >
> >  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
> >
>
> Otherwise:
>
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>
>         M.
> --
> Jazz is not dead. It just smells funny...
