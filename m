Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBFA3B058F;
	Tue, 15 Sep 2026 12:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476913; cv=none; b=rUk+jZntBgMf6Z28KiSiJNizF73f8j+UckzBtpG5ALOuVRCas0E8EfTIzSCfBvZUl/OfWxy3UfnxyDhQN29UsG5dil3dEu7Vzxo/4VmKWd+ZJt1oxxxfMbBLkATH7Sqf0tMLI3F6tYn2Y/cOYQ7G7hk891WcfzR0eNWl69SOw40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476913; c=relaxed/simple;
	bh=4RHv2TayObkVu1Jypz4zcft6A7ZuNLPLOYHN84tQgBw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fAubvWLeUBqlKoYfhf+Q4ds6P+fzB2biDJvsgNwJxc166xYOZ8Y3OYzCjp/PQNapEzVrfJg1H+B5ByajfUpcXQjMPtXdB8Kkd4g5xQMwjcOqkTRbO8O2VmUBPEF4haj3Wd0PIZQ8zIx/PekC1ie3otE4sz8XxzyxPAA5wxdoUhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=jjRG63PV; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="jjRG63PV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=m/nkeRu2bKSmAi9Kfn/9bTVutjRevdYEH4ZRY/DxYx8=; b=jjRG63PVcCTPlnZu0EydQH6jUd
	EYH8/bn9jdy5AWDlRoLf7iD89DjjfwIQAGfuojuTPEskJprAuvanYlTK5R95nqfME/mvW/9LpLmS8
	U4zPpj7h99Y+LbhtfppTBy6GTB9MGjlO2Y/FWqQeavpXMMZwRh1BnzrYDu7xzElaqH00l+Cb6+16W
	3y9zzFaFTJnmobPEY+7/kHb4qr7wXmLMDCPbjq2EXLHLEx6rtGjPJxT+d8gBUOFeL6TJ9SEh8td+5
	s8S2vc4183hCzl6wkeyCVGezw31O4/b29yfMLQQQomllGczRwoAI84j4GEGlbewvgYf3F/Tskkw7Y
	UImVzECg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sgk-004P9q-1G;
	Tue, 15 Sep 2026 12:55:06 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:43 -0700
Subject: [PATCH v5 9/9] mm/memory-failure: keep inherited poisoned frames
 out of the buddy allocator
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2342; i=leitao@debian.org;
 h=from:subject:message-id; bh=4RHv2TayObkVu1Jypz4zcft6A7ZuNLPLOYHN84tQgBw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/eICMsY4l6GHi03IIM8MfD8gNmgSWIlOY/K
 iWYaIFog0yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 beArD/91EKxjfaH0PJcX5tV47c0OR63POIWuptnAdq2ZMAnwIyJuXdqccB0buApoQ+unH4Fz1yM
 DgN18xOTuIUyU4w2lOzhj9QGuc0jLQ/Y3aYjxgPqrpP/hZXsqpiLQl+8MrFbwZ5+5tUkPvjsqQU
 qXDCQi+HyxPG8h/97OAnvi4goH90bAGaxUY66I8c6RW/HUHAjvqdwARlIw97g1dDHkfg5mTBkXE
 8EJdEjolj8X+Ne2bnEi/Wq2ydA6G9AePNg9pQ77bCq/P7+FOHWb1V9MKG/QbKTxFTMeVTCNDDZM
 HAE4OH+PATf67ofo+M7M4prlAwL8mRo0yfy2b+Sr9vGnO8zQIP+uRFW16H2+gCG6YNG8p8hx0wT
 DwUkPP5ltN6k4hf+q3jtnfQkb6WZUz5hwMY2kO5rYUWawRGll8yckWmSJfXCpADIcJxmMyBrsf+
 6L/mnF8ZmuzDsXZzswJvd9p1wc6Xeoh28jDinPgcKPYZmJj+gDaQf5fFJtUR/cSec3NMHcXv7Ma
 bkIKRrFMIQUqgyGfcEHuEtaN9IN+j3B/ZgDwUi/VF8P01m41M34JETR0uq86SpTzoojGjWAOMO0
 9vHeBTxiNOHq3jfx0SPr6Hu1CPuws7AAunT4VHmB1D6vqXgFHCtZKtQSmiWpnNjVA8kaQo6+/7e
 3q2cuVbNVfB9iYw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

When the pages are being given to the allocator, check if they are
poisoned, and mark them as such.

Similar to unaccepted memory, hook it in __free_pages_core(), and thus
the frames never enter the allocator, rather than being taken back out
of it.

A block runs up to MAX_PAGE_ORDER and a unit is 2MB, so hold back only
the frames the table covers and free the rest one at a time. The
allocator merges them back up, so a unit costs the frames it names, not
the whole block.

The frames that are freed go back through accept_and_free_block(), so a
clean frame in a block that is still unaccepted is accepted first.

A frame is flagged before its memory block exists, so the per block
counter is seeded from the page flag when the block is created rather
than incremented here.

Suggested-by: Kiryl Shutsemau <kas@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/page_alloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b07b5f4751cb95..cca67a2702a421 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1597,6 +1597,25 @@ static void __meminit accept_and_free_block(struct page *page,
 	__free_pages_ok(page, order, FPI_TO_TAIL);
 }
 
+static void __meminit free_poisoned_block(struct page *page, unsigned int order,
+					  enum meminit_context context)
+{
+	unsigned long i, nr_pages = 1UL << order;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *p = page + i;
+		phys_addr_t phys = page_to_phys(p);
+
+		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
+			hwpoison_boot_page(p, context);
+			continue;
+		}
+
+		/* this part of the block is not poisoned */
+		accept_and_free_block(p, 0);
+	}
+}
+
 void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
@@ -1631,6 +1650,13 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* First: a block parked by __free_unaccepted() never returns here. */
+	if (range_contains_poisoned_memory(page_to_phys(page),
+					   PAGE_SIZE << order)) {
+		free_poisoned_block(page, order, context);
+		return;
+	}
+
 	accept_and_free_block(page, order);
 }
 

-- 
2.53.0-Meta

