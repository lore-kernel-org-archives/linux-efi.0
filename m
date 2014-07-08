From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: Re: [PATCH] x86/efi: autoload efivars
Date: Tue, 08 Jul 2014 13:19:42 +0100
Message-ID: <1404821982.2489.8.camel@deadeye.wl.decadent.org.uk>
References: <1404788458-32105-1-git-send-email-jlee@suse.com>
	 <20140708101434.GF27474@console-pimps.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-e9FZ+CyaNDKNFMQA4vJF"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140708101434.GF27474-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--=-e9FZ+CyaNDKNFMQA4vJF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-07-08 at 11:14 +0100, Matt Fleming wrote:
> On Tue, 08 Jul, at 11:00:58AM, Lee, Chun-Yi wrote:
[...]
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -44,6 +44,7 @@
> >  #include <linux/io.h>
> >  #include <linux/reboot.h>
> >  #include <linux/bcd.h>
> > +#include <linux/platform_device.h>
> > =20
> >  #include <asm/setup.h>
> >  #include <asm/efi.h>
> > @@ -780,6 +781,20 @@ void __init efi_late_init(void)
> >  	efi_bgrt_init();
> >  }
> > =20
> > +#ifdef CONFIG_EFI_VARS_MODULE
> > +static int __init efi_load_efivars(void)
> > +{
> > +	struct platform_device *pdev;
> > +
> > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > +		return 0;
> > +
> > +	pdev =3D platform_device_register_simple("efivars", 0, NULL, 0);
> > +	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
> > +}
> > +device_initcall(efi_load_efivars);
> > +#endif
> > +
>=20
> Could this be moved to drivers/firmware/efi/efi.c? That way the arm64
> folks could benefit from it too.

It seems like that should work now that efi_enabled() is not specific to
x86.

Ben.

> >  void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
> >  {
> >  	u64 addr, npages;
> > diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efiv=
ars.c
> > index 463c565..f256ecd 100644
> > --- a/drivers/firmware/efi/efivars.c
> > +++ b/drivers/firmware/efi/efivars.c
> > @@ -78,6 +78,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
> >  MODULE_DESCRIPTION("sysfs interface to EFI Variables");
> >  MODULE_LICENSE("GPL");
> >  MODULE_VERSION(EFIVARS_VERSION);
> > +MODULE_ALIAS("platform:efivars");
> > =20
> >  LIST_HEAD(efivar_sysfs_list);
> >  EXPORT_SYMBOL_GPL(efivar_sysfs_list);
> > --=20
> > 1.8.4.5
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=20
Ben Hutchings
Any smoothly functioning technology is indistinguishable from a rigged demo=
.

--=-e9FZ+CyaNDKNFMQA4vJF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU7vh4+e/yOyVhhEJAQqRehAAvTbqo2oFK+Zl+xDiVc0BccET2E7ghK60
+uKuKvTLbuo80bdKGK0Zd2Wtqo+TbyJwrMN6CSSfirerh51TRWcw1xKMGq0tGQ5s
Vg6czR6wfJ10BYN3s08yYl2KgLEwa5h5ms5hqANwkJUsgEmQT2V+PefVL5RVTBIM
yq6yJzRfFffsGvnGwfNtTO08SolXa8977mtoA+Tq2vo9cca1gM8Fb16kgSmT7yUD
BN1dZ8XJX/xzw7nXI+jJrphs+VtcxGN379sDfJaV8s512afNXbwSMCzwREDTm6vb
mof8zPPujyKCJS8LMmfCgh99i0k0AwXzXwyHazwkaa5lqaTKisZaPMG9SwYYsbiv
PsJnbZyBnqABBhexV3AergDDq/qhm1t0jdmPKzI5K/ytr4gaBlnR6MS2oE5lu0mQ
wvCJKrQx0OxzcCAVKutX1UxnwTndCR0xoDGQ48my3+1+aavq+OBNRAfTeGSiQTV4
S8vkK4D/NFpRgaejyyBv8rgb95WJzPUjOvUe6efNLaPrlwQ75BIwOGpVuRYFOSBw
oQpHsTfFGaeE6awiLlgGiccMpxwMNDs++2SULlQjBwmbKni8dPJJ2Bq+7Wz27ZTJ
MkWWdygB47zej6KzSanhaVzjrzuFEVp9/AV1Xg/7uyWjUk9VidWkSbz1paQ8C4jO
v66Yteczs/Y=
=UYlp
-----END PGP SIGNATURE-----

--=-e9FZ+CyaNDKNFMQA4vJF--
