From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 21:30:17 -0800
Message-ID: <CA+55aFwjQUkBxmF+YsniacHhX3XuWJ1wJaQ36VJzJX9qpbvzWg@mail.gmail.com>
References: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
	<CA+55aFwRE6DNoigx0xN7ZTc8dbCqHZdTopfwYOVuK_0vhZe0rw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31DBA1E0@ORSMSX106.amr.corp.intel.com>
	<CA+55aFyHLGaDnTWQRSxtb1dhgoTauEY2x8ztOBWqjLNShh88Tg@mail.gmail.com>
	<1390863051.20150.55.camel@joe-AO722>
	<CA+55aFxZ03VMp+-YPb0KvH6=9A7=iXHVN=YLhfP9VyVDT9skhg@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31DBA6CB@ORSMSX106.amr.corp.intel.com>
	<1390869840.20150.69.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390869840.20150.69.camel@joe-AO722>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 27, 2014 at 4:44 PM, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
>
> There are very few uses overall of KERN_DEFAULT.
>
> I think KERN_DEFAULT should be removed actually.
> All the uses might be better with a specific level.

It's a long time ago, but I think one of the reasons for KERN_DEFAULT
was some of the precursor discussion to a different interface, where
people wanted to make the prefix a separate argument in order to
*force* it to be used. And that meant that you needed a separate value
for the default case, since you couldn't just skip it.

And that obviously never happened, and yes, KERN_DEFAULT is useless. I
agree that it could be removed, I'd just like the "no explicit level"
to behave like KERN_DEFAULT does..

>> Of course if people *really* want things on the same line, they usually end
>> up using sprintf() to save the individual pieces to some buffer and the dump
>> that out using one printk() call
>
> No, actually, they don't.
>
> There's probably much more code that uses KERN_CONT
> or no KERN_ level where it's intended that the printks
> be merged than uses of intermediate buffers.
>
> There are many uses of %pV that effectively serve as a
> mechanism to avoid using multiple printks though.

KERN_CONT is kind of hacky, but the thing is, it's very convenient.
And it's often used when it's important that things be reasonably
dense (in order to not make useless small details end up as lots of
useless separate lines), but for things that aren't really
*important*.

Sometimes people could generate single strings, but KERN_CONT is all
about convenience for those print-outs. And generating a bigger string
and then printing that all out in one go is often non-productive, when
you very much want to get incremental output (some of the really
traditional cases are for things like testing where you print the test
name and then "ok" afterwards, where you need to know that you're
testing even if the ok never happens - or _especially_ if the ok never
happens).

It's not a "good" interface, no. But it's a very simple and convenient
one for simple lists of supported features etc, and it actually does
have some cases where it would be actively *wrong* to try to do it the
"right" way with fancy preformatting.

                 Linus
