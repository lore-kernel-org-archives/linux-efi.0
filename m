From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 37/40] arm64/efi: Enable runtime call flag checking
Date: Mon, 25 Apr 2016 21:07:09 +0100
Message-ID: <1461614832-17633-38-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Dan Williams <dan.j.williams@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Define ARCH_EFI_IRQ_FLAGS_MASK for arm64, which will enable the generic
runtime wrapper code to detect when firmware erroneously modifies flags
over a runtime services function call.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/arm64/include/asm/efi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index cfd4ae2e46c0..622db3c6474e 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -4,6 +4,7 @@
 #include <asm/io.h>
 #include <asm/mmu_context.h>
 #include <asm/neon.h>
+#include <asm/ptrace.h>
 #include <asm/tlbflush.h>
 
 #ifdef CONFIG_EFI
@@ -35,6 +36,8 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 	kernel_neon_end();						\
 })
 
+#define ARCH_EFI_IRQ_FLAGS_MASK (PSR_D_BIT | PSR_A_BIT | PSR_I_BIT | PSR_F_BIT)
+
 /* arch specific definitions used by the stub code */
 
 /*
-- 
2.7.3
