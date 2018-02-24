From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] fix double ;;s in code
Date: Sat, 24 Feb 2018 09:52:27 +0100
Message-ID: <20180224085227.GA12996@amd>
References: <20180217211955.GE9640@amd>
 <20180222090932.GJ3217@dragon>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1757324298=="
Return-path: <dri-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20180222090932.GJ3217@dragon>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/dri-devel>
List-Post: <mailto:dri-devel@lists.freedesktop.org>
List-Help: <mailto:dri-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/dri-devel>,
 <mailto:dri-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: dri-devel-bounces@lists.freedesktop.org
Sender: "dri-devel" <dri-devel-bounces@lists.freedesktop.org>
To: Shawn Guo <shawnguo@kernel.org>
Cc: daniel.lezcano@linaro.org, narmstrong@baylibre.com, airlied@linux.ie, Alexey.Brodkin@synopsys.com, will.deacon@arm.com, fbarrat@linux.vnet.ibm.com, kernel list <linux-kernel@vger.kernel.org>, paulus@ozlabs.org, yamada.masahiro@socionext.com, mhocko@suse.com, viresh.kumar@linaro.org, hpa@zytor.com, JinHuiEric.Huang@amd.com, iommu@lists.linux-foundation.org, elfring@users.sourceforge.net, scott.bauer@intel.com, linux-arm-kernel@lists.infradead.org, mpe@ellerman.id.au, x86@kernel.org, Wenjing.Liu@amd.com, linux@armlinux.org.uk, amd-gfx@lists.freedesktop.org, Ding.Wang@amd.com, aik@ozlabs.ru, wens@csie.org, mingo@redhat.com, vbabka@suse.cz, catalin.marinas@arm.com, airlied@redhat.com, ruscur@russell.cc, shli@kernel.org, dan.carpenter@oracle.com, andresx7@gmail.com, linux-arm-msm@vger.kernel.org, linux-efi@vger.kernel.org, alistair@popple.id.au, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org


--===============1757324298==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > diff --git a/drivers/soc/imx/gpc.c b/drivers/soc/imx/gpc.c
> > index 53f7275..cfb42f5 100644
> > --- a/drivers/soc/imx/gpc.c
> > +++ b/drivers/soc/imx/gpc.c
> > @@ -348,7 +348,7 @@ static int imx_gpc_old_dt_init(struct device *dev, =
struct regmap *regmap,
> >  		if (i =3D=3D 1) {
> >  			domain->supply =3D devm_regulator_get(dev, "pu");
> >  			if (IS_ERR(domain->supply))
> > -				return PTR_ERR(domain->supply);;
> > +				return PTR_ERR(domain->supply);
> > =20
> >  			ret =3D imx_pgc_get_clocks(dev, domain);
> >  			if (ret)
> >=20
>=20
> Considering the controversy how the changes should be merged, I'm going
> to send a separate patch just for IMX GPC driver with a reported-by-you
> tag.  Thanks for catching this.

That works for me.

Alternatively... Andrew Morton merged the patch to his -mm tree
(thanks!), so you don't need to take any action, and it will be
eventually fixed.

If you merge your own version of the patch, that's ok, too, since
Andrew will just drop his version.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlqRJ8sACgkQMOfwapXb+vJnFQCfWSkka/liG8y+QlhIsWXlYlju
LMwAoKeeuJ1utbSPd+SNFlihXcdggiAP
=Ejo3
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--

--===============1757324298==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KZHJpLWRldmVs
IG1haWxpbmcgbGlzdApkcmktZGV2ZWxAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlz
dHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vZHJpLWRldmVsCg==

--===============1757324298==--
