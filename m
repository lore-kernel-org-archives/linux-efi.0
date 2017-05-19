From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/5] efi: Move the x86 secure boot switch to generic code
Date: Fri, 19 May 2017 15:00:32 +0100
Message-ID: <CAKv+Gu9e-r+m6TEBPOg+o01m5JmF9CYLfH4dc60a_K41zJoCKg@mail.gmail.com>
References: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149148299794.3427.549144000807596903.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

First of all, apologies for taking so long to respond.

On 6 April 2017 at 13:49, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Move the switch-statement in x86's setup_arch() that inteprets the
> secure_boot boot parameter to generic code.
>
> Suggested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>
>  arch/x86/kernel/setup.c            |   14 +-------------
>  drivers/firmware/efi/Kconfig       |   23 +++++++++++++++++++++++
>  drivers/firmware/efi/Makefile      |    3 ++-
>  drivers/firmware/efi/secure_boot.c |   34 ++++++++++++++++++++++++++++++++++
>  include/linux/efi.h                |    6 ++++++
>  5 files changed, 66 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/firmware/efi/secure_boot.c
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 4bf0c8926a1c..b89979ffa6e5 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1178,19 +1178,7 @@ void __init setup_arch(char **cmdline_p)
>         /* Allocate bigger log buffer */
>         setup_log_buf(1);
>
> -       if (efi_enabled(EFI_BOOT)) {
> -               switch (boot_params.secure_boot) {
> -               case efi_secureboot_mode_disabled:
> -                       pr_info("Secure boot disabled\n");
> -                       break;
> -               case efi_secureboot_mode_enabled:
> -                       pr_info("Secure boot enabled\n");
> -                       break;
> -               default:
> -                       pr_info("Secure boot could not be determined\n");
> -                       break;
> -               }
> -       }
> +       efi_set_secure_boot(boot_params.secure_boot);
>
>         reserve_initrd();
>
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 2e78b0b96d74..4b902ffbfcf4 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -84,6 +84,29 @@ config EFI_PARAMS_FROM_FDT
>  config EFI_RUNTIME_WRAPPERS
>         bool
>
> +config EFI_SECURE_BOOT
> +       bool "Support UEFI Secure Boot and lock down the kernel in secure boot mode"
> +       default n
> +       help
> +         UEFI Secure Boot provides a mechanism for ensuring that the firmware
> +         will only load signed bootloaders and kernels.  Secure boot mode may
> +         be determined from EFI variables provided by the BIOS if not

Please replace 'the BIOS' with something more generic.

> +         indicated by the boot parameters.
> +
> +         Enabling this option turns on support for UEFI secure boot in the
> +         kernel.  This will result in various kernel facilities being locked
> +         away from userspace if the kernel detects that it has been booted in
> +         secure boot mode.  If it hasn't been booted in secure boot mode, or
> +         this cannot be determined, the lock down doesn't occur.
> +
> +         The kernel facilities that get locked down include:
> +         - Viewing or changing the kernel's memory
> +         - Directly accessing ioports
> +         - Directly specifying ioports and other hardware parameters to drivers
> +         - Storing the kernel image unencrypted for hibernation
> +         - Loading unsigned modules
> +         - Kexec'ing unsigned images
> +
>  config EFI_ARMSTUB
>         bool
>
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index ad67342313ed..65969f840685 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -22,7 +22,8 @@ obj-$(CONFIG_EFI_FAKE_MEMMAP)         += fake_mem.o
>  obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)   += efibc.o
>  obj-$(CONFIG_EFI_TEST)                 += test/
>  obj-$(CONFIG_EFI_DEV_PATH_PARSER)      += dev-path-parser.o
> -obj-$(CONFIG_APPLE_PROPERTIES)         += apple-properties.o
> +obj-$(CONFIG_EFI_SECURE_BOOT)          += secure_boot.o
> +obj-$(CONFIG_APPLE_PROPERTIES)         += apple-properties.oo

Spurious change here

>
>  arm-obj-$(CONFIG_EFI)                  := arm-init.o arm-runtime.o
>  obj-$(CONFIG_ARM)                      += $(arm-obj-y)
> diff --git a/drivers/firmware/efi/secure_boot.c b/drivers/firmware/efi/secure_boot.c
> new file mode 100644
> index 000000000000..cf5bccae15e8
> --- /dev/null
> +++ b/drivers/firmware/efi/secure_boot.c

We have a file called secureboot.c in libstub/, so for consistency,
could you please drop the underscore?

> @@ -0,0 +1,34 @@
> +/* Core kernel secure boot support.
> + *
> + * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/efi.h>
> +#include <linux/kernel.h>
> +#include <linux/printk.h>
> +
> +/*
> + * Decide what to do when UEFI secure boot mode is enabled.
> + */
> +void __init efi_set_secure_boot(enum efi_secureboot_mode mode)
> +{
> +       if (efi_enabled(EFI_BOOT)) {
> +               switch (mode) {
> +               case efi_secureboot_mode_disabled:
> +                       pr_info("Secure boot disabled\n");
> +                       break;
> +               case efi_secureboot_mode_enabled:
> +                       pr_info("Secure boot enabled\n");
> +                       break;
> +               default:
> +                       pr_info("Secure boot could not be determined\n");
> +                       break;
> +               }
> +       }
> +}
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 94d34e0be24f..d8938a780290 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1488,6 +1488,12 @@ enum efi_secureboot_mode {
>  };
>  enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table);
>
> +#ifdef CONFIG_EFI_SECURE_BOOT
> +void __init efi_set_secure_boot(enum efi_secureboot_mode mode);
> +#else
> +static inline void efi_set_secure_boot(enum efi_secureboot_mode mode) {}
> +#endif
> +
>  /*
>   * Arch code can implement the following three template macros, avoiding
>   * reptition for the void/non-void return cases of {__,}efi_call_virt():
>
