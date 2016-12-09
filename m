From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/4] efi: efi_print_memmap(): Call out invalid entries in
 the memory map early.
Date: Fri, 9 Dec 2016 16:18:04 +0000
Message-ID: <CAKv+Gu9Qs=bEee_Ks6ycsVEyb_W4bFB5YzGYXPXAm5f7QrtDNQ@mail.gmail.com>
References: <20161207213830.15984-1-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161207213830.15984-1-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 7 December 2016 at 21:38, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Some machines, such as the Lenovo ThinkPad W541 with firmware GNET80WW
> (2.28), include memory map entries with phys_addr=0x0 and num_pages=0.
> Currently the log output for this case (with efi=debug) looks like:
>
> [    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |  |  |  |  |  ] range=[0x0000000000000000-0xffffffffffffffff] (0MB)
>
> This is clearly wrong, and also not as informative as it could be.  This
> patch changes it so that if we find obviously invalid memory map
> entries, say so when we're printing the memory map.  It also detects the
> display of the address range calculation overflow, so the new output is:
>
> [    0.000000] efi: [Firmware Bug]: Invalid EFI memory map entry for 0x0 pages at 0x0000000000000000
> [    0.000000] efi: mem45: [Reserved           |   |  |  |  |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000] (0MB)
>
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 936a488..0263391 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -217,11 +217,27 @@ void __init efi_print_memmap(void)
>
>         for_each_efi_memory_desc(md) {
>                 char buf[64];
> +               bool valid = true;
> +               u64 size = (md->num_pages << EFI_PAGE_SHIFT) - 1;
> +
> +               if (md->num_pages == 0) {
> +                       size = 0;
> +                       valid = false;
> +               }
> +

This makes sense to me

> +               if (md->num_pages >= (((u64)-1LL) >> EFI_PAGE_SHIFT)) {
> +                       size = (u64)-1LL;
> +                       valid = false;
> +               }
> +

... but this not so much: setting size to U64_MAX does not do much to
clarify the line printed below

> +               if (!valid)
> +                       pr_info(FW_BUG "Invalid EFI memory map entry for 0x%llx pages at 0x%016llx\n",
> +                               md->num_pages, md->phys_addr);
>
>                 pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
>                         i++, efi_md_typeattr_format(buf, sizeof(buf), md),
>                         md->phys_addr,
> -                       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> +                       md->phys_addr + size,

... given that this wraps around to md->phys_addr -1

>                         (md->num_pages >> (20 - EFI_PAGE_SHIFT)));

... and this still uses the bogus num_pages value

>         }
>  }
> --
> 2.9.3
>

In general, I think it makes sense to disregard entries with num_pages
== 0, and disregarding values of num_pages that are obviously bogus is
also fine (although not as meaningful, given the use case), but that
means we should ignore the whole entry, and refrain from performing
arithmetic involving any of these values, or 'sanitize' the size by
setting it to U64_MAX
