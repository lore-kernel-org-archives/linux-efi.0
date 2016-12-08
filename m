From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #5]
Date: Thu, 8 Dec 2016 07:57:35 +0100
Message-ID: <20161208065735.GB8549@wunner.de>
References: <148111668193.23390.6340512985876251017.stgit@warthog.procyon.org.uk>
 <148111671977.23390.12452925207541146423.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <148111671977.23390.12452925207541146423.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Wed, Dec 07, 2016 at 01:18:39PM +0000, David Howells wrote:
> @@ -226,7 +180,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>  	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
>  	unsigned long reserve_addr = 0;
>  	unsigned long reserve_size = 0;
> -	int secure_boot = 0;
> +	enum efi_secureboot_mode secure_boot = efi_secureboot_mode_unknown;

You're setting this variable unconditionally further down, so no need
to initialize it.


> +/*
> + * Determine whether we're in secure boot mode.  We return:
> + */

We return?  Looks like something's missing here.


> +enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
> +{
> +	u8 secboot, setupmode;
> +	unsigned long size;
> +	efi_status_t status;
> +
> +	size = sizeof(secboot);
> +	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
> +			     NULL, &size, &secboot);
> +	if (status != EFI_SUCCESS)
> +		goto out_efi_err;
> +
> +	size = sizeof(setupmode);
> +	status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
> +			     NULL, &size, &setupmode);
> +	if (status != EFI_SUCCESS)
> +		goto out_efi_err;
> +
> +	if (secboot == 0 || setupmode == 1)
> +		goto secure_boot_disabled;

Well, you could just return efi_secureboot_mode_disabled directly here
instead of doing a jump.


> +
> +	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
> +	return efi_secureboot_mode_enabled;
> +
> +secure_boot_disabled:
> +	return efi_secureboot_mode_disabled;
> +
> +out_efi_err:
> +	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
> +	if (status == EFI_NOT_FOUND)
> +		goto secure_boot_disabled;
> +	return efi_secureboot_mode_unknown;
> +}

Thanks,

Lukas
