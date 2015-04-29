From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi firmware
Date: Wed, 29 Apr 2015 14:42:12 -0700
Message-ID: <CALCETrWZvShC189cJVBGXQeUqBrhWpj641ByN46y3wv2c7MmuA@mail.gmail.com>
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
 <1430343304.2189.25.camel@HansenPartnership.com> <CALCETrVYYxGb64D3fFYRazJLAdHtMquQSvcAH0e5goNMVehaEw@mail.gmail.com>
 <1430343554.2189.30.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430343554.2189.30.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Peter Jones <pjones@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ming Lei <ming.lei@canonical.com>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Sam Protsenko <semen.protsenko@linaro.org>, Roy Franz <roy.franz@linaro.org>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS Devel <linux-fsdevel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 29, 2015 at 2:39 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2015-04-29 at 14:36 -0700, Andy Lutomirski wrote:
>> On Wed, Apr 29, 2015 at 2:35 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Wed, 2015-04-29 at 11:23 +0000, Kweh, Hock Leong wrote:
>> >> I agree with James. Due to different people may have different needs. But
>> >> from our side, we would just like to have a simple interface for us to upload
>> >> the efi capsule and perform update. We do not have any use case or need
>> >> to get info from QueryCapsuleUpdate(). Let me give a suggestion here:
>> >> please allow me to focus on deliver this simple loading interface and
>> >> upstream it. Then later whoever has the actual use case or needs on the ioctl
>> >> implementation, he or she could enhance base on this simple loading interface.
>> >> What do you guys think?
>> >>
>> >> Let me summarize the latest design idea:
>> >> - No longer leverage on firmware class but use misc device
>> >> - Do not use platform device but use device_create()
>> >> - User just need to perform "cat file.bin > /sys/.../capsule_loader" in the shell
>> >> - File operation functions include: open(), read(), write() and flush()
>> >> - Perform mutex lock in open() then release the mutex in flush() for avoiding
>> >>    race condition / concurrent loading
>> >> - Perform the capsule update and error return at flush() function
>> >>
>> >> Is there anything I missed? Any one still have concern with this idea?
>> >> Thanks for providing the ideas as well as the review.
>> >
>> > I think that's pretty much it.
>> >
>> > Why don't you let me construct a straw man patch.  It's going to be a
>> > bit controversial because it involves adding flush operations to sysfs
>> > and kernfs, slicing apart firmware_class.c to extract the transaction
>> > handling stuff and creating an new efi update capsule file which makes
>> > use of it.
>> >
>> > Once we have code, we at least have something more concrete to argue
>> > over.
>>
>> Would it be worth checking whether busybox is also okay with it first?
>> (Sorry to be a naysayer.)
>>
>> It would be a shame if we do all this to keep the userspace footprint
>> light and then it doesn't work for non-coreutils userspace.
>
> I don't think so, because we can fix busybox if it's a problem.  The
> embedded people wanting this control the tool space, so they can decide
> to use the fixed version.
>
> So yes, someone should check and fix busybox cat if broken, but no, it's
> not a blocker.

It's still a bit unfortunate that:

#!/bin/sh

cat "$1" >/sys/whatever
if [ "$?" != "0" ]; then
   echo "It didn't work because" ...
   exit 1
fi

echo "It worked!  Go reboot if needed."
exit 0

will only work sometimes.  Will people really test this on their
target implementation of cat?  I agree that making this possible with
just shell is nice, but I'm less happy about it if it'll be
unreliable.

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
