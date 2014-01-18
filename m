From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 1/5] x86, ptdump: Add the functionality to dump an arbitrary pagetable
Date: Sat, 18 Jan 2014 12:48:14 +0100
Message-ID: <1390045698-16882-2-git-send-email-bp@alien8.de>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1390045698-16882-1-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

With reusing the ->trampoline_pgd page table for mapping EFI regions in
order to use them after having switched to EFI virtual mode, it is very
useful to be able to dump aforementioned page table in dmesg. This adds
that functionality through the walk_pgd_level() interface which can be
called from somewhere else.

The original functionality of dumping to debugfs remains untouched.

Cc: Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Tested-by: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
---
 arch/x86/include/asm/pgtable.h |  3 +-
 arch/x86/mm/dump_pagetables.c  | 84 +++++++++++++++++++++++++++---------------
 2 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index bbc8b12fa443..b459ddf27d64 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -15,9 +15,10 @@
 	 : (prot))
 
 #ifndef __ASSEMBLY__
-
 #include <asm/x86_init.h>
 
+void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd);
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0002a3a33081..20621d753d5f 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -30,6 +30,7 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned long current_address;
 	const struct addr_marker *marker;
+	bool to_dmesg;
 };
 
 struct addr_marker {
@@ -88,10 +89,28 @@ static struct addr_marker address_markers[] = {
 #define PUD_LEVEL_MULT (PTRS_PER_PMD * PMD_LEVEL_MULT)
 #define PGD_LEVEL_MULT (PTRS_PER_PUD * PUD_LEVEL_MULT)
 
+#define pt_dump_seq_printf(m, to_dmesg, fmt, args...)		\
+({								\
+	if (to_dmesg)					\
+		printk(KERN_INFO fmt, ##args);			\
+	else							\
+		if (m)						\
+			seq_printf(m, fmt, ##args);		\
+})
+
+#define pt_dump_cont_printf(m, to_dmesg, fmt, args...)		\
+({								\
+	if (to_dmesg)					\
+		printk(KERN_CONT fmt, ##args);			\
+	else							\
+		if (m)						\
+			seq_printf(m, fmt, ##args);		\
+})
+
 /*
  * Print a readable form of a pgprot_t to the seq_file
  */
-static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
+static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 {
 	pgprotval_t pr = pgprot_val(prot);
 	static const char * const level_name[] =
@@ -99,47 +118,47 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
 
 	if (!pgprot_val(prot)) {
 		/* Not present */
-		seq_printf(m, "                          ");
+		pt_dump_cont_printf(m, dmsg, "                          ");
 	} else {
 		if (pr & _PAGE_USER)
-			seq_printf(m, "USR ");
+			pt_dump_cont_printf(m, dmsg, "USR ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_RW)
-			seq_printf(m, "RW ");
+			pt_dump_cont_printf(m, dmsg, "RW ");
 		else
-			seq_printf(m, "ro ");
+			pt_dump_cont_printf(m, dmsg, "ro ");
 		if (pr & _PAGE_PWT)
-			seq_printf(m, "PWT ");
+			pt_dump_cont_printf(m, dmsg, "PWT ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_PCD)
-			seq_printf(m, "PCD ");
+			pt_dump_cont_printf(m, dmsg, "PCD ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 
 		/* Bit 9 has a different meaning on level 3 vs 4 */
 		if (level <= 3) {
 			if (pr & _PAGE_PSE)
-				seq_printf(m, "PSE ");
+				pt_dump_cont_printf(m, dmsg, "PSE ");
 			else
-				seq_printf(m, "    ");
+				pt_dump_cont_printf(m, dmsg, "    ");
 		} else {
 			if (pr & _PAGE_PAT)
-				seq_printf(m, "pat ");
+				pt_dump_cont_printf(m, dmsg, "pat ");
 			else
-				seq_printf(m, "    ");
+				pt_dump_cont_printf(m, dmsg, "    ");
 		}
 		if (pr & _PAGE_GLOBAL)
-			seq_printf(m, "GLB ");
+			pt_dump_cont_printf(m, dmsg, "GLB ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_NX)
-			seq_printf(m, "NX ");
+			pt_dump_cont_printf(m, dmsg, "NX ");
 		else
-			seq_printf(m, "x  ");
+			pt_dump_cont_printf(m, dmsg, "x  ");
 	}
-	seq_printf(m, "%s\n", level_name[level]);
+	pt_dump_cont_printf(m, dmsg, "%s\n", level_name[level]);
 }
 
 /*
@@ -178,7 +197,8 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		st->current_prot = new_prot;
 		st->level = level;
 		st->marker = address_markers;
-		seq_printf(m, "---[ %s ]---\n", st->marker->name);
+		pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
+				   st->marker->name);
 	} else if (prot != cur || level != st->level ||
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
@@ -188,17 +208,17 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%0*lx-0x%0*lx   ",
-			   width, st->start_address,
-			   width, st->current_address);
+		pt_dump_seq_printf(m, st->to_dmesg,  "0x%0*lx-0x%0*lx   ",
+				   width, st->start_address,
+				   width, st->current_address);
 
 		delta = (st->current_address - st->start_address) >> 10;
 		while (!(delta & 1023) && unit[1]) {
 			delta >>= 10;
 			unit++;
 		}
-		seq_printf(m, "%9lu%c ", delta, *unit);
-		printk_prot(m, st->current_prot, st->level);
+		pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ", delta, *unit);
+		printk_prot(m, st->current_prot, st->level, st->to_dmesg);
 
 		/*
 		 * We print markers for special areas of address space,
@@ -207,7 +227,8 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		 */
 		if (st->current_address >= st->marker[1].start_address) {
 			st->marker++;
-			seq_printf(m, "---[ %s ]---\n", st->marker->name);
+			pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
+					   st->marker->name);
 		}
 
 		st->start_address = st->current_address;
@@ -296,7 +317,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
 #define pgd_none(a)  pud_none(__pud(pgd_val(a)))
 #endif
 
-static void walk_pgd_level(struct seq_file *m)
+void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
 {
 #ifdef CONFIG_X86_64
 	pgd_t *start = (pgd_t *) &init_level4_pgt;
@@ -304,9 +325,12 @@ static void walk_pgd_level(struct seq_file *m)
 	pgd_t *start = swapper_pg_dir;
 #endif
 	int i;
-	struct pg_state st;
+	struct pg_state st = {};
 
-	memset(&st, 0, sizeof(st));
+	if (pgd) {
+		start = pgd;
+		st.to_dmesg = true;
+	}
 
 	for (i = 0; i < PTRS_PER_PGD; i++) {
 		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
@@ -331,7 +355,7 @@ static void walk_pgd_level(struct seq_file *m)
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	walk_pgd_level(m);
+	ptdump_walk_pgd_level(m, NULL);
 	return 0;
 }
 
-- 
1.8.5.2.192.g7794a68
