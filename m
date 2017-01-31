From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 08/10] efi/x86: Move EFI BGRT init code to early init code
Date: Tue, 31 Jan 2017 13:21:40 +0000
Message-ID: <1485868902-20401-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Dave Young <dyoung@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Dave Young <dyoung@redhat.com>

Before invoking the arch specific handler, efi_mem_reserve() reserves
the given memory region through memblock.

efi_bgrt_init() will call efi_mem_reserve() after mm_init(), at which
time memblock is dead and should not be used anymore.

The EFI BGRT code depends on ACPI initialization to get the BGRT ACPI
table, so move parsing of the BGRT table to ACPI early boot code to
ensure that efi_mem_reserve() in EFI BGRT code still use memblock safely.

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Tested-by: Bhupesh Sharma <bhsharma@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/kernel/acpi/boot.c      |  9 ++++++
 arch/x86/platform/efi/efi-bgrt.c | 59 +++++++++++++++++-----------------------
 arch/x86/platform/efi/efi.c      |  5 ----
 drivers/acpi/bgrt.c              | 28 +++++++++++++------
 include/linux/efi-bgrt.h         | 11 ++++----
 init/main.c                      |  1 -
 6 files changed, 59 insertions(+), 54 deletions(-)

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
index 274dfc481849..0d4becfc5145 100644
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
 
-- 
2.7.4
