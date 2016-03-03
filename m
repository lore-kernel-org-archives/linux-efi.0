From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v14 4/6] arm64: Move unflatten_device_tree() call earlier.
Date: Thu,  3 Mar 2016 15:55:37 -0800
Message-ID: <1457049339-23351-5-git-send-email-ddaney.cavm@gmail.com>
References: <1457049339-23351-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457049339-23351-1-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

In order to extract NUMA information from the device tree, we need to
have the tree in its unflattened form.

Split paging_init() into two pieces.  The first piece maps memory so
that unflatten_device_tree(), can allocate memory.  The second piece
containing the bootmem_init() call that will be patched in a follow-on
patch to add NUMA handling.

Move the unflatten_device_tree() call between the two new pieces.

Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 arch/arm64/include/asm/mmu.h |  3 ++-
 arch/arm64/kernel/setup.c    | 15 ++++++++++-----
 arch/arm64/mm/mmu.c          | 17 +++++++++++------
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 990124a..e6e40ac 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -28,7 +28,8 @@ typedef struct {
  */
 #define ASID(mm)	((mm)->context.id.counter & 0xffff)
 
-extern void paging_init(void);
+extern void paging_init_map_mem(void);
+extern void paging_init_rest(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 8119479..753ae90 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -319,7 +319,13 @@ void __init setup_arch(char **cmdline_p)
 	/* Parse the ACPI tables for possible boot-time configuration */
 	acpi_boot_table_init();
 
-	paging_init();
+	paging_init_map_mem();
+
+	if (acpi_disabled)
+		unflatten_device_tree();
+
+	paging_init_rest();
+
 	relocate_initrd();
 
 	kasan_init();
@@ -328,12 +334,11 @@ void __init setup_arch(char **cmdline_p)
 
 	early_ioremap_reset();
 
-	if (acpi_disabled) {
-		unflatten_device_tree();
+	if (acpi_disabled)
 		psci_dt_init();
-	} else {
+	else
 		psci_acpi_init();
-	}
+
 	xen_early_init();
 
 	cpu_read_bootcpu_ops();
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 58faeaa..5c6dd0a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -449,18 +449,23 @@ void fixup_init(void)
 }
 
 /*
- * paging_init() sets up the page tables, initialises the zone memory
- * maps and sets up the zero page.
+ * paging_init_map_mem() sets up the page tables so that memblock
+ * memory is usable.
  */
-void __init paging_init(void)
+void __init paging_init_map_mem(void)
 {
-	void *zero_page;
-
 	map_mem();
 	fixup_executable();
+}
 
+/*
+ * paging_init_rest() finishes setting up the page tables, initializes
+ * the zone memory maps and sets up the zero page.
+ */
+void __init paging_init_rest(void)
+{
 	/* allocate the zero page. */
-	zero_page = early_alloc(PAGE_SIZE);
+	void *zero_page = early_alloc(PAGE_SIZE);
 
 	bootmem_init();
 
-- 
1.8.3.1
