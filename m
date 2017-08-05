From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Enable reset attack mitigation
Date: Sat, 5 Aug 2017 10:50:50 +0100
Message-ID: <CAKv+Gu-fe-dw-UXZxen4909b=QOF=_RP-V6GHZ8A4u=iVaaqpw@mail.gmail.com>
References: <20170804212010.15064-1-mjg59@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170804212010.15064-1-mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 4 August 2017 at 22:20, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> If a machine is reset while secrets are present in RAM, it may be
> possible for code executed after the reboot to extract those secrets
> from untouched memory. The Trusted Computing Group specified a mechanism
> for requesting that the firmware clear all RAM on reset before booting
> another OS. This is done by setting the MemoryOverwriteRequestControl
> variable at startup. If userspace can ensure that all secrets are
> removed as part of a controlled shutdown, it can reset this variable to
> 0 before triggering a hardware reboot.
>

Shouldn't it be up to the kernel to decide whether this flag should be
cleared after userspace has indicated to it that it thinks it has
wiped all secrets from memory? The kernel itself may keep secrets as
well, and we may still crash in the time window between userspace
invoking shutdown and the kernel actually calling ResetSystem() in the
firmware.


> Signed-off-by: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c        |  3 ++
>  drivers/firmware/efi/Kconfig            | 10 ++++++
>  drivers/firmware/efi/libstub/Makefile   |  1 +
>  drivers/firmware/efi/libstub/arm-stub.c |  3 ++
>  drivers/firmware/efi/libstub/tpm.c      | 58 +++++++++++++++++++++++++++++++++
>  include/linux/efi.h                     |  7 ++++
>  6 files changed, 82 insertions(+)
>  create mode 100644 drivers/firmware/efi/libstub/tpm.c
>
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index c3e869eaef0c..a1686f3dc295 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -997,6 +997,9 @@ struct boot_params *efi_main(struct efi_config *c,
>         if (boot_params->secure_boot == efi_secureboot_mode_unset)
>                 boot_params->secure_boot = efi_get_secureboot(sys_table);
>
> +       /* Ask the firmware to clear memory on unclean shutdown */
> +       efi_enable_reset_attack_mitigation(sys_table);
> +
>         setup_graphics(boot_params);
>
>         setup_efi_pci(boot_params);
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 394db40ed374..2b4c39fdfa91 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -151,6 +151,16 @@ config APPLE_PROPERTIES
>
>           If unsure, say Y if you have a Mac.  Otherwise N.
>
> +config RESET_ATTACK_MITIGATION
> +       bool "Reset memory attack mitigation"
> +       depends on EFI_STUB
> +       help
> +         Request that the firmware clear the contents of RAM after a reboot
> +         using the TCG Platform Reset Attack Mitigation specification. This
> +         protects against an attacker forcibly rebooting the system while it
> +         still contains secrets in RAM, booting another OS and extracting the
> +         secrets.
> +
>  endmenu
>
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 37e24f525162..4b20a5516929 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -30,6 +30,7 @@ OBJECT_FILES_NON_STANDARD     := y
>  KCOV_INSTRUMENT                        := n
>
>  lib-y                          := efi-stub-helper.o gop.o secureboot.o
> +lib-$(CONFIG_RESET_ATTACK_MITIGATION) += tpm.o
>
>  # include the stub's generic dependencies from lib/ when building for ARM/arm64
>  arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index 8181ac179d14..1cb2d1c070c3 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -192,6 +192,9 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>                 goto fail_free_cmdline;
>         }
>
> +       /* Ask the firmware to clear memory on unclean shutdown */
> +       efi_enable_reset_attack_mitigation(sys_table);
> +
>         secure_boot = efi_get_secureboot(sys_table);
>
>         /*
> diff --git a/drivers/firmware/efi/libstub/tpm.c b/drivers/firmware/efi/libstub/tpm.c
> new file mode 100644
> index 000000000000..45a12311adc3
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/tpm.c
> @@ -0,0 +1,58 @@
> +/*
> + * TPM handling.
> + *
> + * Copyright (C) 2016 CoreOS, Inc
> + * Copyright (C) 2017 Google, Inc.
> + *     Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> + *
> + * This file is part of the Linux kernel, and is made available under the
> + * terms of the GNU General Public License version 2.
> + */
> +#include <linux/efi.h>
> +#include <asm/efi.h>
> +
> +#include "efistub.h"
> +
> +static const efi_char16_t efi_MemoryOverWriteRequest_name[] = {
> +       'M', 'e', 'm', 'o', 'r', 'y', 'O', 'v', 'e', 'r', 'w', 'r', 'i', 't',
> +       'e', 'R', 'e', 'q', 'u', 'e', 's', 't', 'C', 'o', 'n', 't', 'r', 'o',
> +       'l', 0
> +};
> +
> +#define MEMORY_ONLY_RESET_CONTROL_GUID \
> +       EFI_GUID(0xe20939be, 0x32d4, 0x41be, 0xa1, 0x50, 0x89, 0x7f, 0x85, 0xd4, 0x98, 0x29)
> +
> +#define get_efi_var(name, vendor, ...) \
> +       efi_call_runtime(get_variable, \
> +                        (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
> +                        __VA_ARGS__)
> +
> +#define set_efi_var(name, vendor, ...) \
> +       efi_call_runtime(set_variable, \
> +                        (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
> +                        __VA_ARGS__)
> +
> +/*
> + * Enable reboot attack mitigation. This requests that the firmware clear the
> + * RAM on next reboot before proceeding with boot, ensuring that any secrets
> + * are cleared. If userland has ensured that all secrets have bene removed
> + * from RAM before reboot it can simply reset this variable.
> + */
> +void efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg)
> +{
> +       u8 val = 1;
> +       efi_guid_t var_guid = MEMORY_ONLY_RESET_CONTROL_GUID;
> +       efi_status_t status;
> +       unsigned long datasize = 0;
> +
> +       status = get_efi_var(efi_MemoryOverWriteRequest_name, &var_guid,
> +                            NULL, &datasize, NULL);
> +
> +       if (status == EFI_NOT_FOUND)
> +               return;
> +
> +       set_efi_var(efi_MemoryOverWriteRequest_name, &var_guid,
> +                   EFI_VARIABLE_NON_VOLATILE |
> +                   EFI_VARIABLE_BOOTSERVICE_ACCESS |
> +                   EFI_VARIABLE_RUNTIME_ACCESS, sizeof(val), val);
> +}
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 8269bcb8ccf7..12e05118657c 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1497,6 +1497,13 @@ enum efi_secureboot_mode {
>  };
>  enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table);
>
> +#ifdef CONFIG_RESET_ATTACK_MITIGATION
> +void efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg);
> +#else
> +static inline void
> +efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) { }
> +#endif
> +
>  /*
>   * Arch code can implement the following three template macros, avoiding
>   * reptition for the void/non-void return cases of {__,}efi_call_virt():
> --
> 2.14.0.rc1.383.gd1ce394fe2-goog
>
