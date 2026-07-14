Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C6043F8AF;
	Tue, 14 Jul 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037935; cv=none; b=DBq+JYZeH/Vaf8JyVSfwKZeA+icRFWqgr5f1/BwMWAyWkKke85LYt6kQ0Iatihz2+f9Ojy1xec9rnHxD60BFPR4cMT2h46INUR1cMAlxx+Ahsp7Q8oyMRmUMNKWX4xliIWxVxw0kqGm2CHB3/HkMlyzLYY9O+NJ+tuLQCtGSee0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037935; c=relaxed/simple;
	bh=FInc2gTxhVQc4LYtwtKoJPw43dSvFTnMs+LPVQ5s9u0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EG10cxRB8Da6rsROWmwzv5EQ6K9aYuiY3wrvsLA42nMkUPNo5NCIVbuzLCF1aMP8OF7DYyMBpMk3kZvjItG+Wz3orBMH0JmZa0xw0IJnybVRZhUPhBaU8dfj3D1TznIsI97ZlkMKukWxRktIPNa5Ahs8aRF8SeTFkZyh5Sx0KgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Bm1/z7nw; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Bm1/z7nw"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DB181516;
	Tue, 14 Jul 2026 07:05:29 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECA813F7B4;
	Tue, 14 Jul 2026 07:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037933; bh=FInc2gTxhVQc4LYtwtKoJPw43dSvFTnMs+LPVQ5s9u0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Bm1/z7nw3ZrVQHSoXKrtxTQs91wc4RUrXfic6nvC1VPB3At2KepfWXr7Aw3HYFpkn
	 ioHo5OCLJkJiU6MHz48diP4nr6YFWtjQg3UL72aeFoQQSfWxPSBxVE10gNTyxwI//k
	 BrtCJZVqyK4Ji57oD58xPcYajyNM3z8AN78Fhrlw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:52 +0100
Subject: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for init_mm
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2504;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=FInc2gTxhVQc4LYtwtKoJPw43dSvFTnMs+LPVQ5s9u0=;
 b=LLyApQy3cCX+sEK7+yEv+wdSQwFfqhZ/PtGYmJI+JJbZMoulhtvHZSYrG2onhzlRcBnCeJhTe
 oQ14mia3FhGBEfCDsSpVX5EPWBdyUPXpBCd8WmZOxEP54NLEVWz9CaD
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

mm code often needs to know whether some mm represents a kernel or
user address space. This is currently done by comparing the mm
pointer with &init_mm; besides not being particularly elegant, this
ignores the fact that other mm's (e.g. efi_mm) may also represent
parts of the kernel address space.

Introduce a new mm flag MMF_KERNEL and set it for init_mm.
Subsequent patches will use this flag to replace comparisons with
&init_mm. No functional change is introduced for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm_types.h | 10 ++++++++++
 mm/init-mm.c             |  1 +
 2 files changed, 11 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a2e0dc5892ff..7838ea3aac00 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1414,6 +1414,8 @@ struct mm_struct {
 	char flexible_array[] __aligned(__alignof__(unsigned long));
 };
 
+#define MM_FLAGS_INIT(flags)	{ .__mm_flags = { BITMAP_FROM_U64(flags) } }
+
 static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
 {
 	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
@@ -2001,6 +2003,9 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_KERNEL		32	/* mm belongs to the kernel */
+#define MMF_KERNEL_MASK		BIT_ULL(MMF_KERNEL)
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
@@ -2008,6 +2013,11 @@ enum {
 /* Legacy flags must fit within 32 bits. */
 static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
 
+static inline bool mm_is_kernel(const struct mm_struct *mm)
+{
+	return mm && mm_flags_test(MMF_KERNEL, mm);
+}
+
 /*
  * Initialise legacy flags according to masks, propagating selected flags on
  * fork. Further flag manipulation can be performed by the caller.
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 3e792aad7626..93773269bf87 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -34,6 +34,7 @@ struct mm_struct init_mm = {
 	.pgd		= swapper_pg_dir,
 	.mm_users	= ATOMIC_INIT(2),
 	.mm_count	= ATOMIC_INIT(1),
+	.flags		= MM_FLAGS_INIT(MMF_KERNEL_MASK),
 	.write_protect_seq = SEQCNT_ZERO(init_mm.write_protect_seq),
 	MMAP_LOCK_INITIALIZER(init_mm)
 	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),

-- 
2.51.2

