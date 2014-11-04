From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 4 Nov 2014 07:40:17 -0800
Message-ID: <20141104154017.GA28113@kroah.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com>
 <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 04, 2014 at 06:57:21AM -0800, Andy Lutomirski wrote:
> On Nov 4, 2014 6:18 AM, "Matt Fleming" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Mon, 2014-11-03 at 22:32 -0800, Andy Lutomirski wrote:
> > >
> > > It seems like a large fraction of the code in this module exists just
> > > to work around the fact that request_firmware doesn't do what you want
> > > it to do.  You have code to:
> > >
> > >  - Prevent the /lib/firmware mechanism from working.
> > >  - Avoid a deadlock by doing strange things in the unload code.
> > >  - Allow more than one capsule per module load.  (Isn't this hard to
> > > use?  User code will have to wait for the next firmware request before
> > > sending a second capsule.)
> 
> I think that the firmware directory goes away and comes back.  Try cd
> /sys/firmware/efi-capsule-file and upload one capsule.  I bet that ls
> will show an empty directory.
> 
> > >
> > > All of this is for dubious gain.  You have to do three separate opens
> > > in sysfs to upload a capsule, and there's no way to report back to
> > > userspace whether the EFI call worked and whether a reboot is needed.
> >
> > Whether or not a reboot is required is indicated in the capsule image
> > itself, i.e. the capsule tells the firmware whether an immediate reboot
> > is required not the other way around.
> >
> > The firmware does tell the kernel what *kind* of a reboot is required,
> > but that doesn't need reporting to userspace.
> >
> > > What's the benefit of using the firmware interface here?
> >
> > I originally implemented something to send capsules to the firmware via
> > sysfs files back in 2013 and I basically ended up duplicating 25% of the
> > code that's already in drivers/base/firmware_class.c.
> >
> > If you're objecting to the lack of modularity in firmware_class.c, then
> > we could probably carve up the functionality we require a little more
> > neatly (like not having to do the /lib/firmware avoidance hacks), but
> > firmware_class.c should definitely be used as the foundation.
> >
> 
> I don't particularly care what the foundation is, but given that a
> misc char device currently looks like it would be considerably less
> code for a nicer interface, using the firmware class in its current
> state doesn't look so great.

Then fix the firmware class code.

Please, don't create random /dev nodes for firmware images like this,
use the firmware code, that is what it is there for, and it is correct
to use it for this type of interface.

> If I were to write user code for this, I'd really want a single
> transaction that uploads a capsule and gets a success/failure
> indication.  Using ioctl or a single big write sound fine.

That's what you are using with the firmware interface, so this patch is
currect.

> Basically, I agree that EFI capsules are firmware, and using the
> "firmware" mechanism makes logical sense.  But the firmware class is
> designed for kernel drivers that request firmware, user code that just
> blindly supplies an existing file, user code that doesn't care at all
> whether the firmware loaded correctly (because, for many drivers,
> there is probably no synchronous way to figure out whether the upload
> worked anyway), and firmware loading being idempotent.
> 
> For EFI capsules and other flash-my-device mechanisms, we want user
> code to send firmware independently of any driver request, user code
> to actively think about what it wants to send, user code to find out
> what happened as a result of the request, and user code to actively
> think about whether it should send another update.
> 
> If someone wants to make firmware_class work very nicely for this
> interface, that sounds great.  I'd recommend using a non-overlapping
> set of filenames in the sysfs directory to avoid confusing existing
> tools, especially since it's not obvious to be that the kernel has any
> way at all to detect that what it thinks is an intentional capsule
> load request is actually an old version of udev mindlessly responding
> to a firmware loading request (via udevadm trigger if nothing else).
> I kind of suspect that it will end up sharing very little code with
> the normal firmware mechanism, though.
> 
> This thing really does sound like it'll be 20-30 lines of code *total*
> using a misc device, and the earlier patches in the series could
> possibly be dropped entirely.

I don't want to see the misc interface used for this, sorry you don't
like it, but I feel the firmware interface is correct.

greg k-h
