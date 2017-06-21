From: Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [Xen-devel] [PATCH 2/2] x86/xen/efi: Init only efi struct members
 used by Xen
Date: Wed, 21 Jun 2017 09:10:51 +0100
Message-ID: <45df1a82-6d86-2b03-533b-2885e85f034a@citrix.com>
References: <1497989668-6238-1-git-send-email-daniel.kiper@oracle.com>
 <1497989668-6238-3-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497989668-6238-3-git-send-email-daniel.kiper@oracle.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org, xen-devel@lists.xenproject.org
Cc: jgross@suse.com, ard.biesheuvel@linaro.org, matt@codeblueprint.co.uk, mingo@redhat.com, hpa@zytor.com, boris.ostrovsky@oracle.com, tglx@linutronix.de
List-Id: linux-efi@vger.kernel.org

On 20/06/2017 21:14, Daniel Kiper wrote:
> Current approach, wholesale efi struct initialization from efi_xen, is not
> good. Usually if new member is defined then it is properly initialized in
> drivers/firmware/efi/efi.c but not in arch/x86/xen/efi.c. As I saw it happened
> a few times until now. So, let's initialize only efi struct members used by
> Xen to avoid such issues in the future.
>
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/x86/xen/efi.c |   45 ++++++++++++---------------------------------
>  1 file changed, 12 insertions(+), 33 deletions(-)
>
> diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
> index 30bb2e8..01b9faf 100644
> --- a/arch/x86/xen/efi.c
> +++ b/arch/x86/xen/efi.c
> @@ -54,38 +54,6 @@
>  	.tables		= EFI_INVALID_TABLE_ADDR  /* Initialized later. */
>  };
>  
> -static const struct efi efi_xen __initconst = {
> -	.systab                   = NULL, /* Initialized later. */
> -	.runtime_version	  = 0,    /* Initialized later. */
> -	.mps                      = EFI_INVALID_TABLE_ADDR,
> -	.acpi                     = EFI_INVALID_TABLE_ADDR,
> -	.acpi20                   = EFI_INVALID_TABLE_ADDR,
> -	.smbios                   = EFI_INVALID_TABLE_ADDR,
> -	.smbios3                  = EFI_INVALID_TABLE_ADDR,
> -	.sal_systab               = EFI_INVALID_TABLE_ADDR,
> -	.boot_info                = EFI_INVALID_TABLE_ADDR,
> -	.hcdp                     = EFI_INVALID_TABLE_ADDR,
> -	.uga                      = EFI_INVALID_TABLE_ADDR,
> -	.uv_systab                = EFI_INVALID_TABLE_ADDR,
> -	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
> -	.runtime                  = EFI_INVALID_TABLE_ADDR,
> -	.config_table             = EFI_INVALID_TABLE_ADDR,
> -	.get_time                 = xen_efi_get_time,
> -	.set_time                 = xen_efi_set_time,
> -	.get_wakeup_time          = xen_efi_get_wakeup_time,
> -	.set_wakeup_time          = xen_efi_set_wakeup_time,
> -	.get_variable             = xen_efi_get_variable,
> -	.get_next_variable        = xen_efi_get_next_variable,
> -	.set_variable             = xen_efi_set_variable,
> -	.query_variable_info      = xen_efi_query_variable_info,
> -	.update_capsule           = xen_efi_update_capsule,
> -	.query_capsule_caps       = xen_efi_query_capsule_caps,
> -	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
> -	.reset_system             = xen_efi_reset_system,
> -	.set_virtual_address_map  = NULL, /* Not used under Xen. */
> -	.flags			  = 0     /* Initialized later. */
> -};
> -
>  static efi_system_table_t __init *xen_efi_probe(void)
>  {
>  	struct xen_platform_op op = {
> @@ -102,7 +70,18 @@ static efi_system_table_t __init *xen_efi_probe(void)
>  
>  	/* Here we know that Xen runs on EFI platform. */
>  
> -	efi = efi_xen;
> +	efi.get_time = xen_efi_get_time;
> +	efi.set_time = xen_efi_set_time;
> +	efi.get_wakeup_time = xen_efi_get_wakeup_time;
> +	efi.set_wakeup_time = xen_efi_set_wakeup_time;
> +	efi.get_variable = xen_efi_get_variable;
> +	efi.get_next_variable = xen_efi_get_next_variable;
> +	efi.set_variable = xen_efi_set_variable;
> +	efi.query_variable_info = xen_efi_query_variable_info;
> +	efi.update_capsule = xen_efi_update_capsule;
> +	efi.query_capsule_caps = xen_efi_query_capsule_caps;
> +	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
> +	efi.reset_system = xen_efi_reset_system;

This presumably means that the system default values are already present
in efi at the point that we overwrite some Xen specifics?

If so, surely you need to retain the clobbering of set_virtual_address_map ?

~Andrew
