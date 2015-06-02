From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes for v4.2
Date: Tue, 2 Jun 2015 14:24:03 +0100
Message-ID: <20150602132403.GB6826@codeblueprint.co.uk>
References: <20150531162559.GA6826@codeblueprint.co.uk>
 <20150602064557.GB31128@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150602064557.GB31128-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 02 Jun, at 08:45:57AM, Ingo Molnar wrote:
> 
> Pulled, thanks a lot Matt!
> 
> I'm wondering about this commit:
> 
>   f2f6b587c553 ("efi/esrt: Fix some compiler warnings")
> 
> It says, in part:
> 
>  This patch also fixes one other warning about an uninitialized variable
>  some compiler versions seem to see.  You can't actually hit the code
>  path where it would be uninitialized, because there's a prior test that
>  would error out, but gcc hasn't figured that out.  Anyway, it now has a
>  test and returns the error at both places.
> 
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
 
Hmm... yeah good point. I admit that I missed that when merging this
patch because I was focusing more on the fix for the kbuild warnings
related to phys_addr_t.

Peter? Where did you see gcc complaining about this?

-- 
Matt Fleming, Intel Open Source Technology Center
