From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 16:44:00 -0800
Message-ID: <1390869840.20150.69.camel@joe-AO722>
References: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
	 <CA+55aFwRE6DNoigx0xN7ZTc8dbCqHZdTopfwYOVuK_0vhZe0rw@mail.gmail.com>
	 <3908561D78D1C84285E8C5FCA982C28F31DBA1E0@ORSMSX106.amr.corp.intel.com>
	 <CA+55aFyHLGaDnTWQRSxtb1dhgoTauEY2x8ztOBWqjLNShh88Tg@mail.gmail.com>
	 <1390863051.20150.55.camel@joe-AO722>
	 <CA+55aFxZ03VMp+-YPb0KvH6=9A7=iXHVN=YLhfP9VyVDT9skhg@mail.gmail.com>
	 <3908561D78D1C84285E8C5FCA982C28F31DBA6CB@ORSMSX106.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31DBA6CB-P5GAC/sN6hlZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-01-28 at 00:26 +0000, Luck, Tony wrote:
> > But that actually argues *more* for moving to a world where that
> > (common, but also often-forgotten) final '\n' at the end should be
> > de-emphasized. So I don't think it would be at all wrong to expect
> > that
> >
> >    printk("Line A");
> >    printk("Line B");
> >
> > should print two lines. We very much had that KERN_CONT to encode the
> > *exception* to this, for the (not very common) cases where we end up
> > listing multiple things on one line.

Depends on how old the code in question is.

KERN_CONT was introduced in Oct 2007 (commit 4749252776)
and everything older than that actually did have the
intention of continuing a previous line or was a
defect.

KERN_DEFAULT was June 2009 (commit e28d7137041) and
that allowed printks to start with any KERN_<LEVEL>
but KERN_CONT and actually start on a new line too
even if the preceding printk did not end in '\n'.

There are very few uses overall of KERN_DEFAULT.

I think KERN_DEFAULT should be removed actually.
All the uses might be better with a specific level.

> Of course if people *really* want things on the same line, they usually end
> up using sprintf() to save the individual pieces to some buffer and the dump
> that out using one printk() call

No, actually, they don't.

There's probably much more code that uses KERN_CONT
or no KERN_ level where it's intended that the printks
be merged than uses of intermediate buffers.

There are many uses of %pV that effectively serve as a
mechanism to avoid using multiple printks though.

>  ... because KERN_CONT isn't much help when
> some other code comes along and drops its own output in the middle of
> what you were trying to pretty print.

Exactly true.

I've submitted quite a few patches that avoid multiple
printks by either using %pV or coalescing the separate
printks into a single printk.

There are _lots_ more that could be done.

Maybe adding a patch similar to what Linus proposes would
cause a lot more of these changes to be done quicker.
