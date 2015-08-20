From: Taku Izumi <izumi.taku@jp.fujitsu.com>
Subject: [PATCH 2/2] x86, efi: Add "efi_fake_mem_mirror" boot option
Date: Fri, 21 Aug 2015 02:16:00 +0900
Message-ID: <1440090960-15252-1-git-send-email-izumi.taku@jp.fujitsu.com>
References: <1440090902-15157-1-git-send-email-izumi.taku@jp.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440090902-15157-1-git-send-email-izumi.taku@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org, matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: tony.luck@intel.com, qiuxishi@huawei.com, kamezawa.hiroyu@jp.fujitsu.com, Taku Izumi <izumi.taku@jp.fujitsu.com>
List-Id: linux-efi@vger.kernel.org

This patch introduces new boot option named "efi_fake_mem_mirror".
By specifying this parameter, you can mark specific memory as
mirrored memory. This is useful for debugging of Address Range
Mirroring feature.

For example, if you specify "efi_fake_mem_mirror=2G@4G,2G@0x10a0000000",
the original (firmware provided) EFI memmap will be updated so that
the specified memory regions have EFI_MEMORY_MORE_RELIABLE attribute:

 <original EFI memmap>
   efi: mem00: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
   efi: mem01: [Loader Data        |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
   ...
   efi: mem35: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000047ee6000-0x0000000048014000) (1MB)
   efi: mem36: [Conventional Memory|   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x00000020a0000000) (129536MB)
   efi: mem37: [Reserved           |RUN|    |  |  |  |   |  |  |  |UC] range=[0x0000000060000000-0x0000000090000000) (768MB)

 <updated EFI memmap>
   efi: mem00: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000001000) (0MB)
   efi: mem01: [Loader Data        |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000001000-0x0000000000002000) (0MB)
   ...
   efi: mem35: [Boot Data          |   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000047ee6000-0x0000000048014000) (1MB)
   efi: mem36: [Conventional Memory|   |RELY|  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x0000000180000000) (2048MB)
   efi: mem37: [Conventional Memory|   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000000180000000-0x00000010a0000000) (61952MB)
   efi: mem38: [Conventional Memory|   |RELY|  |  |  |   |WB|WT|WC|UC] range=[0x00000010a0000000-0x0000001120000000) (2048MB)
   efi: mem39: [Conventional Memory|   |    |  |  |  |   |WB|WT|WC|UC] range=[0x0000001120000000-0x00000020a0000000) (63488MB)
   efi: mem40: [Reserved           |RUN|    |  |  |  |   |  |  |  |UC] range=[0x0000000060000000-0x0000000090000000) (768MB)

And you will find that the following message is output:

   efi: Memory: 4096M/131455M mirrored memory

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
---
 Documentation/kernel-parameters.txt |   8 ++
 arch/x86/include/asm/efi.h          |   2 +
 arch/x86/kernel/setup.c             |   4 +-
 arch/x86/platform/efi/efi.c         |   2 +-
 arch/x86/platform/efi/quirks.c      | 169 ++++++++++++++++++++++++++++++++++++
 5 files changed, 183 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 1d6f045..0efded6 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1092,6 +1092,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			you are really sure that your UEFI does sane gc and
 			fulfills the spec otherwise your board may brick.
 
+	efi_fake_mem_mirror=nn[KMG]@ss[KMG][,nn[KMG]@ss[KMG],..] [EFI; X86]
+			Mark specific memory as mirrored memory and update
+			EFI memory map.
+			Region of memory to be marked is from ss to ss+nn.
+			Using this parameter you can do debugging of Address
+			Range Mirroring feature even if your box doesn't support
+			it.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 155162e..50e53cc 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -93,6 +93,7 @@ extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int __init efi_memblock_x86_reserve_range(void);
 extern pgd_t * __init efi_call_phys_prolog(void);
 extern void __init efi_call_phys_epilog(pgd_t *save_pgd);
+extern void __init print_efi_memmap(void);
 extern void __init efi_unmap_memmap(void);
 extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
@@ -107,6 +108,7 @@ extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 extern int __init efi_reuse_config(u64 tables, int nr_tables);
 extern void efi_delete_dummy_variable(void);
+extern void __init efi_fake_memmap(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 80f874b..e3ed628 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1104,8 +1104,10 @@ void __init setup_arch(char **cmdline_p)
 	memblock_set_current_limit(ISA_END_ADDRESS);
 	memblock_x86_fill();
 
-	if (efi_enabled(EFI_BOOT))
+	if (efi_enabled(EFI_BOOT)) {
+		efi_fake_memmap();
 		efi_find_mirror();
+	}
 
 	/*
 	 * The EFI specification says that boot service code won't be called
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index e4308fe..eee8068 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -222,7 +222,7 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-static void __init print_efi_memmap(void)
+void __init print_efi_memmap(void)
 {
 #ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380d..5c785e1 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -18,6 +18,10 @@
 
 static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
 
+#define EFI_MAX_FAKE_MIRROR 8
+static struct range fake_mirrors[EFI_MAX_FAKE_MIRROR];
+static int num_fake_mirror;
+
 static bool efi_no_storage_paranoia;
 
 /*
@@ -288,3 +292,168 @@ bool efi_poweroff_required(void)
 {
 	return !!acpi_gbl_reduced_hardware;
 }
+
+void __init efi_fake_memmap(void)
+{
+	efi_memory_desc_t *md;
+	void *p, *q;
+	int i;
+	int nr_map = memmap.nr_map;
+	u64 start, end, m_start, m_end;
+	u64 new_memmap_phy;
+	void *new_memmap;
+
+	if (!num_fake_mirror)
+		return;
+
+	/* count up the number of EFI memory descriptor */
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		start = md->phys_addr;
+		end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+		for (i = 0; i < num_fake_mirror; i++) {
+			/* mirroring range */
+			m_start = fake_mirrors[i].start;
+			m_end = fake_mirrors[i].end;
+
+			if (m_start <= start) {
+				/* split into 2 parts */
+				if (start < m_end && m_end < end)
+					nr_map++;
+			}
+			if (start < m_start && m_start < end) {
+				/* split into 3 parts */
+				if (m_end < end)
+					nr_map += 2;
+				/* split into 2 parts */
+				if (end <= m_end)
+					nr_map++;
+			}
+		}
+	}
+
+	/* allocate memory for new EFI memmap */
+	new_memmap_phy = memblock_alloc(memmap.desc_size * nr_map, PAGE_SIZE);
+	if (!new_memmap_phy)
+		return;
+
+	/* create new EFI memmap */
+	new_memmap = early_memremap(new_memmap_phy, memmap.desc_size * nr_map);
+	for (p = memmap.map, q = new_memmap;
+	     p < memmap.map_end;
+	     p += memmap.desc_size, q += memmap.desc_size) {
+
+		/* copy original EFI memory descriptor */
+		memcpy(q, p, memmap.desc_size);
+		md = q;
+		start = md->phys_addr;
+		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+
+		for (i = 0; i < num_fake_mirror; i++) {
+			/* mirroring range */
+			m_start = fake_mirrors[i].start;
+			m_end = fake_mirrors[i].end;
+
+			if (m_start <= start && end <= m_end)
+				md->attribute |= EFI_MEMORY_MORE_RELIABLE;
+
+			if (m_start <= start &&
+			    (start < m_end && m_end < end)) {
+				/* first part */
+				md->attribute |= EFI_MEMORY_MORE_RELIABLE;
+				md->num_pages = (m_end - md->phys_addr + 1) >>
+					EFI_PAGE_SHIFT;
+				/* latter part */
+				q += memmap.desc_size;
+				memcpy(q, p, memmap.desc_size);
+				md = q;
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
+				q += memmap.desc_size;
+				memcpy(q, p, memmap.desc_size);
+				md = q;
+				md->attribute |= EFI_MEMORY_MORE_RELIABLE;
+				md->phys_addr = m_start;
+				md->num_pages = (m_end - m_start + 1) >>
+					EFI_PAGE_SHIFT;
+				/* last part */
+				q += memmap.desc_size;
+				memcpy(q, p, memmap.desc_size);
+				md = q;
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
+				q += memmap.desc_size;
+				memcpy(q, p, memmap.desc_size);
+				md = q;
+				md->phys_addr = m_start;
+				md->num_pages = (end - md->phys_addr + 1) >>
+					EFI_PAGE_SHIFT;
+				md->attribute |= EFI_MEMORY_MORE_RELIABLE;
+			}
+		}
+	}
+
+	/* swap into new EFI memmap */
+	efi_unmap_memmap();
+	memmap.map = new_memmap;
+	memmap.phys_map = (void *)new_memmap_phy;
+	memmap.nr_map = nr_map;
+	memmap.map_end = memmap.map + memmap.nr_map * memmap.desc_size;
+	set_bit(EFI_MEMMAP, &efi.flags);
+
+	/* print new EFI memmap */
+	print_efi_memmap();
+}
+
+static int __init setup_fake_mem_mirror(char *p)
+{
+	u64 start = 0, mem_size = 0;
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
+		num_fake_mirror = add_range_with_merge(fake_mirrors,
+						       EFI_MAX_FAKE_MIRROR,
+						       num_fake_mirror,
+						       start,
+						       start + mem_size - 1);
+		if (*p == ',')
+			p++;
+	}
+
+	sort_range(fake_mirrors, num_fake_mirror);
+
+	for (i = 0; i < num_fake_mirror; i++)
+		pr_info("efi_fake_mem_mirror: [mem 0x%016llx-0x%016llx] marked as mirrored memory",
+			fake_mirrors[i].start, fake_mirrors[i].end);
+
+	return *p == '\0' ? 0 : -EINVAL;
+}
+
+early_param("efi_fake_mem_mirror", setup_fake_mem_mirror);
-- 
1.8.3.1
