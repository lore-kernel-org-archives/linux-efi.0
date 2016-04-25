From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv3 4/5] x86/efi: enable runtime call flag checking
Date: Mon, 25 Apr 2016 14:46:33 +0100
Message-ID: <1461591994-14918-5-git-send-email-mark.rutland@arm.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

Define ARCH_EFI_IRQ_FLAGS_MASK for x86, which will enable the generic
runtime wrapper code to detect when firmware erroneously modifies flags
over a runtime services function call.

For x86 (both 32-bit and 64-bit), we only need check the interrupt flag.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/efi.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 34bd38b..c6d8ad1 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -3,6 +3,7 @@
 
 #include <asm/fpu/api.h>
 #include <asm/pgtable.h>
+#include <asm/processor-flags.h>
 #include <asm/tlb.h>
 
 /*
@@ -28,8 +29,9 @@
 
 #define MAX_CMDLINE_ADDRESS	UINT_MAX
 
-#ifdef CONFIG_X86_32
+#define ARCH_EFI_IRQ_FLAGS_MASK	X86_EFLAGS_IF
 
+#ifdef CONFIG_X86_32
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
-- 
1.9.1
