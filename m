From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [RFC][PATCH 3/7] efivars: New efivar_entry API
Date: Fri, 8 Feb 2013 22:13:04 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A88489@USINDEM103.corp.hds.com>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
 <1360357158-8168-4-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357158-8168-4-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

 Matt,

> There isn't really a formalised interface for dealing with EFI
> variables or struct efivar_entry. This has led to the efivarfs code
> directly accessing '__efivars'.

I agree with you.

I have some comment on a pstore part.

> @@ -1363,86 +1195,90 @@ static int efi_pstore_write(enum pstore_type_id type,
>  	for (i = 0; i < DUMP_NAME_LEN; i++)
>  		efi_name[i] = name[i];
> 
> -	efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> -				   size, psi->buf);
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;

Please don't allocate memory dynamically in the efi_pstore_write() because efi_pstore_write() is 
called in an interrupt context like oops and panic.

Also, a whole process of query_info() + entry_set() should be protected by a single spin lock()
Because if efi_pstore_write() runs concurrently, a result of query_info() may be meaningless...

So, how about introducing query_info_nolock and entry_set_nolock()?

spin_lock()
query_info_nolock()
entry_set_nolock()
spin_unlock()

IMO, efivarfs_file_write() should be fixed as above.

As for efi_pstore_erase() and efi_pstore_read(), it will take some time to fully understand your change.

Seiji
