From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] arm64: efi: add vmlinux debug link to the Image binary
Date: Wed, 25 Jan 2017 11:45:16 +0000
Message-ID: <CAKv+Gu_fh-Yf7yFx=5=ukrdsJXzyjm_ZqR6bc3Yh581BOBH3LA@mail.gmail.com>
References: <1485340759-28975-1-git-send-email-ard.biesheuvel@linaro.org> <1485340759-28975-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485340759-28975-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 January 2017 at 10:39, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> When building with debugging symbols, take the absolute path to the
> vmlinux binary and add it to the special PE/COFF debug table entry.
>
> These entries are used internally by EDK2 based* debug builds of UEFI
> to populate the DebugImageInfo table, which can be used by debuggers
> as well as by the OS itself to retrieve information about all loaded
> PE/COFF executables. This is highly useful for source level debugging
> of the UEFI stub.
>
> * for AArch64, this probably means all of them
>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/Makefile |  4 +++
>  arch/arm64/kernel/head.S   | 34 +++++++++++++++++++-
>  arch/arm64/kernel/image.h  |  3 ++
>  3 files changed, 40 insertions(+), 1 deletion(-)
>

If desired, I can simplify this patch somewhat, i.e., drop the image.h
change, and reduce the visibility of efi_debug_entry

> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 7d66bbaafc0c..6dbc0e5527f5 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -55,3 +55,7 @@ obj-y                                 += $(arm64-obj-y) vdso/ probes/
>  obj-m                                  += $(arm64-obj-m)
>  head-y                                 := head.o
>  extra-y                                        += $(head-y) vmlinux.lds
> +
> +ifeq ($(CONFIG_EFI)$(CONFIG_DEBUG_INFO),yy)
> +AFLAGS_head.o += -DVMLINUX_PATH="\"$(shell readlink -f $(objtree)/vmlinux)\""
> +endif
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 4b1abac3485a..b462ab1f11ef 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -149,7 +149,7 @@ extra_header_fields:
>         .quad   0                               // SizeOfHeapReserve
>         .quad   0                               // SizeOfHeapCommit
>         .long   0                               // LoaderFlags
> -       .long   0x6                             // NumberOfRvaAndSizes
> +       .long   (section_table - .) / 8         // NumberOfRvaAndSizes
>
>         .quad   0                               // ExportTable
>         .quad   0                               // ImportTable
> @@ -158,6 +158,11 @@ extra_header_fields:
>         .quad   0                               // CertificationTable
>         .quad   0                               // BaseRelocationTable
>
> +#ifdef CONFIG_DEBUG_INFO
> +       .long   efi_debug_table - _head         // DebugTable
> +       .long   efi_debug_table_size
> +#endif
> +
>         // Section table
>  section_table:
>
> @@ -204,6 +209,33 @@ section_table:
>          */
>         .align 12
>  efi_header_end:
> +
> +#ifdef CONFIG_DEBUG_INFO
> +       __INITDATA
> +
> +efi_debug_table:
> +       // EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
> +       .long   0                       // Characteristics
> +       .long   0                       // TimeDateStamp
> +       .short  0                       // MajorVersion
> +       .short  0                       // MinorVersion
> +       .long   2                       // Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
> +       .long   efi_debug_entry_size    // SizeOfData
> +       .long   efi_debug_entry_offset  // RVA
> +       .long   efi_debug_entry_offset  // FileOffset
> +
> +ENTRY(efi_debug_entry)
> +       // EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
> +       .long   0x3031424E              // Signature
> +       .long   0                       // Unknown
> +       .long   0                       // Unknown2
> +       .long   0                       // Unknown3
> +
> +       .asciz  VMLINUX_PATH
> +
> +       .set    efi_debug_entry_size, . - efi_debug_entry
> +       .set    efi_debug_table_size, . - efi_debug_table
> +#endif
>  #endif
>
>         __INIT
> diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
> index c7fcb232fe47..ad5406f011c2 100644
> --- a/arch/arm64/kernel/image.h
> +++ b/arch/arm64/kernel/image.h
> @@ -116,6 +116,9 @@ __efistub__end                      = KALLSYMS_HIDE(_end);
>  __efistub__edata               = KALLSYMS_HIDE(_edata);
>  __efistub_screen_info          = KALLSYMS_HIDE(screen_info);
>
> +#ifdef CONFIG_DEBUG_INFO
> +efi_debug_entry_offset = efi_debug_entry - _text;
> +#endif
>  #endif
>
>  #endif /* __ASM_IMAGE_H */
> --
> 2.7.4
>
