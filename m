Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B428B640;
	Mon,  1 Jun 2026 03:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780285818; cv=none; b=KStg5yMGkwv6FlqZV9DdkuFPPkceJ3DY7d3N+cGTuJQr1AHbZSNMzcI+useDbNxLDr0bSPcaiiB3v0h7HA4qzLvfCOzX82UozozxZlDRKp9aBcMBnqv52u/KLTMKr9ukf3NbS6gZJD+dtiW7PB9NL3QzIxzhqFDA9iQVVyyHxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780285818; c=relaxed/simple;
	bh=JdIDh7oDA4YqsglCX3nuBCSak6XOIkofRzyydFCz6hc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lJgYY/WOiWLrYdz1Swq0hsoyRg9kHzIjNlAaS6PppRD0Ax+zbZh6IEbv5o9lw2fuuY5tf/NDf19k9m+gBGNU1drATsHhFhmq2hCOKTEM0Rz/IluHmrIH5hewhAekYH/uA011GnXu6btgkLTClElH1tBw1jBedqJNeXG2Xa+3R0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=L1sFNeiF; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="L1sFNeiF"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6710F1E8D;
	Sun, 31 May 2026 20:50:03 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B3733F93E;
	Sun, 31 May 2026 20:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780285808; bh=JdIDh7oDA4YqsglCX3nuBCSak6XOIkofRzyydFCz6hc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L1sFNeiFgPIs0nS7w1vLogD2ZEYk6dsFvINDtlgoaPd/Wj1pKjX3jH1HUdBuPcTrz
	 vJ/ISGzLzcauXra7S5bub/fkjHXTDwduA/W3Ig/ZaqDJJYoOZKhOONwvyFvDdo+cwm
	 uHZeMLATXPYUGPcKUftixHwFtYxg51ERjEPY7L0s=
Message-ID: <7352c69a-556b-4cc2-ae65-0ed227da9f8a@arm.com>
Date: Mon, 1 Jun 2026 09:20:02 +0530
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] arm64/mm: Rename ptdesc_t
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520063417.2363417-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260520063417.2363417-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/05/26 12:04 PM, Anshuman Khandual wrote:
> ptdesc_t sounds very similar to the core MM struct ptdesc which is actually
> the memory descriptor for page table allocations. Hence rename this typedef
> element as ptval_t instead for better clarity and separation.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: linux-efi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This patch applies on v7.1-rc4.
> 
> Changes in V2:
> 
> - Renamed pxxval_t as ptval_t per Mike and David
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20260430034933.541634-1-anshuman.khandual@arm.com/
> 
>  arch/arm64/include/asm/io.h            |  2 +-
>  arch/arm64/include/asm/pgtable-types.h | 14 +++++++-------
>  arch/arm64/include/asm/ptdump.h        |  8 ++++----
>  arch/arm64/include/asm/tlbflush.h      |  4 ++--
>  arch/arm64/kernel/efi.c                |  4 ++--
>  arch/arm64/kernel/pi/map_kernel.c      |  2 +-
>  arch/arm64/kernel/pi/map_range.c       |  4 ++--
>  arch/arm64/kernel/pi/pi.h              |  2 +-
>  arch/arm64/mm/mmap.c                   |  4 ++--
>  arch/arm64/mm/pageattr.c               |  2 +-
>  arch/arm64/mm/ptdump.c                 |  2 +-
>  11 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
> index 8cbd1e96fd50..21c8e400107c 100644
> --- a/arch/arm64/include/asm/io.h
> +++ b/arch/arm64/include/asm/io.h
> @@ -270,7 +270,7 @@ static inline void __iomem *ioremap_prot(phys_addr_t phys, size_t size,
>  					 pgprot_t user_prot)
>  {
>  	pgprot_t prot;
> -	ptdesc_t user_prot_val = pgprot_val(user_prot);
> +	ptval_t user_prot_val = pgprot_val(user_prot);
>  
>  	if (WARN_ON_ONCE(!(user_prot_val & PTE_USER)))
>  		return NULL;
> diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
> index 265e8301d7ba..2f2f5527930f 100644
> --- a/arch/arm64/include/asm/pgtable-types.h
> +++ b/arch/arm64/include/asm/pgtable-types.h
> @@ -17,13 +17,13 @@
>   * Generic page table descriptor format from which
>   * all level specific descriptors can be derived.
>   */
> -typedef u64 ptdesc_t;
> +typedef u64 ptval_t;
>  
> -typedef ptdesc_t pteval_t;
> -typedef ptdesc_t pmdval_t;
> -typedef ptdesc_t pudval_t;
> -typedef ptdesc_t p4dval_t;
> -typedef ptdesc_t pgdval_t;
> +typedef ptval_t pteval_t;
> +typedef ptval_t pmdval_t;
> +typedef ptval_t pudval_t;
> +typedef ptval_t p4dval_t;
> +typedef ptval_t pgdval_t;
>  
>  /*
>   * These are used to make use of C type-checking..
> @@ -54,7 +54,7 @@ typedef struct { pgdval_t pgd; } pgd_t;
>  #define pgd_val(x)	((x).pgd)
>  #define __pgd(x)	((pgd_t) { (x) } )
>  
> -typedef struct { ptdesc_t pgprot; } pgprot_t;
> +typedef struct { ptval_t pgprot; } pgprot_t;
>  #define pgprot_val(x)	((x).pgprot)
>  #define __pgprot(x)	((pgprot_t) { (x) } )
>  
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index baff24004459..5b374a6ab34a 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -26,8 +26,8 @@ struct ptdump_info {
>  };
>  
>  struct ptdump_prot_bits {
> -	ptdesc_t	mask;
> -	ptdesc_t	val;
> +	ptval_t	mask;
> +	ptval_t	val;
>  	const char	*set;
>  	const char	*clear;
>  };
> @@ -36,7 +36,7 @@ struct ptdump_pg_level {
>  	const struct ptdump_prot_bits *bits;
>  	char name[4];
>  	int num;
> -	ptdesc_t mask;
> +	ptval_t mask;
>  };
>  
>  /*
> @@ -53,7 +53,7 @@ struct ptdump_pg_state {
>  	const struct mm_struct *mm;
>  	unsigned long start_address;
>  	int level;
> -	ptdesc_t current_prot;
> +	ptval_t current_prot;
>  	bool check_wx;
>  	unsigned long wx_pages;
>  	unsigned long uxn_pages;
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index c0bf5b398041..d52ac8c17190 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -725,9 +725,9 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
>  	sme_dvmsync_add_pending(batch, mm);
>  }
>  
> -static inline bool __pte_flags_need_flush(ptdesc_t oldval, ptdesc_t newval)
> +static inline bool __pte_flags_need_flush(ptval_t oldval, ptval_t newval)
>  {
> -	ptdesc_t diff = oldval ^ newval;
> +	ptval_t diff = oldval ^ newval;
>  
>  	/* invalid to valid transition requires no flush */
>  	if (!(oldval & PTE_VALID))
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index a81cb4aa4738..30cd7f804398 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -31,7 +31,7 @@ static bool region_is_misaligned(const efi_memory_desc_t *md)
>   * executable, everything else can be mapped with the XN bits
>   * set. Also take the new (optional) RO/XP bits into account.
>   */
> -static __init ptdesc_t create_mapping_protection(efi_memory_desc_t *md)
> +static __init ptval_t create_mapping_protection(efi_memory_desc_t *md)
>  {
>  	u64 attr = md->attribute;
>  	u32 type = md->type;
> @@ -85,7 +85,7 @@ static __init ptdesc_t create_mapping_protection(efi_memory_desc_t *md)
>  
>  int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
>  {
> -	ptdesc_t prot_val = create_mapping_protection(md);
> +	ptval_t prot_val = create_mapping_protection(md);
>  	bool page_mappings_only = (md->type == EFI_RUNTIME_SERVICES_CODE ||
>  				   md->type == EFI_RUNTIME_SERVICES_DATA);
>  
> diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
> index a852264958c3..fb44cbdd2f29 100644
> --- a/arch/arm64/kernel/pi/map_kernel.c
> +++ b/arch/arm64/kernel/pi/map_kernel.c
> @@ -165,7 +165,7 @@ static void noinline __section(".idmap.text") set_ttbr0_for_lpa2(phys_addr_t ttb
>  static void __init remap_idmap_for_lpa2(void)
>  {
>  	/* clear the bits that change meaning once LPA2 is turned on */
> -	ptdesc_t mask = PTE_SHARED;
> +	ptval_t mask = PTE_SHARED;
>  
>  	/*
>  	 * We have to clear bits [9:8] in all block or page descriptors in the
> diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
> index de52cd85c691..761b14893f74 100644
> --- a/arch/arm64/kernel/pi/map_range.c
> +++ b/arch/arm64/kernel/pi/map_range.c
> @@ -31,7 +31,7 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  		      u64 va_offset)
>  {
>  	u64 cmask = (level == 3) ? CONT_PTE_SIZE - 1 : U64_MAX;
> -	ptdesc_t protval = pgprot_val(prot) & ~PTE_TYPE_MASK;
> +	ptval_t protval = pgprot_val(prot) & ~PTE_TYPE_MASK;
>  	int lshift = (3 - level) * PTDESC_TABLE_SHIFT;
>  	u64 lmask = (PAGE_SIZE << lshift) - 1;
>  
> @@ -88,7 +88,7 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  	}
>  }
>  
> -asmlinkage phys_addr_t __init create_init_idmap(pgd_t *pg_dir, ptdesc_t clrmask)
> +asmlinkage phys_addr_t __init create_init_idmap(pgd_t *pg_dir, ptval_t clrmask)
>  {
>  	phys_addr_t ptep = (phys_addr_t)pg_dir + PAGE_SIZE; /* MMU is off */
>  	pgprot_t text_prot = PAGE_KERNEL_ROX;
> diff --git a/arch/arm64/kernel/pi/pi.h b/arch/arm64/kernel/pi/pi.h
> index aec3172d4003..5dfd8484d200 100644
> --- a/arch/arm64/kernel/pi/pi.h
> +++ b/arch/arm64/kernel/pi/pi.h
> @@ -35,4 +35,4 @@ void map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  
>  asmlinkage void early_map_kernel(u64 boot_status, phys_addr_t fdt);
>  
> -asmlinkage phys_addr_t create_init_idmap(pgd_t *pgd, ptdesc_t clrmask);
> +asmlinkage phys_addr_t create_init_idmap(pgd_t *pgd, ptval_t clrmask);
> diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
> index 92b2f5097a96..32e0771d6477 100644
> --- a/arch/arm64/mm/mmap.c
> +++ b/arch/arm64/mm/mmap.c
> @@ -34,7 +34,7 @@ static pgprot_t protection_map[16] __ro_after_init = {
>  	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_EXEC
>  };
>  
> -static ptdesc_t gcs_page_prot __ro_after_init = _PAGE_GCS_RO;
> +static ptval_t gcs_page_prot __ro_after_init = _PAGE_GCS_RO;
>  
>  /*
>   * You really shouldn't be using read() or write() on /dev/mem.  This might go
> @@ -87,7 +87,7 @@ arch_initcall(adjust_protection_map);
>  
>  pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
>  {
> -	ptdesc_t prot;
> +	ptval_t prot;
>  
>  	/* Short circuit GCS to avoid bloating the table. */
>  	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index ce035e1b4eaf..bbe98ac9ad8c 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -21,7 +21,7 @@ struct page_change_data {
>  	pgprot_t clear_mask;
>  };
>  
> -static ptdesc_t set_pageattr_masks(ptdesc_t val, struct mm_walk *walk)
> +static ptval_t set_pageattr_masks(ptval_t val, struct mm_walk *walk)
>  {
>  	struct page_change_data *masks = walk->private;
>  
> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> index ab9899ca1e5f..1c20144700d7 100644
> --- a/arch/arm64/mm/ptdump.c
> +++ b/arch/arm64/mm/ptdump.c
> @@ -194,7 +194,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
>  	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
>  	struct ptdump_pg_level *pg_level = st->pg_level;
>  	static const char units[] = "KMGTPE";
> -	ptdesc_t prot = 0;
> +	ptval_t prot = 0;
>  
>  	/* check if the current level has been folded dynamically */
>  	if (st->mm && ((level == 1 && mm_p4d_folded(st->mm)) ||

Hello Catalin/Will,

Any update on this patch ? Could this be pulled in for the next merge
window so that all D128 patches can be rebased as required. Thank you.

- Anshuman
