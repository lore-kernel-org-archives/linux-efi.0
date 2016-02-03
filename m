From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/5] efi: Make efivarfs entries immutable by default.
Date: Wed, 3 Feb 2016 13:16:11 +0000
Message-ID: <20160203131611.GG2597@codeblueprint.co.uk>
References: <1454452386-27709-1-git-send-email-pjones@redhat.com>
 <1454452386-27709-6-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454452386-27709-6-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 02 Feb, at 05:33:06PM, Peter Jones wrote:
> "rm -rf" is bricking some peoples' laptops because of variables being
> used to store non-reinitializable firmware driver data that's required
> to POST the hardware.
> 
> These are 100% bugs, and they need to be fixed, but in the mean time it
> shouldn't be easy to *accidentally* brick machines.
> 
> We have to have delete working, and picking which variables do and don't
> work for deletion is quite intractable, so instead make everything
> immutable by default, and make tools that aren't quite so broad-spectrum
> unset the immutable flag.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/vars.c | 82 +++++++++++++++++++++++++++++++++------------
>  fs/efivarfs/file.c          | 69 ++++++++++++++++++++++++++++++++++++++
>  fs/efivarfs/inode.c         | 32 ++++++++++++------
>  fs/efivarfs/internal.h      |  3 +-
>  fs/efivarfs/super.c         |  9 +++--
>  include/linux/efi.h         |  2 ++
>  6 files changed, 162 insertions(+), 35 deletions(-)
 
Only the last two patches (4 and 5) of this series are required to fix
this bricking issue, right? The fix needs backporting to stable
kernels and if the first three patches are just improving the
robustness of UCS-2 handling, they don't qualify for backport.

> diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
> index e084d08..3a16a57 100644
> --- a/drivers/firmware/efi/vars.c
> +++ b/drivers/firmware/efi/vars.c
> @@ -186,9 +186,32 @@ static const struct variable_validate variable_validate[] = {
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Timeout", validate_uint16 },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "Lang", validate_ascii_string },
>  	{ EFI_GLOBAL_VARIABLE_GUID, "PlatformLang", validate_ascii_string },
> +	{ EFI_GLOBAL_VARIABLE_GUID, "OsIndications", NULL },
>  	{ NULL_GUID, "", NULL },
>  };

It would be good to include a comment above this table that documents
what it is used for since we're adding one more use.
  
> +bool
> +efivar_variable_is_protected(efi_guid_t vendor, const char *var_name,
> +			     size_t len)
> +{
> +	int i;
> +	bool found = false;
> +	int match = 0;
>  
> -			/* Reached the end of the string while matching */
> -			if (!c) {
> -				kfree(utf8_name);
> -				return variable_validate[i].validate(var_name,
> -							     match, data, len);
> -			}
> +	/*
> +	 * Now check the validated variables list and then the whitelist -
> +	 * both are whitelists
> +	 */
> +	for (i = 0; variable_validate[i].name[0] != '\0'; i++) {
> +		if (efi_guidcmp(variable_validate[i].guid, vendor))
> +			continue;
> +
> +		if (variable_matches(var_name, len,
> +				     variable_validate[i].name, &match)) {
> +			found = true;
> +			break;
>  		}
>  	}
>  
> -	kfree(utf8_name);
> +	/*
> +	 * If we found it in our list, it /isn't/ one of our protected names.
> +	 */
> +	if (found)
> +		return false;
>  	return true;
>  }
> -EXPORT_SYMBOL_GPL(efivar_validate);
> +EXPORT_SYMBOL_GPL(efivar_variable_is_protected);

"protected" is a bit of a vague word in this context.

How about inverting the return values and naming it,

efivar_variable_is_removable() ? Or efivar_variable_is_deletable() ?
  
> @@ -102,22 +104,17 @@ static void efivarfs_hex_to_guid(const char *str, efi_guid_t *guid)
>  static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  			  umode_t mode, bool excl)
>  {
> -	struct inode *inode;
> +	struct inode *inode = NULL;
>  	struct efivar_entry *var;
>  	int namelen, i = 0, err = 0;
> +	bool is_protected = false;
>  
>  	if (!efivarfs_valid_name(dentry->d_name.name, dentry->d_name.len))
>  		return -EINVAL;
>  
> -	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0);
> -	if (!inode)
> -		return -ENOMEM;
> -
>  	var = kzalloc(sizeof(struct efivar_entry), GFP_KERNEL);
> -	if (!var) {
> -		err = -ENOMEM;
> -		goto out;
> -	}
> +	if (!var)
> +		return -ENOMEM;
>  
>  	/* length of the variable name itself: remove GUID and separator */
>  	namelen = dentry->d_name.len - EFI_VARIABLE_GUID_LEN - 1;
> @@ -125,6 +122,18 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
>  	efivarfs_hex_to_guid(dentry->d_name.name + namelen + 1,
>  			&var->var.VendorGuid);
>  
> +	if (efivar_variable_is_protected(var->var.VendorGuid,
> +					 dentry->d_name.name,
> +					 dentry->d_name.len))
> +		is_protected = true;
> +
> +	inode = efivarfs_get_inode(dir->i_sb, dir, mode, 0, is_protected);
> +	if (!inode) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +	inode->i_flags = 0;
> +

What's the point looking up efivar_variable_is_protected() if you
trash ->i_flags?
