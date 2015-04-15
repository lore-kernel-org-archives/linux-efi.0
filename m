From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 1/2] firmware_loader: introduce new API - request_firmware_direct_full_path()
Date: Wed, 15 Apr 2015 08:53:19 -0700
Message-ID: <CALCETrW87_K_wj-Es2hNs4MEEjVFnpXewo0A6nWV-LwcBJEo6A@mail.gmail.com>
References: <1429004697-28320-1-git-send-email-hock.leong.kweh@intel.com>
 <1429004697-28320-2-git-send-email-hock.leong.kweh@intel.com>
 <20150414140806.GD5989@kroah.com> <CALCETrW_aXJ1iiXCa6aTE3r3J3EF_Njn5bb9=At_3ajCzPFSPg@mail.gmail.com>
 <20150415131551.GB21491@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150415131551.GB21491@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Ming Lei <ming.lei@canonical.com>, Matt Fleming <matt@console-pimps.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

[Bah, I'm really bad at email today.  Trying again.]

On Apr 15, 2015 6:15 AM, "Greg Kroah-Hartman"
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 14, 2015 at 11:56:26AM -0400, Andy Lutomirski wrote:
> > On Tue, Apr 14, 2015 at 10:08 AM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > On Tue, Apr 14, 2015 at 05:44:55PM +0800, Kweh, Hock Leong wrote:
> > >> From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> > >>
> > >> Introduce this new API for loading firmware from a specific location
> > >> instead of /lib/firmware/ by providing a full path to the firmware
> > >> file.
> > >
> > > Ick, why would we want this?
> > >
> >
> > Because this mechanism should still work even if /lib is unwriteable
> > (e.g it's on squashfs or a read-only NFS root).
>
> Why would a filesystem need to be writable to read a firmware blob from?

Because someone would need to temporarily put the image there.  In
practice, these blobs will come from vendors, signed, online using
ESRT magic.

Imagine a CoreOS system.  When a UEFI update needed on 1% of a
deployment's metal is published, no one is going to want to push out a
new core CoreOS image.  Instead they'll want to run the update on that
1% of nodes and be done with it.

To be fair, and for those that didn't follow all the various
discussions, it's unclear that this mechanism will ever be useful in
the x86 server space.  There's some reason to believe that MS will
only issue UpdateCapsule before ExitBootServices and that firmware
vendors will therefore disallow UpdateCapsule after ExitBootServices.
The fwupd crowd is (I think) planning on bypassing this entirely and
using the boot loader to update firmware.

Regardless, those things aren't going to live in /lib, but they'll
have to write *something* to a FAT filesystem because they have no
choice.  More sensible firmwares will support the runtime stuff, and
atomic systems (RHEL Atomic, OSTree, CoreOS, whatever Docker's working
on, whatever Sandstorm is working on (?), etc.) should probably be as
well supported in the kernel as we can manage.

>
> > In this regard, UEFI capsules are very much unlike firmware_class
> > firmware.  firmware_class firmwise is kind of like device drivers; it
> > generally comes from the same vendor as your kernel image and
> > /lib/modules, and it can be updated by the same mechanism.  UEFI
> > capsules, on the other hand, are one-time things that should be loaded
> > at the explicit request of the admin.
>
> Just like BIOS updates, which use the firmware interface.

What BIOS updates?  There's flashrom, which quite sensibly reads its
input in user space.

The other example I found is dell_rbu, which does a complicated
packetized update thing and explicitly says in the docs:  "This method
makes sure that all the packets get to the driver in a single
operation."  The mechanism seems quite awkward to me.

>
> > There is no reason whatsoever
> > that they should exist on persistent storage, and, in fact, there's a
> > very good reason that they should not.  On little embedded devices,
> > which will apparently be the initial users of this code, keeping the
> > capsules around is a waste of valuable space.
> >
> > This is why I think that the right approach would be to avoid using
> > firmware_class entirely for this.  IMO a simple_char device would be
> > the way to go (hint hint...) but other simple approaches are certainly
> > possible.
>
> A char device would be present all the time, like a sysfs file to write
> the firmware to, so I don't see the difference here.  For a char device,
> you would just do the normal open/write/close, just like for the
> firmware interface, what is the difference?

You wouldn't use open/write/close; you'd do it atomically with a
single ioctl.  That gives userspace an error code.

It would also be possible to require a single write(2) call, but that
seems to defeat most of the purpose of using open/write/close (namely
the ability to script it with cat).

--Andy
