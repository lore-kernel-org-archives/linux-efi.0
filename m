From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] x86/efi-bgrt: Switch all pr_err() to pr_debug() for
 invalid BGRT
Date: Wed, 27 Apr 2016 13:23:55 -0400
Message-ID: <CA+5PVA7bsX9UTM6DCnhE0gHDumGTZgKDGNAgd-teCG8YCM5Nsg@mail.gmail.com>
References: <1461761412-16046-1-git-send-email-jwboyer@fedoraproject.org>
	<5720BE0B.8080605@moshe.nl>
	<CA+5PVA71vCaf+a=6cEqQxe4iUQeAK5NN-s09bMDa6_NbXZfMNw@mail.gmail.com>
	<5720D365.5080601@moshe.nl>
	<CA+5PVA51UZL3zkYgLAimnXcYQwNJ4h+zCqEt0XRp2UEHaV302g@mail.gmail.com>
	<20160427170525.GA1965@jtriplet-mobl2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160427170525.GA1965-rHrQKAUqdt9zQ5U6333jmjMJUdESFZ8XQQ4Iyu8u01E@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Cc: =?UTF-8?Q?M=C3=B4she_van_der_Sterre?= <me-A/3C56C7qwM@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 27, 2016 at 1:05 PM, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org> =
wrote:
> On Wed, Apr 27, 2016 at 11:20:26AM -0400, Josh Boyer wrote:
>> On Wed, Apr 27, 2016 at 10:57 AM, M=C3=B4she van der Sterre <me@mosh=
e.nl> wrote:
>> >
>> > On 04/27/2016 03:56 PM, Josh Boyer wrote:
>> >>
>> >> On Wed, Apr 27, 2016 at 9:26 AM, M=C3=B4she van der Sterre <me@mo=
she.nl> wrote:
>> >>>
>> >>> (additionally CC-ing Josh Triplett)
>> >>
>> >> Thanks for doing so.  I completely forgot.
>> >>
>> >>> On 04/27/2016 02:50 PM, Josh Boyer wrote:
>> >>>>
>> >>>> The promise of pretty boot splashes from firmware via BGRT was =
at
>> >>>> best only that; a promise.  The kernel diligently checks to mak=
e
>> >>>> sure the BGRT data firmware gives it is valid, and dutifully wa=
rns
>> >>>> the user when it isn't.  However, it does so via the pr_err log
>> >>>> level which seems unnecessary.  The user cannot do anything abo=
ut
>> >>>> this and there really isn't an error on the part of Linux to
>> >>>> correct.
>> >>>>
>> >>>> This lowers the log level by using pr_debug instead.  Users wil=
l
>> >>>> no longer have their boot process uglified by the kernel remind=
ing
>> >>>> us that firmware can and often is broken.  Ironic, considering
>> >>>> BGRT is supposed to make boot pretty to begin with.
>> >>>
>> >>> Hi Josh Boyer,
>> >>>
>> >>> Are you seeing these errors somewhere? I recently fixed the erro=
r
>> >>> "Ignoring
>> >>
>> >> We have a user that reports seeing:
>> >>
>> >> "Ignoring BGRT: Invalid version 0 (expected 1)"
>> >>
>> >> on a Lenovo T430 machine.  We've had a few other scattered report=
s on
>> >> various machine types since BGRT went into the kernel as well.
>> >
>> > Ok. With this information, I think pr_debug is indeed better.
>> >>>
>> >>> BGRT: invalid status 0 (expected 1)" because Linux apparently in=
terpreted
>> >>> that part of the specification differently than others.
>> >>> If that's the error you are seeing, perhaps your problem is alre=
ady
>> >>> solved
>> >>> in recent kernels? (fixed in commit 66dbe99)
>> >>>
>> >>> Personally I agree that BGRT messages should not annoy actual us=
ers of
>> >>> production firmwares.
>> >>> However I also agree with the previous consensus that these chec=
ks (for
>> >>> actual spec violations) should remain pr_err unless some product=
ion
>> >>> firmware
>> >>> is triggering them. What do you think?
>> >>
>> >> Production firmware is literally the only firmware end users will=
 ever
>> >> see.  I don't see much point in leaving scary error messages in t=
he
>> >> kernel to complain about things the user has no chance of fixing =
or in
>> >> almost all cases even reporting to people who could fix it.
>> >
>> > In principle I can understand the wish to show big scary error mes=
sages to
>> > firmware developers doing it wrong.
>>
>> Yes, that is theoretically possible.  However, my best guess is that
>> firmware developers aren't typically testing with Linux distribution=
s
>> during firmware development.
>
> Speaking from experience, firmware developers absolutely do test with
> Linux distributions these days.

Clearly not all and not enough.

>> We see this in lots of areas, which is why we have weird quirks for
>> devices all over the kernel, but I don't think there's value in doin=
g
>> quirk mechanisms around BGRT.
>
> I do; I think it makes sense to flag these issues, and making them
> pr_debug means they *will* be missed on pre-production devices.  If y=
ou
> want to downgrade them to pr_warn, I don't have any objection there, =
but
> they shouldn't be any lower than that.

pr_warn still shows up on the console for most distros, which then
runs into the problem described in the commit log in the patch.

> I'd also suggest adding FW_BUG to them.  (And if you want to implemen=
t a
> mechanism to help end users downgrade the priority of FW_BUG messages=
,
> such as if you already have automated reporting of such issues, feel
> free; however, in the absence of such automated reporting, this hides
> real problems and makes it less likely that such issues will be caugh=
t
> and fixed.)

How is an end user supposed to see such a message and report it to the
people that can fix it?  They can't.  So they report it in their
distributions bug tracker and it either gets closed as "yeah, firmware
sucks" or it sits there and rots in the hope that some day someone
will do something.

I understand where you're coming from in a pre-production, development
environment but to be quite clear that is not the default environment
Linux is run in most of the time.  If this were a kernel warning, that
could be fixed with a kernel patch, then maybe it would be worth it.
It isn't though.

> This seems consistent with how the rest of the kernel handles firmwar=
e
> bugs:

Well, to be honest I think those are all wrong too.  There's no
recourse for the user to report them to the firmware developers and no
incentive for the firmware developers to fix them once the firmware is
shipped.  Either the kernel can do something about it and work around
the firmware issue (most likely already done before the warning spew),
it cannot but it doesn't matter, or it cannot and it panics.  The only
situation where added FW_BUG or pr_warn messages actually help
anything is the panic case.

josh
