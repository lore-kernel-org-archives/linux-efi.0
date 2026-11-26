Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693816;
	b=BVloeZDcM//GVmYLco5AhOOA4Wo+MFTsIfiwS6+5owun5bmkzCvQivCVhXQJN0qxjdGp
	 sSnJUGtEt6KM3fddly8mZn3FD9paFlaQQiSvkzmCPuxHGTYDgqZoHm40ruT8+mesq9bVj
	 UXPFBTu8IawrlzkXmPxVC2crAHKwe2y9saV5SF4G9MQfNGi5086iO8+lmJEfAHFi93b06
	 682R4ZBX4EzVl3tk4pQXYfelJJizZpBk9GVY7/hv4jxFqW5GqC4Et4AA2zmw2vZHqbtbo
	 vh5hVixP+5Haqn/f6XbvLZRvGe8Irav6lpVJBQNC4Yggq3YudaXNfQ/K98OUCzCdCww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693816;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=h5GiJCNwUXIWcpQEzRIOQ92oxBIUY5kMYfK9T+/jm2k=;
	b=Fvw1kKNk9xEaSMRxQatV1NfxwdUHHdkO6pUUmoZDf6fnqXhvo58R4LA0UgXpPy7/gjDp
	 FyuWLe1H4WbXlta7FAvRk+bCe2THr4acc+MYhLzEYZGOvnJJ523ODJ34T/NA7fjNYMhvj
	 d8YVzYKIhgn0ouf/YbivSG1FKFJblrgLqQlqa7CI4WBvHTUjSVtvDKlt0oEL7mHZBT4SP
	 WZAWJBZMZz74imqamelHX+c7XmFRvKmwiq1huFq5HG2hwV0vNq1yTal9Bv/VCE8MGTxPx
	 kn2M4Q6G0zKwJutwtYac1yj006giZYF+DD0TyxgP/032tUDrkG9g1+Ikf3v0tGNHphw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fxS1z5mg;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC671606A31C;
	Thu, 26 Nov 2026 11:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AC671606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=fxS1z5mg
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 373251D13;
	Thu, 26 Nov 2026 03:50:12 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C66FE3F632;
	Thu, 26 Nov 2026 03:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693815; bh=qGBo7r4JAWAjdtqdXgMLeYhrT+7MnCHRFBKY0iTyxLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxS1z5mgYeDIlmna6ZpMBnIbhLzYQ4toGwzuedeoRjciWNZAnNrHYgpZFVk4eCNAF
	 SuBJ0xCT/K6P//3GJj0Q22wzYgrRckSvPZi8Qupnb3eiFcRDtJ0dvEFQDPkSjGRs4w
	 B7cLqSdsiza7exCocHzLBLHmt0CHyaKygErPJpDE=
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
Subject: [RFC v2 02/13] arm64: boot: Handle TLBID boot requirements
Date: Thu, 26 Nov 2026 11:49:25 +0000
Message-ID: <20261126114936.864256-3-kristina.martsenko@arm.com>
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

To use FEAT_TLBID, some configuration is necessary at EL3 and EL2. This
patch documents the requirements and adds the initial EL2 setup code,
which enables the kernel to access the TLBIDIDR_EL1 register at EL1.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 Documentation/arch/arm64/booting.rst | 10 ++++++++++
 arch/arm64/include/asm/el2_setup.h   | 10 +++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
index dae5ff9fae26..752917bf62c3 100644
--- a/Documentation/arch/arm64/booting.rst
+++ b/Documentation/arch/arm64/booting.rst
@@ -569,6 +569,16 @@ Before jumping into the kernel, the following conditions must be met:
 
     - HCRX_EL2.EnASR (bit 2) must be initialised to 0b1.
 
+  For CPUs with TLBI domains (FEAT_TLBID):
+
+  - If EL3 is present and the kernel is entered at EL2:
+
+    - SCR_EL3.VTLBIDEn (bit 56) must be initialised to 0b1.
+
+  - If EL2 is present and the kernel is entered at EL1:
+
+    - HFGRTR2_EL2.nTLBIDIDR_EL1 (bit 30) must be initialised to 0b1.
+
 The requirements described above for CPU mode, caches, MMUs, architected
 timers, coherency and system registers apply to all CPUs.  All CPUs must
 enter the kernel in the same exception level.  Where the values documented
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 12a500181291..1521c9965ae3 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -448,7 +448,15 @@
 .Lskip_spefds_\@:
 	msr_s   SYS_HDFGRTR2_EL2, x0
 	msr_s   SYS_HDFGWTR2_EL2, x2
-	msr_s   SYS_HFGRTR2_EL2, xzr
+
+	mov	x0, xzr
+	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
+	ubfx	x1, x1, #ID_AA64MMFR4_EL1_TLBID_SHIFT, #ID_AA64MMFR4_EL1_TLBID_WIDTH
+	cbz	x1, .Lskip_tlbid_\@
+	orr	x0, x0, #HFGRTR2_EL2_nTLBIDIDR_EL1
+
+.Lskip_tlbid_\@:
+	msr_s   SYS_HFGRTR2_EL2, x0
 	msr_s   SYS_HFGWTR2_EL2, xzr
 	msr_s   SYS_HFGITR2_EL2, xzr
 .Lskip_fgt2_\@:
-- 
2.43.0

