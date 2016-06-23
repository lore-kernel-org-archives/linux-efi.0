From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 09/11] efi/runtime-map: Use efi.memmap directly instead of a copy
Date: Thu, 23 Jun 2016 12:34:48 +0100
Message-ID: <1466681690-5850-10-git-send-email-matt@codeblueprint.co.uk>
References: <1466681690-5850-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466681690-5850-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that efi.memmap is available all of the time there's no need to
allocate and build a separate copy of the EFI memory map.

Furthermore, efi.memmap contains boot services regions but only those
regions that have been reserved via efi_mem_reserve(). Using
efi.memmap allows us to pass boot services across kexec reboot so that
the ESRT and BGRT drivers will now work.

Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi.c        | 40 --------------------------------------
 drivers/firmware/efi/runtime-map.c | 35 +++++++++++++--------------------
 include/linux/efi.h                |  4 ----
 3 files changed, 13 insertions(+), 66 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 33bc6c12702c..8ac32128ca94 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -608,42 +608,6 @@ static void __init get_systab_virt_addr(efi_memory_desc_t *md)
 	}
 }
 
-static void __init save_runtime_map(void)
-{
-#ifdef CONFIG_KEXEC_CORE
-	unsigned long desc_size;
-	efi_memory_desc_t *md;
-	void *tmp, *q = NULL;
-	int count = 0;
-
-	if (efi_enabled(EFI_OLD_MEMMAP))
-		return;
-
-	desc_size = efi.memmap.desc_size;
-
-	for_each_efi_memory_desc(md) {
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) ||
-		    (md->type == EFI_BOOT_SERVICES_CODE) ||
-		    (md->type == EFI_BOOT_SERVICES_DATA))
-			continue;
-		tmp = krealloc(q, (count + 1) * desc_size, GFP_KERNEL);
-		if (!tmp)
-			goto out;
-		q = tmp;
-
-		memcpy(q + count * desc_size, md, desc_size);
-		count++;
-	}
-
-	efi_runtime_map_setup(q, count, desc_size);
-	return;
-
-out:
-	kfree(q);
-	pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
-#endif
-}
-
 static void *realloc_pages(void *old_memmap, int old_shift)
 {
 	void *ret;
@@ -856,8 +820,6 @@ static void __init kexec_enter_virtual_mode(void)
 		return;
 	}
 
-	save_runtime_map();
-
 	BUG_ON(!efi.systab);
 
 	num_pages = ALIGN(efi.memmap.nr_map * efi.memmap.desc_size, PAGE_SIZE);
@@ -950,8 +912,6 @@ static void __init __efi_enter_virtual_mode(void)
 		return;
 	}
 
-	save_runtime_map();
-
 	BUG_ON(!efi.systab);
 
 	if (efi_setup_page_tables(pa, 1 << pg_shift)) {
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
index 5c55227a34c8..8e64b77aeac9 100644
--- a/drivers/firmware/efi/runtime-map.c
+++ b/drivers/firmware/efi/runtime-map.c
@@ -14,10 +14,6 @@
 
 #include <asm/setup.h>
 
-static void *efi_runtime_map;
-static int nr_efi_runtime_map;
-static u32 efi_memdesc_size;
-
 struct efi_runtime_map_entry {
 	efi_memory_desc_t md;
 	struct kobject kobj;   /* kobject for each entry */
@@ -106,7 +102,8 @@ static struct kobj_type __refdata map_ktype = {
 static struct kset *map_kset;
 
 static struct efi_runtime_map_entry *
-add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
+add_sysfs_runtime_map_entry(struct kobject *kobj, int nr,
+			    efi_memory_desc_t *md)
 {
 	int ret;
 	struct efi_runtime_map_entry *entry;
@@ -124,8 +121,7 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
 		return ERR_PTR(-ENOMEM);
 	}
 
-	memcpy(&entry->md, efi_runtime_map + nr * efi_memdesc_size,
-	       sizeof(efi_memory_desc_t));
+	memcpy(&entry->md, md, sizeof(efi_memory_desc_t));
 
 	kobject_init(&entry->kobj, &map_ktype);
 	entry->kobj.kset = map_kset;
@@ -142,12 +138,12 @@ add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
 
 int efi_get_runtime_map_size(void)
 {
-	return nr_efi_runtime_map * efi_memdesc_size;
+	return efi.memmap.nr_map * efi.memmap.desc_size;
 }
 
 int efi_get_runtime_map_desc_size(void)
 {
-	return efi_memdesc_size;
+	return efi.memmap.desc_size;
 }
 
 int efi_runtime_map_copy(void *buf, size_t bufsz)
@@ -157,38 +153,33 @@ int efi_runtime_map_copy(void *buf, size_t bufsz)
 	if (sz > bufsz)
 		sz = bufsz;
 
-	memcpy(buf, efi_runtime_map, sz);
+	memcpy(buf, efi.memmap.map, sz);
 	return 0;
 }
 
-void efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size)
-{
-	efi_runtime_map = map;
-	nr_efi_runtime_map = nr_entries;
-	efi_memdesc_size = desc_size;
-}
-
 int __init efi_runtime_map_init(struct kobject *efi_kobj)
 {
 	int i, j, ret = 0;
 	struct efi_runtime_map_entry *entry;
+	efi_memory_desc_t *md;
 
-	if (!efi_runtime_map)
+	if (!efi_enabled(EFI_MEMMAP))
 		return 0;
 
-	map_entries = kzalloc(nr_efi_runtime_map * sizeof(entry), GFP_KERNEL);
+	map_entries = kzalloc(efi.memmap.nr_map * sizeof(entry), GFP_KERNEL);
 	if (!map_entries) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	for (i = 0; i < nr_efi_runtime_map; i++) {
-		entry = add_sysfs_runtime_map_entry(efi_kobj, i);
+	i = 0;
+	for_each_efi_memory_desc(md) {
+		entry = add_sysfs_runtime_map_entry(efi_kobj, i, md);
 		if (IS_ERR(entry)) {
 			ret = PTR_ERR(entry);
 			goto out_add_entry;
 		}
-		*(map_entries + i) = entry;
+		*(map_entries + i++) = entry;
 	}
 
 	return 0;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 9f955dab9f77..729ce6f1af13 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1431,7 +1431,6 @@ extern int efi_capsule_update(efi_capsule_header_t *capsule,
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
-void efi_runtime_map_setup(void *, int, u32);
 int efi_get_runtime_map_size(void);
 int efi_get_runtime_map_desc_size(void);
 int efi_runtime_map_copy(void *buf, size_t bufsz);
@@ -1441,9 +1440,6 @@ static inline int efi_runtime_map_init(struct kobject *kobj)
 	return 0;
 }
 
-static inline void
-efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
-
 static inline int efi_get_runtime_map_size(void)
 {
 	return 0;
-- 
2.7.3
