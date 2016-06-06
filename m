From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] arm64: efi: Ensure efi_create_mapping() does not map
 overlapping regions
Date: Mon, 6 Jun 2016 11:43:01 +0200
Message-ID: <CAKv+Gu-Kiq30-BtQ_aYamLyTB6d8WWmnBM6bOM-+c+WciUnUwA@mail.gmail.com>
References: <1464707672-21882-1-git-send-email-catalin.marinas@arm.com> <1464707672-21882-3-git-send-email-catalin.marinas@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1464707672-21882-3-git-send-email-catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jeremy Linton <jeremy.linton-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 May 2016 at 17:14, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org> wrote:
> Since the EFI page size is 4KB, it is possible for a !4KB page kernel to
> align an EFI runtime map boundaries in a way that they can overlap
> within the same page. This requires the current create_pgd_mapping()
> code to be able to split existing larger mappings when an overlapping
> region needs to be mapped.
>
> With this patch, efi_create_mapping() scans the EFI memory map for
> overlapping regions and trims the length of the current map to avoid a
> large block mapping and subsequent split.
>

I remember the discussion, but IIRC this was about failure to do
break-before-make in general rather than a problem with splitting in
particular.

So first of all, I would like to point out that this failure to do
break-before-make is not a problem in practice, given that the EFI
page tables are not live until much later. The reason we want to fix
this is because the EFI page tables routines are shared with the
swapper, where it /is/ a concern, and there is a desire to make those
routines more strict when it comes to architectural rules regarding
page table manipulation.

Also, the reference to block mappings on !4K pages kernels is a bit
misleading here: such block mappings are at least 32 MB in size, and
we never map runtime code or data regions that big. The problem that
was flagged before is failure to do break-before-make, based on the
observation that a valid mapping (of the page that is shared between
two regions) is overwritten with another valid mapping. However, since
the 64K (or 16K) page that is shared between the two regions is mapped
with the exact same attributes (we ignore the permissions in that
case), the old and the new valid mappings are identical, which I don't
think should be a problem.

So, if it is allowed by the architecture to overwrite a page table
entry with the same value, perhaps we could educate the
break-before-make debug routines (if we merged those, I didn't check)
to allow that. And if we want to make absolutely sure that we don't
inadvertently map more than 32 MB worth of runtime services code or
data on a 16 KB pages kernel using block mappings, we could borrow the
PT debug logic to force mapping regions that are not aligned to
PAGE_SIZE down to pages in all cases. But I don't think we need the
logic in this patch.

Another comment below.

> Signed-off-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 78f52488f9ff..0d5753c31c7f 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -62,10 +62,26 @@ struct screen_info screen_info __section(.data);
>  int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
>  {
>         pteval_t prot_val = create_mapping_protection(md);
> +       phys_addr_t length = md->num_pages << EFI_PAGE_SHIFT;
> +       efi_memory_desc_t *next = md;
>
> -       create_pgd_mapping(mm, md->phys_addr, md->virt_addr,
> -                          md->num_pages << EFI_PAGE_SHIFT,
> -                          __pgprot(prot_val | PTE_NG));
> +       /*
> +        * Search for the next EFI runtime map and check for any overlap with
> +        * the current map when aligned to PAGE_SIZE. In such case, defer
> +        * mapping the end of the current range until the next
> +        * efi_create_mapping() call.
> +        */
> +       for_each_efi_memory_desc_continue(next) {
> +               if (!(next->attribute & EFI_MEMORY_RUNTIME))
> +                       continue;
> +               if (next->phys_addr < PAGE_ALIGN(md->phys_addr + length))
> +                       length -= (md->phys_addr + length) & ~PAGE_MASK;

This looks fishy. We could have more than two runtime regions sharing
a 64 KB page frame, for instance, and the middle regions will have
unaligned start and end addresses, and sizes smaller than 64 KB. This
subtraction may wrap in that case, producing a bogus length.

> +               break;
> +       }
> +
> +       if (length)
> +               create_pgd_mapping(mm, md->phys_addr, md->virt_addr, length,
> +                                  __pgprot(prot_val | PTE_NG));
>         return 0;
>  }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
