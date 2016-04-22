From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/6] arm64: ptdump: use static initializers for vmemmap region boundaries
Date: Fri, 22 Apr 2016 18:48:03 +0200
Message-ID: <1461343688-8552-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461343688-8552-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There is no need to initialize the vmemmap region boundaries dynamically,
since they are compile time constants. So just add these constants to the
global struct initializer, and drop the dynamic assignment and related code.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/dump.c | 49 ++++++--------------
 1 file changed, 13 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index a21f47421b0c..493461159462 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -32,37 +32,21 @@ struct addr_marker {
 	const char *name;
 };
 
-enum address_markers_idx {
-	MODULES_START_NR = 0,
-	MODULES_END_NR,
-	VMALLOC_START_NR,
-	VMALLOC_END_NR,
-	FIXADDR_START_NR,
-	FIXADDR_END_NR,
-	PCI_START_NR,
-	PCI_END_NR,
+static const struct addr_marker address_markers[] = {
+	{ MODULES_VADDR,		"Modules start" },
+	{ MODULES_END,			"Modules end" },
+	{ VMALLOC_START,		"vmalloc() Area" },
+	{ VMALLOC_END,			"vmalloc() End" },
+	{ FIXADDR_START,		"Fixmap start" },
+	{ FIXADDR_TOP,			"Fixmap end" },
+	{ PCI_IO_START,			"PCI I/O start" },
+	{ PCI_IO_END,			"PCI I/O end" },
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-	VMEMMAP_START_NR,
-	VMEMMAP_END_NR,
+	{ VMEMMAP_START,		"vmemmap start" },
+	{ VMEMMAP_START + VMEMMAP_SIZE,	"vmemmap end" },
 #endif
-	KERNEL_SPACE_NR,
-};
-
-static struct addr_marker address_markers[] = {
-	{ MODULES_VADDR,	"Modules start" },
-	{ MODULES_END,		"Modules end" },
-	{ VMALLOC_START,	"vmalloc() Area" },
-	{ VMALLOC_END,		"vmalloc() End" },
-	{ FIXADDR_START,	"Fixmap start" },
-	{ FIXADDR_TOP,		"Fixmap end" },
-	{ PCI_IO_START,		"PCI I/O start" },
-	{ PCI_IO_END,		"PCI I/O end" },
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	{ 0,			"vmemmap start" },
-	{ 0,			"vmemmap end" },
-#endif
-	{ PAGE_OFFSET,		"Linear Mapping" },
-	{ -1,			NULL },
+	{ PAGE_OFFSET,			"Linear Mapping" },
+	{ -1,				NULL },
 };
 
 /*
@@ -347,13 +331,6 @@ static int ptdump_init(void)
 			for (j = 0; j < pg_level[i].num; j++)
 				pg_level[i].mask |= pg_level[i].bits[j].mask;
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
-	address_markers[VMEMMAP_START_NR].start_address =
-				(unsigned long)virt_to_page(PAGE_OFFSET);
-	address_markers[VMEMMAP_END_NR].start_address =
-				(unsigned long)virt_to_page(high_memory);
-#endif
-
 	pe = debugfs_create_file("kernel_page_tables", 0400, NULL, NULL,
 				 &ptdump_fops);
 	return pe ? 0 : -ENOMEM;
-- 
2.7.4
