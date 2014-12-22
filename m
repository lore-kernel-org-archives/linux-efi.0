From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 7/8] arm64: use 'physmem' memblock to improve CONFIG_STRICT_DEVMEM handling
Date: Mon, 22 Dec 2014 19:08:41 +0000
Message-ID: <1419275322-29811-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419275322-29811-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The 'physmem' memblock table allows us to classify memory as RAM even
if it is not covered by the ordinary 'memory' memblock table.

Under CONFIG_STRICT_DEVMEM, we can use this to:
- allow read-only access to parts of RAM that are not considered memory
  by the kernel, this is mainly intended for exposing UEFI configuration
  tables such as SMBIOS to userland;
- avoid using non-cached mappings for those parts of RAM, as it may
  result in mismatched attributes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/Kconfig   |  1 +
 arch/arm64/mm/mmap.c |  2 +-
 arch/arm64/mm/mmu.c  | 15 ++++++++++++++-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b1f9a20a3677..86902f8d8e36 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -60,6 +60,7 @@ config ARM64
 	select HAVE_GENERIC_DMA_COHERENT
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_MEMBLOCK
+	select HAVE_MEMBLOCK_PHYS_MAP
 	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 54922d1275b8..9f558ab41f39 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -126,7 +126,7 @@ int devmem_is_allowed(unsigned long pfn)
 {
 	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
 		return 0;
-	if (!page_is_ram(pfn))
+	if (!pfn_valid(pfn))
 		return 1;
 	return 0;
 }
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 328638548871..083be3de1a87 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -122,7 +122,7 @@ early_param("cachepolicy", early_cachepolicy);
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
-	if (!pfn_valid(pfn))
+	if (!memblock_is_physmem(PFN_PHYS(pfn)))
 		return pgprot_noncached(vma_prot);
 	else if (file->f_flags & O_SYNC)
 		return pgprot_writecombine(vma_prot);
@@ -130,6 +130,19 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
+/*
+ * This definition of phys_mem_access_prot_allowed() overrides
+ * the __weak definition in drivers/char/mem.c
+ */
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+				 unsigned long size, pgprot_t *prot)
+{
+	/* Disallow read-write access to system RAM */
+	if (memblock_is_physmem(PFN_PHYS(pfn)) && pgprot_val(*prot) & PTE_WRITE)
+		return 0;
+	return 1;
+}
+
 static void __init *early_alloc(unsigned long sz)
 {
 	void *ptr = __va(memblock_alloc(sz, sz));
-- 
1.8.3.2
