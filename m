Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B6538F928;
	Tue, 15 Sep 2026 12:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476905; cv=none; b=meUuURaMsKJDmgo5bkmc0ie3NGoFmYJqI+RNNmqTCdYsL1c7dVhhCsSQqbV7hF5oxy9CbvITo8uEiKO6tmkcD5YBwcwCMJsowp3/PHU+WHsqPzcO6swPfLYrCxjUGL22BymnOt4iolygWE26+d8LarB2Y9aqHshoIbKStcqLK34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476905; c=relaxed/simple;
	bh=pkvLVOtl/wJxWCab4MZWos3IO2QmqKMvCWQXOQFBXcc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EHJam23AcUwduOFhu8eoHlwe9PEuWLw16eLwz8Yqiy7s9K+aXQS/Mg7I4tHgBSPUJ5NjzBzK+c06H5mzZwxui9n65lOgcF0/kUgFwkgf4rhsHtuRnbl0QhwrUWn4PWZzxrKjbYCzrf0rUsr1BqbirG3zHsLHkxPKk0PhKQJLV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=peho1MiS; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="peho1MiS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=nJQHvGBJYwJr3F/aktnOoCOR2Bfx83QmvxSaOEex9rc=; b=peho1MiSPxeM5E9y6ZkJnHD3Ac
	ENhbZZIxpw7yPwYcbEI1X27MJfJtisrsN896BxohWU9hGrJtHupzLBnfbm4DthteXHHreNWnt9Y5C
	8QS67ouHGUb8vn4m7JblIDmUdx8G8Tbq1ljQQFyC5VZJH4+0zEoMry+Cg+W+fLVO3JLBqhXxHMz21
	G8aYg3DxyZ+70H3BZqt2ucu+76cl8M0D5evcCm2m7AbyGfDpkKcp0ON6jHuIPa1JO41TWuoiDOdJs
	wCJ2/NXYJ3k2TrxgelPLDMwcY8BwBtdD41XbfHfuA5/SgPYSwl3p+LEVrAnV1biPV8+pa8risBmSL
	ZygLzG/A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sgc-004P9J-34;
	Tue, 15 Sep 2026 12:54:59 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:42 -0700
Subject: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to flag
 an inherited frame
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3014; i=leitao@debian.org;
 h=from:subject:message-id; bh=pkvLVOtl/wJxWCab4MZWos3IO2QmqKMvCWQXOQFBXcc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/ejMXIQjF5HQn3VxXq+6Zy/+n0FqXVKhxTp
 P11aWC3wMmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bY+/EACFlIZZKCGkeF1D4pH+3gCLk17ltEVj4rCRVqtzUt3BEHbKX02a5iBOQC/tfTUtE95ecVK
 lOWKniPGfAbmnAp2TL4aXXUneo8dI4f/STXSJo9qHWYK/Ry9cDgT1xPzvPYj0YDbdp+okn4MT8e
 Tuti3cA3W+IdRnIsAuJMv1FoGqcEMrsOKnyyODshHbHg29gADtUKTLc5J7ccFlVbejrCjPHu1lG
 SboVxR+tnbt3la37O7iBxy8VmdO9Tf69BtvNUmkPuXB452agmhtTAt7EwdfBwIQfmyyrM2yThfP
 rmqSmnXOL/D9MQFjSABsdm/5MrDZOJ8sBY7xpVhGrpBjiFD9Dp6jWC3wFCfuGlSjhONjnYUb3xT
 5J/EuMM2Jg4CJpW9GDxeomC6qbiJXOVuMVdzQfDKMwn7aPdPL2JArr6UkKKVAL7J2eina1oP7Iz
 Og5kFNxhLig6XpPc//LGzKXEXdCESf6B39F/UKPWabHLHJz9Od9S7Q8eNl5KmGoUrANCyGOQvzE
 cKokqpD7Cz/cXHDBief0J6Y3wE/JnD7y0D6fpIYHs/K5GKXf4j+oyf+LEhf0EsjKhRm8GMFXP88
 Nk20+jo7Z/87cujzF69coCuRzBORUnpsor0dJA+DFLKUabKCfDz/ikqi6sCv6YCO1fAnwSKgakI
 RD8ZDEpMLOGVIkQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A frame the previous kernel recorded as poisoned has to be flagged before
it reaches the allocator, which is long before memory_failure() can run.
Add a helper that leaves it in the state a frame poisoned by this kernel
would be in, so everything that already understands PG_hwpoison covers it,
the kexec segment placement check included.

num_poisoned_pages_inc() does not work at boot: its per memory block half
looks the block up by pfn, and memory_dev_init() has not run, so it
divides by zero. Take only the global counter there. A hotplugged block is
already there, so that path takes both counters as usual.

The caller comes later in this series.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/mm.h  |  7 +++++++
 mm/memory-failure.c | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b68824fcfbef19..8039830998dd4b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5225,6 +5225,8 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+void __meminit hwpoison_boot_page(struct page *page,
+				  enum meminit_context context);
 phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size);
 phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size);
 #else
@@ -5232,6 +5234,11 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
 }
 
+static inline void hwpoison_boot_page(struct page *page,
+				      enum meminit_context context)
+{
+}
+
 static inline void num_poisoned_pages_inc(unsigned long pfn)
 {
 }
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d9b8be696aac38..60e9682434700b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -137,6 +137,32 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
 	return range_hwpoison(start, size, false);
 }
 
+static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
+
+void __meminit hwpoison_boot_page(struct page *page,
+				  enum meminit_context context)
+{
+	unsigned long pfn = page_to_pfn(page);
+
+	if (PageHWPoison(page))
+		return;
+
+	SetPageHWPoison(page);
+	set_page_count(page, 1);
+	/* The page has been completely isolated == MF_RECOVERED */
+	update_per_node_mf_stats(pfn, MF_RECOVERED);
+
+	/*
+	 * The per memory block half of num_poisoned_pages_inc() has no block to
+	 * find at boot, and divides by zero looking for one. A hotplugged block
+	 * is already there.
+	 */
+	if (context == MEMINIT_HOTPLUG)
+		num_poisoned_pages_inc(pfn);
+	else
+		atomic_long_inc(&num_poisoned_pages);
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.

-- 
2.53.0-Meta

