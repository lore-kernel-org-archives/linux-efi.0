From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Date: Sat, 11 Jan 2014 13:05:21 +0000
Message-ID: <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389445524-30623-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

A new macro for setting/clearing bits in the SCTLR.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Suggested-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm/include/asm/assembler.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 5c22851..aba6458 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -383,4 +383,17 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #endif
 	.endm
 
+#ifdef CONFIG_CPU_CP15
+/* Macro for setting/clearing bits in sctlr */
+	.macro update_sctlr, set:req, clear:req, tmp:req, tmp2:req
+	mrc	p15, 0, \tmp, c1, c0, 0
+	ldr	\tmp2, =\set
+	orr	\tmp, \tmp, \tmp2
+	ldr	\tmp2, =\clear
+	mvn	\tmp2, \tmp2
+	and	\tmp, \tmp, \tmp2
+	mcr	p15, 0, \tmp, c1, c0, 0
+	.endm
+#endif
+
 #endif /* __ASM_ASSEMBLER_H__ */
-- 
1.7.10.4
