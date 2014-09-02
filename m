From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -v2] x86: only load initrd above 4g on second try
Date: Tue, 2 Sep 2014 14:57:01 -0700
Message-ID: <CAE9FiQXhnoUu=TxT8s0pqzV9nRBgm49unHJGZr-kgYp-11MBtQ@mail.gmail.com>
References: <1409684972-24829-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1409684972-24829-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Sep 2, 2014 at 12:09 PM, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
>
> Revert to old way to load initrd under 4G on first try,
> second try will use above 4G buffer when initrd is too big
> and does not fit under 4G.
>
> -v2: add print out for second try, and print out files buf address.
>
> Reported-by: Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
> Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> ---
>  arch/x86/boot/compressed/eboot.c               |   18 +++++++++++---=
----
>  drivers/firmware/efi/libstub/efi-stub-helper.c |    5 +++++
>  2 files changed, 16 insertions(+), 7 deletions(-)
>
> Index: linux-2.6/arch/x86/boot/compressed/eboot.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/boot/compressed/eboot.c
> +++ linux-2.6/arch/x86/boot/compressed/eboot.c
> @@ -1032,7 +1032,6 @@ struct boot_params *make_boot_params(str
>         int i;
>         unsigned long ramdisk_addr;
>         unsigned long ramdisk_size;
> -       unsigned long initrd_addr_max;
>
>         efi_early =3D c;
>         sys_table =3D (efi_system_table_t *)(unsigned long)efi_early-=
>table;
> @@ -1095,15 +1094,20 @@ struct boot_params *make_boot_params(str
>
>         memset(sdt, 0, sizeof(*sdt));
>
> -       if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
> -               initrd_addr_max =3D -1UL;
> -       else
> -               initrd_addr_max =3D hdr->initrd_addr_max;
> -
>         status =3D handle_cmdline_files(sys_table, image,
>                                       (char *)(unsigned long)hdr->cmd=
_line_ptr,
> -                                     "initrd=3D", initrd_addr_max,
> +                                     "initrd=3D", hdr->initrd_addr_m=
ax,
>                                       &ramdisk_addr, &ramdisk_size);
> +
> +       if (status !=3D EFI_SUCCESS &&
> +           hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G) {
> +               efi_printk(sys_table, "Trying to load files to higher=
 address\n");
> +               status =3D handle_cmdline_files(sys_table, image,
> +                                     (char *)(unsigned long)hdr->cmd=
_line_ptr,
> +                                     "initrd=3D", -1UL,
> +                                     &ramdisk_addr, &ramdisk_size);
> +       }
> +
>         if (status !=3D EFI_SUCCESS)
>                 goto fail2;
>         hdr->ramdisk_image =3D ramdisk_addr & 0xffffffff;
> Index: linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -396,6 +396,7 @@ efi_status_t handle_cmdline_files(efi_sy
>
>         if (file_size_total) {
>                 unsigned long addr;
> +               char buf[64];
>
>                 /*
>                  * Multiple files need to be at consecutive addresses=
 in memory,
> @@ -416,6 +417,10 @@ efi_status_t handle_cmdline_files(efi_sy
>                         goto free_file_total;
>                 }
>
> +               snprintf(buf, sizeof(buf), "files buf: [%lx,%lx)\n",
> +                                       file_addr, file_addr + file_s=
ize_total);

Sorry, Please ignore this version.

I only did make, but if fails with link.

drivers/firmware/efi/libstub/lib.a(efi-stub-helper.o): In function
`handle_cmdline_files':
efi-stub-helper.c:(.text+0xa16): undefined reference to `snprintf'



> +               efi_printk(sys_table_arg, buf);
> +
>                 addr =3D file_addr;
>                 for (j =3D 0; j < nr_files; j++) {
>                         unsigned long size;
