From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 16/16] ARM64: XEN: Initialize Xen specific UEFI
 runtime services
Date: Mon, 18 Jan 2016 11:08:54 +0000
Message-ID: <20160118110854.GG21067@leverpostej>
References: <1452840929-19612-1-git-send-email-zhaoshenglong@huawei.com>
 <1452840929-19612-17-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1452840929-19612-17-git-send-email-zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, stefano.stabellini-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, julien.grall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, peter.huangpeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, Jan 15, 2016 at 02:55:29PM +0800, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> 
> When running on Xen hypervisor, runtime services are supported through
> hypercall. So call Xen specific function to initialize runtime services.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/xen/enlighten.c |  5 +++++
>  arch/arm64/xen/Makefile  |  1 +
>  arch/arm64/xen/efi.c     | 36 ++++++++++++++++++++++++++++++++++++
>  drivers/xen/Kconfig      |  2 +-
>  include/xen/xen-ops.h    |  1 +
>  5 files changed, 44 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm64/xen/efi.c
> 
> diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> index 485e117..84f27ec 100644
> --- a/arch/arm/xen/enlighten.c
> +++ b/arch/arm/xen/enlighten.c
> @@ -414,6 +414,11 @@ static int __init xen_guest_init(void)
>  	if (xen_initial_domain())
>  		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
>  
> +	if (IS_ENABLED(CONFIG_XEN_EFI)) {
> +		if (efi_enabled(EFI_PARAVIRT))
> +			xen_efi_runtime_setup();
> +	}
> +
>  	return 0;
>  }
>  early_initcall(xen_guest_init);
> diff --git a/arch/arm64/xen/Makefile b/arch/arm64/xen/Makefile
> index 74a8d87..62e6fe2 100644
> --- a/arch/arm64/xen/Makefile
> +++ b/arch/arm64/xen/Makefile
> @@ -1,2 +1,3 @@
>  xen-arm-y	+= $(addprefix ../../arm/xen/, enlighten.o grant-table.o p2m.o mm.o)
>  obj-y		:= xen-arm.o hypercall.o
> +obj-$(CONFIG_XEN_EFI) += efi.o
> diff --git a/arch/arm64/xen/efi.c b/arch/arm64/xen/efi.c
> new file mode 100644
> index 0000000..33046b0
> --- /dev/null
> +++ b/arch/arm64/xen/efi.c
> @@ -0,0 +1,36 @@
> +/*
> + * Copyright (c) 2015, Linaro Limited, Shannon Zhao
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/efi.h>
> +#include <xen/xen-ops.h>
> +
> +void __init xen_efi_runtime_setup(void)
> +{
> +	efi.get_time                 = xen_efi_get_time;
> +	efi.set_time                 = xen_efi_set_time;
> +	efi.get_wakeup_time          = xen_efi_get_wakeup_time;
> +	efi.set_wakeup_time          = xen_efi_set_wakeup_time;
> +	efi.get_variable             = xen_efi_get_variable;
> +	efi.get_next_variable        = xen_efi_get_next_variable;
> +	efi.set_variable             = xen_efi_set_variable;
> +	efi.query_variable_info      = xen_efi_query_variable_info;
> +	efi.update_capsule           = xen_efi_update_capsule;
> +	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
> +	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
> +	efi.reset_system             = NULL;
> +}

How do capsules work in the absence of an EFI system reset?

Are there any other mandatory features that are missing in a
Xen-provided pseudo-EFI?

Mark.

> +EXPORT_SYMBOL_GPL(xen_efi_runtime_setup);
> diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> index 73708ac..27d216a 100644
> --- a/drivers/xen/Kconfig
> +++ b/drivers/xen/Kconfig
> @@ -268,7 +268,7 @@ config XEN_HAVE_PVMMU
>  
>  config XEN_EFI
>  	def_bool y
> -	depends on X86_64 && EFI
> +	depends on (ARM64 || X86_64) && EFI
>  
>  config XEN_AUTO_XLATE
>  	def_bool y
> diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
> index c83a338..36ff8e4 100644
> --- a/include/xen/xen-ops.h
> +++ b/include/xen/xen-ops.h
> @@ -107,6 +107,7 @@ efi_status_t xen_efi_update_capsule(efi_capsule_header_t **capsules,
>  efi_status_t xen_efi_query_capsule_caps(efi_capsule_header_t **capsules,
>  					unsigned long count, u64 *max_size,
>  					int *reset_type);
> +void xen_efi_runtime_setup(void);
>  
>  #ifdef CONFIG_PREEMPT
>  
> -- 
> 2.0.4
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
