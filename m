From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: arm: enable DMI/SMBIOS
Date: Thu, 1 Jun 2017 10:52:13 +0000
Message-ID: <CAKv+Gu-OK=0HSG5KmsZ+Zs0Xu2ox5Cva+Nbtgz0DXigk3e3aiA@mail.gmail.com>
References: <20170601104554.21267-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170601104554.21267-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Graeme Gregory <graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(add Russell to To: field)

On 1 June 2017 at 10:45, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Wire up the existing support for SMBIOS tables (aka DMI), by moving the
> arm64 init code to drivers/firmware/efi/arm-runtime.c (which is shared
> between ARM and arm64), and adding a asm/dmi.h header to ARM that defines
> the mapping routines for the firmware tables.
>
> This allows userspace to access these tables to discover system information
> exposed by the firmware. It also sets the hardware name used in crash
> dumps, e.g.,
>
>   Unable to handle kernel NULL pointer dereference at virtual address 00000000
>   pgd = ed3c0000
>   [00000000] *pgd=bf1f3835
>   Internal error: Oops: 817 [#1] SMP THUMB2
>   Modules linked in:
>   CPU: 0 PID: 759 Comm: bash Not tainted 4.10.0-09601-g0e8f38792120-dirty #112
>   Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
>   ^^^
>
> NOTE: This does *NOT* enable or encourage the use of DMI quirks, i.e., the
>       the practice of identifying the platform via DMI to decide whether
>       certain workarounds for buggy hardware and/or firmware need to be
>       enabled. This would require the DMI subsystem to be enabled much
>       earlier than we do on ARM, which is non-trivial.
>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Russell, if you have no objections to this patch, may we have your ack
please? I will take it via the EFI tree then.

Thanks,
Ard.


> ---
> v2: add missing include of <linux/dmi.h>
>     rebase onto v4.12-rc3
>
>  arch/arm/Kconfig                   | 11 +++++++++++
>  arch/arm/include/asm/dmi.h         | 19 +++++++++++++++++++
>  arch/arm64/kernel/efi.c            | 15 ---------------
>  drivers/firmware/efi/arm-runtime.c | 16 ++++++++++++++++
>  4 files changed, 46 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 4c1a35f15838..268f46bfc4d9 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -2061,6 +2061,17 @@ config EFI
>           is only useful for kernels that may run on systems that have
>           UEFI firmware.
>
> +config DMI
> +       bool "Enable support for SMBIOS (DMI) tables"
> +       depends on EFI
> +       default y
> +       help
> +         This enables SMBIOS/DMI feature for systems.
> +
> +         This option is only useful on systems that have UEFI firmware.
> +         However, even with this option, the resultant kernel should
> +         continue to boot on existing non-UEFI platforms.
> +
>  endmenu
>
>  menu "CPU Power Management"
> diff --git a/arch/arm/include/asm/dmi.h b/arch/arm/include/asm/dmi.h
> new file mode 100644
> index 000000000000..df2d2ff06f5b
> --- /dev/null
> +++ b/arch/arm/include/asm/dmi.h
> @@ -0,0 +1,19 @@
> +/*
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __ASM_DMI_H
> +#define __ASM_DMI_H
> +
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +
> +#define dmi_early_remap(x, l)          memremap(x, l, MEMREMAP_WB)
> +#define dmi_early_unmap(x, l)          memunmap(x)
> +#define dmi_remap(x, l)                        memremap(x, l, MEMREMAP_WB)
> +#define dmi_unmap(x)                   memunmap(x)
> +#define dmi_alloc(l)                   kzalloc(l, GFP_KERNEL)
> +
> +#endif
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 5d17f377d905..82cd07592519 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -11,7 +11,6 @@
>   *
>   */
>
> -#include <linux/dmi.h>
>  #include <linux/efi.h>
>  #include <linux/init.h>
>
> @@ -117,20 +116,6 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
>                                    set_permissions, md);
>  }
>
> -static int __init arm64_dmi_init(void)
> -{
> -       /*
> -        * On arm64, DMI depends on UEFI, and dmi_scan_machine() needs to
> -        * be called early because dmi_id_init(), which is an arch_initcall
> -        * itself, depends on dmi_scan_machine() having been called already.
> -        */
> -       dmi_scan_machine();
> -       if (dmi_available)
> -               dmi_set_dump_stack_arch_desc();
> -       return 0;
> -}
> -core_initcall(arm64_dmi_init);
> -
>  /*
>   * UpdateCapsule() depends on the system being shutdown via
>   * ResetSystem().
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 974c5a31a005..1cc41c3d6315 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -11,6 +11,7 @@
>   *
>   */
>
> +#include <linux/dmi.h>
>  #include <linux/efi.h>
>  #include <linux/io.h>
>  #include <linux/memblock.h>
> @@ -166,3 +167,18 @@ void efi_virtmap_unload(void)
>         efi_set_pgd(current->active_mm);
>         preempt_enable();
>  }
> +
> +
> +static int __init arm_dmi_init(void)
> +{
> +       /*
> +        * On arm64/ARM, DMI depends on UEFI, and dmi_scan_machine() needs to
> +        * be called early because dmi_id_init(), which is an arch_initcall
> +        * itself, depends on dmi_scan_machine() having been called already.
> +        */
> +       dmi_scan_machine();
> +       if (dmi_available)
> +               dmi_set_dump_stack_arch_desc();
> +       return 0;
> +}
> +core_initcall(arm_dmi_init);
> --
> 2.9.3
>
