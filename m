From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 02/16] efi: Get the secure boot status
Date: Thu, 17 Nov 2016 13:37:31 +0100
Message-ID: <20161117123731.GA11573@wunner.de>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
 <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147933285147.19316.11046583275861569558.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, Nov 16, 2016 at 09:47:31PM +0000, David Howells wrote:
> Get the firmware's secure-boot status in the kernel boot wrapper and stash
> it somewhere that the main kernel image can find.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/x86/zero-page.txt       |    2 ++
>  arch/x86/boot/compressed/eboot.c      |   35 +++++++++++++++++++++++++++++++++
>  arch/x86/include/uapi/asm/bootparam.h |    3 ++-
>  3 files changed, 39 insertions(+), 1 deletion(-)
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
> index cc69e37548db..17b376596c96 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -12,6 +12,7 @@
>  #include <asm/efi.h>
>  #include <asm/setup.h>
>  #include <asm/desc.h>
> +#include <asm/bootparam_utils.h>
>  
>  #include "../string.h"
>  #include "eboot.h"
> @@ -537,6 +538,36 @@ static void setup_efi_pci(struct boot_params *params)
>  	efi_call_early(free_pool, pci_handle);
>  }
>  
> +static int get_secure_boot(void)
> +{

This function is very similar to the existing efi_get_secureboot() in
drivers/firmware/efi/libstub/arm-stub.c.

Please avoid adding more duplicate code to the EFI stub and try to
reuse the existing code.

I suggest moving the existing efi_get_secureboot() to a new file
drivers/firmware/efi/libstub/secureboot.c which gets linked into
libstub, perhaps dependent on a new config option.


> +	u8 sb, setup;
> +	unsigned long datasize = sizeof(sb);
> +	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
> +	efi_status_t status;
> +
> +	status = efi_early->call((unsigned long)sys_table->runtime->get_variable,
> +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);

This doesn't work in mixed mode.

We already have the efi_call_early() macro to call boot services
in a manner that works across all arches and bitness variants.

In 4.10 there will be an efi_call_proto() macro to allow the same
for protocol calls:
http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=efi/core&id=3552fdf29f01

I suggest adding an efi_call_runtime() macro for arch- and bitness-
agnostic runtime services calls, like this:

#define efi_call_runtime(f, ...)					\
	__efi_early()->call(efi_table_attr(efi_runtime_services, f,	\
		__efi_early()->runtime_services), __VA_ARGS__)

For this to work you need to add a runtime_services attribute to struct
efi_config, this requires modifying head_32.S and head_64.S, use commit
0a637ee61247 ("x86/efi: Allow invocation of arbitrary boot services")
as a template.

If you define corresponding efi_call_runtime() macros for ARM, you
should indeed be able to share this function across arches.

Thanks,

Lukas


> +
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (sb == 0)
> +		return 0;
> +
> +
> +	status = efi_early->call((unsigned long)sys_table->runtime->get_variable,
> +				L"SetupMode", &var_guid, NULL, &datasize,
> +				&setup);
> +
> +	if (status != EFI_SUCCESS)
> +		return 0;
> +
> +	if (setup == 1)
> +		return 0;
> +
> +	return 1;
> +}
> +
>  static efi_status_t
>  setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>  {
> @@ -1094,6 +1125,10 @@ struct boot_params *efi_main(struct efi_config *c,
>  	else
>  		setup_boot_services32(efi_early);
>  
> +	sanitize_boot_params(boot_params);
> +
> +	boot_params->secure_boot = get_secure_boot();
> +
>  	setup_graphics(boot_params);
>  
>  	setup_efi_pci(boot_params);
> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> index c18ce67495fa..2b3e5427097b 100644
> --- a/arch/x86/include/uapi/asm/bootparam.h
> +++ b/arch/x86/include/uapi/asm/bootparam.h
> @@ -134,7 +134,8 @@ struct boot_params {
>  	__u8  eddbuf_entries;				/* 0x1e9 */
>  	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
>  	__u8  kbd_status;				/* 0x1eb */
> -	__u8  _pad5[3];					/* 0x1ec */
> +	__u8  secure_boot;				/* 0x1ec */
> +	__u8  _pad5[2];					/* 0x1ed */
>  	/*
>  	 * The sentinel is set to a nonzero value (0xff) in header.S.
>  	 *
> 
