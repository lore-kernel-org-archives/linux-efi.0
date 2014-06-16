From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 4/4] efi: efistub: convert into static library
Date: Mon, 16 Jun 2014 17:24:30 +0200
Message-ID: <CAKv+Gu_w9N8kRHs8cXXMTJKACwMDpndix+Yh_Pkr_wKXcb7-5w@mail.gmail.com>
References: <1402931688-23597-1-git-send-email-ard.biesheuvel@linaro.org>
	<1402931688-23597-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402931688-23597-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 June 2014 17:14, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This patch changes both x86 and arm64 efistub implementations from #including
> shared .c files under drivers/firmware/efi to building the shared code as a
> static library.
>
> The x86 code uses a stub built into the boot executable which uncompresses the
> kernel at boot time. In this case, the library is linked into the decompressor.
>
> In the arm64 case, the stub is part of the kernel proper so the library is
> linked into the kernel proper as well.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/Kconfig                             |   1 +
>  arch/arm64/Makefile                            |   1 +
>  arch/arm64/kernel/efi-stub.c                   |   5 -
>  arch/x86/boot/compressed/Makefile              |   3 +-
>  arch/x86/boot/compressed/eboot.c               |   2 -
>  drivers/firmware/efi/Kconfig                   |   3 +
>  drivers/firmware/efi/Makefile                  |   2 +-
>  drivers/firmware/efi/arm-stub.c                | 284 -----------
>  drivers/firmware/efi/efi-stub-helper.c         | 632 -------------------------
>  drivers/firmware/efi/efistub.h                 |  42 --
>  drivers/firmware/efi/fdt.c                     | 279 -----------
>  drivers/firmware/efi/libstub/Makefile          |   5 +
>  drivers/firmware/efi/libstub/arm-stub.c        | 284 +++++++++++
>  drivers/firmware/efi/libstub/efi-stub-helper.c | 632 +++++++++++++++++++++++++
>  drivers/firmware/efi/libstub/efistub.h         |  42 ++
>  drivers/firmware/efi/libstub/fdt.c             | 279 +++++++++++
>  16 files changed, 1250 insertions(+), 1246 deletions(-)
>  delete mode 100644 drivers/firmware/efi/arm-stub.c
>  delete mode 100644 drivers/firmware/efi/efi-stub-helper.c
>  delete mode 100644 drivers/firmware/efi/efistub.h
>  delete mode 100644 drivers/firmware/efi/fdt.c
>  create mode 100644 drivers/firmware/efi/libstub/Makefile
>  create mode 100644 drivers/firmware/efi/libstub/arm-stub.c
>  create mode 100644 drivers/firmware/efi/libstub/efi-stub-helper.c
>  create mode 100644 drivers/firmware/efi/libstub/efistub.h
>  create mode 100644 drivers/firmware/efi/libstub/fdt.c
>

Oops, forgot to enable diff.renames ...

diffstat is actually

 arch/arm64/Kconfig                                   | 1 +
 arch/arm64/Makefile                                  | 1 +
 arch/arm64/kernel/efi-stub.c                         | 5 -----
 arch/x86/boot/compressed/Makefile                    | 3 ++-
 arch/x86/boot/compressed/eboot.c                     | 2 --
 drivers/firmware/efi/Kconfig                         | 3 +++
 drivers/firmware/efi/Makefile                        | 2 +-
 drivers/firmware/efi/libstub/Makefile                | 5 +++++
 drivers/firmware/efi/{ => libstub}/arm-stub.c        | 0
 drivers/firmware/efi/{ => libstub}/efi-stub-helper.c | 0
 drivers/firmware/efi/{ => libstub}/efistub.h         | 0
 drivers/firmware/efi/{ => libstub}/fdt.c             | 0
 12 files changed, 13 insertions(+), 9 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/Makefile
 rename drivers/firmware/efi/{ => libstub}/arm-stub.c (100%)
 rename drivers/firmware/efi/{ => libstub}/efi-stub-helper.c (100%)
 rename drivers/firmware/efi/{ => libstub}/efistub.h (100%)
 rename drivers/firmware/efi/{ => libstub}/fdt.c (100%)

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 7295419165e1..1ba4b5eae886 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -298,6 +298,7 @@ config EFI
>         select LIBFDT
>         select UCS2_STRING
>         select EFI_PARAMS_FROM_FDT
> +       select EFI_ARMSTUB
>         default y
>         help
>           This option provides support for runtime services provided
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 8185a913c5ed..bb8f21a626c0 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -48,6 +48,7 @@ core-$(CONFIG_XEN) += arch/arm64/xen/
>  core-$(CONFIG_CRYPTO) += arch/arm64/crypto/
>  libs-y         := arch/arm64/lib/ $(libs-y)
>  libs-y         += $(LIBGCC)
> +libs-$(CONFIG_EFI) += drivers/firmware/efi/libstub/
>
>  # Default target when executing plain make
>  KBUILD_IMAGE   := Image.gz
> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> index e4999021b07d..12456a7d3fa2 100644
> --- a/arch/arm64/kernel/efi-stub.c
> +++ b/arch/arm64/kernel/efi-stub.c
> @@ -13,11 +13,6 @@
>  #include <asm/efi.h>
>  #include <asm/sections.h>
>
> -/* Include shared EFI stub code */
> -#include "../../../drivers/firmware/efi/efi-stub-helper.c"
> -#include "../../../drivers/firmware/efi/fdt.c"
> -#include "../../../drivers/firmware/efi/arm-stub.c"
> -
>
>  efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>                                  unsigned long *image_addr,
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 0fcd9133790c..7a801a310e37 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -33,7 +33,8 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>  $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
>
>  ifeq ($(CONFIG_EFI_STUB), y)
> -       VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
> +       VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
> +                               $(objtree)/drivers/firmware/efi/libstub/lib.a
>  endif
>
>  $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index d338c134c659..d4d865438a0c 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -280,8 +280,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
>         }
>  }
>
> -#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
> -
>  static void find_bits(unsigned long mask, u8 *pos, u8 *size)
>  {
>         u8 first, len;
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index d420ae2d3413..4443ccc16409 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -54,6 +54,9 @@ config EFI_PARAMS_FROM_FDT
>           the EFI runtime support gets system table address, memory
>            map address, and other parameters from the device tree.
>
> +config EFI_ARMSTUB
> +       bool
> +
>  endmenu
>
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 9553496b0f43..c8be91c895e1 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,7 +1,7 @@
>  #
>  # Makefile for linux kernel
>  #
> -obj-$(CONFIG_EFI)                      += efi.o vars.o
> +obj-$(CONFIG_EFI)                      += efi.o vars.o libstub/
>  obj-$(CONFIG_EFI_VARS)                 += efivars.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)          += efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)                        += cper.o

[...]

Regards,
Ard.
