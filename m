From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Sat, 29 Dec 2012 09:00:03 +0800
Message-ID: <1356742803.6113.245.camel@linux-s257.site>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "matt.fleming@intel.com" <matt.fleming@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Jan Beulich <JBeulich@suse.com>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2012-12-28 =E6=96=BC 17:43 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
> > UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeu=
pTime() are also
> > supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
> >=20
> > This patch changed RTC_DRV_EFI configuration to depend on EFI but n=
ot just IA64. It
> > checks efi_enabled flag and efi-rtc driver should enabled.
>=20
> In theory, certainly - but do we still have machines that explode if =
the
> get_time call is made? We may also want to think about disabling the
> legacy access to the RTC if the EFI calls are present.

The legacy get_time access on my test machine is work fine, not thing
explode. :-)
Just we have a function want to expose the timezone information to
userspace and also store it.


Thanks a lot!
Joey Lee
