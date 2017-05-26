From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 1/5] efi: Move the x86 secure boot switch to generic code
Date: Fri, 26 May 2017 15:59:03 +0800
Message-ID: <20170526075903.GB15587@linux-l9pv.suse>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <149563712496.9419.17514071929560674877.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149563712496.9419.17514071929560674877.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi David,

On Wed, May 24, 2017 at 03:45:25PM +0100, David Howells wrote:
> Move the switch-statement in x86's setup_arch() that inteprets the
> secure_boot boot parameter to generic code.
> 
> Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

I reviewed the context for this patch.

Reviewed-by: Joey Lee <jlee@suse.com>

Regards
Joey Lee

> ---
> 
>  arch/x86/kernel/setup.c           |   14 +-------------
>  drivers/firmware/efi/Kconfig      |   23 +++++++++++++++++++++++
>  drivers/firmware/efi/Makefile     |    1 +
>  drivers/firmware/efi/secureboot.c |   34 ++++++++++++++++++++++++++++++++++
>  include/linux/efi.h               |    6 ++++++
>  5 files changed, 65 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/firmware/efi/secureboot.c
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 0b4d3c686b1e..8bffbd8d2c1c 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -1177,19 +1177,7 @@ void __init setup_arch(char **cmdline_p)
>  	/* Allocate bigger log buffer */
>  	setup_log_buf(1);
>  
> -	if (efi_enabled(EFI_BOOT)) {
> -		switch (boot_params.secure_boot) {
> -		case efi_secureboot_mode_disabled:
> -			pr_info("Secure boot disabled\n");
> -			break;
> -		case efi_secureboot_mode_enabled:
> -			pr_info("Secure boot enabled\n");
> -			break;
> -		default:
> -			pr_info("Secure boot could not be determined\n");
> -			break;
> -		}
> -	}
> +	efi_set_secure_boot(boot_params.secure_boot);
>  
>  	reserve_initrd();
>  
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 394db40ed374..c40fdeaf9a45 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -84,6 +84,29 @@ config EFI_PARAMS_FROM_FDT
>  config EFI_RUNTIME_WRAPPERS
>  	bool
>  
> +config EFI_SECURE_BOOT
> +	bool "Support UEFI Secure Boot and lock down the kernel in secure boot mode"
> +	default n
> +	help
> +	  UEFI Secure Boot provides a mechanism for ensuring that the firmware
> +	  will only load signed bootloaders and kernels.  Secure boot mode may
> +	  be determined from EFI variables provided by the system firmware if
> +	  not indicated by the boot parameters.
> +
> +	  Enabling this option turns on support for UEFI secure boot in the
> +	  kernel.  This will result in various kernel facilities being locked
> +	  away from userspace if the kernel detects that it has been booted in
> +	  secure boot mode.  If it hasn't been booted in secure boot mode, or
> +	  this cannot be determined, the lock down doesn't occur.
> +
> +	  The kernel facilities that get locked down include:
> +	  - Viewing or changing the kernel's memory
> +	  - Directly accessing ioports
> +	  - Directly specifying ioports and other hardware parameters to drivers
> +	  - Storing the kernel image unencrypted for hibernation
> +	  - Loading unsigned modules
> +	  - Kexec'ing unsigned images
> +
>  config EFI_ARMSTUB
>  	bool
>  
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 0329d319d89a..9dfd8530063f 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
>  obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
>  obj-$(CONFIG_EFI_TEST)			+= test/
>  obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
> +obj-$(CONFIG_EFI_SECURE_BOOT)		+= secureboot.o
>  obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
>  
>  arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
> diff --git a/drivers/firmware/efi/secureboot.c b/drivers/firmware/efi/secureboot.c
> new file mode 100644
> index 000000000000..cf5bccae15e8
> --- /dev/null
> +++ b/drivers/firmware/efi/secureboot.c
> @@ -0,0 +1,34 @@
> +/* Core kernel secure boot support.
> + *
> + * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
> + * Written by David Howells (dhowells@redhat.com)
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
> +	if (efi_enabled(EFI_BOOT)) {
> +		switch (mode) {
> +		case efi_secureboot_mode_disabled:
> +			pr_info("Secure boot disabled\n");
> +			break;
> +		case efi_secureboot_mode_enabled:
> +			pr_info("Secure boot enabled\n");
> +			break;
> +		default:
> +			pr_info("Secure boot could not be determined\n");
> +			break;
> +		}
> +	}
> +}
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 8269bcb8ccf7..e2f53edccf15 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1497,6 +1497,12 @@ enum efi_secureboot_mode {
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
