From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Add necessary checks before iterating over efi.memmap
Date: Tue, 13 Sep 2016 09:51:39 +0100
Message-ID: <CAKv+Gu_NrMGSu-9DxyZdurLWNbkHx2D480WS3gupazzC8U67EQ@mail.gmail.com>
References: <20160913032813.GA11652@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160913032813.GA11652-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chao Gao <chao.gao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 13 September 2016 at 04:28, Chao Gao <chao.gao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Commit 78ce248f (efi: Iterate over efi.memmap in for_each_efi_memory_desc())
> replaces the old loop by for_each_efi_memory_desc() which will encounter #PF
> when efi.memap are not initialized.
>
> In boot process, xen set EFI_PARAVIRT in xen_efi_init() before setup_arch()
> is called. This leads efi_memmap_init() will not initialize structures
> related to efi.memmap. However, the following functions e.g.
> efi_find_mirror(), efi_print_memmap() and efi_free_boot_services() access
> efi.memmap without necessary checks. kernel and xen crash in this case.
> After adding these checks, xen and kernel boot up normally.
>

OK, so looking at the hunks below, it looks to me like we should
initialize the efi.memmap to sane values in the EFI_PARAVIRT case,
rather than open coding this test each time for_each_efi_memory_desc()
is invoked.

> Signed-off-by: Chao Gao <chao.gao-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c    | 6 ++++++
>  arch/x86/platform/efi/quirks.c | 3 +++
>  2 files changed, 9 insertions(+)
>
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 1fbb408..68966dc 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -102,6 +102,9 @@ void __init efi_find_mirror(void)
>         efi_memory_desc_t *md;
>         u64 mirror_size = 0, total_size = 0;
>
> +       if (efi_enabled(EFI_PARAVIRT))
> +               return;
> +
>         for_each_efi_memory_desc(md) {
>                 unsigned long long start = md->phys_addr;
>                 unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> @@ -207,6 +210,9 @@ void __init efi_print_memmap(void)
>         efi_memory_desc_t *md;
>         int i = 0;
>
> +       if (efi_enabled(EFI_PARAVIRT))
> +               return;
> +
>         for_each_efi_memory_desc(md) {
>                 char buf[64];
>
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index 89d1146..4fa1e4d 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -251,6 +251,9 @@ void __init efi_free_boot_services(void)
>  {
>         efi_memory_desc_t *md;
>
> +       if (efi_enabled(EFI_PARAVIRT))
> +               return;
> +
>         for_each_efi_memory_desc(md) {
>                 unsigned long long start = md->phys_addr;
>                 unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
