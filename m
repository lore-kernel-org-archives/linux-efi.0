Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CB81DE8BB;
	Mon, 23 Mar 2026 07:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252130; cv=none; b=DRp8SqRyWt73GNyWyDMSD+AEbV0R/hOdu32Bio4lZNj/l9x39aYCJftlDxWGBS5KjPrb+0wwICLiy971w7WJN9rLy5Y1fCaCF98O4vt9LbqApCgQ6ucv0LEyV9QYFFOw/bNcqr+cgfy1WkyEgqEgwnmbF64DlNZpGEMkYnHZjDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252130; c=relaxed/simple;
	bh=pCbilTTHI/VwIdYALA976lc/t17gtYFZ5ukjoWq9Zt0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lEJDOIqk5DuBqh4DMgB/NNrxcP5Aq8olD6Wf9aqC5w/05iJDspw0+3o+uPB9QKmLO4gpaPE/BG0t/U1HW5TP7Kf14ThjGk+FzuNOWJY/eFPo8IQDszy1cqxUH7EBptwvrF0AQ5a/6GxZ+DH5UGS//97lPpG16s+TZQ78Kyzs8d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rlv1S8+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rlv1S8+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC71BC4CEF7;
	Mon, 23 Mar 2026 07:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252130;
	bh=pCbilTTHI/VwIdYALA976lc/t17gtYFZ5ukjoWq9Zt0=;
	h=From:To:Cc:Subject:Date:From;
	b=Rlv1S8+0zQURdG9YTxr4y3pNRy8/ylu6kZZ6eCiQf+sFd02KfS8+YNnbcyhsi4jov
	 S5w11oK7YTX3gkuWTcyu3hCCiTiR3veT8ei69ieEMGgMa2ZYMUeINhQjyhnr9FSaE8
	 Uj98YvIFa19EU/fOo55YccuDjUkb9MArMrSqYZ/sLc3WXjjEkYT/en9m3MbKASypiu
	 mxy2taD/9hMXzY7nvOCde6k5j3T9Mi98SQf3en8jrYNH2nRMr3fIiwj2mujYUhGjba
	 bnwQO6qLYjo9aQPPjQMfazIbKXhjL7hgiC8xGbSCEvOmYFBujPtB+XyBem0ZCuxVV4
	 bFbyai2HlbXwg==
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
Subject: [PATCH v2 0/9] memblock: improve late freeing of reserved memory
Date: Mon, 23 Mar 2026 09:48:27 +0200
Message-ID: <20260323074836.3653702-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following a recent discussion about leaks in x86 EFI [1], I audited usage of
memblock_free_late() and free_reserved_area() and made some imporovements how
we handle late freeing of the memory allocated with memblock.

[1] https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org/

v2 changes:
* fix UAF issue in memblock_discard() reported by 0day and sashiko
* address relevant sashiko comments
* squash memblock test stubs changes into the commit with core updates

v1: https://lore.kernel.org/all/20260318105827.1358927-1-rppt@kernel.org

Mike Rapoport (Microsoft) (9):
  memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
  powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
  powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
  mm: move free_reserved_area() to mm/memblock.c
  memblock: make free_reserved_area() more robust
  memblock: extract page freeing from free_reserved_area() into a helper
  memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
  memblock, treewide: make memblock_free() handle late freeing
  memblock: warn when freeing reserved memory before memory map is initialized

 arch/arm64/mm/init.c                       |   3 -
 arch/powerpc/kernel/fadump.c               |  16 +--
 arch/powerpc/platforms/powernv/opal-core.c |  11 +-
 arch/sparc/kernel/mdesc.c                  |   4 +-
 arch/x86/kernel/setup.c                    |   2 +-
 arch/x86/platform/efi/memmap.c             |   5 +-
 arch/x86/platform/efi/quirks.c             |   2 +-
 drivers/firmware/efi/apple-properties.c    |   2 +-
 drivers/of/kexec.c                         |   2 +-
 include/linux/memblock.h                   |   2 -
 init/initramfs.c                           |   7 --
 kernel/dma/swiotlb.c                       |   6 +-
 lib/bootconfig.c                           |   2 +-
 mm/internal.h                              |  10 ++
 mm/kfence/core.c                           |   4 +-
 mm/memblock.c                              | 124 +++++++++++++++------
 mm/page_alloc.c                            |  46 --------
 tools/include/linux/mm.h                   |   1 +
 tools/testing/memblock/internal.h          |  34 +++++-
 19 files changed, 144 insertions(+), 139 deletions(-)


base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.53.0

