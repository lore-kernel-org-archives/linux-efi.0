Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE833C8C48;
	Tue, 15 Sep 2026 12:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476890; cv=none; b=PLzgXr1FotukE3z1wu8GaqcDjF4Agxnu0q0yAphsDQ1cKnsYK74ST7Q0pcR1n4czlha1Le7VjlLF2NY+bZPGV+we9n468esu28IEUkg08Z/Atolk4hTCowhMrtrOZ/vr92DAKYyzZlCPZYpwwRtOOeU3dxCcrQ3MXiUFqscXKsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476890; c=relaxed/simple;
	bh=i08dYaHI1fvoon+7eeYigKp4zMx+PElqpyXpuKwzxk8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=M5j5rCX99+/NXJ/XzpYbidvuTWgQQaEopAtVkd5Sjuw43pbBvprrLvRRAg+cb3mVFpB+8/qkBnDBak84c8H5b4ZNVQluq1vC6KHZjVnd81OeFKo1TKUSP2+Y7//93EhK+mnEfc1Kx1tRPSveNCkADFNkmu/A9LSiO8EeKWe0cT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=tthTfBN4; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="tthTfBN4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=KFGAjcgsBNZUtMlZjlNuj+eLmu5d+vEUzhR99IX1VDA=; b=tthTfBN4x7zCU7oGsVV6Szsvt3
	jvEGAStFY3aByDpkFQ5VIXyHuEyyUNEGE8yGXVKQj1L8z+KaXwyg9EwFNjUaUaS/AtU47uM1fItm4
	WNYOH43FOfWuHSCwAI6seskU41IGUBS/s2Nvdv9mmSkUX2gx+A48JVhqafzaIwX5Q2o0gmOCa7J6/
	ITl+/NOqiGF+m9GDu6J2gzFRWbEEFJe8Yp1cuELMtoUWTSWgdja9ke2cHVwcb85jm09nAmp0vav+i
	UbM7uQ1VJHTBD86CwMtdGVcHr78GZTF07OnczSRjppPZmBpNj6OTeGtxnvfGyEs2Qc0UU1b69cwPg
	15mtXdIg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SgN-004P8C-3B;
	Tue, 15 Sep 2026 12:54:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:40 -0700
Subject: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2450; i=leitao@debian.org;
 h=from:subject:message-id; bh=i08dYaHI1fvoon+7eeYigKp4zMx+PElqpyXpuKwzxk8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/embGYYuss6ak1wnwb0KANA/8FHnDgmX1h4
 yqoOR7u5/GJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bdAqD/9H0G93KgtP4UxtzgrruldA6BytJMy0AZ6jAhasSf8Xy51dKJbfJUkHr7TKK2A/9p/lW5m
 jws0OZ2Jh1HezfvwYd+6NvlKCOa+QGaJnDmH6HqzVpJC2ZlumNgcZ3RNcfpfw+4W+mh6vny5/iZ
 0fvgOwqc+HRut7kUs/auiQbJGbqAU2fCfUSdkKIRVUPSgw1nNzJyir+kgdj4l1k5h/xt630UA0E
 j0CbE9MU7zcmubN03NhUszPfN16ZKJTuxCjS7i2ZjLsnbWNJyzIJ16ILdTbVwPw7Fb2EgLJzFXS
 3pIug07eedNDCbACtksMxD1viJqIoeGbS8a+1ltS6rbYv06jp6kghZjmPViI+rTWQrBD79maXZt
 ZUMgXjcdw+MhWAxCbeLoreCBlQcOKru/nzd/T10zivH86oljN2CnnTDe3s/uUhVqJqmIL5MqaBU
 WI2IkZreup6BBbcP7ECZFUW9EWEGEdV4JeU02oE/OqL+tucY2LGyeurRFz34tQs+bJl7hepbsO+
 2Z7o3h3vo52+4AEnCR44nK7x6TkZSDgVEF+0/sF2ay4niRqriVVCTDeazUUcTCf2GjooHeBWvt6
 yuXaXrYH6gutAekaiv1f3EOttoKg1VkUvmDxRic4Rm1mQq5MbrIAloJxWAKRhUlKq941oiT4yU7
 LHTs6WyqCVbzWDQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

The bitmap an earlier kernel filled in gets in this one through EFI,
but nothing reads it back yet.

Introduce range_contains_poisoned_memory(), which the page allocator
will use to ask about a block before handing it out.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 29 +++++++++++++++++++++++++++++
 include/linux/mm.h            | 14 ++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index 847592862f01d3..4e5cad0d1b9b65 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -101,6 +101,35 @@ static struct linux_efi_poisoned_memory *efi_poisoned_memory(void)
 	return phys_to_virt(efi.poisoned_memory);
 }
 
+/* Does the range cover a unit an earlier kernel recorded as bad? */
+bool range_contains_poisoned_memory(phys_addr_t start, unsigned long size)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poisoned_memory();
+	u64 first, last, nbits;
+	phys_addr_t end;
+
+	if (!pm)
+		return false;
+
+	nbits = pm->size * BITS_PER_BYTE;
+	end = start + size - 1;
+
+	/* Clamp the start into the table, but keep the caller's end. */
+	if (end < pm->phys_base)
+		return false;
+	if (start < pm->phys_base)
+		start = pm->phys_base;
+
+	first = (start - pm->phys_base) / pm->unit_size;
+	if (first >= nbits)
+		return false;
+
+	last = (end - pm->phys_base) / pm->unit_size;
+	last = min(last, nbits - 1);
+
+	return find_next_bit(pm->bitmap, last + 1, first) <= last;
+}
+
 /*
  * A bit is never cleared: it stands for a whole EFI_POISON_UNIT_SIZE, so an
  * unpoison cannot tell whether the unit as a whole is good again.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 274fa880077c54..b68824fcfbef19 100644
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

