From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 16:13:38 -0800
Message-ID: <CA+55aFxZ03VMp+-YPb0KvH6=9A7=iXHVN=YLhfP9VyVDT9skhg@mail.gmail.com>
References: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
	<CA+55aFwRE6DNoigx0xN7ZTc8dbCqHZdTopfwYOVuK_0vhZe0rw@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F31DBA1E0@ORSMSX106.amr.corp.intel.com>
	<CA+55aFyHLGaDnTWQRSxtb1dhgoTauEY2x8ztOBWqjLNShh88Tg@mail.gmail.com>
	<1390863051.20150.55.camel@joe-AO722>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390863051.20150.55.camel@joe-AO722>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 27, 2014 at 2:50 PM, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org> wrote:
> On Mon, 2014-01-27 at 14:09 -0800, Linus Torvalds wrote
>>
>> Ok, I think that's a bug. Only an explicit KERN_CONT prefix should
>> cause a line continuation.
>
> I don't think it's a bug.
> That's never been the case and isn't the case today.

We've certainly had different behavior over time, but we've tried to
generally go into the "do the right thing" direction.

See (for example)

    git show v3.3:kernel/printk.c | less -N

and look at lines 885-901.

Now, that code only triggers if there is *any* prefix (and I think
that we should probably make it trigger for the no-prefix case too),
but the thing is, we seem to really have broken that concept of
KERN_CONT being special.

And we seem to have broken that not so much because we've screwed up
the KERN_CONT logic itself, but because we ended up basically saying
"without any prefix, we do the old pre-linebreak default continuation
thing, so then we can make KERN_CONT empty, so now we have to do the
default continuation even if it doesn't make sense".

And _that_ in turn is a problem, because it means we missed the "oh,
we should make the non-prefix case actually be the same as
KERN_DEFAULT, not KERN_CONT.

Which I think is a bit sad. Because I think the better choice (from a
internal kernel usability standpoint) would have been to say "no
prefix means KERN_DEFAULT".

> In the past, if the printk buffer string prefix was
> "<c>", the emitted string pointer was advanced by 3
> and whatever else was emitted.

Yes, but we then also did that whole "let's break lines so that printk
is easier to use without getting ugly behavior etc". That happened

> A dev_<level> though is always effectively newline
> terminated even if it doesn't have end in an explicit
> '\n'.  pr_cont uses after a dev_<level> are always
> started on a new line.

But we're not talking about dev_xyz. We're talking about printk().

Now, printk() will inevitably behave a bit differently (if for no
other reason than the fact that it by definition *doesn't* have a
device, and *doesn't* have a specific log-level), and I think it's
somewhat reasonable that the "dev_xyz()" functions end up having the
model where they are always effectively single lines. printk() shares
much of the logic, and generally they should be *similar*, but clearly
they won't ever really be the same.

But that actually argues *more* for moving to a world where that
(common, but also often-forgotten) final '\n' at the end should be
de-emphasized. So I don't think it would be at all wrong to expect
that

    printk("Line A");
    printk("Line B");

should print two lines. We very much had that KERN_CONT to encode the
*exception* to this, for the (not very common) cases where we end up
listing multiple things on one line.

Now, I realize that we broke that at some point, and after having
broken it, we seem to have then said "KERN_CONT" doesn't do anything,
so let's make it an empty string.

But quite frankly, wouldn't it be much nicer if it was KERN_DEFAULT
that was the empty string, and KERN_CONT was the "yes, we want to
explicitly continue this line" one? So that the nide default behavior
would be that we'd not have these silly "\n" is meaningful *unless*
the next print-out happens to be a dev_xyzzy() or has an explicit
level.

> btw: today, KERN_CONT is an empty string, not '<c>'.
>
> include/linux/kern_levels.h:#define KERN_CONT   ""

Yes, I noticed that when I started looking at the history of this
thing. I just think we would be better off doing it the other way
around with KERN_DEFAULT instead, and basically move away from having
'\n' be so meaningful at the end.

Hmm?

                   Linus
