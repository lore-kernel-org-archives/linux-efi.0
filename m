From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2 v2] efivarfs: guid part of filenames are
 case-insensitive
Date: Thu, 14 Feb 2013 16:04:05 +0000
Message-ID: <20130214160405.GU4503@ZenIV.linux.org.uk>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
 <20130212123934.GC14790@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130212123934.GC14790-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 12, 2013 at 12:39:34PM +0000, Matt Fleming wrote:

> +static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
> +{
> +	struct qstr q;
> +
> +	q.name = name;
> +	q.len = strlen(name);
> +
> +	if (efivarfs_d_hash(NULL, NULL, &q))
> +		return NULL;
> +
> +	return d_alloc(parent, &q);
> +}

> @@ -1098,7 +1177,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
>  		if (!inode)
>  			goto fail_name;
>  
> -		dentry = d_alloc_name(root, name);
> +		dentry = efivarfs_alloc_dentry(root, name);
>  		if (!dentry)
>  			goto fail_inode;

Umm...  That name has just been built by efivarfs_fill_super() itself, and
AFAICS there's no way for its GUID part to be _not_ lowercase
hex and with proper locations of dashes.  So
	a) hash value will be exactly full_name_hash(name), unless
efivarfs_valid_name() manages to fail.
	b) efivarfs_valid_name() is a serious overkill here - the only things
that might go wrong are length of and dashes in entry->var.VariableName.
Both are trivially checked while we are constructing name (before we do
inode allocation, etc.) and IMO they would be better off there.

IOW, I think this part of the patch is better handled by doing those two
checks several lines before d_alloc_name() and not bothering with
efivarfs_alloc_dentry() at all.  I.e.
		if (len + 1 + GUID_LEN > NAME_MAX)
			goto fail;

		name = kmalloc(len + 1 + GUID_LEN + 1, GFP_ATOMIC);
		if (!name)
			goto fail;

		for (i = 0; i < len; i++) {
			name[i] = entry->var.VariableName[i] & 0xFF;
			if (name[i] == '-')
				goto fail_name;
		}
and then as in the current efivarfs_fill_super().
