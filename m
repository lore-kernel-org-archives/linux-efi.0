From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 2/3] arm64: use ENDPIPROC() to annotate position independent assembler routines
Date: Tue,  6 Oct 2015 12:03:43 +0100
Message-ID: <1444129424-8284-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1444129424-8284-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444129424-8284-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

For more control over which functions are called with the MMU off or
with the UEFI 1:1 mapping active, annotate some assembler routines as
position independent. This is done by introducing ENDPIPROC(), which
replaces the ENDPROC() declaration of those routines.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/assembler.h | 11 +++++++++++
 arch/arm64/lib/memchr.S            |  2 +-
 arch/arm64/lib/memcmp.S            |  2 +-
 arch/arm64/lib/memcpy.S            |  2 +-
 arch/arm64/lib/memmove.S           |  2 +-
 arch/arm64/lib/memset.S            |  2 +-
 arch/arm64/lib/strlen.S            |  2 +-
 arch/arm64/lib/strncmp.S           |  2 +-
 arch/arm64/mm/cache.S              | 10 +++++-----
 9 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index b51f2cc22ca9..12eff928ef8b 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -193,4 +193,15 @@ lr	.req	x30		// link register
 	str	\src, [\tmp, :lo12:\sym]
 	.endm
 
+/*
+ * Annotate a function as position independent, i.e., safe to be called before
+ * the kernel virtual mapping is activated.
+ */
+#define ENDPIPROC(x)			\
+	.globl	__pi_##x;		\
+	.type 	__pi_##x, %function;	\
+	.set	__pi_##x, x;		\
+	.size	__pi_##x, . - x;	\
+	ENDPROC(x)
+
 #endif	/* __ASM_ASSEMBLER_H */
diff --git a/arch/arm64/lib/memchr.S b/arch/arm64/lib/memchr.S
index 8636b7549163..4444c1d25f4b 100644
--- a/arch/arm64/lib/memchr.S
+++ b/arch/arm64/lib/memchr.S
@@ -41,4 +41,4 @@ ENTRY(memchr)
 	ret
 2:	mov	x0, #0
 	ret
-ENDPROC(memchr)
+ENDPIPROC(memchr)
diff --git a/arch/arm64/lib/memcmp.S b/arch/arm64/lib/memcmp.S
index 6ea0776ba6de..ffbdec00327d 100644
--- a/arch/arm64/lib/memcmp.S
+++ b/arch/arm64/lib/memcmp.S
@@ -255,4 +255,4 @@ CPU_LE( rev	data2, data2 )
 .Lret0:
 	mov	result, #0
 	ret
-ENDPROC(memcmp)
+ENDPIPROC(memcmp)
diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
index 8a9a96d3ddae..5d6ddb74454d 100644
--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -198,4 +198,4 @@ ENTRY(memcpy)
 	tst	count, #0x3f
 	b.ne	.Ltail63
 	ret
-ENDPROC(memcpy)
+ENDPIPROC(memcpy)
diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
index 57b19ea2dad4..68e2f2035e23 100644
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -194,4 +194,4 @@ ENTRY(memmove)
 	tst	count, #0x3f
 	b.ne	.Ltail63
 	ret
-ENDPROC(memmove)
+ENDPIPROC(memmove)
diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 7c72dfd36b63..29f405f08792 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -213,4 +213,4 @@ ENTRY(memset)
 	ands	count, count, zva_bits_x
 	b.ne	.Ltail_maybe_long
 	ret
-ENDPROC(memset)
+ENDPIPROC(memset)
diff --git a/arch/arm64/lib/strlen.S b/arch/arm64/lib/strlen.S
index 987b68b9ce44..55ccc8e24c08 100644
--- a/arch/arm64/lib/strlen.S
+++ b/arch/arm64/lib/strlen.S
@@ -123,4 +123,4 @@ CPU_LE( lsr	tmp2, tmp2, tmp1 )	/* Shift (tmp1 & 63).  */
 	csinv	data1, data1, xzr, le
 	csel	data2, data2, data2a, le
 	b	.Lrealigned
-ENDPROC(strlen)
+ENDPIPROC(strlen)
diff --git a/arch/arm64/lib/strncmp.S b/arch/arm64/lib/strncmp.S
index 0224cf5a5533..e267044761c6 100644
--- a/arch/arm64/lib/strncmp.S
+++ b/arch/arm64/lib/strncmp.S
@@ -307,4 +307,4 @@ CPU_BE( orr	syndrome, diff, has_nul )
 .Lret0:
 	mov	result, #0
 	ret
-ENDPROC(strncmp)
+ENDPIPROC(strncmp)
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index eb48d5df4a0f..cfa44a6adc0a 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -98,7 +98,7 @@ ENTRY(__flush_dcache_area)
 	b.lo	1b
 	dsb	sy
 	ret
-ENDPROC(__flush_dcache_area)
+ENDPIPROC(__flush_dcache_area)
 
 /*
  *	__inval_cache_range(start, end)
@@ -131,7 +131,7 @@ __dma_inv_range:
 	b.lo	2b
 	dsb	sy
 	ret
-ENDPROC(__inval_cache_range)
+ENDPIPROC(__inval_cache_range)
 ENDPROC(__dma_inv_range)
 
 /*
@@ -171,7 +171,7 @@ ENTRY(__dma_flush_range)
 	b.lo	1b
 	dsb	sy
 	ret
-ENDPROC(__dma_flush_range)
+ENDPIPROC(__dma_flush_range)
 
 /*
  *	__dma_map_area(start, size, dir)
@@ -184,7 +184,7 @@ ENTRY(__dma_map_area)
 	cmp	w2, #DMA_FROM_DEVICE
 	b.eq	__dma_inv_range
 	b	__dma_clean_range
-ENDPROC(__dma_map_area)
+ENDPIPROC(__dma_map_area)
 
 /*
  *	__dma_unmap_area(start, size, dir)
@@ -197,4 +197,4 @@ ENTRY(__dma_unmap_area)
 	cmp	w2, #DMA_TO_DEVICE
 	b.ne	__dma_inv_range
 	ret
-ENDPROC(__dma_unmap_area)
+ENDPIPROC(__dma_unmap_area)
-- 
1.9.1
