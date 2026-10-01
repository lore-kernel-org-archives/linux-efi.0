Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3750C4F93D3;
	Thu,  1 Oct 2026 11:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852858; cv=none; b=YmfpM9GYGFgoLJQ1N1iFbRZ60QOoH8oC83kbPKgGktvEeOfrutg34H0Dy18rMB031vIjlACEGJfGwPC0BfI6LAxNfuMThHv0I+i03ZhOmdo7m4a78vjElUD9hCa9FibrzPxqcEs8WbhGcns+vsqRFM7TqizioqKRTOAVhTEi68M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852858; c=relaxed/simple;
	bh=UbIPR6km+z9guG/gpw6scqoID4LPZbSYgiGtQevb+aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VI4VFK6PNs6MCNzd0lTfEX3ElQFseibjYUZU252fhLe0d2deObCowB9RNBkgenmSiuWpBva1PyFFQCXTitu1PqM8pZczvmIMQ2Z5NdIdeFVWIQPm4VH3EPUENZtazIlnVlp6YP/lzZ2bwrB9QcXvku4BU4qnaKuQoCZxR+dg0BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RUPa9LhF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RUPa9LhF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39D0B497;
	Thu,  1 Oct 2026 04:07:32 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 115E13F86F;
	Thu,  1 Oct 2026 04:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852855; bh=UbIPR6km+z9guG/gpw6scqoID4LPZbSYgiGtQevb+aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUPa9LhF2LGk8bbNmsU3rG9P9L7EGBHDn47bgAreAVEPiH26CVoHWicniXKvOfQNR
	 6dCQGwjcCdgPcfOeiMJXGaWjHiGrPIq7jQ6g8GSVyVQPGjQ9a+QzH+83xJC4FxpBVO
	 M/tPy/+1Y8amTuPb0C0FyH22p5PkX0r/IMzQN0Mk=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [RFC 02/12] arm64: Detect FEAT_TLBID
Date: Thu,  1 Oct 2026 12:06:45 +0100
Message-ID: <20261001110655.461473-3-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001110655.461473-1-kristina.martsenko@arm.com>
References: <20261001110655.461473-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Detect if FEAT_TLBID is supported by the system. Detect TLBID
configuration from TLBIDIDR_EL1. This information will be used in later
patches.

Set HFGRTR2_EL2.nTLBIDIDR_EL1 so that the kernel can access TLBIDIDR_EL1
at EL1 (in case of nVHE/hVHE).

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/cpu.h        |  1 +
 arch/arm64/include/asm/cpufeature.h |  7 +++++++
 arch/arm64/include/asm/el2_setup.h  |  9 ++++++++-
 arch/arm64/kernel/cpufeature.c      | 25 +++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  3 +++
 arch/arm64/tools/cpucaps            |  1 +
 6 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 3c008821219c..967ccdedf526 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -48,6 +48,7 @@ struct cpuinfo_arm64 {
 	u64		reg_gmid;
 	u64		reg_smidr;
 	u64		reg_mpamidr;
+	u64		reg_tlbididr;
 
 	u64		reg_id_aa64dfr0;
 	u64		reg_id_aa64dfr1;
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 4f04ad82ea34..d4e7497143b2 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -627,6 +627,13 @@ static inline bool id_aa64pfr1_mpamfrac(u64 pfr1)
 	return val > 0;
 }
 
+static inline bool id_aa64mmfr4_tlbid(u64 mmfr4)
+{
+	u32 val = cpuid_feature_extract_unsigned_field(mmfr4, ID_AA64MMFR4_EL1_TLBID_SHIFT);
+
+	return val > 0;
+}
+
 void __init setup_boot_cpu_features(void);
 void __init setup_system_features(void);
 void __init setup_user_features(void);
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index aa8ec9df8024..bd70a470596c 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -438,9 +438,16 @@
 	orr	x0, x0, #HDFGRTR2_EL2_nPMSDSFR_EL1
 
 .Lskip_spefds_\@:
+	mov	x1, xzr
+	mrs_s	x2, SYS_ID_AA64MMFR4_EL1
+	ubfx	x2, x2, #ID_AA64MMFR4_EL1_TLBID_SHIFT, #ID_AA64MMFR4_EL1_TLBID_WIDTH
+	cbz	x2, .Lskip_tlbid_\@
+	orr	x1, x1, #HFGRTR2_EL2_nTLBIDIDR_EL1
+
+.Lskip_tlbid_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x0
-	msr_s   SYS_HFGRTR2_EL2, xzr
+	msr_s   SYS_HFGRTR2_EL2, x1
 	msr_s   SYS_HFGWTR2_EL2, xzr
 	msr_s   SYS_HFGITR2_EL2, xzr
 .Lskip_fgt2_\@:
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32102c3912fa..39a30226ccca 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -521,6 +521,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_TLBID_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
 	ARM64_FTR_END,
@@ -740,6 +741,14 @@ static const struct arm64_ftr_bits ftr_mpamidr[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_tlbididr[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NVOS_SHIFT, TLBIDIDR_EL1_NVOS_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NOS_SHIFT, TLBIDIDR_EL1_NOS_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NVIS_SHIFT, TLBIDIDR_EL1_NVIS_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NIS_SHIFT, TLBIDIDR_EL1_NIS_WIDTH, 0),
+	ARM64_FTR_END,
+};
+
 /*
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
@@ -864,6 +873,7 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 10, CRm = 4 */
 	ARM64_FTR_REG(SYS_MPAMIDR_EL1, ftr_mpamidr),
+	ARM64_FTR_REG(SYS_TLBIDIDR_EL1, ftr_tlbididr),
 
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
@@ -1259,6 +1269,9 @@ void __init init_cpu_features(struct cpuinfo_arm64 *info)
 
 	if (gmid_el1_accessible(info))
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
+
+	if (id_aa64mmfr4_tlbid(info->reg_id_aa64mmfr4))
+		init_cpu_ftr_reg(SYS_TLBIDIDR_EL1, info->reg_tlbididr);
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -1523,6 +1536,11 @@ void update_cpu_features(int cpu,
 		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
 					      info->reg_gmid, boot->reg_gmid);
 
+	if (id_aa64mmfr4_tlbid(info->reg_id_aa64mmfr4)) {
+		taint |= check_update_ftr_reg(SYS_TLBIDIDR_EL1, cpu,
+					info->reg_tlbididr, boot->reg_tlbididr);
+	}
+
 	/*
 	 * If we don't have AArch32 at all then skip the checks entirely
 	 * as the register values may be UNKNOWN and we're not going to be
@@ -3234,6 +3252,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
 	},
 #endif
+	{
+		.desc = "TLBI domains (TLBID)",
+		.capability = ARM64_HAS_TLBID,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, TLBID, IMP)
+	},
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 45c63f3d75c5..2d4fc664231c 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -524,6 +524,9 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 		info->reg_smidr = read_cpuid(SMIDR_EL1) & ~SMIDR_EL1_SMPS;
 	}
 
+	if (id_aa64mmfr4_tlbid(info->reg_id_aa64mmfr4))
+		info->reg_tlbididr = read_cpuid(TLBIDIDR_EL1);
+
 	cpuinfo_detect_icache_policy(info);
 }
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 2775ba3359cf..d9ed599dee70 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -67,6 +67,7 @@ HAS_STAGE2_FWB
 HAS_TCR2
 HAS_TIDCP1
 HAS_TLB_RANGE
+HAS_TLBID
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
-- 
2.43.0

