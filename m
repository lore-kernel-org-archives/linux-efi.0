Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95C4476694;
	Mon, 14 Sep 2026 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393946; cv=none; b=q2xea+M38vjpevWnT0WpoifyIIJPI5TCBCZILblzWN6X7k9BhZfSBfwYUZBB+Hvf9XO673yqE2KJ0gOEqDtx/sTq+2socQhYG0mY4t8fZxoMedJvAx8snc1ixXJPrsoL5dCkxLVw6kpzbKl79zbYcLbIcLeFKFknVsEoaMlc03c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393946; c=relaxed/simple;
	bh=M/GSINSwm6+Et2eyJmmD/tFqPTuI/A1b5T1YgKWiL9c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=f3RR5EhxxuRy2l8CMbiZ9tRm0B7eoknz9/4ybqJB/OV/zCL7FnT48QSEGtzssF5+3BGVajXmbpzMJHcxHctZHF7Vwp1d/e8mTqutMP6IqLa6Deb0eDa9jJzQITRo9TvtmVdHO713eeJko8fN/d4fJjkmY0si+2rO9jfPyRJG4IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l1MXFaUt; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l1MXFaUt"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60C4B1576;
	Mon, 14 Sep 2026 06:52:19 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1F373F882;
	Mon, 14 Sep 2026 06:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393943; bh=M/GSINSwm6+Et2eyJmmD/tFqPTuI/A1b5T1YgKWiL9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=l1MXFaUtsScvaXSmDpLzKQ0x5H2a0xG7fjpv0PnXJZhfGml/cb2/NWB6wiGm/2m/W
	 HbtYIf5YprgsmmREN4DpnnSbzRTpl0G8iRLXXwXoBcCYEWBUBfax0si2I2ttMOWuCI
	 JgPXqqlaUmx6uMk6xS6A4rRtyvVaJNKnNht1RaJ0=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:35 +0100
Subject: [PATCH 5/6] arm64: use HW PTE accessors in early map_range()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-5-bb53b663e396@arm.com>
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

map_range() uses HW PTE pointers to build early translation tables at
each level. Directly testing, decoding, or assigning *tbl treats an
HW PTE as a SW PTE value, which requires explicit conversion once
hw_pte_t becomes distinct.

Use __ptep_get() to load a SW PTE value for the empty-entry check and
child-table address, and __set_pte_nosync() to convert SW PTE values to
HW PTEs on stores. The no-sync helper performs WRITE_ONCE() without
adding the completion barriers used by __set_pte().

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

