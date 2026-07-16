Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FAC3FE36D;
	Thu, 16 Jul 2026 10:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784197474; cv=none; b=JAgY6RJu/yUkx5YTsPL9zMebed7MwGuNAyf43e/FHC7wYEmiLJp5oaztnzIYbqJ4r9s256FKJhe+h+6xw3Vx7wfMGu2BpSA1dhBJ5HXMW8MT7K1oRZsyFJakIIseTn/NPy2Q7iAiV4C1kN92GmUox/YwXxO1n6YbpcxLs1gPM4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784197474; c=relaxed/simple;
	bh=khk7OVdasrmWElu7v+he5pwEjEyq3lY0VQWweIBUcxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MFyEMc2IHLcVfPvcTvPdduivOARlwsWo6cjx/Cz1tryvDzmR7ScoaOv5WpjG2M6Hq2ctImRGth6ty8WjesOzQnEDiqPQIKkiu3ami/caxS3L59aCEE8sx74ggV4JaF8DrUdJuvyFSeyMhe/vYdHQq0eTRbUb+OyYy4wIr/REbBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SWDF44sf; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SWDF44sf"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3F8F5339;
	Thu, 16 Jul 2026 03:24:28 -0700 (PDT)
Received: from [10.57.83.230] (unknown [10.57.83.230])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 182553F7B4;
	Thu, 16 Jul 2026 03:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784197472; bh=khk7OVdasrmWElu7v+he5pwEjEyq3lY0VQWweIBUcxo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SWDF44sfS9ouTQyhsoNdjcWghv45qcZdrZRpeHggINaskI2QpA6EEqdwPjW+Vmzil
	 Oyq849N1iPFY3DmI3306OC+qsEo5JxlkY3KFxgqlm9GhUkNprXodnPXqeKyEOXySIf
	 HsuDVJWHrNHvd1lWMUDXxIJ2DVjDYvMciJe7gb58=
Message-ID: <b0811447-e865-4cde-a45d-8a9f0bd25a4a@arm.com>
Date: Thu, 16 Jul 2026 12:24:18 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/22] mm: pagewalk: drop redundant address check for
 kernel mm walks
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
 <20260714-remove_pgtable_cdtor-v1-17-44be8a7685d7@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-17-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/07/2026 16:04, Kevin Brodsky wrote:
> Commit 8b1cb4a2e819 ("mm/pagewalk: fix EFI_PGT_DUMP of
> espfix area") made no-VMA page table walks use
> pte_offset_kernel() for any address above TASK_SIZE. This avoided
> pte_offset_map() validation on EFI page table dumps, where efi_mm
> could walk x86 espfix PMDs that intentionally look bad to pmd_bad().

Sashiko rightly doesn't like this patch. Turns out 8b1cb4a2e819's commit
message and the comment it added are narrower than what the problem
really is: on x86, due to things like
/sys/kernel/debug/page_tables/current_kernel, we may be walking kernel
page tables even when walk->mm is a regular user mm. Just checking the
mm is therefore not sufficient.

Will replace this patch with a rewording of the comment to avoid
suggesting the issue is specific to efi_mm.

- Kevin


> efi_mm is now marked with MMF_KERNEL, and no-VMA walks use
> mm_is_kernel() to select pte_offset_kernel() for kernel mm's. As a
> result we no longer need to handle the EFI_PGT_DUMP case explicitly.The
> address check is therefore redundant for EFI_PGT_DUMP and makes the
> condition harder to reason about.
>
> Remove the address check and associated comment; mm_is_kernel()
> should be sufficient on its own.
>
> Tested by booting x86 QEMU with CONFIG_EFI_PGT_DUMP=y and reading
> /sys/kernel/debug/page_tables/efi.
>
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  mm/pagewalk.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a3f47d1de3c5..0dd9d4ad9b68 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -68,17 +68,14 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	if (walk->no_vma) {
>  		/*
>  		 * pte_offset_map() might apply user-specific validation.
> -		 * Indeed, on x86_64 the pmd entries set up by init_espfix_ap()
> -		 * fit its pmd_bad() check (_PAGE_NX set and _PAGE_RW clear),
> -		 * and CONFIG_EFI_PGT_DUMP efi_mm goes so far as to walk them.
>  		 */
> -		if (mm_is_kernel(walk->mm) || addr >= TASK_SIZE)
> +		if (mm_is_kernel(walk->mm))
>  			pte = pte_offset_kernel(pmd, addr);
>  		else
>  			pte = pte_offset_map(pmd, addr);
>  		if (pte) {
>  			err = walk_pte_range_inner(pte, addr, end, walk);
> -			if (!mm_is_kernel(walk->mm) && addr < TASK_SIZE)
> +			if (!mm_is_kernel(walk->mm))
>  				pte_unmap(pte);
>  		}
>  	} else {
>
