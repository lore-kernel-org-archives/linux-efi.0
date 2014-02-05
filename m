From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 02/22] arm: add new asm macro update_sctlr
Date: Wed,  5 Feb 2014 17:03:53 +0000
Message-ID: <1391619853-10601-3-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, patches@linaro.org
List-Id: linux-efi@vger.kernel.org

A new macro for setting/clearing bits in the SCTLR.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Suggested-by: Will Deacon <will.deacon@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm/include/asm/assembler.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
index 5c22851..e8ca24b 100644
--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -383,4 +383,18 @@ THUMB(	orr	\reg , \reg , #PSR_T_BIT	)
 #endif
 	.endm
 
+#ifdef CONFIG_CPU_CP15
+/* Macro for setting/clearing bits in sctlr */
+	.macro	update_sctlr, tmp:req, set=, clear=
+	mrc	p15, 0, \tmp, c1, c0, 0
+	.ifnc	\set,
+	orr	\tmp, \set
+	.endif
+	.ifnc	\clear,
+	bic	\tmp, \tmp, \clear
+	.endif
+	mcr	p15, 0, \tmp, c1, c0, 0
+	.endm
+#endif
+
 #endif /* __ASM_ASSEMBLER_H__ */
-- 
1.7.10.4
