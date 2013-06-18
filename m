From: joeyli <jlee@suse.com>
Subject: RE: [PATCH] x86, efi: retry ExitBootServices() on failure
Date: Tue, 18 Jun 2013 10:47:45 +0800
Message-ID: <1371523665.6523.336.camel@linux-s257.site>
References: <1370933558-10128-1-git-send-email-matt@console-pimps.org>
	 <1371139233.6523.272.camel@linux-s257.site>
	 <20130617092107.GA5440@console-pimps.org>
	 <51BEF71402000078000DEC12@nat28.tlf.novell.com>
	 <20130617101745.GB8569@console-pimps.org>
	 <51BF08CD02000078000DEC99@nat28.tlf.novell.com>
	 <20130617123052.GE8569@console-pimps.org>
	 <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7BD74F8E52BFD147B6C83AE7A1E893FFE285F690@atlms1.us.megatrends.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zachary Bobroff <zacharyb@ami.com>
Cc: 'Matt Fleming' <matt@console-pimps.org>, Jan Beulich <JBeulich@suse.com>, Matt Fleming <matt.fleming@intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Hi Zach,=20

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-06-18 =E6=96=BC 00:18 +0000=EF=BC=8CZa=
chary Bobroff =E6=8F=90=E5=88=B0=EF=BC=9A
> All,
>=20
> >> Why a single retry is having reasonable guarantees to work when th=
e
> original one failed (nothing prevents an event handler to do another
> allocation the next time through).
>=20
> This patch is being submitted because of the potential issues that
> occur when 3rd party option ROMs are signaled by the ExitBootServices
> event. At the time they are signaled, they can perform any number of
> actions that would change the EFI Memory map.  This wasn't actually
> seen with our default implementation of our firmware, it was seen whe=
n
> this plug-in card's option rom was run.
>=20
> We only need to retry once because of what is in the UEFI
> specification 2.3.1 Errata C.  The exact verbiage is as follows:
>=20
> The ExitBootServices() function is called by the currently executing
> EFI OS loader image to terminate all boot services. On success, the
> loader becomes responsible for the continued operation of the system.
> All events of type EVT_SIGNAL_EXIT_BOOT_SERVICES must be signaled
> before ExitBootServices() returns EFI_SUCCESS. The events are only
> signaled once even if ExitBootServices() is called multiple times.
>=20
> Since the firmware will only signal the ExitBootServices event once,
> the code that has the potential to change the memory map will only be
> signaled on the first call to exit boot services.=20

Does it possible have any delay time of 3rd party ROMs to change EFI
memory map after they are signaled?
or ExitBootServices() will wait all 3rd party ROMs updated memory map
finished then return true/false to kernel?


Thanks a lot!
Joey Lee
