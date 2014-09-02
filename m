From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v3] x86: only load initrd above 4g on second try
Date: Tue,  2 Sep 2014 15:25:40 -0700
Message-ID: <1409696740-14981-1-git-send-email-yinghai@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Cc: =?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>, Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
loaded above 4G"), the kernel freezes at the earliest possible moment
when trying to boot via UEFI on Asus laptop.

Revert to old way to load initrd under 4G on first try,
second try will use above 4G buffer when initrd is too big
and does not fit under 4G.

-v2: add print out for second try, and print out files buf address.
-v3: can not snprintf

Reported-by: Mantas Mikul=C4=97nas <grawity@gmail.com>
Tested-by: Anders Darander <anders@chargestorm.se>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/boot/compressed/eboot.c               |   18 +++++++++++-----=
--
 drivers/firmware/efi/libstub/efi-stub-helper.c |    6 ++++++
 2 files changed, 17 insertions(+), 7 deletions(-)

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
@@ -1095,15 +1094,20 @@ struct boot_params *make_boot_params(str
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
 				      &ramdisk_addr, &ramdisk_size);
+
+	if (status !=3D EFI_SUCCESS &&
+	    hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G) {
+		efi_printk(sys_table, "Trying to load files to higher address\n");
+		status =3D handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=3D", -1UL,
+				      &ramdisk_addr, &ramdisk_size);
+	}
+
 	if (status !=3D EFI_SUCCESS)
 		goto fail2;
 	hdr->ramdisk_image =3D ramdisk_addr & 0xffffffff;
Index: linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ linux-2.6/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -396,6 +396,7 @@ efi_status_t handle_cmdline_files(efi_sy
=20
 	if (file_size_total) {
 		unsigned long addr;
+		char buf[64];
=20
 		/*
 		 * Multiple files need to be at consecutive addresses in memory,
@@ -416,6 +417,11 @@ efi_status_t handle_cmdline_files(efi_sy
 			goto free_file_total;
 		}
=20
+		memset(buf, 0, sizeof(buf));
+		sprintf(buf, "files buf: [%lx,%lx)\n", file_addr,
+					 file_addr + file_size_total);
+		efi_printk(sys_table_arg, buf);
+
 		addr =3D file_addr;
 		for (j =3D 0; j < nr_files; j++) {
 			unsigned long size;
