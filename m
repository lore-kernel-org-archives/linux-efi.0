From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 03/13] arm64: improve CONFIG_STRICT_DEVMEM handling
Date: Tue, 18 Nov 2014 13:57:02 +0100
Message-ID: <1416315432-8534-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416315432-8534-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Improve the handling of /dev/mem mappings under CONFIG_STRICT_DEVMEM by:
- allowing read-only access to parts of System RAM that are not
  considered memory by the kernel, this is mainly intended for exposing
  UEFI Configuration tables to userland;
- avoid using non-cached mappings for those parts of System RAM, as it
  may result in mismatched attributes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/mmap.c |  5 +++--
 arch/arm64/mm/mmu.c  | 15 ++++++++++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 1d73662f00ff..802cdf0df921 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -127,14 +127,15 @@ int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
  * is valid. The argument is a physical page number.  We mimic x86 here by
- * disallowing access to system RAM as well as device-exclusive MMIO regions.
+ * disallowing access to system RAM that is in active use by the kernel, as
+ * well as device-exclusive MMIO regions.
  * This effectively disable read()/write() on /dev/mem.
  */
 int devmem_is_allowed(unsigned long pfn)
 {
 	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
 		return 0;
-	if (!page_is_ram(pfn))
+	if (!pfn_valid(pfn))
 		return 1;
 	return 0;
 }
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4d583aa9ff4e..93ba10838359 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -121,7 +121,7 @@ early_param("cachepolicy", early_cachepolicy);
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
-	if (!pfn_valid(pfn))
+	if (!page_is_ram(pfn))
 		return pgprot_noncached(vma_prot);
 	else if (file->f_flags & O_SYNC)
 		return pgprot_writecombine(vma_prot);
@@ -129,6 +129,19 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
+/*
+ * This definition of phys_mem_access_prot_allowed() overrides
+ * the __weak definition in drivers/char/mem.c
+ */
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+				 unsigned long size, pgprot_t *prot)
+{
+	/* Disallow read-write access to reserved system RAM */
+	if ((pgprot_val(*prot) & PTE_WRITE) && page_is_ram(pfn))
+		return 0;
+	return 1;
+}
+
 static void __init *early_alloc(unsigned long sz)
 {
 	void *ptr = __va(memblock_alloc(sz, sz));
-- 
1.8.3.2
