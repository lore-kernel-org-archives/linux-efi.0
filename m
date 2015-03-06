From: Andy Lutomirski <luto@amacapital.net>
Subject: RE: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Fri, 6 Mar 2015 11:05:00 -0800
Message-ID: <CALCETrW9w2AtHR7qs2zNphhcSDq8=Q=Vw4J-e4yOw87gWHSUbQ@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
 <20150302122955.GB24476@codeblueprint.co.uk> <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
 <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AF4F2@PGSMSX102.gar.corp.intel.com>
 <CALCETrWKwQVe46gASNbb0miwcuHe+wirVSO-pQt6uF-Jd6e-bw@mail.gmail.com> <F54AEECA5E2B9541821D670476DAE19C2B8AF8A2@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8AF8A2@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Matt Fleming <matt@console-pimps.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-efi@vger.kernel.org

On Mar 6, 2015 4:20 AM, "Kweh, Hock Leong" <hock.leong.kweh@intel.com> wrote:
>
> > -----Original Message-----
> > From: Andy Lutomirski [mailto:luto@amacapital.net]
> > Sent: Friday, March 06, 2015 7:09 AM
> >
> > On Mar 5, 2015 1:19 AM, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> > wrote:
> > >
> > > > > This really is not a big deal. User should cope with it.
> > > >
> > > > No, it's a big deal, and the user should not cope.
> > > >
> > > > The user *should not* be required to have write access to anything in
> > > > /lib to install a UEFI capsule that they download from their
> > > > motherboard vendor's website.  /lib belongs to the distro, and UEFI
> > > > capsules do not belong to the distro.  In this regard, UEFI capsules
> > > > are completely unlike your wireless card firmware, your cpu microcode,
> > > > etc.
> > > >
> > > > Imagine systems using NFS root, Atomic-style systems (e.g. ostree),
> > > > systems that boot off squashfs, etc.  They should still be able to
> > > > load capsules.  The basic user interface that should work is:
> > > >
> > > > # uefi-load-capsule /path/to/capsule
> > > >
> > > > or:
> > > >
> > > > # uefi-load-capsule - </path/to/capsule
> > > >
> > > > I don't really care how uefi-load-capsule is implemented, as long as
> > > > it's straightforward, because people will screw it up if it isn't
> > > > straightforward.
> > > >
> > > > Why is it so hard to have a file in sysfs that you write the capsule
> > > > to using *cat* (not echo) and that will return an error code if cat
> > > > fails?  Is it because you don't know where the end of the capsule is?
> > > > if so, ioctl is designed for exactly this purpose.
> > > >
> > > > TBH, I find this thread kind of ridiculous.  The problem that you're
> > > > trying to solve is extremely simple, the functionality that userspace
> > > > needs is trivial, and all of these complex proposals for how it should
> > > > work are an artifact of the fact that the kernel-internal interfaces
> > > > you're using for it are not well suited to the problem at hand.
> > > >
> > > > --Andy
> > >
> > > Sorry, I may not catch your point correctly. Are you trying to tell that
> > > a "normal" user can perform efi capsule update. But a "normal" user
> > > does not have the right to install or copy the capsule binary into
> > > "/lib/firmware/". So, there is a need to make this capsule module to
> > > allow uploading the capsule binary at any path or location other than
> > > "/lib/firmware/".
> > >
> > > Is this what you mean?
> >
> > No.  Only root should be able to load capsules, but even root may not
> > be able to write to /lib.
> >
> > --Andy
> >
>
> Okay, I accept that only root user can perform the load capsule. It is new
> to me that root user may not have the access right to "/lib/firmware".
>
> But I remember you do mention that CPU micro code and wifi firmware
> they are different and able to write in /lib/firmware. I am curious why
> efi capsule binary have such a restriction.  What is preventing it being
> write to that location?
>

It has to do with where the firmware comes from.  When someone
prepares Linux fs image, they put user code, a kernel (usually), all
modules that might be needed, and all firmware that's likely to be
needed into /.  This might come from the distro or a company-wide
image.

If a normal firmware firmware file needs an update, it's just like
updating a driver or a library -- / will be updated by whatever
mechanism is in use.

Nonvolatile firmware is different.  The update isn't needed on
subsequent boots, and it could be much less generic than a driver.
For example, a capsule could contain a boot splash screen image that
says "this is computer #27."  Updating the system image to do this
makes little sense.  Instead it'll be a one-time thing done by root.

--Andy

> I even went to check out the FHS:
> http://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard
> I do not find any restriction calling out for that.
>
> Would you mind to educate me on that?
> Thanks.
>
>
> Regards,
> Wilson
>
