From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 22 Apr 2015 08:35:54 -0700
Message-ID: <1429716954.2195.28.camel@HansenPartnership.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
	 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
	 <20150414140914.GE5989@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
	 <20150415131906.GC21491@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150415131906.GC21491-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2015-04-15 at 15:19 +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 15, 2015 at 11:32:29AM +0000, Kweh, Hock Leong wrote:
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > > Sent: Tuesday, April 14, 2015 10:09 PM
> > > 
> > > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> > > > + */
> > > > +static void __exit efi_capsule_loader_exit(void)
> > > > +{
> > > > +	platform_device_unregister(efi_capsule_pdev);
> > > 
> > > This is not a platform device, don't abuse that interface please.
> > > 
> > > greg k-h
> > 
> > Okay, so you would recommend to use device_register() for this case?
> > Or you would think that this is more suitable to use class_register()?
> 
> A class isn't needed, you just want a device right?  So just use a
> device, but not a platform device, as that isn't what you have here.

Coming back to this, am I the only one confused here?  What is a
'platform device' then?  Because if it doesn't fit a direct channel to
the platform firmware, which seems to be one of the definitions covered
in driver-model/platform.txt under devices with minimal infrastructure
then perhaps the documentation needs updating.

James
