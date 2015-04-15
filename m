From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 15 Apr 2015 15:20:00 +0200
Message-ID: <20150415132000.GD21491@kroah.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-3-git-send-email-hock.leong.kweh@intel.com>
 <20150414140914.GE5989@kroah.com>
 <CALCETrWeW8Gp9QFGCVhPmNo_Z+xsCJN7LYMPD6XNc92_dKMz3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrWeW8Gp9QFGCVhPmNo_Z+xsCJN7LYMPD6XNc92_dKMz3g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 14, 2015 at 11:52:48AM -0400, Andy Lutomirski wrote:
> On Tue, Apr 14, 2015 at 10:09 AM, Greg Kroah-Hartman
> <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> > On Tue, Apr 14, 2015 at 05:44:56PM +0800, Kweh, Hock Leong wrote:
> >> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >>
> >> Introducing a kernel module to expose capsule loader interface
> >> for user to upload capsule binaries. This module leverage the
> >> request_firmware_direct_full_path() to obtain the binary at a
> >> specific path input by user.
> >>
> >> Example method to load the capsule binary:
> >> echo -n "/path/to/capsule/binary" > /sys/devices/platform/efi_capsule_loader/capsule_loader
> >
> > Ick, why not just have the firmware file location present, and copy it
> > to the sysfs file directly from userspace, instead of this two-step
> > process?
> 
> Because it's not at all obvious how error handling should work in that case.

I don't understand how the error handling is any different.  The kernel
ends up copying the data in through the firmware interface both ways, we
just aren't creating yet-another-firmware-path in the system.

thanks,

greg k-h
