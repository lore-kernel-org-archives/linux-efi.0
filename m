Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD273148D2;
	Mon,  6 Jul 2026 13:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783342827; cv=none; b=QZfijoPrY86WUqQALYb9gpPMQK2RO6IXQ5eNbqf5ku/QyuBVPxpxKVB92utSNQ6CH4mOsqorDNIKDxT9nou+IcV69tUSZg75mdNnE+ULEKKwkCqJrzVCW0QT+EfmUGswAwbPmY7wsEdcXA2wOCCS+N6fgUddIwt1AG+BBSsV5Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783342827; c=relaxed/simple;
	bh=e18CmROrsIkNEtchCUIDgympTFKRiJMUwa8/RGrBLpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RZVsryAa62HV/dcS2q0gBEnZxN3PjJmMr8qexoKrRv0PAQf79gQm6x5oiO+Eout+AqVJ/uOPnwtRqjpxXRm8PBx596H/wClU05BIP+8cNA+KbWBx1dlnyPQbTCjmUDTA+hLtsjkAIgON3BtVKyIUhOOLkDP32Jt5dfH9GZUtTG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=e3aGCBv6; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="e3aGCBv6"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IsnRrRg6VFsdYj6G9kidQSHKUkgdjuelgd7GICGhZWw=;
	b=e3aGCBv6jA2ngFTER3ivoJjkix4C+vP5GWnjGc21S7vXQ7+Tq2AyW/l6IveUsRHOH6WqxsG++
	zGvtClDDLHNJ/Lhzu6azm8kilXtuym4OLuB3vvNayfTf5HCpZrsXDbq/mTwt9dgc6DXOoexnMyS
	fIXScAPOXVBiQKSd2kAhFxg=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gv43c4tYGz1cyPT;
	Mon,  6 Jul 2026 20:51:08 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 233B54055B;
	Mon,  6 Jul 2026 21:00:20 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 6 Jul 2026 21:00:16 +0800
Message-ID: <595ac191-06b9-4d83-a883-3447affc18ea@huawei.com>
Date: Mon, 6 Jul 2026 21:00:14 +0800
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/17] arm64: Rework exception masking into abstract
 logical mask
To: Leonardo Bras <leo.bras@arm.com>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <maz@kernel.org>, <ardb@kernel.org>,
	<ilias.apalodimas@linaro.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<oleg@redhat.com>, <mark.rutland@arm.com>, <lpieralisi@kernel.org>,
	<tglx@kernel.org>, <ada.coupriediaz@arm.com>, <anshuman.khandual@arm.com>,
	<ebiggers@kernel.org>, <broonie@kernel.org>, <mrigendra.chaubey@gmail.com>,
	<baohua@kernel.org>, <lucaswei@google.com>, <james.morse@arm.com>,
	<zengheng4@huawei.com>, <thuth@redhat.com>, <yang@os.amperecomputing.com>,
	<Sascha.Bischoff@arm.com>, <james.clark@linaro.org>, <peterz@infradead.org>,
	<leitao@debian.org>, <ben.horgan@arm.com>, <punit.agrawal@oss.qualcomm.com>,
	<gshan@redhat.com>, <osama.abdelkader@gmail.com>, <fengchengwen@huawei.com>,
	<ryan.roberts@arm.com>, <yangyicong@hisilicon.com>, <kevin.brodsky@arm.com>,
	<kees@kernel.org>, <jeson.gao@unisoc.com>, <zhaoyang.huang@unisoc.com>,
	<ryotkkr98@gmail.com>, <wsw9603@163.com>, <pasha.tatashin@soleen.com>,
	<jeremy.linton@arm.com>, <schuster.simon@siemens-energy.com>,
	<osandov@fb.com>, <arnd@arndb.de>, <zhangpengjie2@huawei.com>,
	<smostafa@google.com>, <vladimir.murzin@arm.com>, <tabba@google.com>,
	<vdonnefort@google.com>, <kaleshsingh@google.com>, <jic23@kernel.org>,
	<timothy.hayes@arm.com>, <alexandru.elisei@arm.com>, <zenghui.yu@linux.dev>,
	<david@kernel.org>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<memxor@gmail.com>, <qperret@google.com>, <chaitanyas.prakash@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
 <20260703100135.2512312-3-ruanjinjie@huawei.com> <ake7YFGAA_jMWhzy@LeoBrasDK>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <ake7YFGAA_jMWhzy@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500011.china.huawei.com (7.185.36.131)



On 7/3/2026 9:38 PM, Leonardo Bras wrote:
> On Fri, Jul 03, 2026 at 06:01:20PM +0800, Jinjie Ruan wrote:
>> The current pseudo-NMI implementation in arm64 bodges the GICv3 PMR
>> state into the DAIF management code. This approach forces local_daif_save()
>> and local_daif_restore() to pretend that PMR is a part of DAIF. This has
>> proven to be convoluted, difficult to maintain, and prone to architectural
>> corner cases where it cannot do the right thing (e.g., faking up DAIF
>> elements during irqflags/lockdep tracking).
>>
>> As we prepare for the hardware-based NMI (FEAT_NMI, which use ALLINT
>> to mask NMI) support, continuing down this path will significantly
>> increase technical debt. We must clean up the exception masking
>> abstraction ahead of ALLINT integration.
>>
>> Introduce a new abstract `struct exception_mask` that explicitly treats
>> DAIF, PMR, and ALLINT as separate, independent elements of the logical
>> exception state. This allows the kernel to track and manipulate the exact
>> hardware masking state cleanly without faking up DAIF flags.
>>
>> Introduce the following new APIs to replace the legacy DAIF-centric
>> helpers:
>>
>>  - arm64_make_{procctx,errctx,noirq}_mask() to generate logical masks.
>>
>>  - local_exception_save_and_mask() / local_exception_restore() to replace
>>    the old local_daif_save() / local_daif_restore() pattern.
>>
>>  - local_exception_inherit() to replace local_daif_inherit().
>>
>> Mechanically convert all existing callers across the arm64 architecture
>> to use the new logical exception mask helpers. The conversion spans:
>>
>> - Core exception entry/exit handling and traps.
>>
>> - KVM nVHE/VHE hypervisor switch and GICv3 save/restore code
>>
>> - CPU idle, suspend, hibernate, and PSCI firmware invocations.
>>
>> - Subsystems including SMP, ACPI, kprobes, and debug monitors
>>
>> Link: https://lore.kernel.org/linux-arm-kernel/Y5c9SLeJacLYHmP7@FVFF77S0Q05N/
>> Suggested-by: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
>> ---
>>  arch/arm64/include/asm/cpuidle.h         |  29 ++---
>>  arch/arm64/include/asm/daifflags.h       | 138 ----------------------
>>  arch/arm64/include/asm/entry-common.h    |   2 +-
>>  arch/arm64/include/asm/exception_masks.h | 141 +++++++++++++++++++++++
>>  arch/arm64/include/asm/kvm_host.h        |   2 +-
>>  arch/arm64/include/asm/mmu_context.h     |   2 +-
>>  arch/arm64/kernel/acpi.c                 |  14 +--
>>  arch/arm64/kernel/debug-monitors.c       |   9 +-
>>  arch/arm64/kernel/entry-common.c         |  74 ++++++------
>>  arch/arm64/kernel/hibernate.c            |  10 +-
>>  arch/arm64/kernel/idle.c                 |   7 +-
>>  arch/arm64/kernel/irq.c                  |   4 +-
>>  arch/arm64/kernel/machine_kexec.c        |   4 +-
>>  arch/arm64/kernel/probes/kprobes.c       |   2 +-
>>  arch/arm64/kernel/setup.c                |   4 +-
>>  arch/arm64/kernel/signal.c               |   2 +-
>>  arch/arm64/kernel/smp.c                  |  22 ++--
>>  arch/arm64/kernel/suspend.c              |  15 ++-
>>  arch/arm64/kernel/traps.c                |   2 +-
>>  arch/arm64/kvm/hyp/vgic-v3-sr.c          |   6 +-
>>  arch/arm64/kvm/hyp/vhe/switch.c          |   6 +-
>>  arch/arm64/mm/fault.c                    |   2 +-
>>  arch/arm64/mm/mmu.c                      |   6 +-
>>  drivers/firmware/psci/psci.c             |   7 +-
>>  24 files changed, 254 insertions(+), 256 deletions(-)
>>  delete mode 100644 arch/arm64/include/asm/daifflags.h
>>  create mode 100644 arch/arm64/include/asm/exception_masks.h
>>
>> diff --git a/arch/arm64/include/asm/cpuidle.h b/arch/arm64/include/asm/cpuidle.h
>> index 64ddb533d3ec..4c19d5b79678 100644
>> --- a/arch/arm64/include/asm/cpuidle.h
>> +++ b/arch/arm64/include/asm/cpuidle.h
>> @@ -6,37 +6,30 @@
>>  
>>  #ifdef CONFIG_ARM64_PSEUDO_NMI
>>  #include <asm/arch_gicv3.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/ptrace.h>
>>  
>> -struct arm_cpuidle_irq_context {
>> -	unsigned long pmr;
>> -	unsigned long daif_bits;
>> -};
>> -
>> -#define arm_cpuidle_save_irq_context(__c)				\
>> +#define arm_cpuidle_save_irq_context(__m)				\
>>  	do {								\
>> -		struct arm_cpuidle_irq_context *c = __c;		\
>> +		struct exception_mask *m = __m;				\
>>  		if (system_uses_irq_prio_masking()) {			\
>> -			c->daif_bits = read_sysreg(daif);		\
>> -			write_sysreg(c->daif_bits | DAIF_PROCCTX_NOIRQ, \
>> +			local_exception_save_mask(m);			\
>> +			write_sysreg(m->daif | DAIF_PROCCTX_NOIRQ,	\
>>  				     daif);				\
>> -			c->pmr = gic_read_pmr();			\
>>  			gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET); \
>>  		}							\
>>  	} while (0)
>>  
>> -#define arm_cpuidle_restore_irq_context(__c)				\
>> +#define arm_cpuidle_restore_irq_context(__m)				\
>>  	do {								\
>> -		struct arm_cpuidle_irq_context *c = __c;		\
>> +		struct exception_mask *m = __m;				\
>>  		if (system_uses_irq_prio_masking()) {			\
>> -			gic_write_pmr(c->pmr);				\
>> -			write_sysreg(c->daif_bits, daif);		\
>> +			gic_write_pmr(m->pmr);				\
>> +			write_sysreg(m->daif, daif);			\
>>  		}							\
>>  	} while (0)
>>  #else
>> -struct arm_cpuidle_irq_context { };
>> -
>> -#define arm_cpuidle_save_irq_context(c)		(void)c
>> -#define arm_cpuidle_restore_irq_context(c)	(void)c
>> +#define arm_cpuidle_save_irq_context(m)		((void)m)
>> +#define arm_cpuidle_restore_irq_context(m)	((void)m)
>>  #endif
>>  #endif
>> diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
>> deleted file mode 100644
>> index 3a4b63a948ac..000000000000
>> --- a/arch/arm64/include/asm/daifflags.h
>> +++ /dev/null
>> @@ -1,138 +0,0 @@
>> -/* SPDX-License-Identifier: GPL-2.0-only */
>> -/*
>> - * Copyright (C) 2017 ARM Ltd.
>> - */
>> -#ifndef __ASM_DAIFFLAGS_H
>> -#define __ASM_DAIFFLAGS_H
>> -
>> -#include <linux/irqflags.h>
>> -
>> -#include <asm/arch_gicv3.h>
>> -#include <asm/barrier.h>
>> -#include <asm/cpufeature.h>
>> -#include <asm/ptrace.h>
>> -
>> -/* mask/save/unmask/restore all exceptions, including interrupts. */
>> -static __always_inline void local_daif_mask(void)
>> -{
>> -	WARN_ON(system_has_prio_mask_debugging() &&
>> -		(read_sysreg_s(SYS_ICC_PMR_EL1) == (GIC_PRIO_IRQOFF |
>> -						    GIC_PRIO_PSR_I_SET)));
>> -
>> -	asm volatile(
>> -		"msr	daifset, #0xf		// local_daif_mask\n"
>> -		:
>> -		:
>> -		: "memory");
>> -
>> -	/* Don't really care for a dsb here, we don't intend to enable IRQs */
>> -	if (system_uses_irq_prio_masking())
>> -		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
>> -
>> -	trace_hardirqs_off();
>> -}
>> -
>> -static __always_inline unsigned long local_daif_save_flags(void)
>> -{
>> -	unsigned long flags;
>> -
>> -	flags = read_sysreg(daif);
>> -
>> -	if (system_uses_irq_prio_masking()) {
>> -		/* If IRQs are masked with PMR, reflect it in the flags */
>> -		if (read_sysreg_s(SYS_ICC_PMR_EL1) != GIC_PRIO_IRQON)
>> -			flags |= DAIF_PROCCTX_NOIRQ;
>> -	}
>> -
>> -	return flags;
>> -}
>> -
>> -static __always_inline unsigned long local_daif_save(void)
>> -{
>> -	unsigned long flags;
>> -
>> -	flags = local_daif_save_flags();
>> -
>> -	local_daif_mask();
>> -
>> -	return flags;
>> -}
>> -
>> -static __always_inline void local_daif_restore(unsigned long flags)
>> -{
>> -	bool irq_disabled = flags & PSR_I_BIT;
>> -
>> -	WARN_ON(system_has_prio_mask_debugging() &&
>> -		(read_sysreg(daif) & DAIF_PROCCTX_NOIRQ) != DAIF_PROCCTX_NOIRQ);
>> -
>> -	if (!irq_disabled) {
>> -		trace_hardirqs_on();
>> -
>> -		if (system_uses_irq_prio_masking()) {
>> -			gic_write_pmr(GIC_PRIO_IRQON);
>> -			pmr_sync();
>> -		}
>> -	} else if (system_uses_irq_prio_masking()) {
>> -		u64 pmr;
>> -
>> -		if (!(flags & PSR_A_BIT)) {
>> -			/*
>> -			 * If interrupts are disabled but we can take
>> -			 * asynchronous errors, we can take NMIs
>> -			 */
>> -			flags &= ~DAIF_PROCCTX_NOIRQ;
>> -			pmr = GIC_PRIO_IRQOFF;
>> -		} else {
>> -			pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
>> -		}
>> -
>> -		/*
>> -		 * There has been concern that the write to daif
>> -		 * might be reordered before this write to PMR.
>> -		 * From the ARM ARM DDI 0487D.a, section D1.7.1
>> -		 * "Accessing PSTATE fields":
>> -		 *   Writes to the PSTATE fields have side-effects on
>> -		 *   various aspects of the PE operation. All of these
>> -		 *   side-effects are guaranteed:
>> -		 *     - Not to be visible to earlier instructions in
>> -		 *       the execution stream.
>> -		 *     - To be visible to later instructions in the
>> -		 *       execution stream
>> -		 *
>> -		 * Also, writes to PMR are self-synchronizing, so no
>> -		 * interrupts with a lower priority than PMR is signaled
>> -		 * to the PE after the write.
>> -		 *
>> -		 * So we don't need additional synchronization here.
>> -		 */
>> -		gic_write_pmr(pmr);
>> -	}
>> -
>> -	write_sysreg(flags, daif);
>> -
>> -	if (irq_disabled)
>> -		trace_hardirqs_off();
>> -}
>> -
>> -/*
>> - * Called by synchronous exception handlers to restore the DAIF bits that were
>> - * modified by taking an exception.
>> - */
>> -static __always_inline void local_daif_inherit(struct pt_regs *regs)
>> -{
>> -	unsigned long flags = regs->pstate & DAIF_MASK;
>> -
>> -	if (!regs_irqs_disabled(regs))
>> -		trace_hardirqs_on();
>> -
>> -	if (system_uses_irq_prio_masking())
>> -		gic_write_pmr(regs->pmr);
>> -
>> -	/*
>> -	 * We can't use local_daif_restore(regs->pstate) here as
>> -	 * system_has_prio_mask_debugging() won't restore the I bit if it can
>> -	 * use the pmr instead.
>> -	 */
>> -	write_sysreg(flags, daif);
>> -}
>> -#endif
>> diff --git a/arch/arm64/include/asm/entry-common.h b/arch/arm64/include/asm/entry-common.h
>> index cab8cd78f693..3d8b38ce7afb 100644
>> --- a/arch/arm64/include/asm/entry-common.h
>> +++ b/arch/arm64/include/asm/entry-common.h
>> @@ -6,7 +6,7 @@
>>  #include <linux/thread_info.h>
>>  
>>  #include <asm/cpufeature.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/fpsimd.h>
>>  #include <asm/mte.h>
>>  #include <asm/stacktrace.h>
>> diff --git a/arch/arm64/include/asm/exception_masks.h b/arch/arm64/include/asm/exception_masks.h
>> new file mode 100644
>> index 000000000000..0a21fb97c3ca
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/exception_masks.h
>> @@ -0,0 +1,141 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2017 ARM Ltd.
>> + */
>> +#ifndef __ASM_EXCEPTION_MASKS_H
>> +#define __ASM_EXCEPTION_MASKS_H
>> +
>> +#include <linux/irqflags.h>
>> +
>> +#include <asm/arch_gicv3.h>
>> +#include <asm/barrier.h>
>> +#include <asm/cpufeature.h>
>> +#include <asm/ptrace.h>
>> +
>> +/*
>> + * Logical exception mask: tracks the three independent exception
>> + * masking controls on arm64:
>> + *  - DAIF (PSTATE.{D,A,I,F} bits)
>> + *  - PMR  (ICC_PMR_EL1)
>> + *  - ALLINT (PSTATE.ALLINT)
>> + */
>> +struct exception_mask {
>> +	unsigned long daif;
>> +	unsigned long pmr;
>> +	unsigned long allint;		// for future FEAT_NMI use
>> +};
>> +
>> +static inline struct exception_mask arm64_make_procctx_mask(void)
> 
> By the code you removed, I understand that those new functions should not 
> be marked as 'inline' but as '__always_inline'.
> 
> Is there any reason why you decided to use 'inline' instead?

Hi Leonardo,

Thanks for catching this! It was an oversight on my part.

These functions should definitely be marked as '__always_inline' to
guarantee they are inlined in the critical section, especially within
the noinstr paths.

I will fix this and use '__always_inline'.

Best regards,
Jinjie


> 
> Thanks!
> Leo
> 
> 
>> +{
>> +	struct exception_mask mask;
>> +
>> +	mask.daif = DAIF_PROCCTX;
>> +	if (system_uses_irq_prio_masking())
>> +		mask.pmr = GIC_PRIO_IRQON;
>> +
>> +	mask.allint = 0;
>> +
>> +	return mask;
>> +}
>> +
>> +static inline struct exception_mask arm64_make_errctx_mask(void)
>> +{
>> +	struct exception_mask mask;
>> +
>> +	mask.daif = DAIF_ERRCTX;
>> +	if (system_uses_irq_prio_masking())
>> +		mask.pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
>> +
>> +	mask.allint = 0;
>> +
>> +	return mask;
>> +}
>> +
>> +static inline struct exception_mask arm64_make_noirq_mask(void)
>> +{
>> +	struct exception_mask mask;
>> +
>> +	if (system_uses_irq_prio_masking()) {
>> +		mask.daif = 0;
>> +		mask.pmr = GIC_PRIO_IRQOFF;
>> +	} else
>> +		mask.daif = DAIF_PROCCTX_NOIRQ;
>> +
>> +	mask.allint = 0;
>> +
>> +	return mask;
>> +}
>> +
>> +/* Mask all exceptions immediately */
>> +static inline void local_exception_mask(void)
>> +{
>> +	WARN_ON(system_has_prio_mask_debugging() &&
>> +		(read_sysreg_s(SYS_ICC_PMR_EL1) == (GIC_PRIO_IRQOFF |
>> +						    GIC_PRIO_PSR_I_SET)));
>> +
>> +	asm volatile("msr daifset, #0xf" ::: "memory");
>> +
>> +	if (system_uses_irq_prio_masking())
>> +		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
>> +
>> +	trace_hardirqs_off();
>> +}
>> +
>> +static inline void local_exception_save_mask(struct exception_mask *mask)
>> +{
>> +	mask->daif = read_sysreg(daif);
>> +	if (system_uses_irq_prio_masking())
>> +		mask->pmr = gic_read_pmr();
>> +
>> +	mask->allint = 0;
>> +}
>> +
>> +static inline struct exception_mask local_exception_save_and_mask(void)
>> +{
>> +	struct exception_mask mask;
>> +
>> +	local_exception_save_mask(&mask);
>> +	local_exception_mask();
>> +
>> +	return mask;
>> +}
>> +
>> +static inline void local_exception_restore(const struct exception_mask mask)
>> +{
>> +	bool irq_disabled = mask.daif & PSR_I_BIT;
>> +
>> +	if (system_uses_irq_prio_masking())
>> +		irq_disabled |= (mask.pmr == GIC_PRIO_IRQOFF);
>> +
>> +	WARN_ON(system_has_prio_mask_debugging() &&
>> +		(read_sysreg(daif) & DAIF_PROCCTX_NOIRQ) != DAIF_PROCCTX_NOIRQ);
>> +
>> +	if (!irq_disabled)
>> +		trace_hardirqs_on();
>> +
>> +	if (system_uses_irq_prio_masking()) {
>> +		gic_write_pmr(mask.pmr);
>> +		pmr_sync();
>> +	}
>> +
>> +	write_sysreg(mask.daif, daif);
>> +
>> +	if (irq_disabled)
>> +		trace_hardirqs_off();
>> +}
>> +
>> +/*
>> + * Called by synchronous exception handlers to restore the DAIF bits that were
>> + * modified by taking an exception.
>> + */
>> +static inline void local_exception_inherit(struct pt_regs *regs)
>> +{
>> +	if (!regs_irqs_disabled(regs))
>> +		trace_hardirqs_on();
>> +
>> +	if (system_uses_irq_prio_masking())
>> +		gic_write_pmr(regs->pmr);
>> +
>> +	write_sysreg(regs->pstate & DAIF_MASK, daif);
>> +}
>> +#endif /* __ASM_EXCEPTION_MASKS_H */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index bae2c4f92ef5..8a443a379689 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -23,7 +23,7 @@
>>  #include <asm/barrier.h>
>>  #include <asm/cpufeature.h>
>>  #include <asm/cputype.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/fpsimd.h>
>>  #include <asm/kvm.h>
>>  #include <asm/kvm_asm.h>
>> diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
>> index 803b68758152..6103925f85b7 100644
>> --- a/arch/arm64/include/asm/mmu_context.h
>> +++ b/arch/arm64/include/asm/mmu_context.h
>> @@ -19,7 +19,7 @@
>>  
>>  #include <asm/cacheflush.h>
>>  #include <asm/cpufeature.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/gcs.h>
>>  #include <asm/proc-fns.h>
>>  #include <asm/cputype.h>
>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>> index 5891f92c2035..4d413419309d 100644
>> --- a/arch/arm64/kernel/acpi.c
>> +++ b/arch/arm64/kernel/acpi.c
>> @@ -33,7 +33,7 @@
>>  #include <acpi/processor.h>
>>  #include <asm/cputype.h>
>>  #include <asm/cpu_ops.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/smp_plat.h>
>>  
>>  int acpi_noirq = 1;		/* skip ACPI IRQ initialization */
>> @@ -388,14 +388,14 @@ void __iomem *acpi_os_ioremap(acpi_physical_address phys, acpi_size size)
>>   */
>>  int apei_claim_sea(struct pt_regs *regs)
>>  {
>> -	int err = -ENOENT;
>> +	struct exception_mask current_mask;
>>  	bool return_to_irqs_enabled;
>> -	unsigned long current_flags;
>> +	int err = -ENOENT;
>>  
>>  	if (!IS_ENABLED(CONFIG_ACPI_APEI_GHES))
>>  		return err;
>>  
>> -	current_flags = local_daif_save_flags();
>> +	local_exception_save_mask(&current_mask);
>>  
>>  	/* current_flags isn't useful here as daif doesn't tell us about pNMI */
>>  	return_to_irqs_enabled = !irqs_disabled_flags(arch_local_save_flags());
>> @@ -407,7 +407,7 @@ int apei_claim_sea(struct pt_regs *regs)
>>  	 * SEA can interrupt SError, mask it and describe this as an NMI so
>>  	 * that APEI defers the handling.
>>  	 */
>> -	local_daif_restore(DAIF_ERRCTX);
>> +	local_exception_restore(arm64_make_errctx_mask());
>>  	nmi_enter();
>>  	err = ghes_notify_sea();
>>  	nmi_exit();
>> @@ -418,7 +418,7 @@ int apei_claim_sea(struct pt_regs *regs)
>>  	 */
>>  	if (!err) {
>>  		if (return_to_irqs_enabled) {
>> -			local_daif_restore(DAIF_PROCCTX_NOIRQ);
>> +			local_exception_restore(arm64_make_noirq_mask());
>>  			__irq_enter();
>>  			irq_work_run();
>>  			__irq_exit();
>> @@ -428,7 +428,7 @@ int apei_claim_sea(struct pt_regs *regs)
>>  		}
>>  	}
>>  
>> -	local_daif_restore(current_flags);
>> +	local_exception_restore(current_mask);
>>  
>>  	return err;
>>  }
>> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
>> index 29307642f4c9..5b53034428e4 100644
>> --- a/arch/arm64/kernel/debug-monitors.c
>> +++ b/arch/arm64/kernel/debug-monitors.c
>> @@ -19,7 +19,7 @@
>>  
>>  #include <asm/cpufeature.h>
>>  #include <asm/cputype.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/exception.h>
>>  #include <asm/kgdb.h>
>> @@ -40,10 +40,11 @@ u8 debug_monitors_arch(void)
>>   */
>>  static void mdscr_write(u64 mdscr)
>>  {
>> -	unsigned long flags;
>> -	flags = local_daif_save();
>> +	struct exception_mask mask;
>> +
>> +	mask = local_exception_save_and_mask();
>>  	write_sysreg(mdscr, mdscr_el1);
>> -	local_daif_restore(flags);
>> +	local_exception_restore(mask);
>>  }
>>  NOKPROBE_SYMBOL(mdscr_write);
>>  
>> diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
>> index ceb4eb11232a..195af3f8001e 100644
>> --- a/arch/arm64/kernel/entry-common.c
>> +++ b/arch/arm64/kernel/entry-common.c
>> @@ -18,7 +18,7 @@
>>  #include <linux/thread_info.h>
>>  
>>  #include <asm/cpufeature.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/esr.h>
>>  #include <asm/exception.h>
>>  #include <asm/fpsimd.h>
>> @@ -57,7 +57,7 @@ static void noinstr arm64_exit_to_kernel_mode(struct pt_regs *regs,
>>  {
>>  	local_irq_disable();
>>  	irqentry_exit_to_kernel_mode_preempt(regs, state);
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  	mte_check_tfsr_exit();
>>  	irqentry_exit_to_kernel_mode_after_preempt(regs, state);
>>  }
>> @@ -86,7 +86,7 @@ static __always_inline void arm64_syscall_exit_to_user_mode(struct pt_regs *regs
>>  {
>>  	local_irq_disable();
>>  	syscall_exit_to_user_mode_prepare(regs);
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  	sme_exit_to_user_mode();
>>  	mte_check_tfsr_exit();
>>  	exit_to_user_mode();
>> @@ -101,7 +101,7 @@ static __always_inline void arm64_exit_to_user_mode(struct pt_regs *regs)
>>  {
>>  	local_irq_disable();
>>  	irqentry_exit_to_user_mode_prepare(regs);
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  	sme_exit_to_user_mode();
>>  	mte_check_tfsr_exit();
>>  	exit_to_user_mode();
>> @@ -318,7 +318,7 @@ static void noinstr el1_abort(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_mem_abort(far, esr, regs);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -329,7 +329,7 @@ static void noinstr el1_pc(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_sp_pc_abort(far, esr, regs);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -339,7 +339,7 @@ static void noinstr el1_undef(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_el1_undef(regs, esr);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -349,7 +349,7 @@ static void noinstr el1_bti(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_el1_bti(regs, esr);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -359,7 +359,7 @@ static void noinstr el1_gcs(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_el1_gcs(regs, esr);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -369,7 +369,7 @@ static void noinstr el1_mops(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_el1_mops(regs, esr);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -434,7 +434,7 @@ static void noinstr el1_fpac(struct pt_regs *regs, unsigned long esr)
>>  	irqentry_state_t state;
>>  
>>  	state = arm64_enter_from_kernel_mode(regs);
>> -	local_daif_inherit(regs);
>> +	local_exception_inherit(regs);
>>  	do_el1_fpac(regs, esr);
>>  	arm64_exit_to_kernel_mode(regs, state);
>>  }
>> @@ -537,7 +537,7 @@ asmlinkage void noinstr el1h_64_error_handler(struct pt_regs *regs)
>>  	unsigned long esr = read_sysreg(esr_el1);
>>  	irqentry_state_t state;
>>  
>> -	local_daif_restore(DAIF_ERRCTX);
>> +	local_exception_restore(arm64_make_errctx_mask());
>>  	state = irqentry_nmi_enter(regs);
>>  	do_serror(regs, esr);
>>  	irqentry_nmi_exit(regs, state);
>> @@ -548,7 +548,7 @@ static void noinstr el0_da(struct pt_regs *regs, unsigned long esr)
>>  	unsigned long far = read_sysreg(far_el1);
>>  
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_mem_abort(far, esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -566,7 +566,7 @@ static void noinstr el0_ia(struct pt_regs *regs, unsigned long esr)
>>  		arm64_apply_bp_hardening();
>>  
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_mem_abort(far, esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -574,7 +574,7 @@ static void noinstr el0_ia(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_fpsimd_acc(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_fpsimd_acc(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -582,7 +582,7 @@ static void noinstr el0_fpsimd_acc(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_sve_acc(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_sve_acc(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -590,7 +590,7 @@ static void noinstr el0_sve_acc(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_sme_acc(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_sme_acc(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -598,7 +598,7 @@ static void noinstr el0_sme_acc(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_fpsimd_exc(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_fpsimd_exc(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -606,7 +606,7 @@ static void noinstr el0_fpsimd_exc(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_sys(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_sys(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -619,7 +619,7 @@ static void noinstr el0_pc(struct pt_regs *regs, unsigned long esr)
>>  		arm64_apply_bp_hardening();
>>  
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_sp_pc_abort(far, esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -627,7 +627,7 @@ static void noinstr el0_pc(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_sp(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_sp_pc_abort(regs->sp, esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -635,7 +635,7 @@ static void noinstr el0_sp(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_undef(regs, esr);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -643,7 +643,7 @@ static void noinstr el0_undef(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_bti(struct pt_regs *regs)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_bti(regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -651,7 +651,7 @@ static void noinstr el0_bti(struct pt_regs *regs)
>>  static void noinstr el0_mops(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_mops(regs, esr);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -659,7 +659,7 @@ static void noinstr el0_mops(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_gcs(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_gcs(regs, esr);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -667,7 +667,7 @@ static void noinstr el0_gcs(struct pt_regs *regs, unsigned long esr)
>>  static void noinstr el0_inv(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	bad_el0_sync(regs, 0, esr);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -681,7 +681,7 @@ static void noinstr el0_breakpt(struct pt_regs *regs, unsigned long esr)
>>  	debug_exception_enter(regs);
>>  	do_breakpoint(esr, regs);
>>  	debug_exception_exit(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	arm64_exit_to_user_mode(regs);
>>  }
>>  
>> @@ -700,7 +700,7 @@ static void noinstr el0_softstp(struct pt_regs *regs, unsigned long esr)
>>  	 * the single-step is complete.
>>  	 */
>>  	step_done = try_step_suspended_breakpoints(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	if (!step_done)
>>  		do_el0_softstep(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>> @@ -715,14 +715,14 @@ static void noinstr el0_watchpt(struct pt_regs *regs, unsigned long esr)
>>  	debug_exception_enter(regs);
>>  	do_watchpoint(far, esr, regs);
>>  	debug_exception_exit(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	arm64_exit_to_user_mode(regs);
>>  }
>>  
>>  static void noinstr el0_brk64(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_brk64(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -732,7 +732,7 @@ static void noinstr el0_svc(struct pt_regs *regs)
>>  	arm64_syscall_enter_from_user_mode(regs);
>>  	cortex_a76_erratum_1463225_svc_handler();
>>  	fpsimd_syscall_enter();
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_svc(regs);
>>  	arm64_syscall_exit_to_user_mode(regs);
>>  	fpsimd_syscall_exit();
>> @@ -741,7 +741,7 @@ static void noinstr el0_svc(struct pt_regs *regs)
>>  static void noinstr el0_fpac(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_fpac(regs, esr);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -857,11 +857,11 @@ static void noinstr __el0_error_handler_common(struct pt_regs *regs)
>>  	irqentry_state_t state;
>>  
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_ERRCTX);
>> +	local_exception_restore(arm64_make_errctx_mask());
>>  	state = irqentry_nmi_enter(regs);
>>  	do_serror(regs, esr);
>>  	irqentry_nmi_exit(regs, state);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	arm64_exit_to_user_mode(regs);
>>  }
>>  
>> @@ -874,7 +874,7 @@ asmlinkage void noinstr el0t_64_error_handler(struct pt_regs *regs)
>>  static void noinstr el0_cp15(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_cp15(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> @@ -883,7 +883,7 @@ static void noinstr el0_svc_compat(struct pt_regs *regs)
>>  {
>>  	arm64_syscall_enter_from_user_mode(regs);
>>  	cortex_a76_erratum_1463225_svc_handler();
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_el0_svc_compat(regs);
>>  	arm64_syscall_exit_to_user_mode(regs);
>>  }
>> @@ -891,7 +891,7 @@ static void noinstr el0_svc_compat(struct pt_regs *regs)
>>  static void noinstr el0_bkpt32(struct pt_regs *regs, unsigned long esr)
>>  {
>>  	arm64_enter_from_user_mode(regs);
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  	do_bkpt32(esr, regs);
>>  	arm64_exit_to_user_mode(regs);
>>  }
>> diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
>> index 9717568518ba..f6996b22fa29 100644
>> --- a/arch/arm64/kernel/hibernate.c
>> +++ b/arch/arm64/kernel/hibernate.c
>> @@ -20,7 +20,7 @@
>>  #include <asm/barrier.h>
>>  #include <asm/cacheflush.h>
>>  #include <asm/cputype.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/irqflags.h>
>>  #include <asm/kexec.h>
>>  #include <asm/memory.h>
>> @@ -332,16 +332,16 @@ static void swsusp_mte_restore_tags(void)
>>  
>>  int swsusp_arch_suspend(void)
>>  {
>> -	int ret = 0;
>> -	unsigned long flags;
>>  	struct sleep_stack_data state;
>> +	struct exception_mask mask;
>> +	int ret = 0;
>>  
>>  	if (cpus_are_stuck_in_kernel()) {
>>  		pr_err("Can't hibernate: no mechanism to offline secondary CPUs.\n");
>>  		return -EBUSY;
>>  	}
>>  
>> -	flags = local_daif_save();
>> +	mask = local_exception_save_and_mask();
>>  
>>  	if (__cpu_suspend_enter(&state)) {
>>  		/* make the crash dump kernel image visible/saveable */
>> @@ -391,7 +391,7 @@ int swsusp_arch_suspend(void)
>>  		spectre_v4_enable_mitigation(NULL);
>>  	}
>>  
>> -	local_daif_restore(flags);
>> +	local_exception_restore(mask);
>>  
>>  	return ret;
>>  }
>> diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
>> index 05cfb347ec26..3997e297691e 100644
>> --- a/arch/arm64/kernel/idle.c
>> +++ b/arch/arm64/kernel/idle.c
>> @@ -6,6 +6,7 @@
>>  #include <linux/cpu.h>
>>  #include <linux/irqflags.h>
>>  
>> +#include <asm/exception_masks.h>
>>  #include <asm/barrier.h>
>>  #include <asm/cpuidle.h>
>>  #include <asm/cpufeature.h>
>> @@ -22,14 +23,14 @@
>>   */
>>  void __cpuidle cpu_do_idle(void)
>>  {
>> -	struct arm_cpuidle_irq_context context;
>> +	struct exception_mask mask;
>>  
>> -	arm_cpuidle_save_irq_context(&context);
>> +	arm_cpuidle_save_irq_context(&mask);
>>  
>>  	dsb(sy);
>>  	wfi();
>>  
>> -	arm_cpuidle_restore_irq_context(&context);
>> +	arm_cpuidle_restore_irq_context(&mask);
>>  }
>>  
>>  /*
>> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
>> index 9fafd826002b..9e7fb0d22586 100644
>> --- a/arch/arm64/kernel/irq.c
>> +++ b/arch/arm64/kernel/irq.c
>> @@ -21,7 +21,7 @@
>>  #include <linux/seq_file.h>
>>  #include <linux/smp.h>
>>  #include <linux/vmalloc.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/exception.h>
>>  #include <asm/numa.h>
>>  #include <asm/softirq_stack.h>
>> @@ -130,6 +130,6 @@ void __init init_IRQ(void)
>>  		 * the PMR/PSR pair to a consistent state.
>>  		 */
>>  		WARN_ON(read_sysreg(daif) & PSR_A_BIT);
>> -		local_daif_restore(DAIF_PROCCTX_NOIRQ);
>> +		local_exception_restore(arm64_make_noirq_mask());
>>  	}
>>  }
>> diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
>> index c5693a32e49b..a8676ee10ea2 100644
>> --- a/arch/arm64/kernel/machine_kexec.c
>> +++ b/arch/arm64/kernel/machine_kexec.c
>> @@ -17,7 +17,7 @@
>>  
>>  #include <asm/cacheflush.h>
>>  #include <asm/cpu_ops.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/memory.h>
>>  #include <asm/mmu.h>
>>  #include <asm/mmu_context.h>
>> @@ -173,7 +173,7 @@ void machine_kexec(struct kimage *kimage)
>>  
>>  	pr_info("Bye!\n");
>>  
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  
>>  	/*
>>  	 * Both restart and kernel_reloc will shutdown the MMU, disable data
>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
>> index 43a0361a8bf0..70d311e415ac 100644
>> --- a/arch/arm64/kernel/probes/kprobes.c
>> +++ b/arch/arm64/kernel/probes/kprobes.c
>> @@ -24,7 +24,7 @@
>>  #include <linux/vmalloc.h>
>>  
>>  #include <asm/cacheflush.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/insn.h>
>>  #include <asm/irq.h>
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 23c05dc7a8f2..10507e55e2ce 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -37,7 +37,7 @@
>>  #include <asm/fixmap.h>
>>  #include <asm/cpu.h>
>>  #include <asm/cputype.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/elf.h>
>>  #include <asm/cpufeature.h>
>>  #include <asm/cpu_ops.h>
>> @@ -311,7 +311,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>>  	 * IRQ and FIQ will be unmasked after the root irqchip has been
>>  	 * detected and initialized.
>>  	 */
>> -	local_daif_restore(DAIF_PROCCTX_NOIRQ);
>> +	local_exception_restore(arm64_make_noirq_mask());
>>  
>>  	/*
>>  	 * TTBR0 is only used for the identity mapping at this stage. Make it
>> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
>> index 38e6fa204c17..ea39b47ae0eb 100644
>> --- a/arch/arm64/kernel/signal.c
>> +++ b/arch/arm64/kernel/signal.c
>> @@ -22,7 +22,7 @@
>>  #include <linux/syscalls.h>
>>  #include <linux/pkeys.h>
>>  
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/elf.h>
>>  #include <asm/exception.h>
>> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
>> index d46022f72075..d153ff77d25c 100644
>> --- a/arch/arm64/kernel/smp.c
>> +++ b/arch/arm64/kernel/smp.c
>> @@ -42,7 +42,7 @@
>>  #include <asm/cpu.h>
>>  #include <asm/cputype.h>
>>  #include <asm/cpu_ops.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/kvm_mmu.h>
>>  #include <asm/mmu_context.h>
>>  #include <asm/numa.h>
>> @@ -263,7 +263,7 @@ asmlinkage notrace void secondary_start_kernel(void)
>>  	 * as the root irqchip has already been detected and initialized we can
>>  	 * unmask IRQ and FIQ at the same time.
>>  	 */
>> -	local_daif_restore(DAIF_PROCCTX);
>> +	local_exception_restore(arm64_make_procctx_mask());
>>  
>>  	/*
>>  	 * OK, it's off to the idle thread for us
>> @@ -370,7 +370,7 @@ void __noreturn cpu_die(void)
>>  
>>  	idle_task_exit();
>>  
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  
>>  	/* Tell cpuhp_bp_sync_dead() that this CPU is now safe to dispose of */
>>  	cpuhp_ap_report_dead();
>> @@ -870,7 +870,7 @@ static void __noreturn local_cpu_stop(unsigned int cpu)
>>  {
>>  	set_cpu_online(cpu, false);
>>  
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  	sdei_mask_local_cpu();
>>  	cpu_park_loop();
>>  }
>> @@ -889,14 +889,14 @@ static void __noreturn ipi_cpu_crash_stop(unsigned int cpu, struct pt_regs *regs
>>  {
>>  #ifdef CONFIG_KEXEC_CORE
>>  	/*
>> -	 * Use local_daif_mask() instead of local_irq_disable() to make sure
>> -	 * that pseudo-NMIs are disabled. The "crash stop" code starts with
>> -	 * an IRQ and falls back to NMI (which might be pseudo). If the IRQ
>> -	 * finally goes through right as we're timing out then the NMI could
>> -	 * interrupt us. It's better to prevent the NMI and let the IRQ
>> -	 * finish since the pt_regs will be better.
>> +	 * Use local_exception_mask() instead of local_irq_disable()
>> +	 * to make sure that pseudo-NMIs are disabled. The "crash stop" code
>> +	 * starts with an IRQ and falls back to NMI (which might be pseudo).
>> +	 * If the IRQ finally goes through right as we're timing out then
>> +	 * the NMI could interrupt us. It's better to prevent the NMI and let
>> +	 * the IRQ finish since the pt_regs will be better.
>>  	 */
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  
>>  	crash_save_cpu(regs, cpu);
>>  
>> diff --git a/arch/arm64/kernel/suspend.c b/arch/arm64/kernel/suspend.c
>> index eaaff94329cd..af16120818ac 100644
>> --- a/arch/arm64/kernel/suspend.c
>> +++ b/arch/arm64/kernel/suspend.c
>> @@ -9,7 +9,7 @@
>>  #include <asm/cacheflush.h>
>>  #include <asm/cpufeature.h>
>>  #include <asm/cpuidle.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/exec.h>
>>  #include <asm/fpsimd.h>
>> @@ -96,10 +96,9 @@ void notrace __cpu_suspend_exit(void)
>>   */
>>  int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>>  {
>> -	int ret = 0;
>> -	unsigned long flags;
>> +	struct exception_mask mask, cpuidle_mask;
>>  	struct sleep_stack_data state;
>> -	struct arm_cpuidle_irq_context context;
>> +	int ret = 0;
>>  
>>  	/*
>>  	 * Some portions of CPU state (e.g. PSTATE.{PAN,DIT}) are initialized
>> @@ -122,7 +121,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>>  	 * hardirqs should be firmly off by now. This really ought to use
>>  	 * something like raw_local_daif_save().
>>  	 */
>> -	flags = local_daif_save();
>> +	mask = local_exception_save_and_mask();
>>  
>>  	/*
>>  	 * Function graph tracer state gets inconsistent when the kernel
>> @@ -135,7 +134,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>>  	 * Switch to using DAIF.IF instead of PMR in order to reliably
>>  	 * resume if we're using pseudo-NMIs.
>>  	 */
>> -	arm_cpuidle_save_irq_context(&context);
>> +	arm_cpuidle_save_irq_context(&cpuidle_mask);
>>  
>>  	ct_cpuidle_enter();
>>  
>> @@ -159,7 +158,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>>  		__cpu_suspend_exit();
>>  	}
>>  
>> -	arm_cpuidle_restore_irq_context(&context);
>> +	arm_cpuidle_restore_irq_context(&cpuidle_mask);
>>  
>>  	unpause_graph_tracing();
>>  
>> @@ -168,7 +167,7 @@ int cpu_suspend(unsigned long arg, int (*fn)(unsigned long))
>>  	 * restored, so from this point onwards, debugging is fully
>>  	 * reenabled if it was enabled when core started shutdown.
>>  	 */
>> -	local_daif_restore(flags);
>> +	local_exception_restore(mask);
>>  
>>  	return ret;
>>  }
>> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
>> index 914282016069..fcc18b182eb2 100644
>> --- a/arch/arm64/kernel/traps.c
>> +++ b/arch/arm64/kernel/traps.c
>> @@ -33,7 +33,7 @@
>>  #include <asm/atomic.h>
>>  #include <asm/bug.h>
>>  #include <asm/cpufeature.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/efi.h>
>>  #include <asm/esr.h>
>> diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> index c4d2f1feea8b..96187ef5a025 100644
>> --- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> +++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
>> @@ -445,8 +445,8 @@ void __vgic_v3_init_lrs(void)
>>   */
>>  u64 __vgic_v3_get_gic_config(void)
>>  {
>> +	struct exception_mask mask;
>>  	u64 val, sre;
>> -	unsigned long flags = 0;
>>  
>>  	/*
>>  	 * In compat mode, we cannot access ICC_SRE_EL1 at any EL
>> @@ -476,7 +476,7 @@ u64 __vgic_v3_get_gic_config(void)
>>  	 * of the exception entry to EL2.
>>  	 */
>>  	if (has_vhe()) {
>> -		flags = local_daif_save();
>> +		mask = local_exception_save_and_mask();
>>  	} else {
>>  		sysreg_clear_set_hcr(0, HCR_AMO | HCR_FMO | HCR_IMO);
>>  		isb();
>> @@ -491,7 +491,7 @@ u64 __vgic_v3_get_gic_config(void)
>>  	isb();
>>  
>>  	if (has_vhe()) {
>> -		local_daif_restore(flags);
>> +		local_exception_restore(mask);
>>  	} else {
>>  		sysreg_clear_set_hcr(HCR_AMO | HCR_FMO | HCR_IMO, 0);
>>  		isb();
>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
>> index bbe9cebd3d9d..024876efe0c3 100644
>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
>> @@ -631,7 +631,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>>  {
>>  	int ret;
>>  
>> -	local_daif_mask();
>> +	local_exception_mask();
>>  
>>  	/*
>>  	 * Having IRQs masked via PMR when entering the guest means the GIC
>> @@ -647,10 +647,10 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
>>  	ret = __kvm_vcpu_run_vhe(vcpu);
>>  
>>  	/*
>> -	 * local_daif_restore() takes care to properly restore PSTATE.DAIF
>> +	 * local_exception_restore() takes care to properly restore PSTATE.DAIF
>>  	 * and the GIC PMR if the host is using IRQ priorities.
>>  	 */
>> -	local_daif_restore(DAIF_PROCCTX_NOIRQ);
>> +	local_exception_restore(arm64_make_noirq_mask());
>>  
>>  	return ret;
>>  }
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 85e23388f9bb..f7b8e87a099e 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -34,7 +34,7 @@
>>  #include <asm/cpufeature.h>
>>  #include <asm/efi.h>
>>  #include <asm/exception.h>
>> -#include <asm/daifflags.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/debug-monitors.h>
>>  #include <asm/esr.h>
>>  #include <asm/kprobes.h>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index f2be501468ce..9afcd2bc2fd1 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -2307,7 +2307,7 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
>>  	typedef void (ttbr_replace_func)(phys_addr_t);
>>  	extern ttbr_replace_func idmap_cpu_replace_ttbr1;
>>  	ttbr_replace_func *replace_phys;
>> -	unsigned long daif;
>> +	struct exception_mask mask;
>>  
>>  	/* phys_to_ttbr() zeros lower 2 bits of ttbr with 52-bit PA */
>>  	phys_addr_t ttbr1 = phys_to_ttbr(virt_to_phys(pgdp));
>> @@ -2323,9 +2323,9 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
>>  	 * We really don't want to take *any* exceptions while TTBR1 is
>>  	 * in the process of being replaced so mask everything.
>>  	 */
>> -	daif = local_daif_save();
>> +	mask = local_exception_save_and_mask();
>>  	replace_phys(ttbr1);
>> -	local_daif_restore(daif);
>> +	local_exception_restore(mask);
>>  
>>  	cpu_uninstall_idmap();
>>  }
>> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
>> index e73bae6cb23a..4cc834db7c15 100644
>> --- a/drivers/firmware/psci/psci.c
>> +++ b/drivers/firmware/psci/psci.c
>> @@ -24,6 +24,7 @@
>>  
>>  #include <asm/cpuidle.h>
>>  #include <asm/cputype.h>
>> +#include <asm/exception_masks.h>
>>  #include <asm/hypervisor.h>
>>  #include <asm/system_misc.h>
>>  #include <asm/smp_plat.h>
>> @@ -503,12 +504,12 @@ int psci_cpu_suspend_enter(u32 state)
>>  	int ret;
>>  
>>  	if (!psci_power_state_loses_context(state)) {
>> -		struct arm_cpuidle_irq_context context;
>> +		struct exception_mask mask;
>>  
>>  		ct_cpuidle_enter();
>> -		arm_cpuidle_save_irq_context(&context);
>> +		arm_cpuidle_save_irq_context(&mask);
>>  		ret = psci_ops.cpu_suspend(state, 0);
>> -		arm_cpuidle_restore_irq_context(&context);
>> +		arm_cpuidle_restore_irq_context(&mask);
>>  		ct_cpuidle_exit();
>>  	} else {
>>  		/*
>> -- 
>> 2.34.1
>>
> 

