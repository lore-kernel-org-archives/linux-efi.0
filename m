From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 05/16] x86/efi: Get entropy through EFI random
 number generator protocol
Date: Thu, 30 Jul 2015 17:11:44 +0100
Message-ID: <1438272704.11322.13.camel@intel.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
	 <1437056730-15247-6-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437056730-15247-6-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2015-07-16 at 22:25 +0800, Lee, Chun-Yi wrote:
> To grab random numbers through EFI protocol as one of the entropies
> source of swsusp key, this patch adds the logic for accessing EFI RNG
> (random number generator) protocol that's introduced since UEFI 2.4.
> 
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  arch/x86/boot/compressed/efi_random.c | 193 ++++++++++++++++++++++++++++++++++
>  include/linux/efi.h                   |  46 ++++++++
>  2 files changed, 239 insertions(+)

[...]

> @@ -2,6 +2,191 @@
>  
>  #include <linux/efi.h>
>  #include <asm/archrandom.h>
> +#include <asm/efi.h>
> +
> +static efi_status_t efi_locate_rng(efi_system_table_t *sys_table,
> +				   void ***rng_handle)
> +{
> +	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
> +	unsigned long size = 0;
> +	efi_status_t status;
> +
> +	status = efi_call_early(locate_handle,
> +				EFI_LOCATE_BY_PROTOCOL,
> +				&rng_proto, NULL, &size, *rng_handle);
> +
> +	if (status == EFI_BUFFER_TOO_SMALL) {
> +		status = efi_call_early(allocate_pool,
> +					EFI_LOADER_DATA,
> +					size, (void **)rng_handle);
> +
> +		if (status != EFI_SUCCESS) {
> +			efi_printk(sys_table, " Failed to alloc mem for rng_handle");
> +			return status;
> +		}
> +
> +		status = efi_call_early(locate_handle,
> +					EFI_LOCATE_BY_PROTOCOL, &rng_proto,
> +					NULL, &size, *rng_handle);
> +	}
> +
> +	if (status != EFI_SUCCESS) {
> +		efi_printk(sys_table, " Failed to locate EFI_RNG_PROTOCOL");
> +		goto free_handle;
> +	}
> +
> +	return EFI_SUCCESS;
> +
> +free_handle:
> +	efi_call_early(free_pool, *rng_handle);
> +
> +	return status;
> +}

I would suggest setting *rng_handle = NULL at the beginning of this
function just because if we ever forget to set it that way in the caller
this free_pool call might do screwy things.


> +static bool efi_rng_supported(efi_system_table_t *sys_table)
> +{
> +	const struct efi_config *efi_early = __efi_early();
> +	u32 random = 0;
> +	efi_status_t status;
> +	void **rng_handle = NULL;
> +
> +	status = efi_locate_rng(sys_table, &rng_handle);
> +	if (status != EFI_SUCCESS)
> +		return false;
> +
> +	if (efi_early->is64)
> +		random = efi_rng_supported64(sys_table, rng_handle);
> +	else
> +		random = efi_rng_supported32(sys_table, rng_handle);
> +
> +	efi_call_early(free_pool, rng_handle);
> +
> +	return random;

Oops, 'random' isn't a bool but it should be.

> @@ -51,6 +236,14 @@ static unsigned long get_random_long(unsigned long entropy,
>  		use_i8254 = false;
>  	}
>  
> +	if (efi_rng_supported(sys_table)) {
> +		efi_printk(sys_table, " EFI_RNG");
> +		raw = efi_get_rng(sys_table);
> +		if (raw)
> +			random ^= raw;
> +		use_i8254 = false;
> +	}
> +
>  	if (use_i8254) {
>  		efi_printk(sys_table, " i8254");
>  		random ^= i8254();

Have you looked at the tradeoff in terms of boot time for building a key
array in 'unsigned long' chunks as opposed to passing the array and size
directly for the RNG protocol?
