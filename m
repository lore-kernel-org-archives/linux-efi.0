Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0433A7F62;
	Wed, 18 Mar 2026 10:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831533; cv=none; b=eR2PGBhAQ2EiF3NReKQRu9EonRrjRSQTD1H6Vc2TRfvueKsS6bDrxyAh8KBKDFrJQEInGbZX2qNWn1dikzyeCY6oArx7avk8FlyJtClcIcR5Cr+XpLEpcsCcPyC56qLjfU5G9t20ewD2ptTIGqdvBqFotjz2t9q3hBNHfHq51pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831533; c=relaxed/simple;
	bh=Xt2trVGOu+O7P4h2C+N66P7rMFK2F5qGGY0Nx9maAnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2D0d/7ao4ZDE6A6clE64Lbn1k34ADsqmB2ON9UckNmLdW/SmlN0mU2MwZnDTJswrW/WjpN33gRHTa3SrU2/lLkf7NAgBPxV0PTNSSsYozXzl5mohRijWEPm6SrxIcBKsqd7SyRTBndArWVKBocT+APVCcBdMmGZBgyFh0XxLGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pcCtAXo9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pcCtAXo9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C28CC19424;
	Wed, 18 Mar 2026 10:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831532;
	bh=Xt2trVGOu+O7P4h2C+N66P7rMFK2F5qGGY0Nx9maAnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcCtAXo9HFjeLmxxQDz1bWFGhGz3cgAlZqqVZqUib3biO4lA09lDRUAnvR7VPd8xK
	 xud5VSvoOVpP/uusVxy/mEj9ZPuFa9FBiEZXenJRIhcJDaFVEfdONJUF/a5DeLxg/6
	 9eJWF8V9iJtWLHumgV17GT6fy0gRDiS3mfXFa5ikPxnCcIM5ggnEsU6yokHlyO3U1v
	 z1M3PIiEZAT6J/8aMQ7R2ZMjIU13s+SJp+4B5zRJ5Z2M0LcqXMaYHaFCkfTXOiu6r5
	 wdkBq5ZN/Uu4ADC4SCCEps0JuPHvaJpv8CueQ5TFX51Ua5WHxeubzTq7aqhN6Hf77n
	 s2wD6ho9PQsRQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 1/8] powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
Date: Wed, 18 Mar 2026 12:58:20 +0200
Message-ID: <20260318105827.1358927-2-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

fadump allocates buffers with alloc_pages_exact(), but then marks them
as reserved and frees using free_reserved_area().

This is completely unnecessary and the pages allocated with
alloc_pages_exact() can be naturally freed with free_pages_exact().

Replace freeing of memory in fadump_free_buffer() with
free_pages_exact() and simplify allocation code so that it won't mark
allocated pages as reserved.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/powerpc/kernel/fadump.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 4ebc333dd786..501d43bf18f3 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -775,24 +775,12 @@ void __init fadump_update_elfcore_header(char *bufp)
 
 static void *__init fadump_alloc_buffer(unsigned long size)
 {
-	unsigned long count, i;
-	struct page *page;
-	void *vaddr;
-
-	vaddr = alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
-	if (!vaddr)
-		return NULL;
-
-	count = PAGE_ALIGN(size) / PAGE_SIZE;
-	page = virt_to_page(vaddr);
-	for (i = 0; i < count; i++)
-		mark_page_reserved(page + i);
-	return vaddr;
+	return  alloc_pages_exact(size, GFP_KERNEL | __GFP_ZERO);
 }
 
 static void fadump_free_buffer(unsigned long vaddr, unsigned long size)
 {
-	free_reserved_area((void *)vaddr, (void *)(vaddr + size), -1, NULL);
+	free_pages_exact((void *)vaddr, size);
 }
 
 s32 __init fadump_setup_cpu_notes_buf(u32 num_cpus)
-- 
2.51.0

