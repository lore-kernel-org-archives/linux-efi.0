From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] samsung-laptop: Disable if CONFIG_EFI=y
Date: Sun, 04 Nov 2012 20:58:44 +0000
Message-ID: <1352062724.14888.206.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1352050506-29317-1-git-send-email-matt@console-pimps.org>
	 <20121104174713.GA28414@elie.Belkin>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121104174713.GA28414-fcEM2ccDkbL2nhBuCrrZHw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Nieder <jrnieder-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Corentin Chary <corentincj-EjuBZuxMvz2sTnJN9+BGXg@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, platform-driver-x86-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alessandro Crismani <alessandro.crismani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mikhail Bakhterev <mike.bakhterev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Patrick H <kernel-0BLq+tI11CLk1uMJSBkQmQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 2012-11-04 at 09:47 -0800, Jonathan Nieder wrote:
> Matt Fleming wrote:
> 
> > --- a/drivers/platform/x86/Kconfig
> > +++ b/drivers/platform/x86/Kconfig
> > @@ -717,7 +717,7 @@ config XO15_EBOOK
> > 
> >  config SAMSUNG_LAPTOP
> >  	tristate "Samsung Laptop driver"
> > -	depends on X86
> > +	depends on X86 && !EFI
> 
> That means distros would just not get the samsung-laptop driver.
> Is there a runtime check that could be used instead?

Well, the closest thing we have at the moment is the 'efi_enabled'
variable, but that doesn't actually mean "We were booted from EFI?", it
means "Do we have EFI runtime services?", and that's not a broad enough
check for this case. We don't have access to the EFI runtime services
when a 64-bit kernel is booted from 32-bit EFI firmware or vice-versa.
Notably the chromebooks use this scheme. And seeing as Samsung make
chromebooks, I'm not convinced we won't hit that case.

But yeah, you've got a valid point. Clearly we need a way to check this
at runtime. I'll repsin this patch.

-- 
Matt Fleming, Intel Open Source Technology Center
