From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] efivarfs: Eliminate dead code in efivarfs_create()
Date: Wed, 24 Feb 2016 16:47:34 +0000
Message-ID: <20160224164734.GC2603@codeblueprint.co.uk>
References: <1456243630-24834-1-git-send-email-tklauser@distanz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456243630-24834-1-git-send-email-tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 23 Feb, at 05:07:10PM, Tobias Klauser wrote:
> After commit ed8b0de5a33d ("efi: Make efivarfs entries immutable by
> default"), inode will always be NULL in the error check before iput(),
> thus remove the check and the call to iput() alltogether. Also directly
> fold the error handling code into the only place it is needed, which
> makes the code a bit smaller.
> 
> Found by the Coverity scanner (CID 1353443).
> 
> Signed-off-by: Tobias Klauser <tklauser-93Khv+1bN0NyDzI6CaY1VQ@public.gmane.org>
> ---
>  fs/efivarfs/inode.c | 15 +++++----------
>  1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
> index e2ab6d0497f2..43321c9cd71b 100644
> --- a/fs/efivarfs/inode.c
> +++ b/fs/efivarfs/inode.c
> @@ -106,7 +106,7 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  {
>  	struct inode *inode = NULL;
>  	struct efivar_entry *var;
> -	int namelen, i = 0, err = 0;
> +	int namelen, i = 0;
>  	bool is_removable = false;
>  
>  	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
> @@ -128,8 +128,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  
>  	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0, is_removable);
>  	if (!inode) {
> -		err = -ENOMEM;
> -		goto out;
> +		kfree(var);
> +		return -ENOMEM;
>  	}
>  
>  	for (i = 0; i < namelen; i++)
> @@ -142,13 +142,8 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	efivar_entry_add(var, &efivarfs_list);
>  	d_instantiate(dentry, inode);
>  	dget(dentry);
> -out:
> -	if (err) {
> -		kfree(var);
> -		if (inode)
> -			iput(inode);
> -	}
> -	return err;
> +
> +	return 0;
>  }
>  
>  static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)

Looks good to me. Thanks, applied!
