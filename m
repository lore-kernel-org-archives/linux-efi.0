Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BF53BCD14;
	Mon,  3 Aug 2026 13:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785765589; cv=none; b=lm+hWmeqLyOtUmfEUqfxF0+/LmW70sKyuwuJiKaaYMKAlIujB545DLz+KHAT9bSZRpyyhlu3dxi4q/a389S7qR1kNcADyqoZlF9g57RKCjcTgWYt9f58CoyTPmDsQJgetjPMgSQUewv6S+ev15YCqZW+WK5MTUTI9b3pvLT1mxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785765589; c=relaxed/simple;
	bh=BMco7cE6ZUb0x1sY/U4XBBksWpvbpHojwOQxtubK6HA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hl5RUgkce6lCHMieWkU+EChNLtQXBCOAwSRdG09e4fZXXpGaxlNC1KXotjKY+8ClocGsCPAgl7QlPw5NKAklGDC7CxgNCImVIh5naguQcVci7oOl1RMu9VuZ86Wr3/jy3iwdzqRCemdnRrBt4QrHef2cyhgkGdfFie8wDCjk8EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VdJzXRQm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VdJzXRQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4B91F000E9;
	Mon,  3 Aug 2026 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785765588;
	bh=JgJjMGVQwXfN1+lfqi/7mzYbORC4vBXwntqjWOpjj5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VdJzXRQmCKCQ7JgyKiUD1/ILZ8ALjapAPRXEniDDnzS1EoQJOd2Rh4mnj01mS0kaC
	 SkdwvAXDVmUbSsA21mXsGUsV6UFqBCfzHqr7sKaMJIwGAPUZ/EuQ/qXVQNy9gbWQou
	 k9r4ZeSmv7XSpcXC6vcb89age58OUEyz0Y3jtZ3UkudyTNaZ5gI+4+nRjmeVka/o9q
	 /dN7dYJ78mn13G49euOFXvjaEbz3SgPDfvCdEu2cZqtsnpAXKCLf+lhpTv+wU8hwAu
	 5uCt9p7JGa3sPVxgYgc/nGl9g631hfgqX2Lq234uZ0mjzzpUHJEqevNTssxpWPfwhD
	 A251zj+Snu4hw==
Message-ID: <01f07ea2-8bdd-4450-8a49-548f8b646cfd@kernel.org>
Date: Mon, 3 Aug 2026 15:59:35 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 14/07/2026 à 16:03, Kevin Brodsky a écrit :
> mm code often needs to know whether some mm represents a kernel or
> user address space. This is currently done by comparing the mm
> pointer with &init_mm; besides not being particularly elegant, this
> ignores the fact that other mm's (e.g. efi_mm) may also represent
> parts of the kernel address space.
> 
> Introduce a new mm flag MMF_KERNEL and set it for init_mm.
> Subsequent patches will use this flag to replace comparisons with
> &init_mm. No functional change is introduced for now.

Did you consider performance impact ? This test is usually done in quite 
critical memory handling functions.

init_mm is known at link time. Before your patch 08/22 there is just a 
comparison of mm (r3) with a constant (loaded in r10):

c0014048 <assert_pte_locked>:
c0014048:	3d 40 c1 09 	lis     r10,-16119
c001404c:	39 4a 03 98 	addi    r10,r10,920
c0014050:	7c 03 50 00 	cmpw    r3,r10
c0014054:	4d 82 00 20 	beqlr
...

After patch 08/22 we have, it first checks that mm is not 0, then it 
loads the word located at mm+528 then AND it with 0x1. This load might 
be costly.

c0014048 <assert_pte_locked>:
c0014048:	2c 03 00 00 	cmpwi   r3,0
c001404c:	7c 85 23 78 	mr      r5,r4
c0014050:	41 82 00 10 	beq     c0014060 <assert_pte_locked+0x18>
c0014054:	81 23 02 10 	lwz     r9,528(r3)
c0014058:	71 29 00 01 	andi.   r9,r9,1
c001405c:	4c 82 00 20 	bnelr
...

Christophe

> 
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   include/linux/mm_types.h | 10 ++++++++++
>   mm/init-mm.c             |  1 +
>   2 files changed, 11 insertions(+)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index a2e0dc5892ff..7838ea3aac00 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1414,6 +1414,8 @@ struct mm_struct {
>   	char flexible_array[] __aligned(__alignof__(unsigned long));
>   };
>   
> +#define MM_FLAGS_INIT(flags)	{ .__mm_flags = { BITMAP_FROM_U64(flags) } }
> +
>   static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
>   {
>   	return test_bit(flag, ACCESS_PRIVATE(&mm->flags, __mm_flags));
> @@ -2001,6 +2003,9 @@ enum {
>   #define MMF_TOPDOWN		31	/* mm searches top down by default */
>   #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
>   
> +#define MMF_KERNEL		32	/* mm belongs to the kernel */
> +#define MMF_KERNEL_MASK		BIT_ULL(MMF_KERNEL)
> +
>   #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
>   				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>   				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
> @@ -2008,6 +2013,11 @@ enum {
>   /* Legacy flags must fit within 32 bits. */
>   static_assert((u64)MMF_INIT_LEGACY_MASK <= (u64)UINT_MAX);
>   
> +static inline bool mm_is_kernel(const struct mm_struct *mm)
> +{
> +	return mm && mm_flags_test(MMF_KERNEL, mm);
> +}
> +
>   /*
>    * Initialise legacy flags according to masks, propagating selected flags on
>    * fork. Further flag manipulation can be performed by the caller.
> diff --git a/mm/init-mm.c b/mm/init-mm.c
> index 3e792aad7626..93773269bf87 100644
> --- a/mm/init-mm.c
> +++ b/mm/init-mm.c
> @@ -34,6 +34,7 @@ struct mm_struct init_mm = {
>   	.pgd		= swapper_pg_dir,
>   	.mm_users	= ATOMIC_INIT(2),
>   	.mm_count	= ATOMIC_INIT(1),
> +	.flags		= MM_FLAGS_INIT(MMF_KERNEL_MASK),
>   	.write_protect_seq = SEQCNT_ZERO(init_mm.write_protect_seq),
>   	MMAP_LOCK_INITIALIZER(init_mm)
>   	.page_table_lock =  __SPIN_LOCK_UNLOCKED(init_mm.page_table_lock),
> 

