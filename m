From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 2/3] efi/arm: add SIMD stash/unstash operations
Date: Thu, 22 Sep 2016 12:30:05 +0100
Message-ID: <1474543806-19210-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1474543806-19210-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474543806-19210-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, glikely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds the SIMD stash/unstash operations that we need to allow UEFI
runtime services calls to call back into the kernel. In the ARM case,
these are actually NOPs, since UEFI on ARM is not allowed to use the
FP/NEON register file.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 766bf9b78160..c71ea8c21d0d 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -83,4 +83,15 @@ static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
 #define MIN_ZIMAGE_OFFSET	MAX_UNCOMP_KERNEL_SIZE
 #define MAX_FDT_OFFSET		ZIMAGE_OFFSET_LIMIT
 
+struct efi_simd_reg_stash {
+};
+
+static inline void arch_efi_stash_simd_regs(struct efi_simd_reg_stash *stash)
+{
+}
+
+static inline void arch_efi_unstash_simd_regs(struct efi_simd_reg_stash *stash)
+{
+}
+
 #endif /* _ASM_ARM_EFI_H */
-- 
2.7.4
