From: Peter Jones <pjones@redhat.com>
Subject: Re: [GIT PULL] EFI changes for v4.2
Date: Tue, 2 Jun 2015 09:59:44 -0400
Message-ID: <20150602135944.GB29523@redhat.com>
References: <20150531162559.GA6826@codeblueprint.co.uk>
 <20150602064557.GB31128@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150602064557.GB31128@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jun 02, 2015 at 08:45:57AM +0200, Ingo Molnar wrote:
> @@ -167,7 +167,6 @@ static struct kset *esrt_kset;
>  
>  static int esre_create_sysfs_entry(void *esre, int entry_num)
>  {
> -       int rc = 0;
>         struct esre_entry *entry;
>         char name[20];
>  
> @@ -180,13 +179,15 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
>         entry->kobj.kset = esrt_kset;
>  
>         if (esrt->fw_resource_version == 1) {
> +               int rc = 0;
> +
>                 entry->esre.esre1 = esre;
>                 rc = kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
>                                           "%s", name);
> -       }
> -       if (rc) {
> -               kfree(entry);
> -               return rc;
> +               if (rc) {
> +                       kfree(entry);
> +                       return rc;
> +               }
>         }
>  
>         list_add_tail(&entry->list, &entry_list);
> 
> How can a compiler ever have warned about 'rc' being uninitialized? It's defined 
> straight at function entry, with initialization to 0. It can never be 
> uninitialized.
>
> I pulled it, because I agree with the change itself, as it's always better to 
> define and use variables in the narrowest scope possible, but I think it's a 
> cleanup, not a compiler warning fix.

Well, apparently I failed to explain it well - the warning was about
"esre" rather than "rc".  Basically before we were testing the version in
register_entries() (i.e. this function's caller) and never calling the
this function if it's not version 1.  The compiler didn't figure out
that when we set "entry->esre.esre1 = esre;", esre can not be null
because the function wouldn't be called.  Adding the explicit check
on the version here silenced the warning about entry plausibly being
NULL.

I'm guessing that this is because it's checking that the same
conditional test is involved - that the initialization is in the same
"...version == 1" test that the usage is.  But that's just a guess.

Would you like another patch to add this email to the commit message, or
do you want to add it in your tree, or what?

-- 
        Peter
