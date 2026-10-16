Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5B23368A9;
	Fri, 16 Oct 2026 12:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792153007; cv=none; b=t/SQqm9hU+RbGRKTj1PO36c8Vj/asqrWmW7wCAsCNsD9+EjEpr6rJzgzS4xMrQLyjcuFagwpqD/rAnssAbs4yRfkvcATkPFdu+YzD+EIlYQMFzbekvAcMQ5J1gz4RPOxNcUfWnj/Uha97oWTCoLHcq0BTkFmrhuKFLGo5vvCgRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792153007; c=relaxed/simple;
	bh=Bu/VoZNuiEdhEWGo00Kj5rCUiRZTVHSpLXvx6jo2EaU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e4XBl6llsXuHq/Y1GsIpyMft9Qcp4pgq0UWnydNl611jZDJZlsIUUgp3mDPdfUbtolBN+EUT1/PQIS5tkY3ODDPqJvyaP0TLPwj78oBcmr2OSqRRYeXr78ggLNk7lm0KSQwFzhwrMssV6/AJKMg9TDIha6IKNXiNJVDsbKGBdtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=P+m4W8Pk; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="P+m4W8Pk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=WxZBoPVq89DlzEuXI3J15DiLUSM8TLChgH6sUBQbat0=; b=P+m4W8PkqhARrQ5Brokl80avXA
	84uyde890m+wCCwjwGq0R3LSAoSAAILFQbSR3NX93ZwLKJvzzR5O+0ywfy53kR6V/8uF9L3es4frX
	KCtukA6GfvdcxsV8f0+KnP6EEMd/utle+7sfi+IzenpFbh5P+5JtP0qMKfG73wmE+OXTxNSurAiBu
	zAfK9gqOLyMfe5Ns2kzDh0mfRWpZmKO9fdRux/pJ87OXpwLRAExovKSeRM34ggjVsayuqF+rQ1mAa
	YVUcLsU1z3kTyUuogpMYhgUwhTuAXYjQ/e/H+3qKUqqjoCus8kJFul5iZGh5GpGxF1XBmX/RImuEo
	LZG90Bzw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrU-005xTu-0O;
	Fri, 16 Oct 2026 12:16:36 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:45 -0700
Subject: [PATCH v6 5/7] drivers/base/memory: count the poison a block
 already holds when creating it
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-5-f304255147da@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2711; i=leitao@debian.org;
 h=from:subject:message-id; bh=Bu/VoZNuiEdhEWGo00Kj5rCUiRZTVHSpLXvx6jo2EaU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0/dx08nW5bcNGpUjsilj8UAtstZQu4E9fx
 64pXp49b1mJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bZjxEACogEk9bO3cK/jZkbLp0V62/KsgOz02SBwb5bR4Q1zqslmB7ZV+Ye0+X4h2hv93nOg1AZ+
 GmqOFkuuXv2Z64THfDAkVy+4hp+NDhgNZrABLVx9FRMvUj0VqbLzNMJPPuthfKFicEX7mdiGRBX
 WzMdSKrjz6HNxxlMKVnFejtUVrV14u0bbvUGzJGPzhE8FtHWZW5+P8K15Dg6VZWLH/mmwlKALd6
 vDO/r4z1t5hO/AZ9XKC3mXDDubJYi112HNKdbUrV3rlxayVV1q5a0Fk8CNDCXmzIr6sNqJCCI87
 Uv2CPeO0fOaXI9RjKqjxFaRfB8njgaHeUiBaSoKwY9HPressp8iADlgiW4emNdSWloY0F3sKYso
 UBcRwTDn3bXvJYQNLG8iQTnxL/I25Vx0DDHeOf7zDabsXmT1XtkEHwFuaHzIP099QPgUzc8zT9a
 bEkarLJr/TPOEk7KTkIZhwqoLz5B6XA2C83WSNyCa2qF1onO590TRvOuczMOXXDiWwwkBW9xbmW
 7u4Qd1qBdARcWAnFdd0rnu7Ie9Hk6kElo5fpK9/CbKFjjR8ckT+P8r8Zat0Y01fRFk7mRtIRVO/
 L6Znz9VCFGUYJsIt9ZFenxE82EDy5/csFeVMCmLV4T6WbDK/6HONT/h7flHstR45VHE19/R4FBv
 0smWVjFM1HCVK0Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A frame flagged poisoned before memory_dev_init() runs cannot be counted
on its memory block. memblk_nr_poison_inc() divides by sections_per_block,
which memory_dev_init() sets, and the block does not exist yet. The block
is then created reading zero, however many of its frames are poisoned.

Until now nothing could poison a frame that early. It becomes possible
once a kernel flags the frames it inherits from the one that kexeced into
it, as it initializes its memmap.

memory_block_online() refuses a block that holds a poisoned frame, and a
counter stuck at zero lets one through.

Count what a block holds when it is created at boot. The walk sits behind
num_poisoned_pages, so a machine with no poison does not pay for it.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/base/memory.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5eead3346f1e32..77481f375c2206 100644
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
@@ -1251,4 +1257,28 @@ static unsigned long memblk_nr_poison(struct memory_block *mem)
 {
 	return atomic_long_read(&mem->nr_hwpoison);
 }
+
+/*
+ * Frames poisoned before the block existed were never counted on it. Count
+ * them now, or the first unpoison takes the counter below zero.
+ */
+static void memblk_nr_poison_init(struct memory_block *mem)
+{
+	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
+	unsigned long end = pfn + PAGES_PER_SECTION * sections_per_block;
+	unsigned long nr = 0;
+
+	/* A hotplugged block is created before its pages are online. */
+	if (mem->state != MEM_ONLINE || !atomic_long_read(&num_poisoned_pages))
+		return;
+
+	for (; pfn < end; pfn++) {
+		struct page *page = pfn_to_online_page(pfn);
+
+		if (page && PageHWPoison(page))
+			nr++;
+	}
+
+	atomic_long_set(&mem->nr_hwpoison, nr);
+}
 #endif

-- 
2.53.0-Meta

