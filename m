From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: RE: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Thu, 5 Mar 2015 15:08:42 -0800
Message-ID: <CALCETrWKwQVe46gASNbb0miwcuHe+wirVSO-pQt6uF-Jd6e-bw@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
 <20150302122955.GB24476@codeblueprint.co.uk> <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
 <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com> <F54AEECA5E2B9541821D670476DAE19C2B8AF4F2@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B8AF4F2-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mar 5, 2015 1:19 AM, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
> > -----Original Message-----
> > From: Andy Lutomirski [mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org]
> > Sent: Wednesday, March 04, 2015 4:38 AM
> >
> > On Mon, Mar 2, 2015 at 9:56 PM, Kweh, Hock Leong
> > <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > Just to call out that using firmware class auto locate binary feature is limited
> > > to locations:
> > > - "/lib/firmware/updates/" UTS_RELEASE,
> > > - "/lib/firmware/updates",
> > > - "/lib/firmware/" UTS_RELEASE,
> > > - "/lib/firmware"
> > > and one custom path which inputted during firmware_class module load
> > > time or kernel boot up time.
> > >
> > > It is just not like the user helper interface which allow load the binary at
> > > any path/location.
> > >
> > > This really is not a big deal. User should cope with it.
> >
> > No, it's a big deal, and the user should not cope.
> >
> > The user *should not* be required to have write access to anything in
> > /lib to install a UEFI capsule that they download from their
> > motherboard vendor's website.  /lib belongs to the distro, and UEFI
> > capsules do not belong to the distro.  In this regard, UEFI capsules
> > are completely unlike your wireless card firmware, your cpu microcode,
> > etc.
> >
> > Imagine systems using NFS root, Atomic-style systems (e.g. ostree),
> > systems that boot off squashfs, etc.  They should still be able to
> > load capsules.  The basic user interface that should work is:
> >
> > # uefi-load-capsule /path/to/capsule
> >
> > or:
> >
> > # uefi-load-capsule - </path/to/capsule
> >
> > I don't really care how uefi-load-capsule is implemented, as long as
> > it's straightforward, because people will screw it up if it isn't
> > straightforward.
> >
> > Why is it so hard to have a file in sysfs that you write the capsule
> > to using *cat* (not echo) and that will return an error code if cat
> > fails?  Is it because you don't know where the end of the capsule is?
> > if so, ioctl is designed for exactly this purpose.
> >
> > TBH, I find this thread kind of ridiculous.  The problem that you're
> > trying to solve is extremely simple, the functionality that userspace
> > needs is trivial, and all of these complex proposals for how it should
> > work are an artifact of the fact that the kernel-internal interfaces
> > you're using for it are not well suited to the problem at hand.
> >
> > --Andy
>
> Sorry, I may not catch your point correctly. Are you trying to tell that
> a "normal" user can perform efi capsule update. But a "normal" user
> does not have the right to install or copy the capsule binary into
> "/lib/firmware/". So, there is a need to make this capsule module to
> allow uploading the capsule binary at any path or location other than
> "/lib/firmware/".
>
> Is this what you mean?

No.  Only root should be able to load capsules, but even root may not
be able to write to /lib.

--Andy

>
>
> Regards,
> Wilson
