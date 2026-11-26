Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693824;
	b=ZhZ0GKPOZYlSzGBFpwfmbNJrSIktQE9E4czNjpylKJIdkWMfr0Kl31yqbHCRwQsgUMIU
	 PDx9OFznlKQlCp6A+zpZ7xwyZLJZFfTOVNMaKrbMUUvnESeTSt9WBGnFLaZeD+5V73lj8
	 NCV2rY4ABv3mQ68tvEtIltyV6gaSzaU9dS2kNfmXVEfC86kTls29MAmiX2u+CA81Az6FT
	 hCE+eQuJt+AoHKZchX6Thvqe6sdiBu5GI/JYo4uV1sccqxEWFGyvKO87VATTfcpLSHCGM
	 naFolLAj0fXGzjg6g5aXxmBThlLOX51D1spVLwZqOHZiekT5cXTNqg3BMsNZiIbYNQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693824;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=J8WNoKEc0VuFKBNFw4+mR3YcdoFeytD04JpUsxYo3ks=;
	b=VJkyaok7gkuaeUMRdWj+kwBBZfN7XaL50bC5WUBIcLj0c5PNWo+UFO7/8twJMgEB4NZa
	 Sq33YbSdpdMbOKIoho6nsqdMk2Jq5m6DwFg03HvK3B8Q/Ase+W+BIialGsAd/sgBmJOBr
	 uQPXCgmWb6uget+VaRU9GyLe9MObYZJC1vLUM/MZmwXLGZE+uH+sT+N/rpJzbadZrk2Hi
	 fNP/dJAefm3FVyCU2wWj1j1aE2wP1mMzlu+xeKF1PmQktyF6n67hZcDAu9UYuFqO1MpYe
	 Qq4F5tiaelNId941Wmw+5hIX/oYfWgeaGj2jXKP/UNIwGviKqZ1+/F+GaSyC3vgXtoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hetP50fs;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1A6A606A31C;
	Thu, 26 Nov 2026 11:50:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1A6A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=hetP50fs
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5EE161CE2;
	Thu, 26 Nov 2026 03:50:19 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA6D73F632;
	Thu, 26 Nov 2026 03:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693822; bh=yFkYatB5WJrK/LmKtOX2lr33tMmU0w63R59hWonTW+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hetP50fsgqAmjdFPviqlduTjbgI+oEwKjOUz/S7jEV+l3va+oYYue9zXTrBRzs0Ng
	 QUJ9QQz++TwVxZXyYShIAy2/H0HmPCvlmOn6CFhpf//np6XG9u+KIBs8VzEwOhID9Z
	 wtAYetpQL3sSbZR/jKEEphDwfPmULweuBig3E9Mk=
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 04/13] KVM: arm64: Hide TLBID from guest sysregs
Date: Thu, 26 Nov 2026 11:49:27 +0000
Message-ID: <20261126114936.864256-5-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126114936.864256-1-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Don't expose FEAT_TLBID to guests. It wouldn't be useful in the general
case since a guest doesn't know which domains exist and its vCPUs can be
moved between any physical CPUs.

Hide TLBID sysregs and sysreg fields from the guest:

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
index adaf26ab93b8..d93bc0715494 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -243,6 +243,7 @@ struct reg_feat_map_desc {
 #define FEAT_S2PIE		ID_AA64MMFR3_EL1, S2PIE, IMP
 #define FEAT_GCIE		ID_AA64PFR2_EL1, GCIE, IMP
 #define FEAT_NV3		ID_AA64MMFR4_EL1, NV_frac, NV3
+#define FEAT_TLBID		ID_AA64MMFR4_EL1, TLBID, IMP
 
 static bool not_feat_aa64el3(struct kvm *kvm)
 {
@@ -849,6 +850,7 @@ static const struct reg_bits_to_feat_map hfgrtr2_feat_map[] = {
 		   HFGRTR2_EL2_nTCRMASK_EL1,
 		   FEAT_SRMASK),
 	NEEDS_FEAT(HFGRTR2_EL2_nRCWSMASK_EL1, FEAT_THE),
+	NEEDS_FEAT(HFGRTR2_EL2_nTLBIDIDR_EL1, FEAT_TLBID),
 };
 
 static const DECLARE_FEAT_MAP_FGT(hfgrtr2_desc, hfgrtr2_masks,
@@ -947,6 +949,10 @@ static const struct reg_bits_to_feat_map hcrx_feat_map[] = {
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
index 2bec81668361..171c0c2b6bf2 100644
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
index c7d91138a6d4..54461a3da117 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1981,6 +1981,9 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
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

