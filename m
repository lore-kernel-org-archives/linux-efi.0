From: Steve Capper <steve.capper@arm.com>
Subject: Re: [PATCH v16 6/6] arm64, mm, numa: Add NUMA balancing support for
 arm64.
Date: Wed, 13 Apr 2016 16:59:23 +0100
Message-ID: <20160413155922.GA2144@e103986-lin>
References: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
 <1460155828-8690-7-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460155828-8690-7-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, devicetree@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Apr 08, 2016 at 03:50:28PM -0700, David Daney wrote:
> From: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
> 
> Enable NUMA balancing for arm64 platforms.
> Add pte, pmd protnone helpers for use by automatic NUMA balancing.
> 
> Reviewed-by: Robert Richter <rrichter@cavium.com>
> Signed-off-by: Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/arm64/Kconfig               |  1 +
>  arch/arm64/include/asm/pgtable.h | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 99f9b55..a578080 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -11,6 +11,7 @@ config ARM64
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select ARCH_SUPPORTS_ATOMIC_RMW
> +	select ARCH_SUPPORTS_NUMA_BALANCING
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
>  	select ARCH_WANT_FRAME_POINTERS
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 989fef1..89b8f20 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -272,6 +272,21 @@ static inline pgprot_t mk_sect_prot(pgprot_t prot)
>  	return __pgprot(pgprot_val(prot) & ~PTE_TABLE_BIT);
>  }
>  
> +#ifdef CONFIG_NUMA_BALANCING
> +/*
> + * See the comment in include/asm-generic/pgtable.h
> + */
> +static inline int pte_protnone(pte_t pte)
> +{
> +	return (pte_val(pte) & (PTE_VALID | PTE_PROT_NONE)) == PTE_PROT_NONE;
> +}
> +
> +static inline int pmd_protnone(pmd_t pmd)
> +{
> +	return pte_protnone(pmd_pte(pmd));
> +}
> +#endif
> +

Okay, this looks good to me. If we have a PROT_NONE VMA then this is
caught before going into do_numa_page or do_huge_pmd_numa_page (and
there is a BUG_ON inside these functions to catch stragglers.

I've given this a quick test with a PROT_NONE THP and everything worked
as expected (i.e. NUMA didn't trip up).

Reviewed-by: Steve Capper <steve.capper@arm.com>

>  /*
>   * THP definitions.
>   */
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
