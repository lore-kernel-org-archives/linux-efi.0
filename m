From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v3] efi: implement mandatory locking for UEFI Runtime
 Services
Date: Mon, 4 Aug 2014 14:00:11 +0100
Message-ID: <20140804130011.GI15082@console-pimps.org>
References: <1405062556-14540-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405062556-14540-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 11 Jul, at 09:09:16AM, Ard Biesheuvel wrote:
> According to section 7.1 of the UEFI spec, Runtime Services are not fully
> reentrant, and there are particular combinations of calls that need to be
> serialized. Use a spinlock to serialize all Runtime Services with respect
> to all others, even if this is more than strictly needed.
 
It'd be good to include a point about why we're only using a spinlock,
namely that anything else introduces complication to code that is
unlikely to be performance critical.

[...]

> + *
> + * In order to prevent deadlocks under NMI, the wrappers for these functions
> + * only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
> + */
> +#ifndef efi_in_nmi
> +#define efi_in_nmi()	(0)
> +#endif

It shouldn't be necessary to do the NMI checking for *all* runtime
services, unless you use, for instance, the timer functions on ARM64.

> +/*
>   * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
>   * the EFI specification requires that callers of the time related runtime
>   * functions serialize with other CMOS accesses in the kernel, as the EFI time
> @@ -30,10 +95,17 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>  {
>  	unsigned long flags;
>  	efi_status_t status;
> +	bool __in_nmi = efi_in_nmi();
>  
> -	spin_lock_irqsave(&rtc_lock, flags);
> +	if (!__in_nmi) {
> +		spin_lock_irqsave(&rtc_lock, flags);
> +		spin_lock(&efi_runtime_lock);
> +	}
>  	status = efi_call_virt(get_time, tm, tc);
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> +	if (!__in_nmi) {
> +		spin_unlock(&efi_runtime_lock);
> +		spin_unlock_irqrestore(&rtc_lock, flags);
> +	}
>  	return status;
>  }
>  
> @@ -42,8 +114,11 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
>  	unsigned long flags;
>  	efi_status_t status;
>  
> +	BUG_ON(efi_in_nmi());

I think we can safely drop these BUG_ON()s. I would expect things to
explode pretty spectacularly anyway, even without them if we're in NMI
context. BUG_ON()s are usually reserved for "this is a fatal condition
and we cannot make any forward progress at all, so stop".

But also see my earlier point about how most of these functions aren't
called from NMI context.

>  static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>  					       efi_char16_t *name,
>  					       efi_guid_t *vendor)
>  {
> -	return efi_call_virt(get_next_variable, name_size, name, vendor);
> +	unsigned long flags;
> +	efi_status_t status;
> +	bool __in_nmi = efi_in_nmi();
> +
> +	if (!__in_nmi)
> +		spin_lock_irqsave(&efi_runtime_lock, flags);
> +	status = efi_call_virt(get_next_variable, name_size, name, vendor);
> +	if (!__in_nmi)
> +		spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +	return status;

We shouldn't ever be in NMI context when calling get_next_variable(),
right?

> @@ -119,17 +245,33 @@ static void virt_efi_reset_system(int reset_type,
>  				  unsigned long data_size,
>  				  efi_char16_t *data)
>  {
> +	unsigned long flags;
> +	bool __in_nmi = efi_in_nmi();
> +
> +	if (!__in_nmi)
> +		spin_lock_irqsave(&efi_runtime_lock, flags);
>  	__efi_call_virt(reset_system, reset_type, status, data_size, data);
> +	if (!__in_nmi)
> +		spin_unlock_irqrestore(&efi_runtime_lock, flags);
>  }
  
Is it even possible to perform a reset through the usual machinery in
NMI context? I don't think this is possible for x86. What about for
arm64?

>  static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
>  					    unsigned long count,
>  					    unsigned long sg_list)
>  {
> +	unsigned long flags;
> +	efi_status_t status;
> +	bool __in_nmi = efi_in_nmi();
> +
>  	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>  		return EFI_UNSUPPORTED;
>  
> -	return efi_call_virt(update_capsule, capsules, count, sg_list);
> +	if (!__in_nmi)
> +		spin_lock_irqsave(&efi_runtime_lock, flags);
> +	status = efi_call_virt(update_capsule, capsules, count, sg_list);
> +	if (!__in_nmi)
> +		spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +	return status;
>  }

I don't think we need to check for being in NMI context here.

>  static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
> @@ -137,11 +279,20 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
>  						u64 *max_size,
>  						int *reset_type)
>  {
> +	unsigned long flags;
> +	efi_status_t status;
> +	bool __in_nmi = efi_in_nmi();
> +
>  	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>  		return EFI_UNSUPPORTED;
>  
> -	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
> -			     reset_type);
> +	if (!__in_nmi)
> +		spin_lock_irqsave(&efi_runtime_lock, flags);
> +	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
> +			       reset_type);
> +	if (!__in_nmi)
> +		spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +	return status;
>  }

Definitely should not be perfoming QueryCapsuleCapabilities() in NMI
context.

-- 
Matt Fleming, Intel Open Source Technology Center
