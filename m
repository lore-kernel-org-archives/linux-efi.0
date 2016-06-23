From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 06/11] efi: Split out EFI memory map functions into new file
Date: Thu, 23 Jun 2016 12:34:45 +0100
Message-ID: <1466681690-5850-7-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Also move the functions from the EFI fake mem driver since future
patches will require access to the memmap insertion code even if
CONFIG_EFI_FAKE_MEM isn't enabled.

This will be useful when we need to build custom EFI memory maps to
allow drivers to mark regions as reserved.

Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/Makefile   |   2 +-
 drivers/firmware/efi/efi.c      | 129 -------------------
 drivers/firmware/efi/fake_mem.c | 143 +--------------------
 drivers/firmware/efi/memmap.c   | 267 ++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h             |  10 ++
 5 files changed, 284 insertions(+), 267 deletions(-)
 create mode 100644 drivers/firmware/efi/memmap.c

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index a219640f881f..b3f5e2adc49f 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -10,7 +10,7 @@
 KASAN_SANITIZE_runtime-wrappers.o	:= n
 
 obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o memattr.o
-obj-$(CONFIG_EFI)			+= capsule.o
+obj-$(CONFIG_EFI)			+= capsule.o memmap.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 50eda492d0bb..d9c41a434462 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -420,135 +420,6 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 	return ret;
 }
 
-/**
- * __efi_memmap_init - Common code for mapping the EFI memory map
- * @data: EFI memory map data
- * @late: Use early or late mapping function?
- *
- * This function takes care of figuring out which function to use to
- * map the EFI memory map in efi.memmap based on how far into the boot
- * we are.
- *
- * During bootup @late should be %false since we only have access to
- * the early_memremap*() functions as the vmalloc space isn't setup.
- * Once the kernel is fully booted we can fallback to the more robust
- * memremap*() API.
- *
- * Returns zero on success, a negative error code on failure.
- */
-static int __init
-__efi_memmap_init(struct efi_memory_map_data *data, bool late)
-{
-	struct efi_memory_map map;
-	phys_addr_t phys_map;
-
-	if (efi_enabled(EFI_PARAVIRT))
-		return 0;
-
-	phys_map = data->phys_map;
-
-	if (late)
-		map.map = memremap(phys_map, data->size, MEMREMAP_WB);
-	else
-		map.map = early_memremap(phys_map, data->size);
-
-	if (!map.map) {
-		pr_err("Could not map the memory map!\n");
-		return -ENOMEM;
-	}
-
-	map.phys_map = data->phys_map;
-	map.nr_map = data->size / data->desc_size;
-	map.map_end = map.map + data->size;
-
-	map.desc_version = data->desc_version;
-	map.desc_size = data->desc_size;
-	map.late = late;
-
-	set_bit(EFI_MEMMAP, &efi.flags);
-
-	efi.memmap = map;
-
-	return 0;
-}
-
-/**
- * efi_memmap_init_early - Map the EFI memory map data structure
- * @data: EFI memory map data
- *
- * Use early_memremap() to map the passed in EFI memory map and assign
- * it to efi.memmap.
- */
-int __init efi_memmap_init_early(struct efi_memory_map_data *data)
-{
-	/* Cannot go backwards */
-	WARN_ON(efi.memmap.late);
-
-	return __efi_memmap_init(data, false);
-}
-
-void __init efi_memmap_unmap(void)
-{
-	if (!efi.memmap.late) {
-		unsigned long size;
-
-		size = efi.memmap.desc_size * efi.memmap.nr_map;
-		early_memunmap(efi.memmap.map, size);
-	} else {
-		memunmap(efi.memmap.map);
-	}
-
-	efi.memmap.map = NULL;
-	clear_bit(EFI_MEMMAP, &efi.flags);
-}
-
-/**
- * efi_memmap_init_late - Map efi.memmap with memremap()
- * @phys_addr: Physical address of the new EFI memory map
- * @size: Size in bytes of the new EFI memory map
- *
- * Setup a mapping of the EFI memory map using ioremap_cache(). This
- * function should only be called once the vmalloc space has been
- * setup and is therefore not suitable for calling during early EFI
- * initialise, e.g. in efi_init(). Additionally, it expects
- * efi_memmap_init_early() to have already been called.
- *
- * The reason there are two EFI memmap initialisation
- * (efi_memmap_init_early() and this late version) is because the
- * early EFI memmap should be explicitly unmapped once EFI
- * initialisation is complete as the fixmap space used to map the EFI
- * memmap (via early_memremap()) is a scarce resource.
- *
- * This late mapping is intended to persist for the duration of
- * runtime so that things like efi_mem_desc_lookup() and
- * efi_mem_attributes() always work.
- *
- * Returns zero on success, a negative error code on failure.
- */
-int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size)
-{
-	struct efi_memory_map_data data = {
-		.phys_map = addr,
-		.size = size,
-	};
-
-	/* Did we forget to unmap the early EFI memmap? */
-	WARN_ON(efi.memmap.map);
-
-	/* Were we already called? */
-	WARN_ON(efi.memmap.late);
-
-	/*
-	 * It makes no sense to allow callers to register different
-	 * values for the following fields. Copy them out of the
-	 * existing early EFI memmap.
-	 */
-	data.desc_version = efi.memmap.desc_version;
-	data.desc_size = efi.memmap.desc_size;
-
-	return __efi_memmap_init(&data, true);
-}
-
 #ifdef CONFIG_EFI_VARS_MODULE
 static int __init efi_load_efivars(void)
 {
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 446c669431c0..0054730f9bae 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -35,17 +35,13 @@
 
 #define EFI_MAX_FAKEMEM CONFIG_EFI_MAX_FAKE_MEM
 
-struct fake_mem {
-	struct range range;
-	u64 attribute;
-};
-static struct fake_mem fake_mems[EFI_MAX_FAKEMEM];
+static struct efi_mem_range fake_mems[EFI_MAX_FAKEMEM];
 static int nr_fake_mem;
 
 static int __init cmp_fake_mem(const void *x1, const void *x2)
 {
-	const struct fake_mem *m1 = x1;
-	const struct fake_mem *m2 = x2;
+	const struct efi_mem_range *m1 = x1;
+	const struct efi_mem_range *m2 = x2;
 
 	if (m1->range.start < m2->range.start)
 		return -1;
@@ -54,133 +50,6 @@ static int __init cmp_fake_mem(const void *x1, const void *x2)
 	return 0;
 }
 
-/**
- * efi_fake_memmap_split_count - Count number of additional EFI memmap entries
- * @md: EFI memory descriptor to split
- * @range: Address range (start, end) to split around
- *
- * Returns the number of additional EFI memmap entries required to
- * accomodate @range.
- */
-static int efi_fake_memmap_split_count(efi_memory_desc_t *md, struct range *range)
-{
-	u64 m_start, m_end;
-	u64 start, end;
-	int count = 0;
-
-	start = md->phys_addr;
-	end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
-
-	/* modifying range */
-	m_start = range->start;
-	m_end = range->end;
-
-	if (m_start <= start) {
-		/* split into 2 parts */
-		if (start < m_end && m_end < end)
-			count++;
-	}
-
-	if (start < m_start && m_start < end) {
-		/* split into 3 parts */
-		if (m_end < end)
-			count += 2;
-		/* split into 2 parts */
-		if (end <= m_end)
-			count++;
-	}
-
-	return count;
-}
-
-/**
- * efi_fake_memmap_insert - Insert a fake memory region in an EFI memmap
- * @old_memmap: The existing EFI memory map structure
- * @buf: Address of buffer to store new map
- * @mem: Fake memory map entry to insert
- *
- * It is suggested that you call efi_fake_memmap_split_count() first
- * to see how large @buf needs to be.
- */
-static void efi_fake_memmap_insert(struct efi_memory_map *old_memmap,
-				   void *buf, struct fake_mem *mem)
-{
-	u64 m_start, m_end, m_attr;
-	efi_memory_desc_t *md;
-	u64 start, end;
-	void *old, *new;
-
-	/* modifying range */
-	m_start = mem->range.start;
-	m_end = mem->range.end;
-	m_attr = mem->attribute;
-
-	for (old = old_memmap->map, new = buf;
-	     old < old_memmap->map_end;
-	     old += old_memmap->desc_size, new += old_memmap->desc_size) {
-
-		/* copy original EFI memory descriptor */
-		memcpy(new, old, old_memmap->desc_size);
-		md = new;
-		start = md->phys_addr;
-		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
-
-		if (m_start <= start && end <= m_end)
-			md->attribute |= m_attr;
-
-		if (m_start <= start &&
-		    (start < m_end && m_end < end)) {
-			/* first part */
-			md->attribute |= m_attr;
-			md->num_pages = (m_end - md->phys_addr + 1) >>
-				EFI_PAGE_SHIFT;
-			/* latter part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->phys_addr = m_end + 1;
-			md->num_pages = (end - md->phys_addr + 1) >>
-				EFI_PAGE_SHIFT;
-		}
-
-		if ((start < m_start && m_start < end) && m_end < end) {
-			/* first part */
-			md->num_pages = (m_start - md->phys_addr) >>
-				EFI_PAGE_SHIFT;
-			/* middle part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->attribute |= m_attr;
-			md->phys_addr = m_start;
-			md->num_pages = (m_end - m_start + 1) >>
-				EFI_PAGE_SHIFT;
-			/* last part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->phys_addr = m_end + 1;
-			md->num_pages = (end - m_end) >>
-				EFI_PAGE_SHIFT;
-		}
-
-		if ((start < m_start && m_start < end) &&
-		    (end <= m_end)) {
-			/* first part */
-			md->num_pages = (m_start - md->phys_addr) >>
-				EFI_PAGE_SHIFT;
-			/* latter part */
-			new += old_memmap->desc_size;
-			memcpy(new, old, old_memmap->desc_size);
-			md = new;
-			md->phys_addr = m_start;
-			md->num_pages = (end - md->phys_addr + 1) >>
-				EFI_PAGE_SHIFT;
-			md->attribute |= m_attr;
-		}
-	}
-}
-
 void __init efi_fake_memmap(void)
 {
 	struct efi_memory_map_data data;
@@ -198,7 +67,7 @@ void __init efi_fake_memmap(void)
 		for_each_efi_memory_desc(md) {
 			struct range *r = &fake_mems[i].range;
 
-			new_nr_map += efi_fake_memmap_split_count(md, r);
+			new_nr_map += efi_memmap_split_count(md, r);
 		}
 	}
 
@@ -217,7 +86,7 @@ void __init efi_fake_memmap(void)
 	}
 
 	for (i = 0; i < nr_fake_mem; i++)
-		efi_fake_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i]);
+		efi_memmap_insert(&efi.memmap, new_memmap, &fake_mems[i]);
 
 	/* swap into new EFI memmap */
 	early_memunmap(new_memmap, efi.memmap.desc_size * new_nr_map);
@@ -265,7 +134,7 @@ static int __init setup_fake_mem(char *p)
 			p++;
 	}
 
-	sort(fake_mems, nr_fake_mem, sizeof(struct fake_mem),
+	sort(fake_mems, nr_fake_mem, sizeof(struct efi_mem_range),
 	     cmp_fake_mem, NULL);
 
 	for (i = 0; i < nr_fake_mem; i++)
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
new file mode 100644
index 000000000000..2df7238eb44e
--- /dev/null
+++ b/drivers/firmware/efi/memmap.c
@@ -0,0 +1,267 @@
+/*
+ * Common EFI memory map functions.
+ */
+
+#define pr_fmt(fmt) "efi: " fmt
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/efi.h>
+#include <linux/io.h>
+#include <asm/early_ioremap.h>
+
+/**
+ * __efi_memmap_init - Common code for mapping the EFI memory map
+ * @data: EFI memory map data
+ * @late: Use early or late mapping function?
+ *
+ * This function takes care of figuring out which function to use to
+ * map the EFI memory map in efi.memmap based on how far into the boot
+ * we are.
+ *
+ * During bootup @late should be %false since we only have access to
+ * the early_memremap*() functions as the vmalloc space isn't setup.
+ * Once the kernel is fully booted we can fallback to the more robust
+ * memremap*() API.
+ *
+ * Returns zero on success, a negative error code on failure.
+ */
+static int __init
+__efi_memmap_init(struct efi_memory_map_data *data, bool late)
+{
+	struct efi_memory_map map;
+	phys_addr_t phys_map;
+
+	if (efi_enabled(EFI_PARAVIRT))
+		return 0;
+
+	phys_map = data->phys_map;
+
+	if (late)
+		map.map = memremap(phys_map, data->size, MEMREMAP_WB);
+	else
+		map.map = early_memremap(phys_map, data->size);
+
+	if (!map.map) {
+		pr_err("Could not map the memory map!\n");
+		return -ENOMEM;
+	}
+
+	map.phys_map = data->phys_map;
+	map.nr_map = data->size / data->desc_size;
+	map.map_end = map.map + data->size;
+
+	map.desc_version = data->desc_version;
+	map.desc_size = data->desc_size;
+	map.late = late;
+
+	set_bit(EFI_MEMMAP, &efi.flags);
+
+	efi.memmap = map;
+
+	return 0;
+}
+
+/**
+ * efi_memmap_init_early - Map the EFI memory map data structure
+ * @data: EFI memory map data
+ *
+ * Use early_memremap() to map the passed in EFI memory map and assign
+ * it to efi.memmap.
+ */
+int __init efi_memmap_init_early(struct efi_memory_map_data *data)
+{
+	/* Cannot go backwards */
+	WARN_ON(efi.memmap.late);
+
+	return __efi_memmap_init(data, false);
+}
+
+void __init efi_memmap_unmap(void)
+{
+	if (!efi.memmap.late) {
+		unsigned long size;
+
+		size = efi.memmap.desc_size * efi.memmap.nr_map;
+		early_memunmap(efi.memmap.map, size);
+	} else {
+		memunmap(efi.memmap.map);
+	}
+
+	efi.memmap.map = NULL;
+	clear_bit(EFI_MEMMAP, &efi.flags);
+}
+
+/**
+ * efi_memmap_init_late - Map efi.memmap with memremap()
+ * @phys_addr: Physical address of the new EFI memory map
+ * @size: Size in bytes of the new EFI memory map
+ *
+ * Setup a mapping of the EFI memory map using ioremap_cache(). This
+ * function should only be called once the vmalloc space has been
+ * setup and is therefore not suitable for calling during early EFI
+ * initialise, e.g. in efi_init(). Additionally, it expects
+ * efi_memmap_init_early() to have already been called.
+ *
+ * The reason there are two EFI memmap initialisation
+ * (efi_memmap_init_early() and this late version) is because the
+ * early EFI memmap should be explicitly unmapped once EFI
+ * initialisation is complete as the fixmap space used to map the EFI
+ * memmap (via early_memremap()) is a scarce resource.
+ *
+ * This late mapping is intended to persist for the duration of
+ * runtime so that things like efi_mem_desc_lookup() and
+ * efi_mem_attributes() always work.
+ *
+ * Returns zero on success, a negative error code on failure.
+ */
+int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size)
+{
+	struct efi_memory_map_data data = {
+		.phys_map = addr,
+		.size = size,
+	};
+
+	/* Did we forget to unmap the early EFI memmap? */
+	WARN_ON(efi.memmap.map);
+
+	/* Were we already called? */
+	WARN_ON(efi.memmap.late);
+
+	/*
+	 * It makes no sense to allow callers to register different
+	 * values for the following fields. Copy them out of the
+	 * existing early EFI memmap.
+	 */
+	data.desc_version = efi.memmap.desc_version;
+	data.desc_size = efi.memmap.desc_size;
+
+	return __efi_memmap_init(&data, true);
+}
+
+/**
+ * efi_memmap_split_count - Count number of additional EFI memmap entries
+ * @md: EFI memory descriptor to split
+ * @range: Address range (start, end) to split around
+ *
+ * Returns the number of additional EFI memmap entries required to
+ * accomodate @range.
+ */
+int __init efi_memmap_split_count(efi_memory_desc_t *md, struct range *range)
+{
+	u64 m_start, m_end;
+	u64 start, end;
+	int count = 0;
+
+	start = md->phys_addr;
+	end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+	/* modifying range */
+	m_start = range->start;
+	m_end = range->end;
+
+	if (m_start <= start) {
+		/* split into 2 parts */
+		if (start < m_end && m_end < end)
+			count++;
+	}
+
+	if (start < m_start && m_start < end) {
+		/* split into 3 parts */
+		if (m_end < end)
+			count += 2;
+		/* split into 2 parts */
+		if (end <= m_end)
+			count++;
+	}
+
+	return count;
+}
+
+/**
+ * efi_memmap_insert - Insert a memory region in an EFI memmap
+ * @old_memmap: The existing EFI memory map structure
+ * @buf: Address of buffer to store new map
+ * @mem: Memory map entry to insert
+ *
+ * It is suggested that you call efi_memmap_split_count() first
+ * to see how large @buf needs to be.
+ */
+void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
+			      struct efi_mem_range *mem)
+{
+	u64 m_start, m_end, m_attr;
+	efi_memory_desc_t *md;
+	u64 start, end;
+	void *old, *new;
+
+	/* modifying range */
+	m_start = mem->range.start;
+	m_end = mem->range.end;
+	m_attr = mem->attribute;
+
+	for (old = old_memmap->map, new = buf;
+	     old < old_memmap->map_end;
+	     old += old_memmap->desc_size, new += old_memmap->desc_size) {
+
+		/* copy original EFI memory descriptor */
+		memcpy(new, old, old_memmap->desc_size);
+		md = new;
+		start = md->phys_addr;
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+		if (m_start <= start && end <= m_end)
+			md->attribute |= m_attr;
+
+		if (m_start <= start &&
+		    (start < m_end && m_end < end)) {
+			/* first part */
+			md->attribute |= m_attr;
+			md->num_pages = (m_end - md->phys_addr + 1) >>
+				EFI_PAGE_SHIFT;
+			/* latter part */
+			new += old_memmap->desc_size;
+			memcpy(new, old, old_memmap->desc_size);
+			md = new;
+			md->phys_addr = m_end + 1;
+			md->num_pages = (end - md->phys_addr + 1) >>
+				EFI_PAGE_SHIFT;
+		}
+
+		if ((start < m_start && m_start < end) && m_end < end) {
+			/* first part */
+			md->num_pages = (m_start - md->phys_addr) >>
+				EFI_PAGE_SHIFT;
+			/* middle part */
+			new += old_memmap->desc_size;
+			memcpy(new, old, old_memmap->desc_size);
+			md = new;
+			md->attribute |= m_attr;
+			md->phys_addr = m_start;
+			md->num_pages = (m_end - m_start + 1) >>
+				EFI_PAGE_SHIFT;
+			/* last part */
+			new += old_memmap->desc_size;
+			memcpy(new, old, old_memmap->desc_size);
+			md = new;
+			md->phys_addr = m_end + 1;
+			md->num_pages = (end - m_end) >>
+				EFI_PAGE_SHIFT;
+		}
+
+		if ((start < m_start && m_start < end) &&
+		    (end <= m_end)) {
+			/* first part */
+			md->num_pages = (m_start - md->phys_addr) >>
+				EFI_PAGE_SHIFT;
+			/* latter part */
+			new += old_memmap->desc_size;
+			memcpy(new, old, old_memmap->desc_size);
+			md = new;
+			md->phys_addr = m_start;
+			md->num_pages = (end - md->phys_addr + 1) >>
+				EFI_PAGE_SHIFT;
+			md->attribute |= m_attr;
+		}
+	}
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index deb9d1c79bbf..8fb8b80b86ac 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -20,6 +20,7 @@
 #include <linux/ioport.h>
 #include <linux/pfn.h>
 #include <linux/pstore.h>
+#include <linux/range.h>
 #include <linux/reboot.h>
 #include <linux/uuid.h>
 #include <linux/screen_info.h>
@@ -764,6 +765,11 @@ struct efi_memory_map {
 	bool late;
 };
 
+struct efi_mem_range {
+	struct range range;
+	u64 attribute;
+};
+
 struct efi_fdt_params {
 	u64 system_table;
 	u64 mmap;
@@ -990,6 +996,10 @@ extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
 extern int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size);
 extern void __init efi_memmap_unmap(void);
+extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
+					 struct range *range);
+extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
+				     void *buf, struct efi_mem_range *mem);
 
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
 #ifdef CONFIG_EFI_ESRT
-- 
2.7.3
