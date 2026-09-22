Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CA0252268A;
	Tue, 22 Sep 2026 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098391; cv=none; b=E0MhHNBelC1EPTU3e++yIfyLmK9Z/VdxjpiXJuWL5L0zE+m49NIF3uaTJIAic2lnqOvaFe+I8yR+KuvEINwyupNLZRv6uCzhVj1ZtuzF4iIbg4oMeMG66y4TMx42GUKnx7SrbY2wzGWsiGJu/s+/3klya6TH3dfjjrND53vM5aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098391; c=relaxed/simple;
	bh=67NvP4PmpCnowWkBeuojZg3SSMqBMwtXDXBIbaFjYiY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=uHwq+7aCuo45ROmWiI7pMvoBq3Kz6aezIBYKao3qQjX8cuTuFrf36vCYU0RADACHzgRXR81V9vSNn1LBzEJYvGtIkes6ZvxGt3gStGEzRoyb7NOtUAyEgsd8oISKF/iWBRH6ZAX3Ev5X0z9F/GDwpa+wxfCfsbjvCXTqQBD0IcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DgfsXpYX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DgfsXpYX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F2AC1AED;
	Tue, 22 Sep 2026 10:32:58 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 269643F86C;
	Tue, 22 Sep 2026 10:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098381; bh=67NvP4PmpCnowWkBeuojZg3SSMqBMwtXDXBIbaFjYiY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DgfsXpYXf+AULhg9SSync9g0KRdJYDwFtPkkElJ/a+wWRq0XRp4XhA/+AQcIjVicE
	 yO9uEDNDRHS6qYUxgDmH4JNy09PlmpfEqfv0MLS+ymlFYbWBDTSK3ieWYmPBLASNUU
	 5DDokOnKTfjJP4/bugtIcH+JIC+awj5G0TJ4BSC4=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:31:58 +0100
Subject: [PATCH v2 3/6] arm64: use hw_pte_val for HW PTE loads and stores
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-3-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
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

__ptep_get() returns a SW PTE value, while __set_pte_nosync() accepts
one. When HW PTE storage uses a distinct hw_pte_t, reading or writing
*ptep as a pte_t no longer satisfies those interfaces.

Use hw_pte_val() to expose the pteval_t stored in either the hw_pte_t
wrapper or its pte_t alias. __set_pte_nosync() writes pte_val(pte) to
that storage, while __ptep_get() reads it and reconstructs a pte_t with
__pte().

This avoids imposing a generic conversion interface between HW and SW
PTE representations, which may require architecture-specific context
in the future.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4768ec59de555..ce6580ab63128 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 
 static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pte);
+	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));
 }
 
 static inline void __set_pte_complete(pte_t pte)
@@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
 
 static inline pte_t __ptep_get(hw_pte_t *ptep)
 {
-	return READ_ONCE(*ptep);
+	return __pte(READ_ONCE(hw_pte_val(*ptep)));
 }
 
 extern void __sync_icache_dcache(pte_t pteval);

-- 
2.47.3

