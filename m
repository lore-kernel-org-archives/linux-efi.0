From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi firmware
Date: Wed, 29 Apr 2015 11:40:54 -0700
Message-ID: <CALCETrXBFBqwZ=A+zoC5Lj0Zr2_2hEkSBX0hrLZJRjyDWqjucA@mail.gmail.com>
References: <20150415131906.GC21491@kroah.com> <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
 <20150417134924.GB19794@kroah.com> <20150417143640.GB3671@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
 <20150420144323.GA7261@kroah.com> <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
 <20150421075620.GA11000@kroah.com> <1429665679.2207.44.camel@HansenPartnership.com>
 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
 <20150422132734.GB12062@redhat.com> <1429715913.2195.22.camel@HansenPartnership.com>
 <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
 <1429798187.2170.3.camel@HansenPartnership.com> <F54AEECA5E2B9541821D670476DAE19C2CC12798@PGSMSX102.gar.corp.intel.com>
 <1429888575.2182.20.camel@HansenPartnership.com> <CALCETrU2G10uGvdB6kVyfMPA=biuZwK7BAeqmKuY=jvN38K2wA@mail.gmail.com>
 <1430174136.2314.49.camel@HansenPartnership.com> <CALCETrXeh+y1XZrdDyhEmy+GK6z7-swZNPYGZybnqzppWAE+Wg@mail.gmail.com>
 <1430175112.2314.56.camel@HansenPartnership.com> <F54AEECA5E2B9541821D670476DAE19C2CC13F37@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2CC13F37@PGSMSX102.gar.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Peter Jones <pjones@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ming Lei <ming.lei@canonical.com>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 29, 2015 at 4:23 AM, Kweh, Hock Leong
<hock.leong.kweh@intel.com> wrote:
>> -----Original Message-----
>> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
>> Sent: Tuesday, April 28, 2015 6:52 AM
>>
>> On Mon, 2015-04-27 at 15:40 -0700, Andy Lutomirski wrote:
>> > On Mon, Apr 27, 2015 at 3:35 PM, James Bottomley
>> > <James.Bottomley@hansenpartnership.com> wrote:
>> > > On Mon, 2015-04-27 at 14:59 -0700, Andy Lutomirski wrote:
>> > >> On Fri, Apr 24, 2015 at 8:16 AM, James Bottomley
>> > >> <James.Bottomley@hansenpartnership.com> wrote:
>> > >> > On Fri, 2015-04-24 at 02:14 +0000, Kweh, Hock Leong wrote:
>> > >> >> > -----Original Message-----
>> > >> >> > From: James Bottomley
>> > >> >> > [mailto:James.Bottomley@HansenPartnership.com]
>> > >> >> > Sent: Thursday, April 23, 2015 10:10 PM
>> > >> >> >
>> > >> >> > On Thu, 2015-04-23 at 08:30 +0000, Kweh, Hock Leong wrote:
>> > >> >> > > > -----Original Message-----
>> > >> >> > > > From: James Bottomley
>> > >> >> > [mailto:James.Bottomley@HansenPartnership.com]
>> > >> >> > > > Sent: Wednesday, April 22, 2015 11:19 PM
>> > >> >> > > >
>> > >> >> > > >
>> > >> >> > > > Yes, I think we've all agreed we can do it ... it's now a
>> > >> >> > > > question of whether
>> > >> >> > we
>> > >> >> > > > can stomach the ick factor of actually initiating a
>> > >> >> > > > transaction in close ... I'm
>> > >> >> > still
>> > >> >> > > > feeling queasy.
>> > >> >> > >
>> > >> >> > > The file "close" here can I understand that the file system
>> > >> >> > > will call the
>> > >> >> > "release"
>> > >> >> > > function at the file_operations struct?
>> > >> >> > > http://lxr.free-electrons.com/source/include/linux/fs.h#L153
>> > >> >> > > 8
>> > >> >> > >
>> > >> >> > > So, James you are meaning that we could initiating the
>> > >> >> > > update transaction inside the f_ops->release() and return
>> > >> >> > > the error code if update failed in this function?
>> > >> >> >
>> > >> >> > Well, that's what I was thinking.  However the return value of
>> > >> >> > ->release doesn't get propagated in sys_close (or indeed
>> > >> >> > anywhere ... no idea why it returns an int) thanks to the task
>> > >> >> > work additions, so we'd actually have to use the operation
>> > >> >> > whose value is propagated in sys_close() which turns out to be
>> flush.
>> > >> >> >
>> > >> >> > James
>> > >> >> >
>> > >> >>
>> > >> >> Okay, I think I got you. Just to double check for in case: you
>> > >> >> are meaning to implement it at f_ops->flush() instead of f_ops-
>> >release().
>> > >> >
>> > >> > Well, what I'm saying is that the only way to propagate an error
>> > >> > to close is by returning one from the flush file_operation.
>> > >> >
>> > >> > Let's cc fsdevel to see if they have any brighter ideas.
>> > >> >
>> > >> > The problem is we need to update firmware (several megabytes of
>> > >> > it) via standard system tools.  We're thinking cat to a device.
>> > >> > The problem is that we need an error code back once the update
>> > >> > goes through (which it can't until we've fed all the firmware
>> > >> > data into the system).  To use standard unix tools, we have to
>> > >> > trigger off the standard system calls cat uses and since write()
>> > >> > will happen in chunks, the only way to commit the transaction is in
>> close().
>> > >> >
>> > >> > We initially through of initiating the transaction in
>> > >> > f_ops->release and returning the error code there, but that
>> > >> > doesn't work because its value isn't actually propagated, so
>> > >> > we're now thinking of initiating the transaction in f_ops->flush
>> > >> > instead (this is a device, not a file, so it won't get any other
>> > >> > flushers).  Are there any other ways for us to propagate error on close?
>> > >> >
>> > >>
>> > >> I think we may end up wanting to support both UpdateCapsule and
>> > >> QueryCapsuleCapabilities, in which case this gets awkward.  Maybe
>> > >> we really should do a misc device + ioctl.
>> > >
>> > > To be honest, I hate ioctls ... especially the "have to use special
>> > > tools" part.
>> > >
>> > > Would we ever want to support QueryCapsuleUpdate()?  The return
>> > > codes on error are the same as UpdateCapsule() but the query call
>> > > does nothing on success (and the update call updates, obviously), so
>> > > it seems a bit pointless if someone's gone to the trouble of getting
>> > > a capsule ... they obviously want to apply it rather than know if it could be
>> applied.
>> >
>> > I can imagine a UI that would try to validate a transaction consisting
>> > of several of these things, tell the user whether it'll work and
>> > whether a reboot is needed, and then do it.
>>
>> You mean for dependent capsules?  That's a bit way overthinking the UEFI
>> current use case (which is for firmware update).  In theory, the persist across
>> reboot flag can be used for OS persistent information (subject to someone
>> actually coming up with an implementation).  I'd code for the simple case:
>> firmware update and let the rest take care of itself if and when we have an
>> implementation.
>>
>> The last thing I want to see landing on the UEFI-SST is some hopelessly
>> complex and nasty capsule spec just "because Linux implements it this way".
>>
>> > > Assuming we do, we could just use the same error on close mechanism,
>> > > but use sysfs binary attributes ... or probably something new like a
>> > > binary transaction attribute that does all the transaction on close
>> > > magic for us.
>> >
>> > Yeah, but now we have both input and output, so as ugly as ioctl is,
>> > it's a pretty good match.
>>
>> No, we'll have read and write, so we can do that.  As long as there's no
>> transaction that can't complete in close or any sense of multiple transactions
>> that aren't issued by open read/write close, we're covered.
>>
>> > Sigh.  This is all more complicated than it deserves to me.
>>
>> Be fair: it is a new interface and it works in a way that's just different enough
>> from regular firmware to cause all this bother.
>>
>> James
>>
>
> Dear communities,
>
> I agree with James. Due to different people may have different needs. But
> from our side, we would just like to have a simple interface for us to upload
> the efi capsule and perform update. We do not have any use case or need
> to get info from QueryCapsuleUpdate(). Let me give a suggestion here:
> please allow me to focus on deliver this simple loading interface and
> upstream it. Then later whoever has the actual use case or needs on the ioctl
> implementation, he or she could enhance base on this simple loading interface.
> What do you guys think?
>
> Let me summarize the latest design idea:
> - No longer leverage on firmware class but use misc device
> - Do not use platform device but use device_create()
> - User just need to perform "cat file.bin > /sys/.../capsule_loader" in the shell

If you do this, there's no need for the misc device.

> - File operation functions include: open(), read(), write() and flush()
> - Perform mutex lock in open() then release the mutex in flush() for avoiding
>    race condition / concurrent loading

Make sure the mutex operation is killable, then, and maybe even interruptable.

> - Perform the capsule update and error return at flush() function
>
> Is there anything I missed? Any one still have concern with this idea?
> Thanks for providing the ideas as well as the review.
>

If it works (and cat really does fail reliably), then it seems okay to me.

However, since I like pulling increasing numbers of my hats, someone
should verify that the common embedded cat implementations are also
okay with this.  For example, I haven't yet found any code in
busybox's cat implementation that closes stdout.

Given that the main targets of this (for now, at least) are embedded,
this might be a problem.

--Andy
