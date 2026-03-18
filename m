Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22513BA248;
	Wed, 18 Mar 2026 10:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831588; cv=none; b=XIfRFGu+HXz43XL7I8ZMCmsG+jNQqFsq6BX/SW7PBhoyXhBycZIxDusnLRv+Hu7cRkXX33pqj05VoOjHR4mZ5h3SooDKhmMjI09GX8eqhv9tTU1+WR/rFybBZiOMTMvyDn4RSSwabY3UkU/JdlcFUjnwRmj3GtqD+F7UId12X7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831588; c=relaxed/simple;
	bh=zHz96zz0ncBdc90iHfU1esNDP5VS2vFvp/Tz9M9XRk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd2VxlBg33puFyq3NZV3/Bhw3kDd+uSnE6QIQCB9/BtLzf/SXRF7/2tBZ5b9DG5l5xPkdj3hyvgo5JnDOmlFyUmLYOArHLxr66zub5mYRdHnU+t6aVHu8+Ym5y/gZ0pjOLQbQeD2k47LNhL4/PM8JJ8ztoiF3UdU+ax3vl7ggOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+3CqX8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+3CqX8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A1FC2BCC6;
	Wed, 18 Mar 2026 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831587;
	bh=zHz96zz0ncBdc90iHfU1esNDP5VS2vFvp/Tz9M9XRk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+3CqX8kLBmNikWLF7a8iVjXMFKms2g5d7cGj+DkSwb7SWZfJl3UUItFy/h005Dyb
	 px8WulbFJMFk9CqcCuNJvWEv/rGujYRCx2LRV//5pAJM9mH2dWdmdTheM2VFzL4fRQ
	 y8jRDky0b5dIJmL2lhrOXQG3ilJYoi1yOuBZKgPG03bS5GPsemT1iu8A5Zn8EVs1k1
	 KORZT0VeE8CibV/qbEteKg8rZeVO6pjmW8j8RmPunYEJIT5qfACmdTvXQzFne51AZG
	 jjNVTjP9AFMX+Ii+jyxIlaK2lRkFLfqVjcg6XRabaz5r85dBmBz4jDrGVKYrPFx+vI
	 1IaEk9XK6tBNA==
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
Subject: [PATCH 6/8] memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
Date: Wed, 18 Mar 2026 12:58:25 +0200
Message-ID: <20260318105827.1358927-7-rppt@kernel.org>
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

On architectures that keep memblock after boot, freeing of reserved memory
with free_reserved_area() is paired with an update of memblock arrays,
usually by a call to memblock_free().

Make free_reserved_area() directly update memblock.reserved when
ARCH_KEEP_MEMBLOCK is enabled.

Remove the now-redundant explicit memblock_free() call from
arm64::free_initmem() and the #ifdef CONFIG_ARCH_KEEP_MEMBLOCK block
from the generic free_initrd_mem().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/arm64/mm/init.c | 3 ---
 init/initramfs.c     | 7 -------
 mm/memblock.c        | 6 ++++++
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 96711b8578fd..07b17c708702 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -385,9 +385,6 @@ void free_initmem(void)
 	WARN_ON(!IS_ALIGNED((unsigned long)lm_init_begin, PAGE_SIZE));
 	WARN_ON(!IS_ALIGNED((unsigned long)lm_init_end, PAGE_SIZE));
 
-	/* Delete __init region from memblock.reserved. */
-	memblock_free(lm_init_begin, lm_init_end - lm_init_begin);
-
 	free_reserved_area(lm_init_begin, lm_init_end,
 			   POISON_FREE_INITMEM, "unused kernel");
 	/*
diff --git a/init/initramfs.c b/init/initramfs.c
index 139baed06589..bca0922b2850 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -652,13 +652,6 @@ void __init reserve_initrd_mem(void)
 
 void __weak __init free_initrd_mem(unsigned long start, unsigned long end)
 {
-#ifdef CONFIG_ARCH_KEEP_MEMBLOCK
-	unsigned long aligned_start = ALIGN_DOWN(start, PAGE_SIZE);
-	unsigned long aligned_end = ALIGN(end, PAGE_SIZE);
-
-	memblock_free((void *)aligned_start, aligned_end - aligned_start);
-#endif
-
 	free_reserved_area((void *)start, (void *)end, POISON_FREE_INITMEM,
 			"initrd");
 }
diff --git a/mm/memblock.c b/mm/memblock.c
index 87bd200a8cc9..9f372a8e82f7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -942,6 +942,12 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 		end_pa = __pa(end - 1) + 1;
 	}
 
+	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
+		if (start_pa < end_pa)
+			memblock_remove_range(&memblock.reserved,
+					      start_pa, end_pa - start_pa);
+	}
+
 	pages = __free_reserved_area(start_pa, end_pa, poison);
 	if (pages && s)
 		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
-- 
2.51.0

