From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv4 4/4] arm64: dump: Add checking for writable and
 exectuable pages
Date: Fri, 28 Oct 2016 12:52:34 +0100
Message-ID: <CAKv+Gu-oYHNKcTpkPYNe7teT6iY8CT=g0_fPzJS-FTzvO5nxdA@mail.gmail.com>
References: <1477585654-8908-1-git-send-email-labbott@redhat.com> <1477585654-8908-5-git-send-email-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477585654-8908-5-git-send-email-labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, David Brown <david.brown-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27 October 2016 at 17:27, Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> Page mappings with full RWX permissions are a security risk. x86
> has an option to walk the page tables and dump any bad pages.
> (See e1a58320a38d ("x86/mm: Warn on W^X mappings")). Add a similar
> implementation for arm64.
>
> Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> Reviewed-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Tested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Signed-off-by: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> ---
> v4: Changed pr_info -> pr_warn. Added a separate count variable for uxn to avoid
> double counting.
> ---
>  arch/arm64/Kconfig.debug        | 29 ++++++++++++++++++++++
>  arch/arm64/include/asm/ptdump.h |  8 +++++++
>  arch/arm64/mm/dump.c            | 53 +++++++++++++++++++++++++++++++++++++++++
>  arch/arm64/mm/mmu.c             |  2 ++
>  4 files changed, 92 insertions(+)
>
> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 21a5b74..d1ebd46 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -42,6 +42,35 @@ config ARM64_RANDOMIZE_TEXT_OFFSET
>           of TEXT_OFFSET and platforms must not require a specific
>           value.
>
> +config DEBUG_WX
> +       bool "Warn on W+X mappings at boot"
> +       select ARM64_PTDUMP_CORE
> +       ---help---
> +         Generate a warning if any W+X mappings are found at boot.
> +
> +         This is useful for discovering cases where the kernel is leaving
> +         W+X mappings after applying NX, as such mappings are a security risk.
> +         This check also includes UXN, which should be set on all kernel
> +         mappings.
> +
> +         Look for a message in dmesg output like this:
> +
> +           arm64/mm: Checked W+X mappings: passed, no W+X pages found.
> +
> +         or like this, if the check failed:
> +
> +           arm64/mm: Checked W+X mappings: FAILED, <N> W+X pages found.
> +
> +         Note that even if the check fails, your kernel is possibly
> +         still fine, as W+X mappings are not a security hole in
> +         themselves, what they do is that they make the exploitation
> +         of other unfixed kernel bugs easier.
> +
> +         There is no runtime or memory usage effect of this option
> +         once the kernel has booted up - it's a one time check.
> +
> +         If in doubt, say "Y".
> +
>  config DEBUG_SET_MODULE_RONX
>         bool "Set loadable kernel module data as NX and text as RO"
>         depends on MODULES
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index f72ee69..6afd847 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -42,5 +42,13 @@ static inline int ptdump_debugfs_register(struct ptdump_info *info,
>         return 0;
>  }
>  #endif
> +void ptdump_check_wx(void);
>  #endif /* CONFIG_ARM64_PTDUMP_CORE */
> +
> +#ifdef CONFIG_DEBUG_WX
> +#define debug_checkwx()        ptdump_check_wx()
> +#else
> +#define debug_checkwx()        do { } while (0)
> +#endif
> +
>  #endif /* __ASM_PTDUMP_H */
> diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
> index bb36649..ef8aca8 100644
> --- a/arch/arm64/mm/dump.c
> +++ b/arch/arm64/mm/dump.c
> @@ -74,6 +74,9 @@ struct pg_state {
>         unsigned long start_address;
>         unsigned level;
>         u64 current_prot;
> +       bool check_wx;
> +       unsigned long wx_pages;
> +       unsigned long uxn_pages;
>  };
>
>  struct prot_bits {
> @@ -202,6 +205,35 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
>         }
>  }
>
> +static void note_prot_uxn(struct pg_state *st, unsigned long addr)
> +{
> +       if (!st->check_wx)
> +               return;
> +
> +       if ((st->current_prot & PTE_UXN) == PTE_UXN)
> +               return;
> +
> +       WARN_ONCE(1, "arm64/mm: Found non-UXN mapping at address %p/%pS\n",
> +                 (void *)st->start_address, (void *)st->start_address);
> +
> +       st->uxn_pages += (addr - st->start_address) / PAGE_SIZE;
> +}
> +
> +static void note_prot_wx(struct pg_state *st, unsigned long addr)
> +{
> +       if (!st->check_wx)
> +               return;
> +       if ((st->current_prot & PTE_RDONLY) == PTE_RDONLY)
> +               return;
> +       if ((st->current_prot & PTE_PXN) == PTE_PXN)
> +               return;
> +
> +       WARN_ONCE(1, "arm64/mm: Found insecure W+X mapping at address %p/%pS\n",
> +                 (void *)st->start_address, (void *)st->start_address);
> +
> +       st->wx_pages += (addr - st->start_address) / PAGE_SIZE;
> +}
> +
>  static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>                                 u64 val)
>  {
> @@ -219,6 +251,8 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
>                 unsigned long delta;
>
>                 if (st->current_prot) {
> +                       note_prot_uxn(st, addr);
> +                       note_prot_wx(st, addr);
>                         pt_dump_seq_printf(st->seq, "0x%016lx-0x%016lx   ",
>                                    st->start_address, addr);
>
> @@ -344,6 +378,25 @@ static struct ptdump_info kernel_ptdump_info = {
>         .base_addr      = VA_START,
>  };
>
> +void ptdump_check_wx(void)
> +{
> +       struct pg_state st = {
> +               .seq = NULL,
> +               .marker = (struct addr_marker[]) {
> +                       { -1, NULL},
> +               },
> +               .check_wx = true,
> +       };
> +
> +       walk_pgd(&st, &init_mm, 0);
> +       note_page(&st, 0, 0, 0);
> +       if (st.wx_pages || st.uxn_pages)
> +               pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
> +                       st.wx_pages, st.uxn_pages);
> +       else
> +               pr_info("Checked W+X mappings: passed, no W+X pages found\n");
> +}
> +
>  static int ptdump_init(void)
>  {
>         ptdump_initialize();
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 05615a3..2cbe2fe 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -42,6 +42,7 @@
>  #include <asm/tlb.h>
>  #include <asm/memblock.h>
>  #include <asm/mmu_context.h>
> +#include <asm/ptdump.h>
>
>  u64 idmap_t0sz = TCR_T0SZ(VA_BITS);
>
> @@ -396,6 +397,7 @@ void mark_rodata_ro(void)
>         section_size = (unsigned long)__init_begin - (unsigned long)__start_rodata;
>         create_mapping_late(__pa(__start_rodata), (unsigned long)__start_rodata,
>                             section_size, PAGE_KERNEL_RO);
> +       debug_checkwx();
>  }
>
>  static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
> --
> 2.7.4
>
