From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] efi/libstub: Retry ExitBootServices if map key is
 invalid
Date: Fri, 1 Jul 2016 11:00:35 +0100
Message-ID: <20160701100033.GB21530@leverpostej>
References: <1467300933-3991-1-git-send-email-jhugo@codeaurora.org>
 <20160630162751.GC29700@leverpostej>
 <CAKv+Gu_PLqOVZQC4i3v75M0a-Z9tuE86DSU4v=Vg_pBj-5Y1WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_PLqOVZQC4i3v75M0a-Z9tuE86DSU4v=Vg_pBj-5Y1WQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Jeff Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 30, 2016 at 06:47:02PM +0200, Ard Biesheuvel wrote:
> On 30 June 2016 at 18:27, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> > Hi,
> >
> > [Adding Ard and Leif]
> >
> > On Thu, Jun 30, 2016 at 09:35:33AM -0600, Jeff Hugo wrote:
> >> From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> >>
> >> There exists a race condition between when the efi stub grabs the =
memory
> >> map, and when ExitBootServices is called at which point the EFI ca=
n process
> >> an event which causes the memory map to be invalidated.
> >
> > For reference, do you have a particular example of such an event?
> >
> > Do these events cause the memory map to grow?
> >
>=20
> Events are typically allowed to allocate or free memory, unless they
> have the EVT_SIGNAL_EXIT_BOOT_SERVICES=EF=80=A0 attribute. Whether th=
ey cause
> the memory map to grow is hard to predict, so one must assume yes.

Ok.
=20
> > That "partial shutdown" also means that giving up after a failed
> > ExitBootServices() call is difficult. We can't log anything, and
> > whatever we return to can't call any boot services.
>=20
> This is the unfortunate part: we lost our console so there is nothing
> we can do except hang, or proceed without a memory map. Since we have
> already allocated space for the static kernel image in this case, it
> may be better to proceed so we can at least die loudly on earlycon
> enabled configurations.

Hmm... That might be best, assuming we can somehow signal to the kernel
that something hass gone very wrong.

> >> However the only alternative I can think of it to allocate a suffi=
cently large
> >> buffer so that it can be reused to hold the modified memory map.  =
There doesn't
> >> seem to be any limit to the new map, so any buffer space value I w=
ould choose
> >> would be arbitrary, and there would be some chance that it would b=
e insufficent.
> >> efi_get_memory_map() would need to be modified to "return" the ori=
gional size
> >> of the allocated buffer as well, so I feel like this solution make=
s a mess of
> >> the code, reduces the value of the efi_get_memory_map() helper fun=
ction, and for
> >> all that effort, we still can't fully address this race condition.
> >>
> >> I guess the question is, where do we draw the line at "good enough=
" for
> >> addressing this issue?  Do we use efi_get_memory_map() since it ap=
pears to be
> >> cleaner and does not seem to cause a problem today, despite violat=
ing the spec?
> >
> > We shouldn't be knowingly violating the UEFI spec.
> >
> > At the very least, this should be raised with the USWG. This feels =
like
> > a specification bug, given that it's impossible (rather than simply
> > difficult) to solve the issue.
>=20
> efi_get_memory_map() is the linux wrapper around the GetMemoryMap()
> boot service, and the latter does not perform any allocations. The
> spec also clearly states that GetMemoryMap() can be called after EBS(=
)
> has failed.

Sure, I understood that.

I find it surprising that the spec rules out the use of the memory
allocation services that efi_get_memory_map() uses under the hood, give=
n
that I imagine those don't require asynchronous processing, and having
those would cater for more extreme cases.

> > Ideally, we have the rules regarding a failed call to ExitBootServi=
ces()
> > tightened such that other boot services calls are valid. The curren=
t
> > wording appears to result in a number of unsolvable issues.
>=20
> The only unsolvable issue is that we may find that we did not allocat=
e
> sufficient slack to cover the updated memory map. Typically, a
> periodic event that happens to allocate and/or free some memory in it=
s
> handler may result in one or two entries to be added, but it is
> bounded in practice even if the spec does not spell it out explicitly=
=2E
>=20
> So allocating a couple of entries' worth of slack should be sufficien=
t
> in virtually all cases.

I agree that this is likely to work in practice, given some arbitrary
amount of slack.

I still think it's worth poking the USWG about this, as they may care
about fixing this in the more general case spec-side. Even if we can't
change things, it seems worth a note that the size of the memory map ma=
y
grow.

> >> Second issue-
> >> When do we give up if we cannot get a good memory map to use with
> >> ExitBootServices?  Currently there is an infinite loop in my patch=
=2E  I noticed
> >> arch/x86/boot/compressed/eboot.c only retrys after the first failu=
re.  I think
> >> a single retry is insufficent, we could do better, but I'm aware t=
hat an
> >> infinite loop is generally a bad idea.  Any strong opinions on whe=
n to quit?
> >> 100 attempts?  Either way, it seems the system will require a hard=
 reboot if
> >> the retry(s) ever end up failing.
> >
> > I think this depends on what the problematic events are.
>=20
> The wording of the spec suggests that two attempts at the most covers
> all cases, and the EDK2 implementation confirms that: the first thing
> it does is disarm the timer, and since all asynchronous processing in
> UEFI is event based (no interrupts except for the timer or for debug)=
,
> this guarantees that the race condition that hit us the first time
> does not exist anymore the second time around.
>=20
> I know this is all a bit hand wavy, but I never experienced the issue
> in practice (to my knowledge) and I don't think it makes a huge lot o=
f
> sense to complicate this code too much only to cater for theoretical
> spec violations.

Understood.

Thanks,
Mark.
