From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 02/14] x86-64/efi: Use EFI to deal with platform wall
 clock (again)
Date: Mon, 23 Dec 2013 15:25:41 -0800
Message-ID: <52B8C675.30204@zytor.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>	<1387448416-11672-1-git-send-email-jlee@suse.com>	<20131219104908.GE3145@console-pimps.org>	<1387459939.3539.4092.camel@linux-s257.site> <20131220112955.75e82a86@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20131220112955.75e82a86@alan.etchedpixels.co.uk>
Sender: linux-acpi-owner@vger.kernel.org
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>
Cc: Matt Fleming <matt@console-pimps.org>, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On 12/20/2013 03:29 AM, One Thousand Gnomes wrote:
> On Thu, 19 Dec 2013 21:32:19 +0800
> joeyli <jlee@suse.com> wrote:
>=20
>> =E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 10:49 +0000=EF=BC=8C=
Matt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
>>> On Thu, 19 Dec, at 06:20:16PM, Lee, Chun-Yi wrote:
>>>> From: Jan Beulich <JBeulich@suse.com>
>>>>
>>>> Other than ix86, x86-64 on EFI so far didn't set the
>>>> {g,s}et_wallclock accessors to the EFI routines, thus
>>>> incorrectly using raw RTC accesses instead.
>=20
> Probably wise.
>=20
> Before anyone reverts that please make sure it also works on EFI32,
> because right now we crash and burn on multiple EFI32 tablets queryin=
g
> the time.
>=20

Quite -- we in fact did just the opposite (checkin 04bf9ba720fc).

	-hpa

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
