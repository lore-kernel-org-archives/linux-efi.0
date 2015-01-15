From: Dave Young <dyoung@redhat.com>
Subject: Re: [patch] efi: small leak on error
Date: Thu, 15 Jan 2015 20:22:17 +0800
Message-ID: <20150115122217.GA16485@darkstar.redhat.com>
References: <20150115092121.GA17976@mwanda>
 <20150115095455.GA15197@darkstar.redhat.com>
 <20150115102824.GB6201@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150115102824.GB6201@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 01/15/15 at 01:28pm, Dan Carpenter wrote:
> On Thu, Jan 15, 2015 at 05:54:55PM +0800, Dave Young wrote:
> > >  out_add_entry:
> > > -	for (j = i - 1; j > 0; j--) {
> > > +	for (j = i - 1; j >= 0; j--) {
> > >  		entry = *(map_entries + j);
> > >  		kobject_put(&entry->kobj);
> > >  	}
> > 
> > see below code, as for an invalid entry with i = 0, it will be not
> > assigned to *(map_entries + i) 
> 
> Yes.  Of course, if the first iteration fails then we want the free loop
> to be a noop and it is in my code as well.  j = -1.  -1 is not >= 0.
> The problem is in later iterations.
> 
> > 
> > ---
> > 	for (i = 0; i < nr_efi_runtime_map; i++) {
> > 		entry = add_sysfs_runtime_map_entry(efi_kobj, i);
> 
> Assume that this is the second iteration and "i == 1".
> 
> > 		if (IS_ERR(entry)) {
> > 			ret = PTR_ERR(entry);
> > 			goto out_add_entry;
> 
> Assume it fails so we hit this goto.  We want to free the first entry.
> 
> > 		}
> > 		*(map_entries + i) = entry;
> > 	}
> > 
> > 	return 0;
> > out_add_entry:
> > 	for (j = i - 1; j > 0; j--) {
> > 		entry = *(map_entries + j);
> 
> In your code, "j == 1 - 1" and that's not greater than zero so we don't
> enter this loop.  In my code, we go through the loop one time.
> 
> By the way this code would be a lot more clear if you used arrays.
> "map_entries[j]" is more clear than "*(map_entries + j)".  Even in the
> other patch, passing "&foo[i]" is more clear than "foo + i".

Oops, I got your point, thanks. Will ack the patches.

I used to use the pointer, but if you want arrays, feel free to send a patch.

Thanks
Dave
