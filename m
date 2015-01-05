From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 6/8] arm64/efi: move SetVirtualAddressMap() to UEFI
 stub
Date: Mon, 5 Jan 2015 16:20:16 +0000
Message-ID: <20150105162016.GD26699@leverpostej>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
 <1419245944-2424-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1419245944-2424-7-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

I have a few (minor) comments below.

On Mon, Dec 22, 2014 at 10:59:02AM +0000, Ard Biesheuvel wrote:
> In order to support kexec, the kernel needs to be able to deal with the
> state of the UEFI firmware after SetVirtualAddressMap() has been called.
> To avoid having separate code paths for non-kexec and kexec, let's move
> the call to SetVirtualAddressMap() to the stub: this will guarantee us
> that it will only be called once (since the stub is not executed during
> kexec), and ensures that the UEFI state is identical between kexec and
> normal boot.
> 
> This implies that the layout of the virtual mapping needs to be created
> by the stub as well. All regions are rounded up to a naturally aligned
> multiple of 64 KB (for compatibility with 64k pages kernels) and recorded
> in the UEFI memory map. The kernel proper reads those values and installs
> the mappings in a dedicated set of page tables that are swapped in during
> UEFI Runtime Services calls.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/efi.h       |  20 +++-
>  arch/arm64/kernel/efi.c            | 223 ++++++++++++++++++++-----------------
>  arch/arm64/kernel/setup.c          |   1 +
>  drivers/firmware/efi/libstub/fdt.c | 137 ++++++++++++++++++++++-
>  4 files changed, 270 insertions(+), 111 deletions(-)

[...]

> +static void efi_set_pgd(struct mm_struct *mm)
> +{
> +       cpu_switch_mm(mm->pgd, mm);
> +       flush_tlb_all();
> +       if (icache_is_aivivt())
> +               __flush_icache_all();
> +}

Do we have any idea how often we call runtime services?

I assume not all that often (read the RTC at boot, set/get variables).

If we're nuking the TLBs and I-cache a lot we'll probably need to
reserve an asid for the EFI virtmap.

[...]

> +void __init efi_virtmap_init(void)
> +{
> +       efi_memory_desc_t *md;
> +
> +       if (!efi_enabled(EFI_BOOT))
> +               return;
> +
> +       for_each_efi_memory_desc(&memmap, md) {
> +               u64 paddr, npages, size;
> +               pgprot_t prot;
> +
> +               if (!(md->attribute & EFI_MEMORY_RUNTIME))
> +                       continue;
> +               if (WARN(md->virt_addr == 0,
> +                        "UEFI virtual mapping incomplete or missing -- no entry found for 0x%llx\n",
> +                        md->phys_addr))
> +                       return;

I wonder if we might want to use a different address to signal a bad
mapping (e.g. 0UL-1 as it's not even EFI_PAGE_SIZE aligned), just in
case we have to handle a valid use of zero in future for some reason --
perhaps coming from another OS.

> +
> +               paddr = md->phys_addr;
> +               npages = md->num_pages;
> +               memrange_efi_to_native(&paddr, &npages);
> +               size = npages << PAGE_SHIFT;
> +
> +               pr_info("  EFI remap 0x%012llx => %p\n",

Why not use %016llx? We might only have 48-bit PAs currently, but we may
as well keep the VA and PA equally long when printing out -- that'll
also help to identify issues with garbage in the upper 16 bits of the
PA field.

[...]

> +/*
> + * This is the base address at which to start allocating virtual memory ranges
> + * for UEFI Runtime Services. This is a userland range so that we can use any
> + * allocation we choose, and eliminate the risk of a conflict after kexec.
> + */
> +#define EFI_RT_VIRTUAL_BASE    0x40000000

Nit: I'm not keen on the term "userland" here. You can map stuff to EL0
in the high half of the address space if you wanted, so TTBR0/TTBR1
aren't architecturally user/kernel.

s/userland/low half/, perhaps?

It might also be worth pointing out that the arbitrary base address
isn't zero so as to be less likely to be an idmap.

> +
> +static void update_memory_map(efi_memory_desc_t *memory_map,
> +                             unsigned long map_size, unsigned long desc_size,
> +                             int *count)
> +{
> +       u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
> +       efi_memory_desc_t *out = (void *)memory_map + map_size;
> +       int l;
> +
> +       for (l = 0; l < map_size; l += desc_size) {
> +               efi_memory_desc_t *in = (void *)memory_map + l;
> +               u64 paddr, size;
> +
> +               if (!(in->attribute & EFI_MEMORY_RUNTIME))
> +                       continue;
> +
> +               /*
> +                * Make the mapping compatible with 64k pages: this allows
> +                * a 4k page size kernel to kexec a 64k page size kernel and
> +                * vice versa.
> +                */
> +               paddr = round_down(in->phys_addr, SZ_64K);
> +               size = round_up(in->num_pages * EFI_PAGE_SIZE +
> +                               in->phys_addr - paddr, SZ_64K);
> +
> +               /*
> +                * Avoid wasting memory on PTEs by choosing a virtual base that
> +                * is compatible with section mappings if this region has the
> +                * appropriate size and physical alignment. (Sections are 2 MB
> +                * on 4k granule kernels)
> +                */
> +               if (IS_ALIGNED(in->phys_addr, SZ_2M) && size >= SZ_2M)
> +                       efi_virt_base = round_up(efi_virt_base, SZ_2M);
> +
> +               in->virt_addr = efi_virt_base + in->phys_addr - paddr;
> +               efi_virt_base += size;
> +
> +               memcpy(out, in, desc_size);
> +               out = (void *)out + desc_size;
> +               ++*count;
> +       }
> +}

This feels like this should live in arch/arm64, or under some other
directory specific to arm/arm64. That said, I guess the fdt stuff is
currently arm-specific anyway, so perhaps this is fine.

[...]

> @@ -248,12 +337,52 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>                 }
>         }
> 
> +       /*
> +        * Update the memory map with virtual addresses. The function will also
> +        * populate the spare second half of the memory_map allocation with
> +        * copies of just the EFI_MEMORY_RUNTIME entries so that we can pass it
> +        * straight into SetVirtualAddressMap()
> +        */
> +       update_memory_map(memory_map, map_size, desc_size,
> +                         &runtime_entry_count);
> +
> +       pr_efi(sys_table,
> +              "Exiting boot services and installing virtual address map...\n");

I believe that the memory map is allowed to change as a result of this
call, so I think this needs to be moved before update_memory_map.

Thanks,
Mark.
