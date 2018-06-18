From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: Free allocated memory if remap fails
Date: Mon, 18 Jun 2018 11:57:59 +0200
Message-ID: <CAKv+Gu-L=UMkzet7s1rUEYMYZxtoE1M_Qa1dqKo134S_hoZWuw@mail.gmail.com>
References: <1529111365-32295-1-git-send-email-sai.praneeth.prakhya@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529111365-32295-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

Hello Sai,

On 16 June 2018 at 03:09, Sai Praneeth Prakhya
<sai.praneeth.prakhya@intel.com> wrote:
> From: Sai Praneeth <sai.praneeth.prakhya@intel.com>
>
> efi_memmap_alloc(), as the name suggests, allocates memory for a new efi
> memory map. It's referenced from couple of places, namely,
> efi_arch_mem_reserve() and efi_free_boot_services(). These callers,
> after allocating memory, remap it for further use. As usual, a routine
> check is performed to confirm successful remap. If the remap fails,
> ideally, the allocated memory should be freed but presently we just
> return without freeing it up. Hence, fix this bug by introducing
> efi_memmap_free() which frees memory allocated by efi_memmap_alloc().
>
> As efi_memmap_alloc() allocates memory depending on whether mm_init()
> has already been invoked or not, similarly efi_memmap_free() frees
> memory accordingly.
>
> efi_fake_memmap() also references efi_memmap_alloc() but it frees
> memory correctly using memblock_free(), but replace it with
> efi_memmap_free() to maintain consistency, as in, allocate memory with
> efi_memmap_alloc() and free memory with efi_memmap_free().
>
> It's a fact that memremap() and early_memremap() might never fail and
> this code might never get a chance to run but to maintain good kernel
> programming semantics, we might need this patch.
>
> Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> Reviewed-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>

Please don't include tags for reviews that did not happen on-list.

> Cc: Lee Chun-Yi <jlee@suse.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Dave Hansen <dave.hansen@intel.com>
> Cc: Bhupesh Sharma <bhsharma@redhat.com>
> Cc: Ricardo Neri <ricardo.neri@intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ravi Shankar <ravi.v.shankar@intel.com>
> Cc: Matt Fleming <matt@codeblueprint.co.uk>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>
> I found this bug when working on a different patch set which uses
> efi_memmap_alloc() and then noticed that I never freed the allocated
> memory. I found it weird, in the sense that, memory is allocated but is
> not freed (upon returning from an error). So, wasn't sure if that should
> be treated as a bug or should I just leave it as is because everything
> works fine even without this patch. Since the effort for the patch is
> very minimal, I just went ahead and posted one, so that I could know
> your thoughts on it.
>
> Note: Patch based on Linus's mainline tree V4.17
>
>  arch/x86/platform/efi/quirks.c  | 10 ++++++----
>  drivers/firmware/efi/fake_mem.c |  2 +-
>  drivers/firmware/efi/memmap.c   | 27 +++++++++++++++++++++++++++
>  include/linux/efi.h             |  1 +
>  4 files changed, 35 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 36c1f8b9f7e0..f223093f2df7 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -285,6 +285,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>         new = early_memremap(new_phys, new_size);
>         if (!new) {
>                 pr_err("Failed to map new boot services memmap\n");
> +               efi_memmap_free(new_phys, num_entries);
>                 return;
>         }
>
> @@ -429,7 +430,7 @@ void __init efi_free_boot_services(void)
>         new = memremap(new_phys, new_size, MEMREMAP_WB);
>         if (!new) {
>                 pr_err("Failed to map new EFI memmap\n");
> -               return;
> +               goto free_mem;
>         }
>
>         /*
> @@ -450,10 +451,11 @@ void __init efi_free_boot_services(void)
>
>         memunmap(new);
>
> -       if (efi_memmap_install(new_phys, num_entries)) {
> +       if (efi_memmap_install(new_phys, num_entries))
>                 pr_err("Could not install new EFI memmap\n");
> -               return;
> -       }
> +
> +free_mem:
> +       efi_memmap_free(new_phys, num_entries);

Doesn't this free the memory map that you just installed?

>  }
>
>  /*
> diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
> index 6c7d60c239b5..63edcedee25b 100644
> --- a/drivers/firmware/efi/fake_mem.c
> +++ b/drivers/firmware/efi/fake_mem.c
> @@ -79,7 +79,7 @@ void __init efi_fake_memmap(void)
>         new_memmap = early_memremap(new_memmap_phy,
>                                     efi.memmap.desc_size * new_nr_map);
>         if (!new_memmap) {
> -               memblock_free(new_memmap_phy, efi.memmap.desc_size * new_nr_map);
> +               efi_memmap_free(new_memmap_phy, new_nr_map);
>                 return;
>         }
>
> diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> index 5fc70520e04c..27d28cb4652d 100644
> --- a/drivers/firmware/efi/memmap.c
> +++ b/drivers/firmware/efi/memmap.c
> @@ -50,6 +50,33 @@ phys_addr_t __init efi_memmap_alloc(unsigned int num_entries)
>  }
>
>  /**
> + * efi_memmap_free - Free memory allocated by efi_memmap_alloc()
> + * @mem: Physical address allocated by efi_memmap_alloc()
> + * @num_entries: Number of entries in the allocated map.
> + *
> + * efi_memmap_alloc() allocates memory depending on whether mm_init()
> + * has already been invoked or not. It uses either memblock or "normal"
> + * page allocation. Use this function to free the memory allocated by
> + * efi_memmap_alloc(). Since the allocation is done in two different
> + * ways, similarly, we free it in two different ways.
> + *
> + */
> +void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries)
> +{
> +       unsigned long size = num_entries * efi.memmap.desc_size;
> +       unsigned int order = get_order(size);
> +       phys_addr_t end = mem + size - 1;
> +
> +       if (slab_is_available()) {
> +               __free_pages(pfn_to_page(PHYS_PFN(mem)), order);

How do you know that the memory you are freeing was allocated when
slab_is_available() was already true?

> +               return;
> +       }
> +
> +       if (memblock_free(mem, size))
> +               pr_err("Failed to free mem from %pa to %pa\n", &mem, &end);
> +}
> +
> +/**
>   * __efi_memmap_init - Common code for mapping the EFI memory map
>   * @data: EFI memory map data
>   * @late: Use early or late mapping function?
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 3016d8c456bc..f5d1cf44b320 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1016,6 +1016,7 @@ extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
>                                          struct range *range);
>  extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
>                                      void *buf, struct efi_mem_range *mem);
> +void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries);
>
>  extern int efi_config_init(efi_config_table_type_t *arch_tables);
>  #ifdef CONFIG_EFI_ESRT
> --
> 2.7.4
>
