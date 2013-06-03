From: joeyli <jlee@suse.com>
Subject: Re: [PATCH] Modify UEFI anti-bricking code
Date: Tue, 04 Jun 2013 00:13:40 +0800
Message-ID: <1370276021.30695.4.camel@linux-s257.site>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: rja@sgi.com, mingo@kernel.org, torvalds@linux-foundation.org, bp@alien8.de, jkosina@suse.cz, matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com, akpm@linux-foundation.org, oneukum@suse.de
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=85=AD=EF=BC=8C2013-06-01 =E6=96=BC 16:06 -0400=EF=BC=8CMa=
tthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> +               unsigned long dummy_size =3D remaining_size + 1024;
> +               void *dummy =3D kmalloc(dummy_size, GFP_ATOMIC);
> +               efi_char16_t efi_name[6] =3D { 'D', 'U', 'M', 'M', 'Y=
', 0 };
> +               efi_guid_t guid =3D EFI_GUID(0x4424ac57, 0xbe4b, 0x47=
dd, 0x9e,
> +                                          0x97, 0xed, 0x50, 0xf0, 0x=
9f, 0x92,
> +                                          0xa9);
> +
> +               status =3D efi.set_variable(efi_name, &guid, attribut=
es,
> +                                         dummy_size, dummy);
> +
> +               if (status =3D=3D EFI_SUCCESS) {
> +                       /*
> +                        * This should have failed, so if it didn't m=
ake sure
> +                        * that we delete it...
> +                        */
> +                       efi.set_variable(efi_name, &guid, attributes,=
 0,
> +                                        dummy);
> +               }=20

Oliver raised a question for if power fails between that succesful
attempt and the deletion?

Due to the create/delete operating are not atomic, I think that will be
better we try to delete DUMMY object in efi_enter_virtual_mode() or whe=
n
efivars initial.

The following diff tested on OVMF for delete DUMMY object when system
boot, for reference.


Thanks a lot!
Joey Lee


diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 63e167a..72770b0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -861,6 +861,10 @@ void __init efi_enter_virtual_mode(void)
 	u64 end, systab, start_pfn, end_pfn;
 	void *p, *va, *new_memmap =3D NULL;
 	int count =3D 0;
+	efi_char16_t efi_name[6] =3D { 'D', 'U', 'M', 'M', 'Y', 0 };
+	efi_guid_t guid =3D EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e,
+				   0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92,
+				   0xa9);
=20
 	efi.systab =3D NULL;
=20
@@ -981,6 +985,9 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
=20
 	kfree(new_memmap);
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_name, &guid, 0, 0, NULL);
 }
=20
 /*
