From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/3] efi/libstub: add random.c to ARM build
Date: Wed, 2 Nov 2016 09:37:13 +0000
Message-ID: <CAKv+Gu_=et=2zHBTYOr9thz2kS0cXHHYg96oWGRdD3D10fqXtw@mail.gmail.com>
References: <1476962486-18368-1-git-send-email-ard.biesheuvel@linaro.org> <1476962486-18368-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476962486-18368-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 20 October 2016 at 12:21, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Make random.c build for ARM by moving the fallback definition of
> EFI_ALLOC_ALIGN to efistub.h
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/Makefile          | 4 ++--
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 9 ---------
>  drivers/firmware/efi/libstub/efistub.h         | 9 +++++++++
>  3 files changed, 11 insertions(+), 11 deletions(-)
>

I need the following hunks on top to make this build on ARM:

""
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -8,6 +8,7 @@
  */

 #include <linux/efi.h>
+#include <linux/log2.h>
 #include <asm/efi.h>

 #include "efistub.h"
@@ -41,8 +42,9 @@
  */
 static unsigned long get_entry_num_slots(efi_memory_desc_t *md,
                                         unsigned long size,
-                                        unsigned long align)
+                                        unsigned long align_shift)
 {
+       unsigned long align = 1UL << align_shift;
        u64 start, end;

        if (md->type != EFI_CONVENTIONAL_MEMORY)
@@ -55,7 +57,7 @@
        if (start > end)
                return 0;

-       return (end - start + 1) / align;
+       return (end - start + 1) >> align_shift;
 }

 /*
@@ -98,7 +100,7 @@
                efi_memory_desc_t *md = (void *)memory_map + map_offset;
                unsigned long slots;

-               slots = get_entry_num_slots(md, size, align);
+               slots = get_entry_num_slots(md, size, ilog2(align));
                MD_NUM_SLOTS(md) = slots;
                total_slots += slots;
        }
"""

This is because ARM does not have a division routine in the
decompressor, and the fact that the division by 'align' should always
involve a power of 2 is not visible to the compiler.

If nobody objects, I will fold this in when applying

Thanks,
Ard.


> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index c06945160a41..40ddf8f763a8 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -36,11 +36,11 @@ arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
>  $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>         $(call if_changed_rule,cc_o_c)
>
> -lib-$(CONFIG_EFI_ARMSTUB)      += arm-stub.o fdt.o string.o \
> +lib-$(CONFIG_EFI_ARMSTUB)      += arm-stub.o fdt.o string.o random.o \
>                                    $(patsubst %.c,lib-%.o,$(arm-deps))
>
>  lib-$(CONFIG_ARM)              += arm32-stub.o
> -lib-$(CONFIG_ARM64)            += arm64-stub.o random.o
> +lib-$(CONFIG_ARM64)            += arm64-stub.o
>  CFLAGS_arm64-stub.o            := -DTEXT_OFFSET=$(TEXT_OFFSET)
>
>  #
> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> index aded10662020..3c2fe209bbfe 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> @@ -32,15 +32,6 @@
>
>  static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
>
> -/*
> - * Allow the platform to override the allocation granularity: this allows
> - * systems that have the capability to run with a larger page size to deal
> - * with the allocations for initrd and fdt more efficiently.
> - */
> -#ifndef EFI_ALLOC_ALIGN
> -#define EFI_ALLOC_ALIGN                EFI_PAGE_SIZE
> -#endif
> -
>  #define EFI_MMAP_NR_SLACK_SLOTS        8
>
>  struct file_info {
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
> index ee49cd23ee63..fe1f22584c69 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -15,6 +15,15 @@
>   */
>  #undef __init
>
> +/*
> + * Allow the platform to override the allocation granularity: this allows
> + * systems that have the capability to run with a larger page size to deal
> + * with the allocations for initrd and fdt more efficiently.
> + */
> +#ifndef EFI_ALLOC_ALIGN
> +#define EFI_ALLOC_ALIGN                EFI_PAGE_SIZE
> +#endif
> +
>  void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
>
>  efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
> --
> 2.7.4
>
