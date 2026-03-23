Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC450363090;
	Mon, 23 Mar 2026 07:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774252141; cv=none; b=UfFGeD+UpJnPiEO1+4n7bPebcCrt9ygQ6263IdRE2dZWaEfOsOpuxijMV+ODQAPlBrTxTRyc5PMHnhrHBu+e7SCSszL7FIK83iaufvpMJU7qb8TUiDUzgfzzrAgTjCFZU9EBX0EMQmTXqHZJ9RWQYgCcev4Dqaj2TMqok0ZA+lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774252141; c=relaxed/simple;
	bh=ZPayAoUZgLwz6EhVKnVbCR0MqW3d3UF4hy1nzr/kEys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9twtqjIIZahydnIRGdVoPTVOd8jRp/zgvWDRFJm43PuiYjNaLjMwdoXyQU1rtZEHhKgyQ7U6zVxWNqFtuyPDjqg0DMYvdWlnQwszYRbpa/psvb8BEaBSbTQJrlu22SSNifP8JgbstsTrK3vWmDJIkupNV4KWvYxjfayCXQdcRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=soMwPHB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="soMwPHB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B1FC2BC9E;
	Mon, 23 Mar 2026 07:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252141;
	bh=ZPayAoUZgLwz6EhVKnVbCR0MqW3d3UF4hy1nzr/kEys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=soMwPHB478isjyOEuq0IFRN9Cief5Jqwxg1OL7jUkDAL9y4hBeM9dbR/1MWaRqGWi
	 ib0jpyTzOuLzovqiLkfFzH/sitT7zv4W8SFvjQAfIZyXowACHhmqxuqnkiN4Ye2w/b
	 fqdb/4qzrOD886HOPMUSVszQTzLVwA06GpzpYZb9RUwXxMKzldKhDOEpdPGEiqzvEz
	 d8ZnoMumXfNyr/H7/zGCKqVZFhNYMDERdxkrZ9jFtVB2x96iGjkhmG/En+iUsCJUVO
	 API6o3jBTJGcQaw3dzn8rTLMq1L6nSmRBE/0It/iNumPWF5phnJ73bZcJMJHMFZdCH
	 C3sxaPr5Q/wkA==
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
Subject: [PATCH v2 1/9] memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
Date: Mon, 23 Mar 2026 09:48:28 +0200
Message-ID: <20260323074836.3653702-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

free_reserved_area() expects end parameter to point to the first address
after the area, but reserve_mem_release_by_name() passes it the last
address inside the area.

Remove subtraction of one in calculation of the area end.

Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..d4a02f1750e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.53.0

