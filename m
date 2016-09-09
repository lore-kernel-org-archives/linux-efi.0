From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 07/29] efi: Add efi_memmap_install() for installing new EFI memory maps
Date: Fri,  9 Sep 2016 16:18:29 +0100
Message-ID: <20160909151851.27577-8-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160909151851.27577-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

While efi_memmap_init_{early,late}() exist for architecture code to
install memory maps from firmware data and for the virtual memory
regions respectively, drivers don't care which stage of the boot we're
at and just want to swap the existing memmap for a modified one.

efi_memmap_install() abstracts the details of how the new memory map
should be mapped and the existing one unmapped.

Tested-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> [kexec/kdump]
Tested-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> [arm]
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/fake_mem.c |  8 +-------
 drivers/firmware/efi/memmap.c   | 25 +++++++++++++++++++++++++
 include/linux/efi.h             |  1 +
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 0054730f9bae..520a40e5e0e4 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -52,7 +52,6 @@ static int __init cmp_fake_mem(const void *x1, const void *x2)
 
 void __init efi_fake_memmap(void)
 {
-	struct efi_memory_map_data data;
 	int new_nr_map = efi.memmap.nr_map;
 	efi_memory_desc_t *md;
 	phys_addr_t new_memmap_phy;
@@ -90,13 +89,8 @@ void __init efi_fake_memmap(void)
 
 	/* swap into new EFI memmap */
 	early_memunmap(new_memmap, efi.memmap.desc_size * new_nr_map);
-	efi_memmap_unmap();
 
-	data.phys_map = new_memmap_phy;
-	data.size = efi.memmap.desc_size * new_nr_map;
-	data.desc_version = efi.memmap.desc_version;
-	data.desc_size = efi.memmap.desc_size;
-	efi_memmap_init_early(&data);
+	efi_memmap_install(new_memmap_phy, new_nr_map);
 
 	/* print new EFI memmap */
 	efi_print_memmap();
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index 2df7238eb44e..cd96086fd851 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -140,6 +140,31 @@ int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size)
 }
 
 /**
+ * efi_memmap_install - Install a new EFI memory map in efi.memmap
+ * @addr: Physical address of the memory map
+ * @nr_map: Number of entries in the memory map
+ *
+ * Unlike efi_memmap_init_*(), this function does not allow the caller
+ * to switch from early to late mappings. It simply uses the existing
+ * mapping function and installs the new memmap.
+ *
+ * Returns zero on success, a negative error code on failure.
+ */
+int __init efi_memmap_install(phys_addr_t addr, unsigned int nr_map)
+{
+	struct efi_memory_map_data data;
+
+	efi_memmap_unmap();
+
+	data.phys_map = addr;
+	data.size = efi.memmap.desc_size * nr_map;
+	data.desc_version = efi.memmap.desc_version;
+	data.desc_size = efi.memmap.desc_size;
+
+	return __efi_memmap_init(&data, efi.memmap.late);
+}
+
+/**
  * efi_memmap_split_count - Count number of additional EFI memmap entries
  * @md: EFI memory descriptor to split
  * @range: Address range (start, end) to split around
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 84c8638c7a8b..987c18f6fcae 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -923,6 +923,7 @@ extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
 extern int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size);
 extern void __init efi_memmap_unmap(void);
+extern int __init efi_memmap_install(phys_addr_t addr, unsigned int nr_map);
 extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
 					 struct range *range);
 extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
-- 
2.9.3
