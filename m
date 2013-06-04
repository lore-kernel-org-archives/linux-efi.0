From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Tue, 04 Jun 2013 11:35:33 +0800
Message-ID: <1370316933.30695.7.camel@linux-s257.site>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370277079.6315.14.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "rja-sJ/iWh9BUns@public.gmane.org" <rja-sJ/iWh9BUns@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "jkosina-AlSwsSmVLrQ@public.gmane.org" <jkosina-AlSwsSmVLrQ@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=B8=80=EF=BC=8C2013-06-03 =E6=96=BC 16:31 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Tue, 2013-06-04 at 00:13 +0800, joeyli wrote:
>=20
> > Oliver raised a question for if power fails between that succesful
> > attempt and the deletion?
>=20
> It's a pretty tiny window, but sure. Making sure we delete it seems
> sensible. In that case we should make the GUID a #define rather than
> write it out twice.
>=20

Base on your patch, the following diff moved DUMMY GUID to #define, and
add a static efi name string:


Thanks a lot!
Joey Lee


diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 63e167a..cc3cfe8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -53,6 +53,11 @@
=20
 #define EFI_DEBUG	1
=20
+#define EFI_DUMMY_GUID \
+	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x=
9f, 0x92, 0xa9)
+
+static efi_char16_t efi_dummy_name[6] =3D { 'D', 'U', 'M', 'M', 'Y', 0=
 };
+
 struct efi __read_mostly efi =3D {
 	.mps        =3D EFI_INVALID_TABLE_ADDR,
 	.acpi       =3D EFI_INVALID_TABLE_ADDR,
@@ -981,6 +986,9 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
=20
 	kfree(new_memmap);
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
 }
=20
 /*
@@ -1051,21 +1059,17 @@ efi_status_t efi_query_variable_store(u32 attri=
butes, unsigned long size)
 		 */
 		unsigned long dummy_size =3D remaining_size + 1024;
 		void *dummy =3D kmalloc(dummy_size, GFP_ATOMIC);
-		efi_char16_t efi_name[6] =3D { 'D', 'U', 'M', 'M', 'Y', 0 };
-		efi_guid_t guid =3D EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e,
-					   0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92,
-					   0xa9);
=20
-		status =3D efi.set_variable(efi_name, &guid, attributes,
-					  dummy_size, dummy);
+		status =3D efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					  attributes, dummy_size, dummy);
=20
 		if (status =3D=3D EFI_SUCCESS) {
 			/*
 			 * This should have failed, so if it didn't make sure
 			 * that we delete it...
 			 */
-			efi.set_variable(efi_name, &guid, attributes, 0,
-					 dummy);
+			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					 attributes, 0, dummy);
 		}
=20
 		/*
