From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Don't use spinlocks for efi vars
Date: Fri, 8 Jan 2016 11:08:33 +0000
Message-ID: <20160108110833.GC2532@codeblueprint.co.uk>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
 <20160106122421.GB2671@codeblueprint.co.uk>
 <CAD_mUW3Ws6+VrfXE-SnmSSzkqeCN0PVKeQJVXkRuJ8R_=pZ66g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAD_mUW3Ws6+VrfXE-SnmSSzkqeCN0PVKeQJVXkRuJ8R_=pZ66g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 06 Jan, at 04:22:40PM, Sylvain Chouleur wrote:
> 2016-01-06 13:24 GMT+01:00 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>:
> > > @@ -582,7 +583,8 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
> > >               return ret;
> > >
> > >       kobject_uevent(&new_var->kobj, KOBJ_ADD);
> > > -     efivar_entry_add(new_var, &efivar_sysfs_list);
> > > +     if (efivar_entry_add(new_var, &efivar_sysfs_list))
> > > +             return -EINTR;
> > >
> > >       return 0;
> > >  }
> >
> > This looks like it's missing a call to efivar_unregister() in the
> > -EINTR case.
> 
> I don't see why
> It's returning an error code as other lines in the same function.
> Can you develop your thoughts?
 
kobject_uevent() just notified userspace that a new object was
available. But because it hasn't been put onto 'efivar_sysfs_list'
when efivar_entry_add() fails, we'll never ever call kobject_put().

Before your changes efivar_entry_add() never failed and 'new_var' was
always added to the list, and always removed in efivar_sysfs_destroy().

That invariant no longer holds. Now we leak new_var->kobj.

> > > @@ -1055,12 +1087,16 @@ int efivars_register(struct efivars *efivars,
> > >                    const struct efivar_operations *ops,
> > >                    struct kobject *kobject)
> > >  {
> > > -     spin_lock_init(&efivars->lock);
> > > +     if (down_trylock(&efivars_lock))
> > > +             return -EBUSY;
> > > +
> >
> > Is this correct? I would have assumed that you'd want to return -EINTR
> > here, not -EBUSY since if an EFI variable operation is currently
> > running we should spin waiting for the semaphore to be released.
> 
> No because this is a trylock, it will not wait for the semaphore to be release,
> it will return as soon as it sees that the semaphore is locked.
> We don't want to use down_interruptible() here because we want to be able to
> (un)register efivars operation in an interrupt context.

Like I said in the other mail, I think supporting registration from
within a panic context is a bad idea. Using down_interruptible() here
would be much better. 
