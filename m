From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 38/40] arm/efi: Enable runtime call flag checking
Date: Mon, 25 Apr 2016 21:07:10 +0100
Message-ID: <1461614832-17633-39-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Colin Ian King <colin.king@canonical.com>, Leif Lindholm <leif.lindholm@linaro.org>, Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Define ARCH_EFI_IRQ_FLAGS_MASK for arm, which will enable the generic
runtime wrapper code to detect when firmware erroneously modifies flags
over a runtime services function call.

We check all allocated flags, barring those which firmware has
legitimate reason to modify (condition flags and IT state). While in
practice corruption of some flags (e.g. J) would already be fatal, we
include these for consistency and documentation purposes.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm/include/asm/efi.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 5f273b43d704..a708fa1f0905 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -17,6 +17,7 @@
 #include <asm/mach/map.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
+#include <asm/ptrace.h>
 
 #ifdef CONFIG_EFI
 void efi_init(void);
@@ -34,6 +35,10 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 	__f(args);							\
 })
 
+#define ARCH_EFI_IRQ_FLAGS_MASK \
+	(PSR_J_BIT | PSR_E_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT | \
+	 PSR_T_BIT | MODE_MASK)
+
 static inline void efi_set_pgd(struct mm_struct *mm)
 {
 	check_and_switch_context(mm, NULL);
-- 
2.7.3
