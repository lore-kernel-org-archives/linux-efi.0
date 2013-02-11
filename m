From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2] efivarfs: guid part of filenames are case-insensitive
Date: Mon, 11 Feb 2013 15:22:21 +0000
Message-ID: <20130211152221.GL4503@ZenIV.linux.org.uk>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360592935-26026-3-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2013 at 02:28:55PM +0000, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> It makes no sense to treat the following filenames as unique,
> 
> 	VarName-abcdefab-abcd-abcd-abcd-abcdefabcdef
> 	VarName-ABCDEFAB-ABCD-ABCD-ABCD-ABCDEFABCDEF
> 	VarName-ABcDEfAB-ABcD-ABcD-ABcD-ABcDEfABcDEf
> 	VarName-aBcDEfAB-aBcD-aBcD-aBcD-aBcDEfaBcDEf
> 	... etc ...
> 
> since the guid will be converted into a binary representation, which
> has no case.
> 
> Roll our own dentry operations so that we can treat the variable name
> part of filenames ("VarName" in the above example) as case-sensitive,
> but the guid portion as case-insensitive. That way, efivarfs will
> refuse to create the above files if any one already exists.
> 
> Reported-by: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
> Cc: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efivars.c | 101 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 100 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
> index a4fa409..10088fd 100644
> --- a/drivers/firmware/efivars.c
> +++ b/drivers/firmware/efivars.c
> @@ -79,6 +79,7 @@
>  #include <linux/device.h>
>  #include <linux/slab.h>
>  #include <linux/pstore.h>
> +#include <linux/ctype.h>
>  
>  #include <linux/fs.h>
>  #include <linux/ramfs.h>
> @@ -1049,6 +1050,91 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
>  	return -EINVAL;
>  };
>  
> +/*
> + * Compare two efivarfs file names.
> + *
> + * An efivarfs filename is composed of two parts,
> + *
> + *	1. A case-sensitive variable name
> + *	2. A case-insensitive GUID
> + *
> + * So we need to perform a case-sensitive match on part 1 and a
> + * case-insensitive match on part 2.
> + */
> +static int efivarfs_d_compare(const struct dentry *parent, const struct inode *pinode,
> +			      const struct dentry *dentry, const struct inode *inode,
> +			      unsigned int len, const char *str,
> +			      const struct qstr *name)
> +{
> +	const char *q;
> +	int guid;
> +
> +	/*
> +	 * If the string we're being asked to compare doesn't match
> +	 * the expected format return "no match".
> +	 */
> +	if (!efivarfs_valid_name(str, len))
> +		return 1;
> +	if (!(q = strchr(name->name, '-')))
> +		return 1;

No.  Why check that again, when we'd already called ->d_hash() on the
incoming name *and* candidate dentry?  And buggered off on any potential
errors.

> +
> +	/* Find part 1, the variable name. */
> +	guid = q - (const char *)name->name;

No need to do strchr() for that - you know that name passes
efivarfs_valid_name(), so you know how far from the end will GUID part begin.

> +	/* Case-sensitive compare for the variable name */
> +	if (memcmp(str, name->name, guid))
> +		return 1;
> +
> +	/* Case-insensitive compare for the GUID */
> +	return strcasecmp(&name->name[guid], &str[guid]);
> +}

> +static int efivarfs_d_hash(const struct dentry *dentry,
> +			   const struct inode *inode, struct qstr *qstr)
> +{
Egads, man...
[snip the horror with copying the name]

        unsigned long hash = init_name_hash();
	const unsigned char *s = qstr->name;
	int len = qstr->len;

	if (!efivarfs_valid_name(s, len))
		return -EINVAL;
        while (len-- > GUID_LEN)
		hash = partial_name_hash(*s++, hash);
	/* GUID is case-insensitive. */
	while (len--)
		hash = partial_name_hash(tolower(*s++), hash);
        return end_name_hash(hash);
