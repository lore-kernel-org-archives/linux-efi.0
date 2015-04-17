From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Fri, 17 Apr 2015 15:50:16 +0200
Message-ID: <20150417135016.GC19794@kroah.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <CALCETrWeW8Gp9QFGCVhPmNo_Z+xsCJN7LYMPD6XNc92_dKMz3g@mail.gmail.com>
 <20150415132000.GD21491@kroah.com>
 <CALCETrWUTjTLmwPZAwXrj06SwYaSX_7+XSTsVun2+HYC4wsqZQ@mail.gmail.com>
 <CAFECyb-bthi74VwkF8fpZg8ZpoyORmE5X+8dbRGG1uTP8RUm_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb-bthi74VwkF8fpZg8ZpoyORmE5X+8dbRGG1uTP8RUm_A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 15, 2015 at 05:19:09PM -0700, Roy Franz wrote:
> On Wed, Apr 15, 2015 at 8:45 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> > On Apr 15, 2015 6:20 AM, "Greg Kroah-Hartman"
> > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >>
> >> On Tue, Apr 14, 2015 at 11:52:48AM -0400, Andy Lutomirski wrote:
> >> > On Tue, Apr 14, 2015 at 10:09 AM, Greg Kroah-Hartman
> >> > <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >> > > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> >> > >> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> > >>
> >> > >> Introducing a kernel module to expose capsule loader interface
> >> > >> for user to upload capsule binaries. This module leverage the
> >> > >> request_firmware_direct_full_path() to obtain the binary at a
> >> > >> specific path input by user.
> >> > >>
> >> > >> Example method to load the capsule binary:
> >> > >> echo -n "/path/to/capsule/binary" > /sys/devices/platform/efi_capsule_loader/capsule_loader
> >> > >
> >> > > Ick, why not just have the firmware file location present, and copy it
> >> > > to the sysfs file directly from userspace, instead of this two-step
> >> > > process?
> >> >
> >> > Because it's not at all obvious how error handling should work in that case.
> >>
> >> I don't understand how the error handling is any different.  The kernel
> >> ends up copying the data in through the firmware interface both ways, we
> >> just aren't creating yet-another-firmware-path in the system.
> >
> > If I run uefi-update-capsule foo.bin, I want it to complain if the
> > UEFI call fails.  In contrast, if I boot and my ath10k firmware is
> > bad, there's no explicit user interaction that should fail; instead I
> > have no network device and I get to read the logs and figure out why.
> > IOW bad volatile device firmware is just like a bad device driver,
> > whereas bad UEFI capsules are problems that should be reported to
> > whatever tried to send them to UEFI.
> >
> > --Andy
> >
> There are several types of errors that can be returned by
> UpdateCapsule(), allowing
> us to distinguish between capsules that are not supported by the
> platform, capsules
> that must be updated at boot time, and capsule updates that failed due
> to a device error.
> I think we really do want this type of information returned to capsule loader.

Ok, all of that sounds like you really want a character device, with an
ioctl, to do this.  Just use a misc device and your infrastructure will
be handled for you (sysfs, character device, etc.) and away you go.

thanks,

greg k-h
