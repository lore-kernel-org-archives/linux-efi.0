From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 3/3] arm64: Add software workaround for Falkor erratum 1041
Date: Fri, 3 Nov 2017 15:11:07 +0000
Message-ID: <1f4a523c-608b-b46b-527a-bc1e02e7db5e@arm.com>
References: <1509679664-3749-1-git-send-email-shankerd@codeaurora.org>
 <1509679664-3749-4-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <1509679664-3749-4-git-send-email-shankerd@codeaurora.org>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shanker Donthineni <shankerd@codeaurora.org>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: linux-efi@vger.kernel.org

On 03/11/17 03:27, Shanker Donthineni wrote:
> The ARM architecture defines the memory locations that are permitted
> to be accessed as the result of a speculative instruction fetch from
> an exception level for which all stages of translation are disabled.
> Specifically, the core is permitted to speculatively fetch from the
> 4KB region containing the current program counter and next 4KB.
> 
> When translation is changed from enabled to disabled for the running
> exception level (SCTLR_ELn[M] changed from a value of 1 to 0), the
> Falkor core may errantly speculatively access memory locations outside
> of the 4KB region permitted by the architecture. The errant memory
> access may lead to one of the following unexpected behaviors.
> 
> 1) A System Error Interrupt (SEI) being raised by the Falkor core due
>    to the errant memory access attempting to access a region of memory
>    that is protected by a slave-side memory protection unit.
> 2) Unpredictable device behavior due to a speculative read from device
>    memory. This behavior may only occur if the instruction cache is
>    disabled prior to or coincident with translation being changed from
>    enabled to disabled.
> 
> To avoid the errant behavior, software must execute an ISB immediately
> prior to executing the MSR that will change SCTLR_ELn[M] from 1 to 0.
> 
> Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
> ---
>  Documentation/arm64/silicon-errata.txt |  1 +
>  arch/arm64/Kconfig                     | 10 ++++++++++
>  arch/arm64/include/asm/assembler.h     | 17 +++++++++++++++++
>  arch/arm64/include/asm/cpucaps.h       |  3 ++-
>  arch/arm64/kernel/cpu_errata.c         | 16 ++++++++++++++++
>  arch/arm64/kernel/efi-entry.S          |  4 ++--
>  arch/arm64/kernel/head.S               |  4 ++--
>  7 files changed, 50 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/arm64/silicon-errata.txt b/Documentation/arm64/silicon-errata.txt
> index 66e8ce1..704770c0 100644
> --- a/Documentation/arm64/silicon-errata.txt
> +++ b/Documentation/arm64/silicon-errata.txt
> @@ -74,3 +74,4 @@ stable kernels.
>  | Qualcomm Tech. | Falkor v1       | E1003           | QCOM_FALKOR_ERRATUM_1003    |
>  | Qualcomm Tech. | Falkor v1       | E1009           | QCOM_FALKOR_ERRATUM_1009    |
>  | Qualcomm Tech. | QDF2400 ITS     | E0065           | QCOM_QDF2400_ERRATUM_0065   |
> +| Qualcomm Tech. | Falkor v{1,2}   | E1041           | QCOM_FALKOR_ERRATUM_1041    |
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 0df64a6..7e933fb 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -539,6 +539,16 @@ config QCOM_QDF2400_ERRATUM_0065
>  
>  	  If unsure, say Y.
>  
> +config QCOM_FALKOR_ERRATUM_1041
> +	bool "Falkor E1041: Speculative instruction fetches might cause errant memory access"
> +	default y
> +	help
> +	  Falkor CPU may speculatively fetch instructions from an improper
> +	  memory location when MMU translation is changed from SCTLR_ELn[M]=1
> +	  to SCTLR_ELn[M]=0. Prefix an ISB instruction to fix the problem.
> +
> +	  If unsure, say Y.
> +
>  endmenu
>  
>  
> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
> index b6dfb4f..4c91efb 100644
> --- a/arch/arm64/include/asm/assembler.h
> +++ b/arch/arm64/include/asm/assembler.h
> @@ -30,6 +30,7 @@
>  #include <asm/pgtable-hwdef.h>
>  #include <asm/ptrace.h>
>  #include <asm/thread_info.h>
> +#include <asm/alternative.h>
>  
>  /*
>   * Enable and disable interrupts.
> @@ -514,6 +515,22 @@
>   *   reg: the value to be written.
>   */
>  	.macro	write_sctlr, eln, reg
> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1041
> +	tbnz    \reg, #0, 8000f          // enable MMU?

Do we really need the branch here? It's not like enabling the MMU is
something we do on the syscall fastpath, and I can't imagine an extra
ISB hurts much (and is probably comparable to a mispredicted branch
anyway). In fact, is there any noticeable hit on other
microarchitectures if we save the alternative bother and just do it
unconditionally always?

Robin.

> +	isb
> +8000:
> +alternative_else_nop_endif
> +#endif
> +	msr	sctlr_\eln, \reg
> +	.endm
> +
> +	.macro	early_write_sctlr, eln, reg
> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
> +	tbnz    \reg, #0, 8000f          // enable MMU?
> +	isb
> +8000:
> +#endif
>  	msr	sctlr_\eln, \reg
>  	.endm
>  
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 8da6216..7f7a59d 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -40,7 +40,8 @@
>  #define ARM64_WORKAROUND_858921			19
>  #define ARM64_WORKAROUND_CAVIUM_30115		20
>  #define ARM64_HAS_DCPOP				21
> +#define ARM64_WORKAROUND_QCOM_FALKOR_E1041	22
>  
> -#define ARM64_NCAPS				22
> +#define ARM64_NCAPS				23
>  
>  #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
> index 0e27f86..27f9a45 100644
> --- a/arch/arm64/kernel/cpu_errata.c
> +++ b/arch/arm64/kernel/cpu_errata.c
> @@ -179,6 +179,22 @@ static int cpu_enable_trap_ctr_access(void *__unused)
>  			   MIDR_CPU_VAR_REV(0, 0)),
>  	},
>  #endif
> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
> +	{
> +		.desc = "Qualcomm Technologies Falkor erratum 1041",
> +		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1041,
> +		MIDR_RANGE(MIDR_QCOM_FALKOR_V1,
> +			MIDR_CPU_VAR_REV(0, 0),
> +			MIDR_CPU_VAR_REV(0, 0)),
> +	},
> +	{
> +		.desc = "Qualcomm Technologies Falkor erratum 1041",
> +		.capability = ARM64_WORKAROUND_QCOM_FALKOR_E1041,
> +		MIDR_RANGE(MIDR_QCOM_FALKOR,
> +			MIDR_CPU_VAR_REV(0, 1),
> +			MIDR_CPU_VAR_REV(0, 2)),
> +	},
> +#endif
>  #ifdef CONFIG_ARM64_ERRATUM_858921
>  	{
>  	/* Cortex-A73 all versions */
> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> index acae627..c31be1b 100644
> --- a/arch/arm64/kernel/efi-entry.S
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -96,14 +96,14 @@ ENTRY(entry)
>  	read_sctlr el2, x0
>  	bic	x0, x0, #1 << 0	// clear SCTLR.M
>  	bic	x0, x0, #1 << 2	// clear SCTLR.C
> -	write_sctlr el2, x0
> +	early_write_sctlr el2, x0
>  	isb
>  	b	2f
>  1:
>  	read_sctlr el1, x0
>  	bic	x0, x0, #1 << 0	// clear SCTLR.M
>  	bic	x0, x0, #1 << 2	// clear SCTLR.C
> -	write_sctlr el1, x0
> +	early_write_sctlr el1, x0
>  	isb
>  2:
>  	/* Jump to kernel entry point */
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index b8d5b73..9512ce7 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -511,7 +511,7 @@ install_el2_stub:
>  	mov	x0, #0x0800			// Set/clear RES{1,0} bits
>  CPU_BE(	movk	x0, #0x33d0, lsl #16	)	// Set EE and E0E on BE systems
>  CPU_LE(	movk	x0, #0x30d0, lsl #16	)	// Clear EE and E0E on LE systems
> -	write_sctlr el1, x0
> +	early_write_sctlr el1, x0
>  
>  	/* Coprocessor traps. */
>  	mov	x0, #0x33ff
> @@ -732,7 +732,7 @@ __primary_switch:
>  	 * to take into account by discarding the current kernel mapping and
>  	 * creating a new one.
>  	 */
> -	write_sctlr el1, x20			// disable the MMU
> +	early_write_sctlr el1, x20		// disable the MMU
>  	isb
>  	bl	__create_page_tables		// recreate kernel mapping
>  
> 
