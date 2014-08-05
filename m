From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: Add efi= parameter parsing to the EFI boot stub
Date: Tue, 5 Aug 2014 17:51:13 +0200
Message-ID: <CAKv+Gu8bpU9D8MrsLSF=j_HDwcctjFEyvHnB2FPeAP-j77RKjQ@mail.gmail.com>
References: <1407245008-2994-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407245008-2994-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Maarten Lankhorst <m.b.lankhorst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 August 2014 15:23, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> We need a way to customize the behaviour of the EFI boot stub, in
> particular, we need a way to disable the "chunking" workaround, used
> when reading files from the EFI System Partition.
>
> One of my machines doesn't cope well when reading files in 1MB chunks to
> a buffer above the 4GB mark - it appears that the "chunking" bug
> workaround triggers another firmware bug. This was only discovered with
> commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"), and
> that commit is perfectly valid. The symptom I observed was a corrupt
> initrd rather than any kind of crash.
>
> efi= is now used to specify EFI parameters in two very different
> execution environments, the EFI boot stub and during kernel boot.
>
> There is also a slight performance optimization by enabling efi=nochunk,
> but that's offset by the fact that you're more likely to run into
> firmware issues, at least on x86. This is the rationale behind leaving
> the workaround enabled by default.
>
> Also provide some documentation for EFI_READ_CHUNK_SIZE and why we're
> using the current value of 1MB.
>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
> Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Maarten Lankhorst <m.b.lankhorst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>
> Folks, I added the EFI cmdline parsing to the arm stub too, but didn't
> compile test it.
>

Seems to work fine, both with and without efi=nochunk, when reading a
DTB padded to 16 megabytes.

Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

-- 
Ard.


>  Documentation/kernel-parameters.txt            |  5 ++-
>  arch/x86/boot/compressed/eboot.c               |  4 ++
>  arch/x86/platform/efi/efi.c                    | 19 +++++++-
>  drivers/firmware/efi/libstub/arm-stub.c        |  4 ++
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 62 +++++++++++++++++++++++++-
>  include/linux/efi.h                            |  2 +
>  6 files changed, 91 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 6eaa9cdb7094..7c5fc8ec9be8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -981,10 +981,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         Format: {"off" | "on" | "skip[mbr]"}
>
>         efi=            [EFI]
> -                       Format: { "old_map" }
> +                       Format: { "old_map", "nochunk" }
>                         old_map [X86-64]: switch to the old ioremap-based EFI
>                         runtime services mapping. 32-bit still uses this one by
>                         default.
> +                       nochunk: disable reading files in "chunks" in the EFI
> +                       boot stub, as chunking can cause problems with some
> +                       firmware implementations.
>
>         efi_no_storage_paranoia [EFI; X86]
>                         Using this parameter you can use more than 50% of
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index f277184e2ac1..3a7f9c047e9b 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1100,6 +1100,10 @@ struct boot_params *make_boot_params(struct efi_config *c)
>         else
>                 initrd_addr_max = hdr->initrd_addr_max;
>
> +       status = efi_parse_options(hdr->cmd_line_ptr);
> +       if (status != EFI_SUCCESS)
> +               goto fail2;
> +
>         status = handle_cmdline_files(sys_table, image,
>                                       (char *)(unsigned long)hdr->cmd_line_ptr,
>                                       "initrd=", initrd_addr_max,
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 850da94fef30..a1f745b0bf1d 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -943,8 +943,23 @@ static int __init parse_efi_cmdline(char *str)
>         if (*str == '=')
>                 str++;
>
> -       if (!strncmp(str, "old_map", 7))
> -               set_bit(EFI_OLD_MEMMAP, &efi.flags);
> +       while (*str) {
> +               if (!strncmp(str, "old_map", 7)) {
> +                       set_bit(EFI_OLD_MEMMAP, &efi.flags);
> +                       str += strlen("old_map");
> +               }
> +
> +               /*
> +                * Skip any options we don't understand. Presumably
> +                * they apply to the EFI boot stub.
> +                */
> +               while (*str && *str != ',')
> +                       str++;
> +
> +               /* If we hit a delimiter, skip it */
> +               if (*str == ',')
> +                       str++;
> +       }
>
>         return 0;
>  }
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index 480339b6b110..75ee05964cbc 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -226,6 +226,10 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
>                 goto fail_free_image;
>         }
>
> +       status = efi_parse_options(cmdline_ptr);
> +       if (status != EFI_SUCCESS)
> +               pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
> +
>         /*
>          * Unauthenticated device tree data is a security hazard, so
>          * ignore 'dtb=' unless UEFI Secure Boot is disabled.
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index 32d5cca30f49..a920fec8fe88 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -15,8 +15,23 @@
>
>  #include "efistub.h"
>
> +/*
> + * Some firmware implementations have problems reading files in one go.
> + * A read chunk size of 1MB seems to work for most platforms.
> + *
> + * Unfortunately, reading files in chunks triggers *other* bugs on some
> + * platforms, so we provide a way to disable this workaround, which can
> + * be done by passing "efi=nochunk" on the EFI boot stub command line.
> + *
> + * If you experience issues with initrd images being corrupt it's worth
> + * trying efi=nochunk, but chunking is enabled by default because there
> + * are far more machines that require the workaround than those that
> + * break with it enabled.
> + */
>  #define EFI_READ_CHUNK_SIZE    (1024 * 1024)
>
> +static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
> +
>  struct file_info {
>         efi_file_handle_t *handle;
>         u64 size;
> @@ -281,6 +296,49 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
>         efi_call_early(free_pages, addr, nr_pages);
>  }
>
> +/*
> + * Parse the ASCII string 'cmdline' for EFI options, denoted by the efi=
> + * option, e.g. efi=nochunk.
> + *
> + * It should be noted that efi= is parsed in two very different
> + * environments, first in the early boot environment of the EFI boot
> + * stub, and subsequently during the kernel boot.
> + */
> +efi_status_t efi_parse_options(char *cmdline)
> +{
> +       char *str;
> +
> +       /*
> +        * If no EFI parameters were specified on the cmdline we've got
> +        * nothing to do.
> +        */
> +       str = strstr(cmdline, "efi=");
> +       if (!str)
> +               return EFI_SUCCESS;
> +
> +       /* Skip ahead to first argument */
> +       str += strlen("efi=");
> +
> +       /*
> +        * Remember, because efi= is also used by the kernel we need to
> +        * skip over arguments we don't understand.
> +        */
> +       while (*str) {
> +               if (!strncmp(str, "nochunk", 7)) {
> +                       str += strlen("nochunk");
> +                       __chunk_size = -1UL;
> +               }
> +
> +               /* Group words together, delimited by "," */
> +               while (*str && *str != ',')
> +                       str++;
> +
> +               if (*str == ',')
> +                       str++;
> +       }
> +
> +       return EFI_SUCCESS;
> +}
>
>  /*
>   * Check the cmdline for a LILO-style file= arguments.
> @@ -423,8 +481,8 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>                         size = files[j].size;
>                         while (size) {
>                                 unsigned long chunksize;
> -                               if (size > EFI_READ_CHUNK_SIZE)
> -                                       chunksize = EFI_READ_CHUNK_SIZE;
> +                               if (size > __chunk_size)
> +                                       chunksize = __chunk_size;
>                                 else
>                                         chunksize = size;
>
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index efc681fd5895..0d37d3372d99 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1208,4 +1208,6 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>                                   unsigned long *load_addr,
>                                   unsigned long *load_size);
>
> +efi_status_t efi_parse_options(char *cmdline);
> +
>  #endif /* _LINUX_EFI_H */
> --
> 1.9.0
>
