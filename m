From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v4.2
Date: Wed, 3 Jun 2015 08:22:48 +0200
Message-ID: <20150603062247.GA24639@gmail.com>
References: <20150531162559.GA6826@codeblueprint.co.uk>
 <20150602064557.GB31128@gmail.com>
 <20150602135944.GB29523@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150602135944.GB29523-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Jun 02, 2015 at 08:45:57AM +0200, Ingo Molnar wrote:
> > @@ -167,7 +167,6 @@ static struct kset *esrt_kset;
> >  
> >  static int esre_create_sysfs_entry(void *esre, int entry_num)
> >  {
> > -       int rc = 0;
> >         struct esre_entry *entry;
> >         char name[20];
> >  
> > @@ -180,13 +179,15 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
> >         entry->kobj.kset = esrt_kset;
> >  
> >         if (esrt->fw_resource_version == 1) {
> > +               int rc = 0;
> > +
> >                 entry->esre.esre1 = esre;
> >                 rc = kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
> >                                           "%s", name);
> > -       }
> > -       if (rc) {
> > -               kfree(entry);
> > -               return rc;
> > +               if (rc) {
> > +                       kfree(entry);
> > +                       return rc;
> > +               }
> >         }
> >  
> >         list_add_tail(&entry->list, &entry_list);
> > 
> > How can a compiler ever have warned about 'rc' being uninitialized? It's defined 
> > straight at function entry, with initialization to 0. It can never be 
> > uninitialized.
> >
> > I pulled it, because I agree with the change itself, as it's always better to 
> > define and use variables in the narrowest scope possible, but I think it's a 
> > cleanup, not a compiler warning fix.
> 
> Well, apparently I failed to explain it well - the warning was about
> "esre" rather than "rc".  Basically before we were testing the version in
> register_entries() (i.e. this function's caller) and never calling the
> this function if it's not version 1.  The compiler didn't figure out
> that when we set "entry->esre.esre1 = esre;", esre can not be null
> because the function wouldn't be called.  Adding the explicit check
> on the version here silenced the warning about entry plausibly being
> NULL.
> 
> I'm guessing that this is because it's checking that the same
> conditional test is involved - that the initialization is in the same
> "...version == 1" test that the usage is.  But that's just a guess.
> 
> Would you like another patch to add this email to the commit message, or do you 
> want to add it in your tree, or what?

No need, I already pulled, because the changes themselves seemed OK - just wanted 
to ask in case there's something subtle going on.

Thanks,

	Ingo
