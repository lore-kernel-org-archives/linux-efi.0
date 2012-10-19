From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: RE: [RFC][PATCH 1/2] efi_pstore: hold multiple logs
Date: Fri, 19 Oct 2012 14:26:33 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138796E1@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41386D119@USINDEM103.corp.hds.com>
 <CAGTjWtDgrDGN-+yCqfFsfaA8Xjbhj8nherA+puoGVRs-8vXO5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGTjWtDgrDGN-+yCqfFsfaA8Xjbhj8nherA+puoGVRs-8vXO5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Mike,

Thank you for reviewing my patch.
Here is my comment.

> >   - Write callback
> >     - Check if there are enough spaces to write logs with QueryVariableInfo()
> >       to avoid handling out of space situation. (It is suggested by
> > Matthew Garrett.)
> >
> 
> I would prefer to see the exposing query_variable_info callback as a separate patch.  The check in the patch looks good.
>

OK. I will make a separate patch.

 
> >     - Remove a logic erasing existing entries.
> >
> >   - Erase callback
> >     - Freshly create a logic rather than sharing it with a write callback because
> >       erasing entries doesn't need in a write callback.
> >
> 
> This sort of change is a lot easier to review if you copy and paste the routine in a patch separate from this one.
> 

I will separate it as well.


> > +       /*
> > +        * Check if there is a space enough to log.
> > +        * size: a size of logging data
> > +        * DUMP_NAME_LEN * 2: a maximum size of variable name
> > +        *
> 
> extra line
> 

Will fix.

> > +
> > +       efivars->ops->set_variable(efi_name, &vendor, PSTORE_EFI_ATTRIBUTES,
> > +                                  size, psi->buf);
> > +
> > +       spin_unlock(&efivars->lock);
> > +
> > +       if (size)
> > +               ret = efivar_create_sysfs_entry(efivars,
> > +                                         utf16_strsize(efi_name,
> > +                                                       DUMP_NAME_LEN * 2),
> > +                                         efi_name, &vendor);
> 
> What is happening here?  Why is size checked for non-zero?
> 

I just copied an original code sharing a logic of write callback and erase callback.. 
But, if size is zero, we don't need to create a sysfs file because a set_variable service erases the entry.
It is defined in EFI specification.
So, I think this code is right.

> > +++ b/fs/pstore/inode.c
> > @@ -175,7 +175,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
> >         struct pstore_private *p = dentry->d_inode->i_private;
> >
> >         if (p->psi->erase)
> > -               p->psi->erase(p->type, p->id, p->psi);
> > +               p->psi->erase(p->type, p->id, dentry->d_inode->i_ctime,
> > +                             p->psi);
> 
> This doesn't look right.  What guarantees that the i_ctime means anything across reboots?
> 

Ctime is persistent across reboots because ctime of pstore means the date that the recode was
originally stored. (See below.)

To do this, efi_pstore saves the ctime to variable name at writing time and passes it to pstore at reading time.

fs/pstore/inode.c:
<snip>
/*
  * Make a regular file in the root directory of our file system.
  * Load it up with "size" bytes of data from "buf".
  * Set the mtime & ctime to the date that this record was originally stored.
  */
int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
                   char *data, size_t size, struct timespec time,
                   struct pstore_info *psi) {
         struct dentry           *root = pstore_sb->s_root;
         struct dentry           *dentry;
         struct inode            *inode;
         int                     rc = 0;
         char                    name[PSTORE_NAMELEN];
<snip>

Seiji
--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
