From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
Date: Tue, 20 May 2014 10:47:00 +0100
Message-ID: <537B2494.2080702@citrix.com>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com> <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400272904-31121-4-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org
Cc: boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 16/05/14 21:41, Daniel Kiper wrote:
> Put EFI machinery for Xen in place.

Put what machinery to do what?

> @@ -1714,6 +1725,21 @@ asmlinkage __visible void __init xen_start_kernel(void)
>  
>  	xen_setup_runstate_info(0);
>  
> +	efi_systab_xen = xen_efi_probe();
> +
> +	if (efi_systab_xen) {
> +		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
> +				sizeof(boot_params.efi_info.efi_loader_signature));
> +		boot_params.efi_info.efi_systab = (__u32)((__u64)efi_systab_xen);
> +		boot_params.efi_info.efi_systab_hi = (__u32)((__u64)efi_systab_xen >> 32);
> +
> +		x86_platform.get_wallclock = efi_get_time;

x86_platform.get_wallclock should always be xen_get_wallclock().

> +		x86_platform.set_wallclock = efi_set_rtc_mmss;
> +
> +		set_bit(EFI_BOOT, &efi.flags);
> +		set_bit(EFI_64BIT, &efi.flags);
> +	}
> +
>  	/* Start the world */
>  #ifdef CONFIG_X86_32
>  	i386_start_kernel();
> --- /dev/null
> +++ b/drivers/xen/efi.c
> @@ -0,0 +1,374 @@
> + * Copyright (c) 2014 Daniel Kiper, Oracle Corporation

Is this really copyright by you personally and not Oracle?


> +#define call (op.u.efi_runtime_call)
> +#define DECLARE_CALL(what) \
> +	struct xen_platform_op op; \
> +	op.cmd = XENPF_efi_runtime_call; \
> +	call.function = XEN_EFI_##what; \
> +	call.misc = 0

Macros that declare local variables are awful.

Use what Andrew suggested and something like

struct xen_blah *call = &op.u.efi_runtime_call;


> +static const struct efi efi_xen __initconst = {
> +	.systab                   = NULL, /* Initialized later. */
> +	.runtime_version	  = 0,    /* Initialized later. */
> +	.mps                      = EFI_INVALID_TABLE_ADDR,
> +	.acpi                     = EFI_INVALID_TABLE_ADDR,
> +	.acpi20                   = EFI_INVALID_TABLE_ADDR,
> +	.smbios                   = EFI_INVALID_TABLE_ADDR,
> +	.sal_systab               = EFI_INVALID_TABLE_ADDR,
> +	.boot_info                = EFI_INVALID_TABLE_ADDR,
> +	.hcdp                     = EFI_INVALID_TABLE_ADDR,
> +	.uga                      = EFI_INVALID_TABLE_ADDR,
> +	.uv_systab                = EFI_INVALID_TABLE_ADDR,
> +	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
> +	.runtime                  = EFI_INVALID_TABLE_ADDR,
> +	.config_table             = EFI_INVALID_TABLE_ADDR,
> +	.get_time                 = xen_efi_get_time,
> +	.set_time                 = xen_efi_set_time,
> +	.get_wakeup_time          = xen_efi_get_wakeup_time,
> +	.set_wakeup_time          = xen_efi_set_wakeup_time,
> +	.get_variable             = xen_efi_get_variable,
> +	.get_next_variable        = xen_efi_get_next_variable,
> +	.set_variable             = xen_efi_set_variable,
> +	.query_variable_info      = xen_efi_query_variable_info,
> +	.update_capsule           = xen_efi_update_capsule,
> +	.query_capsule_caps       = xen_efi_query_capsule_caps,
> +	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
> +	.reset_system             = NULL, /* Functionality provided by Xen. */

Xen provides functionality to reset (just maybe not via an EFI call).
Should an implementation be provided that does this?

> +	.set_virtual_address_map  = NULL, /* Not used under Xen. */
> +	.memmap                   = NULL, /* Not used under Xen. */
> +	.flags			  = 0     /* Initialized later. */
> +};
> +
> +efi_system_table_t __init *xen_efi_probe(void)
> +{
> +	struct xen_platform_op op = {
> +		.cmd = XENPF_firmware_info,
> +		.u.firmware_info = {
> +			.type = XEN_FW_EFI_INFO,
> +			.index = XEN_FW_EFI_CONFIG_TABLE
> +		}
> +	};
> +	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
> +
> +	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op))
> +		return NULL;

	if (!xen_initial_domain())
		return NULL;

	if (HYPERVISOR_dom0_op(&op) < 0)
		return NULL;

> +
> +	/* Here we know that Xen runs on EFI platform. */
> +
> +	efi = efi_xen;
> +
> +	op.cmd = XENPF_firmware_info;
> +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
> +	info->vendor.bufsz = sizeof(vendor);
> +	set_xen_guest_handle(info->vendor.name, vendor);
> +
> +	if (!HYPERVISOR_dom0_op(&op)) {

if (HYPERVISOR_dom0_op(&op) == 0)

David
