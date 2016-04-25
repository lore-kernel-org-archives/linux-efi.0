From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 21/40] efi/arm: libstub: Make screen_info accessible to the UEFI stub
Date: Mon, 25 Apr 2016 21:06:53 +0100
Message-ID: <1461614832-17633-22-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

In order to hand over the framebuffer described by the GOP protocol and
discovered by the UEFI stub, make struct screen_info accessible by the
stub. This involves allocating a loader data buffer and passing it to the
kernel proper via a UEFI Configuration Table, since the UEFI stub executes
in the context of the decompressor, and cannot access the kernel's copy of
struct screen_info directly.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: David Herrmann <dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/arm/include/asm/efi.h                |  3 +++
 arch/arm/kernel/setup.c                   |  3 ++-
 drivers/firmware/efi/arm-init.c           | 34 +++++++++++++++++++++++++++-
 drivers/firmware/efi/efi.c                |  5 +++--
 drivers/firmware/efi/libstub/arm32-stub.c | 37 +++++++++++++++++++++++++++++++
 include/linux/efi.h                       | 11 ++++++++-
 6 files changed, 88 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index dc30d89a1ed3..25f8b1162c2e 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -64,6 +64,9 @@ void efi_virtmap_unload(void);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(false)
 
+struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg);
+void free_screen_info(efi_system_table_t *sys_table, struct screen_info *si);
+
 /*
  * A reasonable upper bound for the uncompressed kernel size is 32 MBytes,
  * so we will reserve that amount of memory. We have no easy way to tell what
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index a28fce0bdbbe..180f528ec318 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -883,7 +883,8 @@ static void __init request_standard_resources(const struct machine_desc *mdesc)
 		request_resource(&ioport_resource, &lp2);
 }
 
-#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
+#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE) || \
+    defined(CONFIG_EFI)
 struct screen_info screen_info = {
  .orig_video_lines	= 30,
  .orig_video_cols	= 80,
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 909d974d35d9..ac95dd8b119f 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -11,12 +11,15 @@
  *
  */
 
+#define pr_fmt(fmt)	"efi: " fmt
+
 #include <linux/efi.h>
 #include <linux/init.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
+#include <linux/screen_info.h>
 
 #include <asm/efi.h>
 
@@ -51,6 +54,32 @@ static phys_addr_t efi_to_phys(unsigned long addr)
 	return addr;
 }
 
+static __initdata unsigned long screen_info_table = EFI_INVALID_TABLE_ADDR;
+
+static __initdata efi_config_table_type_t arch_tables[] = {
+	{LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID, NULL, &screen_info_table},
+	{NULL_GUID, NULL, NULL}
+};
+
+static void __init init_screen_info(void)
+{
+	struct screen_info *si;
+
+	if (screen_info_table != EFI_INVALID_TABLE_ADDR) {
+		si = early_memremap_ro(screen_info_table, sizeof(*si));
+		if (!si) {
+			pr_err("Could not map screen_info config table\n");
+			return;
+		}
+		screen_info = *si;
+		early_memunmap(si, sizeof(*si));
+
+		/* dummycon on ARM needs non-zero values for columns/lines */
+		screen_info.orig_video_cols = 80;
+		screen_info.orig_video_lines = 25;
+	}
+}
+
 static int __init uefi_init(void)
 {
 	efi_char16_t *c16;
@@ -108,7 +137,8 @@ static int __init uefi_init(void)
 		goto out;
 	}
 	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
-					 sizeof(efi_config_table_t), NULL);
+					 sizeof(efi_config_table_t),
+					 arch_tables);
 
 	early_memunmap(config_tables, table_size);
 out:
@@ -223,4 +253,6 @@ void __init efi_init(void)
 				 PAGE_ALIGN(params.mmap_size +
 					    (params.mmap & ~PAGE_MASK)));
 	}
+
+	init_screen_info();
 }
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 583e647912a5..4991371012b4 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -353,8 +353,9 @@ static __init int match_config_table(efi_guid_t *guid,
 		for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
 			if (!efi_guidcmp(*guid, table_types[i].guid)) {
 				*(table_types[i].ptr) = table;
-				pr_cont(" %s=0x%lx ",
-					table_types[i].name, table);
+				if (table_types[i].name)
+					pr_cont(" %s=0x%lx ",
+						table_types[i].name, table);
 				return 1;
 			}
 		}
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 6f42be4d0084..e1f0b28e1dcb 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -26,6 +26,43 @@ efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 	return EFI_SUCCESS;
 }
 
+static efi_guid_t screen_info_guid = LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID;
+
+struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg)
+{
+	struct screen_info *si;
+	efi_status_t status;
+
+	/*
+	 * Unlike on arm64, where we can directly fill out the screen_info
+	 * structure from the stub, we need to allocate a buffer to hold
+	 * its contents while we hand over to the kernel proper from the
+	 * decompressor.
+	 */
+	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+				sizeof(*si), (void **)&si);
+
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	status = efi_call_early(install_configuration_table,
+				&screen_info_guid, si);
+	if (status == EFI_SUCCESS)
+		return si;
+
+	efi_call_early(free_pool, si);
+	return NULL;
+}
+
+void free_screen_info(efi_system_table_t *sys_table_arg, struct screen_info *si)
+{
+	if (!si)
+		return;
+
+	efi_call_early(install_configuration_table, &screen_info_guid, NULL);
+	efi_call_early(free_pool, si);
+}
+
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
 				 unsigned long *image_size,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9203bbb28887..e53458842245 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -286,7 +286,7 @@ typedef struct {
 	efi_status_t (*locate_handle)(int, efi_guid_t *, void *,
 				      unsigned long *, efi_handle_t *);
 	void *locate_device_path;
-	void *install_configuration_table;
+	efi_status_t (*install_configuration_table)(efi_guid_t *, void *);
 	void *load_image;
 	void *start_image;
 	void *exit;
@@ -633,6 +633,15 @@ void efi_native_runtime_setup(void);
 	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, \
 		 0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
 
+/*
+ * This GUID is used to pass to the kernel proper the struct screen_info
+ * structure that was populated by the stub based on the GOP protocol instance
+ * associated with ConOut
+ */
+#define LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID \
+	EFI_GUID(0xe03fc20a, 0x85dc, 0x406e, \
+		 0xb9, 0xe, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
-- 
2.7.3
