From: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5 09/19] x86, boot: Split kernel_ident_mapping_init to another file
Date: Wed, 18 Mar 2015 00:28:16 -0700
Message-ID: <1426663706-23979-10-git-send-email-yinghai@kernel.org>
References: <1426663706-23979-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426663706-23979-1-git-send-email-yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We need to include that in boot::decompress_kernel stage to set new
ident mapping.

Also add checking for __pa/__va macro definition, as we need to override them
in boot::decompress_kernel stage.

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Signed-off-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 arch/x86/include/asm/page.h |  5 +++
 arch/x86/mm/ident_map.c     | 74 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_64.c       | 74 +--------------------------------------------
 3 files changed, 80 insertions(+), 73 deletions(-)
 create mode 100644 arch/x86/mm/ident_map.c

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 802dde3..cf8f619 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -37,7 +37,10 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 	alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO | movableflags, vma, vaddr)
 #define __HAVE_ARCH_ALLOC_ZEROED_USER_HIGHPAGE
 
+#ifndef __pa
 #define __pa(x)		__phys_addr((unsigned long)(x))
+#endif
+
 #define __pa_nodebug(x)	__phys_addr_nodebug((unsigned long)(x))
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */
@@ -51,7 +54,9 @@ static inline void copy_user_page(void *to, void *from, unsigned long vaddr,
 #define __pa_symbol(x) \
 	__phys_addr_symbol(__phys_reloc_hide((unsigned long)(x)))
 
+#ifndef __va
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
+#endif
 
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
diff --git a/arch/x86/mm/ident_map.c b/arch/x86/mm/ident_map.c
new file mode 100644
index 0000000..751ca92
--- /dev/null
+++ b/arch/x86/mm/ident_map.c
@@ -0,0 +1,74 @@
+
+static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
+			   unsigned long addr, unsigned long end)
+{
+	addr &= PMD_MASK;
+	for (; addr < end; addr += PMD_SIZE) {
+		pmd_t *pmd = pmd_page + pmd_index(addr);
+
+		if (!pmd_present(*pmd))
+			set_pmd(pmd, __pmd(addr | pmd_flag));
+	}
+}
+static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
+			  unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+
+	for (; addr < end; addr = next) {
+		pud_t *pud = pud_page + pud_index(addr);
+		pmd_t *pmd;
+
+		next = (addr & PUD_MASK) + PUD_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pud_present(*pud)) {
+			pmd = pmd_offset(pud, 0);
+			ident_pmd_init(info->pmd_flag, pmd, addr, next);
+			continue;
+		}
+		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
+		if (!pmd)
+			return -ENOMEM;
+		ident_pmd_init(info->pmd_flag, pmd, addr, next);
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+
+	return 0;
+}
+
+int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
+			      unsigned long addr, unsigned long end)
+{
+	unsigned long next;
+	int result;
+	int off = info->kernel_mapping ? pgd_index(__PAGE_OFFSET) : 0;
+
+	for (; addr < end; addr = next) {
+		pgd_t *pgd = pgd_page + pgd_index(addr) + off;
+		pud_t *pud;
+
+		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
+		if (next > end)
+			next = end;
+
+		if (pgd_present(*pgd)) {
+			pud = pud_offset(pgd, 0);
+			result = ident_pud_init(info, pud, addr, next);
+			if (result)
+				return result;
+			continue;
+		}
+
+		pud = (pud_t *)info->alloc_pgt_page(info->context);
+		if (!pud)
+			return -ENOMEM;
+		result = ident_pud_init(info, pud, addr, next);
+		if (result)
+			return result;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+
+	return 0;
+}
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 30eb05a..c30efb6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -56,79 +56,7 @@
 
 #include "mm_internal.h"
 
-static void ident_pmd_init(unsigned long pmd_flag, pmd_t *pmd_page,
-			   unsigned long addr, unsigned long end)
-{
-	addr &= PMD_MASK;
-	for (; addr < end; addr += PMD_SIZE) {
-		pmd_t *pmd = pmd_page + pmd_index(addr);
-
-		if (!pmd_present(*pmd))
-			set_pmd(pmd, __pmd(addr | pmd_flag));
-	}
-}
-static int ident_pud_init(struct x86_mapping_info *info, pud_t *pud_page,
-			  unsigned long addr, unsigned long end)
-{
-	unsigned long next;
-
-	for (; addr < end; addr = next) {
-		pud_t *pud = pud_page + pud_index(addr);
-		pmd_t *pmd;
-
-		next = (addr & PUD_MASK) + PUD_SIZE;
-		if (next > end)
-			next = end;
-
-		if (pud_present(*pud)) {
-			pmd = pmd_offset(pud, 0);
-			ident_pmd_init(info->pmd_flag, pmd, addr, next);
-			continue;
-		}
-		pmd = (pmd_t *)info->alloc_pgt_page(info->context);
-		if (!pmd)
-			return -ENOMEM;
-		ident_pmd_init(info->pmd_flag, pmd, addr, next);
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
-	}
-
-	return 0;
-}
-
-int kernel_ident_mapping_init(struct x86_mapping_info *info, pgd_t *pgd_page,
-			      unsigned long addr, unsigned long end)
-{
-	unsigned long next;
-	int result;
-	int off = info->kernel_mapping ? pgd_index(__PAGE_OFFSET) : 0;
-
-	for (; addr < end; addr = next) {
-		pgd_t *pgd = pgd_page + pgd_index(addr) + off;
-		pud_t *pud;
-
-		next = (addr & PGDIR_MASK) + PGDIR_SIZE;
-		if (next > end)
-			next = end;
-
-		if (pgd_present(*pgd)) {
-			pud = pud_offset(pgd, 0);
-			result = ident_pud_init(info, pud, addr, next);
-			if (result)
-				return result;
-			continue;
-		}
-
-		pud = (pud_t *)info->alloc_pgt_page(info->context);
-		if (!pud)
-			return -ENOMEM;
-		result = ident_pud_init(info, pud, addr, next);
-		if (result)
-			return result;
-		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
-	}
-
-	return 0;
-}
+#include "ident_map.c"
 
 static int __init parse_direct_gbpages_off(char *arg)
 {
-- 
1.8.4.5
