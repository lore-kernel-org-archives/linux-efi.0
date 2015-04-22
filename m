From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 22 Apr 2015 09:11:17 -0700
Message-ID: <1429719077.2195.37.camel@HansenPartnership.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
	 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
	 <20150414140914.GE5989@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
	 <20150415131906.GC21491@kroah.com>
	 <1429716954.2195.28.camel@HansenPartnership.com>
	 <20150422154620.GA32576@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150422154620.GA32576-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2015-04-22 at 17:46 +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 22, 2015 at 08:35:54AM -0700, James Bottomley wrote:
> > On Wed, 2015-04-15 at 15:19 +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Apr 15, 2015 at 11:32:29AM +0000, Kweh, Hock Leong wrote:
> > > > > -----Original Message-----
> > > > > From: Greg Kroah-Hartman [mailto:gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org]
> > > > > Sent: Tuesday, April 14, 2015 10:09 PM
> > > > > 
> > > > > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> > > > > > + */
> > > > > > +static void __exit efi_capsule_loader_exit(void)
> > > > > > +{
> > > > > > +	platform_device_unregister(efi_capsule_pdev);
> > > > > 
> > > > > This is not a platform device, don't abuse that interface please.
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Okay, so you would recommend to use device_register() for this case?
> > > > Or you would think that this is more suitable to use class_register()?
> > > 
> > > A class isn't needed, you just want a device right?  So just use a
> > > device, but not a platform device, as that isn't what you have here.
> > 
> > Coming back to this, am I the only one confused here?  What is a
> > 'platform device' then?  Because if it doesn't fit a direct channel to
> > the platform firmware, which seems to be one of the definitions covered
> > in driver-model/platform.txt under devices with minimal infrastructure
> > then perhaps the documentation needs updating.
> 
> I don't remember the original code here at all, sorry.  I'm guessing
> that they were using a class, and a platform device together, which is
> not a good idea.  Just make a "virtual" device, as you don't need/want
> any of the platform device infrastructure here, you just wanted a device
> node and/or a way to show up in sysfs somewhere.

It was a platform device called efi_platform_loader and a single
attribute file in that device called  capsule_load.  I agree that if
we're going to use this for other things, we should probably have a uefi
directory somewhere (under firmware?) to collect everything together
rather than spraying random devices around.

> If you have some kind of "platform resource", then you can be a platform
> device, otherwise please don't use that api just because it seems simple
> to use.  Use the ones the driver core provides for you that really are
> just as simple (i.e. device_create()).

OK, so this is what I'm trying to understand.  Why isn't a pipe to
firmware for something a "platform resource"?  I think UEFI is in the
same class as ACPI which uses platform devices all over.

James
