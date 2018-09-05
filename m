From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3 3/5] x86/efi: Permanently save the EFI_MEMORY_MAP
 passed by the firmware
Date: Wed, 5 Sep 2018 13:48:33 +0200
Message-ID: <20180905114833.GW24082@hirez.programming.kicks-ass.net>
References: <1536099149-12564-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1536099149-12564-4-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536099149-12564-4-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 04, 2018 at 03:12:27PM -0700, Sai Praneeth Prakhya wrote:
> +void __init efi_save_original_memmap(void)
> +{
> +	efi_memory_desc_t *md;
> +	void *remapped_phys, *new_md;
> +	phys_addr_t new_phys, new_size;
> +
> +	new_size = efi.memmap.desc_size * efi.memmap.nr_map;
> +	new_phys = efi_memmap_alloc(efi.memmap.nr_map);
> +	if (!new_phys) {
> +		pr_err("Failed to allocate new EFI memmap\n");
> +		return;
> +	}
> +
> +	remapped_phys = memremap(new_phys, new_size, MEMREMAP_WB);
> +	if (!remapped_phys) {
> +		pr_err("Failed to remap new EFI memmap\n");
> +		__free_pages(pfn_to_page(PHYS_PFN(new_phys)), get_order(new_size));
> +		return;
> +	}
> +
> +	new_md = remapped_phys;
> +	for_each_efi_memory_desc(md) {
> +		memcpy(new_md, md, efi.memmap.desc_size);
> +		new_md += efi.memmap.desc_size;
> +	}

Should we ioremap_prot(remapped_phys, new_size, PROT_NONE), here? Such
that nobody can accidentally use this thing?

> +	original_memory_map.late = 1;
> +	original_memory_map.phys_map = new_phys;
> +	original_memory_map.map = remapped_phys;
> +	original_memory_map.nr_map = efi.memmap.nr_map;
> +	original_memory_map.desc_size = efi.memmap.desc_size;
> +	original_memory_map.map_end = remapped_phys + new_size;
> +	original_memory_map.desc_version = efi.memmap.desc_version;
> +
> +	original_memory_map_present = true;
> +}
> +#endif /* CONFIG_EFI_WARN_ON_ILLEGAL_ACCESS */
> -- 
> 2.7.4
> 
