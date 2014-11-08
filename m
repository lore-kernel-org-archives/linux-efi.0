From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Sat, 8 Nov 2014 07:54:25 -0800
Message-ID: <CALCETrVaSKH_zChUzVFSqU7NCD9DtdeYDZF3GVKuxQDe607p0w@mail.gmail.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-4-git-send-email-hock.leong.kweh@intel.com>
 <20141104043247.GA23418@kroah.com> <CALCETrXjJju+cMWJfB6W5kSD=Ox5y+Hj_AfmbbbOTOh8CV8eaQ@mail.gmail.com>
 <F54AEECA5E2B9541821D670476DAE19C2B80EAE4@PGSMSX102.gar.corp.intel.com>
 <CALCETrU2wk_FdcD6E+oMcp-tF97zN7f+w7q5rfPWBaNKrrmxVg@mail.gmail.com>
 <1415110688.26277.36.camel@mfleming-mobl1.ger.corp.intel.com>
 <CALCETrW1UaOCcb-32SOUhi_Zh5vLzV+VwyffThVvso23z04SHA@mail.gmail.com>
 <20141104154017.GA28113@kroah.com> <CALCETrV6M5D4iPjxPwNkMWTfVYDf3wSuZ9P23miUSR-jMGRyvg@mail.gmail.com>
 <20141108130556.GM3592@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141108130556.GM3592-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Nov 8, 2014 5:05 AM, "Matt Fleming" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
>
> On Tue, 04 Nov, at 08:35:40AM, Andy Lutomirski wrote:
> >
> > Am I missing something here?  The current proposal is missing the
> > success/failure part, unless you count the loaded count (in a
> > different sysfs directory) as a useful interface for that.
>
> As Wilson pointed out, you only get the ability to make meaningful
> success/failure declarations once you've performed the reboot.
>
> I know of no firmware that will hot-patch itself when you call
> UpdateCapsule(). A reboot is always required. Certainly that's the way
> Windows will work from what I've read, which means that for x86 it's
> pretty much set in stone.

I dunno.  If nothing else, efi_capsule_update can fail due to ENOMEM.

>
> Which means there's only so much info you can return to userspace once
> you've handed the blob to the firmware. I don't see a huge problem with
> printing things in kernel buffer, since that's how other
> firmware-related things work today.

I think the kernel log is fine.  But if the code is going to report
success / failure to userspace at all, shouldn't that indication be
reliable?

TBH, I find this discussion very strange.  In summary:

me: This API is really awkward.

others: But it's using the subsystem that it should be using.

me: Then fix the subsystem?

others: The subsystem the correct choice.

me: But the API is still really awkward, and, by the way, it probably
has at least two races that user code could hit.  And, by the way, the
sample script written by the author of the patches is subject to
*both* races most likely and therefore won't work reliably.

you: Common use cases (e.g. Windows-style uses, perhaps) don't need
the features that are racy anyway.


My only response is that (a) something else might want the full
functionality and (b) Wilson's actual example script exercises the
racy code.

I think I'm done reviewing these patches.  I'll probably grumble at
the result the first time I actually try to install an EFI capsule,
though.

--Andy

P.S. What happens when a strange UEFI BIOS really wants two capsules,
and the second one will brick the machine if the first one isn't
there, and the first one failed to load but no one noticed because
there's no useful error handling?
