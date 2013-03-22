From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH] efivars: Fix check for
 CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE
Date: Fri, 22 Mar 2013 19:56:51 +0000
Message-ID: <1363982211.3728.38.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oD434DXM5N1QxO9fHWRr"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-oD434DXM5N1QxO9fHWRr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The 'CONFIG_' prefix is not implicit in IS_ENABLED().

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
 drivers/firmware/efivars.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index d64661f..7acafb8 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -104,7 +104,7 @@ MODULE_VERSION(EFIVARS_VERSION);
 #define GUID_LEN 36
=20
 static bool efivars_pstore_disable =3D
-	IS_ENABLED(EFI_VARS_PSTORE_DEFAULT_DISABLE);
+	IS_ENABLED(CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE);
=20
 module_param_named(pstore_disable, efivars_pstore_disable, bool, 0644);
=20


--=-oD434DXM5N1QxO9fHWRr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUy3g+e/yOyVhhEJAQqaLQ//Rxtq1snJPgpsuHu00sreUr+tVQutp/Hy
trzdCtNcSLfOtGcnAg5AS4sIkqYC/eeoDMqF4eNrbwvJEvChOGIJA2KTK0wLFaqF
eYU5FbnLhJMD+uNweBEMYD3AO0kemxs0FNq+F94WDNmDfDKCYmHaAQGCg9ce6mKh
GTx+NwBeql54Wh91zyR6EESswqEjCT4zREy6OzfZTRzUksMCN0h15cDfiVdpq8fj
f2+8oHYC/mjJQUM9aQYYMqBDqowK3FS+2zwaj1wfEypE7uv6Yz2kBdtdb2u2qdWH
QLNAC0vJTWMq/bEhOOrxe2ZtDBs9DgNp1N2hIHJ4jX7AgSDueRfDIMTZpLwaahrK
dQrQPobnk602g6TrTg9qw9tZR/xV9s3XtnRLo1DsAmH4bHBPHhfRXrc9zolH78GV
q/V0MPgLvFqx75uSlKEAVhRBdX1Wl3B4oSXu9nrA1EJZ7oD6XVZoVOJQodXX/cgx
hWLkbMLz+Vnx8P4jBYW0DpFPp6JhbLO6uaKnQvzBJQ1ei6z1BCRWe0DjvdyPx4Ol
F+/hGKhXriLg3vobRZ859mfQUTnUlTvojvAjxeog+e7WY/eFCYq8AEe5JluiSowc
es+aeiXewtCcthhjg5qbU9HUiviyP6BSL4CJrQxq69ADeCnB2fainCddz4eSoqBz
H6sJCUOQxhc=
=PRGB
-----END PGP SIGNATURE-----

--=-oD434DXM5N1QxO9fHWRr--
