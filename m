From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 5 Dec 2017 11:27:58 +0100
Message-ID: <20171205102757.GA12982@amd>
References: <20171109044619.GG7859@linaro.org>
 <20171111023240.2398ca55@alans-desktop>
 <20171113174250.GA22894@wotan.suse.de>
 <20171113210848.4dc344bd@alans-desktop>
 <454.1510609487@warthog.procyon.org.uk>
 <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
 <1510662098.3711.139.camel@linux.vnet.ibm.com>
 <CA+55aFzvuvqOfsJ9arzcc1QbTGs+U-TsNmsyem9UAVVQC8YkZQ@mail.gmail.com>
 <CACdnJuvP=0AHGtfGJ5+cT+kHRy3fU4BLjwkvzP0rLO6q5ejAQQ@mail.gmail.com>
 <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFxeLwgwxh2iJTf6Dz0T_a_TZfTdhBw5TkcSsCmjt2N5pw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Our ability to determine that userland hasn't been tampered with
> > depends on the kernel being trustworthy. If userland can upload
> > arbitrary firmware to DMA-capable devices then we can no longer trust
> > the kernel. So yes, firmware is special.
>=20
> You're ignoring the whole "firmware is already signed by the hardware
> manufacturer and we don't even have access to it" part.

Well... I guess we'd prefer the firmware _not_ be signed, so we can
fix security holes in that after the vendor lost interest... Bugs in
the wifi stacks seemed patcheable that way.

There is GPLed firmware available for some USB wifi's. We really
should make sure firmware signing is not mandatory/encouraged for the hw ve=
ndors.

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlomdK0ACgkQMOfwapXb+vIV5QCfbLTfDRPpmSyNW4zBd5NcDz4a
tvIAoKPxjwRKC28Ol6pYiZHKmy33UtNS
=rkvs
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
