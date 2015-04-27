From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Mon, 27 Apr 2015 15:35:36 -0700
Message-ID: <1430174136.2314.49.camel@HansenPartnership.com>
References: <20150415131906.GC21491@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
	 <20150417134924.GB19794@kroah.com>
	 <20150417143640.GB3671@codeblueprint.co.uk>
	 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
	 <20150420144323.GA7261@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
	 <20150421075620.GA11000@kroah.com>
	 <1429665679.2207.44.camel@HansenPartnership.com>
	 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
	 <20150422132734.GB12062@redhat.com>
	 <1429715913.2195.22.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
	 <1429798187.2170.3.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC12798@PGSMSX102.gar.corp.intel.com>
	 <1429888575.2182.20.camel@HansenPartnership.com>
	 <CALCETrU2G10uGvdB6kVyfMPA=biuZwK7BAeqmKuY=jvN38K2wA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU2G10uGvdB6kVyfMPA=biuZwK7BAeqmKuY=jvN38K2wA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2015-04-27 at 14:59 -0700, Andy Lutomirski wrote:
> On Fri, Apr 24, 2015 at 8:16 AM, James Bottomley
> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> > On Fri, 2015-04-24 at 02:14 +0000, Kweh, Hock Leong wrote:
> >> > -----Original Message-----
> >> > From: James Bottomley [mailto:James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org]
> >> > Sent: Thursday, April 23, 2015 10:10 PM
> >> >
> >> > On Thu, 2015-04-23 at 08:30 +0000, Kweh, Hock Leong wrote:
> >> > > > -----Original Message-----
> >> > > > From: James Bottomley
> >> > [mailto:James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org]
> >> > > > Sent: Wednesday, April 22, 2015 11:19 PM
> >> > > >
> >> > > >
> >> > > > Yes, I think we've all agreed we can do it ... it's now a question of whether
> >> > we
> >> > > > can stomach the ick factor of actually initiating a transaction in close ... I'm
> >> > still
> >> > > > feeling queasy.
> >> > >
> >> > > The file "close" here can I understand that the file system will call the
> >> > "release"
> >> > > function at the file_operations struct?
> >> > > http://lxr.free-electrons.com/source/include/linux/fs.h#L1538
> >> > >
> >> > > So, James you are meaning that we could initiating the update transaction
> >> > > inside the f_ops->release() and return the error code if update failed in this
> >> > > function?
> >> >
> >> > Well, that's what I was thinking.  However the return value of ->release
> >> > doesn't get propagated in sys_close (or indeed anywhere ... no idea why
> >> > it returns an int) thanks to the task work additions, so we'd actually
> >> > have to use the operation whose value is propagated in sys_close() which
> >> > turns out to be flush.
> >> >
> >> > James
> >> >
> >>
> >> Okay, I think I got you. Just to double check for in case: you are meaning
> >> to implement it at f_ops->flush() instead of f_ops->release().
> >
> > Well, what I'm saying is that the only way to propagate an error to
> > close is by returning one from the flush file_operation.
> >
> > Let's cc fsdevel to see if they have any brighter ideas.
> >
> > The problem is we need to update firmware (several megabytes of it) via
> > standard system tools.  We're thinking cat to a device.  The problem is
> > that we need an error code back once the update goes through (which it
> > can't until we've fed all the firmware data into the system).  To use
> > standard unix tools, we have to trigger off the standard system calls
> > cat uses and since write() will happen in chunks, the only way to commit
> > the transaction is in close().
> >
> > We initially through of initiating the transaction in f_ops->release and
> > returning the error code there, but that doesn't work because its value
> > isn't actually propagated, so we're now thinking of initiating the
> > transaction in f_ops->flush instead (this is a device, not a file, so it
> > won't get any other flushers).  Are there any other ways for us to
> > propagate error on close?
> >
> 
> I think we may end up wanting to support both UpdateCapsule and
> QueryCapsuleCapabilities, in which case this gets awkward.  Maybe we
> really should do a misc device + ioctl.

To be honest, I hate ioctls ... especially the "have to use special
tools" part.

Would we ever want to support QueryCapsuleUpdate()?  The return codes on
error are the same as UpdateCapsule() but the query call does nothing on
success (and the update call updates, obviously), so it seems a bit
pointless if someone's gone to the trouble of getting a capsule ... they
obviously want to apply it rather than know if it could be applied.

Assuming we do, we could just use the same error on close mechanism, but
use sysfs binary attributes ... or probably something new like a binary
transaction attribute that does all the transaction on close magic for
us.

James
