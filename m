From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 2/2] acpi, apei: Use appropriate pgprot_t to map GHES memory
Date: Fri,  4 Sep 2015 14:11:42 +0100
Message-ID: <1441372302-23242-3-git-send-email-matt@codeblueprint.co.uk>
References: <1441372302-23242-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441372302-23242-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

If the ACPI APEI firmware handles hardware error first (called "firmware
first handling"), the firmware updates the GHES memory region with hardware
error record (called "generic hardware error record"). Essentially the
firmware writes hardware error records in the GHES memory region, triggers
an NMI/interrupt, then the GHES driver goes off and grabs the error record
from the GHES region.

The kernel currently maps the GHES memory region as cacheable
(PAGE_KERNEL) for all architectures. However, on some arm64 platforms,
there is a mismatch between how the kernel maps the GHES region
(PAGE_KERNEL) and how the firmware maps it (EFI_MEMORY_UC, ie.
uncacheable), leading to the possibility of the kernel GHES driver
reading stale data from the cache when it receives the interrupt.

With stale data being read, the kernel is unaware there is new hardware
error to be handled when there actually is; this may lead to further damage
in various scenarios, such as error propagation caused data corruption.
If uncorrected error (such as double bit ECC error) happened in memory
operation and if the kernel is unaware of such event happening, errorneous
data may be propagated to the disk.

Instead GHES memory region should be mapped with page protection type
according to what is returned from arch_apei_get_mem_attribute().

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/acpi/apei/ghes.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 2bfd53cbfe80..e661695cf123 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -161,11 +161,15 @@ static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
 
 static void __iomem *ghes_ioremap_pfn_irq(u64 pfn)
 {
-	unsigned long vaddr;
+	unsigned long vaddr, paddr;
+	pgprot_t prot;
 
 	vaddr = (unsigned long)GHES_IOREMAP_IRQ_PAGE(ghes_ioremap_area->addr);
-	ioremap_page_range(vaddr, vaddr + PAGE_SIZE,
-			   pfn << PAGE_SHIFT, PAGE_KERNEL);
+
+	paddr = pfn << PAGE_SHIFT;
+	prot = arch_apei_get_mem_attribute(paddr);
+
+	ioremap_page_range(vaddr, vaddr + PAGE_SIZE, paddr, prot);
 
 	return (void __iomem *)vaddr;
 }
-- 
2.1.0
