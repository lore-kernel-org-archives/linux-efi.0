From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: fix multiple GOP device support
Date: Wed, 7 Oct 2015 21:48:37 +0100
Message-ID: <20151007204837.GB3249@codeblueprint.co.uk>
References: <fce1886dc0b07f374eb49a13746df5e47518d338.1442666763.git.DirtY.iCE.hu@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <fce1886dc0b07f374eb49a13746df5e47518d338.1442666763.git.DirtY.iCE.hu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?B?S8WRdsOhZ8OzLCBab2x0w6Fu?= <dirty.ice.hu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 19 Sep, at 03:40:23PM, K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n wrote=
:
> When multiple GOP devices exists, but none of them implements ConOut,
> the code should just choose the first GOP (according to the comments)=
=2E
> But currently fb_base will refer to the last GOP, while other paramet=
ers
> to the first GOP, which will likely result in a garbled display.
>=20
> Signed-off-by: K=C5=91v=C3=A1g=C3=B3, Zolt=C3=A1n <DirtY.iCE.hu@gmail=
=2Ecom>
> ---
>=20
> I can reliably reproducible this bug using my ASRock Z87M Extreme4
> motherboard with CSM and integrated GPU disabled, and two PCIe video
> cards (NVidia GT640 and GTX980), booting from efi-stub (booting from
> grub works fine).  On the primary display the asrock logo remains and=
 on
> the secondary screen is garbled up completely.
>=20
>  arch/x86/boot/compressed/eboot.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
=20
Sorry for the delay. I've applied this now to the urgent queue.

The reproduction details under the "---" are so useful that I've moved
them into the commit message proper.

Thanks!

--=20
Matt Fleming, Intel Open Source Technology Center
