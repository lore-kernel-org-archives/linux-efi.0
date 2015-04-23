From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Thu, 23 Apr 2015 22:38:26 +0200
Message-ID: <20150423203826.GE15251@kroah.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8D2AEA@PGSMSX102.gar.corp.intel.com>
 <20150415131906.GC21491@kroah.com>
 <1429716954.2195.28.camel@HansenPartnership.com>
 <20150422154620.GA32576@kroah.com>
 <1429719077.2195.37.camel@HansenPartnership.com>
 <20150423095022.GA21126@kroah.com>
 <1429805658.6624.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1429805658.6624.2.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 23, 2015 at 09:14:18AM -0700, James Bottomley wrote:
> > > OK, so this is what I'm trying to understand.  Why isn't a pipe to
> > > firmware for something a "platform resource"?  I think UEFI is in the
> > > same class as ACPI which uses platform devices all over.
> > 
> > And I hate the fact that ACPI did that, but that ship has sailed a long
> > time ago.  It "should" have been it's own bus and device type, but oh
> > well.
> > 
> > For a "simple" bus-less device, that has no platform resources needed
> > (i.e from acpi or device tree), so you don't need the infrastructure
> > from the platform core, just use a simple device_create() call, that's
> > what it is there for.
> 
> That's not confusing: ACPI shouldn't be a platform device, but something
> that is should have a platform resource provided by ACPI (or device tree).
> 
> So I think the problem is that the documentation is wrong?  Platform
> device isn't for "platform resources" like you said initially?
> 
> Or do we have a more fundamental problem: You don't use the word
> "platform" the same way we do?  A "platform" to most people on this
> thread is something designed to be delivered with the box that's not
> amenable to user modification.  That's why we think of UEFI (and ACPI)
> as platform technologies: they come with the box (often they were
> specially crafted for it) and we use their services to discover stuff
> and correctly configure the OS.  In this definition, almost everything
> we do via UEFI manipulates "platform resources".

Maybe we aren't using the word "platform" the same way.

Platform devices were originally created to handle all of the "cruft"
that a system has that used to be only at fixed locations on the
CPU/chipset, and were not on any real "bus".  Things like timers,
keyboard controllers, and all of the odd embedded things that we just
"knew" where in memory they were located.

Then we got platform data structures, to help know "where" in memory
devices were to be able to write to, and board files interacted with
them that way.

Because of this, and how they were just so easy to create, lots of
developers were "lazy" and just put a platform device into their driver
instead of having to hook it up to an existing system, or actually write
a bus for it (I had an Intel laptop that shipped 1 year ago come with a
driver that used a platform device instead of a "real" i2c device like
the touchpad really was.

Then came device tree, which leveraged platform devices because that's
what they needed to control (replacing the board files.)  Somewhere in
there ACPI also decided to use platform devices and it makes sense now,
as drivers just need to get a resource as to how to talk to the
hardware, and it doesn't matter if it comes from ACPI or device tree.

But for devices that are just "virtual", like this firmware loader, use
the virtual bus, which happens automatically when you don't provide a
parent to device_create().  That's what it is there for, your device
doesn't have to deal with any "resources" that it needs to read from
board files, device tree, or acpi, so it shouldn't be a platform device.

Hope that helps explain things better.

thanks,

greg k-h
