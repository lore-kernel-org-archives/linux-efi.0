From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/2] x86/xen/efi: Init only efi struct members used by Xen
Date: Wed, 21 Jun 2017 11:24:06 +0200
Message-ID: <20170621092406.ak2cord743ded3hf@gmail.com>
References: <1497989668-6238-1-git-send-email-daniel.kiper@oracle.com>
 <1497989668-6238-3-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1497989668-6238-3-git-send-email-daniel.kiper@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, stable@vger.kernel.org, xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com, jgross@suse.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org
List-Id: linux-efi@vger.kernel.org


* Daniel Kiper <daniel.kiper@oracle.com> wrote:

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

This is a step back stylistically, as you lost the nice vertical tabulation of the 
original initializer ...

Thanks,

	Ingo
