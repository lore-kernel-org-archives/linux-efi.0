From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI changes for v4.11
Date: Mon, 20 Feb 2017 10:40:17 +0100
Message-ID: <20170220094017.GA9846@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: b3879a4d3a31ef14265a52e8d941cf4b0f6627ae efi/libstub: Make file I/O chunking x86-specific

The main changes in this cycle were:

 - Changes to the EFI init code to establish whether secure boot authentication 
   was performed at boot time. (Josh Boyer, David Howells)

 - Wire up the UEFI memory attributes table for x86. This eliminates any
   runtime memory regions that are both writable and executable, on recent
   firmware versions. (Sai Praneeth)

 - Move the BGRT init code to an earlier stage so that we can still use
   efi_mem_reserve(). (Dave Young)

 - Preserve debug symbols in the ARM/arm64 UEFI stub (Ard Biesheuvel)

 - Code deduplication work and various other cleanups (Lukas Wunner)

 - ... plus various other fixes and cleanups.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (3):
      efi: Use typed function pointers for the runtime services table
      efi/libstub: Preserve .debug sections after absolute relocation check
      efi/libstub: Make file I/O chunking x86-specific

Colin Ian King (1):
      efi/esrt: Fix typo in pr_err() message

Dave Young (2):
      efi/x86: Move the EFI BGRT init code to early init code
      efi/x86: Add debug code to print cooked memmap

David Howells (4):
      x86/efi: Allow invocation of arbitrary runtime services
      arm/efi: Allow invocation of arbitrary runtime services
      efi: Get and store the secure boot status
      efi: Print the secure boot status in x86 setup_arch()

Josh Boyer (2):
      efi: Add SHIM and image security database GUID definitions
      efi: Disable secure boot if shim is in insecure mode

Lukas Wunner (2):
      efi: Deduplicate efi_file_size() / _read() / _close()
      x86/efi: Deduplicate efi_char16_printk()

Sai Praneeth (3):
      efi: Make EFI_MEMORY_ATTRIBUTES_TABLE initialization common across all architectures
      efi: Introduce the EFI_MEM_ATTR bit and set it from the memory attributes table
      x86/efi: Add support for EFI_MEMORY_ATTRIBUTES_TABLE


 Documentation/x86/zero-page.txt                |   2 +
 arch/arm/include/asm/efi.h                     |   1 +
 arch/arm64/include/asm/efi.h                   |   1 +
 arch/x86/boot/compressed/eboot.c               | 182 ++-----------------------
 arch/x86/boot/compressed/head_32.S             |   6 +-
 arch/x86/boot/compressed/head_64.S             |   8 +-
 arch/x86/include/asm/efi.h                     |   5 +
 arch/x86/include/uapi/asm/bootparam.h          |   3 +-
 arch/x86/kernel/acpi/boot.c                    |   9 ++
 arch/x86/kernel/asm-offsets.c                  |   1 +
 arch/x86/kernel/setup.c                        |  14 ++
 arch/x86/platform/efi/efi-bgrt.c               |  59 ++++----
 arch/x86/platform/efi/efi.c                    |  10 +-
 arch/x86/platform/efi/efi_64.c                 |  64 +++++++--
 drivers/acpi/bgrt.c                            |  28 ++--
 drivers/firmware/efi/arm-init.c                |   1 -
 drivers/firmware/efi/efi.c                     |   2 +
 drivers/firmware/efi/esrt.c                    |   2 +-
 drivers/firmware/efi/libstub/Makefile          |  26 ++--
 drivers/firmware/efi/libstub/arm-stub.c        | 132 +-----------------
 drivers/firmware/efi/libstub/efi-stub-helper.c |  74 +++++++++-
 drivers/firmware/efi/libstub/efistub.h         |   8 --
 drivers/firmware/efi/libstub/secureboot.c      |  84 ++++++++++++
 drivers/firmware/efi/memattr.c                 |   6 +-
 include/linux/efi-bgrt.h                       |  11 +-
 include/linux/efi.h                            |  56 +++++---
 init/main.c                                    |   1 -
 27 files changed, 383 insertions(+), 413 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/secureboot.c

diff --git a/Documentation/x86/zero-page.txt b/Documentation/x86/zero-page.txt
index 95a4d34af3fd..b8527c6b7646 100644
--- a/Documentation/x86/zero-page.txt
+++ b/Documentation/x86/zero-page.txt
@@ -31,6 +31,8 @@ Offset	Proto	Name		Meaning
 1E9/001	ALL	eddbuf_entries	Number of entries in eddbuf (below)
 1EA/001	ALL	edd_mbr_sig_buf_entries	Number of entries in edd_mbr_sig_buffer
 				(below)
+1EB/001	ALL     kbd_status      Numlock is enabled
+1EC/001	ALL     secure_boot	Secure boot is enabled in the firmware
 1EF/001	ALL	sentinel	Used to detect broken bootloaders
 290/040	ALL	edd_mbr_sig_buffer EDD MBR signatures
 2D0/A00	ALL	e820_map	E820 memory map table
diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 0b06f5341b45..e4e6a9d6a825 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -55,6 +55,7 @@ void efi_virtmap_unload(void);
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(false)
 
 #define efi_call_proto(protocol, f, instance, ...)			\
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 0b6b1633017f..e7445281e534 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -50,6 +50,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
 #define efi_call_proto(protocol, f, instance, ...)			\
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ff01c8fc76f7..801c7a158e55 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -32,160 +32,13 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 									\
 	table = (typeof(table))sys_table;				\
 									\
+	c->runtime_services = table->runtime;				\
 	c->boot_services = table->boottime;				\
 	c->text_output = table->con_out;				\
 }
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
 
-void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
-
-static efi_status_t
-__file_size32(void *__fh, efi_char16_t *filename_16,
-	      void **handle, u64 *file_sz)
-{
-	efi_file_handle_32_t *h, *fh = __fh;
-	efi_file_info_t *info;
-	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	u32 info_sz;
-
-	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
-				 EFI_FILE_MODE_READ, (u64)0);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to open file: ");
-		efi_char16_printk(sys_table, filename_16);
-		efi_printk(sys_table, "\n");
-		return status;
-	}
-
-	*handle = h;
-
-	info_sz = 0;
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, NULL);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		efi_printk(sys_table, "Failed to get file info size\n");
-		return status;
-	}
-
-grow:
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				info_sz, (void **)&info);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to alloc mem for file info\n");
-		return status;
-	}
-
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, info);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_early(free_pool, info);
-		goto grow;
-	}
-
-	*file_sz = info->file_size;
-	efi_call_early(free_pool, info);
-
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table, "Failed to get initrd info\n");
-
-	return status;
-}
-
-static efi_status_t
-__file_size64(void *__fh, efi_char16_t *filename_16,
-	      void **handle, u64 *file_sz)
-{
-	efi_file_handle_64_t *h, *fh = __fh;
-	efi_file_info_t *info;
-	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	u64 info_sz;
-
-	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
-				 EFI_FILE_MODE_READ, (u64)0);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to open file: ");
-		efi_char16_printk(sys_table, filename_16);
-		efi_printk(sys_table, "\n");
-		return status;
-	}
-
-	*handle = h;
-
-	info_sz = 0;
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, NULL);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		efi_printk(sys_table, "Failed to get file info size\n");
-		return status;
-	}
-
-grow:
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				info_sz, (void **)&info);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to alloc mem for file info\n");
-		return status;
-	}
-
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, info);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_early(free_pool, info);
-		goto grow;
-	}
-
-	*file_sz = info->file_size;
-	efi_call_early(free_pool, info);
-
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table, "Failed to get initrd info\n");
-
-	return status;
-}
-efi_status_t
-efi_file_size(efi_system_table_t *sys_table, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
-{
-	if (efi_early->is64)
-		return __file_size64(__fh, filename_16, handle, file_sz);
-
-	return __file_size32(__fh, filename_16, handle, file_sz);
-}
-
-efi_status_t
-efi_file_read(void *handle, unsigned long *size, void *addr)
-{
-	unsigned long func;
-
-	if (efi_early->is64) {
-		efi_file_handle_64_t *fh = handle;
-
-		func = (unsigned long)fh->read;
-		return efi_early->call(func, handle, size, addr);
-	} else {
-		efi_file_handle_32_t *fh = handle;
-
-		func = (unsigned long)fh->read;
-		return efi_early->call(func, handle, size, addr);
-	}
-}
-
-efi_status_t efi_file_close(void *handle)
-{
-	if (efi_early->is64) {
-		efi_file_handle_64_t *fh = handle;
-
-		return efi_early->call((unsigned long)fh->close, handle);
-	} else {
-		efi_file_handle_32_t *fh = handle;
-
-		return efi_early->call((unsigned long)fh->close, handle);
-	}
-}
-
 static inline efi_status_t __open_volume32(void *__image, void **__fh)
 {
 	efi_file_io_interface_t *io;
@@ -249,30 +102,8 @@ efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 
 void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 {
-	unsigned long output_string;
-	size_t offset;
-
-	if (efi_early->is64) {
-		struct efi_simple_text_output_protocol_64 *out;
-		u64 *func;
-
-		offset = offsetof(typeof(*out), output_string);
-		output_string = efi_early->text_output + offset;
-		out = (typeof(out))(unsigned long)efi_early->text_output;
-		func = (u64 *)output_string;
-
-		efi_early->call(*func, out, str);
-	} else {
-		struct efi_simple_text_output_protocol_32 *out;
-		u32 *func;
-
-		offset = offsetof(typeof(*out), output_string);
-		output_string = efi_early->text_output + offset;
-		out = (typeof(out))(unsigned long)efi_early->text_output;
-		func = (u32 *)output_string;
-
-		efi_early->call(*func, out, str);
-	}
+	efi_call_proto(efi_simple_text_output_protocol, output_string,
+		       efi_early->text_output, str);
 }
 
 static efi_status_t
@@ -1157,6 +988,13 @@ struct boot_params *efi_main(struct efi_config *c,
 	else
 		setup_boot_services32(efi_early);
 
+	/*
+	 * If the boot loader gave us a value for secure_boot then we use that,
+	 * otherwise we ask the BIOS.
+	 */
+	if (boot_params->secure_boot == efi_secureboot_mode_unset)
+		boot_params->secure_boot = efi_get_secureboot(sys_table);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index fd0b6a272dd5..d85b9625e836 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -82,7 +82,7 @@ ENTRY(efi_pe_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 32(%eax)
+	add	%esi, 40(%eax)
 	pushl	%eax
 
 	call	make_boot_params
@@ -108,7 +108,7 @@ ENTRY(efi32_stub_entry)
 
 	/* Relocate efi_config->call() */
 	leal	efi32_config(%esi), %eax
-	add	%esi, 32(%eax)
+	add	%esi, 40(%eax)
 	pushl	%eax
 2:
 	call	efi_main
@@ -264,7 +264,7 @@ ENDPROC(startup_32)
 #ifdef CONFIG_EFI_STUB
 	.data
 efi32_config:
-	.fill 4,8,0
+	.fill 5,8,0
 	.long efi_call_phys
 	.long 0
 	.byte 0
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 4d85e600db78..d2ae1f821e0c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -264,7 +264,7 @@ ENTRY(efi_pe_entry)
 	/*
 	 * Relocate efi_config->call().
 	 */
-	addq	%rbp, efi64_config+32(%rip)
+	addq	%rbp, efi64_config+40(%rip)
 
 	movq	%rax, %rdi
 	call	make_boot_params
@@ -284,7 +284,7 @@ ENTRY(efi_pe_entry)
 	 * Relocate efi_config->call().
 	 */
 	movq	efi_config(%rip), %rax
-	addq	%rbp, 32(%rax)
+	addq	%rbp, 40(%rax)
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -456,14 +456,14 @@ ENDPROC(efi64_stub_entry)
 #ifdef CONFIG_EFI_MIXED
 	.global efi32_config
 efi32_config:
-	.fill	4,8,0
+	.fill	5,8,0
 	.quad	efi64_thunk
 	.byte	0
 #endif
 
 	.global efi64_config
 efi64_config:
-	.fill	4,8,0
+	.fill	5,8,0
 	.quad	efi_call
 	.byte	1
 #endif /* CONFIG_EFI_STUB */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index e99675b9c861..2f77bcefe6b4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -191,6 +191,7 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 struct efi_config {
 	u64 image_handle;
 	u64 table;
+	u64 runtime_services;
 	u64 boot_services;
 	u64 text_output;
 	efi_status_t (*call)(unsigned long, ...);
@@ -226,6 +227,10 @@ static inline bool efi_is_64bit(void)
 #define __efi_call_early(f, ...)					\
 	__efi_early()->call((unsigned long)f, __VA_ARGS__);
 
+#define efi_call_runtime(f, ...)					\
+	__efi_early()->call(efi_table_attr(efi_runtime_services, f,	\
+		__efi_early()->runtime_services), __VA_ARGS__)
+
 extern bool efi_reboot_required(void);
 
 #else
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index b10bf319ed20..5138dacf8bb8 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -135,7 +135,8 @@ struct boot_params {
 	__u8  eddbuf_entries;				/* 0x1e9 */
 	__u8  edd_mbr_sig_buf_entries;			/* 0x1ea */
 	__u8  kbd_status;				/* 0x1eb */
-	__u8  _pad5[3];					/* 0x1ec */
+	__u8  secure_boot;				/* 0x1ec */
+	__u8  _pad5[2];					/* 0x1ed */
 	/*
 	 * The sentinel is set to a nonzero value (0xff) in header.S.
 	 *
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 64422f850e95..7ff007ed899d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -35,6 +35,7 @@
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
 #include <linux/pci.h>
+#include <linux/efi-bgrt.h>
 
 #include <asm/irqdomain.h>
 #include <asm/pci_x86.h>
@@ -1557,6 +1558,12 @@ int __init early_acpi_boot_init(void)
 	return 0;
 }
 
+static int __init acpi_parse_bgrt(struct acpi_table_header *table)
+{
+	efi_bgrt_init(table);
+	return 0;
+}
+
 int __init acpi_boot_init(void)
 {
 	/* those are executed after early-quirks are executed */
@@ -1581,6 +1588,8 @@ int __init acpi_boot_init(void)
 	acpi_process_madt();
 
 	acpi_table_parse(ACPI_SIG_HPET, acpi_parse_hpet);
+	if (IS_ENABLED(CONFIG_ACPI_BGRT))
+		acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);
 
 	if (!acpi_noirq)
 		x86_init.pci.init = pci_acpi_init;
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index c62e015b126c..de827d6ac8c2 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -81,6 +81,7 @@ void common(void) {
 
 	BLANK();
 	OFFSET(BP_scratch, boot_params, scratch);
+	OFFSET(BP_secure_boot, boot_params, secure_boot);
 	OFFSET(BP_loadflags, boot_params, hdr.loadflags);
 	OFFSET(BP_hardware_subarch, boot_params, hdr.hardware_subarch);
 	OFFSET(BP_version, boot_params, hdr.version);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 4cfba947d774..69780edf0dde 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1176,6 +1176,20 @@ void __init setup_arch(char **cmdline_p)
 	/* Allocate bigger log buffer */
 	setup_log_buf(1);
 
+	if (efi_enabled(EFI_BOOT)) {
+		switch (boot_params.secure_boot) {
+		case efi_secureboot_mode_disabled:
+			pr_info("Secure boot disabled\n");
+			break;
+		case efi_secureboot_mode_enabled:
+			pr_info("Secure boot enabled\n");
+			break;
+		default:
+			pr_info("Secure boot could not be determined\n");
+			break;
+		}
+	}
+
 	reserve_initrd();
 
 	acpi_table_upgrade();
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index 6aad870e8962..04ca8764f0c0 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -19,8 +19,7 @@
 #include <linux/efi.h>
 #include <linux/efi-bgrt.h>
 
-struct acpi_table_bgrt *bgrt_tab;
-void *__initdata bgrt_image;
+struct acpi_table_bgrt bgrt_tab;
 size_t __initdata bgrt_image_size;
 
 struct bmp_header {
@@ -28,66 +27,58 @@ struct bmp_header {
 	u32 size;
 } __packed;
 
-void __init efi_bgrt_init(void)
+void __init efi_bgrt_init(struct acpi_table_header *table)
 {
-	acpi_status status;
 	void *image;
 	struct bmp_header bmp_header;
+	struct acpi_table_bgrt *bgrt = &bgrt_tab;
 
 	if (acpi_disabled)
 		return;
 
-	status = acpi_get_table("BGRT", 0,
-	                        (struct acpi_table_header **)&bgrt_tab);
-	if (ACPI_FAILURE(status))
-		return;
-
-	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
+	if (table->length < sizeof(bgrt_tab)) {
 		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
-		       bgrt_tab->header.length, sizeof(*bgrt_tab));
+		       table->length, sizeof(bgrt_tab));
 		return;
 	}
-	if (bgrt_tab->version != 1) {
+	*bgrt = *(struct acpi_table_bgrt *)table;
+	if (bgrt->version != 1) {
 		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
-		       bgrt_tab->version);
-		return;
+		       bgrt->version);
+		goto out;
 	}
-	if (bgrt_tab->status & 0xfe) {
+	if (bgrt->status & 0xfe) {
 		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
-		       bgrt_tab->status);
-		return;
+		       bgrt->status);
+		goto out;
 	}
-	if (bgrt_tab->image_type != 0) {
+	if (bgrt->image_type != 0) {
 		pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
-		       bgrt_tab->image_type);
-		return;
+		       bgrt->image_type);
+		goto out;
 	}
-	if (!bgrt_tab->image_address) {
+	if (!bgrt->image_address) {
 		pr_notice("Ignoring BGRT: null image address\n");
-		return;
+		goto out;
 	}
 
-	image = memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMREMAP_WB);
+	image = early_memremap(bgrt->image_address, sizeof(bmp_header));
 	if (!image) {
 		pr_notice("Ignoring BGRT: failed to map image header memory\n");
-		return;
+		goto out;
 	}
 
 	memcpy(&bmp_header, image, sizeof(bmp_header));
-	memunmap(image);
+	early_memunmap(image, sizeof(bmp_header));
 	if (bmp_header.id != 0x4d42) {
 		pr_notice("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4d42)\n",
 			bmp_header.id);
-		return;
+		goto out;
 	}
 	bgrt_image_size = bmp_header.size;
+	efi_mem_reserve(bgrt->image_address, bgrt_image_size);
 
-	bgrt_image = memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP_WB);
-	if (!bgrt_image) {
-		pr_notice("Ignoring BGRT: failed to map image memory\n");
-		bgrt_image = NULL;
-		return;
-	}
-
-	efi_mem_reserve(bgrt_tab->image_address, bgrt_image_size);
+	return;
+out:
+	memset(bgrt, 0, sizeof(bgrt_tab));
 }
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 274dfc481849..565dff3c9a12 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -542,11 +542,6 @@ void __init efi_init(void)
 		efi_print_memmap();
 }
 
-void __init efi_late_init(void)
-{
-	efi_bgrt_init();
-}
-
 void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 {
 	u64 addr, npages;
@@ -960,6 +955,11 @@ static void __init __efi_enter_virtual_mode(void)
 		return;
 	}
 
+	if (efi_enabled(EFI_DBG)) {
+		pr_info("EFI runtime memory map:\n");
+		efi_print_memmap();
+	}
+
 	BUG_ON(!efi.systab);
 
 	if (efi_setup_page_tables(pa, 1 << pg_shift)) {
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 2f25a363068c..a4695da42d77 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -414,10 +414,44 @@ void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 	efi_setup = phys_addr + sizeof(struct setup_data);
 }
 
-void __init efi_runtime_update_mappings(void)
+static int __init efi_update_mappings(efi_memory_desc_t *md, unsigned long pf)
 {
 	unsigned long pfn;
 	pgd_t *pgd = efi_pgd;
+	int err1, err2;
+
+	/* Update the 1:1 mapping */
+	pfn = md->phys_addr >> PAGE_SHIFT;
+	err1 = kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages, pf);
+	if (err1) {
+		pr_err("Error while updating 1:1 mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, md->virt_addr);
+	}
+
+	err2 = kernel_map_pages_in_pgd(pgd, pfn, md->virt_addr, md->num_pages, pf);
+	if (err2) {
+		pr_err("Error while updating VA mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, md->virt_addr);
+	}
+
+	return err1 || err2;
+}
+
+static int __init efi_update_mem_attr(struct mm_struct *mm, efi_memory_desc_t *md)
+{
+	unsigned long pf = 0;
+
+	if (md->attribute & EFI_MEMORY_XP)
+		pf |= _PAGE_NX;
+
+	if (!(md->attribute & EFI_MEMORY_RO))
+		pf |= _PAGE_RW;
+
+	return efi_update_mappings(md, pf);
+}
+
+void __init efi_runtime_update_mappings(void)
+{
 	efi_memory_desc_t *md;
 
 	if (efi_enabled(EFI_OLD_MEMMAP)) {
@@ -426,6 +460,24 @@ void __init efi_runtime_update_mappings(void)
 		return;
 	}
 
+	/*
+	 * Use the EFI Memory Attribute Table for mapping permissions if it
+	 * exists, since it is intended to supersede EFI_PROPERTIES_TABLE.
+	 */
+	if (efi_enabled(EFI_MEM_ATTR)) {
+		efi_memattr_apply_permissions(NULL, efi_update_mem_attr);
+		return;
+	}
+
+	/*
+	 * EFI_MEMORY_ATTRIBUTES_TABLE is intended to replace
+	 * EFI_PROPERTIES_TABLE. So, use EFI_PROPERTIES_TABLE to update
+	 * permissions only if EFI_MEMORY_ATTRIBUTES_TABLE is not
+	 * published by the firmware. Even if we find a buggy implementation of
+	 * EFI_MEMORY_ATTRIBUTES_TABLE, don't fall back to
+	 * EFI_PROPERTIES_TABLE, because of the same reason.
+	 */
+
 	if (!efi_enabled(EFI_NX_PE_DATA))
 		return;
 
@@ -446,15 +498,7 @@ void __init efi_runtime_update_mappings(void)
 			(md->type != EFI_RUNTIME_SERVICES_CODE))
 			pf |= _PAGE_RW;
 
-		/* Update the 1:1 mapping */
-		pfn = md->phys_addr >> PAGE_SHIFT;
-		if (kernel_map_pages_in_pgd(pgd, pfn, md->phys_addr, md->num_pages, pf))
-			pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
-				   md->phys_addr, md->virt_addr);
-
-		if (kernel_map_pages_in_pgd(pgd, pfn, md->virt_addr, md->num_pages, pf))
-			pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
-				   md->phys_addr, md->virt_addr);
+		efi_update_mappings(md, pf);
 	}
 }
 
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index 75f128e766a9..ca28aa572aa9 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -15,40 +15,41 @@
 #include <linux/sysfs.h>
 #include <linux/efi-bgrt.h>
 
+static void *bgrt_image;
 static struct kobject *bgrt_kobj;
 
 static ssize_t show_version(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->version);
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.version);
 }
 static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 
 static ssize_t show_status(struct device *dev,
 			   struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->status);
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.status);
 }
 static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
 
 static ssize_t show_type(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_type);
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_type);
 }
 static DEVICE_ATTR(type, S_IRUGO, show_type, NULL);
 
 static ssize_t show_xoffset(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_offset_x);
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_x);
 }
 static DEVICE_ATTR(xoffset, S_IRUGO, show_xoffset, NULL);
 
 static ssize_t show_yoffset(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab->image_offset_y);
+	return snprintf(buf, PAGE_SIZE, "%d\n", bgrt_tab.image_offset_y);
 }
 static DEVICE_ATTR(yoffset, S_IRUGO, show_yoffset, NULL);
 
@@ -84,15 +85,24 @@ static int __init bgrt_init(void)
 {
 	int ret;
 
-	if (!bgrt_image)
+	if (!bgrt_tab.image_address)
 		return -ENODEV;
 
+	bgrt_image = memremap(bgrt_tab.image_address, bgrt_image_size,
+			      MEMREMAP_WB);
+	if (!bgrt_image) {
+		pr_notice("Ignoring BGRT: failed to map image memory\n");
+		return -ENOMEM;
+	}
+
 	bin_attr_image.private = bgrt_image;
 	bin_attr_image.size = bgrt_image_size;
 
 	bgrt_kobj = kobject_create_and_add("bgrt", acpi_kobj);
-	if (!bgrt_kobj)
-		return -EINVAL;
+	if (!bgrt_kobj) {
+		ret = -EINVAL;
+		goto out_memmap;
+	}
 
 	ret = sysfs_create_group(bgrt_kobj, &bgrt_attribute_group);
 	if (ret)
@@ -102,6 +112,8 @@ static int __init bgrt_init(void)
 
 out_kobject:
 	kobject_put(bgrt_kobj);
+out_memmap:
+	memunmap(bgrt_image);
 	return ret;
 }
 device_initcall(bgrt_init);
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index f853ad2c4ca0..1027d7b44358 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -250,7 +250,6 @@ void __init efi_init(void)
 	}
 
 	reserve_regions();
-	efi_memattr_init();
 	efi_esrt_init();
 	efi_memmap_unmap();
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 92914801e388..e7d404059b73 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -529,6 +529,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		}
 	}
 
+	efi_memattr_init();
+
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
 		efi_properties_table_t *tbl;
diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 14914074f716..08b026864d4e 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -269,7 +269,7 @@ void __init efi_esrt_init(void)
 	max -= efi.esrt;
 
 	if (max < size) {
-		pr_err("ESRT header doen't fit on single memory map entry. (size: %zu max: %zu)\n",
+		pr_err("ESRT header doesn't fit on single memory map entry. (size: %zu max: %zu)\n",
 		       size, max);
 		return;
 	}
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d564d25df8ab..f7425960f6a5 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -11,7 +11,7 @@ cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ -O2 \
 				   -mno-mmx -mno-sse
 
 cflags-$(CONFIG_ARM64)		:= $(subst -pg,,$(KBUILD_CFLAGS))
-cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) -g0 \
+cflags-$(CONFIG_ARM)		:= $(subst -pg,,$(KBUILD_CFLAGS)) \
 				   -fno-builtin -fpic -mno-single-pic-base
 
 cflags-$(CONFIG_EFI_ARMSTUB)	+= -I$(srctree)/scripts/dtc/libfdt
@@ -28,7 +28,7 @@ OBJECT_FILES_NON_STANDARD	:= y
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
 KCOV_INSTRUMENT			:= n
 
-lib-y				:= efi-stub-helper.o gop.o
+lib-y				:= efi-stub-helper.o gop.o secureboot.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
@@ -60,7 +60,7 @@ CFLAGS_arm64-stub.o 		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 extra-$(CONFIG_EFI_ARMSTUB)	:= $(lib-y)
 lib-$(CONFIG_EFI_ARMSTUB)	:= $(patsubst %.o,%.stub.o,$(lib-y))
 
-STUBCOPY_FLAGS-y		:= -R .debug* -R *ksymtab* -R *kcrctab*
+STUBCOPY_RM-y			:= -R *ksymtab* -R *kcrctab*
 STUBCOPY_FLAGS-$(CONFIG_ARM64)	+= --prefix-alloc-sections=.init \
 				   --prefix-symbols=__efistub_
 STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
@@ -68,17 +68,25 @@ STUBCOPY_RELOC-$(CONFIG_ARM64)	:= R_AARCH64_ABS
 $(obj)/%.stub.o: $(obj)/%.o FORCE
 	$(call if_changed,stubcopy)
 
+#
+# Strip debug sections and some other sections that may legally contain
+# absolute relocations, so that we can inspect the remaining sections for
+# such relocations. If none are found, regenerate the output object, but
+# this time, use objcopy and leave all sections in place.
+#
 quiet_cmd_stubcopy = STUBCPY $@
-      cmd_stubcopy = if $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; then	\
-		     $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y)	\
-		     && (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
-			 rm -f $@; /bin/false); else /bin/false; fi
+      cmd_stubcopy = if $(STRIP) --strip-debug $(STUBCOPY_RM-y) -o $@ $<; \
+		     then if $(OBJDUMP) -r $@ | grep $(STUBCOPY_RELOC-y); \
+		     then (echo >&2 "$@: absolute symbol references not allowed in the EFI stub"; \
+			   rm -f $@; /bin/false); 			  \
+		     else $(OBJCOPY) $(STUBCOPY_FLAGS-y) $< $@; fi	  \
+		     else /bin/false; fi
 
 #
 # ARM discards the .data section because it disallows r/w data in the
 # decompressor. So move our .data to .data.efistub, which is preserved
 # explicitly by the decompressor linker script.
 #
-STUBCOPY_FLAGS-$(CONFIG_ARM)	+= --rename-section .data=.data.efistub \
-				   -R ___ksymtab+sort -R ___kcrctab+sort
+STUBCOPY_FLAGS-$(CONFIG_ARM)	+= --rename-section .data=.data.efistub
+STUBCOPY_RM-$(CONFIG_ARM)	+= -R ___ksymtab+sort -R ___kcrctab+sort
 STUBCOPY_RELOC-$(CONFIG_ARM)	:= R_ARM_ABS
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index b4f7d78f9e8b..d4056c6be1ec 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -20,52 +20,6 @@
 
 bool __nokaslr;
 
-static int efi_get_secureboot(efi_system_table_t *sys_table_arg)
-{
-	static efi_char16_t const sb_var_name[] = {
-		'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
-	static efi_char16_t const sm_var_name[] = {
-		'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0 };
-
-	efi_guid_t var_guid = EFI_GLOBAL_VARIABLE_GUID;
-	efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
-	u8 val;
-	unsigned long size = sizeof(val);
-	efi_status_t status;
-
-	status = f_getvar((efi_char16_t *)sb_var_name, (efi_guid_t *)&var_guid,
-			  NULL, &size, &val);
-
-	if (status != EFI_SUCCESS)
-		goto out_efi_err;
-
-	if (val == 0)
-		return 0;
-
-	status = f_getvar((efi_char16_t *)sm_var_name, (efi_guid_t *)&var_guid,
-			  NULL, &size, &val);
-
-	if (status != EFI_SUCCESS)
-		goto out_efi_err;
-
-	if (val == 1)
-		return 0;
-
-	return 1;
-
-out_efi_err:
-	switch (status) {
-	case EFI_NOT_FOUND:
-		return 0;
-	case EFI_DEVICE_ERROR:
-		return -EIO;
-	case EFI_SECURITY_VIOLATION:
-		return -EACCES;
-	default:
-		return -EINVAL;
-	}
-}
-
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
 {
@@ -91,75 +45,6 @@ efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 	return status;
 }
 
-efi_status_t efi_file_close(void *handle)
-{
-	efi_file_handle_t *fh = handle;
-
-	return fh->close(handle);
-}
-
-efi_status_t
-efi_file_read(void *handle, unsigned long *size, void *addr)
-{
-	efi_file_handle_t *fh = handle;
-
-	return fh->read(handle, size, addr);
-}
-
-
-efi_status_t
-efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
-{
-	efi_file_handle_t *h, *fh = __fh;
-	efi_file_info_t *info;
-	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	unsigned long info_sz;
-
-	status = fh->open(fh, &h, filename_16, EFI_FILE_MODE_READ, (u64)0);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to open file: ");
-		efi_char16_printk(sys_table_arg, filename_16);
-		efi_printk(sys_table_arg, "\n");
-		return status;
-	}
-
-	*handle = h;
-
-	info_sz = 0;
-	status = h->get_info(h, &info_guid, &info_sz, NULL);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		efi_printk(sys_table_arg, "Failed to get file info size\n");
-		return status;
-	}
-
-grow:
-	status = sys_table_arg->boottime->allocate_pool(EFI_LOADER_DATA,
-				 info_sz, (void **)&info);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
-		return status;
-	}
-
-	status = h->get_info(h, &info_guid, &info_sz,
-						   info);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		sys_table_arg->boottime->free_pool(info);
-		goto grow;
-	}
-
-	*file_sz = info->file_size;
-	sys_table_arg->boottime->free_pool(info);
-
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table_arg, "Failed to get initrd info\n");
-
-	return status;
-}
-
-
-
 void efi_char16_printk(efi_system_table_t *sys_table_arg,
 			      efi_char16_t *str)
 {
@@ -226,7 +111,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
-	int secure_boot = 0;
+	enum efi_secureboot_mode secure_boot;
 	struct screen_info *si;
 
 	/* Check if we were booted by the EFI firmware */
@@ -296,19 +181,14 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
 
 	secure_boot = efi_get_secureboot(sys_table);
-	if (secure_boot > 0)
-		pr_efi(sys_table, "UEFI Secure Boot is enabled.\n");
-
-	if (secure_boot < 0) {
-		pr_efi_err(sys_table,
-			"could not determine UEFI Secure Boot status.\n");
-	}
 
 	/*
-	 * Unauthenticated device tree data is a security hazard, so
-	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
+	 * Unauthenticated device tree data is a security hazard, so ignore
+	 * 'dtb=' unless UEFI Secure Boot is disabled.  We assume that secure
+	 * boot is enabled if we can't determine its state.
 	 */
-	if (secure_boot != 0 && strstr(cmdline_ptr, "dtb=")) {
+	if (secure_boot != efi_secureboot_mode_disabled &&
+	    strstr(cmdline_ptr, "dtb=")) {
 		pr_efi(sys_table, "Ignoring DTB from command line.\n");
 	} else {
 		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 757badc1debb..919822b7773d 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -338,6 +338,69 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 	efi_call_early(free_pages, addr, nr_pages);
 }
 
+static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
+				  efi_char16_t *filename_16, void **handle,
+				  u64 *file_sz)
+{
+	efi_file_handle_t *h, *fh = __fh;
+	efi_file_info_t *info;
+	efi_status_t status;
+	efi_guid_t info_guid = EFI_FILE_INFO_ID;
+	unsigned long info_sz;
+
+	status = efi_call_proto(efi_file_handle, open, fh, &h, filename_16,
+				EFI_FILE_MODE_READ, (u64)0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to open file: ");
+		efi_char16_printk(sys_table_arg, filename_16);
+		efi_printk(sys_table_arg, "\n");
+		return status;
+	}
+
+	*handle = h;
+
+	info_sz = 0;
+	status = efi_call_proto(efi_file_handle, get_info, h, &info_guid,
+				&info_sz, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk(sys_table_arg, "Failed to get file info size\n");
+		return status;
+	}
+
+grow:
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = efi_call_proto(efi_file_handle, get_info, h, &info_guid,
+				&info_sz, info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_call_early(free_pool, info);
+		goto grow;
+	}
+
+	*file_sz = info->file_size;
+	efi_call_early(free_pool, info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table_arg, "Failed to get initrd info\n");
+
+	return status;
+}
+
+static efi_status_t efi_file_read(void *handle, unsigned long *size, void *addr)
+{
+	return efi_call_proto(efi_file_handle, read, handle, size, addr);
+}
+
+static efi_status_t efi_file_close(void *handle)
+{
+	return efi_call_proto(efi_file_handle, close, handle);
+}
+
 /*
  * Parse the ASCII string 'cmdline' for EFI options, denoted by the efi=
  * option, e.g. efi=nochunk.
@@ -351,6 +414,14 @@ efi_status_t efi_parse_options(char *cmdline)
 	char *str;
 
 	/*
+	 * Currently, the only efi= option we look for is 'nochunk', which
+	 * is intended to work around known issues on certain x86 UEFI
+	 * versions. So ignore for now on other architectures.
+	 */
+	if (!IS_ENABLED(CONFIG_X86))
+		return EFI_SUCCESS;
+
+	/*
 	 * If no EFI parameters were specified on the cmdline we've got
 	 * nothing to do.
 	 */
@@ -523,7 +594,8 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			size = files[j].size;
 			while (size) {
 				unsigned long chunksize;
-				if (size > __chunk_size)
+
+				if (IS_ENABLED(CONFIG_X86) && size > __chunk_size)
 					chunksize = __chunk_size;
 				else
 					chunksize = size;
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 0e2a96b12cb3..71c4d0e3c4ed 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -29,14 +29,6 @@ void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
 			     void **__fh);
 
-efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
-			   efi_char16_t *filename_16, void **handle,
-			   u64 *file_sz);
-
-efi_status_t efi_file_read(void *handle, unsigned long *size, void *addr);
-
-efi_status_t efi_file_close(void *handle);
-
 unsigned long get_dram_base(efi_system_table_t *sys_table_arg);
 
 efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
new file mode 100644
index 000000000000..6def402bf569
--- /dev/null
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -0,0 +1,84 @@
+/*
+ * Secure boot handling.
+ *
+ * Copyright (C) 2013,2014 Linaro Limited
+ *     Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
+ * Copyright (C) 2013 Red Hat, Inc.
+ *     Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+ *
+ * This file is part of the Linux kernel, and is made available under the
+ * terms of the GNU General Public License version 2.
+ */
+#include <linux/efi.h>
+#include <asm/efi.h>
+
+/* BIOS variables */
+static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
+static const efi_char16_t const efi_SecureBoot_name[] = {
+	'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0
+};
+static const efi_char16_t const efi_SetupMode_name[] = {
+	'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
+};
+
+/* SHIM variables */
+static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
+static efi_char16_t const shim_MokSBState_name[] = {
+	'M', 'o', 'k', 'S', 'B', 'S', 't', 'a', 't', 'e', 0
+};
+
+#define get_efi_var(name, vendor, ...) \
+	efi_call_runtime(get_variable, \
+			 (efi_char16_t *)(name), (efi_guid_t *)(vendor), \
+			 __VA_ARGS__);
+
+/*
+ * Determine whether we're in secure boot mode.
+ */
+enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
+{
+	u32 attr;
+	u8 secboot, setupmode, moksbstate;
+	unsigned long size;
+	efi_status_t status;
+
+	size = sizeof(secboot);
+	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
+			     NULL, &size, &secboot);
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	size = sizeof(setupmode);
+	status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
+			     NULL, &size, &setupmode);
+	if (status != EFI_SUCCESS)
+		goto out_efi_err;
+
+	if (secboot == 0 || setupmode == 1)
+		return efi_secureboot_mode_disabled;
+
+	/*
+	 * See if a user has put the shim into insecure mode. If so, and if the
+	 * variable doesn't have the runtime attribute set, we might as well
+	 * honor that.
+	 */
+	size = sizeof(moksbstate);
+	status = get_efi_var(shim_MokSBState_name, &shim_guid,
+			     &attr, &size, &moksbstate);
+
+	/* If it fails, we don't care why. Default to secure */
+	if (status != EFI_SUCCESS)
+		goto secure_boot_enabled;
+	if (!(attr & EFI_VARIABLE_RUNTIME_ACCESS) && moksbstate == 1)
+		return efi_secureboot_mode_disabled;
+
+secure_boot_enabled:
+	pr_efi(sys_table_arg, "UEFI Secure Boot is enabled.\n");
+	return efi_secureboot_mode_enabled;
+
+out_efi_err:
+	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
+	return efi_secureboot_mode_unknown;
+}
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
index 236004b9a50d..8986757eafaf 100644
--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -43,6 +43,7 @@ int __init efi_memattr_init(void)
 
 	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
 	memblock_reserve(efi.mem_attr_table, tbl_size);
+	set_bit(EFI_MEM_ATTR, &efi.flags);
 
 unmap:
 	early_memunmap(tbl, sizeof(*tbl));
@@ -174,8 +175,11 @@ int __init efi_memattr_apply_permissions(struct mm_struct *mm,
 				md.phys_addr + size - 1,
 				efi_md_typeattr_format(buf, sizeof(buf), &md));
 
-		if (valid)
+		if (valid) {
 			ret = fn(mm, &md);
+			if (ret)
+				pr_err("Error updating mappings, skipping subsequent md's\n");
+		}
 	}
 	memunmap(tbl);
 	return ret;
diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
index 051b21fedf68..2fd3993c370b 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -1,20 +1,19 @@
 #ifndef _LINUX_EFI_BGRT_H
 #define _LINUX_EFI_BGRT_H
 
-#ifdef CONFIG_ACPI_BGRT
-
 #include <linux/acpi.h>
 
-void efi_bgrt_init(void);
+#ifdef CONFIG_ACPI_BGRT
+
+void efi_bgrt_init(struct acpi_table_header *table);
 
 /* The BGRT data itself; only valid if bgrt_image != NULL. */
-extern void *bgrt_image;
 extern size_t bgrt_image_size;
-extern struct acpi_table_bgrt *bgrt_tab;
+extern struct acpi_table_bgrt bgrt_tab;
 
 #else /* !CONFIG_ACPI_BGRT */
 
-static inline void efi_bgrt_init(void) {}
+static inline void efi_bgrt_init(struct acpi_table_header *table) {}
 
 #endif /* !CONFIG_ACPI_BGRT */
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5b1af30ece55..94d34e0be24f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -509,24 +509,6 @@ typedef struct {
 	u64 query_variable_info;
 } efi_runtime_services_64_t;
 
-typedef struct {
-	efi_table_hdr_t hdr;
-	void *get_time;
-	void *set_time;
-	void *get_wakeup_time;
-	void *set_wakeup_time;
-	void *set_virtual_address_map;
-	void *convert_pointer;
-	void *get_variable;
-	void *get_next_variable;
-	void *set_variable;
-	void *get_next_high_mono_count;
-	void *reset_system;
-	void *update_capsule;
-	void *query_capsule_caps;
-	void *query_variable_info;
-} efi_runtime_services_t;
-
 typedef efi_status_t efi_get_time_t (efi_time_t *tm, efi_time_cap_t *tc);
 typedef efi_status_t efi_set_time_t (efi_time_t *tm);
 typedef efi_status_t efi_get_wakeup_time_t (efi_bool_t *enabled, efi_bool_t *pending,
@@ -561,6 +543,24 @@ typedef efi_status_t efi_query_variable_store_t(u32 attributes,
 						unsigned long size,
 						bool nonblocking);
 
+typedef struct {
+	efi_table_hdr_t			hdr;
+	efi_get_time_t			*get_time;
+	efi_set_time_t			*set_time;
+	efi_get_wakeup_time_t		*get_wakeup_time;
+	efi_set_wakeup_time_t		*set_wakeup_time;
+	efi_set_virtual_address_map_t	*set_virtual_address_map;
+	void				*convert_pointer;
+	efi_get_variable_t		*get_variable;
+	efi_get_next_variable_t		*get_next_variable;
+	efi_set_variable_t		*set_variable;
+	efi_get_next_high_mono_count_t	*get_next_high_mono_count;
+	efi_reset_system_t		*reset_system;
+	efi_update_capsule_t		*update_capsule;
+	efi_query_capsule_caps_t	*query_capsule_caps;
+	efi_query_variable_info_t	*query_variable_info;
+} efi_runtime_services_t;
+
 void efi_native_runtime_setup(void);
 
 /*
@@ -611,6 +611,9 @@ void efi_native_runtime_setup(void);
 #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 #define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
 
+#define EFI_IMAGE_SECURITY_DATABASE_GUID	EFI_GUID(0xd719b2cb, 0x3d3a, 0x4596,  0xa3, 0xbc, 0xda, 0xd0, 0x0e, 0x67, 0x65, 0x6f)
+#define EFI_SHIM_LOCK_GUID			EFI_GUID(0x605dab50, 0xe046, 0x4300,  0xab, 0xb6, 0x3d, 0xd8, 0x10, 0xdd, 0x8b, 0x23)
+
 /*
  * This GUID is used to pass to the kernel proper the struct screen_info
  * structure that was populated by the stub based on the GOP protocol instance
@@ -1065,6 +1068,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		7	/* First arch-specific bit */
 #define EFI_DBG			8	/* Print additional debug info at runtime */
 #define EFI_NX_PE_DATA		9	/* Can runtime data regions be mapped non-executable? */
+#define EFI_MEM_ATTR		10	/* Did firmware publish an EFI_MEMORY_ATTRIBUTES table? */
 
 #ifdef CONFIG_EFI
 /*
@@ -1240,17 +1244,17 @@ struct efivar_entry {
 	bool deleting;
 };
 
-struct efi_simple_text_output_protocol_32 {
+typedef struct {
 	u32 reset;
 	u32 output_string;
 	u32 test_string;
-};
+} efi_simple_text_output_protocol_32_t;
 
-struct efi_simple_text_output_protocol_64 {
+typedef struct {
 	u64 reset;
 	u64 output_string;
 	u64 test_string;
-};
+} efi_simple_text_output_protocol_64_t;
 
 struct efi_simple_text_output_protocol {
 	void *reset;
@@ -1476,6 +1480,14 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 bool efi_runtime_disabled(void);
 extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
 
+enum efi_secureboot_mode {
+	efi_secureboot_mode_unset,
+	efi_secureboot_mode_unknown,
+	efi_secureboot_mode_disabled,
+	efi_secureboot_mode_enabled,
+};
+enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table);
+
 /*
  * Arch code can implement the following three template macros, avoiding
  * reptition for the void/non-void return cases of {__,}efi_call_virt():
diff --git a/init/main.c b/init/main.c
index b0c9d6facef9..9648d707eea5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -663,7 +663,6 @@ asmlinkage __visible void __init start_kernel(void)
 	sfi_init_late();
 
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		efi_late_init();
 		efi_free_boot_services();
 	}
 
