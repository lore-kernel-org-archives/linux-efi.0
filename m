Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946E33B8944;
	Fri,  3 Jul 2026 10:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072993; cv=none; b=HtygI0koA5f5eUmQaQdAwaR2VaAgViWAdqdQpqAeytxXD7ZBM8O8+/yEcYWqZs+CITUtndDWqwZL2IiYd4/PPQk820+mL8jQnrbI8fhazC0SpnCUZ2h4L2W3DNEqPnfvdqMwUi8DE6E85k4amrKhq5V2wfwHyIPAnWMSuK9uyzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072993; c=relaxed/simple;
	bh=tKEBzK0mcfiTSMbAdB6HhV9cKlrRAMJ7x575FYNjG/A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KS8dLJSibm53dY2CsVKycBXSV1x6x5xAMs9MbsoAkUsz6FRpcUmpCe4JHw2amZGyuy8dOonxzFP66+sQ+gARLGAjhM5/OlXONp5eMSnjjpGk6HGfjiLoPmEpuJPWyjjjUzpdcRSKFGBItOTHGchIrKKWdajBx6GFzQ9HiQJZPrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=luRBk927; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="luRBk927"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dcnVmxdaH6wSRZRqnLtsXvnAeOilL/23LtsClQlQYcg=;
	b=luRBk927VaQIe7kH/0SMlXJh/LjQhUAynKwB2I5p+GAIna/q1Ztwd1PQd5v+HNNJtVglVWmMq
	Gt7WBOuElb9hutkkZ6hH9GNN6ACfE1oX4yRDzwggN/Mh8qNV0/yeN73yTiWNMFn5SfcUKayy/eO
	/q1tqBZhKvZfykLWMRx53j8=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4gs8GZ5LRfz1K97g;
	Fri,  3 Jul 2026 17:53:58 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EC4F40578;
	Fri,  3 Jul 2026 18:03:08 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:03:04 +0800
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
Subject: [PATCH 15/17] arm64/nmi: Add handling of superpriority interrupts as NMIs
Date: Fri, 3 Jul 2026 18:01:33 +0800
Message-ID: <20260703100135.2512312-16-ruanjinjie@huawei.com>
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

Our goal with superpriority interrupts is to use them as NMIs, taking
advantage of the much smaller regions where they are masked to allow
prompt handling of the most time critical interrupts.

When an interrupt configured with superpriority we will enter EL1 as
normal for any interrupt, the presence of a superpriority interrupt is
indicated with a status bit in ISR_EL1. We use this to check for the
presence of a superpriority interrupt before we unmask anything in
elX_interrupt(), reporting without unmasking any interrupts. If no
superpriority interrupt is present then we handle normal interrupts as
normal, superpriority interrupts will be unmasked while doing so as a
result of setting DAIF_PROCCTX.

Both IRQs and FIQs may be configured with superpriority so we handle
both, passing an additional root handler into the elX_interrupt()
function along with the mask for the bit in ISR_EL1 which indicates the
presence of the relevant kind of superpriority interrupt. These root
handlers can be configured by the interrupt controller similarly to the
root handlers for normal interrupts using the newly added
set_handle_nmi_irq() and set_handle_nmi_fiq() functions.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221112151708.175147-13-broonie@kernel.org
Co-developed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/irq.h     |  2 ++
 arch/arm64/kernel/entry-common.c | 59 +++++++++++++++++++++++++++-----
 arch/arm64/kernel/irq.c          | 32 +++++++++++++++++
 arch/arm64/kernel/process.c      |  4 +++
 4 files changed, 89 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/irq.h b/arch/arm64/include/asm/irq.h
index e93548914c36..bf77769c5dfb 100644
--- a/arch/arm64/include/asm/irq.h
+++ b/arch/arm64/include/asm/irq.h
@@ -13,6 +13,8 @@ void arch_trigger_cpumask_backtrace(const cpumask_t *mask, int exclude_cpu);
 
 struct pt_regs;
 
+int set_handle_nmi_irq(void (*handle_irq)(struct pt_regs *));
+int set_handle_nmi_fiq(void (*handle_fiq)(struct pt_regs *));
 int set_handle_irq(void (*handle_irq)(struct pt_regs *));
 #define set_handle_irq	set_handle_irq
 int set_handle_fiq(void (*handle_fiq)(struct pt_regs *));
diff --git a/arch/arm64/kernel/entry-common.c b/arch/arm64/kernel/entry-common.c
index dc223085e773..4115a5e7c392 100644
--- a/arch/arm64/kernel/entry-common.c
+++ b/arch/arm64/kernel/entry-common.c
@@ -162,6 +162,8 @@ static void do_interrupt_handler(struct pt_regs *regs,
 	set_irq_regs(old_regs);
 }
 
+extern void (*handle_arch_nmi_irq)(struct pt_regs *);
+extern void (*handle_arch_nmi_fiq)(struct pt_regs *);
 extern void (*handle_arch_irq)(struct pt_regs *);
 extern void (*handle_arch_fiq)(struct pt_regs *);
 
@@ -514,6 +516,16 @@ asmlinkage void noinstr el1h_64_sync_handler(struct pt_regs *regs)
 	}
 }
 
+static __always_inline void __el1_nmi(struct pt_regs *regs,
+				      void (*handler)(struct pt_regs *))
+{
+	irqentry_state_t state;
+
+	state = irqentry_nmi_enter(regs);
+	do_interrupt_handler(regs, handler);
+	irqentry_nmi_exit(regs, state);
+}
+
 static __always_inline void __el1_pnmi(struct pt_regs *regs,
 				       void (*handler)(struct pt_regs *))
 {
@@ -537,11 +549,20 @@ static __always_inline void __el1_irq(struct pt_regs *regs,
 
 	arm64_exit_to_kernel_mode(regs, state);
 }
-static void noinstr el1_interrupt(struct pt_regs *regs,
-				  void (*handler)(struct pt_regs *))
+static void noinstr el1_interrupt(struct pt_regs *regs, u64 nmi_flag,
+				  void (*handler)(struct pt_regs *),
+				  void (*nmi_handler)(struct pt_regs *))
 {
 	struct exception_mask mask = irq_entry_unmask_debug_serror(regs);
 
+	if (system_uses_nmi()) {
+		/* Is there a NMI to handle? */
+		if (read_sysreg(isr_el1) & nmi_flag) {
+			__el1_nmi(regs, nmi_handler);
+			return;
+		}
+	}
+
 	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && regs_irqs_disabled(regs))
 		__el1_pnmi(regs, handler);
 	else
@@ -552,12 +573,12 @@ static void noinstr el1_interrupt(struct pt_regs *regs,
 
 asmlinkage void noinstr el1h_64_irq_handler(struct pt_regs *regs)
 {
-	el1_interrupt(regs, handle_arch_irq);
+	el1_interrupt(regs, ISR_EL1_IS, handle_arch_irq, handle_arch_nmi_irq);
 }
 
 asmlinkage void noinstr el1h_64_fiq_handler(struct pt_regs *regs)
 {
-	el1_interrupt(regs, handle_arch_fiq);
+	el1_interrupt(regs, ISR_EL1_FS, handle_arch_fiq, handle_arch_nmi_fiq);
 }
 
 asmlinkage void noinstr el1h_64_error_handler(struct pt_regs *regs)
@@ -844,13 +865,35 @@ asmlinkage void noinstr el0t_64_sync_handler(struct pt_regs *regs)
 	}
 }
 
-static void noinstr el0_interrupt(struct pt_regs *regs,
-				  void (*handler)(struct pt_regs *))
+static void noinstr el0_interrupt(struct pt_regs *regs, u64 nmi_flag,
+				  void (*handler)(struct pt_regs *),
+				  void (*nmi_handler)(struct pt_regs *))
 {
 	arm64_enter_from_user_mode(regs);
 
 	irq_entry_unmask_debug_serror(regs);
 
+	if (system_uses_nmi()) {
+		irqentry_state_t state;
+
+		/* Is there a NMI to handle? */
+		if (read_sysreg(isr_el1) & nmi_flag) {
+			/*
+			 * Any system with FEAT_NMI should not be
+			 * affected by Spectre v2 so we don't mitigate
+			 * here.
+			 */
+			state = irqentry_nmi_enter(regs);
+			do_interrupt_handler(regs, nmi_handler);
+			irqentry_nmi_exit(regs, state);
+
+			_allint_clear();
+
+			arm64_exit_to_user_mode(regs);
+			return;
+		}
+	}
+
 	if (regs->pc & BIT(55))
 		arm64_apply_bp_hardening();
 
@@ -863,7 +906,7 @@ static void noinstr el0_interrupt(struct pt_regs *regs,
 
 static void noinstr __el0_irq_handler_common(struct pt_regs *regs)
 {
-	el0_interrupt(regs, handle_arch_irq);
+	el0_interrupt(regs, ISR_EL1_IS, handle_arch_irq, handle_arch_nmi_irq);
 }
 
 asmlinkage void noinstr el0t_64_irq_handler(struct pt_regs *regs)
@@ -873,7 +916,7 @@ asmlinkage void noinstr el0t_64_irq_handler(struct pt_regs *regs)
 
 static void noinstr __el0_fiq_handler_common(struct pt_regs *regs)
 {
-	el0_interrupt(regs, handle_arch_fiq);
+	el0_interrupt(regs, ISR_EL1_FS, handle_arch_fiq, handle_arch_nmi_fiq);
 }
 
 asmlinkage void noinstr el0t_64_fiq_handler(struct pt_regs *regs)
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index fff0efd5a195..54e25b4c0698 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -84,6 +84,16 @@ void do_softirq_own_stack(void)
 }
 #endif
 
+static void default_handle_nmi_irq(struct pt_regs *regs)
+{
+	panic("Superpriority IRQ taken without a root NMI IRQ handler\n");
+}
+
+static void default_handle_nmi_fiq(struct pt_regs *regs)
+{
+	panic("Superpriority FIQ taken without a root NMI FIQ handler\n");
+}
+
 static void default_handle_irq(struct pt_regs *regs)
 {
 	panic("IRQ taken without a root IRQ handler\n");
@@ -94,9 +104,31 @@ static void default_handle_fiq(struct pt_regs *regs)
 	panic("FIQ taken without a root FIQ handler\n");
 }
 
+void (*handle_arch_nmi_irq)(struct pt_regs *) __ro_after_init = default_handle_nmi_irq;
+void (*handle_arch_nmi_fiq)(struct pt_regs *) __ro_after_init = default_handle_nmi_fiq;
 void (*handle_arch_irq)(struct pt_regs *) __ro_after_init = default_handle_irq;
 void (*handle_arch_fiq)(struct pt_regs *) __ro_after_init = default_handle_fiq;
 
+int __init set_handle_nmi_irq(void (*handle_nmi_irq)(struct pt_regs *))
+{
+	if (handle_arch_nmi_irq != default_handle_nmi_irq)
+		return -EBUSY;
+
+	handle_arch_nmi_irq = handle_nmi_irq;
+	pr_info("Root superpriority IRQ handler: %ps\n", handle_nmi_irq);
+	return 0;
+}
+
+int __init set_handle_nmi_fiq(void (*handle_nmi_fiq)(struct pt_regs *))
+{
+	if (handle_arch_nmi_fiq != default_handle_nmi_fiq)
+		return -EBUSY;
+
+	handle_arch_nmi_fiq = handle_nmi_fiq;
+	pr_info("Root superpriority FIQ handler: %ps\n", handle_nmi_fiq);
+	return 0;
+}
+
 int __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
 {
 	if (handle_arch_irq != default_handle_irq)
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 1aa8f0f66484..b0244005e20f 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -757,6 +757,10 @@ static inline void debug_switch_state(void)
 		WARN_ONCE(daif_actual != daif_expected,
 			  "Unexpected DAIF value: 0x%lx (expected 0x%lx)\n",
 			  daif_actual, daif_expected);
+
+		if (system_uses_nmi())
+			WARN_ONCE(read_sysreg_s(SYS_ALLINT) & ALLINT_ALLINT,
+				  "Unexpected ALLINT set\n");
 	}
 }
 
-- 
2.34.1

