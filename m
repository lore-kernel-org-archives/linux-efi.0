Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC60544D73;
	Tue, 22 Sep 2026 17:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098395; cv=none; b=E9r9/CMIMvepfvfUVN/BorgJlVwpXeDtdGIuLW6qIWyW5aD1kyAnKBFxiYGQA2tb5xZselRfysqYPXKsdGXpvwGsf23VYTzzOjNC3yWoXtQtecWNaYcNt3spati/URMBiDoKJKTgUdOyu+YO5zqMFQSmV2Uyg2rVL1f5C3dMYJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098395; c=relaxed/simple;
	bh=shLHKCHn3ZdXre7hsjCS5Jwr6cqRreukZfraeH8Cy3s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cK8QUj+MF2hzlH8TdikRF2/iuWs3PTWrPsxVpOsT0ijWxYfkBdWdQRMo045StzJOe3DoTDra2KOH71RLAkEpNIF0pENhxiY4Jjxt7vA58m33zy5qAcvPAVVuR4IG154mXdMrD7P4ZEEGCAtPTYsTtwwOoa2itSQ8HqTo++jlCP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SgM0Qx+n; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SgM0Qx+n"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4C601595;
	Tue, 22 Sep 2026 10:33:01 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD49E3F86C;
	Tue, 22 Sep 2026 10:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098385; bh=shLHKCHn3ZdXre7hsjCS5Jwr6cqRreukZfraeH8Cy3s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=SgM0Qx+n9SIyEwK6aMAq6Ppwz1dhcVVmU+Lr/ToZEX+hmzKievt4rrjFlrNonyWHj
	 Kx0OuVjhvw7BEYioGKvMfa7FL7lAcKc8dmLMmbyM40JqkH/qOYzITwD4t/d5FVCOgL
	 ym3nNFw6xAU08NSMAjwa2v6IMkLgy4NQLbeBKLcY=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:31:59 +0100
Subject: [PATCH v2 4/6] arm64: use hw_pte_t for fixmap HW PTEs
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-4-a3f1ddff0a8a@arm.com>
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

fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
installs those arrays as page tables. Their elements are therefore
HW PTEs.

Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
pointers returned and passed to the accessors. This is needed before
ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
array dimensions and placement are unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/mm/fixmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index 237a9136bc73b..709a97fe327d8 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
 
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
-static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
+static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
 static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
 

-- 
2.47.3

