From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Mon, 10 Nov 2014 11:31:06 -0800
Message-ID: <CALCETrUz+5TXxuCHM+RetaR9A_Nb4BRs6bhb6vfL5ijYoUp42A@mail.gmail.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com> <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com> <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80F3A9@PGSMSX102.gar.corp.intel.com>
 <CALCETrUi0ssZbOpHyVmh6jx68Oj=0h4BwfM0uLio8Qbaeu9gJw@mail.gmail.com> <F54AEECA5E2B9541821D670476DAE19C2B851058@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B851058-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 10, 2014 at 12:31 AM, Kweh, Hock Leong
<hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org]
>> > #!/bin/sh
>> >
>> > old=$(cat
>> > /sys/devices/platform/efi_capsule_user_helper/capsule_loaded)
>> >
>> > for arg in "$@"
>> > do
>> >         if [ -f $arg ]
>> >         then
>> >                 echo 1 > /sys/class/firmware/efi-capsule-file/loading
>> >                 cat $arg > /sys/class/firmware/efi-capsule-file/data
>> >                 echo 0 > /sys/class/firmware/efi-capsule-file/loading
>>
>> I think you have a race.  Try putting msleep(1000) after the
>> request_firmware_nowait call, and I bet this will fail on the second try.
>
> Sorry for the late response. I don't really catch the race condition that
> you are referring? Are you trying to tell that the user script could run faster
> before the previous callback function actually end? Will such scenario happen?
> In the callback function, after the request_firmware_nowait(), I don't have
> any codes will delay the callback function to end. Besides, there is a mutex_lock
> protecting the request_firmware_nowait() calling. Won't that take care of the
> issue?

In callbackfn_efi_capsule, you call request_firmware_nowait.  When
that callback is invoked, I think that the
/sys/class/firmware/efi-capsule-file directory doesn't exist at all.
If the callback takes longer than it takes your script to make it
through a full iteration, then it will try uploading the second
capsule before the firmware class directory is there, so it will fail.

But I just realized that your script has a loop below to handle that.
It's this:

                 oldtime=$(date +%S)
                 oldtime=$(((time + 2) % 60))
                 until [ -f /sys/class/firmware/efi-capsule-file/loading ]
                 do
                         newtime=$(date +%S)
                         if [ $newtime -eq $oldtime ]
                         then
                                 break
                         fi
                 done

Aside from the fact that this loop itself is racy (it may loop forever
if something goes wrong in the kernel, since $newtime -eq $oldtime may
never happen), it should help, if you're lucky.  But there's another
bug.

>>
>> I think that firmware_class doesn't call the callback until after loading is closed
>> for the second time.  If so, then this is racy.  Try inserting msleep(1000) at the
>> beginning of your callback and uploading a capsule that should load
>> successfully -- this will report failure, but a future upload may get very
>> confused. Also, what does the firmware class do when simultaneous
>> uploads of the same file with different contents are in flight?  Is that possible?
>
> Sorry again, I can't really catch you on this race condition statement. Are you
> trying to tell if user is doing this:
>
> echo 1 > /sys/class/firmware/efi-capsule-file/loading
> cat capsule1 > /sys/class/firmware/efi-capsule-file/data
> cat capsule2 > /sys/class/firmware/efi-capsule-file/data
> echo 0 > /sys/class/firmware/efi-capsule-file/loading
>
> If so, capsule2 will be the one we will obtain in the callback function.

Here's the race:

User:
echo 1 > /sys/class/firmware/efi-capsule-file/loading
cat capsule1 > /sys/class/firmware/efi-capsule-file/data
echo 0 > /sys/class/firmware/efi-capsule-file/loading

Kernel: Be a little slow here due to preemption or whatever.

User:
-f /sys/class/firmware/efi-capsule-file/loading returns true
capsules_loaded == 0
Assume failure, incorrectly

Kernel: catch up and increment capsules_loaded.

If these patches get applied, then I think that the protocol needs to
be documented in Documentation/ABI.  It should say something like:

To upload an EFI capsule, do this:

Write 1 to /sys/class/firmware/efi-capsule-file/loading
Write the capsule to /sys/class/firmware/efi-capsule-file/data
Write 0 to /sys/class/firmware/efi-capsule-file/loading

Make sure that /sys/class/firmware/efi-capsule-file disappears and
comes back, perhaps by cd-ing there and waiting for all the files in
the directory to go away.

Then, and only then, read capsules_loaded to detect success.


Once you've written that doc, please seriously consider whether this
interface is justifiable.  I think it sucks.

--Andy
