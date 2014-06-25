From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2 v2] efilinux: set ext_ramdisk_* for huge initrd
Date: Wed, 25 Jun 2014 14:24:27 -0700
Message-ID: <1403731467-1527-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We could load it high if it is more than 2G when kernel support
LOAD_ABOVE_4G.

-v2: Use macro instead of (1<<1) directly for LOAD_ABOVE_4G.

Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

---
 loaders/bzimage/bzimage.c |    9 ++++++++-
 loaders/bzimage/bzimage.h |   15 +++++++++++++--
 2 files changed, 21 insertions(+), 3 deletions(-)

Index: efilinux/loaders/bzimage/bzimage.c
===================================================================
--- efilinux.orig/loaders/bzimage/bzimage.c
+++ efilinux/loaders/bzimage/bzimage.c
@@ -130,7 +130,9 @@ static void parse_initrd(EFI_LOADED_IMAG
 	if (err != EFI_SUCCESS)
 		goto close_handles;
 
-	if ((UINTN)addr > boot_params->hdr.ramdisk_max) {
+	if ((boot_params->hdr.version < 0x20c ||
+	     !(boot_params->hdr.xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)) &&
+	    (UINTN)addr > boot_params->hdr.ramdisk_max) {
 		Print(L"ramdisk address is too high!\n");
 		efree(addr, size);
 		goto close_handles;
@@ -138,6 +140,11 @@ static void parse_initrd(EFI_LOADED_IMAG
 
 	boot_params->hdr.ramdisk_start = (UINT32)(UINTN)addr;
 	boot_params->hdr.ramdisk_len = (UINT32)size;
+	if (boot_params->hdr.version >= 0x20c &&
+	    (boot_params->hdr.xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)) {
+		boot_params->ext_ramdisk_image = (UINT64)(UINTN)addr >> 32;
+		boot_params->ext_ramdisk_size = size >> 32;
+	}
 
 	for (j = 0; j < nr_initrds; j++) {
 		struct initrd *rd = &initrds[j];
Index: efilinux/loaders/bzimage/bzimage.h
===================================================================
--- efilinux.orig/loaders/bzimage/bzimage.h
+++ efilinux/loaders/bzimage/bzimage.h
@@ -40,6 +40,13 @@
 #define E820_NVS		4
 #define E820_UNUSABLE		5
 
+/* xloadflags */
+#define XLF_KERNEL_64                   (1<<0)
+#define XLF_CAN_BE_LOADED_ABOVE_4G      (1<<1)
+#define XLF_EFI_HANDOVER_32             (1<<2)
+#define XLF_EFI_HANDOVER_64             (1<<3)
+#define XLF_EFI_KEXEC                   (1<<4)
+
 struct setup_header {
 	UINT8 setup_secs;	/* Sectors for setup code */
 	UINT16 root_flags;
@@ -69,7 +76,8 @@ struct setup_header {
 	UINT32 ramdisk_max;    /* Highest legal initrd address */
 	UINT32 kernel_alignment; /* Physical addr alignment required for kernel */
 	UINT8 relocatable_kernel; /* Whether kernel is relocatable or not */
-	UINT8 _pad2[3];
+	UINT8 min_alignment;
+	UINT16 xloadflags;
 	UINT32 cmdline_size;
 	UINT32 hardware_subarch;
 	UINT64 hardware_subarch_data;
@@ -148,7 +156,10 @@ struct boot_params {
 	UINT8 hd1_info[16];
 	UINT8 sys_desc_table[0x10];
 	UINT8 olpc_ofw_header[0x10];
-	UINT8 _pad4[128];
+	UINT32 ext_ramdisk_image;
+	UINT32 ext_ramdisk_size;
+	UINT32 ext_cmd_line_ptr;
+	UINT8 _pad4[116];
 	UINT8 edid_info[0x80];
 	struct efi_info efi_info;
 	UINT32 alt_mem_k;
