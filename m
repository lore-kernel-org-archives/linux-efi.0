From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Fri, 6 Mar 2015 17:17:25 -0500
Message-ID: <20150306221724.GA15249@fenchurch.internal.datastacks.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com>
 <CAFECyb8oD+tjmwaR11PRZ_0K6ddYW5TE9+L1tVnMFE2yHHCg0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFECyb8oD+tjmwaR11PRZ_0K6ddYW5TE9+L1tVnMFE2yHHCg0A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Mar 06, 2015 at 01:49:20PM -0800, Roy Franz wrote:
> On Fri, Mar 6, 2015 at 1:39 PM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Tue, Feb 24, 2015 at 12:49:09PM +0000, Kweh, Hock Leong wrote:
> >> Hi All,
> >>
> >> After some internal discussion and re-design prototyping & testing on
> >> this efi capsule interface kernel module, I would like to start a discussion
> >> here on the new idea and wish to get input for the implementation and
> >> eventually upstream.
> >
> > So do we actually *need* a kernel interface to UpdateCapsule?  We've
> > already got an implementation in progress where we use my ESRT patch to
> > figure out what firmwares we can update, and we schedule them and do the
> > update during boot up before the normal bootloader is run.  That means
> > never having to call UpdateCapsule() after ExitBootServices() or
> > SetVirtualAddressMap() have been called, and only doing it across
> > reboots that UEFI is performing itself.  It also means never having to
> > do it with multiple CPUs running.
> 
> So this does it by writing the capsules to the EFI system partition, and having
> them processed from there during the next boot?
> How would this work on diskless systems? (or boot-disk-less systems)

One of the things I'm currently writing is making the file we load be
specified correctly by UEFI device paths - and that'll include the
ability to get it from devices presented by the network drivers.  On
currently extant test machines that includes tftp support, just like
netbooting.  On UEFI 2.5 machines, where ESRT is introduced so that we
actually know something about the capsules we can apply updates for, it
also includes http support.  Admittedly that means when you're doing
deployment you'll have to have some process for putting the images
someplace, but it can be the same device you're net-booting from.
Just one example.

If we're talking about systems that are booting entirely out of their
own firmware volume, there's definitely some legitimate argument that
doing this without an ESP could be valuable - so yeah, a kernel API in
that case might be worthwhile.

That said, the extra complexity combined with the fact that it's running
after ExitBootServices() and SetVirtualAddressMap() means I'll probably
avoid using it from the userland code except on machines where there are
no other options.  My faith that we're going to see a lot of machines
where that's well tested without our address maps looking exactly like
Windows's isn't very high, and we've repeatedly run into a lot of pain
with that in the past.  That's not the only thing that has to be exactly
right, either - for instance there's no guarantee it'll work if you use
the ACPI reset vector instead of the EFI runtime services
ResetSystem(EfiResetWarm) call.  Right now we use the ACPI method
preferentially because of SetVirtualAddressMap() not working as
documented on so *many* platforms.  That means what happens upon reboot
when we do UpdateCapsule() is undefined behavior.

Of course I'm likely not the only person who will ever implement tools
in userland to orchestrate firmware updates, either :)

> What are the use cases for capsules that don't require a reboot?  I'm
> not really clear uses for those, but the kernel interface could be
> better for those, as it would allow processing without a reboot.

I'm really not sure if we know the answer to that yet.  Things like USB
devices most often won't ever be registered with firmware's FMP anyway,
so they won't have capsules exposed, and they'll use more traditional
USB commands to do firmware updates - stuff like hughsie's ColorHug
device are in that category, and he's already supporting that with
fwupd.

Things like peripheral card option ROMs are potentially in that
category, though I'm a little skeptical of the idea that I actually want
to update the firmware on my video or network card with the kernel
already running, and that when I do I'm not going to want to reboot
immediately to make sure it worked right anyway.  There are almost
certainly lots of cases I haven't thought of, though.

If we want this interface for those cases, I think we should also be
enumerating the cases we think it's supporting, as well, even if only in
broad strokes.  I don't think we need to say "support this specific
device's updates", but keeping track of the basic model of the update
we're supporting would go a long way to establishing the value of
supporting all the complexity.

-- 
        Peter
