From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v3 1/5] ia64: add early_memremap() alias for early_ioremap()
Date: Wed,  7 Aug 2013 19:54:16 +0100
Message-ID: <1375901660-23541-2-git-send-email-leif.lindholm@linaro.org>
References: <1375901660-23541-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375901660-23541-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, matt.fleming@intel.com, tony.luck@gmail.com, grant.likely@secretlab.ca, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

early_ioremap() on IA64 chooses its mapping type based on the EFI
memory map. This patch adds an alias "early_memremap()" to be used
where the targeted location is memory rather than an i/o device.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/include/asm/io.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index 74a7cc3..0d2bcb3 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -424,6 +424,7 @@ extern void __iomem * ioremap(unsigned long offset, unsigned long size);
 extern void __iomem * ioremap_nocache (unsigned long offset, unsigned long size);
 extern void iounmap (volatile void __iomem *addr);
 extern void __iomem * early_ioremap (unsigned long phys_addr, unsigned long size);
+#define early_memremap(phys_addr, size)        early_ioremap(phys_addr, size)
 extern void early_iounmap (volatile void __iomem *addr, unsigned long size);
 static inline void __iomem * ioremap_cache (unsigned long phys_addr, unsigned long size)
 {
-- 
1.7.10.4
