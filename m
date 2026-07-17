Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFB4429034;
	Fri, 17 Jul 2026 14:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297014; cv=none; b=pE7/T5UaVS6U+vU9M9Hg97sNDY41Nc/Vox22fQQEm/sWTjJkPxpsYdLOG8snUc5coLIcoKQJX+VatqNujFjjgit+5XWLICSPqN2HTpZUOxla1QtXsPy/78lhwzU5r5qLy/Q2+7xjIFIZ3quMTjIlUZ3h6kNU7utk7cTfkYkaBuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297014; c=relaxed/simple;
	bh=tVC3qjK2uT7R1b63jjn7gm8DEZPWnfi5O6+kdXwvQWg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CkYhY5kwr6j9pfOWViXtVgDQYGadwx2xpVXc8vKj2/sSjRkLjMKa0Ny0dJwxGrw7Ul9bfDvCkVIvCe0UAT98G4qAqRFoOcaUcBcW0WwEDjQsRpqVFTmQoYwQiAYOZhGYArS5tQavpw7kQf5rGlUZ6HHr59FFafVShhd3ar2bIkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=CPkUm7bE; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="CPkUm7bE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=xLHoBAC97Z8vKvZnpYvz5TMDtvC87jPH3QPXAp2zb00=; b=CPkUm7bEgxpkSeb9CZM34STENE
	FEXFrMiLbqKqbQABw1a/ozpsCYvZLgSLBRYdYqlFsBr09VW9cUWfFT7CFSi4kTttCFlXg5nwKHMmi
	LRH9CYsQKiO0KxpvaguyUakbKFDOF8r2//psUz6RR6eqGnt6VqRf/mBewEuoVeDYgVfyZjn5opo/P
	mDw0d45oUXZAxTxvTuTwzfA1pJ4IUwWUudi8z9bf2bCSb6xeROtf2ulEnAdRifKoD6uuL3p+T3CBQ
	FbdJUWSQcHTcJ0tKqKuik74juD7Z3f0msS1gC2SDDLkDujpZDaq5ry1Y0nK4iNIlwZXnqGJNA46nm
	F2v3ED1A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wkjA2-004eC1-01;
	Fri, 17 Jul 2026 14:03:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 17 Jul 2026 07:03:04 -0700
Subject: [PATCH RFC 2/3] efi: record hardware-poisoned frames into the
 poisoned-memory table
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-hwpoison-kho-v1-2-9c5eda551998@debian.org>
References: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
In-Reply-To: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
To: kas@kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, rneu@meta.com, riel@surriel.com, caggio@meta.com, 
 anilagrawal@meta.com, rmikey@meta.com, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=6844; i=leitao@debian.org;
 h=from:subject:message-id; bh=tVC3qjK2uT7R1b63jjn7gm8DEZPWnfi5O6+kdXwvQWg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqWjYjmedAAxB69t9q8yvBYFMgnREjkexS1Y1MX
 25OxrVY+caJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCalo2IwAKCRA1o5Of/Hh3
 bWtHD/0YD4LUadpZ5uQnSghE+/YmW4gy5OYa5OHvbl13MYqcn687RTaEOMpbzHKm/M5P5Va3cUn
 nG/rFRDO3Y/Au62KDx9N2YWXclmNQfmIxebaae1EMqKFZIAHbJ2hdGzz/6J82RcaIQsLRrtu1xo
 vnP4I6169hUvVfc2gdiFz9WGEje5ir+dRgp7EXX3yZd1O1/xZT3I1t/WB+j5xpiqrTvosPY7d+d
 fqmlLxqVJKwWfQBrA3v6qB0fOxEEtEm6IFyp+31I+BGzqxdkaGc2Js9tet3JDTkV/Wa34aZcDle
 jcRPGNFrlPOCBUf0goF1FcJZXAYIquG9O7GtG31dWMmJAj1hbF9MsI1mgQAUPer9ranqDDVGAvl
 gKGnRdZSIvZXg9agpFSZDLQp9MpySovgkJBrHUQ1hiYCCHlpwuv8+/jBMuv55J6zjH5YHHLw14Y
 zB0eTDfDpLDcuxRpo+fEmkcEOlxBoZeRBCpvIf3aM3YTub4lgk5vQ+XDiGyCCE9axS1dpegff3y
 Zpooc5zGBLMen1xK6M95pkSb3sG8rfJ6aCKvuhsXDvKc/blrkfWZ8D7Ii9tVGQvQzgRKFc29U8u
 Z+r+oUtqUlxeUojYMwHFB5lmhvbwGbyPth53OAxt9DJkS82665X3bx52qYvXSHtX/kYwWWxx7Ed
 L290f6k1JcU8mGA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

num_poisoned_pages_inc() and num_poisoned_pages_sub() are the single choke
point for every poison and unpoison event. Hook them so each hardware-poisoned
frame is appended to the LINUX_EFI_POISONED_MEMORY table, and each unpoison
tombstones its entry so a frame that is good again is not carried forward.

The append mirrors efi_mem_reserve_persistent(): claim a slot in an existing
list entry, or allocate and link a new list page -- itself reserved via
memreserve so it survives to the next kernel. memory_failure() has already
taken the frame out of this kernel's allocator, so only the cross-kexec record
happens here.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/poison.c | 127 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |   8 +++
 mm/memory-failure.c           |   6 +-
 4 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 8efbcf699e4ff..05d0a490923e5 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -43,4 +43,5 @@ obj-$(CONFIG_EFI_EARLYCON)		+= earlycon.o
 obj-$(CONFIG_UEFI_CPER_ARM)		+= cper-arm.o
 obj-$(CONFIG_UEFI_CPER_X86)		+= cper-x86.o
 obj-$(CONFIG_UNACCEPTED_MEMORY)		+= unaccepted_memory.o
+obj-$(CONFIG_EFI_POISONED_MEMORY)	+= poison.o
 obj-$(CONFIG_TEE_STMM_EFI)		+= stmm/tee_stmm_efi.o
diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
new file mode 100644
index 0000000000000..ed3b8cee21ba6
--- /dev/null
+++ b/drivers/firmware/efi/poison.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Runtime handling for the LINUX_EFI_POISONED_MEMORY configuration table:
+ * record and clear poisoned frames so the next kexec kernel can keep them out
+ * of its allocator.
+ *
+ * Copyright (c) 2026 Meta Platforms, Inc. and affiliates.
+ * Copyright (c) 2026 Breno Leitao <leitao@debian.org>
+ */
+
+#define pr_fmt(fmt) "efi: " fmt
+
+#include <linux/efi.h>
+#include <linux/io.h>
+#include <linux/mm.h>
+#include <linux/sizes.h>
+#include <linux/spinlock.h>
+
+static struct linux_efi_poisoned_memory *efi_poisoned_memory_root __ro_after_init;
+static DEFINE_SPINLOCK(efi_poisoned_memory_lock);
+
+static int __init efi_poisoned_memory_map_root(void)
+{
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return -ENODEV;
+
+	efi_poisoned_memory_root = memremap(efi.poisoned_memory,
+					    sizeof(*efi_poisoned_memory_root),
+					    MEMREMAP_WB);
+	if (WARN_ON_ONCE(!efi_poisoned_memory_root))
+		return -ENOMEM;
+	return 0;
+}
+
+static int __init efi_poisoned_memory_root_init(void)
+{
+	if (efi_poisoned_memory_root)
+		return 0;
+	if (efi_poisoned_memory_map_root())
+		efi_poisoned_memory_root = (void *)ULONG_MAX;
+	return 0;
+}
+early_initcall(efi_poisoned_memory_root_init);
+
+/*
+ * Record a hardware-poisoned frame so the next kernel can keep it out of its
+ * allocator. memory_failure() has already removed it from this kernel, so only
+ * the cross-kexec record is needed here.
+ */
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	phys_addr_t addr = PFN_PHYS(pfn);
+	struct linux_efi_poisoned_memory *pm;
+	unsigned long ppm;
+	int index;
+
+	if (!efi_poisoned_memory_root ||
+	    efi_poisoned_memory_root == (void *)ULONG_MAX)
+		return;
+
+	/* Try to claim a slot in an existing list entry. */
+	for (ppm = efi_poisoned_memory_root->next; ppm; ) {
+		pm = memremap(ppm, sizeof(*pm), MEMREMAP_WB);
+		if (!pm)
+			return;
+		index = atomic_fetch_add_unless(&pm->count, 1, pm->size);
+		if (index < pm->size) {
+			pm->entry[index].base = addr;
+			pm->entry[index].size = PAGE_SIZE;
+			memunmap(pm);
+			return;
+		}
+		ppm = pm->next;
+		memunmap(pm);
+	}
+
+	/*
+	 * No slot free - allocate a new list entry and link it in. The page
+	 * stays allocated for the rest of this boot, and the next kernel
+	 * reserves it while parsing the EFI configuration tables, so no
+	 * separate cross-kexec reservation is needed here.
+	 */
+	pm = (void *)__get_free_page(GFP_ATOMIC);
+	if (!pm)
+		return;
+
+	pm->size = EFI_POISONED_MEMORY_COUNT(SZ_4K);
+	atomic_set(&pm->count, 1);
+	pm->entry[0].base = addr;
+	pm->entry[0].size = PAGE_SIZE;
+
+	spin_lock(&efi_poisoned_memory_lock);
+	pm->next = efi_poisoned_memory_root->next;
+	efi_poisoned_memory_root->next = __pa(pm);
+	spin_unlock(&efi_poisoned_memory_lock);
+}
+
+/*
+ * A frame was unpoisoned (typically the hwpoison injector under test).
+ * Tombstone its entry so the next kernel does not reserve a now-good frame.
+ */
+void efi_hwpoison_unrecord_pfn(unsigned long pfn)
+{
+	phys_addr_t addr = PFN_PHYS(pfn);
+	struct linux_efi_poisoned_memory *pm;
+	unsigned long ppm;
+	int i;
+
+	if (!efi_poisoned_memory_root ||
+	    efi_poisoned_memory_root == (void *)ULONG_MAX)
+		return;
+
+	for (ppm = efi_poisoned_memory_root->next; ppm; ) {
+		pm = memremap(ppm, sizeof(*pm), MEMREMAP_WB);
+		if (!pm)
+			return;
+		for (i = 0; i < atomic_read(&pm->count); i++) {
+			if (pm->entry[i].base == addr) {
+				pm->entry[i].size = 0;
+				memunmap(pm);
+				return;
+			}
+		}
+		ppm = pm->next;
+		memunmap(pm);
+	}
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 7787eb8d4e4c1..bd1b0934881fb 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1292,6 +1292,14 @@ struct linux_efi_poisoned_memory {
 	(((size) - sizeof(struct linux_efi_poisoned_memory)) \
 	/ sizeof_field(struct linux_efi_poisoned_memory, entry[0]))
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+void efi_hwpoison_record_pfn(unsigned long pfn);
+void efi_hwpoison_unrecord_pfn(unsigned long pfn);
+#else
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
+static inline void efi_hwpoison_unrecord_pfn(unsigned long pfn) { }
+#endif
+
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e2..03fa921ef1b7a 100644
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
@@ -87,13 +88,16 @@ void num_poisoned_pages_inc(unsigned long pfn)
 {
 	atomic_long_inc(&num_poisoned_pages);
 	memblk_nr_poison_inc(pfn);
+	efi_hwpoison_record_pfn(pfn);
 }
 
 void num_poisoned_pages_sub(unsigned long pfn, long i)
 {
 	atomic_long_sub(i, &num_poisoned_pages);
-	if (pfn != -1UL)
+	if (pfn != -1UL) {
 		memblk_nr_poison_sub(pfn, i);
+		efi_hwpoison_unrecord_pfn(pfn);
+	}
 }
 
 /**

-- 
2.53.0-Meta

