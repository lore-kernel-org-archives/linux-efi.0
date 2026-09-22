Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72BB576EB7;
	Tue, 22 Sep 2026 17:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098400; cv=none; b=nE16i2PBxEypA3F4x7Nw+Aae8GuReO1lZ8rHjyj83jVag/ZDpOPjYr0WhsQKj4pxk7QWjvUjVX7ElCmNDK9t/pI63H3Lr/jgk+xdgpXZvKMVikJZ/ekpnTYprrJt3LixdN+QuZBr9mc71evVN4VuZeLNU0lr6P+oTz0qfLz/TpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098400; c=relaxed/simple;
	bh=lGoyQT/IUQtR3cNCOID4as8wOLQ/VDmkytsu/6BddYQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FGouXsBvBXPaN4Yy/07B0zDmwBWpccLKRPFQC9mAWkEQoPprPQoVX95NvQsRJ8xSUbHqfR1XbOWM1QfgC4LOtkaiFzvy2xsSAhc1N9qIuoqFA1XUV67EAJyb79qTgY8GuH+liBwOTdOvTj3veF1M1qVFbOTV5vlWET9dykrDBXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=mNoQ9q5B; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="mNoQ9q5B"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85DBA1576;
	Tue, 22 Sep 2026 10:33:05 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9EBCD3F86C;
	Tue, 22 Sep 2026 10:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098389; bh=lGoyQT/IUQtR3cNCOID4as8wOLQ/VDmkytsu/6BddYQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mNoQ9q5BtvoMd+Rw12q0kZB49nZuw7UiCE1KeciQ3TnFAZnWIjbD+UV3pSFN6VIrW
	 HiDynCz+zSRp1JmOxEnCoMWiBzqNZqS42/vU0/wJuCDlZ01zEtC5LxR2cFN0m6O57w
	 DIbzipLnMXJ/EX/qZe4oH777ESIeNsTvQu0X9Inw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:32:00 +0100
Subject: [PATCH v2 5/6] arm64: use HW PTE accessors in early map_range()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-5-a3f1ddff0a8a@arm.com>
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

map_range() uses HW PTE pointers to build early translation tables at
each level. Directly testing, decoding, or assigning *tbl treats an
HW PTE as a SW PTE value, which requires explicit conversion once
hw_pte_t becomes distinct.

Use __ptep_get() to load a SW PTE value for the empty-entry check and
child-table address, and __set_pte_nosync() to convert SW PTE values to
HW PTEs on stores. The no-sync helper performs WRITE_ONCE() without
adding the completion barriers used by __set_pte().

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/kernel/pi/map_range.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
index 94f06da76e333..9c4c8060c5df4 100644
--- a/arch/arm64/kernel/pi/map_range.c
+++ b/arch/arm64/kernel/pi/map_range.c
@@ -51,19 +51,21 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 
 	while (start < end) {
 		u64 next = min((start | lmask) + 1, PAGE_ALIGN(end));
+		pte_t entry = __ptep_get(tbl);
 
 		if (level < 2 || (level == 2 && (start | next | pa) & lmask)) {
 			/*
 			 * This chunk needs a finer grained mapping. Create a
 			 * table mapping if necessary and recurse.
 			 */
-			if (pte_none(*tbl)) {
-				*tbl = __pte(__phys_to_pte_val(*pte) |
+			if (pte_none(entry)) {
+				entry = __pte(__phys_to_pte_val(*pte) |
 					     PMD_TYPE_TABLE | PMD_TABLE_UXN);
-				*pte += PTRS_PER_PTE * sizeof(pte_t);
+				__set_pte_nosync(tbl, entry);
+				*pte += PTRS_PER_PTE * sizeof(hw_pte_t);
 			}
 			map_range(pte, start, next, pa, prot, level + 1,
-				  (hw_pte_t *)(__pte_to_phys(*tbl) + va_offset),
+				  (hw_pte_t *)(__pte_to_phys(entry) + va_offset),
 				  may_use_cont, va_offset);
 		} else {
 			/*
@@ -81,7 +83,8 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 				protval &= ~PTE_CONT;
 
 			/* Put down a block or page mapping */
-			*tbl = __pte(__phys_to_pte_val(pa) | protval);
+			entry = __pte(__phys_to_pte_val(pa) | protval);
+			__set_pte_nosync(tbl, entry);
 		}
 		pa += next - start;
 		start = next;

-- 
2.47.3

