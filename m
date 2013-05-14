From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] efivarfs: Never return ENOENT from firmware again
Date: Tue, 14 May 2013 16:32:26 +0800
Message-ID: <1368520346.21417.180.camel@linux-s257.site>
References: <5b6476bf31dc699a0e6f3983e78447eeac34d831.1368180585.git.lxiang@redhat.com>
	 <51913D4B.2000606@intel.com> <1368506197.21417.172.camel@linux-s257.site>
	 <5191E4E0.7020505@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5191E4E0.7020505@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>
Cc: Lingzhu Xiang <lxiang@redhat.com>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garrett <matthew.garrett@nebula.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>, Andy Whitcroft <apw@canonical.com>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-05-14 =E6=96=BC 08:16 +0100=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On 05/14/2013 05:36 AM, joeyli wrote:
> > I found the "[PATCH] x86, efi: initial the local variable of DataSi=
ze to
> > zero" lost in urgent branch, and it also didn't in Linus's v3.10-rc=
1.
> >=20
> > Did this patch move to other branch?
>=20
> It appears I dropped this patch when doing the rebase against -rc1. I=
'm
> really sorry about that. I've applied it again.

Thanks for your help!

>=20
> Thanks for being so diligent.
> --

That because I need apply this patch on v3.9 and v3.10 when debugging
issue on Acer machine.


Thank a lot!
Joey Lee
