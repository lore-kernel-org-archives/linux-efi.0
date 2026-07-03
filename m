Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D895B35A387;
	Fri,  3 Jul 2026 10:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072944; cv=none; b=snTWxADMKBFAKsz0CqYFb2TNpXIkb+SUWewfUkSykA4vGdWstVjQxA7iZNC0BZY0FgAkfuiNN0qxjP3z2QXT3tnlFVzzGoBBj6vlIClwoTvkPlEV68VNX2FgXUVD3Z4wvGU0A8/qCAi5U6JvAHvFikK0Wg2fB7pGfCrqxIn0PEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072944; c=relaxed/simple;
	bh=JWCxTOsV2dA7z6VxVONQlPLmdWFhrFsM9+oISbpODdQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NuNwsNmSNe6e52Jg70Gx3idpkQUoZJUm6rq1z7gpWC+7RQD3Vp4PdPyqZ2qjxoDVJEieqNJ6wmhax/tdUOp1IIXPL4VyMzAO/iCDs8WRGhY017cTHbkVoYwXWlIHEnyWnEFt+Kk2A24bc0R+gK92sgLHowAItkcSCNGq8G8R7wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=GQIlrVZ2; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="GQIlrVZ2"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=6a6mDkZdZ+OBlzajcYcMQbQWF9p+PLV7Ah7P0dvJklc=;
	b=GQIlrVZ2TK2Rh0A1ilD5HVA8yknucAhH67lTSe6r48BWk3EDCcBlSkzlbr6qFvR03KaIfWqvE
	zvQiPmt0FDevX4I+nFoCFyz+bGAkEc3V7z6DKm1cOrX+XBvoZSd6QN/NxywOTp3aBlb867A9zaW
	SmlycWbjr+Gfuv7/0K4wGYE=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gs8GL65XfzpSvY;
	Fri,  3 Jul 2026 17:53:46 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 4167F40579;
	Fri,  3 Jul 2026 18:02:18 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:02:14 +0800
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
Subject: [PATCH 01/17] arm64: Move DAIF macros to ptrace.h and use them centrally
Date: Fri, 3 Jul 2026 18:01:19 +0800
Message-ID: <20260703100135.2512312-2-ruanjinjie@huawei.com>
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

Currently, various subsystems and low-level headers explicitly combine
PSR_I_BIT, PSR_F_BIT, and other DAIF bits (such as D and A) to mask
or unmask interrupts and exceptions. This hardcoded approach reduces
code readability and increases the maintenance burden when managing
processor contexts.

So move the definitions of DAIF_PROCCTX, DAIF_PROCCTX_NOIRQ, DAIF_ERRCTX,
and DAIF_MASK from <asm/daifflags.h> to <asm/ptrace.h>. And clean this up
by replacing explicit bitmask combinations with the unified
macros defined in <asm/daifflags.h>. Specifically:

- Replace `PSR_I_BIT | PSR_F_BIT` with `DAIF_PROCCTX_NOIRQ` where
  normal interrupts are disabled but NMIs/asynchronous errors can
  still be taken.

- Replace the full explicit DAIF bit mask with `DAIF_MASK`.

This unifies DAIF flag manipulation across kvm, cpuidle, daifflags, and
efi subsystems, making the code more readable.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/cpuidle.h   |  3 ++-
 arch/arm64/include/asm/daifflags.h | 12 +++---------
 arch/arm64/include/asm/efi.h       |  2 +-
 arch/arm64/include/asm/ptrace.h    | 11 +++++++----
 arch/arm64/kvm/emulate-nested.c    |  6 +++---
 arch/arm64/kvm/hyp/nvhe/host.S     |  4 ++--
 arch/arm64/kvm/hyp/nvhe/hyp-init.S |  3 ++-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c |  4 ++--
 arch/arm64/kvm/reset.c             |  6 ++----
 9 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/cpuidle.h b/arch/arm64/include/asm/cpuidle.h
index 2047713e097d..64ddb533d3ec 100644
--- a/arch/arm64/include/asm/cpuidle.h
+++ b/arch/arm64/include/asm/cpuidle.h
@@ -6,6 +6,7 @@
 
 #ifdef CONFIG_ARM64_PSEUDO_NMI
 #include <asm/arch_gicv3.h>
+#include <asm/ptrace.h>
 
 struct arm_cpuidle_irq_context {
 	unsigned long pmr;
@@ -17,7 +18,7 @@ struct arm_cpuidle_irq_context {
 		struct arm_cpuidle_irq_context *c = __c;		\
 		if (system_uses_irq_prio_masking()) {			\
 			c->daif_bits = read_sysreg(daif);		\
-			write_sysreg(c->daif_bits | PSR_I_BIT | PSR_F_BIT, \
+			write_sysreg(c->daif_bits | DAIF_PROCCTX_NOIRQ, \
 				     daif);				\
 			c->pmr = gic_read_pmr();			\
 			gic_write_pmr(GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET); \
diff --git a/arch/arm64/include/asm/daifflags.h b/arch/arm64/include/asm/daifflags.h
index 795b35128467..3a4b63a948ac 100644
--- a/arch/arm64/include/asm/daifflags.h
+++ b/arch/arm64/include/asm/daifflags.h
@@ -12,12 +12,6 @@
 #include <asm/cpufeature.h>
 #include <asm/ptrace.h>
 
-#define DAIF_PROCCTX		0
-#define DAIF_PROCCTX_NOIRQ	(PSR_I_BIT | PSR_F_BIT)
-#define DAIF_ERRCTX		(PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
-#define DAIF_MASK		(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
-
-
 /* mask/save/unmask/restore all exceptions, including interrupts. */
 static __always_inline void local_daif_mask(void)
 {
@@ -47,7 +41,7 @@ static __always_inline unsigned long local_daif_save_flags(void)
 	if (system_uses_irq_prio_masking()) {
 		/* If IRQs are masked with PMR, reflect it in the flags */
 		if (read_sysreg_s(SYS_ICC_PMR_EL1) != GIC_PRIO_IRQON)
-			flags |= PSR_I_BIT | PSR_F_BIT;
+			flags |= DAIF_PROCCTX_NOIRQ;
 	}
 
 	return flags;
@@ -69,7 +63,7 @@ static __always_inline void local_daif_restore(unsigned long flags)
 	bool irq_disabled = flags & PSR_I_BIT;
 
 	WARN_ON(system_has_prio_mask_debugging() &&
-		(read_sysreg(daif) & (PSR_I_BIT | PSR_F_BIT)) != (PSR_I_BIT | PSR_F_BIT));
+		(read_sysreg(daif) & DAIF_PROCCTX_NOIRQ) != DAIF_PROCCTX_NOIRQ);
 
 	if (!irq_disabled) {
 		trace_hardirqs_on();
@@ -86,7 +80,7 @@ static __always_inline void local_daif_restore(unsigned long flags)
 			 * If interrupts are disabled but we can take
 			 * asynchronous errors, we can take NMIs
 			 */
-			flags &= ~(PSR_I_BIT | PSR_F_BIT);
+			flags &= ~DAIF_PROCCTX_NOIRQ;
 			pmr = GIC_PRIO_IRQOFF;
 		} else {
 			pmr = GIC_PRIO_IRQON | GIC_PRIO_PSR_I_SET;
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e8a9783235cb..ae2a24868ee7 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -48,7 +48,7 @@ void arch_efi_call_virt_teardown(void);
 	(efi_rt_stack_top != NULL &&					\
 	 on_task_stack(current, READ_ONCE(efi_rt_stack_top[-1]), 1))
 
-#define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+#define ARCH_EFI_IRQ_FLAGS_MASK (DAIF_MASK)
 
 /*
  * Even when Linux uses IRQ priorities for IRQ disabling, EFI does not.
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 39582511ad72..f33f75881c9a 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -12,14 +12,17 @@
 
 #include <uapi/asm/ptrace.h>
 
+#define DAIF_PROCCTX		0
+#define DAIF_PROCCTX_NOIRQ	(PSR_I_BIT | PSR_F_BIT)
+#define DAIF_ERRCTX		(PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+#define DAIF_MASK		(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+
 /* Current Exception Level values, as contained in CurrentEL */
 #define CurrentEL_EL1		(1 << 2)
 #define CurrentEL_EL2		(2 << 2)
 
-#define INIT_PSTATE_EL1 \
-	(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | PSR_MODE_EL1h)
-#define INIT_PSTATE_EL2 \
-	(PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | PSR_MODE_EL2h)
+#define INIT_PSTATE_EL1	(DAIF_MASK | PSR_MODE_EL1h)
+#define INIT_PSTATE_EL2	(DAIF_MASK | PSR_MODE_EL2h)
 
 #include <linux/irqchip/arm-gic-v3-prio.h>
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index e688bc5139c1..356b67aa8dc0 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -9,6 +9,7 @@
 
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_nested.h>
+#include <asm/ptrace.h>
 
 #include "hyp/include/hyp/adjust_pc.h"
 
@@ -2754,9 +2755,8 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 		 */
 		spsr = *vcpu_cpsr(vcpu);
 
-		spsr &= (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
-			 PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT | PSR_V_BIT |
-			 PSR_MODE_MASK | PSR_MODE32_BIT);
+		spsr &= (DAIF_MASK | PSR_N_BIT | PSR_Z_BIT | PSR_C_BIT |
+			 PSR_V_BIT | PSR_MODE_MASK | PSR_MODE32_BIT);
 		spsr |= PSR_IL_BIT;
 	}
 
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 9393fe3ea6a1..cbe2a616c726 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -11,6 +11,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_ptrauth.h>
+#include <asm/ptrace.h>
 
 	.text
 
@@ -111,8 +112,7 @@ SYM_FUNC_END(__host_enter)
  */
 SYM_FUNC_START(__hyp_do_panic)
 	/* Prepare and exit to the host's panic function. */
-	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
-		      PSR_MODE_EL1h)
+	mov	lr, #(DAIF_MASK | PSR_MODE_EL1h)
 	msr	spsr_el2, lr
 	adr_l	lr, nvhe_hyp_panic_handler
 	hyp_kimg_va lr, x6
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 89cb553be1e5..26ea02e7f5fd 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -15,6 +15,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_mmu.h>
 #include <asm/pgtable-hwdef.h>
+#include <asm/ptrace.h>
 #include <asm/sysreg.h>
 #include <asm/virt.h>
 
@@ -224,7 +225,7 @@ SYM_CODE_START(__kvm_handle_stub_hvc)
 
 	/* This is where we're about to jump, staying at EL2 */
 	msr	elr_el2, x1
-	mov	x0, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT | PSR_MODE_EL2h)
+	mov	x0, #(DAIF_MASK | PSR_MODE_EL2h)
 	msr	spsr_el2, x0
 
 	/* Shuffle the arguments, and don't come back */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index d3c69de698f4..69dfbbe109ad 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -8,6 +8,7 @@
 #include <hyp/switch.h>
 
 #include <asm/pgtable-types.h>
+#include <asm/ptrace.h>
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_host.h>
@@ -859,8 +860,7 @@ void inject_host_exception(u64 esr)
 	}
 
 	spsr_el2 &= spsr_mask;
-	spsr_el2 |= PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT |
-		    PSR_MODE_EL1h;
+	spsr_el2 |= DAIF_MASK | PSR_MODE_EL1h;
 
 	sctlr = read_sysreg_el1(SYS_SCTLR);
 	if (!(sctlr & SCTLR_EL1_SPAN))
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index b963fd975aac..0e1167eee5c0 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -37,11 +37,9 @@ unsigned int __ro_after_init kvm_host_sve_max_vl;
 /*
  * ARMv8 Reset Values
  */
-#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
+#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | DAIF_MASK)
 
-#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | DAIF_MASK)
 
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
-- 
2.34.1

