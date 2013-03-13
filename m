From: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] efivars: Allow disabling use as a pstore backend
Date: Wed, 13 Mar 2013 12:07:24 -0500
Message-ID: <20130313170724.GB12157@thinkpad-t410>
References: <1362678017-2862-1-git-send-email-seth.forshee@canonical.com>
 <5138FAD9.7050504@zytor.com>
 <20130307205915.GF24233@thinkpad-t410>
 <1362694529.15011.211.camel@mfleming-mobl1.ger.corp.intel.com>
 <513911F9.8050308@zytor.com>
 <20130311211750.GB8440@thinkpad-t410>
 <1363118073.15011.275.camel@mfleming-mobl1.ger.corp.intel.com>
 <20130312211417.GC16558@thinkpad-t410>
 <1363189770.15011.300.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1363189770.15011.300.camel-ZqTwcBeJ+wsBof6jY8KHXm7IUlhRatedral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 13, 2013 at 03:49:30PM +0000, Matt Fleming wrote:
> > diff --git a/drivers/firmware/Kconfig b/drivers/firmware/Kconfig
> > index 9b00072..35f7d16 100644
> > --- a/drivers/firmware/Kconfig
> > +++ b/drivers/firmware/Kconfig
> > @@ -53,6 +53,15 @@ config EFI_VARS
> >  	  Subsequent efibootmgr releases may be found at:
> >  	  <http://linux.dell.com/efibootmgr>
> >  
> > +config EFI_VARS_PSTORE
> > +	bool "Use efivars as a pstore backend"
> > +	depends on EFI_VARS
> > +	default y
> > +	help
> > +	  Say Y here to enable the use of efivars as a storage backend
> > +	  for pstore. This setting can be overridden using the
> > +	  efivars.pstore_enable parameter.
> > +
> 
> The depends here should probably include PSTORE, which I think it did on
> previous iterations. I can't think of a situation where you'd want to
> disable CONFIG_PSTORE but enable CONFIG_EFI_VARS_PSTORE. Also, we don't
> need to use CONFIG_EFI_VARS_PSTORE solely for the purpose of setting the
> initial value of efivars_pstore_enabled - there's merit in also using it
> to leave out the pstore code in efivars.c during compilation.
> 
> Granted, this change does mean that your decision at compile time may be
> final, and you can't enable the pstore code at runtime if you built your
> kernel/efivars module with CONFIG_EFI_VARS_PSTORE=n. Arguably, I think
> that's a feature that some people will want, e.g. "Don't allow enabling
> the efivars pstore backend at all... no, srsly!".

Hmm. Since my original patch was to compile pstore support out
completely, I interpreted Peter's suggestion to be allowing the user
override the default even if the default is disabled. That's the
assumption my implementation was based off of, but maybe I
misunderstood.

But if Peter agrees with your changes then I'm fine with them too.

Thanks,
Seth
