From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Tue, 18 Jun 2013 15:34:06 +0800
Message-ID: <1371540846.6523.344.camel@linux-s257.site>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
	 <1371139233.6523.272.camel@linux-s257.site>
	 <20130617092107.GA5440@console-pimps.org>
	 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
	 <20130617101745.GB8569@console-pimps.org>
	 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
	 <20130617123052.GE8569@console-pimps.org>
	 <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
	 ,<1371523665.6523.336.camel@linux-s257.site>
	 <B0277B82-F2C5-4BA9-B42C-F554E12F6961@ami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B0277B82-F2C5-4BA9-B42C-F554E12F6961-gH/BEeFdNRQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zachary Bobroff <zacharyb-gH/BEeFdNRQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Thanks for Zach's clarify, then I think that makes sense BIOS has
problem if kernel need call ExitBootServices() more then 2 times.


Thanks
Joey Lee

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-06-18 =E6=96=BC 04:20 +0000=EF=BC=8CZa=
chary Bobroff =E6=8F=90=E5=88=B0=EF=BC=9A
> The timer is shutdown before callbacks on exitbootservices are called=
=2E  The bios should be entirely single threaded at this point unless L=
inux has started some other CPUs.  So exitbootservices will not return =
until each until each callback is complete.  In short, then it would re=
turn the status of failure if the memory map has changed, success other=
wise.  The callbacks are not called on any subsequent call to exitboots=
ervices, so the map should stay the same then.
>=20
> Sent from my iPhone
>=20
> On Jun 17, 2013, at 10:48 PM, "joeyli" <jlee-IBi9RG/b67k@public.gmane.org> wrote:
>=20
> > Hi Zach,=20
> >=20
> > =E6=96=BC =E4=BA=8C=EF=BC=8C2013-06-18 =E6=96=BC 00:18 +0000=EF=BC=8C=
Zachary Bobroff =E6=8F=90=E5=88=B0=EF=BC=9A
> >> All,
> >>=20
> >>>> Why a single retry is having reasonable guarantees to work when =
the
> >> original one failed (nothing prevents an event handler to do anoth=
er
> >> allocation the next time through).
> >>=20
> >> This patch is being submitted because of the potential issues that
> >> occur when 3rd party option ROMs are signaled by the ExitBootServi=
ces
> >> event. At the time they are signaled, they can perform any number =
of
> >> actions that would change the EFI Memory map.  This wasn't actuall=
y
> >> seen with our default implementation of our firmware, it was seen =
when
> >> this plug-in card's option rom was run.
> >>=20
> >> We only need to retry once because of what is in the UEFI
> >> specification 2.3.1 Errata C.  The exact verbiage is as follows:
> >>=20
> >> The ExitBootServices() function is called by the currently executi=
ng
> >> EFI OS loader image to terminate all boot services. On success, th=
e
> >> loader becomes responsible for the continued operation of the syst=
em.
> >> All events of type EVT_SIGNAL_EXIT_BOOT_SERVICES must be signaled
> >> before ExitBootServices() returns EFI_SUCCESS. The events are only
> >> signaled once even if ExitBootServices() is called multiple times.
> >>=20
> >> Since the firmware will only signal the ExitBootServices event onc=
e,
> >> the code that has the potential to change the memory map will only=
 be
> >> signaled on the first call to exit boot services.=20
> >=20
> > Does it possible have any delay time of 3rd party ROMs to change EF=
I
> > memory map after they are signaled?
> > or ExitBootServices() will wait all 3rd party ROMs updated memory m=
ap
> > finished then return true/false to kernel?
> >=20
> >=20
> > Thanks a lot!
> > Joey Lee
> >=20
>=20
> The information contained in this message may be confidential and pro=
prietary to American Megatrends, Inc.  This communication is intended t=
o be read only by the individual or entity to whom it is addressed or b=
y their designee. If the reader of this message is not the intended rec=
ipient, you are on notice that any distribution of this message, in any=
 form, is strictly prohibited.  Please promptly notify the sender by re=
ply e-mail or by telephone at 770-246-8600, and then delete or destroy =
all copies of the transmission.
>=20
