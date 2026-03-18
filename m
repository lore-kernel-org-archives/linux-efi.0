Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378133AE194;
	Wed, 18 Mar 2026 10:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773831522; cv=none; b=FdycXJ70l6vSdQMEqo9QFPndZWiNEPgUAGkp+kwENtYH7YW3wsZ95TBFDjG6r2yoX5JFyuM3jWDCnt7nO0YB4O1rHwY4Gr1rGxXshlbby+AbMmGR9s4vXcvdcyZ6mMUp3LniWzCXC6MpC/M1so67EiYFtyheaO7QlbO+VGAFQBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773831522; c=relaxed/simple;
	bh=kLYySycm4Q+kO2x2jmLEs+z7oAnQtdjmqDIbHrWcbjw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FkrwECbg3IvgAO1goomj0dMiHNJE6Vc3Vq3XhGmg0OFAcloAvlmdMSZsQHZw0d7weI12MXG4mUTP13qATgSV2r0ch+PDyGp3PFIKjEWL6yIcXqNWCVlOG40sZWdTk5OZi0vwa8vzW/Y8Yisl7Ds8CaInm3dmh4arWvTEBi8058E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eKiMcZ85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eKiMcZ85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65881C19421;
	Wed, 18 Mar 2026 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831521;
	bh=kLYySycm4Q+kO2x2jmLEs+z7oAnQtdjmqDIbHrWcbjw=;
	h=From:To:Cc:Subject:Date:From;
	b=eKiMcZ85WLFC8bXWA/cKx5AD46CSeZMTj7t+7hTK626aenEZLjVU/M1bTaE/8BRRS
	 X6S1Y6bTAssMWXPL91D/crg1FtPFmAE77lAntj2Q7m/PYz0wUHGJzu4AZOtr5VKYhD
	 O9x+2NB3x0e+Qee3RPqpqmkTck/x41t2dPoDUPGIkmdpXAuih590JlibeZmTDiQlQj
	 +q9tqVFXNLT50Bo4J93EDhzKNN36MtH2iOtNw1iebPTvJL5rSLJyP/H3K7GSINY4cU
	 Jl739DvgI4xC+TxFvGCyIhqDj4Pg7a/bTjrprZ63VJjVDKtRWfpfjBV+NYDfdH+Dsr
	 4yKWpa/0srIqQ==
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
Subject: [PATCH 0/8] memblock: improve late freeing of reserved memory
Date: Wed, 18 Mar 2026 12:58:19 +0200
Message-ID: <20260318105827.1358927-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
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

Mike Rapoport (Microsoft) (8):
  powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
  powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
  mm: move free_reserved_area() to mm/memblock.c
  memblock: make free_reserved_area() more robust
  memblock: extract page freeing from free_reserved_area() into a helper
  memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
  memblock, treewide: make memblock_free() handle late freeing
  memblock: warn when freeing reserved memory before memory map is
    initialized

 arch/arm64/mm/init.c                       |   3 -
 arch/powerpc/kernel/fadump.c               |  16 +--
 arch/powerpc/platforms/powernv/opal-core.c |   9 +-
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
 mm/memblock.c                              | 110 ++++++++++++++-------
 mm/page_alloc.c                            |  46 ---------
 17 files changed, 102 insertions(+), 130 deletions(-)


base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
--
2.51.0
