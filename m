Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849BA3C0A03;
	Fri,  3 Jul 2026 10:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783072974; cv=none; b=U+3y5lJ0BvmkUL5pUmbRl0bvDeUxcn3eFI4wURc6Z0FRqmaVjIPolzdG2J+F+oUv3u+U67TpjW6KacQPoFz417nziJb+oz4kx+TQS4YAGApcB0C7yXaonWw6K8aE/fIRfLHKaW1lLoy0f1f+F5Wx+KvS1dQrH2CiiypeSooC9js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783072974; c=relaxed/simple;
	bh=6sd+agQ8mrxK32cq+c9kUO4CXSMAsRC2METI7ZBGJ6Y=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PnOyscB/cwaPeKEcKNppWORjtet6/kmNFseLLG39ox2xQJE+Q3kIcBu72IiogFjRLOTwbCNZs5Yvp1g/1EZisyFQ3y02iMGE9cKQKeCW0NgqUQ8ZpxgNIzPIAmg2oUPijB/dGmoHyRaMRO2r+SDnjfvo0dQcBXVIA8YNdOPDXQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=q+rYde3U; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="q+rYde3U"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=K+6PdQrpgzvN+lRuw1F7TouGPdwrwwmoNjOY6YqvGsw=;
	b=q+rYde3Uc1d/Wf9GyiuMeKiws9lwu3OH+oB/I23w0GVivmWavntYclJKTuWXk6DRwhyyc4P1C
	5PSo4W5mXhK6Rdypq4Eg+EeuC4LWQ5RhnI3LG6tg9HSV1ScO7YUtlL6bW2SCzciKv2C+hZSEDql
	SkiXzQ/QJD71FhVAcsnOsZs=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gs8Gz0km1zpSts;
	Fri,  3 Jul 2026 17:54:19 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 821C74058F;
	Fri,  3 Jul 2026 18:02:50 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Jul
 2026 18:02:46 +0800
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
Subject: [PATCH 10/17] arm64/cpufeature: Detect PE support for FEAT_NMI
Date: Fri, 3 Jul 2026 18:01:28 +0800
Message-ID: <20260703100135.2512312-11-ruanjinjie@huawei.com>
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

Use of FEAT_NMI requires that all the PEs in the system and the GIC
have NMI support. This patch implements the PE part of that detection.

In order to avoid problematic interactions between real and pseudo NMIs
we disable the architected feature if the user has enabled pseudo NMIs
on the command line. If this is done on a system where support for the
architected feature is detected then a warning is printed during boot in
order to help users spot what is likely to be a misconfiguration.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221112151708.175147-9-broonie@kernel.org
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 +++
 arch/arm64/kernel/cpufeature.c      | 58 ++++++++++++++++++++++++++++-
 arch/arm64/tools/cpucaps            |  2 +
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index a57870fa96db..8ce12c21e223 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -816,6 +816,11 @@ static __always_inline bool system_uses_irq_prio_masking(void)
 	return alternative_has_cap_unlikely(ARM64_HAS_GIC_PRIO_MASKING);
 }
 
+static __always_inline bool system_uses_nmi(void)
+{
+	return alternative_has_cap_unlikely(ARM64_USES_NMI);
+}
+
 static inline bool system_supports_mte(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MTE);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9a22df0c5120..33d7cb43269f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -89,6 +89,7 @@
 #include <asm/mmu_context.h>
 #include <asm/mpam.h>
 #include <asm/mte.h>
+#include <asm/nmi.h>
 #include <asm/hypervisor.h>
 #include <asm/processor.h>
 #include <asm/smp.h>
@@ -315,6 +316,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_GCS),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_GCS_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MTE_frac_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_NMI_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_SME),
 		       FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_SME_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR1_EL1_MPAM_frac_SHIFT, 4, 0),
@@ -1137,9 +1139,11 @@ static void init_32bit_cpu_features(struct cpuinfo_32bit *info)
 	init_cpu_ftr_reg(SYS_MVFR2_EL1, info->reg_mvfr2);
 }
 
-#ifdef CONFIG_ARM64_PSEUDO_NMI
+#if IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) || IS_ENABLED(CONFIG_ARM64_NMI)
 static bool enable_pseudo_nmi;
+#endif
 
+#ifdef CONFIG_ARM64_PSEUDO_NMI
 static int __init early_enable_pseudo_nmi(char *p)
 {
 	return kstrtobool(p, &enable_pseudo_nmi);
@@ -2320,6 +2324,41 @@ static bool has_gic_prio_relaxed_sync(const struct arm64_cpu_capabilities *entry
 }
 #endif
 
+#ifdef CONFIG_ARM64_NMI
+static bool use_nmi(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	if (!has_cpuid_feature(entry, scope))
+		return false;
+
+	/*
+	 * Having both real and pseudo NMIs enabled simultaneously is
+	 * likely to cause confusion.  Since pseudo NMIs must be
+	 * enabled with an explicit command line option, if the user
+	 * has set that option on a system with real NMIs for some
+	 * reason assume they know what they're doing.
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_PSEUDO_NMI) && enable_pseudo_nmi) {
+		pr_info_once("Pseudo NMI enabled, not using architected NMI\n");
+		return false;
+	}
+
+	return true;
+}
+
+static void nmi_enable(const struct arm64_cpu_capabilities *__unused)
+{
+	/*
+	 * Enable use of NMIs controlled by ALLINT, SPINTMASK should
+	 * be clear by default but make it explicit that we are using
+	 * this mode.  Ensure that ALLINT is clear first in order to
+	 * avoid leaving things masked.
+	 */
+	_allint_clear();
+	sysreg_clear_set(sctlr_el1, SCTLR_EL1_SPINTMASK, SCTLR_EL1_NMI);
+	isb();
+}
+#endif
+
 static bool can_trap_icv_dir_el1(const struct arm64_cpu_capabilities *entry,
 				 int scope)
 {
@@ -3198,6 +3237,23 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
 	},
+#endif
+#ifdef CONFIG_ARM64_NMI
+	{
+		.desc = "Non-maskable Interrupts present",
+		.capability = ARM64_HAS_NMI,
+		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, NMI, IMP)
+	},
+	{
+		.desc = "Non-maskable Interrupts enabled",
+		.capability = ARM64_USES_NMI,
+		.type = ARM64_CPUCAP_BOOT_CPU_FEATURE,
+		.matches = use_nmi,
+		.cpu_enable = nmi_enable,
+		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, NMI, IMP)
+	},
 #endif
 	{},
 };
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 9b85a84f6fd4..676d00b5fd14 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -51,6 +51,7 @@ HAS_LS64_V
 HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
+HAS_NMI
 HAS_BBML2_NOABORT
 HAS_PAN
 HAS_PMUV3
@@ -90,6 +91,7 @@ SPECTRE_BHB
 SSBS
 SVE
 UNMAP_KERNEL_AT_EL0
+USES_NMI
 WORKAROUND_834220
 WORKAROUND_843419
 WORKAROUND_845719
-- 
2.34.1

