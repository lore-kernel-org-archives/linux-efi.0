From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 14:50:51 -0800
Message-ID: <1390863051.20150.55.camel@joe-AO722>
References: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
	 <CA+55aFwRE6DNoigx0xN7ZTc8dbCqHZdTopfwYOVuK_0vhZe0rw@mail.gmail.com>
	 <3908561D78D1C84285E8C5FCA982C28F31DBA1E0@ORSMSX106.amr.corp.intel.com>
	 <CA+55aFyHLGaDnTWQRSxtb1dhgoTauEY2x8ztOBWqjLNShh88Tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFyHLGaDnTWQRSxtb1dhgoTauEY2x8ztOBWqjLNShh88Tg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2014-01-27 at 14:09 -0800, Linus Torvalds wrote:
> On Mon, Jan 27, 2014 at 11:48 AM, Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> >> The thing is, unless the next printk is a continuation (PR_CONT), the
> >> newline should be added at that point. And if it isn't, then that's a
> >> bug. So I'm wondering how this issue got noticed - does it actually
> >> cause user-visible issues, or was it just code reading?
> >
> > The next thing that happened was a debug printk() that didn't have
> > any log level specified.
> >
> >         printk("CMCI on cpu%d\n", smp_processor_id());
> >
> > and no newline was added.
> 
> Ok, I think that's a bug. Only an explicit KERN_CONT prefix should
> cause a line continuation.

I don't think it's a bug.
That's never been the case and isn't the case today.

In the past, if the printk buffer string prefix was
"<c>", the emitted string pointer was advanced by 3
and whatever else was emitted.

A dev_<level> though is always effectively newline
terminated even if it doesn't have end in an explicit
'\n'.  pr_cont uses after a dev_<level> are always
started on a new line.

That's sometimes unfortunate, but that is a fallout of
Kay's desire to have dev_<level> output always be a
complete message.

There was a patch proposed recently to fix some of the
scsi dev_<level> output followed by KERN_CONT that
previously would have been emitted on a single line
that is now on multiple lines.

https://lkml.org/lkml/2014/1/15/926

> The new msg code seems to be terminally confused about this, and for
> example, seems to completely ignore the KERN_CONT flag, and instead
> tests for just LOG_PREFIX (which is set for any prefix, not the
> KERN_CONT 'c' prefix).

btw: today, KERN_CONT is an empty string, not '<c>'.

include/linux/kern_levels.h:#define KERN_CONT   ""
