Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693848;
	b=flItlUHDhdczBZ2rSrpgJ/Y5I0UXCrGwk6hPq9Cbn6mz5kjw/JHrSwvlS64cnM+ZofDq
	 uQZAf1npvVCiIB7bhHnD1sE5GL7Jjmz3joZ2akBLo01u+C/FX6KXxs1DtOz6YRXiM1CSR
	 Ktv0vO1YoK3jC+I+/x9P7UZ/N6aSkxTUYC21bKSiIuDmCL51Rcq2VmtFjN2RHmyx/FDek
	 iK8v7HsZaFqNPMvHmWsMqnAeAs6lgZz37Ie3KzZ6vEgh+0tI/mBL1P9cYfvm7Cx0KF1GH
	 xCsvB1py5vl0AYBr29biK53eozLWw3fK5fdA8tpLRXirjyHRIGEUE/5SgphqOB2cLnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693848;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=vNhZoLWHEJooH7K0M5adBsTZX+4xiWJt3xs0oUlCycY=;
	b=aSHwh6Ysvo6f6g+tgaSWHVga3/Yg+rx5sh8Dcc4i5vKN8tRwu7eT3iibVYCiLHOa49hU
	 utPgOn8j51PB1lqW9U6NLGlGiVhN9h4vYBPnBNBFVZCKBcS+xkcBAvpsvXCI+rCPHtqzv
	 4wYiH82D0koqBz7vua6GcClxRqnajYkv9FgxZeyG2HTwc1awjtSm1ne/6F9jX3mEFwUgD
	 /Pll3BSDq7Yv91h/i5LuvV0T8/aPhk6I1T8fcrgSk1tW3ZLRm3rg7NaAvGUkEwMhGyY4A
	 e4DGs9RKZqLjnYz258ZLYRmZcRUQBwhAQVIrUgP5GZEKCFZapW50987GDgq3Ek2956g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DMn0t2qc;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018AB606A326;
	Thu, 26 Nov 2026 11:50:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 018AB606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DMn0t2qc
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AEB91D15;
	Thu, 26 Nov 2026 03:50:44 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 178193F632;
	Thu, 26 Nov 2026 03:50:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693847; bh=dbMROqEBiiOnXrLd/t4gIEe0yyAP6fWxR9vxfO6Bg84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMn0t2qc9tPPecrbOmCKWE4VYrkPe3eLnJfrBsszJQYDenu1wG3xwug/Z6hZCrsg2
	 tpIUhvGQCFUmwWBm4DL32I+vp9cZwZR0ZKAc3LnZQhbqm9gwWhaQ4S37X8tbQjSP5Z
	 UOB6bUs5patZd8tAyYS2V0QaSXdzYdWor5xy2u6Q=
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
Subject: [RFC v2 11/13] arm64: Support TLBIP instructions
Date: Thu, 26 Nov 2026 11:49:34 +0000
Message-ID: <20261126114936.864256-12-kristina.martsenko@arm.com>
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

Modify the TLBI helper functions in tlbflush.h to issue TLBIP
instructions instead of TLBI when requested. These will be used to pass
a TLBI domain ID to TLBI operations.

FEAT_TLBID introduces TLBIP instructions that behave like TLBI but take
a 128-bit value as an argument (passed in two consecutive GPRs). TLBID
uses these to pass a TLBI domain ID to *VA* and *IPA* type instructions.
TLBID does not introduce non-shareable TLBIP instructions, so assert
that those are not requested.

Use local register variables to ensure that the two GPRs are
consecutive. Alternatively we could use the %H operand modifier but LLVM
doesn't support it.

Check for assembler support of TLBIP instructions. TLBIP won't be used
(nor assembled) when CONFIG_ARM64_TLBID=n.

For now there should be no functional change, as no callers request
TLBIP. A later patch will change this.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/Kconfig                |   9 ++-
 arch/arm64/include/asm/tlbflush.h | 130 ++++++++++++++++++++++--------
 2 files changed, 103 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e288e8dc14aa..d0df8abb9b49 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2409,9 +2409,16 @@ config ARM64_LSUI
 
 endmenu # "ARMv9.6 architectural feature"
 
+config AS_HAS_TLBID
+	def_bool $(as-instr,.arch_extension tlbid)
+	# https://github.com/llvm/llvm-project/pull/178913
+	depends on AS_IS_GNU || (AS_IS_LLVM && AS_VERSION >= 230000)
+	help
+	  Supported by LLVM 23+ and binutils 2.46+.
+
 config ARM64_TLBID
 	def_bool y
-	depends on ACPI
+	depends on ACPI && AS_HAS_TLBID
 	select ACPI_TLBI
 
 config ARM64_SVE
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index 8338d780ca59..da7f99d722a5 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -41,11 +41,27 @@
 
 #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
 
+#define __tlbip(op, arg) do {							\
+	u128 __arg = (arg);							\
+	register u64 low asm ("x0") = (u64)__arg;				\
+	register u64 high asm ("x1") = (u64)(__arg >> 64);			\
+										\
+	asm (ARM64_ASM_PREAMBLE ".arch_extension tlbid\n"			\
+	     "tlbip " #op ", %0, %1\n"						\
+	  : : "r" (low), "r" (high));						\
+} while (0)
+
 #define __tlbi_user(op, arg) do {						\
 	if (arm64_kernel_unmapped_at_el0())					\
 		__tlbi(op, (arg) | USER_ASID_FLAG);				\
 } while (0)
 
+#define __tlbip_user(op, arg) do {						\
+	if (arm64_kernel_unmapped_at_el0()) {					\
+		__tlbip(op, (arg) | (u128)USER_ASID_FLAG);			\
+	}									\
+} while (0)
+
 #define TLBI_TLBID_MASK		GENMASK_ULL(15, 0)
 
 /* This macro creates a properly formatted VA operand for the TLBI */
@@ -132,49 +148,75 @@ static inline void sme_dvmsync_batch(void)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
-typedef void (*tlbi_op)(u64 arg);
+typedef void (*tlbi_op)(bool tlbip, u128 arg);
 
-static __always_inline void vae1is(u64 arg)
+static __always_inline void vae1is(bool tlbip, u128 arg)
 {
-	__tlbi(vae1is, arg);
-	__tlbi_user(vae1is, arg);
+	if (tlbip) {
+		__tlbip(vae1is, arg);
+		__tlbip_user(vae1is, arg);
+	} else {
+		__tlbi(vae1is, (u64)arg);
+		__tlbi_user(vae1is, (u64)arg);
+	}
 }
 
-static __always_inline void vae2is(u64 arg)
+static __always_inline void vae2is(bool tlbip, u128 arg)
 {
-	__tlbi(vae2is, arg);
+	if (tlbip)
+		__tlbip(vae2is, arg);
+	else
+		__tlbi(vae2is, (u64)arg);
 }
 
-static __always_inline void vale1(u64 arg)
+static __always_inline void vale1(bool tlbip, u128 arg)
 {
-	__tlbi(vale1, arg);
-	__tlbi_user(vale1, arg);
+	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
+
+	__tlbi(vale1, (u64)arg);
+	__tlbi_user(vale1, (u64)arg);
 }
 
-static __always_inline void vale1is(u64 arg)
+static __always_inline void vale1is(bool tlbip, u128 arg)
 {
-	__tlbi(vale1is, arg);
-	__tlbi_user(vale1is, arg);
+	if (tlbip) {
+		__tlbip(vale1is, arg);
+		__tlbip_user(vale1is, arg);
+	} else {
+		__tlbi(vale1is, (u64)arg);
+		__tlbi_user(vale1is, (u64)arg);
+	}
 }
 
-static __always_inline void vale2is(u64 arg)
+static __always_inline void vale2is(bool tlbip, u128 arg)
 {
-	__tlbi(vale2is, arg);
+	if (tlbip)
+		__tlbip(vale2is, arg);
+	else
+		__tlbi(vale2is, (u64)arg);
 }
 
-static __always_inline void vaale1is(u64 arg)
+static __always_inline void vaale1is(bool tlbip, u128 arg)
 {
-	__tlbi(vaale1is, arg);
+	if (tlbip)
+		__tlbip(vaale1is, arg);
+	else
+		__tlbi(vaale1is, (u64)arg);
 }
 
-static __always_inline void ipas2e1(u64 arg)
+static __always_inline void ipas2e1(bool tlbip, u128 arg)
 {
-	__tlbi(ipas2e1, arg);
+	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
+
+	__tlbi(ipas2e1, (u64)arg);
 }
 
-static __always_inline void ipas2e1is(u64 arg)
+static __always_inline void ipas2e1is(bool tlbip, u128 arg)
 {
-	__tlbi(ipas2e1is, arg);
+	if (tlbip)
+		__tlbip(ipas2e1is, arg);
+	else
+		__tlbi(ipas2e1is, (u64)arg);
 }
 
 static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
@@ -188,7 +230,7 @@ static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
 		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
 	}
 
-	op(arg);
+	op(false, arg);
 }
 
 static inline void __tlbi_level(tlbi_op op, u64 addr, u32 level)
@@ -449,32 +491,50 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  *    operations can only span an even number of pages. We save this for last to
  *    ensure 64KB start alignment is maintained for the LPA2 case.
  */
-static __always_inline void rvae1is(u64 arg)
+static __always_inline void rvae1is(bool tlbip, u128 arg)
 {
-	__tlbi(rvae1is, arg);
-	__tlbi_user(rvae1is, arg);
+	if (tlbip) {
+		__tlbip(rvae1is, arg);
+		__tlbip_user(rvae1is, arg);
+	} else {
+		__tlbi(rvae1is, (u64)arg);
+		__tlbi_user(rvae1is, (u64)arg);
+	}
 }
 
-static __always_inline void rvale1(u64 arg)
+static __always_inline void rvale1(bool tlbip, u128 arg)
 {
-	__tlbi(rvale1, arg);
-	__tlbi_user(rvale1, arg);
+	compiletime_assert(!tlbip, "Unsupported TLBIP operand");
+
+	__tlbi(rvale1, (u64)arg);
+	__tlbi_user(rvale1, (u64)arg);
 }
 
-static __always_inline void rvale1is(u64 arg)
+static __always_inline void rvale1is(bool tlbip, u128 arg)
 {
-	__tlbi(rvale1is, arg);
-	__tlbi_user(rvale1is, arg);
+	if (tlbip) {
+		__tlbip(rvale1is, arg);
+		__tlbip_user(rvale1is, arg);
+	} else {
+		__tlbi(rvale1is, (u64)arg);
+		__tlbi_user(rvale1is, (u64)arg);
+	}
 }
 
-static __always_inline void rvaale1is(u64 arg)
+static __always_inline void rvaale1is(bool tlbip, u128 arg)
 {
-	__tlbi(rvaale1is, arg);
+	if (tlbip)
+		__tlbip(rvaale1is, arg);
+	else
+		__tlbi(rvaale1is, (u64)arg);
 }
 
-static __always_inline void ripas2e1is(u64 arg)
+static __always_inline void ripas2e1is(bool tlbip, u128 arg)
 {
-	__tlbi(ripas2e1is, arg);
+	if (tlbip)
+		__tlbip(ripas2e1is, arg);
+	else
+		__tlbi(ripas2e1is, (u64)arg);
 }
 
 static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
@@ -490,7 +550,7 @@ static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
 	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
 	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
 
-	op(arg);
+	op(false, arg);
 }
 
 static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,
-- 
2.43.0

