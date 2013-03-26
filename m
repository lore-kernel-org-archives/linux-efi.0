From: Lingzhu Xiang <lxiang@redhat.com>
Subject: Re: efi: be more paranoid about available space when creating variables
Date: Tue, 26 Mar 2013 12:31:11 +0800
Message-ID: <5151248F.2010303@redhat.com>
References: <1364004995.3728.76.camel@deadeye.wl.decadent.org.uk> <1364010441.3728.82.camel@deadeye.wl.decadent.org.uk> <CAL01qpvaP7_YWS+vhjTskvisCyjxg-28WBAjSQftrSmnCphwdw@mail.gmail.com> <1364070731.2553.47.camel@x230.sbx07502.somerma.wayport.net> <514E31B0.4030305@intel.com> <20130326035600.GA6209@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130326035600.GA6209@srcf.ucam.org>
Sender: stable-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt.fleming@intel.com>, Ben Hutchings <ben@decadent.org.uk>, Josh Boyer <jwboyer@redhat.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Seth Forshee <seth.forshee@canonical.com>
List-Id: linux-efi@vger.kernel.org

On 03/26/2013 11:56 AM, Matthew Garrett wrote:
> Ok, so having thought some more about the actual problem (ie, Samsungs
> go wrong if there's too much used space marked as being active, not
> merely too much used space) I think we really want to be looking for the
> amount of active space rather than the remaining space value that
> QueryVariableInfo() gives us. Something like this (absolutely untested,
> provided here for comment) patch? I'll try rigging something up under
> OVMF to test it. This version certainly seems a little over-naive, since
> it won't handle the case of a variable that's being overwritten with
> something of a different size.
>
> commit 263c2ee36c67dfa6d869304a3b5aef7a14f1ec4e
> Author: Matthew Garrett <matthew.garrett@nebula.com>
> Date:   Mon Mar 25 13:40:28 2013 -0400
>
>      efi: Distinguish between "remaining space" and actually used space
>
>      EFI implementations distinguish between space that is actively used by a
>      variable and space that merely hasn't been garbage collected yet. Space
>      that hasn't yet been garbage collected isn't available for use and so isn't
>      counted in the remaining_space field returned by QueryVariableInfo().
>
>      Combined with commit 68d9298 this can cause problems. Some implementations
>      don't garbage collect until the remaining space is smaller than the maximum
>      variable size, and as a result check_var_size() will always fail once more
>      than 50% of the variable store has been used even if most of that space is
>      marked as available for garbage collection. The user is unable to create
>      new variables, and deleting variables doesn't increase the remaining space.

Do you mean they don't garbage collect across reboots?

>      The problem that 68d9298 was attempting to avoid was one where certain
>      platforms fail if the actively used space is greater than 50% of the
>      available storage space. We should be able to calculate that by simply
>      summing the size of each available variable and subtracting that from
>      the total storage space. With luck this will fix the problem described in

What about the size of variable name, paddings, headers (especially 
authenticated ones) and other internal stuff?

>      https://bugzilla.kernel.org/show_bug.cgi?id=55471 without permitting
>      damage to occur to the machines 68d9298 was attempting to fix.

This bug is reporting "query_variable_info sets max_size as zero". If 
that's true, this patch doesn't seem to account for that case.

>
>      Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
>
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
