From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2 v2] efivarfs: guid part of filenames are
 case-insensitive
Date: Thu, 14 Feb 2013 17:55:19 +0000
Message-ID: <20130214175519.GV4503@ZenIV.linux.org.uk>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
 <20130212123934.GC14790@console-pimps.org>
 <20130214160405.GU4503@ZenIV.linux.org.uk>
 <1360861876.24917.52.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360861876.24917.52.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 14, 2013 at 05:11:16PM +0000, Matt Fleming wrote:
> On Thu, 2013-02-14 at 16:04 +0000, Al Viro wrote:
> > On Tue, Feb 12, 2013 at 12:39:34PM +0000, Matt Fleming wrote:
> > 
> > > +static struct dentry *efivarfs_alloc_dentry(struct dentry *parent, char *name)
> > > +{
> > > +	struct qstr q;
> > > +
> > > +	q.name = name;
> > > +	q.len = strlen(name);
> > > +
> > > +	if (efivarfs_d_hash(NULL, NULL, &q))
> > > +		return NULL;
> > > +
> > > +	return d_alloc(parent, &q);
> > > +}
> > 
> > > @@ -1098,7 +1177,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
> > >  		if (!inode)
> > >  			goto fail_name;
> > >  
> > > -		dentry = d_alloc_name(root, name);
> > > +		dentry = efivarfs_alloc_dentry(root, name);
> > >  		if (!dentry)
> > >  			goto fail_inode;
> > 
> > Umm...  That name has just been built by efivarfs_fill_super() itself, and
> > AFAICS there's no way for its GUID part to be _not_ lowercase
> > hex and with proper locations of dashes.  So
> > 	a) hash value will be exactly full_name_hash(name), unless
> > efivarfs_valid_name() manages to fail.
> 
> In my testing calling full_name_hash() and doing the partial_name_hash()
> loop returned different results. This is on x86, with
> CONFIG_DCACHE_WORD_ACCESS=y. I assumed they weren't compatible because
> most (all?) file systems that do fs-specific hashing also fill out the
> hash member using their fs-specific function, whereas efivarfs was
> previously using d_alloc_name().
> 
> Is this mismatch indicative of a bug in efivarfs hashing?

No, just me forgetting about DCACHE_WORD_ACCESS.  Nevermind...
