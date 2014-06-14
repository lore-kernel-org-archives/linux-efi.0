From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] x86, eboot: Support initrd loaded above 4G
Date: Sat, 14 Jun 2014 12:23:41 -0700
Message-ID: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For boot efi kernel directly without bootloader.
If the kernel support XLF_CAN_BE_LOADED_ABOVE_4G, we should
not limit initrd under hdr->initrd_add_max.

Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
 arch/x86/boot/compressed/eboot.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/boot/compressed/eboot.c
===================================================================
--- linux-2.6.orig/arch/x86/boot/compressed/eboot.c
+++ linux-2.6/arch/x86/boot/compressed/eboot.c
@@ -1038,6 +1038,7 @@ struct boot_params *make_boot_params(str
 	int i;
 	unsigned long ramdisk_addr;
 	unsigned long ramdisk_size;
+	unsigned long initrd_addr_max;
 
 	efi_early = c;
 	sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
@@ -1100,14 +1101,21 @@ struct boot_params *make_boot_params(str
 
 	memset(sdt, 0, sizeof(*sdt));
 
+	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
+		initrd_addr_max = -1UL;
+	else
+		initrd_addr_max = hdr->initrd_addr_max;
+
 	status = handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
-				      "initrd=", hdr->initrd_addr_max,
+				      "initrd=", initrd_addr_max,
 				      &ramdisk_addr, &ramdisk_size);
 	if (status != EFI_SUCCESS)
 		goto fail2;
-	hdr->ramdisk_image = ramdisk_addr;
-	hdr->ramdisk_size = ramdisk_size;
+	hdr->ramdisk_image = ramdisk_addr & 0xffffffff;
+	hdr->ramdisk_size  = ramdisk_size & 0xffffffff;
+	boot_params->ext_ramdisk_image = (u64)ramdisk_addr >> 32;
+	boot_params->ext_ramdisk_size  = (u64)ramdisk_size >> 32;
 
 	return boot_params;
 fail2:
