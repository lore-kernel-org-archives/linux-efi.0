Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D514D47B425;
	Tue, 14 Jul 2026 14:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037922; cv=none; b=SNoCrYd8Fn1sVIVK9C+EB+NySKGgBVjXZgpqtkdyJzH27hjZMS7PD74pkrB/OpkO2AGAlU7YSS7lurUe61OmGlkXueUqacFl+XsttbIk6sBYOTERB9CI/b926E4SYPKI2GRjaiWiMj4EtkwkkjpK0LtJ0LiWZSSa7wr9rjRkc3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037922; c=relaxed/simple;
	bh=w+klhTdFU9VL3dvxDzm8zfdFs5zqm0APSZWeudQBGNo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iF2L+L1HXC+u84CHD1E5yqmmfu4AI2DBh+7lgRc1C8QXsiHzZ18TPDXk5NsIWtYdd9NGQkjN4d1YRCe+iTV2ESctueWQtbyzVqWW3ZxAvMQ+huB9Ly0lh6TadJkmHcDkCPuDDO89WCuU6/HuoLaHIKqFPoBRck+rHL2utGkUJCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZNaRsCzA; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZNaRsCzA"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A30D5339;
	Tue, 14 Jul 2026 07:05:13 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7DEFC3F7B4;
	Tue, 14 Jul 2026 07:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037917; bh=w+klhTdFU9VL3dvxDzm8zfdFs5zqm0APSZWeudQBGNo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ZNaRsCzAt1MnFAcOqfXFWvT4T4lPSEzMCEGtQrD8PcOucfEtWoppc1fCEKGc9cJXK
	 6RWZuY1RJvPlk32rxkdaZDZjs4oIrAl0+EdZq5ACM4/oIU1EOINAjEPtOBYdtmnjAy
	 gQq/h8AoBHc7SVStww7Gu1VeAurSqfnl+VdiDEVc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:50 +0100
Subject: [PATCH 01/22] mm: drop unused __mm_flags_set_mask_bits_word()
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-1-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1348;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=w+klhTdFU9VL3dvxDzm8zfdFs5zqm0APSZWeudQBGNo=;
 b=Ifi0NsVAxXOM3X00d29l/TBqH4M9i/euaIMaezX4RjYeZIsEEEbWOkkWnSKDmLxeFJ4OWFsJu
 hMlhl3GESzgCyZw7KMYDONi2E6s1qECPsAJEDuKo4qx+p6nf5J2ydG5
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

Commit 39f8049cd49f ("mm: update coredump logic to correctly
use bitmap mm flags") added coredump-specific helpers for the
remaining masked mm-flags update users.

That left __mm_flags_set_mask_bits_word() without any callers.
This is a special-purpose helper that is unlikely to be useful for
other purposes; best to remove it.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm_types.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ae9bca4eda5c..b4129beb9c4a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1432,18 +1432,6 @@ static inline unsigned long __mm_flags_get_word(const struct mm_struct *mm)
 	return *__mm_flags_get_bitmap(mm);
 }
 
-/*
- * Update the first system word of mm flags ONLY, applying the specified mask to
- * it, then setting all flags specified by bits.
- */
-static inline void __mm_flags_set_mask_bits_word(struct mm_struct *mm,
-		unsigned long mask, unsigned long bits)
-{
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
-
-	set_mask_bits(bitmap, mask, bits);
-}
-
 #define MM_MT_FLAGS	(MT_FLAGS_ALLOC_RANGE | MT_FLAGS_LOCK_EXTERN | \
 			 MT_FLAGS_USE_RCU)
 extern struct mm_struct init_mm;

-- 
2.51.2

