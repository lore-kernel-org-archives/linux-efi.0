Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5DE9503BE0;
	Thu,  1 Oct 2026 11:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852898; cv=none; b=lrzxaJsGgSZSF8SoFLdCEkJGy6NR0I95ri6e7AF4/fJRLoCr9EVXZ3e75qslKuD9KQXjqSq74tYAVKCsuVKg26aI4TfF6IETou8TCzSmlmmAqY7jdKpevoaftmxZDuOmAwGKRf9u+iAc7ndYRHzNCKTSyZ+Ox3niCxQpBeMoxw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852898; c=relaxed/simple;
	bh=3TSuuPvUu9ywWP0crNatFLDGsZoQ7PuxeuXdWS5myIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oOeXh/De58lJGrATmR0I5plpHBxRokigg2XYUdjAES34TNVb+6+45lkv1NxiXKZcjBLBh+eYfO9tJfAdghscuKiQfzA30+D59RQbbD/gW91qsIQswy5rD2Kwz2bPV0GVdxStH3ZXtNU5DnRBXEft2vdi7tybGZaHfkVg0JQluLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KWFAtQ4G; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KWFAtQ4G"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21E34143D;
	Thu,  1 Oct 2026 04:08:12 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA2533F86F;
	Thu,  1 Oct 2026 04:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852895; bh=3TSuuPvUu9ywWP0crNatFLDGsZoQ7PuxeuXdWS5myIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWFAtQ4GnV4Eo5YiwDfpzHBTB0GdqkFUIaPed9+64852hGTMcQMLjHk0oiz1tedqn
	 Aex1+nOxChMjigCmBHoKuOV8HrSuEq98XaUk/OXD174/x/O3U/iRtR01L9fyxjD4a8
	 4VADmF7l7Gf0MFw3A+ZuKEeEmc9TMyt2qFEb1FR4=
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
Subject: [RFC 10/12] arm64: Support TLBIP instructions
Date: Thu,  1 Oct 2026 12:06:53 +0100
Message-ID: <20261001110655.461473-11-kristina.martsenko@arm.com>
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
 arch/arm64/Kconfig                |   9 +-
 arch/arm64/include/asm/tlbflush.h | 131 ++++++++++++++++++++++--------
 2 files changed, 103 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 46701449fef2..a6525754492b 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2329,9 +2329,16 @@ config ARM64_LSUI
 
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
index b51df8e0ce63..dac35568570f 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -41,11 +41,26 @@
 
 #define __tlbi(op, ...)		__TLBI_N(op, ##__VA_ARGS__, 1, 0)
 
+#define __tlbip(op, arg) do {		\
+	register u64 low asm ("x0") = (u64)arg;					\
+	register u64 high asm ("x1") = (u64)(arg >> 64);			\
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
@@ -132,49 +147,75 @@ static inline void sme_dvmsync_batch(void)
 
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
+		__tlbi(ipas2e1is, arg);
+	else
+		__tlbi(ipas2e1is, (u64)arg);
 }
 
 static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
@@ -188,7 +229,7 @@ static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
 		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
 	}
 
-	op(arg);
+	op(false, arg);
 }
 
 static inline void __tlbi_level(tlbi_op op, u64 addr, u32 level)
@@ -445,32 +486,50 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  *    operations can only span an even number of pages. We save this for last to
  *    ensure 64KB start alignment is maintained for the LPA2 case.
  */
-static __always_inline void rvae1is(u64 arg)
-{
-	__tlbi(rvae1is, arg);
-	__tlbi_user(rvae1is, arg);
+static __always_inline void rvae1is(bool tlbip, u128 arg)
+{
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
@@ -486,7 +545,7 @@ static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
 	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
 	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
 
-	op(arg);
+	op(false, arg);
 }
 
 static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,
-- 
2.43.0

