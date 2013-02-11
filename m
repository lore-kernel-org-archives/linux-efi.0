From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 1/2] efivarfs: Validate filenames much more aggressively
Date: Mon, 11 Feb 2013 15:12:31 +0000
Message-ID: <20130211151231.GA26681@console-pimps.org>
References: <1360592935-26026-1-git-send-email-matt@console-pimps.org>
 <1360592935-26026-2-git-send-email-matt@console-pimps.org>
 <20130211150109.GK4503@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130211150109.GK4503-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 11 Feb, at 03:01:09PM, Al Viro wrote:
> 
> Yecchhh...  How about
> 	static const char dashes[GUID_LEN] = {
> 		[8] = 1, [13] = 1, [18] = 1, [23] = 1
> 	};
> 	const char *s = str + len - GUID_LEN;
> 	int i;
> 	/*
> 	 * We need a GUID, plus at least one letter for the variable name,
> 	 * plus the '-' separator
> 	 */
> 	if (len < GUID_LEN + 2)
> 		return 0;
> 
> 	/* GUID should be right after the first '-' */
> 	if (s - 1 != strchr(str, '-'))
> 		return 0;
> 
> 	/*
> 	 * Validate that 's' is of the correct format, e.g.
> 	 *
> 	 *	12345678-1234-1234-1234-123456789abc
> 	 */
> 	for (i = 0; i < GUID_LEN; i++) {
> 		if (dashes[i]) {
> 			if (*s++ != '-')
> 				return 0;
> 		} else {
> 			if (!isxdigit(*s++))
> 				return 0;
> 		}
> 	}
> 	return 1;
> 
> instead?

Sure, that's a nice improvement.

Also, I did have a version of this patch that returned a boolean, but
that seems to have been lost in one of my topic branches.

I'll respind this, thanks Al.

-- 
Matt Fleming, Intel Open Source Technology Center
