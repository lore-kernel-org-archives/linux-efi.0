Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DB655C300;
	Wed,  9 Sep 2026 13:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959172; cv=none; b=bWHumFcWAGPMfQ6be+PpPJ2BG2/RowUhSq4rqySyYcZ5jKqi83Hhyebu5LHjitTjAP+MPBPt+aYXKuuzjOZv+L0p1/GvIzWPG19oSRttmPYzN/SfSjcZzuoxHnzI1gOF4Wa1XT9UjqmOtv2tCzJoHS+Bk8dkUCbblUu/+dlHp+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959172; c=relaxed/simple;
	bh=MZnll+uvZ+yY/oMfw6DSCIEir7AmYXLDgRkRphbIGv4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YPDZf983PNJ6bDGz42ezQuUG3vHzwEh0tFGY+XbwjLs+pJhU4FtwjKHO2SN+KI7UAakC7t0TV9C3w96Ll3fPGOxckW0zTyu9FpncaefPLYQjo5Lz3U7F5d+nAqirbaOopyIx8stTr/KKHLsPmHpFoFJswghAgWNOftGPHcZ9Dvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=tHwGSDg5; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="tHwGSDg5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=1pT0yQbwDkGLyzj6/qFjpw66FqU9lPeWqHePe181JIU=; b=tHwGSDg54ByEfThjAj+t4YPGlr
	oZmW25qQh71QWoYRoNFnzPGiZ7q1hBwUaG+br9xCsqnjXZgWt9jDLMbCznjOdgY/aUJtWObxG19tc
	57pIOs3bOeCLjdjYp7mt1vGNJqYKLnTr4bvNjJ4qSI5cOHCjAfJV0TTzXw0QuSuwhvUEanuY/EO0Z
	gIty+yaHouxyyAAef0FkMQqQmyrgMIkV3J150bH8PsLwLDqD69gBr5kcANXmYdvuoq3/calpWgVbg
	Ph5CZerJW2HE44JYcZe/99Zq3hCIIn98LrF0r23FwAoWI90mngX1Sw0jW3dyS/h+irw0xsHwRE3eu
	Yuvt+Xuw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4I01-0034e0-0s;
	Wed, 09 Sep 2026 13:06:01 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 09 Sep 2026 06:05:23 -0700
Subject: [PATCH v4 4/5] mm/memory-failure: efi: answer whether a range is
 poisoned
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-hwpoison-kho-v4-4-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
In-Reply-To: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
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
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=2349; i=leitao@debian.org;
 h=from:subject:message-id; bh=MZnll+uvZ+yY/oMfw6DSCIEir7AmYXLDgRkRphbIGv4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqoVmYSlBarC3RkQk9eIxE1kitJWwdSYMD89hTK
 8h7doIqSa+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqFZmAAKCRA1o5Of/Hh3
 bY5bD/9F7YKH2OjzTN+a/S5ygVJPXHtamJZIQ+TnnkmEvwQmdlVoyS4CRJSxclq4Js03mxJyva0
 qhkZaMKfbHM0I5I9MER8lgxRzomsl+gzHs4/0WCQuJNH0izWGCn3nSFQsfguePpLlyMnXCzwHdj
 OE4IIsvyIgy0jn0aqNW4FzYrHy/zw27sAi7SQoMkQT/4sVSucXjhAHgY1vDHrFiKcruHugMDjx1
 o2ai+946IwYpayMnLy82CHJqnOuvKU9mJNF1jgscp5PMnlWGFe5xaQ8Ctf2RoBsmmc75qEDTqVp
 shQ9UHRely46WbP95/46g2Nqtjb4rO0KudGUsNOnHJLefz5wXo8yHfC1dWjWpfhxa67AWwzQCG7
 Poy+diIt1+VZgMuAsYIu35h0o1YFdJmebQ4ve2XTHtMZlpHNvk7PiTcLrtXMBA8mQ7QLQTz8rdo
 3PE8mA5cpqkbWm9Ue7ItkSJVgVDhZEVuKOvZ3+kx6l78/rJ6mRE3DTJRx4lAEc6d9OtS1P4XwgG
 X6E0a07eLOzD7PipCfzttdg7aeJtDOsiG5PuhdRrO1f+bCZYKtHMjvWEeQKg2v4zaJ6G8v26V1U
 ruxQhN7Zw+LCBdD6EcL9Ch73V4T8fMVuDXXBpIfncOP01zdbAtYOkWCs1H9GyH6crGJgAlKAl+H
 GVLmgr7mIpZIA0w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The bitmap an earlier kernel filled in gets in this one through EFI,
but nothing reads it back yet.

Introduce range_contains_poisoned_memory(), which the page allocator
will use to ask about a block before handing it out.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 26 ++++++++++++++++++++++++++
 include/linux/mm.h            | 14 ++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index c18edf111c710..e16d43f4438ee 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -96,6 +96,32 @@ static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
 	return phys_to_virt(efi.poisoned_memory);
 }
 
+/* Does the range cover a unit an earlier kernel recorded as bad? */
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	u64 first, last, nbits;
+
+	if (!pm)
+		return false;
+
+	nbits = pm->size * BITS_PER_BYTE;
+
+	if (start + size <= pm->phys_base)
+		return false;
+	if (start < pm->phys_base)
+		start = pm->phys_base;
+
+	first = (start - pm->phys_base) / pm->unit_size;
+	if (first >= nbits)
+		return false;
+
+	last = (start + size - 1 - pm->phys_base) / pm->unit_size;
+	last = min(last, nbits - 1);
+
+	return find_next_bit(pm->bitmap, last + 1, first) <= last;
+}
+
 /*
  * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
  * unpoison cannot tell whether the unit as a whole is good again.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 274fa880077c5..b68824fcfbef1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5387,6 +5387,20 @@ static inline bool pfn_is_unaccepted_memory(unsigned long pfn)
 	return range_contains_unaccepted_memory(pfn << PAGE_SHIFT, PAGE_SIZE);
 }
 
+#ifdef CONFIG_EFI_POISONED_MEMORY
+
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size);
+
+#else
+
+static inline bool range_contains_poisoned_memory(phys_addr_t start,
+						  unsigned long size)
+{
+	return false;
+}
+
+#endif
+
 void vma_pgtable_walk_begin(struct vm_area_struct *vma);
 void vma_pgtable_walk_end(struct vm_area_struct *vma);
 

-- 
2.53.0-Meta

