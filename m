From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 5/6] arm: mm: dump: make page table dumping reusable
Date: Fri, 22 Apr 2016 18:48:07 +0200
Message-ID: <1461343688-8552-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461343688-8552-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For debugging purposes, it would be nice if we could export page tables
other than the swapper_pg_dir to userspace. To enable this, this patch
refactors the ARM page table dumping code such that multiple tables
may be registered with the framework, and exported under debugfs.

(this is a port of Mark Rutland's arm64 patch that does the same)

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/ptdump.h | 44 ++++++++++++++
 arch/arm/mm/dump.c            | 60 ++++++++++++--------
 2 files changed, 81 insertions(+), 23 deletions(-)

diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.h
new file mode 100644
index 000000000000..2df5737b2cc7
--- /dev/null
+++ b/arch/arm/include/asm/ptdump.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2014 ARM Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_PTDUMP_H
+#define __ASM_PTDUMP_H
+
+#ifdef CONFIG_ARM_PTDUMP
+
+#include <linux/mm_types.h>
+
+struct addr_marker {
+	unsigned long start_address;
+	char *name;
+};
+
+struct ptdump_info {
+	struct mm_struct		*mm;
+	const struct addr_marker	*markers;
+	unsigned long			base_addr;
+	unsigned long			max_addr;
+};
+
+int ptdump_register(struct ptdump_info *info, const char *name);
+
+#else
+static inline int ptdump_register(struct ptdump_info *info, const char *name)
+{
+	return 0;
+}
+#endif /* CONFIG_ARM_PTDUMP */
+
+#endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
index 9fe8e241335c..0c1ff61440aa 100644
--- a/arch/arm/mm/dump.c
+++ b/arch/arm/mm/dump.c
@@ -19,11 +19,7 @@
 
 #include <asm/fixmap.h>
 #include <asm/pgtable.h>
-
-struct addr_marker {
-	unsigned long start_address;
-	const char *name;
-};
+#include <asm/ptdump.h>
 
 static struct addr_marker address_markers[] = {
 	{ MODULES_VADDR,	"Modules" },
@@ -266,7 +262,8 @@ static void walk_pte(struct pg_state *st, pmd_t *pmd, unsigned long start)
 	}
 }
 
-static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
+static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start,
+		     unsigned long max)
 {
 	pmd_t *pmd = pmd_offset(pud, 0);
 	unsigned long addr;
@@ -274,6 +271,8 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 
 	for (i = 0; i < PTRS_PER_PMD; i++, pmd++) {
 		addr = start + i * PMD_SIZE;
+		if (addr > max)
+			break;
 		if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd))
 			note_page(st, addr, 3, pmd_val(*pmd));
 		else
@@ -284,7 +283,8 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
 	}
 }
 
-static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
+static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start,
+		     unsigned long max)
 {
 	pud_t *pud = pud_offset(pgd, 0);
 	unsigned long addr;
@@ -292,46 +292,51 @@ static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
 
 	for (i = 0; i < PTRS_PER_PUD; i++, pud++) {
 		addr = start + i * PUD_SIZE;
+		if (addr > max)
+			break;
 		if (!pud_none(*pud)) {
-			walk_pmd(st, pud, addr);
+			walk_pmd(st, pud, addr, max);
 		} else {
 			note_page(st, addr, 2, pud_val(*pud));
 		}
 	}
 }
 
-static void walk_pgd(struct seq_file *m)
+static void walk_pgd(struct pg_state *st, struct mm_struct *mm, unsigned long max)
 {
-	pgd_t *pgd = swapper_pg_dir;
-	struct pg_state st;
+	pgd_t *pgd = pgd_offset(mm, 0UL);
 	unsigned long addr;
 	unsigned i;
 
-	memset(&st, 0, sizeof(st));
-	st.seq = m;
-	st.marker = address_markers;
-
 	for (i = 0; i < PTRS_PER_PGD; i++, pgd++) {
 		addr = i * PGDIR_SIZE;
+		if (addr > max)
+			break;
 		if (!pgd_none(*pgd)) {
-			walk_pud(&st, pgd, addr);
+			walk_pud(st, pgd, addr, max);
 		} else {
-			note_page(&st, addr, 1, pgd_val(*pgd));
+			note_page(st, addr, 1, pgd_val(*pgd));
 		}
 	}
 
-	note_page(&st, 0, 0, 0);
+	note_page(st, 0, 0, 0);
 }
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	walk_pgd(m);
+	struct ptdump_info *info = m->private;
+	struct pg_state st = {
+		.seq = m,
+		.marker = info->markers,
+	};
+
+	walk_pgd(&st, info->mm, info->max_addr);
 	return 0;
 }
 
 static int ptdump_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, ptdump_show, NULL);
+	return single_open(file, ptdump_show, inode->i_private);
 }
 
 static const struct file_operations ptdump_fops = {
@@ -341,7 +346,7 @@ static const struct file_operations ptdump_fops = {
 	.release	= single_release,
 };
 
-static int ptdump_init(void)
+int ptdump_register(struct ptdump_info *info, const char *name)
 {
 	struct dentry *pe;
 	unsigned i, j;
@@ -353,8 +358,17 @@ static int ptdump_init(void)
 
 	address_markers[2].start_address = VMALLOC_START;
 
-	pe = debugfs_create_file("kernel_page_tables", 0400, NULL, NULL,
-				 &ptdump_fops);
+	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
 	return pe ? 0 : -ENOMEM;
 }
+
+static struct ptdump_info kernel_ptdump_info = {
+	.mm		= &init_mm,
+	.markers	= address_markers,
+};
+
+static int ptdump_init(void)
+{
+	return ptdump_register(&kernel_ptdump_info, "kernel_page_tables");
+}
 __initcall(ptdump_init);
-- 
2.7.4
