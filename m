From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] efi: small leak on error
Date: Thu, 15 Jan 2015 13:28:24 +0300
Message-ID: <20150115102824.GB6201@mwanda>
References: <20150115092121.GA17976@mwanda>
 <20150115095455.GA15197@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150115095455.GA15197-4/PLUo9XfK/1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Jan 15, 2015 at 05:54:55PM +0800, Dave Young wrote:
> >  out_add_entry:
> > -	for (j = i - 1; j > 0; j--) {
> > +	for (j = i - 1; j >= 0; j--) {
> >  		entry = *(map_entries + j);
> >  		kobject_put(&entry->kobj);
> >  	}
> 
> see below code, as for an invalid entry with i = 0, it will be not
> assigned to *(map_entries + i) 

Yes.  Of course, if the first iteration fails then we want the free loop
to be a noop and it is in my code as well.  j = -1.  -1 is not >= 0.
The problem is in later iterations.

> 
> ---
> 	for (i = 0; i < nr_efi_runtime_map; i++) {
> 		entry = add_sysfs_runtime_map_entry(efi_kobj, i);

Assume that this is the second iteration and "i == 1".

> 		if (IS_ERR(entry)) {
> 			ret = PTR_ERR(entry);
> 			goto out_add_entry;

Assume it fails so we hit this goto.  We want to free the first entry.

> 		}
> 		*(map_entries + i) = entry;
> 	}
> 
> 	return 0;
> out_add_entry:
> 	for (j = i - 1; j > 0; j--) {
> 		entry = *(map_entries + j);

In your code, "j == 1 - 1" and that's not greater than zero so we don't
enter this loop.  In my code, we go through the loop one time.

By the way this code would be a lot more clear if you used arrays.
"map_entries[j]" is more clear than "*(map_entries + j)".  Even in the
other patch, passing "&foo[i]" is more clear than "foo + i".

regards,
dan carpenter
