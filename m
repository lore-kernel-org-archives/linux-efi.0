From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 1/3] efi/arm64: add SIMD stash/unstash operations
Date: Thu, 22 Sep 2016 12:30:04 +0100
Message-ID: <1474543806-19210-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474543806-19210-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds the SIMD stash/unstash operations that we need to allow UEFI
runtime services calls to call back into the kernel.

The UEFI bindings for arm64 stipulate that the ordinary AAPCS rules apply,
which means that code may use FP/NEON registers, and may also expect that
the values of the callee saved registers q8 - q15 are preserved across
function calls.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h | 33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index a9e54aad15ef..d6bbbcba9820 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -81,4 +81,37 @@ static inline void efi_set_pgd(struct mm_struct *mm)
 void efi_virtmap_load(void);
 void efi_virtmap_unload(void);
 
+struct efi_simd_reg_stash {
+	u8	q8[16];
+	u8	q9[16];
+	u8	q10[16];
+	u8	q11[16];
+	u8	q12[16];
+	u8	q13[16];
+	u8	q14[16];
+	u8	q15[16];
+};
+
+static inline void arch_efi_stash_simd_regs(struct efi_simd_reg_stash *stash)
+{
+	asm(	"stp	q8,  q9,  [%1];"
+		"stp	q10, q11, [%1, #32];"
+		"stp	q12, q13, [%1, #64];"
+		"stp	q14, q15, [%1, #96];"
+
+		: "=m"(*stash)
+		: "r"(stash));
+}
+
+static inline void arch_efi_unstash_simd_regs(struct efi_simd_reg_stash *stash)
+{
+	asm(	"ldp	q8,  q9,  [%1];"
+		"ldp	q10, q11, [%1, #32];"
+		"ldp	q12, q13, [%1, #64];"
+		"ldp	q14, q15, [%1, #96];"
+
+		:
+		: "m"(*stash), "r"(stash));
+}
+
 #endif /* _ASM_EFI_H */
-- 
2.7.4
