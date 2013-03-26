From: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Tue, 26 Mar 2013 15:40:28 +0800
Message-ID: <515150EC.7040203@redhat.com>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk> <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk> <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com> <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net> <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130326035600.GA6209-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 03/26/2013 11:56 AM, Matthew Garrett wrote:
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index 7acafb8..731ac7b 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -436,9 +436,12 @@ static efi_status_t
>   check_var_size_locked(struct efivars *efivars, u32 attributes,
>   			unsigned long size)
>   {
> -	u64 storage_size, remaining_size, max_size;
> +	u64 storage_size, remaining_size, max_size, active_available;
> +	struct efivar_entry *entry;
> +	struct efi_variable *var;
>   	efi_status_t status;
>   	const struct efivar_operations *fops = efivars->ops;
> +	unsigned long active_size = 0;
>
>   	if (!efivars->ops->query_variable_info)
>   		return EFI_UNSUPPORTED;
> @@ -449,8 +452,16 @@ check_var_size_locked(struct efivars *efivars, u32 attributes,
>   	if (status != EFI_SUCCESS)
>   		return status;
>
> +	list_for_each_entry(entry, &efivars->list, list) {
> +		var = &entry->var;
> +		get_var_data_locked(efivars, var);

Check the return value here? Like for an empty efivarfs file,
it would return EFI_NOT_FOUND and active_size += 1024.

> +		active_size += var->DataSize;
> +	}
> +
> +	active_available = storage_size - active_size;
> +
>   	if (!storage_size || size > remaining_size || size > max_size ||
> -	    (remaining_size - size) < (storage_size / 2))
> +	    (active_available - size) < (storage_size / 2))
>   		return EFI_OUT_OF_RESOURCES;
>
>   	return status;
>
