From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 10/10] arm64/efi: improve /dev/mem mmap() handling under UEFI
Date: Thu,  6 Nov 2014 15:13:26 +0100
Message-ID: <1415283206-14713-11-git-send-email-ard.biesheuvel@linaro.org>
References: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415283206-14713-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When booting via UEFI, we need to ensure that mappings of arbitrary
physical ranges through /dev/mem do not violate architectural rules
regarding conflicting cacheability attributes of overlapping regions.
Also, when CONFIG_STRICT_DEVMEM is in effect, memory regions with
special significance to UEFI should be protected sufficiently.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/mmu.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 3e8b3732ca87..9ae3904f386c 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -19,6 +19,7 @@
 
 #include <linux/export.h>
 #include <linux/kernel.h>
+#include <linux/efi.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/mman.h>
@@ -28,6 +29,7 @@
 #include <linux/io.h>
 
 #include <asm/cputype.h>
+#include <asm/efi.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/sizes.h>
@@ -121,6 +123,8 @@ early_param("cachepolicy", early_cachepolicy);
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 			      unsigned long size, pgprot_t vma_prot)
 {
+	if (efi_enabled(EFI_MEMMAP) && efi_mem_access_prot(pfn, &vma_prot))
+		return vma_prot;
 	if (!pfn_valid(pfn))
 		return pgprot_noncached(vma_prot);
 	else if (file->f_flags & O_SYNC)
@@ -129,6 +133,19 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
+/*
+ * This definition of phys_mem_access_prot_allowed() overrides
+ * the __weak definition in drivers/char/mem.c
+ */
+int phys_mem_access_prot_allowed(struct file *file, unsigned long pfn,
+				 unsigned long size, pgprot_t *prot)
+{
+	if (efi_enabled(EFI_MEMMAP))
+		return efi_mem_access_allowed(pfn, size,
+					      pgprot_val(*prot) & PTE_WRITE);
+	return 1;
+}
+
 static void __init *early_alloc(unsigned long sz)
 {
 	void *ptr = __va(memblock_alloc(sz, sz));
-- 
1.8.3.2
