From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 3/5] arm/efi: enable runtime call flag checking
Date: Mon, 25 Apr 2016 14:46:32 +0100
Message-ID: <1461591994-14918-4-git-send-email-mark.rutland@arm.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

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
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
---
 arch/arm/include/asm/efi.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e1461fc..b05ff68 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -17,6 +17,7 @@
 #include <asm/mach/map.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
+#include <asm/ptrace.h>
 
 #ifdef CONFIG_EFI
 void efi_init(void);
@@ -33,6 +34,10 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
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
1.9.1
