From: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [patch 3/4 v3] Add efi_info in x86 setup header
Date: Thu, 21 Nov 2013 14:40:46 +0800
Message-ID: <20131121064125.574692044@dhcp-16-126.nay.redhat.com>
References: <20131121064043.969000753@dhcp-16-126.nay.redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=02-kexec-padd-efi_info.patch
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For supporting efi runtime on kexec kernel we need to
fill the efi_info struct in setup_header. I just get
the info in kernel exported boot_params data in debugfs.

v1->v2:
update comment for offset of reserved4_1[] in x87_linux_param_header
Address comment from mjg59: do not break old kernel when use newer kexec-tools.
  add checking for xloadflags bit 4 XLF_EFI_KEXEC. Only fill
  efi_info and pass acpi_rsdp when the kexec kernel support efi boot.
coding style fix, change internal function to be static

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/x86/x86-linux.h             |    3 ++-
 kexec/arch/i386/crashdump-x86.c     |    4 +++-
 kexec/arch/i386/x86-linux-setup.c   |    9 +++++++++
 kexec/arch/i386/x86-linux-setup.h   |    1 +
 kexec/arch/x86_64/kexec-bzImage64.c |    6 ++++++
 5 files changed, 21 insertions(+), 2 deletions(-)

--- kexec-tools.orig/include/x86/x86-linux.h
+++ kexec-tools/include/x86/x86-linux.h
@@ -113,7 +113,8 @@ struct x86_linux_param_header {
 	uint32_t ext_ramdisk_image;		/* 0xc0 */
 	uint32_t ext_ramdisk_size;		/* 0xc4 */
 	uint32_t ext_cmd_line_ptr;		/* 0xc8 */
-	uint8_t reserved4_1[0x1e0 - 0xcc];	/* 0xcc */
+	uint8_t reserved4_1[0x1c0 - 0xcc];	/* 0xe4 */
+	uint8_t efi_info[32];			/* 0x1c0 */
 	uint32_t alt_mem_k;			/* 0x1e0 */
 	uint8_t  reserved5[4];			/* 0x1e4 */
 	uint8_t  e820_map_nr;			/* 0x1e8 */
--- kexec-tools.orig/kexec/arch/i386/x86-linux-setup.c
+++ kexec-tools/kexec/arch/i386/x86-linux-setup.c
@@ -480,6 +480,13 @@ void setup_subarch(struct x86_linux_para
 	get_bootparam(&real_mode->hardware_subarch, offset, sizeof(uint32_t));
 }
 
+static void setup_efi_info(struct x86_linux_param_header *real_mode)
+{
+	off_t offset = offsetof(typeof(*real_mode), efi_info);
+
+	get_bootparam(&real_mode->efi_info, offset, 32);
+}
+
 void setup_linux_system_parameters(struct kexec_info *info,
 				   struct x86_linux_param_header *real_mode)
 {
@@ -489,6 +496,8 @@ void setup_linux_system_parameters(struc
 
 	/* get subarch from running kernel */
 	setup_subarch(real_mode);
+	if (bzImage_support_efi_boot)
+		setup_efi_info(real_mode);
 	
 	/* Default screen size */
 	real_mode->orig_x = 0;
--- kexec-tools.orig/kexec/arch/i386/crashdump-x86.c
+++ kexec-tools/kexec/arch/i386/crashdump-x86.c
@@ -41,6 +41,7 @@
 #include "../../crashdump.h"
 #include "kexec-x86.h"
 #include "crashdump-x86.h"
+#include "x86-linux-setup.h"
 
 #ifdef HAVE_LIBXENCTRL
 #ifdef HAVE_XC_GET_MACHINE_MEMORY_MAP
@@ -1046,7 +1047,8 @@ int load_crashdump_segments(struct kexec
 	if (delete_memmap(memmap_p, elfcorehdr, memsz) < 0)
 		return -1;
 	cmdline_add_memmap(mod_cmdline, memmap_p);
-	cmdline_add_efi(mod_cmdline);
+	if (!bzImage_support_efi_boot)
+		cmdline_add_efi(mod_cmdline);
 	cmdline_add_elfcorehdr(mod_cmdline, elfcorehdr);
 
 	/* Inform second kernel about the presence of ACPI tables. */
--- kexec-tools.orig/kexec/arch/i386/x86-linux-setup.h
+++ kexec-tools/kexec/arch/i386/x86-linux-setup.h
@@ -29,5 +29,6 @@ void setup_linux_system_parameters(struc
 
 /* command line parameter may be appended by purgatory */
 #define PURGATORY_CMDLINE_SIZE 64
+extern int bzImage_support_efi_boot;
 
 #endif /* X86_LINUX_SETUP_H */
--- kexec-tools.orig/kexec/arch/x86_64/kexec-bzImage64.c
+++ kexec-tools/kexec/arch/x86_64/kexec-bzImage64.c
@@ -42,6 +42,7 @@
 #include <arch/options.h>
 
 static const int probe_debug = 0;
+int bzImage_support_efi_boot;
 
 int bzImage64_probe(const char *buf, off_t len)
 {
@@ -82,6 +83,11 @@ int bzImage64_probe(const char *buf, off
 		/* Must be KERNEL_64 and CAN_BE_LOADED_ABOVE_4G */
 		return -1;
 	}
+
+#define XLF_EFI_KEXEC   (1 << 4)
+	if ((header->xloadflags & XLF_EFI_KEXEC) == XLF_EFI_KEXEC)
+		bzImage_support_efi_boot = 1;
+
 	/* I've got a relocatable bzImage64 */
 	if (probe_debug)
 		fprintf(stderr, "It's a relocatable bzImage64\n");
