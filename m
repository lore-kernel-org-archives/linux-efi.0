From: Matt Fleming <matt@console-pimps.org>
Subject: Re: Loading initrd above 4G causes freeze on boot
Date: Wed, 13 Aug 2014 19:44:49 +0100
Message-ID: <20140813184449.GV15082@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
 <20140809192302.GJ15082@console-pimps.org>
 <CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
 <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
 <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
 <20140813140219.GP15082@console-pimps.org>
 <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPWNY8WdA+Q+WjXirGOsrYjMGp+69sCqYa8ST7_owQeVhQkT0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, 13 Aug, at 07:38:14PM, Mantas Mikul=C4=97nas wrote:
>=20
> Here you go.
>=20
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000137ffffff]=
 usable

[...]

> [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x00000001=
37ffffff] usable

[...]

> [    0.000000] efi: mem201: type=3D7, attr=3D0xf, range=3D[0x00000001=
00000000-0x0000000138000000) (896MB)

Nothing crazy here, unless we're getting the calculation wrong and
reading past the buffer, the code looks OK though. Or something like th=
e
last page or so of that memory isn't actually free even though the
firmware tells us it is.

At this point, I think modifying the max address is the best way to
debug this further, and figure out what address causes the hang.

--=20
Matt Fleming, Intel Open Source Technology Center
