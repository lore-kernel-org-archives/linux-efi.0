From: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Subject: [PATCH] x86/efi: Fix dummy variable buffer allocation
Date: Sun, 16 Jun 2013 21:27:12 +0100
Message-ID: <1371414432.3321.7.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-v9zmmgg7IoynKWtmMYTv"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


--=-v9zmmgg7IoynKWtmMYTv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

1. Check for allocation failure
2. Clear the buffer contents, as they may actually be written to flash
3. Don't leak the buffer

Compile-tested only.

Signed-off-by: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 arch/x86/platform/efi/efi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 5ae2eb0..d2fbced 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1069,7 +1069,10 @@ efi_status_t efi_query_variable_store(u32 attributes=
, unsigned long size)
 		 * that by attempting to use more space than is available.
 		 */
 		unsigned long dummy_size =3D remaining_size + 1024;
-		void *dummy =3D kmalloc(dummy_size, GFP_ATOMIC);
+		void *dummy =3D kzalloc(dummy_size, GFP_ATOMIC);
+
+		if (!dummy)
+			return EFI_OUT_OF_RESOURCES;
=20
 		status =3D efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
 					  EFI_VARIABLE_NON_VOLATILE |
@@ -1089,6 +1092,8 @@ efi_status_t efi_query_variable_store(u32 attributes,=
 unsigned long size)
 					 0, dummy);
 		}
=20
+		kfree(dummy);
+
 		/*
 		 * The runtime code may now have triggered a garbage collection
 		 * run, so check the variable info again


--=-v9zmmgg7IoynKWtmMYTv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUb4foOe/yOyVhhEJAQosUhAAg4ICFQA3a/zTQn/H25VwHo8FP1ccbwmw
u+P8SVFTvCGMxUkwAlP5NNeg43ZstuyFj7tK9pETF2YvCsFdrd4va3Em6zpiad4R
o9MTjdNLd6SbWGj7DUupJroB6PJp2OJG+u6Q+7G3S0CIM7OBTARYGOlTHZzgkna6
EedCALcrMVhaV+SQIQDwC1ZpK8rqbwUYHen/w17lvcjjmaN2/2OUbODz50qsJyr2
hLBke8j6Hs6204gbaiWDdQdyEsSDhEFv0ZuHKymRP402ZjpbaU3SIhN2UNuCGIoL
fOO9xgv0sja179kWn9IX8KbOsLffGTdNVI7ZBNIFKSegeZb74VYwmO95lH/zqQ44
Dh51uHsDtZk75U9AGntWUQZoCrXCt/zVpLPuWg7z9SKw65xpBLJB1yvwSyYqhc2T
VowIZmGDRmHeocvFa0xcY2brBWW9sEEenpLb/ifCquh8fcTfo+VxYySOZ0x23dfX
Xi+HO0wxs16Xqwh0Ck3IoC9XZ58vaS0OHLFJbvfrLtW/E6Ql8jRVdAtDcPJxpeRe
TAlqoSA9oTQ0HfjGHtv12yJRHRVFGUasUil8kUr+ibY5C5I+H2ciODmd30eLpK2w
KO/3WNAj+SAPl6x1DzCluhSziIijIEF1fFxi3/VbxygXj9Z0OIyKcAWEyl25VG6p
PsUEp4i9128=
=vSlI
-----END PGP SIGNATURE-----

--=-v9zmmgg7IoynKWtmMYTv--
