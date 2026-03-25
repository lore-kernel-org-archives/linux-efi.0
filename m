Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8797927E05E;
	Wed, 25 Mar 2026 08:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774428713; cv=none; b=sKSFCWPXncIk6LKeSrDDK8ozDcqxhL4I+FzpbwZ/hlNJ2dLqHI5HNUAkcspgU5brE6Qw1aFPGcpJkrL2jlG65Tmlqq0d7gst0MpVZO25AlgkjTCxdpS0B9zdlCmjDToBOkvWPezxCuN0W2BuSqz1sAdukDEJ60LXcEhNoEw8QnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774428713; c=relaxed/simple;
	bh=wb0mpku6g4vk6LeYoqKTVgZtD079ouSEG5afLG7CYHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nftf2ImoQNjFalmcayTxtG+yu50x3TVouFgdHShWretSJYZ63WP48gFT2BU5S9EXzjpf9ehTHDzKSKUqnwY3EaE1WsG0xWh/om7kNe7/iUApF1Xv8N+PW+UvrXD2Mf9jNwlRF4HGpJFD4l8Hd+GHMLGPU0CFKqw40l2wkX1MUjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b1e3/Kii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b1e3/Kii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F3AC4CEF7;
	Wed, 25 Mar 2026 08:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774428713;
	bh=wb0mpku6g4vk6LeYoqKTVgZtD079ouSEG5afLG7CYHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1e3/Kii8oNvJgJ1AntUStWco7jvCebnWCtuv9zQCi2oUsNeV3CcabZ/VnDWT/4Bu
	 SdMcpnZUmux3R7PA238aj+buhQoQTRaRCXpWVo3lfGnlVNamvRsJHecUDO4uY4JETZ
	 xHJynwGclZ7csipkKUqwqfdSbhr2yZe/cHdAo7WUa3IRdxgN7vSItNWj8/2zpJM8+z
	 ZD01fhqLFQqk3slMEX+1PFlTdn7jeaS5TQm3vnMZ8RuoTjWtwNM3l4/A2ygJ2Hvbj0
	 HyR0HIfxv2d4zYS9GJNQyVlSryBTgfJVvw36EgMl3VIff5tJxeQAebFY0sT7kqzmW+
	 QsAWpfwuNt7wg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
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
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
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
	x86@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: Re: [PATCH v2 0/9] memblock: improve late freeing of reserved memory
Date: Wed, 25 Mar 2026 10:51:37 +0200
Message-ID: <177442863989.343689.8532363597437067519.b4-ty@b4>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Mon, 23 Mar 2026 09:48:27 +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> Following a recent discussion about leaks in x86 EFI [1], I audited usage of
> memblock_free_late() and free_reserved_area() and made some imporovements how
> we handle late freeing of the memory allocated with memblock.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/9] memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
      commit: ea459d3c24fefd90b60a702f4a73833434ae0248
[2/9] powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
      commit: 6e827110aea5fb9c53a5bf070413ffe5cad105b0
[3/9] powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
      commit: 3cf80188ecb828ed034ba562614cf1d48156b126
[4/9] mm: move free_reserved_area() to mm/memblock.c
      commit: 0aa264cda784f9fbe1a80ef13144cf81610086c7
[5/9] memblock: make free_reserved_area() more robust
      commit: 456ac994018598bc57ceaacb8a2c72e722c9755b
[6/9] memblock: extract page freeing from free_reserved_area() into a helper
      commit: 40191dae9ed84c816b593bb1b36a80f86c2279d1
[7/9] memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
      commit: b9e028ca869de24df00206d7ec640380670fc38f
[8/9] memblock, treewide: make memblock_free() handle late freeing
      commit: 64cb853c2ab4d8bd25b965f05e33ac0c6672bae7
[9/9] memblock: warn when freeing reserved memory before memory map is initialized
      commit: c7fc9cde41be029cf6675befbafcbb2dab40b39b

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.

