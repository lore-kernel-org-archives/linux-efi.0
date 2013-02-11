From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 2/2] efivarfs: guid part of filenames are case-insensitive
Date: Mon, 11 Feb 2013 16:05:57 +0000
Message-ID: <20130211160557.GB26681@console-pimps.org>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
 <20130211152221.GL4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130211152221.GL4503-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Feb, at 03:22:21PM, Al Viro wrote:
> > +	/*
> > +	 * If the string we're being asked to compare doesn't match
> > +	 * the expected format return "no match".
> > +	 */
> > +	if (!efivarfs_valid_name(str, len))
> > +		return 1;
> > +	if (!(q = strchr(name->name, '-')))
> > +		return 1;
> 
> No.  Why check that again, when we'd already called ->d_hash() on the
> incoming name *and* candidate dentry?  And buggered off on any potential
> errors.

Good point.

> > +
> > +	/* Find part 1, the variable name. */
> > +	guid = q - (const char *)name->name;
> 
> No need to do strchr() for that - you know that name passes
> efivarfs_valid_name(), so you know how far from the end will GUID part begin.

Right.

> > +	/* Case-sensitive compare for the variable name */
> > +	if (memcmp(str, name->name, guid))
> > +		return 1;
> > +
> > +	/* Case-insensitive compare for the GUID */
> > +	return strcasecmp(&name->name[guid], &str[guid]);
> > +}
> 
> > +static int efivarfs_d_hash(const struct dentry *dentry,
> > +			   const struct inode *inode, struct qstr *qstr)
> > +{
> Egads, man...
> [snip the horror with copying the name]
> 
>         unsigned long hash = init_name_hash();
> 	const unsigned char *s = qstr->name;
> 	int len = qstr->len;
> 
> 	if (!efivarfs_valid_name(s, len))
> 		return -EINVAL;
>         while (len-- > GUID_LEN)
> 		hash = partial_name_hash(*s++, hash);
> 	/* GUID is case-insensitive. */
> 	while (len--)
> 		hash = partial_name_hash(tolower(*s++), hash);
>         return end_name_hash(hash);

Oh, wow, yes that is much nicer. I didn't realise we could build the
hash incrementally like that. Very cool.

-- 
Matt Fleming, Intel Open Source Technology Center
