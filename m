Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8D73CDBB5;
	Fri,  3 Jul 2026 10:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783073000; cv=none; b=uQ/VvJvM6YGjVqW0YjR4hJIrAQl/7Hqu/a0Cz1AxSsZ6D4pTNobn08dIoDCXq/dRgR3ku1p8xUUar5UQrZKDCjCo1QOlO7YXqKJaCHavxNGWSVAkaDbwE6z5DIFcn5Dc0Ft5JP3ETmntKLcCexig+oP0rhxhpss0i3q0E/KEpgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783073000; c=relaxed/simple;
	bh=uKPsADKklpc8guf1d07ocGLEVVDJP0kxF8aZbTVIJMI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIAy0qTOwvIIQ8ZqbpVh2OPmLFEPcQPWtB7PyI+idKoicMGrEJ0wLUBLdkDBolUD+poFvQuuD8M3qrirkhLDAfSgHvRP3P71Z65s49iw4sYdYmKIaCiZFGN4e7oO3/gLjsYLg60cu9JVqmbqAXmL1ETZGfPULggXx6FF7Kf2E/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5GcGL8cl; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5GcGL8cl"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3zaQxjemlKke1E3qtuPww5rLwpZ1TlYlWST3KzQylNU=;
	b=5GcGL8clukjyJHO6AhPgM4vjwfdMNTturIVC8/Y5wYKx7VfbR8ruFmY0Oz20gwFpIqWUIVkRP
	Ce/CSZaVciFCcfFvt0UeMDozwcHEVVXmrimaAgpO3FhwDJI1EqwsjHE+fIdAgVeNZaPA7PtKtwH
	xE/fNk7ET1s2CkWq3yWGoSk=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Gh3W0HzmV6V;
	Fri,  3 Jul 2026 17:54:04 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 9A00C40572;
	Fri,  3 Jul 2026 18:03:15 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:03:11 +0800
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
Subject: [PATCH 17/17] irqchip/gic-v3: Implement FEAT_GICv3_NMI support
Date: Fri, 3 Jul 2026 18:01:35 +0800
Message-ID: <20260703100135.2512312-18-ruanjinjie@huawei.com>
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

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

The FEAT_GICv3_NMI GIC feature coupled with the CPU FEAT_NMI enables
handling NMI interrupts in HW on aarch64, by adding a superpriority
interrupt to the existing GIC priority scheme.

Implement GIC driver support for the FEAT_GICv3_NMI feature.

Rename gic_supports_nmi() helper function to gic_supports_pseudo_nmis()
to make the pseudo NMIs code path clearer and more explicit.

Check, through the ARM64 capabilitity infrastructure, if support
for FEAT_NMI was detected on the core and the system has not overridden
the detection and forced pseudo-NMIs enablement.

If FEAT_NMI is detected, it was not overridden (check embedded in the
system_uses_nmi() call) and the GIC supports the FEAT_GICv3_NMI feature,
install an NMI handler and initialize NMIs related HW GIC registers.

Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221112151708.175147-15-broonie@kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 drivers/irqchip/irq-gic-v3.c       | 146 ++++++++++++++++++++++++++---
 include/linux/irqchip/arm-gic-v3.h |   4 +
 2 files changed, 138 insertions(+), 12 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 111cd882c7a9..6e48dd999021 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -64,6 +64,7 @@ struct gic_chip_data {
 	u32			nr_redist_regions;
 	u64			flags;
 	bool			has_rss;
+	bool			has_nmi;
 	unsigned int		ppi_nr;
 	struct partition_affinity *parts;
 	unsigned int		nr_parts;
@@ -252,6 +253,20 @@ enum gic_intid_range {
 	__INVALID_RANGE__
 };
 
+#ifdef CONFIG_ARM64
+#include <linux/cpufeature.h>
+
+static inline bool has_v3_3_nmi(void)
+{
+	return gic_data.has_nmi && system_uses_nmi();
+}
+#else
+static inline bool has_v3_3_nmi(void)
+{
+	return false;
+}
+#endif
+
 static enum gic_intid_range __get_intid_range(irq_hw_number_t hwirq)
 {
 	switch (hwirq) {
@@ -467,6 +482,42 @@ static int gic_peek_irq(struct irq_data *d, u32 offset)
 	return !!(readl_relaxed(base + offset + (index / 32) * 4) & mask);
 }
 
+static DEFINE_RAW_SPINLOCK(irq_controller_lock);
+
+static void gic_irq_configure_nmi(struct irq_data *d, bool enable)
+{
+	void __iomem *base, *addr;
+	u32 offset, index, mask, val;
+
+	offset = convert_offset_index(d, GICD_INMIR, &index);
+	mask = 1 << (index % 32);
+
+	if (gic_irq_in_rdist(d))
+		base = gic_data_rdist_sgi_base();
+	else
+		base = gic_data.dist_base;
+
+	addr = base + offset + (index / 32) * 4;
+
+	raw_spin_lock(&irq_controller_lock);
+
+	val = readl_relaxed(addr);
+	val = enable ? (val | mask) : (val & ~mask);
+	writel_relaxed(val, addr);
+
+	raw_spin_unlock(&irq_controller_lock);
+}
+
+static void gic_irq_enable_nmi(struct irq_data *d)
+{
+	gic_irq_configure_nmi(d, true);
+}
+
+static void gic_irq_disable_nmi(struct irq_data *d)
+{
+	gic_irq_configure_nmi(d, false);
+}
+
 static void gic_poke_irq(struct irq_data *d, u32 offset)
 {
 	void __iomem *base;
@@ -512,7 +563,7 @@ static void gic_unmask_irq(struct irq_data *d)
 	gic_poke_irq(d, GICD_ISENABLER);
 }
 
-static inline bool gic_supports_nmi(void)
+static inline bool gic_supports_pseudo_nmis(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) &&
 	       static_branch_likely(&supports_pseudo_nmis);
@@ -598,7 +649,7 @@ static int gic_irq_nmi_setup(struct irq_data *d)
 {
 	struct irq_desc *desc = irq_to_desc(d->irq);
 
-	if (!gic_supports_nmi())
+	if (!gic_supports_pseudo_nmis() && !has_v3_3_nmi())
 		return -EINVAL;
 
 	if (gic_peek_irq(d, GICD_ISENABLER)) {
@@ -617,7 +668,10 @@ static int gic_irq_nmi_setup(struct irq_data *d)
 	if (!gic_irq_in_rdist(d))
 		desc->handle_irq = handle_fasteoi_nmi;
 
-	gic_irq_set_prio(d, dist_prio_nmi);
+	if (has_v3_3_nmi())
+		gic_irq_enable_nmi(d);
+	else
+		gic_irq_set_prio(d, dist_prio_nmi);
 
 	return 0;
 }
@@ -626,7 +680,7 @@ static void gic_irq_nmi_teardown(struct irq_data *d)
 {
 	struct irq_desc *desc = irq_to_desc(d->irq);
 
-	if (WARN_ON(!gic_supports_nmi()))
+	if (WARN_ON(!gic_supports_pseudo_nmis() && !has_v3_3_nmi()))
 		return;
 
 	if (gic_peek_irq(d, GICD_ISENABLER)) {
@@ -645,7 +699,10 @@ static void gic_irq_nmi_teardown(struct irq_data *d)
 	if (!gic_irq_in_rdist(d))
 		desc->handle_irq = handle_fasteoi_irq;
 
-	gic_irq_set_prio(d, dist_prio_irq);
+	if (has_v3_3_nmi())
+		gic_irq_disable_nmi(d);
+	else
+		gic_irq_set_prio(d, dist_prio_irq);
 }
 
 static bool gic_arm64_erratum_2941627_needed(struct irq_data *d)
@@ -804,7 +861,7 @@ static inline void gic_complete_ack(u32 irqnr)
 
 static bool gic_rpr_is_nmi_prio(void)
 {
-	if (!gic_supports_nmi())
+	if (!gic_supports_pseudo_nmis())
 		return false;
 
 	return unlikely(gic_read_rpr() == GICV3_PRIO_NMI);
@@ -836,7 +893,8 @@ static void __gic_handle_nmi(u32 irqnr, struct pt_regs *regs)
 	gic_complete_ack(irqnr);
 
 	if (generic_handle_domain_nmi(gic_data.domain, irqnr)) {
-		WARN_ONCE(true, "Unexpected pseudo-NMI (irqnr %u)\n", irqnr);
+		WARN_ONCE(true, "Unexpected %sNMI (irqnr %u)\n",
+			  gic_supports_pseudo_nmis() ? "pseudo-" : "", irqnr);
 		gic_deactivate_unhandled(irqnr);
 	}
 }
@@ -857,6 +915,28 @@ static void __gic_handle_irq_from_irqson(struct pt_regs *regs)
 	bool is_nmi;
 	u32 irqnr;
 
+	/*
+	 * We should enter here with interrupts disabled, otherwise we may met
+	 * a race here with FEAT_NMI/FEAT_GICv3_NMI:
+	 *
+	 * [interrupt disabled]
+	 *                   <- normal interrupt pending, for example timer interrupt
+	 *                   <- NMI occurs, ISR_EL1.nmi = 1
+	 * do_el1_interrupt()
+	 *                   <- NMI withdraw, ISR_EL1.nmi = 0
+	 *   ISR_EL1.nmi = 0, not an NMI interrupt
+	 *   gic_handle_irq()
+	 *     __gic_handle_irq_from_irqson()
+	 *       irqnr = gic_read_iar() <- Oops, ack and handle an normal interrupt
+	 *                                 in interrupt disabled context!
+	 *
+	 * So if we met this case here, just return from the interrupt context.
+	 * Since the interrupt is still pending, we can handle it once the
+	 * interrupt re-enabled and it'll not be missing.
+	 */
+	if (!interrupts_enabled(regs))
+		return;
+
 	irqnr = gic_read_iar();
 
 	is_nmi = gic_rpr_is_nmi_prio();
@@ -912,9 +992,37 @@ static void __gic_handle_irq_from_irqsoff(struct pt_regs *regs)
 	__gic_handle_nmi(irqnr, regs);
 }
 
+#ifdef CONFIG_ARM64
+static inline u64 gic_read_nmiar(void)
+{
+	u64 irqstat;
+
+	irqstat = read_sysreg_s(SYS_ICC_NMIAR1_EL1);
+
+	dsb(sy);
+
+	return irqstat;
+}
+
+static asmlinkage void __exception_irq_entry gic_handle_nmi_irq(struct pt_regs *regs)
+{
+	u32 irqnr = gic_read_nmiar();
+
+	__gic_handle_nmi(irqnr, regs);
+}
+
+static inline void gic_setup_nmi_handler(void)
+{
+	if (has_v3_3_nmi())
+		set_handle_nmi_irq(gic_handle_nmi_irq);
+}
+#else
+static inline void gic_setup_nmi_handler(void) { }
+#endif
+
 static void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
-	if (unlikely(gic_supports_nmi() && !interrupts_enabled(regs)))
+	if (unlikely(gic_supports_pseudo_nmis() && !interrupts_enabled(regs)))
 		__gic_handle_irq_from_irqsoff(regs);
 	else
 		__gic_handle_irq_from_irqson(regs);
@@ -1165,7 +1273,7 @@ static void gic_cpu_sys_reg_init(void)
 	/* Set priority mask register */
 	if (!gic_prio_masking_enabled()) {
 		write_gicreg(DEFAULT_PMR_VALUE, ICC_PMR_EL1);
-	} else if (gic_supports_nmi()) {
+	} else if (gic_supports_pseudo_nmis()) {
 		/*
 		 * Check that all CPUs use the same priority space.
 		 *
@@ -1958,15 +2066,27 @@ static const struct gic_quirk gic_quirks[] = {
 	}
 };
 
-static void gic_enable_nmi_support(void)
+static void gic_enable_pseudo_nmis(void)
 {
-	if (!gic_prio_masking_enabled() || nmi_support_forbidden)
-		return;
 
 	pr_info("Pseudo-NMIs enabled using %s ICC_PMR_EL1 synchronisation\n",
 		gic_has_relaxed_pmr_sync() ? "relaxed" : "forced");
 
 	static_branch_enable(&supports_pseudo_nmis);
+}
+
+static void gic_enable_nmi_support(void)
+{
+	if ((!gic_prio_masking_enabled() || nmi_support_forbidden) &&
+	     !has_v3_3_nmi())
+		return;
+
+	/*
+	 * Initialize pseudo-NMIs only if GIC driver cannot take advantage
+	 * of core (FEAT_NMI) and GIC (FEAT_GICv3_NMI) in HW
+	 */
+	if (!has_v3_3_nmi())
+		gic_enable_pseudo_nmis();
 
 	if (static_branch_likely(&supports_deactivate_key))
 		gic_eoimode1_chip.flags |= IRQCHIP_SUPPORTS_NMI;
@@ -2035,6 +2155,7 @@ static int __init gic_init_bases(phys_addr_t dist_phys_base,
 	irq_domain_update_bus_token(gic_data.domain, DOMAIN_BUS_WIRED);
 
 	gic_data.has_rss = !!(typer & GICD_TYPER_RSS);
+	gic_data.has_nmi = !!(typer & GICD_TYPER_NMI);
 
 	if (typer & GICD_TYPER_MBIS) {
 		err = mbi_init(handle, gic_data.domain);
@@ -2043,6 +2164,7 @@ static int __init gic_init_bases(phys_addr_t dist_phys_base,
 	}
 
 	set_handle_irq(gic_handle_irq);
+	gic_setup_nmi_handler();
 
 	gic_update_rdist_properties();
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index ea5fd2374ebe..ebccd76cadda 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -30,6 +30,7 @@
 #define GICD_ICFGR			0x0C00
 #define GICD_IGRPMODR			0x0D00
 #define GICD_NSACR			0x0E00
+#define GICD_INMIR			0x0F80
 #define GICD_IGROUPRnE			0x1000
 #define GICD_ISENABLERnE		0x1200
 #define GICD_ICENABLERnE		0x1400
@@ -39,6 +40,7 @@
 #define GICD_ICACTIVERnE		0x1C00
 #define GICD_IPRIORITYRnE		0x2000
 #define GICD_ICFGRnE			0x3000
+#define GICD_INMIRnE			0x3B00
 #define GICD_IROUTER			0x6000
 #define GICD_IROUTERnE			0x8000
 #define GICD_IDREGS			0xFFD0
@@ -83,6 +85,7 @@
 #define GICD_TYPER_LPIS			(1U << 17)
 #define GICD_TYPER_MBIS			(1U << 16)
 #define GICD_TYPER_ESPI			(1U << 8)
+#define GICD_TYPER_NMI			(1U << 9)
 
 #define GICD_TYPER_ID_BITS(typer)	((((typer) >> 19) & 0x1f) + 1)
 #define GICD_TYPER_NUM_LPIS(typer)	((((typer) >> 11) & 0x1f) + 1)
@@ -238,6 +241,7 @@
 #define GICR_ICFGR0			GICD_ICFGR
 #define GICR_IGRPMODR0			GICD_IGRPMODR
 #define GICR_NSACR			GICD_NSACR
+#define GICR_INMIR0			GICD_INMIR
 
 #define GICR_TYPER_PLPIS		(1U << 0)
 #define GICR_TYPER_VLPIS		(1U << 1)
-- 
2.34.1

