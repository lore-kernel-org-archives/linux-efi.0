Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911F44756B2;
	Mon, 14 Sep 2026 13:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393939; cv=none; b=TosDnN680UH0da8/448H9SPdHlP4mu27h4gXd34r1qqARAusnTZxd2SXwAkMGfmtdIIFukLgAOyOLep4bipBz/jZ+eN7ukfHOjICgUXkzNz9f0KcO1oiaAqTTXwqFPTUjoDMNSqGRsfSwHyTL4LXp3nL/SXnVrVKTYZrhxIBFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393939; c=relaxed/simple;
	bh=yv6552mFvvf13JAoUBxhYSH5LMmG+s9tUQsoS51fbNQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XcFxomNRj+wHOVEUmA4MdMzqK7d0rPfyZhQ4Co5l+Rh/K+HdCQbanjaf/yawhPMXxbTMoIuqFa90cgNOSedWcxAIFKXoFxa/NQ5vRam9vVIeKiLuy7WuUP7x8Zw9OQCFf4veTIUKqCGWPOYwMwAQSPp5xb/1QWuIcNUFZJrKnyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gzbKM8Ca; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gzbKM8Ca"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 544C41576;
	Mon, 14 Sep 2026 06:52:12 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B236F3F882;
	Mon, 14 Sep 2026 06:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393935; bh=yv6552mFvvf13JAoUBxhYSH5LMmG+s9tUQsoS51fbNQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gzbKM8Ca28zZ5K6P5ERV+/fCGpEVK/cv9jlKFw2gr9//PfYHgZprGWfo191uCCc6z
	 Cf7m0v8/apWMpqmmgMHBA6J9VkXnoRe1GIpcuZ12FSGnPYjHDPuGZmC5Cob7BBesv6
	 pyrAeo+x1fR1GNNgGI02k3iSQRVZhxr9ZAy5zTgQ=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:33 +0100
Subject: [PATCH 3/6] arm64: convert between HW PTEs and SW PTE values
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0

__ptep_get() returns a SW PTE value, and __set_pte_nosync() accepts one.
When HW PTEs use a distinct hw_pte_t, directly reading or writing *ptep
as a SW PTE value no longer satisfies those interfaces.

Use __pte_from_hw after READ_ONCE() to obtain a SW PTE value and add
__hw_pte before WRITE_ONCE() to form an HW PTE.

Define __hw_pte for both the wrapper and alias configurations so the
same accessor code works in either case.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 include/linux/pgtable_types.h    | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4768ec59de555..67c4a6179e154 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	WRITE_ONCE(*ptep, __hw_pte(pte));
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte_from_hw(READ_ONCE(*ptep));
 }
 
 extern void __sync_icache_dcache(pte_t pteval);
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index ee4eace5c3e1c..b5862a16aa497 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -9,11 +9,13 @@
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
 #define __pte_from_hw(pte)	((pte).__pte)
+#define __hw_pte(pte)  ((hw_pte_t) { (pte) })
 
 #define hw_pte_val(x)  pte_val((x).__pte)
 #else
 #define hw_pte_t pte_t
 #define __pte_from_hw(pte)	(pte)
+#define __hw_pte(pte)  (pte)
 
 #define hw_pte_val(x)  pte_val(x)
 #endif

-- 
2.47.3

