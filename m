From: Ganapatrao Kulkarni <gpkulkarni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/8] arm64/efi: ignore DT memory nodes instead of removing them
Date: Mon, 11 May 2015 21:58:27 +0530
Message-ID: <CAFpQJXV0Hq7pCGDsY4qLSJGiwWTYu1VtTPAPZ0dNADaNkELr6Q@mail.gmail.com>
References: <1431326520-17331-1-git-send-email-ard.biesheuvel@linaro.org>
	<1431326520-17331-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431326520-17331-7-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, "Kulkarni, Ganapatrao" <Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, May 11, 2015 at 12:11 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> There are two problems with the UEFI stub DT memory node removal
> routine:
> - it deletes nodes as it traverses the tree, which happens to work
>   but is not supported, as deletion invalidates the node iterator;
> - deleting memory nodes entirely may discard annotations in the form
>   of additional properties on the nodes.
>
> Now that the UEFI initialization has moved to an earlier stage, we can
> actually just ignore any memblocks that are installed after we have
> processed the UEFI memory map. This way, it is no longer necessary to
> remove the nodes, so we can remove that logic from the stub as well.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/mm/init.c               |  7 +++++++
>  drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
>  2 files changed, 8 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 64480b65ef17..95c239f43384 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -386,6 +386,13 @@ __setup("keepinitrd", keepinitrd_setup);
>
>  void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>  {
> +       /*
> +        * EFI_MEMMAP will be set /after/ UEFI has installed all memory based
> +        * on the content of the UEFI memory map.
> +        */
> +       if (efi_enabled(EFI_MEMMAP))
> +               return;
> +
>         if (!PAGE_ALIGNED(base)) {
>                 if (size < PAGE_SIZE - (base & ~PAGE_MASK)) {
>                         pr_warn("Ignoring memory block 0x%llx - 0x%llx\n",
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index ef5d764e2a27..343e7992bd8f 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -24,7 +24,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>                         unsigned long map_size, unsigned long desc_size,
>                         u32 desc_ver)
>  {
> -       int node, prev, num_rsv;
> +       int node, num_rsv;
>         int status;
>         u32 fdt_val32;
>         u64 fdt_val64;
> @@ -54,28 +54,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>                 goto fdt_set_fail;
>
>         /*
> -        * Delete any memory nodes present. We must delete nodes which
> -        * early_init_dt_scan_memory may try to use.
> -        */
> -       prev = 0;
> -       for (;;) {
> -               const char *type;
> -               int len;
> -
> -               node = fdt_next_node(fdt, prev, NULL);
> -               if (node < 0)
> -                       break;
> -
> -               type = fdt_getprop(fdt, node, "device_type", &len);
> -               if (type && strncmp(type, "memory", len) == 0) {
> -                       fdt_del_node(fdt, node);
> -                       continue;
> -               }
> -
> -               prev = node;
> -       }
> -
> -       /*
>          * Delete all memory reserve map entries. When booting via UEFI,
>          * kernel will use the UEFI memory map to find reserved regions.
>          */
> --
> 1.9.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Thanks Ard.
Tested this patch on my numa setup.

Tested-by: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>

thanks
Ganapat
