Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3603B71B2;
	Tue, 15 Sep 2026 12:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476852; cv=none; b=ZPREgijl2KuhVPmaEA+I5xqtpIo2PfPU8Lb8GQrA0xbNJoxgAb+3iaS5lPFpsU33nRV785q9ZmXVrSIlmv96USfIV4nxsAyAL1owWKpZdXSUcA86DIrJlfd+yio45ITh/ELQ6I5p7sPoaq8TXg1d3sPgfYZR3P49pwYeNT638M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476852; c=relaxed/simple;
	bh=QndDTWh5bGLYFpgTzNsBMcjtlSoq6B2ZnR6/EP1pCQo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PTZJEMiQZXwnZiutAzBHljys5DXx3asz2i/p8NdfeQoNxe3gENm+4eXLzEe/w4CINXz2zgXZM0sStAzkUzOl66HfZLyzchKKlwvuyqrR4iZw4+SPv7n0Iflq1Hyhp15lD3A+qq5NYDpNWGsOK6gBYiyV+rWk8JOwktdS0FTcgGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=QY0GrUg+; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="QY0GrUg+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=txqh/4dMVNkv3jAnEFkWYzpJcEFlwoVpdz1x6TA4rUQ=; b=QY0GrUg+hg2FpxWgJ8xxZXb26i
	a40KcG1CY1FLiZgOkpyJzp7DOw1gx1xQpWXRtn5i+i0aRmh548I+laXxHuxipkTKTvSiRNGRa5cCa
	15eEcGqTe1tBJvKRukwl9HWsRnOCulnpK4y+qO0fhIOzcDFrlMZl+0CfRcEvuSOcPBgro4LJ8Yp5T
	+W95tZNqEZYj0PJvLqiJ78uIB6UGaw0dgkHbkpn2unqZVyAM2xLbbEbzam7ULQANjEZAiAHBDlgK7
	ZG96j8aQrDleLqQAt/XRd2xXSUxwLy+Qib1h43v3kLn4zpG6CtscsiWn1xAmBwv68+/Wm51M3Kvks
	hdLJbdeA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Sfl-004P5U-0I;
	Tue, 15 Sep 2026 12:54:05 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 15 Sep 2026 05:53:35 -0700
Subject: [PATCH v5 1/9] mm/page_alloc: factor out the accept-and-free tail
 of __free_pages_core()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-hwpoison-kho-v5-1-3bc7a57bd503@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2075; i=leitao@debian.org;
 h=from:subject:message-id; bh=QndDTWh5bGLYFpgTzNsBMcjtlSoq6B2ZnR6/EP1pCQo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqqT/e/q5/cYr405F2RzQcKhfWFrisnYG55iAgq
 UvT/67s8SiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqk/3gAKCRA1o5Of/Hh3
 bceTEACgTXdW1ZYLhwiIgzpNy3/tIJlO0t6mQw1xMfw4l9nQV4a9dvbY/XfEh5CoXZ1SxwevYyr
 jYhT3krAmc4hkLt0U0WC3K64jg+VIQ1OpVudj7jjOnaFTFoQCk+Wco/JApTvPg0TXGejrmXZnAA
 7bmbJKaGYUBr0k+GH132hy4tzAGPNsbMghbh0+ZOx+CUZOLCAJ1OW+tW8seGCZ1H1iOZb33i/cN
 yfqd5+3JA5PFya4Rq4iDZ+h+fhXelxujWlvkWhenA1TReHsfprrwXMK5NAlwxaOUqqy2mhKpzfd
 WWyC+BjxTCT1RAF47MCnkAAi3/QAS8UDySy7+N26+WFvGImkuhmkRHw+Fb+yqxmn9erNjh6i2Da
 pkX0o7jatRDIeeA0Tc6nEDsHerPH/Ao+Ph2vjQVWkC42Hy0Criep/Mi5EcLHD16RcBqgbyGCVHZ
 Zmh4ahHaN07+XvCyatxhM9P3MiIQK+etSZDTegputerYeHbzVpCcMCTOkBz2i3R7GmpRoq/7IGf
 u3uZYqGtBbqF5p5463cbsewXIL75U79WBO5rTMPMvegvHF85MkpAbTtQK5N/RZckds3O02TLBIY
 ttKp3I2XptzsAjyHnmWewT1GB5fAUo2ahpu2ryFEAHzvDUf6GoZMUUMxTP39H4en8Sr4iglVSmT
 l5jNgyb+RfmoLoQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao

__free_pages_core() ends by accepting the block if it is still
unaccepted and then handing it to the allocator. The poisoned-memory
replay later in this series needs that same tail for the parts of a
block it does not withhold.

Move it into accept_and_free_block(). This will be used later, when
we need to accept and free a subset of a order-block that is
not-poisioned.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/page_alloc.c | 31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 404896b53003ef..b07b5f4751cb95 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1579,6 +1579,24 @@ static void __free_pages_ok(struct page *page, unsigned int order,
 		free_one_page(zone, page, pfn, order, fpi_flags);
 }
 
+/* Accept the block if it needs it, then hand it to the allocator. */
+static void __meminit accept_and_free_block(struct page *page,
+					    unsigned int order)
+{
+	if (page_contains_unaccepted(page, order)) {
+		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
+			return;
+
+		accept_memory(page_to_phys(page), PAGE_SIZE << order);
+	}
+
+	/*
+	 * Bypass PCP and place fresh pages right to the tail, primarily
+	 * relevant for memory onlining.
+	 */
+	__free_pages_ok(page, order, FPI_TO_TAIL);
+}
+
 void __meminit __free_pages_core(struct page *page, unsigned int order,
 		enum meminit_context context)
 {
@@ -1613,18 +1631,7 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
-	if (page_contains_unaccepted(page, order)) {
-		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
-			return;
-
-		accept_memory(page_to_phys(page), PAGE_SIZE << order);
-	}
-
-	/*
-	 * Bypass PCP and place fresh pages right to the tail, primarily
-	 * relevant for memory onlining.
-	 */
-	__free_pages_ok(page, order, FPI_TO_TAIL);
+	accept_and_free_block(page, order);
 }
 
 /*

-- 
2.53.0-Meta

