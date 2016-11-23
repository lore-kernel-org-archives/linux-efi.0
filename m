From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 4/6] efi: Get the secure boot status [ver #2]
Date: Wed, 23 Nov 2016 10:31:23 +0100
Message-ID: <20161123093122.GB2071@wunner.de>
References: <147986054870.13790.8640536414645705863.stgit@warthog.procyon.org.uk>
 <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147986057768.13790.3027173260868896792.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 23, 2016 at 12:22:57AM +0000, David Howells wrote:
> Get the firmware's secure-boot status in the kernel boot wrapper and stash
> it somewhere that the main kernel image can find.
> 
> The efi_get_secureboot() function is extracted from the arm stub and (a)
> generalised so that it can be called from x86 and (b) made to use
> efi_call_runtime() so that it can be run in mixed-mode.
> 
> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/x86/zero-page.txt           |    2 +
>  arch/x86/boot/compressed/eboot.c          |    2 +
>  arch/x86/include/uapi/asm/bootparam.h     |    3 +
>  drivers/firmware/efi/libstub/Makefile     |    2 -
>  drivers/firmware/efi/libstub/arm-stub.c   |   46 -------------------
>  drivers/firmware/efi/libstub/secureboot.c |   71 +++++++++++++++++++++++++++++
>  include/linux/efi.h                       |    2 +
>  7 files changed, 80 insertions(+), 48 deletions(-)
>  create mode 100644 drivers/firmware/efi/libstub/secureboot.c
> 
> diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
> index 95a4d34af3fd..b8527c6b7646 100644
> --- a/Documentation/x86/zero-page.txt
> +++ b/Documentation/x86/zero-page.txt
> @@ -31,6 +31,8 @@ Offset	Proto	Name		Meaning
>  1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
>  1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
>  				(below)
> +1EB/001	ALL     kbd_status      Numlock is enabled
> +1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
>  1EF/001	ALL	sentinel	Used to detect broken bootloaders
>  290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
>  2D0/A00	ALL	e820_map	E820 memory map table
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index c8c32ebcdfdb..6023b0e6f2af 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -1158,6 +1158,8 @@ struct boot_params *efi_main(struct efi_config *c,
>  	else
>  		setup_boot_services32(efi_early);
>  
> +	boot_params->secure_boot = (efi_get_secureboot(sys_table) == 1);
> +

It just occurred to me that the boot_params struct is populated in
make_boot_params(), perhaps it makes sense to move this line there.
Otherwise LGTM.

Thanks,

Lukas

>  	setup_graphics(boot_params);
>  
>  	setup_efi_pci(boot_params);
> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> index b10bf319ed20..5138dacf8bb8 100644
> --- a/arch/x86/include/uapi/asm/bootparam.h
> +++ b/arch/x86/include/uapi/asm/bootparam.h
> @@ -135,7 +135,8 @@ struct boot_params {
>  	__u8  eddbuf_entries;				/* 0x1e9 */
>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
>  	__u8  kbd_status;				/* 0x1eb */
> -	__u8  _pad5[3];					/* 0x1ec */
> +	__u8  secure_boot;				/* 0x1ec */
> +	__u8  _pad5[2];					/* 0x1ed */
>  	/*
>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
>  	 *
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 6621b13c370f..9af966863612 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -28,7 +28,7 @@ OBJECT_FILES_NON_STANDARD	:= y
>  # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
>  KCOV_INSTRUMENT			:= n
>  
> -lib-y				:= efi-stub-helper.o gop.o
> +lib-y				:= efi-stub-helper.o gop.o secureboot.o
>  
>  # include the stub's generic dependencies from lib/ when building for ARM/arm64
>  arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index b4f7d78f9e8b..552ee61ddbed 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -20,52 +20,6 @@
>  
>  bool __nokaslr;
>  
> -static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
> -{
> -	static efi_char16_t const sb_var_name[] = {
> -		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
> -	static efi_char16_t const sm_var_name[] = {
> -		'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
> -
> -	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
> -	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
> -	u8 val;
> -	unsigned long size = sizeof(val);
> -	efi_status_t status;
> -
> -	status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
> -			  NULL, &size, &val);
> -
> -	if (status != EFI_SUCCESS)
> -		goto out_efi_err;
> -
> -	if (val == 0)
> -		return 0;
> -
> -	status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
> -			  NULL, &size, &val);
> -
> -	if (status != EFI_SUCCESS)
> -		goto out_efi_err;
> -
> -	if (val == 1)
> -		return 0;
> -
> -	return 1;
> -
> -out_efi_err:
> -	switch (status) {
> -	case EFI_NOT_FOUND:
> -		return 0;
> -	case EFI_DEVICE_ERROR:
> -		return -EIO;
> -	case EFI_SECURITY_VIOLATION:
> -		return -EACCES;
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
>  efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
>  			     void *__image, void **__fh)
>  {
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> new file mode 100644
> index 000000000000..466fe24f5866
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -0,0 +1,71 @@
> +/*
> + * Secure boot handling.
> + *
> + * Copyright (C) 2013,2014 Linaro Limited
> + *     Roy Franz <roy.franz@linaro.org
> + * Copyright (C) 2013 Red Hat, Inc.
> + *     Mark Salter <msalter@redhat.com>
> + *
> + * This file is part of the Linux kernel, and is made available under the
> + * terms of the GNU General Public License version 2.
> + *
> + */
> +
> +#include <linux/efi.h>
> +#include <asm/efi.h>
> +
> +/* BIOS variables */
> +static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
> +static const efi_char16_t const efi_SecureBoot_name[] = {
> +	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
> +};
> +static const efi_char16_t const efi_SetupMode_name[] = {
> +	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
> +};
> +
> +#define get_efi_var(name, vendor, ...) \
> +	efi_call_runtime(get_variable, \
> +			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
> +			 __VA_ARGS__);
> +
> +/*
> + * Determine whether we're in secure boot mode.
> + */
> +int efi_get_secureboot(efi_system_table_t *sys_table_arg)
> +{
> +	u8 val;
> +	unsigned long size = sizeof(val);
> +	efi_status_t status;
> +
> +	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
> +			     NULL, &size, &val);
> +
> +	if (status != EFI_SUCCESS)
> +		goto out_efi_err;
> +
> +	if (val == 0)
> +		return 0;
> +
> +	status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
> +			     NULL, &size, &val);
> +
> +	if (status != EFI_SUCCESS)
> +		goto out_efi_err;
> +
> +	if (val == 1)
> +		return 0;
> +
> +	return 1;
> +
> +out_efi_err:
> +	switch (status) {
> +	case EFI_NOT_FOUND:
> +		return 0;
> +	case EFI_DEVICE_ERROR:
> +		return -EIO;
> +	case EFI_SECURITY_VIOLATION:
> +		return -EACCES;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 24db4e5ec817..ff01ad6f2823 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1477,6 +1477,8 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>  bool efi_runtime_disabled(void);
>  extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
>  
> +int efi_get_secureboot(efi_system_table_t *sys_table_arg);
> +
>  /*
>   * Arch code can implement the following three template macros, avoiding
>   * reptition for the void/non-void return cases of {__,}efi_call_virt():
> 
