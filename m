From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
Subject: [PATCH V3 2/2] acpi, apei: use appropriate pgprot_t to map GHES memory
Date: Mon, 17 Aug 2015 14:08:41 -0700
Message-ID: <1439845721-30196-2-git-send-email-zjzhang@codeaurora.org>
References: <1439845721-30196-1-git-send-email-zjzhang@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439845721-30196-1-git-send-email-zjzhang@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>, "linux-efi @ vger . kernel . org" <linux-efi@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>, Borislav Petkov <bp@suse.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

From: "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>

With ACPI APEI firmware first handling, generic hardware error
record is updated by firmware in GHES memory region. On an arm64
platform, firmware updates GHES memory region with uncached
access attribute, and then Linux reads stale data from cache.

With current code, GHES memory region is mapped with PAGE_KERNEL
based on the assumption that cache coherency of GHES memory region
is maintained by firmware on all platforms. This assumption is
not true for above mentioned arm64 platform.

Instead GHES memory region should be mapped with page protection type
according to what is returned from arch_apei_get_mem_attribute().

Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
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
