From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] x86: only load initrd above 4g on second try
Date: Tue, 26 Aug 2014 14:45:44 -0700
Message-ID: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
loaded above 4G"), the kernel freezes at the earliest possible moment
when trying to boot via UEFI on Asus laptop.

There are buggy EFI implementations: with EFI run time, kernel need
to load file with 512bytes alignment when buffer is above 4G.

So revert to old way to load initrd on first try,
second try will use above 4G buffer when initrd is more than
2G and does not fit under 4G.

Reported-by: Mantas Mikul=C4=97nas <grawity-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Anders Darander <anders-7UjN0b3lYz2SbKU13Z4Etw@public.gmane.org>
Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
 arch/x86/boot/compressed/eboot.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/boot/compressed/eboot.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/arch/x86/boot/compressed/eboot.c
+++ linux-2.6/arch/x86/boot/compressed/eboot.c
@@ -1032,7 +1032,6 @@ struct boot_params *make_boot_params(str
 	int i;
 	unsigned long ramdisk_addr;
 	unsigned long ramdisk_size;
-	unsigned long initrd_addr_max;
=20
 	efi_early =3D c;
 	sys_table =3D (efi_system_table_t *)(unsigned long)efi_early->table;
@@ -1095,15 +1094,18 @@ struct boot_params *make_boot_params(str
=20
 	memset(sdt, 0, sizeof(*sdt));
=20
-	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
-		initrd_addr_max =3D -1UL;
-	else
-		initrd_addr_max =3D hdr->initrd_addr_max;
-
 	status =3D handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
-				      "initrd=3D", initrd_addr_max,
+				      "initrd=3D", hdr->initrd_addr_max,
+				      &ramdisk_addr, &ramdisk_size);
+
+	if (status !=3D EFI_SUCCESS &&
+	    hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
+		status =3D handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=3D", -1UL,
 				      &ramdisk_addr, &ramdisk_size);
+
 	if (status !=3D EFI_SUCCESS)
 		goto fail2;
 	hdr->ramdisk_image =3D ramdisk_addr & 0xffffffff;
