Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9796237BE81;
	Tue, 15 Sep 2026 12:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476897; cv=none; b=us0pl3816LYO/342c1NThEsl6sMFQBqMR2un+nyOATymkY1fIM08oaQOmm6YyIhueyVL1Q3bhM9fgTQsFs31NA4kNHtkzjWnxtuOfvJ+LWMgqzLFBHB0cjRJkFIel4mVABY4eWsEGANFQNJ1sh/EWLISJVRf6HnbA/TPbCF8QWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476897; c=relaxed/simple;
	bh=T3mL/3Kc07p9K/MT4mso5EEMI4eOaZY0yANJdmvBvvE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZvaRcbzCMceB8IX5K2DpP3lUWsu4SJCjNmKj58AB/wEqG8rhZ+oGVqMxgjRPpoOzZ5P93VA1eUl9QnnTG9gm1JG+oFSOLhjymVR2GWnsQj4y15065UDtPAIhgTGvBGNV+JUDan6WmIREOS0aIjS0+EkaxJ3a7nWzy4JipRuNn6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=WCLWVJs9; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="WCLWVJs9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=K8v/C9O0g8FUjKOQ0TaIzosy3/qX+2dVro7BLtwLk5M=; b=WCLWVJs990HuIGJZ4x6CqmQCWg
	uyMV8BszXqdZPcU9jgOKeQm8wtjSV8Koco5/z+PrAKYJu4BryqdfOOcNsgFsbIgJMWh9EzoXRryPa
	H7dTU+tzAHUV00L56XsX0kLjyfH7qdxfIFnS2uNKDR7vnMsFW/X10qma/qPFVJbUls3KOTsRRSYWi
	kdY4yJNGj7qWA6Z4zOqwdLgXUbBfH1qW6X1+qt5nF+zzLWXObNMkHR/QwRo9b84yo5qgY6tyxyext
	mpraWHuEA0CgqcOfTj+XhyG/sbXtj8oecs4/BXDaT2m7WraT67ft2Vg2EmcfB02x6oJGikzUSrxwr
	7ZdSBIaw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SgV-004P8h-0Y;
	Tue, 15 Sep 2026 12:54:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:41 -0700
Subject: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2728; i=leitao@debian.org;
 h=from:subject:message-id; bh=T3mL/3Kc07p9K/MT4mso5EEMI4eOaZY0yANJdmvBvvE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e53Hu0gqe5cHhpqQNe7hv0ZP42+UV0B6bQ
 Vl11UrXA/WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 baWYD/9D8jAr4oQzhn8Bl3b7Tmy0SS3Ar8i9wUTDGHUSVH8aR9qkR16ztxsU8oNKXkkIQQVbY6C
 +h4QevMxbRjtvsOyHkX4Kt8/hP+r9ytz2g7Ak3tWpPL/J3kXu4SrJb5o5hRcVhjXvHpW6HIq3Ws
 bFRMMbgL6xFVx7f5KFd8vjnYa6UStxqQKihP9INLA+VS4NYodrQCJ7T7q8udy/4fvLq4uT5eYqE
 HA7DXM5U2+fn5Rg8NKhxjJltesF5EqwqvrJtW8VPYYS6zuuConb9ZqLqsz8EfMSpTa8oliYbe1c
 TGVWNkeMvmBCRv8HaZYXW5cIVAHOzcf/FveCy7/ZZsi49Vc3IeVgNEr+nJwZaXpEYoieTgE7c6V
 LxDER8G4X1yzf8uxvPb37xayi4WN5h5/Dg4Ez6bj+3GRWjwWWY3f9PrMP5mhNt4ER9SSqpIASl5
 JB2Dd1a1891Yf823Bcovd8GMrQySGGIZVKVSMDcqBgPSLZItIzNFgHMV2peT+GVz/CTiyVvJoBe
 gVDkX8elv/o9EQAJ91RlR8W/sBlCXJC7iOi7ilK1upHfZAOFdeIBO+dayDenszq6c6rfWbCrW5p
 4Q3IQ7FqWebTAaOsGRql4aFJv87VAW7MKQ+gOHvxPtlBXRL2BTAg3au44y9iTOBYqZ8etixQJtO
 aI8MzCIkOTUGhRw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A frame a kexec handed over is flagged as it reaches the allocator, long
before its memory block exists, so memblk_nr_poison_inc() had nowhere to
count it. Walk the block once when it is created and take the count from
the page flag instead.

Without it an unpoison later subtracts from a counter that was never
incremented and wraps it, which then refuses memory_block_online() for
good.

Only a block created online needs the walk. A hotplugged one is created
before its pages are, so there is nothing to find, and its frames are
counted by num_poisoned_pages_inc() as they are flagged.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/base/memory.c | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5eead3346f1e32..49a33ddbb2e717 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -220,11 +220,16 @@ int memory_notify(enum memory_block_state state, void *v)
 
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
 static unsigned long memblk_nr_poison(struct memory_block *mem);
+static void memblk_nr_poison_init(struct memory_block *mem);
 #else
 static inline unsigned long memblk_nr_poison(struct memory_block *mem)
 {
 	return 0;
 }
+
+static inline void memblk_nr_poison_init(struct memory_block *mem)
+{
+}
 #endif
 
 /*
@@ -807,6 +812,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 	mem->state = state;
 	mem->nid = nid;
 	INIT_LIST_HEAD(&mem->group_next);
+	memblk_nr_poison_init(mem);
 
 #ifndef CONFIG_NUMA
 	if (state == MEM_ONLINE)
@@ -1251,4 +1257,33 @@ static unsigned long memblk_nr_poison(struct memory_block *mem)
 {
 	return atomic_long_read(&mem->nr_hwpoison);
 }
+
+/*
+ * Frames a kexec handed over are flagged as they reach the allocator, long
+ * before this block exists, so memblk_nr_poison_inc() had nowhere to count
+ * them. Take them from the page flag instead.
+ */
+static void memblk_nr_poison_init(struct memory_block *mem)
+{
+	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
+	unsigned long i, nr_poison = 0;
+
+	/* A hotplugged block is created before its pages are online. */
+	if (mem->state != MEM_ONLINE)
+		return;
+
+	if (!range_contains_poisoned_memory(PFN_PHYS(pfn),
+					    nr_pages << PAGE_SHIFT))
+		return;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct page *page = pfn_to_online_page(pfn + i);
+
+		if (page && PageHWPoison(page))
+			nr_poison++;
+	}
+
+	atomic_long_set(&mem->nr_hwpoison, nr_poison);
+}
 #endif

-- 
2.53.0-Meta

