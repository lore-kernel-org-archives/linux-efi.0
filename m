From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH 2/2] efivarfs: guid part of filenames are case-insensitive
Date: Mon, 11 Feb 2013 17:30:57 +0000
Message-ID: <20130211173057.GM4503@ZenIV.linux.org.uk>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-3-git-send-email-matt@console-pimps.org>
 <20130211152221.GL4503@ZenIV.linux.org.uk>
 <20130211160557.GB26681@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130211160557.GB26681-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Feb 11, 2013 at 04:05:57PM +0000, Matt Fleming wrote:
> > Egads, man...
> > [snip the horror with copying the name]
> > 
> >         unsigned long hash = init_name_hash();
> > 	const unsigned char *s = qstr->name;
> > 	int len = qstr->len;
> > 
> > 	if (!efivarfs_valid_name(s, len))
> > 		return -EINVAL;
> >         while (len-- > GUID_LEN)
> > 		hash = partial_name_hash(*s++, hash);
> > 	/* GUID is case-insensitive. */
> > 	while (len--)
> > 		hash = partial_name_hash(tolower(*s++), hash);
> >         return end_name_hash(hash);
> 
> Oh, wow, yes that is much nicer. I didn't realise we could build the
> hash incrementally like that. Very cool.

... except that it should end with qstr->hash = end_name_hash(hash); return 0;
instead.  My apologies.
