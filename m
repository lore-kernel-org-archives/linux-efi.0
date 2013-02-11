From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2] efivarfs: guid part of filenames are case-insensitive
Date: Mon, 11 Feb 2013 15:37:45 +0000
Message-ID: <20130211153745.GA27879@ZenIV.linux.org.uk>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
 <20130211152221.GL4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130211152221.GL4503-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2013 at 03:22:21PM +0000, Al Viro wrote:
> > +static int efivarfs_d_compare(const struct dentry *parent, const struct inode *pinode,
> > +			      const struct dentry *dentry, const struct inode *inode,
> > +			      unsigned int len, const char *str,
> > +			      const struct qstr *name)
> > +{
> > +	const char *q;
> > +	int guid;
> > +
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
> 
> > +
> > +	/* Find part 1, the variable name. */
> > +	guid = q - (const char *)name->name;
> 
> No need to do strchr() for that - you know that name passes
> efivarfs_valid_name(), so you know how far from the end will GUID part begin.
> 
> > +	/* Case-sensitive compare for the variable name */
> > +	if (memcmp(str, name->name, guid))
> > +		return 1;

... and by the way, you need to compare lengths first, or that memcmp()
risks running out of mapped page.  Sure, it's NUL-terminated, but memcmp()
is *not* required to compare left-to-right; it's arch-dependent and the
very first memory access have every right to be at str + guid - 1.
