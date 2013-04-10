From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [PATCH 3/6] efivars: efivar_entry API
Date: Wed, 10 Apr 2013 15:25:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8CFEE@USINDEM103.corp.hds.com>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org>
 <1365077935-6859-4-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365077935-6859-4-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> -static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
> -			       int *count, struct timespec *timespec,
> -			       char **buf, struct pstore_info *psi)
> +struct pstore_read_data {
> +	u64 *id;
> +	enum pstore_type_id *type;
> +	int *count;
> +	struct timespec *timespec;
> +	char **buf;
> +};
> +
> +static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>  {
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> -	struct efivars *efivars = __efivars;
> +	struct pstore_read_data *cb_data = data;
>  	char name[DUMP_NAME_LEN];
>  	int i;
>  	int cnt;
> -	unsigned int part, size;
> -	unsigned long time;
> -
> -	while (&efivars->walk_entry->list != &efivars->list) {
> -		if (!efi_guidcmp(efivars->walk_entry->var.VendorGuid,
> -				 vendor)) {
> -			for (i = 0; i < DUMP_NAME_LEN; i++) {
> -				name[i] = efivars->walk_entry->var.VariableName[i];
> -			}
> -			if (sscanf(name, "dump-type%u-%u-%d-%lu",
> -				   type, &part, &cnt, &time) == 4) {
> -				*id = part;
> -				*count = cnt;
> -				timespec->tv_sec = time;
> -				timespec->tv_nsec = 0;
> -			} else if (sscanf(name, "dump-type%u-%u-%lu",
> -				   type, &part, &time) == 3) {
> -				/*
> -				 * Check if an old format,
> -				 * which doesn't support holding
> -				 * multiple logs, remains.
> -				 */
> -				*id = part;
> -				*count = 0;
> -				timespec->tv_sec = time;
> -				timespec->tv_nsec = 0;
> -			} else {
> -				efivars->walk_entry = list_entry(
> -						efivars->walk_entry->list.next,
> -						struct efivar_entry, list);
> -				continue;
> -			}
> +	unsigned int part;
> +	unsigned long time, size;
> 
> -			get_var_data_locked(efivars, &efivars->walk_entry->var);
> -			size = efivars->walk_entry->var.DataSize;
> -			*buf = kmalloc(size, GFP_KERNEL);
> -			if (*buf == NULL)
> -				return -ENOMEM;
> -			memcpy(*buf, efivars->walk_entry->var.Data,
> -			       size);
> -			efivars->walk_entry = list_entry(
> -					efivars->walk_entry->list.next,
> -					struct efivar_entry, list);
> -			return size;
> -		}
> -		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
> -						 struct efivar_entry, list);
> -	}
> -	return 0;
> +	if (efi_guidcmp(entry->var.VendorGuid, vendor))
> +		return 0;
> +
> +	for (i = 0; i < DUMP_NAME_LEN; i++)
> +		name[i] = entry->var.VariableName[i];
> +
> +	if (sscanf(name, "dump-type%u-%u-%d-%lu",
> +		   cb_data->type, &part, &cnt, &time) == 4) {
> +		*cb_data->id = part;
> +		*cb_data->count = cnt;
> +		cb_data->timespec->tv_sec = time;
> +		cb_data->timespec->tv_nsec = 0;
> +	} else if (sscanf(name, "dump-type%u-%u-%lu",
> +			  cb_data->type, &part, &time) == 3) {
> +		/*
> +		 * Check if an old format,
> +		 * which doesn't support holding
> +		 * multiple logs, remains.
> +		 */
> +		*cb_data->id = part;
> +		*cb_data->count = 0;
> +		cb_data->timespec->tv_sec = time;
> +		cb_data->timespec->tv_nsec = 0;
> +	} else
> +		return 0;
> +
> +	efivar_entry_size(entry, &size);

Deadlocking will happen in this efivar_entry_size() because __efivars->lock is already hold 
in efivar_entry_iter_begin().


> +	*cb_data->buf = kmalloc(size, GFP_KERNEL);
> +	if (*cb_data->buf == NULL)
> +		return -ENOMEM;
> +	memcpy(*cb_data->buf, entry->var.Data, size);
> +	return size;
> +}
> +
> +static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
> +			       int *count, struct timespec *timespec,
> +			       char **buf, struct pstore_info *psi)
> +{
> +	struct pstore_read_data data;
> +
> +	data.id = id;
> +	data.type = type;
> +	data.count = count;
> +	data.timespec = timespec;
> +	data.buf = buf;
> +
> +	return __efivar_entry_iter(efi_pstore_read_func, &efivar_sysfs_list, &data,
> +				   (struct efivar_entry **)&psi->data);
>  }
> 
>  static int efi_pstore_write(enum pstore_type_id type,
> @@ -1382,36 +1221,7 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	char name[DUMP_NAME_LEN];
>  	efi_char16_t efi_name[DUMP_NAME_LEN];
>  	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
> -	struct efivars *efivars = __efivars;
>  	int i, ret = 0;
> -	efi_status_t status = EFI_NOT_FOUND;
> -	unsigned long flags;
> -
> -	if (pstore_cannot_block_path(reason)) {
> -		/*
> -		 * If the lock is taken by another cpu in non-blocking path,
> -		 * this driver returns without entering firmware to avoid
> -		 * hanging up.
> -		 */
> -		if (!spin_trylock_irqsave(&efivars->lock, flags))
> -			return -EBUSY;
> -	} else
> -		spin_lock_irqsave(&efivars->lock, flags);
> -
> -	/*
> -	 * Check if there is a space enough to log.
> -	 * size: a size of logging data
> -	 * DUMP_NAME_LEN * 2: a maximum size of variable name
> -	 */
> -
> -	status = check_var_size_locked(efivars, PSTORE_EFI_ATTRIBUTES,
> -					 size + DUMP_NAME_LEN * 2);
> -
> -	if (status) {
> -		spin_unlock_irqrestore(&efivars->lock, flags);
> -		*id = part;
> -		return -ENOSPC;
> -	}
> 
>  	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
>  		get_seconds());
> @@ -1419,81 +1229,90 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>  		efi_name[i] = name[i];
> 
> -	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> -				   size, psi->buf);
> +	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
> +				    !pstore_cannot_block_path(reason),
> +				    size, psi->buf);
> 
> -	spin_unlock_irqrestore(&efivars->lock, flags);
> -
> -	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
> +	if (size && !ret && reason == KMSG_DUMP_OOPS && efivar_wq_enabled)

Why do you add (size && !ret) checking?
If the purpose of this patch is just adding new API, we don't need to modify the logic.


>  		schedule_work(&efivar_work);
> 
>  	*id = part;
>  	return ret;
>  };
