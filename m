Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B28F47799D;
	Fri, 16 Oct 2026 12:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153021; cv=none; b=MLkv2VhXIetaPk0v1d7CJY1SAEZ0KdaSUZe4wgWAw0QO/JST3T0e1gUaxDNk/sEsEpiJiy7Ri68B8Ausq5N1tkgX0N1ioFw6v7LOfJBYr6cqOq4yGgO37DCs9ZR8O9R62OYSoW/AC4Am4qZYH6VHRu7GsTRaErPQYURVg6tm+YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153021; c=relaxed/simple;
	bh=SBhhKTkaRHyX1GAyy8PMkoGcpH3NzvKmmkEdQFwHE8s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sbIYinzq9ls6U+Tc2D2+oSEJpblM72j1AJeYF2N2eGfklYV8T+mtgNRUV9JPDGMlPkFrJtUgvP2DUj/AYyBTGn/sQuilfzN0f+g08jf9pe6zegIrE16CC0rdnXvolgOxkg2ONV6LhYy+1nka/uqF2rP2ekLqu5jNFvy8KtsMFns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=WAgaUL+g; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="WAgaUL+g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ROmo/VbuKtcX0poOX7UbrOJdgEcyV6UWD4h0M1KsHMY=; b=WAgaUL+grMEMT1FcLzjc197iQO
	HoDsSJltoVCJBeo1Ik4GbA0vgHQhdZu4pmHBOSmnbEt/NOduNTa4BeP8SJUrvwvpxuo+h2IdiTcxU
	KTesb5f8u7Oa3CFOLFq/MrBj5MsKn2O1qS6iPkAqQJmli2jOoQS8WXJ9YP+Cn5X9IA98tHCM1V+8q
	b7a0P5onSnBYTfuN43gPO7fTanUXllAYO7YKyRwcuT2g/mepu7ih5IM9A3Dy5SGwDqA3zYdgrHw04
	bl/U11WdtD0uog/w1Qz9C2TP07ar74x5CSqKgMC9+39c8umLtz3covUM28HgmClBHv2Ls0kMpJbe/
	6KOJXsmg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrj-005xUr-1W;
	Fri, 16 Oct 2026 12:16:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:47 -0700
Subject: [PATCH v6 7/7] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-7-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=11890; i=leitao@debian.org;
 h=from:subject:message-id; bh=SBhhKTkaRHyX1GAyy8PMkoGcpH3NzvKmmkEdQFwHE8s=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0tzL5+ezl9xhLzUMq3OAEA0tEafBgnFPDw
 FdZN1Pwoa2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bQdUEACA8Y5MRXLL76J6ikzWB06LLym/d6Sp/ikm9MYeKBLAF5+R3EjkkeBMe/vkD9xmK0bsyx1
 I2q+OKhauwGst628sANSviBUe4vlMSrGZt+pg4sDJLSRTBW2Ia4jmvQgap3ObO0uhjaauzdPoLd
 gbxOvcuFHFK2TX+8rZKTvzjhzN/MHLfC3EzzFEE5U79Cy1Xh9tMDKBVN5KsHCdEtnfj6jy1JfGz
 HaFn35nDfiSf9Xthwwz/ychaOzIKnxjd0Ge3FWOifdK1Emt1Mt756aSl7Yn/IORTwnbDwiwedyu
 K6ujSdgEqLZQphEWIsYgTSIjrQ5ML8+gT8Ge7LsX9upac0UIrDnMBDUwBgO52krW99mFQYtGv0z
 mdFlzjkE63f8AOO5F0IN9A7p5ze2f057llFvNwJjjlsjZeDa/UPUS7zUM1H3qeJNm9uXV1EIe4U
 hwlFQshDfusCAFV4Fon2Xk/YHyu8uDfk2A5fPhxOPPKjwvDMCGjxp+xqMsxQpgGl02meVqst9Rw
 36tcqCDyFv3+0gVrDFVRvpduKPFrH6pYJsx1NNRamSD4b+ZAHlLGcIdOX4LwPJe1V61YwN+E55u
 jGvquIXgFR37DW3YdP8W/vaUD5l7gXtny2tpS+AoKg6Q1tdwKfF3cH+82qWzu9oRfPK3Hzq3osY
 lEYVFJgq/ZLtDZg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When memory_failure() reports the outcome of a hard offline, set the
frame's bit in the LINUX_EFI_POISONED_MEMORY bitmap, so that the next
kernel reserves its unit.

Hook action_result() ahead of the statistics guard. A hard error on a
frame that was soft-offlined earlier comes in as MF_MSG_ALREADY_POISONED,
which skips the statistics, but it is a real failure and has to be
recorded. MF_MSG_PFN_MAP is left out, as it is not System RAM.

A bit is only ever set, never cleared (for now). Several frames share
a bit, and an unpoison cannot tell whether the unit as a whole is good
again. That is a known limitation.

The table is mapped with memremap() from an early_initcall rather than
through the direct map. On arm64, mem= and the usable memory range of a
crash kernel trim memblock, which drops the table's pages from the direct
map, and the first recorded error then faults.

Recording is skipped on a host with SME active. The stub writes the table
in the clear, so reading it back there needs a decrypted mapping. That is
left for a follow up.

memory_failure() has already taken the frame out of this kernel's
allocator, so only the cross-kexec record happens here.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 69 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |  2 ++
 mm/memory-failure.c           | 53 ++++++++++++++++++---------------
 3 files changed, 101 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index fa84df55aeb469..4bb56865551224 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -11,12 +11,14 @@
 #define pr_fmt(fmt) "efi: " fmt
 
 #include <linux/bitmap.h>
+#include <linux/cc_platform.h>
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/overflow.h>
+#include <linux/uaccess.h>
 
 static bool __init
 efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
@@ -172,3 +174,70 @@ void __init efi_poisoned_memory_reserve_units(void)
 
 	efi_poison_reserve_units(efi.poisoned_memory, &efi_poison_hdr);
 }
+
+static struct linux_efi_poisoned_memory *efi_poison_table __ro_after_init;
+
+static bool __init efi_poison_mapped(const void *map, size_t len)
+{
+	const void *end = map + len;
+	const void *p;
+	u64 val;
+
+	for (p = map; p < end; p = PTR_ALIGN_DOWN(p, PAGE_SIZE) + PAGE_SIZE)
+		if (copy_from_kernel_nofault(&val, p, sizeof(val)))
+			return false;
+
+	return true;
+}
+
+static int __init efi_poisoned_memory_map(void)
+{
+	struct linux_efi_poisoned_memory *hdr, *table = NULL;
+	size_t len = 0;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	/*
+	 * The stub writes the table in the clear, so an SME host needs a
+	 * decrypted mapping. Skip such hosts for now.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT)) {
+		pr_warn("SME is active, poisoned frames are not recorded\n");
+		return 0;
+	}
+
+	hdr = memremap(efi.poisoned_memory, sizeof(*hdr), MEMREMAP_WB);
+	if (hdr) {
+		if (efi_poison_mapped(hdr, sizeof(*hdr)))
+			len = sizeof(*hdr) + hdr->size;
+		memunmap(hdr);
+		if (len)
+			table = memremap(efi.poisoned_memory, len, MEMREMAP_WB);
+	}
+	if (table && !efi_poison_mapped(table, len)) {
+		memunmap(table);
+		table = NULL;
+	}
+	if (!table)
+		pr_warn("Could not map poisoned-memory table, poisoned frames are not recorded\n");
+	efi_poison_table = table;
+
+	return 0;
+}
+early_initcall(efi_poisoned_memory_map);
+
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poison_table;
+	phys_addr_t addr = PFN_PHYS(pfn);
+	u64 unit;
+
+	if (!pm || addr < pm->phys_base)
+		return;
+
+	/* unit is the bit we are going to set in the bitmap */
+	unit = (addr - pm->phys_base) / pm->unit_size;
+	if (unit < pm->size * BITS_PER_BYTE)
+		set_bit(unit, pm->bitmap);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 396e0d61112205..259e64467ed1ba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1289,9 +1289,11 @@ struct linux_efi_poisoned_memory {
 #ifdef CONFIG_EFI_POISONED_MEMORY
 void __init efi_poisoned_memory_reserve(void);
 void __init efi_poisoned_memory_reserve_units(void);
+void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
 static inline void efi_poisoned_memory_reserve(void) { }
 static inline void efi_poisoned_memory_reserve_units(void) { }
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d0d6b184ee469f..c95b0be04a0cf8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -43,6 +43,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/dax.h>
+#include <linux/efi.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
@@ -1327,10 +1328,16 @@ static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
 static int action_result(unsigned long pfn, enum mf_action_page_type type,
-			 enum mf_result result)
+			 enum mf_result result, int flags)
 {
 	trace_memory_failure_event(pfn, type, result);
 
+	/*
+	 * An error injected by software is not a hardware fault, leave it out.
+	 */
+	if (type != MF_MSG_PFN_MAP && !(flags & MF_SW_SIMULATED))
+		efi_hwpoison_record_pfn(pfn);
+
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
@@ -1346,7 +1353,7 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 }
 
 static int page_action(struct page_state *ps, struct page *p,
-			unsigned long pfn)
+			unsigned long pfn, int flags)
 {
 	int result;
 
@@ -1358,7 +1365,7 @@ static int page_action(struct page_state *ps, struct page *p,
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
 
-	return action_result(pfn, ps->type, result);
+	return action_result(pfn, ps->type, result, flags);
 }
 
 static inline bool PageHWPoisonTakenOff(struct page *page)
@@ -1731,7 +1738,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 }
 
 static int identify_page_state(unsigned long pfn, struct page *p,
-				unsigned long page_flags)
+				unsigned long page_flags, int flags)
 {
 	struct page_state *ps;
 
@@ -1750,7 +1757,7 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 		for (ps = error_states;; ps++)
 			if ((page_flags & ps->mask) == ps->res)
 				break;
-	return page_action(ps, p, pfn);
+	return page_action(ps, p, pfn, flags);
 }
 
 /*
@@ -2144,16 +2151,16 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
-		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED, flags);
 	case MF_HUGETLB_FOLIO_PRE_POISONED:
 	case MF_HUGETLB_PAGE_PRE_POISONED:
 		rv = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			rv = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_PAGE_PRE_POISONED)
-			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED, flags);
 		else
-			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED, flags);
 		return rv;
 	default:
 		WARN_ON((res != MF_HUGETLB_FREED) && (res != MF_HUGETLB_IN_USED));
@@ -2185,17 +2192,17 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 		} else {
 			res = MF_FAILED;
 		}
-		return action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return action_result(pfn, MF_MSG_FREE_HUGE, res, flags);
 	}
 
 	page_flags = folio->flags.f;
 
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		folio_unlock(folio);
-		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
+		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED, flags);
 	}
 
-	return identify_page_state(pfn, p, page_flags);
+	return identify_page_state(pfn, p, page_flags, flags);
 }
 
 #else
@@ -2247,7 +2254,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);
 	if (rc != -EOPNOTSUPP)
-		action_result(pfn, MF_MSG_DAX, rc ? MF_FAILED : MF_RECOVERED);
+		action_result(pfn, MF_MSG_DAX, rc ? MF_FAILED : MF_RECOVERED, flags);
 	return rc;
 }
 
@@ -2390,7 +2397,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
 		}
 
 		if (!mf_handled)
-			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED);
+			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED, flags);
 	}
 
 	/*
@@ -2403,7 +2410,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
 
 	kill_procs(&tokill, true, pfn, flags);
 
-	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
+	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED, flags);
 }
 
 /**
@@ -2490,7 +2497,7 @@ int memory_failure(unsigned long pfn, int flags)
 			res = kill_accessing_process(current, pfn, flags);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(p);
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED, flags);
 		goto unlock_mutex;
 	}
 
@@ -2521,9 +2528,9 @@ int memory_failure(unsigned long pfn, int flags)
 				}
 				res = MF_FAILED;
 			}
-			res = action_result(pfn, MF_MSG_BUDDY, res);
+			res = action_result(pfn, MF_MSG_BUDDY, res, flags);
 		} else {
-			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED, flags);
 		}
 		goto unlock_mutex;
 	case 1:
@@ -2535,11 +2542,11 @@ int memory_failure(unsigned long pfn, int flags)
 		 * slab, page tables, large-kmalloc).
 		 * No recovery possible.
 		 */
-		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED, flags);
 		goto unlock_mutex;
 	default:
 		/* Transient lifecycle race with the page allocator. */
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED, flags);
 		goto unlock_mutex;
 	}
 
@@ -2587,7 +2594,7 @@ int memory_failure(unsigned long pfn, int flags)
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED, flags);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -2641,7 +2648,7 @@ int memory_failure(unsigned long pfn, int flags)
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
-		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
+		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED, flags);
 		goto unlock_page;
 	}
 
@@ -2650,12 +2657,12 @@ int memory_failure(unsigned long pfn, int flags)
 	 */
 	if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
 	    folio->mapping == NULL) {
-		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED, flags);
 		goto unlock_page;
 	}
 
 identify_page_state:
-	res = identify_page_state(pfn, p, page_flags);
+	res = identify_page_state(pfn, p, page_flags, flags);
 	mutex_unlock(&mf_mutex);
 	return res;
 unlock_page:

-- 
2.53.0-Meta

