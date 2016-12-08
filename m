From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #5]
Date: Thu, 8 Dec 2016 13:42:36 +0100
Message-ID: <20161208124236.GA8757@wunner.de>
References: <20161208065735.GB8549@wunner.de>
 <148111668193.23390.6340512985876251017.stgit@warthog.procyon.org.uk>
 <148111671977.23390.12452925207541146423.stgit@warthog.procyon.org.uk>
 <6009.1481184981@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6009.1481184981@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 08, 2016 at 08:16:21AM +0000, David Howells wrote:
> +/*
> + * Determine whether we're in secure boot mode.
> + */
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
> +		return efi_secureboot_mode_disabled;
> +
> +	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
> +	return efi_secureboot_mode_enabled;
> +
> +out_efi_err:
> +	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
> +	if (status == EFI_NOT_FOUND)
> +		return efi_secureboot_mode_disabled;
> +	return efi_secureboot_mode_unknown;
> +}

In the out_efi_err path, the if-statement needs to come before the
pr_efi_err() call.  Otherwise it would be a change of behaviour for
ARM to what we have now.

Also, minor nit, I'd expect Matt to ask for a newline between the
if-statement and the following statements, so:

out_efi_err:
	if (status == EFI_NOT_FOUND)
		return efi_secureboot_mode_disabled;

	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
	return efi_secureboot_mode_unknown;

The error message doesn't say what the consequence is of the
failure to determine the status, but IIUC this differs between
x86 and ARM, is that correct?  (If I remember the discussion
correctly, x86 defaults to disabled, ARM to enabled.)

Thanks,

Lukas
