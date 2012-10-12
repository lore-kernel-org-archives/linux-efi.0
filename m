From: Khalid Aziz <khalid-21RPF02GE+GXwddmVfQv5g@public.gmane.org>
Subject: Re: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our
 reference on inode on error
Date: Fri, 12 Oct 2012 13:03:49 -0600
Message-ID: <1350068629.7065.58.camel@rhapsody>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
	 <1349951541-20498-3-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1349951541-20498-3-git-send-email-apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2012-10-11 at 11:32 +0100, Andy Whitcroft wrote:
> Signed-off-by: Andy Whitcroft <apw-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> ---
>  drivers/firmware/efivars.c |   14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index ae50d2f..0bbf742 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -866,7 +866,7 @@ static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
>  static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  			  umode_t mode, bool excl)
>  {
> -	struct inode *inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
> +	struct inode *inode;
>  	struct efivars *efivars = &__efivars;
>  	struct efivar_entry *var;
>  	int namelen, i = 0, err = 0;
> @@ -874,13 +874,15 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	if (dentry->d_name.len < 38)
>  		return -EINVAL;
>  
> +	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
>  	if (!inode)
>  		return -ENOSPC;
>  
>  	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
> -
> -	if (!var)
> -		return -ENOMEM;
> +	if (!var) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
>  

This does not read right. If kzalloc() fails, var will be a NULL
pointer. This code will set err to -ENOMEM and jump to out: where since
err is non-zero, this code will call kfree(Var) but var is a NULL
pointer at this point. Now kfree() does check for NULL pointer and this
will not cause any serious problems but why call kfree for a NULL
pointer?


>  	namelen = dentry->d_name.len - GUID_LEN;
>  
> @@ -908,8 +910,10 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	d_instantiate(dentry, inode);
>  	dget(dentry);
>  out:
> -	if (err)
> +	if (err) {
>  		kfree(var);
> +		iput(inode);
> +	}
>  	return err;
>  }
>  

--
Khalid


--
To unsubscribe from this list: send the line "unsubscribe linux-efi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
