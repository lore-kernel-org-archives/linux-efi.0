Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADAF3B9D98;
	Fri,  3 Jul 2026 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072958; cv=none; b=THGubrlGCO7A+G+7N5bFyf/0evECL/ZNcH5nmiISETPb/VELalRGuDxizz+1pTFwcSZVO1okLw9oq+e9i+JycgHSxhxTdTiUVgZ9+PwWN4C4x5esG0yd67fTLlZbFV/CmIduSS2NboXe+moGmFcVOy2YJrNsOBzChr9LRU5kUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072958; c=relaxed/simple;
	bh=rMHYfsPIj9csZmiTJp3AzJLzHYimBrTFl9ATWh8WQNo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6eHCm0noHfDnPa3tbAU9owC4ZaZQvD/RZkri9HM2OBSciRHjzPjPJBwgzy/iR5pBzootqSNI44h/bdf7RL7021nQiOGPfCga8jVyz0Y/godsefgKD0TrgBtu5L6vbim0M/yqgg4BxNUOFsyxzme01Vi16/jyKbsaac7klx1avk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5sq/TnO4; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5sq/TnO4"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=d1sS0on0PHC89aq4LdBePidBgA9ZlZCJ5FDeW7rZmOI=;
	b=5sq/TnO4eai2Jxm8uXOzt0fWd/v5w2BSJgrbu+cuIwfcKnAS/omwHcWq8Jdj45jNjpRMl8uJ7
	lbHnWBnb6Q2NOlxzyT77UyeDDYHmFyc6LIIBxWFPkSiEE3CwCosFn4mrCa32XcpYzo4aBhqlW2m
	cnNn5zqCCDVqrLNFB8Oea5Q=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Fv0X8nz1cyNs;
	Fri,  3 Jul 2026 17:53:23 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 90D8E4058B;
	Fri,  3 Jul 2026 18:02:32 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:02:28 +0800
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
Subject: [PATCH 05/17] arm64: Introduce helpers for restoring standard exception masks
Date: Fri, 3 Jul 2026 18:01:23 +0800
Message-ID: <20260703100135.2512312-6-ruanjinjie@huawei.com>
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

Several non-entry call sites construct and restore standard exception
masks by open-coding patterns like

	local_exception_restore(arm64_make_noirq_mask());
	local_exception_restore(arm64_make_procctx_mask());
	local_exception_restore(arm64_make_errctx_mask());

These scattered calls directly manipulate DAIF and are blind to the
ongoing rework of exception mask management (DAIF + PMR + future
ALLINT).  Encapsulate each pattern into a dedicated helper:

	local_exception_restore_noirq()
	local_exception_restore_procctx()
	local_exception_restore_errctx()

This centralises the mask construction, avoids open-coding of
arch-specific mask details, and prepares for the entry-specific
exception mask framework that will manage DAIF, PMR and eventually
ALLINT in a consistent way.

Callers in ACPI, IRQ setup, SMP, KVM VHE switch and elsewhere are
converted to use the new helpers.  No functional change.

No functional change.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/exception_masks.h | 15 +++++++++++++++
 arch/arm64/kernel/acpi.c                 |  4 ++--
 arch/arm64/kernel/irq.c                  |  2 +-
 arch/arm64/kernel/setup.c                |  2 +-
 arch/arm64/kernel/smp.c                  |  2 +-
 arch/arm64/kvm/hyp/vhe/switch.c          |  2 +-
 6 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/exception_masks.h b/arch/arm64/include/asm/exception_masks.h
index 2c87f7c90f62..fbbba769ca03 100644
--- a/arch/arm64/include/asm/exception_masks.h
+++ b/arch/arm64/include/asm/exception_masks.h
@@ -196,4 +196,19 @@ static __always_inline void exception_exit_restore_mask(struct exception_mask ma
 {
 	write_sysreg(mask.daif, daif);
 }
+
+static inline void local_exception_restore_noirq(void)
+{
+	local_exception_restore(arm64_make_noirq_mask());
+}
+
+static inline void local_exception_restore_errctx(void)
+{
+	local_exception_restore(arm64_make_errctx_mask());
+}
+
+static inline void local_exception_restore_procctx(void)
+{
+	local_exception_restore(arm64_make_procctx_mask());
+}
 #endif /* __ASM_EXCEPTION_MASKS_H */
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 4d413419309d..88883d074ecd 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -407,7 +407,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 * SEA can interrupt SError, mask it and describe this as an NMI so
 	 * that APEI defers the handling.
 	 */
-	local_exception_restore(arm64_make_errctx_mask());
+	local_exception_restore_errctx();
 	nmi_enter();
 	err = ghes_notify_sea();
 	nmi_exit();
@@ -418,7 +418,7 @@ int apei_claim_sea(struct pt_regs *regs)
 	 */
 	if (!err) {
 		if (return_to_irqs_enabled) {
-			local_exception_restore(arm64_make_noirq_mask());
+			local_exception_restore_noirq();
 			__irq_enter();
 			irq_work_run();
 			__irq_exit();
diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
index 9e7fb0d22586..fff0efd5a195 100644
--- a/arch/arm64/kernel/irq.c
+++ b/arch/arm64/kernel/irq.c
@@ -130,6 +130,6 @@ void __init init_IRQ(void)
 		 * the PMR/PSR pair to a consistent state.
 		 */
 		WARN_ON(read_sysreg(daif) & PSR_A_BIT);
-		local_exception_restore(arm64_make_noirq_mask());
+		local_exception_restore_noirq();
 	}
 }
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 10507e55e2ce..bd7aa8263ebe 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -311,7 +311,7 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	 * IRQ and FIQ will be unmasked after the root irqchip has been
 	 * detected and initialized.
 	 */
-	local_exception_restore(arm64_make_noirq_mask());
+	local_exception_restore_noirq();
 
 	/*
 	 * TTBR0 is only used for the identity mapping at this stage. Make it
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index d153ff77d25c..a94ebb1bb6d7 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -263,7 +263,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	 * as the root irqchip has already been detected and initialized we can
 	 * unmask IRQ and FIQ at the same time.
 	 */
-	local_exception_restore(arm64_make_procctx_mask());
+	local_exception_restore_procctx();
 
 	/*
 	 * OK, it's off to the idle thread for us
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 024876efe0c3..d11fb05e558b 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -650,7 +650,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * local_exception_restore() takes care to properly restore PSTATE.DAIF
 	 * and the GIC PMR if the host is using IRQ priorities.
 	 */
-	local_exception_restore(arm64_make_noirq_mask());
+	local_exception_restore_noirq();
 
 	return ret;
 }
-- 
2.34.1

