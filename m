From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 1/3] ia64: add early_memremap() alias for early_ioremap()
Date: Thu,  5 Sep 2013 11:34:53 +0100
Message-ID: <1378377295-32758-2-git-send-email-leif.lindholm@linaro.org>
References: <1378377295-32758-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378377295-32758-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

early_ioremap() on IA64 chooses its mapping type based on the EFI
memory map. This patch adds an alias "early_memremap()" to be used
where the targeted location is memory rather than an i/o device.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
