Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C63A3BCD2C;
	Tue, 15 Sep 2026 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476882; cv=none; b=Zm+5EvRGigJJWwD+DGDW2Uv5zFFwW2y3ymgTJrhVn+sAnuoNitc1zo6MEwm5AmOkAzTNa0kCxqNN9KbOnhUoHm6V6YS+8I7dKH7G+0Z+ShptaiWZo/BEC8ZtW+38JWW/q+bdN4PW/fGXr8gWzRa6cOB82CpRQ92ceDPGpuirunQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476882; c=relaxed/simple;
	bh=OD6lOfDsuQ3Gx0O3nG+lnSFgQ/uCyiBdpWhEzT0xs4w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Aq/6idR+uR1reyRfEwmhhnotd6mpt+r3wIslewq+1R6qWZSFDCqyK0g7xKbcrgwlAUnyAZrk988DvnkeQuCC91u1lDZe/3Znh+si7PjkA168fupoQRRlgPC5eyv37Q8M/mmt5sfJYbuVWI9QwW5pXTupkCe1NuckUNIjmG+Lw3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Qcf3QIz5; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Qcf3QIz5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=06TheYrO+RqVpiOeLZzO2sVZrEIqfAB0lq+jheypzUY=; b=Qcf3QIz55CcoaSldbU3zzTlL9y
	IesoBAEM54qeIhRkKwKFUEMm4nfEKwbtnDTM2Kwd/9YFqHwXxGoIriQlWqoQ7M5qGa7U48T1BTx8M
	DG1/EIn4i/N3wGOau9uP2DnOL3mq9IE36OTH+ACyOXN/gBOSOmzbXk9ZVPvdlo96o0jM8zTSCTRAZ
	w/lj1lQEIxmzspaxPkyvhiAs5vTFOfO4ATfnvHd+Ral4CQZ+gLnhbwATUF1OJc1jr457gY66mVZr9
	AqOKMoDcCVXOb6Tff4axnEA1/l9sQiiL4HEI2zrLGLxVnHMLBEzeJRxf24fQ868QdNF9UqbHy4YMW
	ghNx9N7Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SgG-004P7U-0N;
	Tue, 15 Sep 2026 12:54:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:39 -0700
Subject: [PATCH v5 5/9] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-5-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 hannes@cmpxchg.or, shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=3575; i=leitao@debian.org;
 h=from:subject:message-id; bh=OD6lOfDsuQ3Gx0O3nG+lnSFgQ/uCyiBdpWhEzT0xs4w=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e9fGRdv2ojIBIylpv+WGyoKgen1RPvA/py
 wfutQvXLwSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bcZOD/9tYa5c1xoSwHHUjr+PBSVX2GYqBV2gH0IMO8Np0WO5iyG9Uz1fsyag/5SdmAC3g8xbHCi
 SU49YEZF/BxnxWXcegM8Hq2aRQQ/PsZzDmwpiOVkh1Yd0+m23cgfkxAHTeObj79QrvrpupuB0ZN
 ZfenMCr6f9nmRuuyXJgGAdN3SqmKKkHp/0pLf9jhrJVQppAmkL21OL/dcIL7MUn4ViSzT5ay1rg
 9bKerw/vl7i3oNZKiblmKUgY1iOw28hN1BLbiZ5OJAiotlCciX210WGqifZUCnD8F4v9XbMcL88
 GkxIZrs8wOD30AS0yt1/Hp6DziMWkY2qmOjX+0oLGASCVf77CT1Ki6jFrVtp6AwYJhTqVaTTviz
 VObWrgN1tVtc491/NDobzNW8fcbhu6gPkS6kU9dTdpXBMGlSjBGkdkhrmyZuarbh9+yY4cgwe+6
 lGdYm1vtptAfuVdrjaBkWTSEO0HaYCWL6UfQ1TBPZbU3oPBsjerrrMSO8RiB0OVDgkaTbgFHvMY
 1XsGOXMKOJm1ZBfnZ5E06uWG8cxlbQMS47XSWNyLn95gNQKRh2W9OwNwfvFxN/B5oyjgx0tmbmx
 aeFo0YF6GMWpENLcwZT/pidl1kpqjp6Tc/kh6QxZA3JoXkPIZMg0nTE2piBle5FZW0X0wk4m2kJ
 hAkVzZhu0+0Hnxg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

action_result() is where memory_failure() reports the outcome of a hard
offline, so hook it to set the frame's bit in the
LINUX_EFI_POISONED_MEMORY bitmap.

Soft-offlined pages reach num_poisoned_pages_inc() through
page_handle_poison() and are deliberately left out: they are still
functional and were offlined predictively, so recording them would turn
a prediction into a permanent loss for every kernel further down the
kexec chain.

A bit is only ever set, never cleared, given that multiple pages can set
the same bit, and it is not trivial to decide if the bit should be unset
when a page is unrecorded.

Unpoisoning a frame therefore does not hand its unit back to the next
kernel. That is a known limitation.

memory_failure() has already taken the frame out of this kernel's
allocator, so only the cross-kexec record happens here.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 27 +++++++++++++++++++++++++++
 include/linux/efi.h           |  2 ++
 mm/memory-failure.c           |  3 +++
 3 files changed, 32 insertions(+)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index 3f12db3dc9b844..847592862f01d3 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -91,3 +91,30 @@ void __init efi_poisoned_memory_reserve(void)
 	memblock_add(start, end - start);
 	memblock_reserve(start, end - start);
 }
+
+/* The table, vetted at parse time, or NULL if this boot has none. */
+static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
+{
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return NULL;
+
+	return phys_to_virt(efi.poisoned_memory);
+}
+
+/*
+ * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
+ * unpoison cannot tell whether the unit as a whole is good again.
+ */
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	phys_addr_t addr = PFN_PHYS(pfn);
+	u64 unit;
+
+	if (!pm || addr < pm->phys_base)
+		return;
+
+	unit = (addr - pm->phys_base) / pm->unit_size;
+	if (unit < pm->size * BITS_PER_BYTE)
+		set_bit(unit, pm->bitmap);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index dd3263456dd4a3..56402fdccd1149 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1288,8 +1288,10 @@ struct linux_efi_poisoned_memory {
 
 #ifdef CONFIG_EFI_POISONED_MEMORY
 void __init efi_poisoned_memory_reserve(void);
+void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
 static inline void efi_poisoned_memory_reserve(void) { }
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a2ca8df501caee..d9b8be696aac38 100644
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
@@ -1326,6 +1327,8 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
+		/* Only hard offlines are carried over to the next kernel. */
+		efi_hwpoison_record_pfn(pfn);
 	}
 
 	pr_err("%#lx: recovery action for %s: %s\n",

-- 
2.53.0-Meta

