Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CABC150E594;
	Thu,  1 Oct 2026 11:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852862; cv=none; b=rDNdAocILK431+r8FPV2LOSu186Yg6rHuyAbY3hirfAgjMhFjLgeZZoy8WMmfGSmhvOjJM/sZPmf/iYnfIxckviXzQBnbqaBG47HQobvAs7CdGUWoTpDiPmulXUSQr6h0Lvlw/zKWtdXT2dD77MlqieCaKSIYzTkG+IDceJ16WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852862; c=relaxed/simple;
	bh=yEcODPs/JVj3qaCyrYR+sHXqC9guLfgCT9uj2ITLQnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p5fiElpWrQhJj7QNW0RebGoUhxqtO9Eib7PDZAMpVDRJKSr6jQL3UDIfOJqdQ72KFT1T5mBYjGkbdnfpwjbmE/M7M7GD3J05zcMjuZgd1liSm8OIztEqSxcdXYj2UrkuEJs2TsuMJarEHqXl9soUmCGr9o6TBSOsjqlPjlqeO0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Dks2nePA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Dks2nePA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C5D14497;
	Thu,  1 Oct 2026 04:07:36 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 99E363F86F;
	Thu,  1 Oct 2026 04:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852860; bh=yEcODPs/JVj3qaCyrYR+sHXqC9guLfgCT9uj2ITLQnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dks2nePANzHkekdku+n19iz6SUU3FyX3QoOa9eWYO37E1ifmlHoBJmtIGeeuryI8Q
	 M6P4sqZ6isQCkGFOoEnjjKGfbThYgWa1dH7sn4NdmWRc/JLSvxLReo2jjU27dWhQiQ
	 XNZNO2Al0g9zJdRWZlK4szU3Dn4kp6rn2HiY10/Q=
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
Subject: [RFC 03/12] KVM: arm64: Hide TLBID from guest sysregs
Date: Thu,  1 Oct 2026 12:06:46 +0100
Message-ID: <20261001110655.461473-4-kristina.martsenko@arm.com>
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

Don't expose FEAT_TLBID to guests. It wouldn't be useful in the general
case since a guest doesn't know which domains exist and its vCPUs can be
moved between any physical CPUs.

Try to hide TLBID sysregs and sysreg fields from the guest:

  * Report the feature as not supported in the ID register
    ID_AA64MMFR4_EL1.TLBID.

  * Configure the TLBIDIDR_EL1 sysreg to UNDEF via the FGU mechanism.
    Sanitize a nested hypervisor's HFGRTR2.nTLBIDIDR.

  * Sanitize a nested hypervisor's HCRX.{VTLBIDEn,VTLBIDOSEn,FNB}.

  * VTLBID{OS}<n>_EL2 registers are VNCR-backed and not exposed to
    guests (apart from being able to read/write into the VNCR page) so
    no need to handle them in sys_reg_descs or elsewhere.

  * The guest is free to set SCTLR2_EL{1,2}.TLBOSNIS, which shouldn't
    matter to KVM.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/kvm/config.c         | 6 ++++++
 arch/arm64/kvm/emulate-nested.c | 1 +
 arch/arm64/kvm/sys_regs.c       | 3 +++
 3 files changed, 10 insertions(+)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 1053676551af..6c116aa1864a 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -226,6 +226,7 @@ struct reg_feat_map_desc {
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
 #define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
 #define FEAT_NV3		ID_AA64MMFR4_EL1, NV_frac, NV3
+#define FEAT_TLBID		ID_AA64MMFR4_EL1, TLBID, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -813,6 +814,7 @@ static const struct reg_bits_to_feat_map hfgrtr2_feat_map[] = {
 		   HFGRTR2_EL2_nTCRMASK_EL1,
 		   FEAT_SRMASK),
 	NEEDS_FEAT(HFGRTR2_EL2_nRCWSMASK_EL1, FEAT_THE),
+	NEEDS_FEAT(HFGRTR2_EL2_nTLBIDIDR_EL1, FEAT_TLBID),
 };
 
 static const DECLARE_FEAT_MAP_FGT(hfgrtr2_desc, hfgrtr2_masks,
@@ -911,6 +913,10 @@ static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
 		   HCRX_EL2_NVnTTLBOS,
 		   FEAT_NV3),
 	NEEDS_FEAT(HCRX_EL2_SRMASKEn, FEAT_SRMASK),
+	NEEDS_FEAT(HCRX_EL2_FNB			|
+		   HCRX_EL2_VTLBIDOSEn		|
+		   HCRX_EL2_VTLBIDEn,
+		   FEAT_TLBID),
 	NEEDS_FEAT(HCRX_EL2_PACMEn, feat_pauth_lr),
 	NEEDS_FEAT(HCRX_EL2_EnFPM, FEAT_FPMR),
 	NEEDS_FEAT(HCRX_EL2_GCSEn, FEAT_GCS),
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 625604019fb3..cd8ad03028e7 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -1440,6 +1440,7 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_TCRALIAS_EL1,	HFGRTR2, nTCRALIAS_EL1, 0),
 	SR_FGT(SYS_TCRMASK_EL1,		HFGRTR2, nTCRMASK_EL1, 0),
 	SR_FGT(SYS_ERXGSR_EL1,		HFGRTR2, nERXGSR_EL1, 0),
+	SR_FGT(SYS_TLBIDIDR_EL1,	HFGRTR2, nTLBIDIDR_EL1, 0),
 
 	/* HFGITR_EL2 */
 	SR_FGT(OP_AT_S1E1A, 		HFGITR, ATS1E1A, 1),
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..6a025e1f3161 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1984,6 +1984,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 		if (!system_supports_poe())
 			val &= ~ID_AA64MMFR3_EL1_S1POE;
 		break;
+	case SYS_ID_AA64MMFR4_EL1:
+		val &= ~ID_AA64MMFR4_EL1_TLBID;
+		break;
 	case SYS_ID_MMFR4_EL1:
 		val &= ~ID_MMFR4_EL1_CCIDX;
 		break;
-- 
2.43.0

