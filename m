From: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: Don't use spinlocks for efi vars
Date: Wed, 6 Jan 2016 16:22:40 +0100
Message-ID: <CAD_mUW3Ws6+VrfXE-SnmSSzkqeCN0PVKeQJVXkRuJ8R_=pZ66g@mail.gmail.com>
References: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com> <20160106122421.GB2671@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106122421.GB2671-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

2016-01-06 13:24 GMT+01:00 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>:
>
> (Cc'ing Ard since he has recently been in this area)
>
> On Fri, 18 Dec, at 11:29:50AM, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> > From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > All efivars operations are protected by a spinlock which prevents
> > interruptions and preemption. This is too restricted, we just need a
> > lock preventing concurency.
> > The idea is to use a semaphore of count 1 and to have two ways of
> > locking, depending on the context:
> >  - In interrupt context, we call down_trylock(), if it fails we return
> >  an error
> >  - In normal context, we call down_interruptible()
> >
> > We don't use a mutex here because the mutex_trylock() function must not
> > be called from interrupt context, whereas the down_trylock() can.
> >
> > This patch also remove the efivars lock to use a single lock for the
> > whole vars.c file. The goal of this lock is to protect concurrent calls
> > to efi variable services, registering and unregistering.
> > This allows to register new efivars operations without having
> > in-progress call.
> >
> > Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > ---
> >  drivers/firmware/efi/efi-pstore.c |  34 +++++++---
> >  drivers/firmware/efi/efivars.c    |  10 ++-
> >  drivers/firmware/efi/vars.c       | 130 +++++++++++++++++++++++++-------------
> >  fs/efivarfs/inode.c               |   5 +-
> >  fs/efivarfs/super.c               |   8 ++-
> >  include/linux/efi.h               |  12 +---
> >  6 files changed, 130 insertions(+), 69 deletions(-)
>
> This needs splitting into more than 1 patch.
>
> You need separate patches to,
>
>   - Split out __efivars->lock into a file local lock
>   - Convert the lock to a semaphore
>   - Print a message when efi_operations are registered
>
> Further comments below.
>
> > diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
> > index 756eca8c4cf8..3998373d92ef 100644
> > --- a/drivers/firmware/efi/efivars.c
> > +++ b/drivers/firmware/efi/efivars.c
> > @@ -509,7 +509,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
> >               vendor = del_var->VendorGuid;
> >       }
> >
> > -     efivar_entry_iter_begin();
> > +     if (efivar_entry_iter_begin())
> > +             return -EINTR;
> >       entry = efivar_entry_find(name, vendor, &efivar_sysfs_list, true);
> >       if (!entry)
> >               err = -EINVAL;
> > @@ -582,7 +583,8 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
> >               return ret;
> >
> >       kobject_uevent(&new_var->kobj, KOBJ_ADD);
> > -     efivar_entry_add(new_var, &efivar_sysfs_list);
> > +     if (efivar_entry_add(new_var, &efivar_sysfs_list))
> > +             return -EINTR;
> >
> >       return 0;
> >  }
>
> This looks like it's missing a call to efivar_unregister() in the
> -EINTR case.

I don't see why
It's returning an error code as other lines in the same function.
Can you develop your thoughts?

>
> > @@ -697,7 +699,9 @@ static int efivars_sysfs_callback(efi_char16_t *name, efi_guid_t vendor,
> >
> >  static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
> >  {
> > -     efivar_entry_remove(entry);
> > +     int err = efivar_entry_remove(entry);
> > +     if (err)
> > +             return err;
> >       efivar_unregister(entry);
> >       return 0;
> >  }
>
> You now need to return early from efivars_sysfs_exit() if you hit the
> error path in efivar_sysfs_destroy().
>
> > diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> > index 70a0fb10517f..8a44351211e5 100644
> > --- a/drivers/firmware/efi/vars.c
> > +++ b/drivers/firmware/efi/vars.c
> > @@ -37,6 +37,13 @@
> >  /* Private pointer to registered efivars */
> >  static struct efivars *__efivars;
> >
> > +/*
> > + * ->lock protects two things:
> > + * 1) efivarfs_list and efivars_sysfs_list
> > + * 2) ->ops calls
> > + */
> > +DEFINE_SEMAPHORE(efivars_lock);
> > +
>
> Now it also protects registration of __efivars, so that needs to be
> documented too.
>
> >  static bool efivar_wq_enabled = true;
> >  DECLARE_WORK(efivar_work, NULL);
> >  EXPORT_SYMBOL_GPL(efivar_work);
> > @@ -376,7 +383,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
> >               return -ENOMEM;
> >       }
> >
> > -     spin_lock_irq(&__efivars->lock);
> > +     if (down_interruptible(&efivars_lock)) {
> > +             err = -EINTR;
> > +             goto free;
> > +     }
> >
> >       /*
> >        * Per EFI spec, the maximum storage allocated for both
> > @@ -392,7 +402,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
> >               switch (status) {
> >               case EFI_SUCCESS:
> >                       if (!atomic)
> > -                             spin_unlock_irq(&__efivars->lock);
> > +                             up(&efivars_lock);
> >
> >                       variable_name_size = var_name_strnsize(variable_name,
> >                                                              variable_name_size);
> > @@ -410,7 +420,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
> >                               dup_variable_bug(variable_name, &vendor_guid,
> >                                                variable_name_size);
> >                               if (!atomic)
> > -                                     spin_lock_irq(&__efivars->lock);
> > +                                     if (down_interruptible(&efivars_lock)) {
> > +                                             err = -EINTR;
> > +                                             goto free;
> > +                                     }
> >
> >                               status = EFI_NOT_FOUND;
> >                               break;
>
> Add braces to the if(!atomic) clause please to help with readability.
>
> > @@ -421,7 +434,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
> >                               status = EFI_NOT_FOUND;
> >
> >                       if (!atomic)
> > -                             spin_lock_irq(&__efivars->lock);
> > +                             if (down_interruptible(&efivars_lock)) {
> > +                                     err = -EINTR;
> > +                                     goto free;
> > +                             }
> >
> >                       break;
> >               case EFI_NOT_FOUND:
>
> Ditto.
>
> > @@ -533,12 +559,14 @@ int efivar_entry_delete(struct efivar_entry *entry)
> >       const struct efivar_operations *ops = __efivars->ops;
> >       efi_status_t status;
> >
> > -     spin_lock_irq(&__efivars->lock);
> > +     if (down_interruptible(&efivars_lock))
> > +             return -EINTR;
> > +
> >       status = ops->set_variable(entry->var.VariableName,
> >                                  &entry->var.VendorGuid,
> >                                  0, 0, NULL);
> >       if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
> > -             spin_unlock_irq(&__efivars->lock);
> > +             up(&efivars_lock);
> >               return efi_status_to_err(status);
> >       }
> >
>
> Please update the documentation for this function to note that we
> return -EINTR if we can't grab the semaphore.
>
> > @@ -576,10 +604,10 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
> >       efi_char16_t *name = entry->var.VariableName;
> >       efi_guid_t vendor = entry->var.VendorGuid;
> >
> > -     spin_lock_irq(&__efivars->lock);
> > -
> > +     if (down_interruptible(&efivars_lock))
> > +             return -EINTR;
> >       if (head && efivar_entry_find(name, vendor, head, false)) {
> > -             spin_unlock_irq(&__efivars->lock);
> > +             up(&efivars_lock);
> >               return -EEXIST;
> >       }
> >
> > @@ -588,7 +616,7 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
> >               status = ops->set_variable(name, &vendor,
> >                                          attributes, size, data);
> >
> > -     spin_unlock_irq(&__efivars->lock);
> > +     up(&efivars_lock);
> >
> >       return efi_status_to_err(status);
> >
>
> Function documentation for the return values needs updating here too.
>
> > @@ -1055,12 +1087,16 @@ int efivars_register(struct efivars *efivars,
> >                    const struct efivar_operations *ops,
> >                    struct kobject *kobject)
> >  {
> > -     spin_lock_init(&efivars->lock);
> > +     if (down_trylock(&efivars_lock))
> > +             return -EBUSY;
> > +
>
> Is this correct? I would have assumed that you'd want to return -EINTR
> here, not -EBUSY since if an EFI variable operation is currently
> running we should spin waiting for the semaphore to be released.

No because this is a trylock, it will not wait for the semaphore to be release,
it will return as soon as it sees that the semaphore is locked.
We don't want to use down_interruptible() here because we want to be able to
(un)register efivars operation in an interrupt context.

>
> >       efivars->ops = ops;
> >       efivars->kobject = kobject;
> >
> >       __efivars = efivars;
> >
> > +     up(&efivars_lock);
> > +
> >       return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(efivars_register);
> > @@ -1076,6 +1112,9 @@ int efivars_unregister(struct efivars *efivars)
> >  {
> >       int rv;
> >
> > +     if (down_trylock(&efivars_lock))
> > +             return -EBUSY;
> > +
>
> Same logic applies in the unregister case.


Thanks Matt,

I'll provide updated patches soon
-- 
Sylvain
