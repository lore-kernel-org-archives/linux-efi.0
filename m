From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: linux-next: Tree for Apr 26
Date: Mon, 29 Apr 2013 09:36:28 +1000
Message-ID: <20130429093628.b739ef3b879b6f8759bd31af@canb.auug.org.au>
References: <20130426180357.7599d1b6b7965470905dcdf3@canb.auug.org.au>
	<CAMuHMdWQ0rMuoH+peGMZ3=AdsYrMPpeV4_vSsLD3kaJukx=83w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_09_36_28_+1000_dEW_lY6F6I/=XZBT"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAMuHMdWQ0rMuoH+peGMZ3=AdsYrMPpeV4_vSsLD3kaJukx=83w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Linux-Next <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

--Signature=_Mon__29_Apr_2013_09_36_28_+1000_dEW_lY6F6I/=XZBT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sat, 27 Apr 2013 19:06:53 +0200 Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org=
> wrote:
>
> ia64-defconfig:
>=20
> (.text+0x3956a2): undefined reference to `ucs2_strsize'
> (.text+0x395f82): undefined reference to `ucs2_strsize'
> (.text+0x395fa2): undefined reference to `ucs2_strsize'
> (.text+0x396222): undefined reference to `ucs2_strsize'
> (.text+0x396562): undefined reference to `ucs2_strsize'
> drivers/built-in.o:(.text+0x396722): more undefined references to
> `ucs2_strsize' follow
> vars.c:(.text+0x3975a2): undefined reference to `ucs2_strnlen'
> vars.c:(.text+0x3976f2): undefined reference to `ucs2_strsize'
> efivars.c:(.text+0x398b92): undefined reference to `ucs2_strlen'
> make[1]: *** [vmlinux] Error 1
>=20
> http://kisskb.ellerman.id.au/kisskb/buildresult/8629073/
>=20
> It seems to "select UCS2_STRING" introduced by commit
> 0635eb8a54cf0fea64b174bb68bc36b9c3d622db ("Move utf16 functions to
> kernel core and rename") got lost in the drivers/firmware/{=3D> efi}/Kcon=
fig
> move from commit 048517722cde2595a7366d0c3c72b8b1ec142a9c
> ("efivars: Move pstore code into the new EFI directory")
>=20
> Don't know who did the mismerge.

Commit e29c2de5f591 ("Merge tag 'v3.9-rc8' into efi-for-tip") by Matt
Fleming from the tip tree merged v3.9-rc8 (which has 0635eb8a54cf) with
the branch that contains 048517722cde but lost the "select UCS2_STRING"
which should be in drivers/firmware/efi/Kconfig.

--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org

P.S. Geert, please trim your replies.

--Signature=_Mon__29_Apr_2013_09_36_28_+1000_dEW_lY6F6I/=XZBT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfbJ8AAoJEECxmPOUX5FEGaEP/j19g3DuExraOTY0WvZEHm7g
C3SeiuFgTL/3B/yt8tLTcRm31II73m/2mOopL5YUIvdjFZ/JIo0A0V0va1R18O3G
pChfiafSvFW9Tq6FZwiWKk4WKm5wmFHYYiScT5HZ3Q6jEHi1KLkuprd4mUERhNNr
27TrUHH1WAWpceR21Lq6gsE8mIJ8JlMKdGce92AXlVDVKWM/WAlA3bXR/Z5r0LSX
ZYva9cAsBAVXrUR78uZkGVxvTRb5XYs2YTqBotl82hOwVIiLEUsYVIrlyegUlxUC
oHJ5URg6u7q6daOV5jzi6W7CpcXrt/rM8fr1uRBb/in6pmhSAvf1POx568XVupv0
Wk1ZBBu9s/X6ADmdGx3odKXJyKhdH+LtAX2t0+gTxXrRgJo/j59WRExQiTug7EvZ
50XOVcLyR6u68kGACoKsBEWAp+mtQ08CToLgQP8nM/I/T6JZXZ6Sb9FDIiyD/Hkc
JyFEgvsS9Kw04MIi+usoNubuBmL0hIMiYrhZKm+s8LDt+bvqGb4W+/LbbYH3+fQU
+at16bYGRaGW8tb1a2EJWoZ7iKFgyHGdNwVP6L1/iuEC1aoRzFAor4YYTJPh1yCt
nlEH6Y0pP72j8KBflHvs9YE8K65GYEPM02VI9vDXZZEIPfm3f+671P7blSfW1d7F
H5B0P/ZCGZ0CzmEsvkwX
=hnPY
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_09_36_28_+1000_dEW_lY6F6I/=XZBT--
