From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [RFC][PATCH v2] efivars,efi-pstore: Hold off deletion of sysfs
 entry until the scan is completed
Date: Fri, 11 Oct 2013 18:34:16 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EF15D4@USINDEM103.corp.hds.com>
References: <5245E958.5040602@hds.com>
 <20131007114218.GA14773@console-pimps.org>
 <A5ED84D3BB3A384992CBB9C77DEDA4D443EED4D0@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443EED4D0-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Tomoki Sekiyama <tomoki.sekiyama-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt,

I submitted a v3 patch based on my comment below..

Seiji

> -----Original Message-----
> From: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Seiji Aguchi
> Sent: Wednesday, October 09, 2013 12:37 PM
> To: Matt Fleming
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org; dle-
> develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org; Tomoki Sekiyama
> Subject: RE: [RFC][PATCH v2] efivars,efi-pstore: Hold off deletion of sysfs entry until the scan is completed
> 
> Thank you for reviewing.
> In my understanding, your point is that all accesses to efivar_entry should be done while holding __efivars->lock.
> 
> > > @@ -88,8 +103,9 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
> > >  		return 0;
> > >
> > >  	entry->var.DataSize = 1024;
> > > -	__efivar_entry_get(entry, &entry->var.Attributes,
> > > -			   &entry->var.DataSize, entry->var.Data);
> > > +	efivar_entry_get(entry, &entry->var.Attributes,
> > > +			 &entry->var.DataSize, entry->var.Data);
> > > +
> > >  	size = entry->var.DataSize;
> > >
> > >  	*cb_data->buf = kmemdup(entry->var.Data, size, GFP_KERNEL);
> >
> > This isn't safe to do without holding the __efivars->lock, because
> > there's the potential for someone else to update entry->var.Data and
> > entry->var.DataSize while you're in the middle of copying the data in
> > kmemdup(). This could leak to an information leak, though I think you're
> > safe from an out-of-bounds access because DataSize is never > 1024.
> >
> 
> I see...
> Bu, kmemdup() cannot be called while holding the spinlock.
> 
> So, for protecting efivar_entry, I will call kzalloc() before holding the lock in efi_pstore_read().
> and use memcpy() in efi_pstore_read_func().
> 
> The pseudo code is as below.
> 
> 	static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
>  				       struct pstore_info *psi)
>  	{
> 		*data.buf = kzalloc(1024, GFP_KERNEL);
> 		if (!*data.buf)
> 			return -ENOMEM;
> 
> 		efivar_entry_iter_begin();
> 		size = efi_pstore_sysfs_entry_iter(&data,
> 						   (struct efivar_entry **)&psi->data);
> 		efivar_entry_iter_end();
> 		if (size <= 0)
> 			kfree(*data.buf);
> 		return size;
>  	}
> 
> 	static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
>  	{
> 	[...]
> 		entry->var.DataSize = 1024;
>  		__efivar_entry_get(entry, &entry->var.Attributes,
> 				 &entry->var.DataSize, entry->var.Data);
> 
>  		size = entry->var.DataSize;
> 		memcpy(*cb_data->buf, entry->var.Data, (size_t)min_t(unsigned long,
> 								     1024, size));
> 		return size;
> 	}
> 
> 
> > This doesn't look correct to me. You can't access 'entry' outside of the
> > *_iter_begin() and *_iter_end() blocks. You can't do,
> >
> > 	efivar_entry_iter_end():
> >
> > 	if (!entry->scanning)
> > 		efivar_unregister(entry);
> >
> > because 'entry' may have already been freed by another CPU.
> 
>  I will fix it as follows.
> 
> 	if (!entry->scanning) {
> 			efivar_entry_iter_end();
>  			efivar_unregister(entry);
> 	}  else
> 			efivar_entry_iter_end();
> 
> (efivar_unregister(entry) still runs concurrently.
> But, it cannot move inside spinlock because kzalloc() may run while freeing kobject.)
> 
> Is it your expectation?
> 
> Seiji
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
