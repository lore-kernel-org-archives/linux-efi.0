Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 457863BB126;
	Thu, 16 Jul 2026 09:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194528; cv=none; b=LlgnDJZeLO0EnI4k5uE9G9SKAfHL2y+Rume635HYRi7DLQLAkRpHSxwq/uxmLN7B9pmtFeWUVUFGoJsqiFT0mUnwvKWxdVPuXPHKczUpcWcnLEGQ8In2Ycq0xwVDrkTlyr3xPzDrpY3W7z4hN6Z1gLF2XD0+PlqdYtz1zlKZWmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194528; c=relaxed/simple;
	bh=1BVLyLaF1qecs+fgW08zdSlsqUZduOIGJBU1ULHtkjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cl5BGT1dWItDPli6dDjSl+vn9MVtrSH3ECJtNXWfSAUeIOrjSIff8bnMDlX7yy1UALv9qIy8H4kdnxoN4sW0FQZDlkgA23kl+wzpOpv5pwBjiuT/wdByZrozvvD0DS/hj98kCV6dIwAZAtBnIRFjfd/Oez+TYNnBxzbYi86eVxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=WfF+qmdk; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="WfF+qmdk"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3DB162F;
	Thu, 16 Jul 2026 02:35:20 -0700 (PDT)
Received: from [10.57.83.230] (unknown [10.57.83.230])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D48693F905;
	Thu, 16 Jul 2026 02:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784194524; bh=1BVLyLaF1qecs+fgW08zdSlsqUZduOIGJBU1ULHtkjI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WfF+qmdktWvhJyvXuGhu5iu7o0FWtOqQ5I0g8heoED31AV02y/qkTuaH5oKdQgNVz
	 Zk0OME+7E85ZuIaQ7/UmrEgiZGtJ9Onp9GZygZefACK6bIgVDye7nneuzPpsC+bgGq
	 OEE0LznhDFEX6R7AoNIGyWQ01U2Y9n4+8Xjc5eLI=
Message-ID: <02565237-d777-4c63-8b17-817df59feac4@arm.com>
Date: Thu, 16 Jul 2026 11:35:10 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/22] mm: use mm_is_kernel() in generic page table code
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
 <20260714-remove_pgtable_cdtor-v1-4-44be8a7685d7@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-4-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/07/2026 16:03, Kevin Brodsky wrote:
> diff --git a/mm/memory.c b/mm/memory.c
> index d5e87624f692..c0244c0b0756 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3394,13 +3394,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  	spinlock_t *ptl;
>  
>  	if (create) {
> - mapped_pte = pte = (mm == &init_mm) ?
> + mapped_pte = pte = mm_is_kernel(mm) ?
>  			pte_alloc_kernel_track(pmd, addr, mask) :
>  			pte_alloc_map_lock(mm, pmd, addr, &ptl);

As noted by Sashiko, this is a little problematic because if
apply_to_page_range() is called on efi_mm, then we will end up with
__pte_alloc_kernel() taking the init_mm lock, since that's hardcoded.

That probably means we should pass the mm to __pte_alloc_kernel().

FWIW calling the kernel alloc function for efi_mm is the correct thing
to do: this ensures we use pmd_populate_kernel() and therefore kernel
page table attributes (just like efi_create_mapping()). This path is
currently never hit because EFI regions whose permissions are modified
are PTE-mapped, but it is clearly more correct to use the kernel path
for such mm's.

- Kevin
