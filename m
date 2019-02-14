From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] arm64: account for GICv3 LPI tables in static
 memblock reserve table
Date: Thu, 14 Feb 2019 14:40:17 +0000
Message-ID: <20190214144017.GG31597@fuggles.cambridge.arm.com>
References: <20190213132738.10294-1-ard.biesheuvel@linaro.org>
 <20190213132738.10294-2-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20190213132738.10294-2-ard.biesheuvel@linaro.org>
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
Cc: linux-efi@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, James Morse <james.morse@arm.com>, Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 13, 2019 at 02:27:37PM +0100, Ard Biesheuvel wrote:
> In the irqchip and EFI code, we have what basically amounts to a quirk
> to work around a peculiarity in the GICv3 architecture, which permits
> the system memory address of LPI tables to be programmable only once
> after a CPU reset. This means kexec kernels must use the same memory
> as the first kernel, and thus ensure that this memory has not been
> given out for other purposes by the time the ITS init code runs, which
> is not very early for secondary CPUs.
> 
> On systems with many CPUs, these reservations could overflow the
> memblock reservation table, and this was addressed in commit
> eff896288872 ("efi/arm: Defer persistent reservations until after
> paging_init()"). However, this turns out to have made things worse,
> since the allocation of page tables and heap space for the resized
> memblock reservation table itself may overwrite the regions we are
> attempting to reserve, which may cause all kinds of corruption,
> also considering that the ITS will still be poking bits into that
> memory in response to incoming MSIs.
> 
> So instead, let's grow the static memblock reservation table on such
> systems so it can accommodate these reservations at an earlier time.
> This will permit us to revert the above commit in a subsequent patch.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm64/include/asm/memory.h | 11 +++++++++++
>  include/linux/memblock.h        |  3 ---
>  mm/memblock.c                   | 10 ++++++++--
>  3 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
> index e1ec947e7c0c..7e2b13cdd970 100644
> --- a/arch/arm64/include/asm/memory.h
> +++ b/arch/arm64/include/asm/memory.h
> @@ -332,6 +332,17 @@ static inline void *phys_to_virt(phys_addr_t x)
>  #define virt_addr_valid(kaddr)		\
>  	(_virt_addr_is_linear(kaddr) && _virt_addr_valid(kaddr))
>  
> +/*
> + * Given that the GIC architecture permits ITS implementations that can only be
> + * configured with a LPI table address once, GICv3 systems with many CPUs may
> + * end up reserving a lot of different regions after a kexec for their LPI
> + * tables, as we are forced to reuse the same memory after kexec (and thus
> + * reserve it persistently with EFI beforehand)
> + */
> +#if defined(CONFIG_EFI) && defined(CONFIG_ARM_GIC_V3_ITS)
> +#define INIT_MEMBLOCK_RESERVED_REGIONS	(INIT_MEMBLOCK_REGIONS + 2 * NR_CPUS)
> +#endif

Assuming this "ought to be enough for anybody", then:

Acked-by: Will Deacon <will.deacon@arm.com>

Will
