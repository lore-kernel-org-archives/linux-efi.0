From: Matt Fleming <matt@console-pimps.org>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Date: Tue, 5 Aug 2014 16:07:37 +0100
Message-ID: <20140805150737.GR15082@console-pimps.org>
References: <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
 <20140805084542.GM15082@console-pimps.org>
 <20140805111330.3cf9319f@pluto>
 <20140805091848.GN15082@console-pimps.org>
 <20140805135130.2d180b69@pluto>
 <20140805141142.437ecb17@pluto>
 <20140805125548.GP15082@console-pimps.org>
 <20140805162107.4698f717@pluto>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140805162107.4698f717@pluto>
Sender: linux-kernel-owner@vger.kernel.org
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 05 Aug, at 04:21:07PM, Bruno Pr=E9mont wrote:
>=20
> Thanks, enabling CONFIG_RELOCATABLE allows kernel to successfully boo=
t!
>=20
> So you can add my tested-by to the patch.
=20
Great, thanks for testing! I've tagged the patch for stable and I'll ge=
t
it sent to tip quickly.

> If of interest, memory layout information as reported by 3.16 with
> CONFIG_RELOCATABLE enabled:

[...]

> [    0.000000] efi: mem06: type=3D2, attr=3D0xf, range=3D[0x000000000=
1000000-0x0000000001100000) (1MB)

Bingo, this is likely to be the reason for the resets.

Overwriting EFI_LOADER_DATA regions (well, any region other than
EFI_CONVENTIONAL_MEMORY) is gonna cause some issues.

--=20
Matt Fleming, Intel Open Source Technology Center
