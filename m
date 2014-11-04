From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Mon, 3 Nov 2014 22:32:02 -0800
Message-ID: <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com> <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B80EAE4-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 3, 2014 at 10:04 PM, Kweh, Hock Leong
<hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> -----Original Message-----
>> From: Andy Lutomirski [mailto:luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org]
>> >
>> > Andy, here's the steps to load a capsule.  I don't have a problem with
>> > this, it's userspace driven, no "autoloading" of files in /lib/, and
>> > works with sysfs.
>> >
>> > Have any objection to it, I don't.
>
> Thanks Greg for helping me on the explanation. I would like to apologize if
> my cover letter/commit messages did misleading.
>
>>
>> After reading the code, I still have objections.
>>
>> The full workflow seems to be, from the user's POV:
>>
>> 1. load the module
>>
>> 2. hope that there isn't a file called /lib/firmware/efi-capsule-file
>>
>> 3. echo 1 >.../loading
>>
>> 4. cat firmware >.../data
>>
>> 5. echo 0 >.../loading
>>
>> 6. efi_update_capsule gets called.  The return value ends up in the kernel
>> logs somewhere but doesn't seem to make it to userspace.
>>
>> 7. reboot(), but only if the capsule you loaded requires a reboot, which may
>> or may not be detectable without the kernel's help (I'm not sure about this
>> point).
>>
>> If you want to load a second capsule (which seems like a reasonable thing to
>> do if the first capsule was the kind that is processed immediately), then
>> rmmod -f the module and start over?
>
> You no need to do rmmod in order to upload the 2nd capsule binary. You just need to
> do the 3 steps as you mentioned in your 3, 4 and 5 for your 2nd or 3rd capsule binaries.
> Then the last, you do the reboot.

OK.  I missed that you request firmware again after each request finishes.

>
>>
>> This seems like an unpleasant interface.  I think that ioctl or a dedicated
>> custom sysfs file would be considerably nicer.  It would allow you to upload a
>> capsule and get an indication of success or failure all at once, and it lets you
>> load more than one capsule.
>> Also, it gets rid of some of the really weird module refcounting stuff that's
>> going on -- the only unusual thing the module would do would be to pin itself
>> once a reboot-requiring capsule is loaded.
>>
>> --Andy
>>
>
> Regarding the synchronization, it is only required for module unload. The code is designed
> in such a way that allow to be built as a kernel module or built into the kernel. If you choose
> the built in kernel method, you won't come into the module unload situation which require
> the synchronization.
>

It seems like a large fraction of the code in this module exists just
to work around the fact that request_firmware doesn't do what you want
it to do.  You have code to:

 - Prevent the /lib/firmware mechanism from working.
 - Avoid a deadlock by doing strange things in the unload code.
 - Allow more than one capsule per module load.  (Isn't this hard to
use?  User code will have to wait for the next firmware request before
sending a second capsule.)

All of this is for dubious gain.  You have to do three separate opens
in sysfs to upload a capsule, and there's no way to report back to
userspace whether the EFI call worked and whether a reboot is needed.

What's the benefit of using the firmware interface here?

--Andy
