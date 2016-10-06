From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire section
Date: Thu, 6 Oct 2016 11:00:33 +0100
Message-ID: <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475747527-32387-1-git-send-email-rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Robert,

Apologies for only responding now. I did not quite manage to get my
head around your original email yet, but I don't think this patch is
the correct solution.

On 6 October 2016 at 10:52, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> There is a memory setup problem on ThunderX systems with certain
> memory configurations. The symptom is
>
>  kernel BUG at mm/page_alloc.c:1848!
>
> This happens for some configs with 64k page size enabled. The bug
> triggers for page zones with some pages in the zone not assigned to
> this particular zone. In my case some pages that are marked as nomap
> were not reassigned to the new zone of node 1, so those are still
> assigned to node 0.
>
> The reason for the mis-configuration is a change in pfn_valid() which
> reports pages marked nomap as invalid:
>
>  68709f45385a arm64: only consider memblocks with NOMAP cleared for linear mapping
>

These pages are owned by the firmware, which may map it with
attributes that conflict with the attributes we use for the linear
mapping. This means they should not be covered by the linear mapping.

> This causes pages marked as nomap being no long reassigned to the new
> zone in memmap_init_zone() by calling __init_single_pfn().
>

This sounds like the root cause of your issue. Could we not fix that instead?

> Fixing this by restoring the old behavior of pfn_valid() to use
> memblock_is_memory().

This is incorrect imo. In general, pfn_valid() means ordinary memory
covered by the linear mapping and the struct page array. Returning
reserved ranges that the kernel should not even touch only to please
the NUMA code seems like an inappropriate way to deal with this issue.

> Also changing users of pfn_valid() in arm64 code
> to use memblock_is_map_memory() where necessary. This only affects
> code in ioremap.c. The code in mmu.c still can use the new version of
> pfn_valid().
>
> Should be marked stable v4.5..
>
> Signed-off-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  arch/arm64/mm/init.c    | 2 +-
>  arch/arm64/mm/ioremap.c | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index bbb7ee76e319..25b8659c2a9f 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -147,7 +147,7 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
>  #ifdef CONFIG_HAVE_ARCH_PFN_VALID
>  int pfn_valid(unsigned long pfn)
>  {
> -       return memblock_is_map_memory(pfn << PAGE_SHIFT);
> +       return memblock_is_memory(pfn << PAGE_SHIFT);
>  }
>  EXPORT_SYMBOL(pfn_valid);
>  #endif
> diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
> index 01e88c8bcab0..c17c220b0c48 100644
> --- a/arch/arm64/mm/ioremap.c
> +++ b/arch/arm64/mm/ioremap.c
> @@ -21,6 +21,7 @@
>   */
>
>  #include <linux/export.h>
> +#include <linux/memblock.h>
>  #include <linux/mm.h>
>  #include <linux/vmalloc.h>
>  #include <linux/io.h>
> @@ -55,7 +56,7 @@ static void __iomem *__ioremap_caller(phys_addr_t phys_addr, size_t size,
>         /*
>          * Don't allow RAM to be mapped.
>          */
> -       if (WARN_ON(pfn_valid(__phys_to_pfn(phys_addr))))
> +       if (WARN_ON(memblock_is_map_memory(phys_addr)))
>                 return NULL;
>
>         area = get_vm_area_caller(size, VM_IOREMAP, caller);
> @@ -96,7 +97,7 @@ EXPORT_SYMBOL(__iounmap);
>  void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size)
>  {
>         /* For normal memory we already have a cacheable mapping. */
> -       if (pfn_valid(__phys_to_pfn(phys_addr)))
> +       if (memblock_is_map_memory(phys_addr))
>                 return (void __iomem *)__phys_to_virt(phys_addr);
>
>         return __ioremap_caller(phys_addr, size, __pgprot(PROT_NORMAL),
> --
> 2.7.0.rc3
>
