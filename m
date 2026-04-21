Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2923A3834
	for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 09:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763568; cv=none; b=S0ARNgqPNtWUOYRjOIUKgK+5B3kerr8D6tXHpJ9UB7z86Qtzgg4ascMhgQ3rq5adY0o2CiHXP1n8uT1Vjr/lytylKlLS8R7DM4tv+hpN0/inqpxYvo1auNLnJoxPNshPe4mwbEmqiq5RTLEUpqhom9DdPaT6rkXjrF7USBweiPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763568; c=relaxed/simple;
	bh=6PIN/dG7wFqQzqUa3HZ7Md7FkGfW//HU1jgeoeBIV1E=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q7k2CPxceMV7fUBHbUn65bTie3qzmfHkRpBDJBJCAo6VzCY2oZJbv8vT4Zr0mv3VNuq/Os+T1zGwYW1ldCvfooxyUNm3/LpXpjBet9h1ppbicIzFVzSJ8be/6GUDUt4MkQL8jabBt3LjhS4wuulEnjQhhVE6Nsl2qic4T/hj+XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=aLgBMTtq; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="aLgBMTtq"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so2402522a91.0
        for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 02:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776763566; x=1777368366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FJWvxx2SvBNX2CVsFvwsTk0IK3zSjjAIlJH4BJFUonM=;
        b=aLgBMTtq5BDkSduB8coXYpoodGKG9tuSocK8BDlmgDOrw8Kqzo+gYzNq0/wtkZubha
         hjZgW9QOzntpnZDp2LqV4LtUGHX38VDzo4tkVZxUukxYFKvbORQpL4jxUYpklFTCAZJU
         XVnlqo4Hk0YfY2Fv73Bk8KXyyEhO5ZdBJ61pnldTgG68w2/71TWZm8HFm54AH+x8Y9o3
         LgLMbfIRHCIyqfkAhh37nUdvqcx3O7HFhlPBIxpq0rGb1nqvrXNE4oQjDdgzcCGqUjYu
         TqYgmCuEisedUau/et0KIf3OaMaCfY2cCHDXjQiQO1RAnTTu1e5fWpck+8S+bt09L5XV
         4h/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763566; x=1777368366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FJWvxx2SvBNX2CVsFvwsTk0IK3zSjjAIlJH4BJFUonM=;
        b=m5NJW5tcwaWfUEv9t154Mz/oNydVFbNaxG7DwLFMh12JQuZcAJg/7I7rtzhzgAHncO
         RmUD1OnkfuaKR4Zma74zvXBIWu7AFT6IL41TZBscet6ssyPQir7LI/dyI7vzLcX5Vzul
         UMdLRn7fhUE3ekuHrqPF0kMPyWRbmGDa8qfOSWB23w/IEWc2C+1peJsE9OiYMb5cGma3
         CyhOO2e3GZY4aRkM2ONZxub/ShD9XV33E5Nmd+Pk7i1rH7Z2iV624WBGYM7laT59bUL3
         V7hGEKvnQYtw1OcoKvvAXr8MVkOeOuRMxf71XAyun/NF8lXmXOr3LxymX/RENVG//4hx
         O/lA==
X-Forwarded-Encrypted: i=1; AFNElJ9LJkSLFksP822yv3sjwT1sA9aW8eqsmPtVP+IxkgydUwcMOI724cPFW4YYLxjQWOohqCaHhNqRydU=@vger.kernel.org
X-Gm-Message-State: AOJu0YznY6Ezop0jwiosJgUD6wUysCUjUXHNvnelBxzxupzhQoHfvAfZ
	y7Zft6R1GMrYtrtFadTUE2sCRiXPdXW3y1eCupzd/uu3aRMXfuG00FLpu0LSGAJ15Lc=
X-Gm-Gg: AeBDiesXIs5gMgbzUgzmUixbeL8HYpFgolhRBzt0dZdvpfY2mdJFap6bOWAQrycQo87
	aXK7I+ojcVnhBr+O/MHuYWa55MI5/hmeAnW664mQrG/AqThK8fTugtPDc3evcXyBYxVXKdPXHuo
	DMBO20iM9MuVhY/+KZkP14gL7d1qe8L9F2N6wkmT0XX5NsZBfj0F6+KAUuj3GPjstNxPEMqHMNK
	WQAXe+rHVoBFOY2YONlh61s0l63Yd1eKSaK6qbRfzNJ4zOYDkXKbtFOpfy5MLUF4vFHF+UthFlL
	ccRQMyENdtxbiYYG6U5+gSj+wACnjaV2k+50mxb+C+q9aOVKdMDTiytFxKVhQWHB6gelay8HUhq
	cA/WhROiYdXiTDD1nQMaKV233KP9btYHPcfmsC7jmDRGcz/DHM7SdYhtev/BRbQm6OJbf2vfdiw
	GKv6sgM5i4r952PiBmfo1MUJSBaTOBK6pQW+nE7VdMvfSC8henEsI2wGEYsmNAhdVwHUAFDxZHF
	/dZtVg=
X-Received: by 2002:a17:90b:5865:b0:35d:a557:e41 with SMTP id 98e67ed59e1d1-3614046f978mr18558407a91.14.1776763566317;
        Tue, 21 Apr 2026 02:26:06 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff39csm131965105ad.4.2026.04.21.02.25.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Apr 2026 02:26:05 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: akpm@linux-foundation.org,
	alex@ghiti.fr,
	andrew+kernel@donnellan.id.au,
	andreyknvl@gmail.com,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	apopple@nvidia.com,
	ardb@kernel.org,
	atish.patra@linux.dev,
	baolin.wang@linux.alibaba.com,
	cuiyunhui@bytedance.com,
	david@kernel.org,
	debug@rivosinc.com,
	djordje.todorovic@htecgroup.com,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	ilias.apalodimas@linaro.org,
	junhui.liu@pigmoral.tech,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	liu.xuemei1@zte.com.cn,
	ljs@kernel.org,
	namcao@linutronix.de,
	osalvador@suse.de,
	palmer@dabbelt.com,
	pjw@kernel.org,
	rmclure@linux.ibm.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryabinin.a.a@gmail.com,
	surenb@google.com,
	vincenzo.frascino@arm.com,
	vishal.moola@gmail.com,
	wangruikang@iscas.ac.cn,
	zhangchunyan@iscas.ac.cn
Subject: [PATCH 6/7] riscv: batch write-protect contiguous PTE ranges
Date: Tue, 21 Apr 2026 17:24:56 +0800
Message-Id: <20260421092457.37649-7-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260421092457.37649-1-cuiyunhui@bytedance.com>
References: <20260421092457.37649-1-cuiyunhui@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hook wrprotect_ptes() into the Svnapot contpte helpers so write
protection can preserve fully covered NAPOT blocks and only unfold
partial ranges at the edges.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++--
 arch/riscv/mm/contpte.c          | 42 ++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 3e6516b5a4587..db82253efb218 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -813,13 +813,30 @@ __ptep_set_wrprotect(struct mm_struct *mm, unsigned long address, pte_t *ptep)
 	 * shadow stack memory is XWR = 010 and thus clearing _PAGE_WRITE will lead to
 	 * encoding 000b which is wrong encoding with V = 1. This should lead to page fault
 	 * but we dont want this wrong configuration to be set in page tables.
+	 * Keep the entry readable when clearing write permissions so we don't create
+	 * an invalid present encoding.
 	 */
 	atomic_long_set((atomic_long_t *)ptep,
-			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
+			(pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) |
+			_PAGE_READ);
 }
 
 #define __ptep_set_wrprotect __ptep_set_wrprotect
 
+static inline void __wrprotect_ptes(struct mm_struct *mm,
+				    unsigned long address,
+				    pte_t *ptep, unsigned int nr)
+{
+	for (;;) {
+		__ptep_set_wrprotect(mm, address, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		address += PAGE_SIZE;
+	}
+}
+
+#define __wrprotect_ptes __wrprotect_ptes
 static inline pte_t __ptep_clear_flush(struct vm_area_struct *vma,
 				       unsigned long address,
 				       pte_t *ptep)
@@ -879,6 +896,8 @@ pte_t napotpte_get_and_clear_full_ptes(struct mm_struct *mm,
 void napotpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 				     unsigned long addr, pte_t *ptep,
 			     unsigned int nr, cydp_t flags);
+void napotpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, unsigned int nr);
 bool napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
 				    unsigned long address, pte_t *ptep,
 			    pte_t entry, int dirty);
@@ -1004,11 +1023,25 @@ static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
 	return napotpte_get_and_clear_full_ptes(mm, addr, ptep, nr, full);
 }
 
+#define wrprotect_ptes wrprotect_ptes
+static inline void wrprotect_ptes(struct mm_struct *mm,
+				  unsigned long address, pte_t *ptep,
+				  unsigned int nr)
+{
+	if (likely(nr == 1)) {
+		napotpte_try_unfold(mm, address, ptep, __ptep_get(ptep));
+		__ptep_set_wrprotect(mm, address, ptep);
+		return;
+	}
+
+	napotpte_wrprotect_ptes(mm, address, ptep, nr);
+}
+
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pte_t *ptep)
 {
-	__ptep_set_wrprotect(mm, address, ptep);
+	wrprotect_ptes(mm, address, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
@@ -1062,6 +1095,7 @@ napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
 #define clear_young_dirty_ptes			__clear_young_dirty_ptes
 #define clear_full_ptes				__clear_full_ptes
 #define get_and_clear_full_ptes			__get_and_clear_full_ptes
+#define wrprotect_ptes				__wrprotect_ptes
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define ptep_set_wrprotect			__ptep_set_wrprotect
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 77c2a4dbd3dda..077ffa49e89d9 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -261,6 +261,30 @@ static void napotpte_try_unfold_range(struct mm_struct *mm,
 	}
 }
 
+static void napotpte_try_unfold_partial(struct mm_struct *mm,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
+{
+	pte_t pte;
+
+	if (ptep != napot_align_ptep(ptep) || nr < napotpte_pte_num()) {
+		pte = READ_ONCE(*ptep);
+		if (pte_present_napot(pte))
+			__napotpte_try_unfold(mm, addr, ptep, pte);
+	}
+
+	if (ptep + nr != napot_align_ptep(ptep + nr)) {
+		unsigned long last_addr;
+		pte_t *last_ptep;
+
+		last_addr = addr + PAGE_SIZE * (nr - 1);
+		last_ptep = ptep + nr - 1;
+		pte = READ_ONCE(*last_ptep);
+		if (pte_present_napot(pte))
+			__napotpte_try_unfold(mm, last_addr, last_ptep, pte);
+	}
+}
+
 void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, pte_t pte)
 {
@@ -485,6 +509,24 @@ void napotpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL(napotpte_clear_young_dirty_ptes);
 
+void napotpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, unsigned int nr)
+{
+	unsigned int i;
+
+	if (!napot_hw_supported() || !mm_is_user(mm)) {
+		for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE)
+			__ptep_set_wrprotect(mm, addr, ptep);
+		return;
+	}
+
+	napotpte_try_unfold_partial(mm, addr, ptep, nr);
+
+	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE)
+		__ptep_set_wrprotect(mm, addr, ptep);
+}
+EXPORT_SYMBOL(napotpte_wrprotect_ptes);
+
 bool napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
 				    unsigned long address, pte_t *ptep,
 				    pte_t entry, int dirty)
-- 
2.39.5

