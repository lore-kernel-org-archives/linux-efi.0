From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v16 4/6] arm64: Move unflatten_device_tree() call earlier.
Date: Fri,  8 Apr 2016 15:50:26 -0700
Message-ID: <1460155828-8690-5-git-send-email-ddaney.cavm@gmail.com>
References: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460155828-8690-1-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

In order to extract NUMA information from the device tree, we need to
have the tree in its unflattened form.

Move the call to bootmem_init() in the tail of paging_init() into
setup_arch, and adjust header files so that its declaration is
visible.

Move the unflatten_device_tree() call between the calls to
paging_init() and bootmem_init().  Follow on patches add NUMA handling
to bootmem_init().

Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 arch/arm64/include/asm/mmu.h |  1 +
 arch/arm64/kernel/setup.c    | 13 +++++++++----
 arch/arm64/mm/mm.h           |  1 -
 arch/arm64/mm/mmu.c          |  2 --
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 990124a..97b1d8f 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -29,6 +29,7 @@ typedef struct {
 #define ASID(mm)	((mm)->context.id.counter & 0xffff)
 
 extern void paging_init(void);
+extern void bootmem_init(void);
 extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
 extern void init_mem_pgprot(void);
 extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 9dc6776..9bd237e 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -327,6 +327,12 @@ void __init setup_arch(char **cmdline_p)
 	acpi_boot_table_init();
 
 	paging_init();
+
+	if (acpi_disabled)
+		unflatten_device_tree();
+
+	bootmem_init();
+
 	relocate_initrd();
 
 	kasan_init();
@@ -335,12 +341,11 @@ void __init setup_arch(char **cmdline_p)
 
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
diff --git a/arch/arm64/mm/mm.h b/arch/arm64/mm/mm.h
index ef47d99..71fe989 100644
--- a/arch/arm64/mm/mm.h
+++ b/arch/arm64/mm/mm.h
@@ -1,3 +1,2 @@
-extern void __init bootmem_init(void);
 
 void fixup_init(void);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f3e5c74..267903b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -564,8 +564,6 @@ void __init paging_init(void)
 	 */
 	memblock_free(__pa(swapper_pg_dir) + PAGE_SIZE,
 		      SWAPPER_DIR_SIZE - PAGE_SIZE);
-
-	bootmem_init();
 }
 
 /*
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
