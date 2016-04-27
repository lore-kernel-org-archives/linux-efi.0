From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch all pr_err() to pr_debug() for
 invalid BGRT
Date: Wed, 27 Apr 2016 10:05:25 -0700
Message-ID: <20160427170525.GA1965@jtriplet-mobl2.jf.intel.com>
References: <1461761412-16046-1-git-send-email-jwboyer@fedoraproject.org>
 <5720BE0B.8080605@moshe.nl>
 <CA+5PVA71vCaf+a=6cEqQxe4iUQeAK5NN-s09bMDa6_NbXZfMNw@mail.gmail.com>
 <5720D365.5080601@moshe.nl>
 <CA+5PVA51UZL3zkYgLAimnXcYQwNJ4h+zCqEt0XRp2UEHaV302g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA51UZL3zkYgLAimnXcYQwNJ4h+zCqEt0XRp2UEHaV302g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Cc: =?iso-8859-1?Q?M=F4she?= van der Sterre <me-A/3C56C7qwM@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 11:20:26AM -0400, Josh Boyer wrote:
> On Wed, Apr 27, 2016 at 10:57 AM, M=F4she van der Sterre <me-A/3C56C7qwM@public.gmane.org=
> wrote:
> >
> > On 04/27/2016 03:56 PM, Josh Boyer wrote:
> >>
> >> On Wed, Apr 27, 2016 at 9:26 AM, M=F4she van der Sterre <me@moshe.=
nl> wrote:
> >>>
> >>> (additionally CC-ing Josh Triplett)
> >>
> >> Thanks for doing so.  I completely forgot.
> >>
> >>> On 04/27/2016 02:50 PM, Josh Boyer wrote:
> >>>>
> >>>> The promise of pretty boot splashes from firmware via BGRT was a=
t
> >>>> best only that; a promise.  The kernel diligently checks to make
> >>>> sure the BGRT data firmware gives it is valid, and dutifully war=
ns
> >>>> the user when it isn't.  However, it does so via the pr_err log
> >>>> level which seems unnecessary.  The user cannot do anything abou=
t
> >>>> this and there really isn't an error on the part of Linux to
> >>>> correct.
> >>>>
> >>>> This lowers the log level by using pr_debug instead.  Users will
> >>>> no longer have their boot process uglified by the kernel remindi=
ng
> >>>> us that firmware can and often is broken.  Ironic, considering
> >>>> BGRT is supposed to make boot pretty to begin with.
> >>>
> >>> Hi Josh Boyer,
> >>>
> >>> Are you seeing these errors somewhere? I recently fixed the error
> >>> "Ignoring
> >>
> >> We have a user that reports seeing:
> >>
> >> "Ignoring BGRT: Invalid version 0 (expected 1)"
> >>
> >> on a Lenovo T430 machine.  We've had a few other scattered reports=
 on
> >> various machine types since BGRT went into the kernel as well.
> >
> > Ok. With this information, I think pr_debug is indeed better.
> >>>
> >>> BGRT: invalid status 0 (expected 1)" because Linux apparently int=
erpreted
> >>> that part of the specification differently than others.
> >>> If that's the error you are seeing, perhaps your problem is alrea=
dy
> >>> solved
> >>> in recent kernels? (fixed in commit 66dbe99)
> >>>
> >>> Personally I agree that BGRT messages should not annoy actual use=
rs of
> >>> production firmwares.
> >>> However I also agree with the previous consensus that these check=
s (for
> >>> actual spec violations) should remain pr_err unless some producti=
on
> >>> firmware
> >>> is triggering them. What do you think?
> >>
> >> Production firmware is literally the only firmware end users will =
ever
> >> see.  I don't see much point in leaving scary error messages in th=
e
> >> kernel to complain about things the user has no chance of fixing o=
r in
> >> almost all cases even reporting to people who could fix it.
> >
> > In principle I can understand the wish to show big scary error mess=
ages to
> > firmware developers doing it wrong.
>=20
> Yes, that is theoretically possible.  However, my best guess is that
> firmware developers aren't typically testing with Linux distributions
> during firmware development.

Speaking from experience, firmware developers absolutely do test with
Linux distributions these days.

> We see this in lots of areas, which is why we have weird quirks for
> devices all over the kernel, but I don't think there's value in doing
> quirk mechanisms around BGRT.

I do; I think it makes sense to flag these issues, and making them
pr_debug means they *will* be missed on pre-production devices.  If you
want to downgrade them to pr_warn, I don't have any objection there, bu=
t
they shouldn't be any lower than that.

I'd also suggest adding FW_BUG to them.  (And if you want to implement =
a
mechanism to help end users downgrade the priority of FW_BUG messages,
such as if you already have automated reporting of such issues, feel
free; however, in the absence of such automated reporting, this hides
real problems and makes it less likely that such issues will be caught
and fixed.)

This seems consistent with how the rest of the kernel handles firmware
bugs:

~/src/linux$ git grep -h FW_BUG | grep -Eo 'pr_[a-z]*' | sort | uniq -c=
 | sort -rn
     22 pr_err
     13 pr_warn
      8 pr_warning
      2 pr_info
      1 pr_debug
