From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 3/6] efivars: efivar_entry API
Date: Thu, 11 Apr 2013 14:34:51 +0100
Message-ID: <5166BBFB.5030200@console-pimps.org>
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <1365077935-6859-4-git-send-email-matt@console-pimps.org> <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8CFEE@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF8CFEE-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10/04/13 16:25, Seiji Aguchi wrote:
>> +	if (efi_guidcmp(entry->var.VendorGuid, vendor))
>> +		return 0;
>> +
>> +	for (i = 0; i < DUMP_NAME_LEN; i++)
>> +		name[i] = entry->var.VariableName[i];
>> +
>> +	if (sscanf(name, "dump-type%u-%u-%d-%lu",
>> +		   cb_data->type, &part, &cnt, &time) == 4) {
>> +		*cb_data->id = part;
>> +		*cb_data->count = cnt;
>> +		cb_data->timespec->tv_sec = time;
>> +		cb_data->timespec->tv_nsec = 0;
>> +	} else if (sscanf(name, "dump-type%u-%u-%lu",
>> +			  cb_data->type, &part, &time) == 3) {
>> +		/*
>> +		 * Check if an old format,
>> +		 * which doesn't support holding
>> +		 * multiple logs, remains.
>> +		 */
>> +		*cb_data->id = part;
>> +		*cb_data->count = 0;
>> +		cb_data->timespec->tv_sec = time;
>> +		cb_data->timespec->tv_nsec = 0;
>> +	} else
>> +		return 0;
>> +
>> +	efivar_entry_size(entry, &size);
> 
> Deadlocking will happen in this efivar_entry_size() because __efivars->lock is already hold 
> in efivar_entry_iter_begin().

Good catch, thanks.

>> @@ -1419,81 +1229,90 @@ static int efi_pstore_write(enum pstore_type_id type,
>>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>>  		efi_name[i] = name[i];
>>
>> -	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
>> -				   size, psi->buf);
>> +	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
>> +				    !pstore_cannot_block_path(reason),
>> +				    size, psi->buf);
>>
>> -	spin_unlock_irqrestore(&efivars->lock, flags);
>> -
>> -	if (reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
>> +	if (size && !ret && reason == KMSG_DUMP_OOPS && efivar_wq_enabled)
> 
> Why do you add (size && !ret) checking?
> If the purpose of this patch is just adding new API, we don't need to modify the logic.

That looks like a bug that slipped in. I'll fix it. Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
