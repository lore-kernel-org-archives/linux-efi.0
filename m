From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: sysfs: cannot create duplicate filename
Date: Tue, 12 Mar 2013 16:35:25 +0000
Message-ID: <1363106125.15011.263.camel@mfleming-mobl1.ger.corp.intel.com>
References: <CAHsu+b-cG+ED6TX5evRTBjR-LwHugW+8-9hnHXAz5DnAioJnUQ@mail.gmail.com>
	   <5135BD66.1030005@redhat.com>
	  <1362755479.15011.238.camel@mfleming-mobl1.ger.corp.intel.com>
	  <513A2B29.8090705@redhat.com>
	 <1363082900.15011.257.camel@mfleming-mobl1.ger.corp.intel.com>
	 <513F0734.80600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <513F0734.80600-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2013-03-12 at 18:45 +0800, Lingzhu Xiang wrote:
> (Cc'ing Seiji Aguchi for the bug related to sysfs workqueue)
> 
> On 03/12/2013 06:08 PM, Matt Fleming wrote:
> > On Sat, 2013-03-09 at 02:17 +0800, Lingzhu Xiang wrote:
> >> Comparing with the immediately previous one won't detect larger loop
> >> like how The IBM x3100 M4 in question was looping as below.
> >>
> >> (There is some log loss; probably too much data for serial.)
> >> [    9.783119] sysfs: cannot create duplicate filename '/firmware/efi/vars/MemoryTypeInformation-4c19049f-4137-4dd3-9c10-8b97a83ffdfa'
> >> [    9.852017] sysfs: cannot create duplicate filename '/firmware/efi/vars/Boot0003-8be4df61-93ca-11d2-aa0d-00e098032b8c'
> > 
> > Ah, thanks. I misunderstood the bug.
> > 
> > How about something like this? We're just going to have to suck it up
> > and iterate the entire list. This could be made more optimal, but this
> > isn't a fast path anyway, so I'm not sure it's worth optimising
> > immediately.
> > 
> > ---
> > 
> >  From c8b6c9c175f4459197e2a13f29a2e4125372d771 Mon Sep 17 00:00:00 2001
> > From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Date: Thu, 7 Mar 2013 11:59:14 +0000
> > Subject: [PATCH v2] efivars: Handle duplicate names from get_next_variable()
> > 
> > Some firmware exhibits a bug where the same VariableName and
> > VendorGuid values are returned on multiple invocations of
> > GetNextVariableName(). See,
> > 
> >      https://bugzilla.kernel.org/show_bug.cgi?id=47631
> > 
> > As a consequence of such a bug, Andre reports hitting the following
> > WARN_ON() in the sysfs code after updating the BIOS on his, "Gigabyte
> > Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F19e
> > 11/21/2012)" machine,
> > 
> > [    0.581554] EFI Variables Facility v0.08 2004-May-17
> > [    0.584914] ------------[ cut here ]------------
> > [    0.585639] WARNING: at /home/andre/linux/fs/sysfs/dir.c:536 sysfs_add_one+0xd4/0x100()
> > [    0.586381] Hardware name: To be filled by O.E.M.
> > [    0.587123] sysfs: cannot create duplicate filename '/firmware/efi/vars/SbAslBufferPtrVar-01f33c25-764d-43ea-aeea-6b5a41f3f3e8'
> > [    0.588694] Modules linked in:
> > [    0.589484] Pid: 1, comm: swapper/0 Not tainted 3.8.0+ #7
> > [    0.590280] Call Trace:
> > [    0.591066]  [<ffffffff81208954>] ? sysfs_add_one+0xd4/0x100
> > [    0.591861]  [<ffffffff810587bf>] warn_slowpath_common+0x7f/0xc0
> > [    0.592650]  [<ffffffff810588bc>] warn_slowpath_fmt+0x4c/0x50
> > [    0.593429]  [<ffffffff8134dd85>] ? strlcat+0x65/0x80
> > [    0.594203]  [<ffffffff81208954>] sysfs_add_one+0xd4/0x100
> > [    0.594979]  [<ffffffff81208b78>] create_dir+0x78/0xd0
> > [    0.595753]  [<ffffffff81208ec6>] sysfs_create_dir+0x86/0xe0
> > [    0.596532]  [<ffffffff81347e4c>] kobject_add_internal+0x9c/0x220
> > [    0.597310]  [<ffffffff81348307>] kobject_init_and_add+0x67/0x90
> > [    0.598083]  [<ffffffff81584a71>] ? efivar_create_sysfs_entry+0x61/0x1c0
> > [    0.598859]  [<ffffffff81584b2b>] efivar_create_sysfs_entry+0x11b/0x1c0
> > [    0.599631]  [<ffffffff8158517e>] register_efivars+0xde/0x420
> > [    0.600395]  [<ffffffff81d430a7>] ? edd_init+0x2f5/0x2f5
> > [    0.601150]  [<ffffffff81d4315f>] efivars_init+0xb8/0x104
> > [    0.601903]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
> > [    0.602659]  [<ffffffff81d05d80>] kernel_init_freeable+0x13e/0x1c6
> > [    0.603418]  [<ffffffff81d05586>] ? loglevel+0x31/0x31
> > [    0.604183]  [<ffffffff816a6530>] ? rest_init+0x80/0x80
> > [    0.604936]  [<ffffffff816a653e>] kernel_init+0xe/0xf0
> > [    0.605681]  [<ffffffff816ce7ec>] ret_from_fork+0x7c/0xb0
> > [    0.606414]  [<ffffffff816a6530>] ? rest_init+0x80/0x80
> > [    0.607143] ---[ end trace 1609741ab737eb29 ]---
> > 
> > There's not much we can do to work around and keep traversing the
> > variable list once we hit this firmware bug. Our only solution is to
> > terminate the loop because, as Lingzhu reports, some machines get
> > stuck when they encounter duplicate names,
> > 
> >    > I had an IBM System x3100 M4 and x3850 X5 on which kernel would
> >    > get stuck in infinite loop creating duplicate sysfs files because,
> >    > for some reason, there are several duplicate boot entries in nvram
> >    > getting GetNextVariableName into a circle of iteration (with
> >    > period > 2).
> > 
> > Reported-by: Andre Heider <a.heider-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> > 
> > v2: iterate the entire list when checking for duplicates.
> > 
> >   drivers/firmware/efivars.c | 14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> > 
> > diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> > index bea32d1..d1656e3 100644
> > --- a/drivers/firmware/efivars.c
> > +++ b/drivers/firmware/efivars.c
> > @@ -2005,6 +2005,20 @@ int register_efivars(struct efivars *efivars,
> >   						&vendor_guid);
> >   		switch (status) {
> >   		case EFI_SUCCESS:
> > +			/*
> > +			 * Some firmware implementations return the
> > +			 * same variable name on multiple calls to
> > +			 * get_next_variable(). Terminate the loop
> > +			 * immediately as there is no guarantee that
> > +			 * we'll ever see a different variable name,
> > +			 * and may end up looping here forever.
> > +			 */
> > +			if (variable_is_present(variable_name, &vendor_guid)) {
> > +				printk(KERN_WARNING "efivars: duplicate variable name.\n");
> > +				status = EFI_NOT_FOUND;
> > +				break;
> > +			}
> > +
> >   			efivar_create_sysfs_entry(efivars,
> >   						  variable_name_size,
> >   						  variable_name,
> > 
> 
> I think using what we have is good enough for this. I'll verify
> boot time tomorrow.

That would be great, thank you.

> status = EFI_NOT_FOUND here doesn't seem to do anything.

It terminates the enclosing do-while loop.

> By the way, efivar_update_sysfs_entries from Seiji's sysfs workqueue
> patch may also get stuck in loop in the same way. 

You mean if GetNextVariableName() never terminates? Yeah,
efivar_update_sysfs_entries() looks like it needs protecting from that
too, good catch.

-- 
Matt Fleming, Intel Open Source Technology Center
