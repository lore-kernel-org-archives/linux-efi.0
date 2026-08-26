Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C473FB7E7;
	Wed, 26 Aug 2026 12:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787745898; cv=none; b=d2QptC+BDWYOuuF13h/Ypw1El1OPf2H3tiIx7WrLPURVs1830SY5MvBn/+/H9h5yXLJh8cc7kV2DV4768BbQ1OPf5bQJcLDS1GT1qUdc+j2Jxo8HNjcC606F4adz3g+c84Giz8uDVuj5hytAf7JGuzKMIGEgSb76zVPnd3ywXFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787745898; c=relaxed/simple;
	bh=o7M5nleNUlNmnqMGyVTK9Qj2BeNxjWI0gsdkMd+ovbg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tdf4HPrSShrD6FMR4YCI49Sn4xNHsMHG6A8CmbhNNmkpGTTIgYgFqjmvrgAT2uXLZRE7Ao6X2bgntlEbZzsHs6B5oxOVr+dTfuwsr9ZSUF8O4bZ2f0iivEv/B2Vd7cq/kXIgviDKs2troPlLGCp2u8hgL4djljJKXM19urCJY24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=eJhsOs+d; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="eJhsOs+d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ua19ttiw+1gS6VkqPomk+aSAT0oJIssRXjVFuOoXcyQ=; b=eJhsOs+dcKxgZEjIawHbnCfoxR
	FJoj2CNhOb1rCtnrqH2Mm5aAlhy0LOqunuNfO1EA6x/ZK3OFyOSYpP6kp+gLpH6XoL4OQaK/xRKki
	pX7HzuixQR6+8AEy8YUjtcuSATq+wSmUzpUfLNfUkezzAAEiqfNVvC25+hWJu6NrfQoh1pvKkmP/N
	S8kFISupRIKNuvwk6E/mgWW/iuLDuynkVUMay1aPs8ymGFi/WIIcM1BMzocl5KnGPAp5rnMI7P4ez
	q0++WLO/Ya8vMFeuh9tmFVPZxYYtnFmnHOuFHmoFEGgXFvwMymeTAEoCAOg6C8UyC23eHL7dzUmir
	7B44HBnA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wzCNC-00FCXg-3C;
	Wed, 26 Aug 2026 12:04:55 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 26 Aug 2026 05:03:55 -0700
Subject: [PATCH v3 4/5] mm/memory-failure: add a helper to poison a frame
 at boot
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260826-hwpoison-kho-v3-4-6f79c4b605bc@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2675; i=leitao@debian.org;
 h=from:subject:message-id; bh=o7M5nleNUlNmnqMGyVTK9Qj2BeNxjWI0gsdkMd+ovbg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqjtZLFACyJ88fYHvmvDeKqRvOsw5p9Y+n1bm5D
 Mzx8D61g3WJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCao7WSwAKCRA1o5Of/Hh3
 bVB+D/sH01X0pquQmQeP/oQwRNdbzSLw8hrBthdZ+iuZnJ7EHMihKbidDfHRr21dB7Wah97UeXu
 5tqMyBCwmEUKMGWLphOO2rTVM3srwtYk/XGmp0yy635/DwcN0HvOEeWmabJFg699vfaZ/SCP2Vb
 JE8vJL2/GfuL5GwtRZmgsQUQ+S4phKctRMge8sk0Ggg+eOHf6QDZQafMOlZjP0kZYppluUTE5pE
 /bBRllA6j0Gh6MiXOpnapCz9b0ERKstaO8YWOUWlmMLXJEuBbsRx+HdUGUp4LPV7toFT+RiGjz6
 ttsLGOS3n85dg9Q60645l3tsJOGdGMAhF5JiMLTw3PQ6wexEEpzwO5syX4+NOLlfeSFDW1/c1nX
 iiUBw1tymNwiDEUXh0GhvQq2CJukvcp8a+OuzWmIcg0IX9hw9M20qqY3ypRVJc2LvzvZFaP2Fa8
 I3alDzhhkiphuwoMnicMqCg7cGjJqba2vNPmWin7iPqk96K/Mk1k/8jRDpE/QgJcziewYWRd8/2
 0bRqDeDM2P3Q3PBpCzGU279PckPuqgGZ8duiElywmz1Q9Muik3O8uh54+r4e4zj958/GSrKZ++p
 qlVPg+pTp0I8JwfifiUB37YCoihHpNHZAr73OSS96JxHJMOE6kJ8jRYaWV0j1ge15pLYu2wRD5C
 CnO+jWKzf1QGruA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

A kernel that inherits a record of hardware-poisoned frames from an
earlier kernel needs a way to apply it. memory_failure() does not fit: it
takes mf_mutex, prints a line per frame, and a 2M unit is 512 of them.

Add hwpoison_boot_pfn(). A frame that is free takes the same route
memory_failure() takes for a free page: take_page_off_buddy(), the flag,
the refcount and the counter. A frame the kernel is already sitting on is
only flagged, since it cannot be taken away from whoever reserved it.
free_pages_prepare() drops such a frame if it is ever handed back, so it
does not reach the allocator either way.

The accounting cannot go through num_poisoned_pages_inc(). Its per memory
block half divides by sections_per_block, which memory_dev_init() only
sets up from driver_init(), so where this runs it is still zero and the
boot dies on a divide by zero. Bump the global counter directly; the block
counters stay short by these frames.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/mm.h  |  1 +
 mm/memory-failure.c | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 32bb723ffbb92..52a00a0e090c7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -5104,6 +5104,7 @@ extern const struct attribute_group memory_failure_attr_group;
 extern void memory_failure_queue(unsigned long pfn, int flags);
 void num_poisoned_pages_inc(unsigned long pfn);
 void num_poisoned_pages_sub(unsigned long pfn, long i);
+bool __init hwpoison_boot_pfn(unsigned long pfn);
 #else
 static inline void memory_failure_queue(unsigned long pfn, int flags)
 {
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 357a72ffda625..713fb2f8e0332 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -97,6 +97,30 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
 		memblk_nr_poison_sub(pfn, i);
 }
 
+static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
+
+bool __init hwpoison_boot_pfn(unsigned long pfn)
+{
+	struct page *page = pfn_to_online_page(pfn);
+
+	if (!page || PageHWPoison(page))
+		return false;
+
+	if (is_free_buddy_page(page)) {
+		if (!take_page_off_buddy(page))
+			return false;
+		page_ref_inc(page);
+	} else if (!PageReserved(page)) {
+		return false;
+	}
+
+	SetPageHWPoison(page);
+	update_per_node_mf_stats(pfn, MF_RECOVERED);
+	atomic_long_inc(&num_poisoned_pages);
+
+	return true;
+}
+
 /**
  * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
  * @_name: name of the file in the per NUMA sysfs directory.

-- 
2.53.0-Meta

