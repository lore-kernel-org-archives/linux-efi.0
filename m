From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 2/2] acpi, apei: use appropriate pgprot_t to map GHES memory
Date: Mon, 24 Aug 2015 11:25:57 -0700
Message-ID: <1440440757-4526-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel @ vger . kernel . org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi @ vger . kernel . org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

GHES memory region is used as a communication buffer for reporting
hardware errors from the firmware to kernel. Essentially the
firmware writes hardware error records there, triggers an NMI/interrupt,
then the GHES driver goes off and grabs the error record from the
GHES region.

The kernel currently maps the GHES memory region as cacheable
(PAGE_KERNEL) for all architectures. However, on some arm64 platforms,
there is a mismatch between how the kernel maps the GHES region
(PAGE_KERNEL) and how the firmware maps it (EFI_MEMORY_UC, ie.
uncacheable), leading to the possibility of the kernel GHES driver
reading stale data from the cache when it receives the interrupt. With
stale data being read, kernel reports there is no new hardware error
when there actually is; this may lead to further damage in various
scenarios, such as error propagation caused data corruption.

Instead GHES memory region should be mapped with page protection type
according to what is returned from arch_apei_get_mem_attribute().

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/acpi/apei/ghes.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 23981ac1c6c2..3dd9c462d22a 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -157,11 +157,15 @@ static void __iomem *ghes_ioremap_pfn_nmi(u64 pfn)
 
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
