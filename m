From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [efi:next 15/19] fs/efivarfs/super.c:180:7-11: ERROR: reference
 preceded by free on line 162
Date: Mon, 15 Aug 2016 10:56:21 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1608151055330.4129@hadrien>
References: <alpine.DEB.2.10.1608091401570.2911@hadrien> <20160815145412.GH30909@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160815145412.GH30909-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On Mon, 15 Aug 2016, Matt Fleming wrote:

> On Tue, 09 Aug, at 02:02:39PM, Julia Lawall wrote:
> > Possibility of a double free.
> >
> > julia
> >
> > ---------- Forwarded message ----------
> > Date: Tue, 9 Aug 2016 19:58:20 +0800
> > From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > To: kbuild-JC7UmRfGjtg@public.gmane.org
> > Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
> > Subject: [efi:next 15/19] fs/efivarfs/super.c:180:7-11: ERROR: reference
> >     preceded by free on line 162
> >
> > CC: kbuild-all-JC7UmRfGjtg@public.gmane.org
> > CC: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > TO: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > CC: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> > CC: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> >
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git next
> > head:   302c675f2c1f6a2426709695d6dfe8683cfc7bab
> > commit: 0d22f33bc37ce1c9f10dd304bd335d6feb7796d1 [15/19] efi: Don't use spinlocks for efi vars
> > :::::: branch date: 4 days ago
> > :::::: commit date: 2 weeks ago
> >
> > >> fs/efivarfs/super.c:180:7-11: ERROR: reference preceded by free on line 162
> >
> > git remote add efi https://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> > git remote update efi
> > git checkout 0d22f33bc37ce1c9f10dd304bd335d6feb7796d1
> > vim +180 fs/efivarfs/super.c
> >
> > d68772b7 Matt Fleming     2013-02-08  156  	if (IS_ERR(dentry)) {
> > d68772b7 Matt Fleming     2013-02-08  157  		err = PTR_ERR(dentry);
> > d68772b7 Matt Fleming     2013-02-08  158  		goto fail_inode;
> > d68772b7 Matt Fleming     2013-02-08  159  	}
> > d68772b7 Matt Fleming     2013-02-08  160
> > d68772b7 Matt Fleming     2013-02-08  161  	/* copied by the above to local storage in the dentry. */
> > d68772b7 Matt Fleming     2013-02-08 @162  	kfree(name);
> > d68772b7 Matt Fleming     2013-02-08  163
> > d68772b7 Matt Fleming     2013-02-08  164  	efivar_entry_size(entry, &size);
> > 0d22f33b Sylvain Chouleur 2016-07-15  165  	err = efivar_entry_add(entry, &efivarfs_list);
> > 0d22f33b Sylvain Chouleur 2016-07-15  166  	if (err)
> > 0d22f33b Sylvain Chouleur 2016-07-15  167  		goto fail_inode;
> > d68772b7 Matt Fleming     2013-02-08  168
> > 5955102c Al Viro          2016-01-22  169  	inode_lock(inode);
> > d68772b7 Matt Fleming     2013-02-08  170  	inode->i_private = entry;
> > d68772b7 Matt Fleming     2013-02-08  171  	i_size_write(inode, size + sizeof(entry->var.Attributes));
> > 5955102c Al Viro          2016-01-22  172  	inode_unlock(inode);
> > d68772b7 Matt Fleming     2013-02-08  173  	d_add(dentry, inode);
> > d68772b7 Matt Fleming     2013-02-08  174
> > d68772b7 Matt Fleming     2013-02-08  175  	return 0;
> > d68772b7 Matt Fleming     2013-02-08  176
> > d68772b7 Matt Fleming     2013-02-08  177  fail_inode:
> > d68772b7 Matt Fleming     2013-02-08  178  	iput(inode);
> > d68772b7 Matt Fleming     2013-02-08  179  fail_name:
> > d68772b7 Matt Fleming     2013-02-08 @180  	kfree(name);
> > d68772b7 Matt Fleming     2013-02-08  181  fail:
> > d68772b7 Matt Fleming     2013-02-08  182  	kfree(entry);
> > d68772b7 Matt Fleming     2013-02-08  183  	return err;
>
> Indeed. How about this?

It looks better to me.

Acked-by: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>

>
> ---
>
> From 403180deeb68ce6b78ac0e22c50dc6aa2003dab5 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Date: Mon, 15 Aug 2016 15:29:20 +0100
> Subject: [PATCH] fs/efivarfs: Fix double kfree() in error path
>
> Julia reported that we may double free 'name' in efivarfs_callback(),
> and that this bug was introduced by commit 0d22f33bc37c ("efi: Don't
> use spinlocks for efi vars").
>
> Move one of the kfree()s until after the point at which we know we are
> definitely on the success path.
>
> Reported-by: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  fs/efivarfs/super.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
> index e48feb022d82..a0837453dc2c 100644
> --- a/fs/efivarfs/super.c
> +++ b/fs/efivarfs/super.c
> @@ -158,14 +158,14 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
>  		goto fail_inode;
>  	}
>
> -	/* copied by the above to local storage in the dentry. */
> -	kfree(name);
> -
>  	efivar_entry_size(entry, &size);
>  	err = efivar_entry_add(entry, &efivarfs_list);
>  	if (err)
>  		goto fail_inode;
>
> +	/* copied by the above to local storage in the dentry. */
> +	kfree(name);
> +
>  	inode_lock(inode);
>  	inode->i_private = entry;
>  	i_size_write(inode, size + sizeof(entry->var.Attributes));
> --
> 2.7.3
>
>
