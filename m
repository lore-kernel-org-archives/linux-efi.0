From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Mon, 16 Mar 2015 08:35:29 -0700
Message-ID: <CALCETrVovfe0ivru52KUdWOhwLnPAa=ANYrXBGJ3Z+4zLf=YLg@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com> <20150310122652.GA17573@codeblueprint.co.uk>
 <20150310152155.GB1208@fenchurch.internal.datastacks.com> <CALCETrXMvDqMvRf2yzRvpjHQB5pip5zNiihAccCc9Sm5UWGysg@mail.gmail.com>
 <20150310154000.GD1208@fenchurch.internal.datastacks.com> <CALCETrUDuTt_BK1JSFU=_EEujpm1ekzmkte-c3vxuRW7hWPUPQ@mail.gmail.com>
 <20150312224754.GD24174@codeblueprint.co.uk> <20150313144213.GA19009@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150313144213.GA19009@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ong Boon Leong <boon.leong.ong@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, LKML <linux-kernel@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-efi@vger.kernel.org

On Mar 13, 2015 7:42 AM, "Greg Kroah-Hartman"
<gregkh@linuxfoundation.org> wrote:
>
> On Thu, Mar 12, 2015 at 10:47:54PM +0000, Matt Fleming wrote:
> > On Tue, 10 Mar, at 08:51:59AM, Andy Lutomirski wrote:
> > >
> > > I'm not 100% happy with write(2) (which is all we have in sysfs) for
> > > two reasons:
> > >
> > > 1. If we write a file name, eww.  That's more complicated, requires
> > > temporary files, has annoying mount namespace issues, etc.
> > >
> > > 2. If we write the full contents, we need to do it in a single call to
> > > write.  That means that we can't use cat, which mostly defeats the
> > > purpose.  In fact, using cat could be actively harmful.
> >
> > At this point I'd really like Greg to chime in.
> >
> > In principal, I'm not stricly opposed to using a simple char device
> > provided that it's not essentially a copy and paste of code from
> > drivers/base/firmware_class.c.
> >
> > Greg?
>
> Yes, I don't want a character driver here for this if at all possible.
> Just stick with the firmware download code, it's there and should work
> "as-is" for your stuff.

Given the rest of this interminable discussion, it seems pretty clear
to me that the firmware download code doesn't work as is for this use
case.  It will sort of work with lots of changes (to locking,
synchronicity, error reporting, enumeration, etc), but I think that
the total complexity of doing that will far exceed the complexity if
either a new chardev or some straightforward sysfs interface.

We don't have ioctls in sysfs, though, and adding that sounds worse
than a new character driver, so...

--Andy

>
> thanks,
>
> greg k-h
