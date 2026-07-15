Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6298B39A046;
	Wed, 15 Jul 2026 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784128040; cv=none; b=IVvNafFWVP8J+Hppqv2yk29PL2ApuFOK4c5qCtu/+PoTPOSVZ2a1fcnAz60xl5/SLbZ/hlvmV9YsVUSWlHEyBpEVzSJgPdSrnJoQEQPBq1Vvr/Z1cCMPK0xhjOidQdeZpq6sZl23DrgTKL81i8WQ0fNF+Sy1mKYKocpOHx494N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784128040; c=relaxed/simple;
	bh=+jFMWWv220aZ8z/A3E0zhi9BB4H/u0SqqJRjY/UOWiM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4sDuHt4fLZwdres2R1OuCSecel6zALaLiWY1dcKQXNDpTSRfSMrIiBB0VNLqWA0l934diTAkV32LxUI//1mYPRSYF5+h9h91tFbEHTGN1ccsCKxbV8ZsLzBDYvqB8gXjswDccFFxL13paeITeFdsjO48Trz9v+tnT9pY7WAdRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Z5zyq2Hj; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Z5zyq2Hj"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F4601477;
	Wed, 15 Jul 2026 08:07:13 -0700 (PDT)
Received: from [10.57.82.220] (unknown [10.57.82.220])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28E1B3F905;
	Wed, 15 Jul 2026 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784128037; bh=+jFMWWv220aZ8z/A3E0zhi9BB4H/u0SqqJRjY/UOWiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z5zyq2HjC1J3H+2sS3zu5v1h+CSpo+X2JamGTGR0pKplJ+iyMq9LehKG+jacWhbPZ
	 WPUxV70PTchy+e9ITMIQB1lc3Qrkdac2O7M9gEkdlvEpppy6u5k2BxIx/dsQ5U+PV6
	 B4YDMFmLqLte+c5rOhprH1XGuK2zbmrCTYOVdNc8=
Message-ID: <6d167aaa-e9b0-4687-970c-1c67d0df6344@arm.com>
Date: Wed, 15 Jul 2026 17:07:02 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/22] Simplify special kernel page table handling
To: linux-mm@kvack.org
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/07/2026 16:03, Kevin Brodsky wrote:
> Page table constructors and destructors were originally introduced
> specifically for user PTE pages. Over time, their use became more
> widespread, and starting from v6.16 they are called at all levels
> and for both user and kernel page tables [1]. Or so I thought. Turns
> out, we still have various special kernel page tables where the
> ctor/dtor are not called; vmemmap page tables is one such case.
>
> Looking closer, we do not actually need per-level ctors for kernel
> page tables. In fact we do not need ctors for them at all, because
> nothing is specific to kernel page tables in the ctor/dtor and
> nowadays they should be allocated with pagetable_alloc().
>
> Here's the plan: all the generic page table handling moves to
> pagetable_{alloc,free}(). Whatever is left is specific to user page
> tables; the ctor/dtor are only called for user page tables at the
> required levels (PTE/PMD), and renamed to make that clear.
>
> Doing this will allow us to remove a good amount of special casing,
> but there's quite a bit of churn to get there. Here's what this
> series does:
>
> 1. Introduce the concept of "kernel mm" and replace most comparisons
>    with &init_mm with a flag check (patch 1-12); no functional change
>    so far.
>
> 2. Move the page table accounting/type setting to pagetable_{alloc,free}
>    (patch 13-15). Kernel mm's do not need to call the ctor/dtor any
>    more.

The underlying assumption here is that pagetable_{alloc,free} are used
wherever the ctor/dtor are called, and as Sashiko pointed out there are
counterexamples:

1. sparc32 calls the ctor/dtor for user PTE pages, but uses a custom
allocator.

2. archs that do not select MMU_GATHER_TABLE_FREE do not use
pagetable_free() in tlb_remove_table().

3. arch_remove_memory() and vmemmap_free() are a bit of a mess - some
archs call the dtor and/or use pagetable_free() for freeing the direct
map page tables, some don't.

How I'm thinking to address these:

1. sparc32 does not use split ptlocks, so maybe doing the memory
accounting explicitly? Otherwise, we may need to keep the page type
handling + memory accounting in a separate helper that sparc32 can
explicitly call.

2. Always enable MMU_GATHER_TABLE_FREE. pagetable_free() should always
be used for pages allocated with pagetable_alloc().

3. Go through all the implementations of memory hotplug and vmemmap, and
ensure that pagetable_free() is used for those pages allocated with
pagetable_free() (and only those). That may well call for a separate series.

- Kevin
