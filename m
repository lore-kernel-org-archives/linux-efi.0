Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70294FD268;
	Thu,  1 Oct 2026 11:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852904; cv=none; b=SWReXFPSKp7Db+XHARKQSLDdA3UCiunW0lKLrwkDG7dI7G+Y2N1qiJ9G+8NRKjgU15P57qJmM2evZCkV/Mz9qCbxFhFoCTSEd+zC4GPj/cR83BGNZS/txhTTV3jUymRSy3lVZ3kvKW/cftrA3hAZoiMQx+ufwKpjEB8jsxAG5UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852904; c=relaxed/simple;
	bh=hgMQxRFL1SZ01cC2jGkWuz2aiXQ+1i4INyYC3+BjHYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g0X3W40rFQV5Dwwrc863We/N/7Vr5dRbqUGuNURxlx+O518VQj/2dUCCYeaRDOrKYTKJhjjP7uJdwOy0HYPTMaUaAzYedw3FIyQnEvMNer9P8rHwmIgwGjwktzV5IrVbPvUrV3NqY00JbTRJzEjf/n+pOn7n30Lb6/Hoe0RtrNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iY2ttwGk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iY2ttwGk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CC178497;
	Thu,  1 Oct 2026 04:08:16 -0700 (PDT)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 830233F86F;
	Thu,  1 Oct 2026 04:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790852900; bh=hgMQxRFL1SZ01cC2jGkWuz2aiXQ+1i4INyYC3+BjHYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY2ttwGki8fPVIf5dRLDF4Ug1b6I3ktcGCXXXN0IXlltiFbFBj8sIRQUN8d/cWbhm
	 klYB7kOjDYnWMzmyKtc2EiG2+0GXilFJt3ZYSGmIGCoTBYNBhHR5sk57aABpXwRGyA
	 Y8zZOfI8MSdMLMbYHhJoRVtcP41eKfG0k2YrMas0=
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
Subject: [RFC 11/12] arm64: tlbid: Pass domain to TLBI instructions
Date: Thu,  1 Oct 2026 12:06:54 +0100
Message-ID: <20261001110655.461473-12-kristina.martsenko@arm.com>
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

Update the TLB invalidation interfaces in tlbflush.h to pass a TLBI
domain to TLBI instructions (when available). This may improve
performance by sending the TLBI to only the subset of CPUs that needs
it.

Only use TLBI domains for user mappings, as the kernel is mapped on all
CPUs. Use the mm domain bitmap to choose the smallest domain that
contains all the CPUs that an mm has been installed on.

Most invalidations need to use the TLBIP instruction in order to use a
TLBI domain. The exception is TLBI ASID* (flush_tlb_mm()) which can pass
a domain to a regular TLBI instruction.

To avoid runtime checks on the TLBI domain, use TLBIP instructions for all
invalidations (except local/non-shareable) when supported. When no
domain is needed, callers pass 0 which is the fallback domain
broadcasting to the entire Inner Shareable domain. Local invalidations
continue to use TLBI instructions since the TLBID architecture does not
have non-shareable versions of TLBIP instructions.

The mm domain bitmap may be updated concurrently by another CPU while it
is being read. Use a DSB to ensure that invalidations don't miss any CPU
that has relevant mappings.

Assisted-by: LLM
Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/mmu.h      |  2 +
 arch/arm64/include/asm/tlbflush.h | 90 ++++++++++++++++++++++---------
 arch/arm64/kvm/hyp/nvhe/tlb.c     |  2 +-
 arch/arm64/kvm/hyp/vhe/tlb.c      |  2 +-
 arch/arm64/mm/tlbid.c             | 36 +++++++++++++
 5 files changed, 104 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index fc4e759f9f64..ae43a91ddabc 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -111,10 +111,12 @@ extern bool page_alloc_available;
 int init_tlbid_context(struct mm_struct *mm);
 void destroy_tlbid_context(struct mm_struct *mm);
 void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu);
+u16 get_tlbid_domain(struct mm_struct *mm);
 #else
 static inline int init_tlbid_context(struct mm_struct *mm) { return 0; }
 static inline void destroy_tlbid_context(struct mm_struct *mm) {}
 static inline void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu) {}
+static inline u16 get_tlbid_domain(struct mm_struct *mm) { return 0; }
 #endif
 
 #endif	/* !__ASSEMBLER__ */
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index dac35568570f..864d7459d5be 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -61,7 +61,9 @@
 	}									\
 } while (0)
 
+#define TLBI_ASID_MASK		GENMASK_ULL(63, 48)
 #define TLBI_TLBID_MASK		GENMASK_ULL(15, 0)
+#define TLBIP_ADDR_MASK		GENMASK_U128(107, 64)
 
 /* This macro creates a properly formatted VA operand for the TLBI */
 #define __TLBI_VADDR(addr, asid)				\
@@ -144,6 +146,7 @@ static inline void sme_dvmsync_batch(void)
  * in asm/stage2_pgtable.h.
  */
 #define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
+#define TLBIP_TTL64		BIT(32)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
@@ -219,22 +222,38 @@ static __always_inline void ipas2e1is(bool tlbip, u128 arg)
 }
 
 static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
-					      u16 asid)
+					      u16 asid, bool local, int domain)
 {
-	u64 arg = __TLBI_VADDR(addr, asid);
+	bool tlbip = system_supports_tlbid() && !local;
+	u128 arg = 0;
+
+	if (tlbip) {
+		arg |= (((u128)addr >> 12) << 64) & TLBIP_ADDR_MASK;
+		arg |= FIELD_PREP(TLBI_ASID_MASK, asid);
+		arg |= domain;
+	} else {
+		arg |= __TLBI_VADDR(addr, asid);
+	}
 
 	if (alternative_has_cap_unlikely(ARM64_HAS_ARMv8_4_TTL) && level <= 3) {
 		u64 ttl = level | (get_trans_granule() << 2);
+		arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);
 
-		FIELD_MODIFY(TLBI_TTL_MASK, &arg, ttl);
+		if (tlbip)
+			arg |= TLBIP_TTL64;
 	}
 
-	op(false, arg);
+	op(tlbip, arg);
 }
 
 static inline void __tlbi_level(tlbi_op op, u64 addr, u32 level)
 {
-	__tlbi_level_asid(op, addr, level, 0);
+	__tlbi_level_asid(op, addr, level, 0, false, 0);
+}
+
+static inline void __tlbi_level_local(tlbi_op op, u64 addr, u32 level)
+{
+	__tlbi_level_asid(op, addr, level, 0, true, -1);
 }
 
 /*
@@ -418,12 +437,13 @@ static inline void flush_tlb_all(void)
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
-	unsigned long asid;
+	unsigned long arg;
 
 	dsb(ishst);
-	asid = __TLBI_VADDR(0, ASID(mm));
-	__tlbi(aside1is, asid);
-	__tlbi_user(aside1is, asid);
+	arg = __TLBI_VADDR(0, ASID(mm));
+	arg |= get_tlbid_domain(mm);
+	__tlbi(aside1is, arg);
+	__tlbi_user(aside1is, arg);
 	__tlbi_sync_s1ish(mm);
 	mmu_notifier_arch_invalidate_secondary_tlbs(mm, 0, -1UL);
 }
@@ -534,24 +554,38 @@ static __always_inline void ripas2e1is(bool tlbip, u128 arg)
 
 static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
 					 u16 asid, int scale, int num,
-					 u32 level, bool lpa2)
+					 u32 level, bool lpa2, bool local,
+					 int domain)
 {
-	u64 arg = 0;
+	bool tlbip = system_supports_tlbid() && !local;
+	u128 arg = 0;
+
+	if (tlbip) {
+		arg |= (((u128)addr >> 12) << 64) & TLBIP_ADDR_MASK;
+		arg |= domain;
+	} else {
+		arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
+	}
+
+	if (level <= 3) {
+		arg |= FIELD_PREP(TLBIR_TTL_MASK, level);
+		if (tlbip)
+			arg |= TLBIP_TTL64;
+	}
 
-	arg |= FIELD_PREP(TLBIR_BADDR_MASK, addr >> (lpa2 ? 16 : PAGE_SHIFT));
-	arg |= FIELD_PREP(TLBIR_TTL_MASK, level > 3 ? 0 : level);
 	arg |= FIELD_PREP(TLBIR_NUM_MASK, num);
 	arg |= FIELD_PREP(TLBIR_SCALE_MASK, scale);
 	arg |= FIELD_PREP(TLBIR_TG_MASK, get_trans_granule());
 	arg |= FIELD_PREP(TLBIR_ASID_MASK, asid);
 
-	op(false, arg);
+	op(tlbip, arg);
 }
 
 static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,
 						 u64 start, size_t pages,
 						 u64 stride, u16 asid,
-						 u32 level, bool lpa2)
+						 u32 level, bool lpa2,
+						 bool local, int domain)
 {
 	u64 addr = start, end = start + pages * PAGE_SIZE;
 	int scale = 3;
@@ -569,23 +603,24 @@ static __always_inline void __flush_tlb_range_op(tlbi_op lop, tlbi_op rop,
 
 		num = __TLBI_RANGE_NUM(pages, scale);
 		if (num >= 0) {
-			__tlbi_range(rop, addr, asid, scale, num, level, lpa2);
+			__tlbi_range(rop, addr, asid, scale, num, level, lpa2,
+				     local, domain);
 			addr += __TLBI_RANGE_PAGES(num, scale) << PAGE_SHIFT;
 		}
 
 		scale--;
 		continue;
 invalidate_one:
-		__tlbi_level_asid(lop, addr, level, asid);
+		__tlbi_level_asid(lop, addr, level, asid, local, domain);
 		addr += stride;
 	}
 }
 
-#define __flush_s1_tlb_range_op(op, start, pages, stride, asid, tlb_level) \
-	__flush_tlb_range_op(op, r##op, start, pages, stride, asid, tlb_level, lpa2_is_enabled())
+#define __flush_s1_tlb_range_op(op, start, pages, stride, asid, tlb_level, local, domain) \
+	__flush_tlb_range_op(op, r##op, start, pages, stride, asid, tlb_level, lpa2_is_enabled(), local, domain)
 
 #define __flush_s2_tlb_range_op(op, start, pages, stride, tlb_level) \
-	__flush_tlb_range_op(op, r##op, start, pages, stride, 0, tlb_level, kvm_lpa2_is_enabled())
+	__flush_tlb_range_op(op, r##op, start, pages, stride, 0, tlb_level, kvm_lpa2_is_enabled(), false, 0)
 
 static inline bool __flush_tlb_range_limit_excess(unsigned long pages,
 						  unsigned long stride)
@@ -626,6 +661,7 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long asid, pages;
+	int domain;
 
 	pages = (end - start) >> PAGE_SHIFT;
 
@@ -634,21 +670,23 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
 		return;
 	}
 
-	if (!(flags & TLBF_NOBROADCAST))
+	if (!(flags & TLBF_NOBROADCAST)) {
 		dsb(ishst);
-	else
+		domain = get_tlbid_domain(mm);
+	} else {
 		dsb(nshst);
+	}
 
 	asid = ASID(mm);
 
 	switch (flags & (TLBF_NOWALKCACHE | TLBF_NOBROADCAST)) {
 	case TLBF_NONE:
 		__flush_s1_tlb_range_op(vae1is, start, pages, stride,
-					asid, tlb_level);
+					asid, tlb_level, false, domain);
 		break;
 	case TLBF_NOWALKCACHE:
 		__flush_s1_tlb_range_op(vale1is, start, pages, stride,
-					asid, tlb_level);
+					asid, tlb_level, false, domain);
 		break;
 	case TLBF_NOBROADCAST:
 		/* Combination unused */
@@ -656,7 +694,7 @@ static __always_inline void __do_flush_tlb_range(struct vm_area_struct *vma,
 		break;
 	case TLBF_NOWALKCACHE | TLBF_NOBROADCAST:
 		__flush_s1_tlb_range_op(vale1, start, pages, stride,
-					asid, tlb_level);
+					asid, tlb_level, true, -1);
 		break;
 	}
 
@@ -725,7 +763,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 
 	dsb(ishst);
 	__flush_s1_tlb_range_op(vaale1is, start, pages, stride, 0,
-				TLBI_TTL_UNKNOWN);
+				TLBI_TTL_UNKNOWN, false, 0);
 	__tlbi_sync_s1ish_kernel();
 	isb();
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index fdb90483340c..f7cac7f1f4fe 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -187,7 +187,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	 * Instead, we invalidate Stage-2 for this IPA, and the
 	 * whole of Stage-1. Weep...
 	 */
-	__tlbi_level(ipas2e1, ipa, level);
+	__tlbi_level_local(ipas2e1, ipa, level);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index e2e6a2df1533..ac1c5e623cf3 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -135,7 +135,7 @@ void __kvm_tlb_flush_vmid_ipa_nsh(struct kvm_s2_mmu *mmu,
 	 * Instead, we invalidate Stage-2 for this IPA, and the
 	 * whole of Stage-1. Weep...
 	 */
-	__tlbi_level(ipas2e1, ipa, level);
+	__tlbi_level_local(ipas2e1, ipa, level);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
diff --git a/arch/arm64/mm/tlbid.c b/arch/arm64/mm/tlbid.c
index b44fab2dca20..c748e710e2ee 100644
--- a/arch/arm64/mm/tlbid.c
+++ b/arch/arm64/mm/tlbid.c
@@ -10,6 +10,7 @@
 #include <linux/atomic.h>
 #include <linux/bitops.h>
 #include <linux/bitmap.h>
+#include <linux/bug.h>
 #include <linux/efi.h>
 #include <linux/jump_label.h>
 #include <linux/mm_types.h>
@@ -24,6 +25,33 @@ static u16 *domain_ids;
 static unsigned long **cpu_domains;
 static int domain_count;
 
+u16 get_tlbid_domain(struct mm_struct *mm)
+{
+	unsigned long mask = BITMAP_LAST_WORD_MASK(domain_count);
+	int idx = (domain_count - 1) / 64;
+	unsigned long domain_idx;
+	unsigned long domains;
+
+	if (!system_supports_tlbid())
+		return 0;
+
+	/* Open-coded find_last_bit() that uses atomic reads */
+	do {
+		domains = atomic64_read(&mm->context.tlbid_domains[idx]);
+		domains &= mask;
+		if (domains) {
+			domain_idx = idx * 64 + __fls(domains);
+			break;
+		}
+		mask = ~0UL;
+	} while (idx--);
+
+	if (WARN_ON(idx < 0))
+		return 0;
+
+	return domain_ids[domain_idx];
+}
+
 void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu)
 {
 	if (!system_supports_tlbid())
@@ -31,6 +59,14 @@ void update_tlbid_domains(struct mm_struct *mm, unsigned int cpu)
 
 	for (int i = 0; i < BITS_TO_U64(domain_count); i++)
 		atomic64_and(cpu_domains[cpu][i], &mm->context.tlbid_domains[i]);
+
+	/*
+	 * Pairs with the DSB before reading tlbid_domains in the TLBI paths.
+	 * Either a concurrent PTE update is visible to this CPU before it uses
+	 * the mm, or the PTE updater observes the reduced domain bitmap and
+	 * includes this CPU in its TLBI.
+	 */
+	dsb(ishst);
 }
 
 int init_tlbid_context(struct mm_struct *mm)
-- 
2.43.0

