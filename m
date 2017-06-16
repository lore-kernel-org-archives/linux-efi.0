From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v7 09/36] x86/mm: Simplify p[gum]d_page() macros
Date: Fri, 16 Jun 2017 13:51:25 -0500
Message-ID: <20170616185125.18967.33160.stgit@tlendack-t1.amdoffice.net>
References: <20170616184947.18967.84890.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170616184947.18967.84890.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, xen-devel-GuqFBffKawuEi8DpZVb4nw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juergen Gross <jgross-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Create a pgd_pfn() macro similar to the p[um]d_pfn() macros and then
use the p[gum]d_pfn() macros in the p[gum]d_page() macros instead of
duplicating the code.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/pgtable.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 77037b6..b64ea52 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -195,6 +195,11 @@ static inline unsigned long p4d_pfn(p4d_t p4d)
 	return (p4d_val(p4d) & p4d_pfn_mask(p4d)) >> PAGE_SHIFT;
 }
 
+static inline unsigned long pgd_pfn(pgd_t pgd)
+{
+	return (pgd_val(pgd) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
+
 static inline int p4d_large(p4d_t p4d)
 {
 	/* No 512 GiB pages yet */
@@ -704,8 +709,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
  * Currently stuck as a macro due to indirect forward reference to
  * linux/mmzone.h's __section_mem_map_addr() definition:
  */
-#define pmd_page(pmd)		\
-	pfn_to_page((pmd_val(pmd) & pmd_pfn_mask(pmd)) >> PAGE_SHIFT)
+#define pmd_page(pmd)	pfn_to_page(pmd_pfn(pmd))
 
 /*
  * the pmd page can be thought of an array like this: pmd_t[PTRS_PER_PMD]
@@ -773,8 +777,7 @@ static inline unsigned long pud_page_vaddr(pud_t pud)
  * Currently stuck as a macro due to indirect forward reference to
  * linux/mmzone.h's __section_mem_map_addr() definition:
  */
-#define pud_page(pud)		\
-	pfn_to_page((pud_val(pud) & pud_pfn_mask(pud)) >> PAGE_SHIFT)
+#define pud_page(pud)	pfn_to_page(pud_pfn(pud))
 
 /* Find an entry in the second-level page table.. */
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
@@ -824,8 +827,7 @@ static inline unsigned long p4d_page_vaddr(p4d_t p4d)
  * Currently stuck as a macro due to indirect forward reference to
  * linux/mmzone.h's __section_mem_map_addr() definition:
  */
-#define p4d_page(p4d)		\
-	pfn_to_page((p4d_val(p4d) & p4d_pfn_mask(p4d)) >> PAGE_SHIFT)
+#define p4d_page(p4d)	pfn_to_page(p4d_pfn(p4d))
 
 /* Find an entry in the third-level page table.. */
 static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
@@ -859,7 +861,7 @@ static inline unsigned long pgd_page_vaddr(pgd_t pgd)
  * Currently stuck as a macro due to indirect forward reference to
  * linux/mmzone.h's __section_mem_map_addr() definition:
  */
-#define pgd_page(pgd)		pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT)
+#define pgd_page(pgd)	pfn_to_page(pgd_pfn(pgd))
 
 /* to find an entry in a page-table-directory. */
 static inline p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
