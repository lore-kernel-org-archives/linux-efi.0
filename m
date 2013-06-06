From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Thu, 06 Jun 2013 15:40:26 +0800
Message-ID: <1370504426.6523.49.camel@linux-s257.site>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
	 <1370495110.6523.35.camel@linux-s257.site>
	 <1370497321.6315.44.camel@x230.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370497321.6315.44.camel-+5W/JHIUVxg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "rja-sJ/iWh9BUns@public.gmane.org" <rja-sJ/iWh9BUns@public.gmane.org>, "mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "jkosina-AlSwsSmVLrQ@public.gmane.org" <jkosina-AlSwsSmVLrQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-06-06 =E6=96=BC 05:42 +0000=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 2013-06-06 at 13:05 +0800, joeyli wrote:
>=20
> > +		if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
> > +			return EFI_OUT_OF_RESOURCES;
>=20
> I'd move this up to the top of the function, and just return 0 - ther=
e's
> no risk of the firmware causing problems if it's a volatile variable,=
 so
> we should probably just pass it down to the firmware and return an er=
ror
> from there.
>=20

OK, I moved volatile checking to the top of the function.
New version, version 3 diff result like the following.


Thanks a lot for reviewing
Joey Lee

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cc3cfe8..5ae2eb0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -53,6 +53,8 @@
=20
 #define EFI_DEBUG	1
=20
+#define EFI_MIN_RESERVE 5120
+
 #define EFI_DUMMY_GUID \
 	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x=
9f, 0x92, 0xa9)
=20
@@ -988,7 +990,11 @@ void __init efi_enter_virtual_mode(void)
 	kfree(new_memmap);
=20
 	/* clean DUMMY object */
-	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
 }
=20
 /*
@@ -1040,6 +1046,9 @@ efi_status_t efi_query_variable_store(u32 attribu=
tes, unsigned long size)
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
=20
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
 	status =3D efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status !=3D EFI_SUCCESS)
@@ -1051,7 +1060,9 @@ efi_status_t efi_query_variable_store(u32 attribu=
tes, unsigned long size)
 	 * write if permitting it would reduce the available space to under
 	 * 5KB. This figure was provided by Samsung, so should be safe.
 	 */
-	if ((remaining_size - size < 5120) && !efi_no_storage_paranoia) {
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
 		/*
 		 * Triggering garbage collection may require that the firmware
 		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
@@ -1061,7 +1072,10 @@ efi_status_t efi_query_variable_store(u32 attrib=
utes, unsigned long size)
 		void *dummy =3D kmalloc(dummy_size, GFP_ATOMIC);
=20
 		status =3D efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					  attributes, dummy_size, dummy);
+					  EFI_VARIABLE_NON_VOLATILE |
+					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					  EFI_VARIABLE_RUNTIME_ACCESS,
+					  dummy_size, dummy);
=20
 		if (status =3D=3D EFI_SUCCESS) {
 			/*
@@ -1069,7 +1083,10 @@ efi_status_t efi_query_variable_store(u32 attrib=
utes, unsigned long size)
 			 * that we delete it...
 			 */
 			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					 attributes, 0, dummy);
+					 EFI_VARIABLE_NON_VOLATILE |
+					 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					 EFI_VARIABLE_RUNTIME_ACCESS,
+					 0, dummy);
 		}
=20
 		/*
@@ -1085,7 +1102,7 @@ efi_status_t efi_query_variable_store(u32 attribu=
tes, unsigned long size)
 		/*
 		 * There still isn't enough room, so return an error
 		 */
-		if (remaining_size - size < 5120)
+		if (remaining_size - size < EFI_MIN_RESERVE)
 			return EFI_OUT_OF_RESOURCES;
 	}
=20
