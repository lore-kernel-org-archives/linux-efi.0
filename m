Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA61650B8B9;
	Thu,  1 Oct 2026 11:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852854; cv=none; b=EnbPtFBYzk9YWlfxXB3YdaoGaefkou8qlJhRbXeVIQdLb1LK/es/TN8JX0irGYtMtRPTQ+YraCI7UbqEePjx9VcEoy9NA8TUBOFcriVU6Am+6O/J4PmboTglFEXpJti/HLT0gfQ20tOiC98QcioME8Mc07pbRytSAzuzrwlJQCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852854; c=relaxed/simple;
	bh=P874H+3XkUEaweVPu/iQHLVGgjAmR/t8sk5vWLaLPcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aD39Hmvlqj2Lcp2EtJx7prH6oBtPUmxHj5wEBAnk5dxXX0oCF2jKbpEKBnLnxcds97q1+yCFiKayJNKTo/ypcOZwx+UxyNCS4ynbg+KFUY51JtYdYnD+l/gLOQVriKYhrBuXH42qlEgHqzRzLPZ5zyO7Qc3vis6cNl51j2AQAdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=hDS5rr6x; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="hDS5rr6x"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1F9A143D;
	Thu,  1 Oct 2026 04:07:27 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A10E3F86F;
	Thu,  1 Oct 2026 04:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852851; bh=P874H+3XkUEaweVPu/iQHLVGgjAmR/t8sk5vWLaLPcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDS5rr6xo5dWjVucyKuR1kbNKuS3sPmvO2ii+vs3ySrPoVo4AoZ1xJbPsPEKS1njQ
	 to2XyMiWh6B6drsjVX3CNZG13/+EIOwQ9s0ei5+QvcXUtZKoWjOd2MBQuuGwNn65Ye
	 NTZI1xAxXYGbyoaKd2EefCzxGRV41/1xCQO/wdL4=
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
Subject: [RFC 01/12] arm64: sysreg: Add definitions for FEAT_TLBID
Date: Thu,  1 Oct 2026 12:06:44 +0100
Message-ID: <20261001110655.461473-2-kristina.martsenko@arm.com>
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

Describe new system registers and fields added by FEAT_TLBID, so that
later patches can use them. This is based on the latest system register
specifications (version 2026-09, see Link).

The size and number of fields in VTLBID* registers is determined by
information in other registers at runtime, so can't be described
statically here.

Link: https://support.arm.com/architectures/a-profile-architecture#Downloads
Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/tools/sysreg | 53 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index e2d37ee221b8..b134418ff3aa 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -4331,7 +4331,9 @@ Field	0	nPMECR_EL1
 EndSysreg
 
 Sysreg	HFGRTR2_EL2	3	4	3	1	2
-Res0	63:15
+Res0	63:31
+Field	30	nTLBIDIDR_EL1
+Res0	29:15
 Field	14	nACTLRALIAS_EL1
 Field	13	nACTLRMASK_EL1
 Field	12	nTCR2ALIAS_EL1
@@ -4551,14 +4553,16 @@ Fields	ZCR_ELx
 EndSysreg
 
 Sysreg	HCRX_EL2	3	4	1	2	2
-Res0	63:35
+Res0	63:37
+Field	36	FNB
+Field	35	VTLBIDOSEn
 Field	34	NVnTTLBOS
 Field	33	NVnTTLBIS
 Field	32	NVnTTLB
 Res0	31:28
 Field	27	NVTGE
 Field	26	SRMASKEn
-Res0	25
+Field	25	VTLBIDEn
 Field	24	PACMEn
 Field	23	EnFPM
 Field	22	GCSEn
@@ -4708,6 +4712,38 @@ Res0	25:19
 Field	18:0	INDEX
 EndSysreg
 
+Sysreg	VTLBID0_EL2	3	4	2	8	0
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBID1_EL2	3	4	2	8	1
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBID2_EL2	3	4	2	8	2
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBID3_EL2	3	4	2	8	3
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS0_EL2	3	4	2	9	0
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS1_EL2	3	4	2	9	1
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS2_EL2	3	4	2	9	2
+Field	63:0	TD
+EndSysreg
+
+Sysreg	VTLBIDOS3_EL2	3	4	2	9	3
+Field	63:0	TD
+EndSysreg
+
 Sysreg	DACR32_EL2	3	4	3	0	0
 Res0	63:32
 Field	31:30	D15
@@ -5755,6 +5791,17 @@ Res0	16
 Field	15:0	PARTID_MAX
 EndSysreg
 
+Sysreg	TLBIDIDR_EL1	3	0	10	4	6
+Res0	63:45
+Field	44:40	NVOS
+Res0	39:37
+Field	36:32	NOS
+Res0	31:13
+Field	12:8	NVIS
+Res0	7:5
+Field	4:0	NIS
+EndSysreg
+
 Sysreg	LORID_EL1	3	0	10	4	7
 Res0	63:24
 Field	23:16	LD
-- 
2.43.0

