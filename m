From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 5/6] efi: Disable secure boot if shim is in insecure mode
Date: Tue, 22 Nov 2016 14:03:31 +0100
Message-ID: <20161122130331.GA1657@wunner.de>
References: <20161117123731.GA11573@wunner.de>
 <147977472850.6360.6174897435078432354.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147977472850.6360.6174897435078432354.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Josh Boyer <jwboyer@fedoraproject.org>, keyrings@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 22, 2016 at 12:32:08AM +0000, David Howells wrote:
> From: Josh Boyer <jwboyer@fedoraproject.org>
> 
> A user can manually tell the shim boot loader to disable validation of
> images it loads.  When a user does this, it creates a UEFI variable called
> MokSBState that does not have the runtime attribute set.  Given that the
> user explicitly disabled validation, we can honor that and not enable
> secure boot mode if that variable is set.
> 
> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/firmware/efi/libstub/secureboot.c |   22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index e44d8c9ee150..d928398a3a52 100644
> --- a/drivers/firmware/efi/libstub/secureboot.c
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -23,10 +23,14 @@ int efi_get_secureboot(void)
>  		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
>  	static const efi_char16_t const sm_var_name[] = {
>  		'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
> +	static efi_char16_t const MokSBState_var_name[] = {
> +		'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0 };
>  
>  	static const efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
> +	static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
>  
> -	u8 val;
> +	u32 attr;
> +	u8 val, moksbstate;
>  	unsigned long size = sizeof(val);
>  	efi_status_t status;
>  
> @@ -50,6 +54,22 @@ int efi_get_secureboot(void)
>  	if (val == 1)
>  		return 0;
>  
> +	/* See if a user has put shim into insecure mode.  If so, and if the
> +	 * variable doesn't have the runtime attribute set, we might as well
> +	 * honor that.
> +	 */
> +	size = sizeof(moksbstate);
> +	status = f_getvar((efi_char16_t *)MokSBState_var_name, &shim_guid,
> +			  &attr, &size, &moksbstate);

Please use efi_call_runtime() instead of f_getvar().

> +
> +	/* If it fails, we don't care why.  Default to secure */
> +	if (status != EFI_SUCCESS)
> +		return 1;
> +
> +	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) &&
> +	    moksbstate == 1)

This would fit on a single line.

Thanks,

Lukas

> +		return 0;
> +
>  	return 1;
>  
>  out_efi_err:
> 
