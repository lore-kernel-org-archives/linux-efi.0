From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: replace GFP_KERNEL with GFP_ATOMIC
Date: Tue, 3 Nov 2015 16:36:56 +0000
Message-ID: <20151103163650.GE2653@codeblueprint.co.uk>
References: <saurabh.truth@gmail.com>
 <1446003747-3760-1-git-send-email-saurabh.truth@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446003747-3760-1-git-send-email-saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 28 Oct, at 09:12:27AM, Saurabh Sengar wrote:
> replace GFP_KERNEL with GFP_ATOMIC, as code while holding a spinlock
> should be atomic
> GFP_KERNEL may sleep and can cause deadlock, where as GFP_ATOMIC may
> fail but certainly avoids deadlock
> 
> Signed-off-by: Saurabh Sengar <saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index 70a0fb1..d4eeebf 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -322,10 +322,11 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
>   * disable the sysfs workqueue since the firmware is buggy.
>   */
>  static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
> -			     unsigned long len16)
> +			     unsigned long len16, bool atomic)
>  {
>  	size_t i, len8 = len16 / sizeof(efi_char16_t);
>  	char *str8;
> +	int gfp_mask;
>  
>  	/*
>  	 * Disable the workqueue since the algorithm it uses for
> @@ -334,7 +335,12 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
>  	 */
>  	efivar_wq_enabled = false;
>  
> -	str8 = kzalloc(len8, GFP_KERNEL);
> +	if (atomic)
> +		gfp_mask = GFP_ATOMIC;
> +	else
> +		gfp_mask = GFP_KERNEL;
> +
> +	str8 = kzalloc(len8, gfp_mask);
>  	if (!str8)
>  		return;
>  
> @@ -408,7 +414,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
>  			if (duplicates &&
>  			    variable_is_present(variable_name, &vendor_guid, head)) {
>  				dup_variable_bug(variable_name, &vendor_guid,
> -						 variable_name_size);
> +						 variable_name_size, atomic);
>  				if (!atomic)
>  					spin_lock_irq(&__efivars->lock);

It's slightly winding code, but if you look at the callers of
efivar_init() you'll see that none of them set both 'atomic' and
'duplicates', so dup_variable_bug() will never be called while holding
a spinlock.

Or am I missing something?
