From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 4/6] arm64: mm: dump: make page table dumping reusable
Date: Fri, 13 May 2016 13:56:07 +0100
Message-ID: <20160513125606.GB4088@leverpostej>
References: <1461343688-8552-1-git-send-email-ard.biesheuvel@linaro.org>
 <1461343688-8552-5-git-send-email-ard.biesheuvel@linaro.org>
 <20160425110757.GI16065@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160425110757.GI16065-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Apr 25, 2016 at 12:07:57PM +0100, Will Deacon wrote:
> Hi Ard, Mark,
> 
> On Fri, Apr 22, 2016 at 06:48:06PM +0200, Ard Biesheuvel wrote:
> > From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > 
> > For debugging purposes, it would be nice if we could export page tables
> > other than the swapper_pg_dir to userspace. To enable this, this patch
> > refactors the arm64 page table dumping code such that multiple tables
> > may be registered with the framework, and exported under debugfs.
> > 
> > Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/arm64/include/asm/ptdump.h | 44 ++++++++++++++++++++
> >  arch/arm64/mm/dump.c            | 32 ++++++++------
> >  2 files changed, 64 insertions(+), 12 deletions(-)
> 
> Could you reorder this with patch 3, please? I'm unsure about the benefit
> of the very specific string literal changes, but the ptdump stuff here
> certainly looks beneficial.

I'm sure this is far too late, but for posterity I've rebased patch 4
below atop of pathes 1 & 2 as queued in the arm64 for-next/core branch,
without patch 3. It builds cleanly, and I've given it a spin on
Juno.

Will, I guess I should rebase and resend this after we hit v4.7-rc1?

Thanks,
Mark.

---->8----
>From f17b52c0f004614027c356c848fd21308f4177c1 Mon Sep 17 00:00:00 2001
From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Date: Fri, 22 Apr 2016 18:48:06 +0200
Subject: [PATCH] arm64: mm: dump: make page table dumping reusable

For debugging purposes, it would be nice if we could export page tables
other than the swapper_pg_dir to userspace. To enable this, this patch
refactors the arm64 page table dumping code such that multiple tables
may be registered with the framework, and exported under debugfs.

Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/ptdump.h | 44 +++++++++++++++++++++++++++++++++++++++++
 arch/arm64/mm/dump.c            | 32 +++++++++++++++++++-----------
 2 files changed, 64 insertions(+), 12 deletions(-)
 create mode 100644 arch/arm64/include/asm/ptdump.h

diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
new file mode 100644
index 0000000..07b8ed0
--- /dev/null
+++ b/arch/arm64/include/asm/ptdump.h
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
+#ifdef CONFIG_ARM64_PTDUMP
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
+#endif /* CONFIG_ARM64_PTDUMP */
+
+#endif /* __ASM_PTDUMP_H */
diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index 8404190..a56a7ad 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -27,11 +27,7 @@
 #include <asm/memory.h>
 #include <asm/pgtable.h>
 #include <asm/pgtable-hwdef.h>
-
-struct addr_marker {
-	unsigned long start_address;
-	const char *name;
-};
+#include <asm/ptdump.h>
 
 static const struct addr_marker address_markers[] = {
 #ifdef CONFIG_KASAN
@@ -284,7 +280,8 @@ static void walk_pud(struct pg_state *st, pgd_t *pgd, unsigned long start)
 	}
 }
 
-static void walk_pgd(struct pg_state *st, struct mm_struct *mm, unsigned long start)
+static void walk_pgd(struct pg_state *st, struct mm_struct *mm,
+		     unsigned long start)
 {
 	pgd_t *pgd = pgd_offset(mm, 0UL);
 	unsigned i;
@@ -303,12 +300,13 @@ static void walk_pgd(struct pg_state *st, struct mm_struct *mm, unsigned long st
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
+	struct ptdump_info *info = m->private;
 	struct pg_state st = {
 		.seq = m,
-		.marker = address_markers,
+		.marker = info->markers,
 	};
 
-	walk_pgd(&st, &init_mm, VA_START);
+	walk_pgd(&st, info->mm, info->base_addr);
 
 	note_page(&st, 0, 0, 0);
 	return 0;
@@ -316,7 +314,7 @@ static int ptdump_show(struct seq_file *m, void *v)
 
 static int ptdump_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, ptdump_show, NULL);
+	return single_open(file, ptdump_show, inode->i_private);
 }
 
 static const struct file_operations ptdump_fops = {
@@ -326,7 +324,7 @@ static const struct file_operations ptdump_fops = {
 	.release	= single_release,
 };
 
-static int ptdump_init(void)
+int ptdump_register(struct ptdump_info *info, const char *name)
 {
 	struct dentry *pe;
 	unsigned i, j;
@@ -336,8 +334,18 @@ static int ptdump_init(void)
 			for (j = 0; j < pg_level[i].num; j++)
 				pg_level[i].mask |= pg_level[i].bits[j].mask;
 
-	pe = debugfs_create_file("kernel_page_tables", 0400, NULL, NULL,
-				 &ptdump_fops);
+	pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
 	return pe ? 0 : -ENOMEM;
 }
+
+static struct ptdump_info kernel_ptdump_info = {
+	.mm		= &init_mm,
+	.markers	= address_markers,
+	.base_addr	= VA_START,
+};
+
+static int ptdump_init(void)
+{
+	return ptdump_register(&kernel_ptdump_info, "kernel_page_tables");
+}
 device_initcall(ptdump_init);
-- 
1.9.1
