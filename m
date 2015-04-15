From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 1/2] firmware_loader: introduce new API -
 request_firmware_direct_full_path()
Date: Wed, 15 Apr 2015 15:15:51 +0200
Message-ID: <20150415131551.GB21491@kroah.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-2-git-send-email-hock.leong.kweh@intel.com>
 <20150414140806.GD5989@kroah.com>
 <CALCETrW_aXJ1iiXCa6aTE3r3J3EF_Njn5bb9=At_3ajCzPFSPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW_aXJ1iiXCa6aTE3r3J3EF_Njn5bb9=At_3ajCzPFSPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 14, 2015 at 11:56:26AM -0400, Andy Lutomirski wrote:
> On Tue, Apr 14, 2015 at 10:08 AM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Tue, Apr 14, 2015 at 05:44:55PM +0800, Kweh, Hock Leong wrote:
> >> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >> Introduce this new API for loading firmware from a specific location
> >> instead of /lib/firmware/ by providing a full path to the firmware
> >> file.
> >
> > Ick, why would we want this?
> >
> 
> Because this mechanism should still work even if /lib is unwriteable
> (e.g it's on squashfs or a read-only NFS root).

Why would a filesystem need to be writable to read a firmware blob from?

> In this regard, UEFI capsules are very much unlike firmware_class
> firmware.  firmware_class firmwise is kind of like device drivers; it
> generally comes from the same vendor as your kernel image and
> /lib/modules, and it can be updated by the same mechanism.  UEFI
> capsules, on the other hand, are one-time things that should be loaded
> at the explicit request of the admin.

Just like BIOS updates, which use the firmware interface.

> There is no reason whatsoever
> that they should exist on persistent storage, and, in fact, there's a
> very good reason that they should not.  On little embedded devices,
> which will apparently be the initial users of this code, keeping the
> capsules around is a waste of valuable space.
> 
> This is why I think that the right approach would be to avoid using
> firmware_class entirely for this.  IMO a simple_char device would be
> the way to go (hint hint...) but other simple approaches are certainly
> possible.

A char device would be present all the time, like a sysfs file to write
the firmware to, so I don't see the difference here.  For a char device,
you would just do the normal open/write/close, just like for the
firmware interface, what is the difference?

thanks,

greg k-h
