Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA9A3CA4B9;
	Fri,  3 Jul 2026 10:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072982; cv=none; b=sdBEHMEAp7E4FOrK3Lx+JHw+eAUaf7yL041px2iT1hblOO2d0vHr6HUvKFv3eiBL33Xxx/k5z12xqV9bOTWyBDjM8A6Lafha2jvqR2BBOBRDTPdAmgiNC+t9wgJXEFyNPJWm2KyCDv6M0OQzqk/zIDpwpYYP9K0nXlcvEz5g4JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072982; c=relaxed/simple;
	bh=Kn3ikfTiRR9B/rDLxYLHM0EECi8SSr9JF4E/cWAqeG8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qBcRKDuWbo6IM+OfVVQwVGlsJ/oUFzpGn172wWf0uVKIbjBibpVec//6xbj3bDRi1N6yh3wg9N7Lom+fdNBh7UFffghJ5JjhvwiWMCyxSNGURRkl9xEwd1dU4J2ex2PT/kmR/duVF7u+9lsSn7FfjxYkjKM8MkNYCuSATHcY5Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=aOK0iu1j; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="aOK0iu1j"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bPvLeuWguviBJUlF5M8yJR6JSiKpkQk532vZ2PrhA7E=;
	b=aOK0iu1j8ly6PUNKSwG01ZoY+YG0EvPu0O6MgCsEs3HGABeddO3sc3fTO6z4hBkgKOjAYXt05
	NOCvxUsaE1I456YkWS+ZjQGxrAMVUVVLvSFhFErBGnSWmS1kv66ohPLJzzrMJMGMFqBUd4+6gJX
	v2/Ldvw+L8ZWx7ZRTqHkgYE=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Gv50hlz12LD7;
	Fri,  3 Jul 2026 17:54:15 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id AF0F640561;
	Fri,  3 Jul 2026 18:02:57 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:02:54 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <maz@kernel.org>, <ardb@kernel.org>,
	<ilias.apalodimas@linaro.org>, <oupton@kernel.org>, <joey.gouly@arm.com>,
	<seiden@linux.ibm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<oleg@redhat.com>, <mark.rutland@arm.com>, <lpieralisi@kernel.org>,
	<tglx@kernel.org>, <ada.coupriediaz@arm.com>, <anshuman.khandual@arm.com>,
	<ruanjinjie@huawei.com>, <ebiggers@kernel.org>, <broonie@kernel.org>,
	<mrigendra.chaubey@gmail.com>, <baohua@kernel.org>, <lucaswei@google.com>,
	<james.morse@arm.com>, <zengheng4@huawei.com>, <thuth@redhat.com>,
	<yang@os.amperecomputing.com>, <leo.bras@arm.com>, <Sascha.Bischoff@arm.com>,
	<james.clark@linaro.org>, <peterz@infradead.org>, <leitao@debian.org>,
	<ben.horgan@arm.com>, <punit.agrawal@oss.qualcomm.com>, <gshan@redhat.com>,
	<osama.abdelkader@gmail.com>, <fengchengwen@huawei.com>,
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
Subject: [PATCH 12/17] arm64/nmi: Manage masking for superpriority interrupts along with DAIF
Date: Fri, 3 Jul 2026 18:01:30 +0800
Message-ID: <20260703100135.2512312-13-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260703100135.2512312-1-ruanjinjie@huawei.com>
References: <20260703100135.2512312-1-ruanjinjie@huawei.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)

From: Mark Brown <broonie@kernel.org>

As we do for pseudo NMIs add code to our DAIF management which keeps
superpriority interrupts unmasked when we have asynchronous exceptions
enabled. Since superpriority interrupts are not masked through DAIF like
pseduo NMIs are we also need to modify the assembler macros for managing
DAIF to ensure that the masking is done in the assembly code. At present
users of the assembly macros always mask pseudo NMIs.

There is a difference to the actual handling between pseudo NMIs
and superpriority interrupts in the assembly save_and_disable_irq and
restore_irq macros, these cover both interrupts and FIQs using DAIF
without regard for the use of pseudo NMIs so also mask those but are not
updated here to mask superpriority interrupts. Given the names it is not
clear that the behaviour with pseudo NMIs is particularly intentional,
and in any case these macros are only used in the implementation of
alternatives for software PAN while hardware PAN has been mandatory
since v8.1 so it is not anticipated that practical systems with support
for FEAT_NMI will ever execute the affected code.

This should be a conservative set of masked regions, we may be able to
relax this in future, but this should represent a good starting point.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221112151708.175147-11-broonie@kernel.org
Co-developed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/arch_gicv3.h      |  7 ++++++-
 arch/arm64/include/asm/assembler.h       | 13 +++++++++++++
 arch/arm64/include/asm/efi.h             | 22 ++++++++++++++++------
 arch/arm64/include/asm/exception_masks.h | 22 ++++++++++++++++++++--
 arch/arm64/include/uapi/asm/ptrace.h     |  1 +
 arch/arm64/kernel/probes/kprobes.c       |  7 +++++++
 arch/arm64/kernel/process.c              |  3 ++-
 drivers/irqchip/irq-gic-v3.c             |  6 +++---
 8 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index d20b03931a8d..78405aa0d233 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -15,6 +15,7 @@
 #include <linux/stringify.h>
 #include <asm/barrier.h>
 #include <asm/cacheflush.h>
+#include <asm/nmi.h>
 
 #define read_gicreg(r)			read_sysreg_s(SYS_ ## r)
 #define write_gicreg(v, r)		write_sysreg_s(v, SYS_ ## r)
@@ -180,7 +181,11 @@ static inline void gic_pmr_mask_irqs(void)
 
 static inline void gic_arch_enable_irqs(void)
 {
-	asm volatile ("msr daifclr, #3" : : : "memory");
+	if (gic_prio_masking_enabled())
+		asm volatile ("msr daifclr, #3" : : : "memory");
+
+	if (system_uses_nmi())
+		_allint_clear();
 }
 
 static inline bool gic_has_relaxed_pmr_sync(void)
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 0b58b550e8dc..b7293844bbc5 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -39,6 +39,11 @@
  */
 	.macro save_and_disable_daif, flags
 	mrs	\flags, daif
+#ifdef CONFIG_ARM64_NMI
+alternative_if ARM64_HAS_NMI
+	msr_s	SYS_ALLINT_SET, xzr
+alternative_else_nop_endif
+#endif
 	msr	daifset, #0xf
 	.endm
 
@@ -49,6 +54,14 @@
 
 	.macro	restore_irq, flags
 	msr	daif, \flags
+#ifdef CONFIG_ARM64_NMI
+alternative_if ARM64_HAS_NMI
+	/* If async exceptions are unmasked we can take NMIs */
+	tbnz	\flags, #8, 2004f
+	msr_s	SYS_ALLINT_CLR, xzr
+2004:
+alternative_else_nop_endif
+#endif
 	.endm
 
 	.macro	disable_step_tsk, flgs, tmp
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index ae2a24868ee7..9435b64124e7 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -48,18 +48,28 @@ void arch_efi_call_virt_teardown(void);
 	(efi_rt_stack_top != NULL &&					\
 	 on_task_stack(current, READ_ONCE(efi_rt_stack_top[-1]), 1))
 
-#define ARCH_EFI_IRQ_FLAGS_MASK (DAIF_MASK)
+#define ARCH_EFI_IRQ_FLAGS_MASK		\
+	(system_uses_nmi() ? (DAIF_MASK | ALLINT_ALLINT) : (DAIF_MASK))
 
 /*
  * Even when Linux uses IRQ priorities for IRQ disabling, EFI does not.
  * And EFI shouldn't really play around with priority masking as it is not aware
  * which priorities the OS has assigned to its interrupts.
  */
-#define arch_efi_save_flags(state_flags)		\
-	((void)((state_flags) = read_sysreg(daif)))
-
-#define arch_efi_restore_flags(state_flags)	write_sysreg(state_flags, daif)
-
+#define arch_efi_save_flags(state_flags)			\
+	do {							\
+		((void)((state_flags) = read_sysreg(daif)));	\
+		if (system_uses_nmi())				\
+			(state_flags) |= (read_sysreg_s(SYS_ALLINT) & ALLINT_ALLINT);	\
+	} while (0)
+
+#define arch_efi_restore_flags(state_flags)			\
+	do {							\
+		u64 __flags = (state_flags);			\
+		write_sysreg(__flags & DAIF_MASK, daif);	\
+		if (system_uses_nmi())				\
+			write_sysreg_s(__flags & ALLINT_ALLINT, SYS_ALLINT);	\
+	} while (0)
 
 /* arch specific definitions used by the stub code */
 
diff --git a/arch/arm64/include/asm/exception_masks.h b/arch/arm64/include/asm/exception_masks.h
index fbbba769ca03..3dd41998f705 100644
--- a/arch/arm64/include/asm/exception_masks.h
+++ b/arch/arm64/include/asm/exception_masks.h
@@ -10,6 +10,7 @@
 #include <asm/arch_gicv3.h>
 #include <asm/barrier.h>
 #include <asm/cpufeature.h>
+#include <asm/nmi.h>
 #include <asm/ptrace.h>
 
 /*
@@ -46,7 +47,10 @@ static inline struct exception_mask arm64_make_errctx_mask(void)
 	if (system_uses_irq_prio_masking())
 		mask.pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
 
-	mask.allint = 0;
+	if (system_uses_nmi())
+		mask.allint = ALLINT_ALLINT;
+	else
+		mask.allint = 0;
 
 	return mask;
 }
@@ -78,6 +82,9 @@ static inline void local_exception_mask(void)
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET);
 
+	if (system_uses_nmi())
+		_allint_set();
+
 	trace_hardirqs_off();
 }
 
@@ -87,7 +94,8 @@ static inline void local_exception_save_mask(struct exception_mask *mask)
 	if (system_uses_irq_prio_masking())
 		mask->pmr = gic_read_pmr();
 
-	mask->allint = 0;
+	if (system_uses_nmi())
+		mask->allint = read_sysreg_s(SYS_ALLINT);
 }
 
 static inline struct exception_mask local_exception_save_and_mask(void)
@@ -118,6 +126,9 @@ static inline void local_exception_restore(const struct exception_mask mask)
 		pmr_sync();
 	}
 
+	if (system_uses_nmi())
+		write_sysreg_s(mask.allint, SYS_ALLINT);
+
 	write_sysreg(mask.daif, daif);
 
 	if (irq_disabled)
@@ -137,6 +148,13 @@ static inline void local_exception_inherit(struct pt_regs *regs)
 		gic_write_pmr(regs->pmr);
 
 	write_sysreg(regs->pstate & DAIF_MASK, daif);
+
+	if (system_uses_nmi()) {
+		if (regs->pstate & ALLINT_ALLINT)
+			_allint_set();
+		else
+			_allint_clear();
+	}
 }
 
 /*
diff --git a/arch/arm64/include/uapi/asm/ptrace.h b/arch/arm64/include/uapi/asm/ptrace.h
index 6fed93fb2536..99352dd823cc 100644
--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -48,6 +48,7 @@
 #define PSR_D_BIT	0x00000200
 #define PSR_BTYPE_MASK	0x00000c00
 #define PSR_SSBS_BIT	0x00001000
+#define PSR_ALLINT_BIT	0x00002000
 #define PSR_PAN_BIT	0x00400000
 #define PSR_UAO_BIT	0x00800000
 #define PSR_DIT_BIT	0x01000000
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 70d311e415ac..8045245ebbdd 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -197,12 +197,19 @@ static void __kprobes kprobes_save_local_irqflag(struct kprobe_ctlblk *kcb,
 {
 	kcb->saved_irqflag = regs->pstate & DAIF_MASK;
 	regs->pstate |= DAIF_MASK;
+
+	if (system_uses_nmi())
+		regs->pstate |= ALLINT_ALLINT;
 }
 
 static void __kprobes kprobes_restore_local_irqflag(struct kprobe_ctlblk *kcb,
 						struct pt_regs *regs)
 {
 	regs->pstate &= ~DAIF_MASK;
+
+	if (system_uses_nmi())
+		regs->pstate &= ~ALLINT_ALLINT;
+
 	regs->pstate |= kcb->saved_irqflag;
 }
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 033643cd4e5e..1aa8f0f66484 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -182,7 +182,7 @@ static void print_pstate(struct pt_regs *regs)
 		const char *btype_str = btypes[(pstate & PSR_BTYPE_MASK) >>
 					       PSR_BTYPE_SHIFT];
 
-		printk("pstate: %08llx (%c%c%c%c %c%c%c%c %cPAN %cUAO %cTCO %cDIT %cSSBS BTYPE=%s)\n",
+		printk("pstate: %08llx (%c%c%c%c %c%c%c%c %cPAN %cUAO %cTCO %cDIT %cSSBS %cALLINT BTYPE=%s)\n",
 			pstate,
 			pstate & PSR_N_BIT ? 'N' : 'n',
 			pstate & PSR_Z_BIT ? 'Z' : 'z',
@@ -197,6 +197,7 @@ static void print_pstate(struct pt_regs *regs)
 			pstate & PSR_TCO_BIT ? '+' : '-',
 			pstate & PSR_DIT_BIT ? '+' : '-',
 			pstate & PSR_SSBS_BIT ? '+' : '-',
+			pstate & PSR_ALLINT_BIT ? '+' : '-',
 			btype_str);
 	}
 }
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 99444a1b2ffa..111cd882c7a9 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -867,10 +867,10 @@ static void __gic_handle_irq_from_irqson(struct pt_regs *regs)
 		nmi_exit();
 	}
 
-	if (gic_prio_masking_enabled()) {
+	if (gic_prio_masking_enabled())
 		gic_pmr_mask_irqs();
-		gic_arch_enable_irqs();
-	}
+
+	gic_arch_enable_irqs();
 
 	if (!is_nmi)
 		__gic_handle_irq(irqnr, regs);
-- 
2.34.1

