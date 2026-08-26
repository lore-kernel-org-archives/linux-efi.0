Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7594D3FA5F1;
	Wed, 26 Aug 2026 12:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745904; cv=none; b=Jyv4gaZjmiyMK4xj3aV37eYDZy63z8qnmdtS1/g1hoVPeZDMe0CuuS371iYlmz1CZpGjQ9o107Ak9cDy0umAs3HUvX9Kqm1G3BFB6C58npvEnRPIKWJmDWACnX3ApeLZgpHFJSlMRDFBTPNOaPMS0YlOrvRIstPwL+HmZ3i3AKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745904; c=relaxed/simple;
	bh=UoMzb64e2RlMzQ3LgVqhH1IIBLhMvJk/4Xuo1bCJkZY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G93nDfcKwMjCITp/HcIA4i8bdv3cCmH4cF8p5AA/7X2R+LlVzfbS9Jgi5FRY6shGKxWCKFvzNv3d48rWFCLB9TYdDu1azBbKEw0yTo513GuG55yi4w+a6O/tHULAcZdXzfvqwDp5Lg8EHCtt9zZBCgFlZDFw2JE5n8JN7u5C5h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=LkUh0EPQ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="LkUh0EPQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7xslyR078ZQa9uWsN28A/GTFrLCow8t/z01YQTIpb9Q=; b=LkUh0EPQg0YWEV+OVhhL9JVar1
	+errUwJd89Jlfz9ZJ0e9fwczcl1eiXAOCjKm2dAVkwISXn/QCAbRUtMikpoexLaNG0LyOYkco7bxD
	gd46v+RNkPwwuVsi729M1C/LlE/5YMDSfW6zjA/+RbGyPuIYzS30Z4cS/RWBBj2GFzrWULotAXkgx
	E03T0r5DlUvwsqPviw8AQ+wKyxf/YtUE6VhFDflHxVxEiyU8xfWaMQ9bpVikanWkjfbxcgU/IFlJU
	dz9F3mtydsPnNG95Si5m6UR0jEludb/lwOWE34uWXrb+QAodQidP+/4NACd0caC6UmRv5JTOgeHUW
	P0bv+opA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCNI-00FCY0-12;
	Wed, 26 Aug 2026 12:05:00 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:56 -0700
Subject: [PATCH v3 5/5] mm/memory-failure: efi: replay the poisioned page
 in the next kernel
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
In-Reply-To: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
 kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=6726; i=leitao@debian.org;
 h=from:subject:message-id; bh=UoMzb64e2RlMzQ3LgVqhH1IIBLhMvJk/4Xuo1bCJkZY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZLCwO1oNCTElS8ix1B3HUNJcnZq769xR1lZ
 JL5PIiU4FSJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSwAKCRA1o5Of/Hh3
 bbVRD/9Iw/LK/BjUim0dpaiQgKRZZ1f8xiftwNTEtyL3fOd0n8rJfhNNwI3sYHq4gVE284XOr0D
 HGbW/hOAUuLhRJmxMLt1Qil0zrEugzPTWrqr/cjzKoc9ga5RFlLqyWgh8m20KaN/vPRotaDgD7z
 lkFCuSvCi0Zz4XeMNR7NwjzbHxsvBKDUMUzHu2Z/+/Z0sHYuVy/Lpweceyw9VkmWvcAdtRQIEP3
 zHv3ZzSeSWh57EEBZFbzvhgRcdsZK+5BCsafGwfZKZNrnyKq+UNWyoQL8IFc49096PwDyb8Vv7H
 h02yYRlRPK3SX7oy0qGdgUsbZnVwq/6cmVZRWYlo6awU5x0wnGxtBq4GFd0w2KgTmd90Tm1xb+x
 t9mJyuJx5cO2t9vbna97j/R/7WumGlKZ26f/PCpNoz3qdeItgOtm2T5p1jodiaHCs9pT3j5H43H
 oxqhKoT4dWSwszAA15pdvAfbCyBj/8hRGSnLgzY6/pMMCMdrDV17a98RuEVN1CmauiQM62VLNm+
 y0mwHb+CUzJEBpngUcZl8El7meotwtiqRQSmfXv92H0N92WqAq/fHk9IRU4FxUfxQjdInJhBcc0
 eiLHKoWhcTngSyZLgxzqcTLu8udSaoB9BmQ89+JfzcASGwJvZZSnmWNkWamlwIqRY+mmUXp2jgA
 SjD/FL4O6CUk1lQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The bitmap an earlier kernel filled in rides the EFI system table into
this one, but nothing reads it back until now.

Add efi_offline_poisoned_memory(), which vets the table header, copies
the geometry out of it, and hands every frame of every set unit to
hwpoison_boot_pfn(). The bitmap runs to megabytes on a large machine, so
it is mapped and walked a page at a time rather than in one go.

Call it through hwpoison_init_boot() from mm_core_init() right after
memblock_free_all(), the first point at which the recorded frames have
struct pages. They end up in the state a frame poisoned by this kernel
would be in, so the placement check that already understands PG_hwpoison
covers them too.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 113 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/efi.h           |   2 +
 include/linux/mm.h            |   5 ++
 mm/memory-failure.c           |   6 +++
 mm/mm_init.c                  |   1 +
 5 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index d6855e712832c..179843277457f 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -9,14 +9,20 @@
 
 #define pr_fmt(fmt) "efi: " fmt
 
-#include <linux/bitmap.h>
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/log2.h>
 #include <linux/memblock.h>
+#include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/overflow.h>
 
+struct efi_poison_geometry {
+	u64 table;		/* phys address of the table */
+	u64 unit_size;
+	u64 bitmap_size;
+};
+
 static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
 static u64 efi_poison_nbits __ro_after_init;
 
@@ -124,3 +130,108 @@ void efi_hwpoison_record_pfn(unsigned long pfn)
 
 	set_bit(unit, efi_poison->bitmap);
 }
+
+static bool __init efi_poison_read_geometry(u64 ppm,
+					    struct efi_poison_geometry *g)
+{
+	struct linux_efi_poisoned_memory *pm;
+	bool valid;
+
+	pm = early_memremap(ppm, sizeof(*pm));
+	if (!pm) {
+		pr_warn("Could not map poisoned-memory table\n");
+		return false;
+	}
+
+	valid = efi_poison_table_valid(pm);
+	if (valid) {
+		g->table = ppm;
+		g->unit_size = pm->unit_size;
+		g->bitmap_size = efi_poison_usable_size(pm);
+	} else {
+		/* Keep the runtime side off a table this pass rejected. */
+		efi.poisoned_memory = EFI_INVALID_TABLE_ADDR;
+	}
+
+	early_memunmap(pm, sizeof(*pm));
+
+	return valid;
+}
+
+static unsigned long __init
+efi_poison_offline_unit(const struct efi_poison_geometry *g, u64 unit)
+{
+	unsigned long pfn = PHYS_PFN(unit * g->unit_size);
+	unsigned long i, nr_pages = 0;
+
+	for (i = 0; i < g->unit_size >> PAGE_SHIFT; i++)
+		nr_pages += hwpoison_boot_pfn(pfn + i);
+
+	return nr_pages;
+}
+
+static long __init efi_poison_walk_chunk(const struct efi_poison_geometry *g,
+					 u64 off, unsigned long *nr_units)
+{
+	u64 chunk = min_t(u64, PAGE_SIZE, g->bitmap_size - off);
+	unsigned long bit, nbits = chunk * BITS_PER_BYTE;
+	unsigned long *map, nr_pages = 0;
+
+	map = early_memremap(g->table + offsetof(struct linux_efi_poisoned_memory,
+						 bitmap) + off, chunk);
+	if (!map)
+		return -1;
+
+	for_each_set_bit(bit, map, nbits) {
+		nr_pages += efi_poison_offline_unit(g, off * BITS_PER_BYTE + bit);
+		(*nr_units)++;
+	}
+
+	early_memunmap(map, chunk);
+
+	return nr_pages;
+}
+
+static long __init efi_poison_walk(const struct efi_poison_geometry *g,
+				   unsigned long *nr_units)
+{
+	unsigned long nr_pages = 0;
+	u64 off;
+
+	for (off = 0; off < g->bitmap_size; off += PAGE_SIZE) {
+		long nr = efi_poison_walk_chunk(g, off, nr_units);
+
+		if (nr < 0) {
+			pr_warn("Could not map poisoned-memory bitmap\n");
+			return -1;
+		}
+		nr_pages += nr;
+	}
+
+	return nr_pages;
+}
+
+void __init efi_offline_poisoned_memory(void)
+{
+	struct efi_poison_geometry g;
+	unsigned long nr_units = 0;
+	long nr_pages, expected;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return;
+
+	if (!efi_poison_read_geometry(efi.poisoned_memory, &g))
+		return;
+
+	nr_pages = efi_poison_walk(&g, &nr_units);
+	if (nr_pages < 0)
+		return;
+
+	if (nr_pages)
+		pr_info("poisoned %ld page(s) inherited across kexec\n", nr_pages);
+
+	expected = nr_units * (g.unit_size >> PAGE_SHIFT);
+	if (nr_pages < expected)
+		pr_warn("%ld inherited poisoned page(s) could not be taken out of use\n",
+			expected - nr_pages);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d579d75372248..03ba40ff70e7e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1285,8 +1285,10 @@ struct linux_efi_poisoned_memory {
 #define EFI_POISON_UNIT_SIZE	SZ_2M
 
 #ifdef CONFIG_EFI_POISONED_MEMORY
+void efi_offline_poisoned_memory(void);
 void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
+static inline void efi_offline_poisoned_memory(void) { }
 static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 52a00a0e090c7..092220943531e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5104,12 +5104,17 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+void __init hwpoison_init_boot(void);
 bool __init hwpoison_boot_pfn(unsigned long pfn);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
 
+static inline void hwpoison_init_boot(void)
+{
+}
+
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 713fb2f8e0332..1d6a472267bdb 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -121,6 +121,12 @@ bool __init hwpoison_boot_pfn(unsigned long pfn)
 	return true;
 }
 
+/* The EFI table is the only source of inherited poison today. */
+void __init hwpoison_init_boot(void)
+{
+	efi_offline_poisoned_memory();
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.
diff --git a/mm/mm_init.c b/mm/mm_init.c
index ddda9d6837f32..f94fa221da0b8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2667,6 +2667,7 @@ void __init mm_core_init(void)
 	kho_memory_init();
 
 	memblock_free_all();
+	hwpoison_init_boot();
 	mem_init();
 	kmem_cache_init();
 	/*

-- 
2.53.0-Meta

