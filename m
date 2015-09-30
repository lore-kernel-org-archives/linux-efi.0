From: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 2/2] x86, efi: Add "efi_fake_mem" boot option
Date: Wed, 30 Sep 2015 23:01:56 +0900
Message-ID: <1443621716-209818-1-git-send-email-izumi.taku@jp.fujitsu.com>
References: <201509300948.PGoujrqX%fengguang.wu@intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201509300948.PGoujrqX%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org
Cc: tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, qinxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This patch introduces new boot option named "efi_fake_mem".
By specifying this parameter, you can add arbitrary attribute
to specific memory range.
This is useful for debugging of Address Range Mirroring feature.

For example, if "efi_fake_mem=2G@4G:0x10000,2G@0x10a0000000:0x10000"
is specified, the original (firmware provided) EFI memmap will be
updated so that the specified memory regions have
EFI_MEMORY_MORE_RELIABLE attribute (0x10000):

 <original>
   efi: mem36: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x00000020a0000000) (129536MB)

 <updated>
   efi: mem36: [Conventional Memory|  |MR|  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x0000000180000000) (2048MB)
   efi: mem37: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000180000000-0x00000010a0000000) (61952MB)
   efi: mem38: [Conventional Memory|  |MR|  |  |  |   |WB|WT|WC|UC] range=[0x00000010a0000000-0x0000001120000000) (2048MB)
   efi: mem39: [Conventional Memory|  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000001120000000-0x00000020a0000000) (63488MB)

And you will find that the following message is output:

   efi: Memory: 4096M/131455M mirrored memory

Signed-off-by: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 Documentation/kernel-parameters.txt |  15 +++
 arch/x86/kernel/setup.c             |   4 +-
 drivers/firmware/efi/Kconfig        |  22 ++++
 drivers/firmware/efi/Makefile       |   1 +
 drivers/firmware/efi/fake_mem.c     | 238 ++++++++++++++++++++++++++++++++++++
 include/linux/efi.h                 |   6 +
 6 files changed, 285 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/fake_mem.c

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 22a4b68..50fc09b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1094,6 +1094,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			you are really sure that your UEFI does sane gc and
 			fulfills the spec otherwise your board may brick.
 
+	efi_fake_mem=	nn[KMG]@ss[KMG]:aa[,nn[KMG]@ss[KMG]:aa,..] [EFI; X86]
+			Add arbitrary attribute to specific memory range by
+			updating original EFI memory map.
+			Region of memory which aa attribute is added to is
+			from ss to ss+nn.
+			If efi_fake_mem=2G@4G:0x10000,2G@0x10a0000000:0x10000
+			is specified, EFI_MEMORY_MORE_RELIABLE(0x10000)
+			attribute is added to range 0x100000000-0x180000000 and
+			0x10a0000000-0x1120000000.
+
+			Using this parameter you can do debugging of EFI memmap
+			related feature. For example, you can do debugging of
+			Address Range Mirroring feature even if your box
+			doesn't support it.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index fdb7f2a..30b4c44 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1079,8 +1079,10 @@ void __init setup_arch(char **cmdline_p)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
-	if (efi_enabled(EFI_BOOT))
+	if (efi_enabled(EFI_BOOT)) {
+		efi_fake_memmap();
 		efi_find_mirror();
+	}
 
 	/*
 	 * The EFI specification says that boot service code won't be called
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 84533e0..ac47cc4d 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -52,6 +52,28 @@ config EFI_RUNTIME_MAP
 
 	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
 
+config EFI_FAKE_MEMMAP
+	bool "Enable EFI fake memory map"
+	depends on EFI && X86
+	default n
+	help
+	  Saying Y here will enable "efi_fake_mem" boot option.
+	  By specifying this parameter, you can add arbitrary attribute
+	  to specific memory range by updating original (firmware provided)
+	  EFI memmap.
+	  This is useful for debugging of EFI memmap related feature.
+	  e.g. Address Range Mirroring feature.
+
+config EFI_MAX_FAKE_MEM
+	int "maximum allowable number of ranges in efi_fake_mem boot option"
+	depends on EFI && X86 && EFI_FAKE_MEMMAP
+	range 1 128
+	default 8
+	help
+	  Maximum allowable number of ranges in efi_fake_mem boot option.
+	  Ranges can be set up to this value using comma-separated list.
+	  The default value is 8.
+
 config EFI_PARAMS_FROM_FDT
 	bool
 	help
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 6fd3da9..c24f005 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_STUB)			+= libstub/
+obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
new file mode 100644
index 0000000..32bcb14
--- /dev/null
+++ b/drivers/firmware/efi/fake_mem.c
@@ -0,0 +1,238 @@
+/*
+ * fake_mem.c
+ *
+ * Copyright (C) 2015 FUJITSU LIMITED
+ * Author: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
+ *
+ * This code introduces new boot option named "efi_fake_mem"
+ * By specifying this parameter, you can add arbitrary attribute to
+ * specific memory range by updating original (firmware provided) EFI
+ * memmap.
+ *
+ *  This program is free software; you can redistribute it and/or modify it
+ *  under the terms and conditions of the GNU General Public License,
+ *  version 2, as published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ *  more details.
+ *
+ *  You should have received a copy of the GNU General Public License along with
+ *  this program; if not, see <http://www.gnu.org/licenses/>.
+ *
+ *  The full GNU General Public License is included in this distribution in
+ *  the file called "COPYING".
+ */
+
+#include <linux/kernel.h>
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/memblock.h>
+#include <linux/types.h>
+#include <linux/sort.h>
+#include <asm/efi.h>
+
+#define EFI_MAX_FAKEMEM CONFIG_EFI_MAX_FAKE_MEM
+
+struct fake_mem {
+	struct range range;
+	u64 attribute;
+};
+static struct fake_mem fake_mems[EFI_MAX_FAKEMEM];
+static int nr_fake_mem;
+
+static int __init cmp_fake_mem(const void *x1, const void *x2)
+{
+	const struct fake_mem *m1 = x1;
+	const struct fake_mem *m2 = x2;
+
+	if (m1->range.start < m2->range.start)
+		return -1;
+	if (m1->range.start > m2->range.start)
+		return 1;
+	return 0;
+}
+
+void __init efi_fake_memmap(void)
+{
+	u64 start, end, m_start, m_end, m_attr;
+	int new_nr_map = memmap.nr_map;
+	efi_memory_desc_t *md;
+	u64 new_memmap_phy;
+	void *new_memmap;
+	void *old, *new;
+	int i;
+
+	if (!nr_fake_mem || !efi_enabled(EFI_MEMMAP))
+		return;
+
+	/* count up the number of EFI memory descriptor */
+	for (old = memmap.map; old < memmap.map_end; old += memmap.desc_size) {
+		md = old;
+		start = md->phys_addr;
+		end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+		for (i = 0; i < nr_fake_mem; i++) {
+			/* modifying range */
+			m_start = fake_mems[i].range.start;
+			m_end = fake_mems[i].range.end;
+
+			if (m_start <= start) {
+				/* split into 2 parts */
+				if (start < m_end && m_end < end)
+					new_nr_map++;
+			}
+			if (start < m_start && m_start < end) {
+				/* split into 3 parts */
+				if (m_end < end)
+					new_nr_map += 2;
+				/* split into 2 parts */
+				if (end <= m_end)
+					new_nr_map++;
+			}
+		}
+	}
+
+	/* allocate memory for new EFI memmap */
+	new_memmap_phy = memblock_alloc(memmap.desc_size * new_nr_map,
+					PAGE_SIZE);
+	if (!new_memmap_phy)
+		return;
+
+	/* create new EFI memmap */
+	new_memmap = early_memremap(new_memmap_phy,
+				    memmap.desc_size * new_nr_map);
+	if (!new_memmap) {
+		memblock_free(new_memmap_phy, memmap.desc_size * new_nr_map);
+		return;
+	}
+
+	for (old = memmap.map, new = new_memmap;
+	     old < memmap.map_end;
+	     old += memmap.desc_size, new += memmap.desc_size) {
+
+		/* copy original EFI memory descriptor */
+		memcpy(new, old, memmap.desc_size);
+		md = new;
+		start = md->phys_addr;
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+		for (i = 0; i < nr_fake_mem; i++) {
+			/* modifying range */
+			m_start = fake_mems[i].range.start;
+			m_end = fake_mems[i].range.end;
+			m_attr = fake_mems[i].attribute;
+
+			if (m_start <= start && end <= m_end)
+				md->attribute |= m_attr;
+
+			if (m_start <= start &&
+			    (start < m_end && m_end < end)) {
+				/* first part */
+				md->attribute |= m_attr;
+				md->num_pages = (m_end - md->phys_addr + 1) >>
+					EFI_PAGE_SHIFT;
+				/* latter part */
+				new += memmap.desc_size;
+				memcpy(new, old, memmap.desc_size);
+				md = new;
+				md->phys_addr = m_end + 1;
+				md->num_pages = (end - md->phys_addr + 1) >>
+					EFI_PAGE_SHIFT;
+			}
+
+			if ((start < m_start && m_start < end) && m_end < end) {
+				/* first part */
+				md->num_pages = (m_start - md->phys_addr) >>
+					EFI_PAGE_SHIFT;
+				/* middle part */
+				new += memmap.desc_size;
+				memcpy(new, old, memmap.desc_size);
+				md = new;
+				md->attribute |= m_attr;
+				md->phys_addr = m_start;
+				md->num_pages = (m_end - m_start + 1) >>
+					EFI_PAGE_SHIFT;
+				/* last part */
+				new += memmap.desc_size;
+				memcpy(new, old, memmap.desc_size);
+				md = new;
+				md->phys_addr = m_end + 1;
+				md->num_pages = (end - m_end) >>
+					EFI_PAGE_SHIFT;
+			}
+
+			if ((start < m_start && m_start < end) &&
+			    (end <= m_end)) {
+				/* first part */
+				md->num_pages = (m_start - md->phys_addr) >>
+					EFI_PAGE_SHIFT;
+				/* latter part */
+				new += memmap.desc_size;
+				memcpy(new, old, memmap.desc_size);
+				md = new;
+				md->phys_addr = m_start;
+				md->num_pages = (end - md->phys_addr + 1) >>
+					EFI_PAGE_SHIFT;
+				md->attribute |= m_attr;
+			}
+		}
+	}
+
+	/* swap into new EFI memmap */
+	efi_unmap_memmap();
+	memmap.map = new_memmap;
+	memmap.phys_map = (void *)new_memmap_phy;
+	memmap.nr_map = new_nr_map;
+	memmap.map_end = memmap.map + memmap.nr_map * memmap.desc_size;
+	set_bit(EFI_MEMMAP, &efi.flags);
+
+	/* print new EFI memmap */
+	efi_print_memmap();
+}
+
+static int __init setup_fake_mem(char *p)
+{
+	u64 start = 0, mem_size = 0, attribute = 0;
+	int i;
+
+	if (!p)
+		return -EINVAL;
+
+	while (*p != '\0') {
+		mem_size = memparse(p, &p);
+		if (*p == '@')
+			start = memparse(p+1, &p);
+		else
+			break;
+
+		if (*p == ':')
+			attribute = simple_strtoull(p+1, &p, 0);
+		else
+			break;
+
+		if (nr_fake_mem >= EFI_MAX_FAKEMEM)
+			break;
+
+		fake_mems[nr_fake_mem].range.start = start;
+		fake_mems[nr_fake_mem].range.end = start + mem_size - 1;
+		fake_mems[nr_fake_mem].attribute = attribute;
+		nr_fake_mem++;
+
+		if (*p == ',')
+			p++;
+	}
+
+	sort(fake_mems, nr_fake_mem, sizeof(struct fake_mem),
+	     cmp_fake_mem, NULL);
+
+	for (i = 0; i < nr_fake_mem; i++)
+		pr_info("efi_fake_mem: add attr=0x%016llx to [mem 0x%016llx-0x%016llx]",
+			fake_mems[i].attribute, fake_mems[i].range.start,
+			fake_mems[i].range.end);
+
+	return *p == '\0' ? 0 : -EINVAL;
+}
+
+early_param("efi_fake_mem", setup_fake_mem);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 85ef051..620baec 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -908,6 +908,12 @@ extern struct kobject *efi_kobj;
 extern int efi_reboot_quirk_mode;
 extern bool efi_poweroff_required(void);
 
+#ifdef CONFIG_EFI_FAKE_MEMMAP
+extern void __init efi_fake_memmap(void);
+#else
+static inline void efi_fake_memmap(void) { }
+#endif
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc(m, md)					   \
 	for ((md) = (m)->map;						   \
-- 
1.8.3.1
