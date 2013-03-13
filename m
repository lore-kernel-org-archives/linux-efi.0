From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Wed, 13 Mar 2013 14:14:55 -0500
Message-ID: <20130313191455.GC12157@thinkpad-t410>
References: <20130307205915.GF24233@thinkpad-t410>
 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
 <513911F9.8050308@zytor.com>
 <20130311211750.GB8440@thinkpad-t410>
 <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
 <20130312211417.GC16558@thinkpad-t410>
 <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com>
 <20130313170724.GB12157@thinkpad-t410>
 <5140B674.8070308@zytor.com>
 <1363199617.15011.310.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363199617.15011.310.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 13, 2013 at 06:33:37PM +0000, Matt Fleming wrote:
> On Wed, 2013-03-13 at 10:25 -0700, H. Peter Anvin wrote:
> > I think there should be two compile-time options (one to compile in the
> > EFI pstore code at all, and one to set its default.)
> 
> OK, sorry Seth, looks like I'm the one that misunderstood. I've picked
> up your first two patches and pushed them out to the urgent branch.
> Please check that they look OK - they required minor fixups.

A minor nit from the second patch:

+static bool efivars_pstore_disable = \
+       IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);

The backslash isn't necessary.

Otherwise everything looks fine afaict.

Thanks,
Seth
