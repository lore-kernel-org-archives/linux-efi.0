From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 6/7] x86/efi: Update efi_thunk to use the the arch_efi_call_virt* macros
Date: Sat, 25 Jun 2016 08:20:29 +0100
Message-ID: <1466839230-12781-7-git-send-email-matt@codeblueprint.co.uk>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Roy Franz <roy.franz@linaro.org>, Russ Anderson <rja@sgi.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Alex Thorlton <athorlton@sgi.com>

Currently, the efi_thunk macro has some semi-duplicated code in it that
can be replaced with the arch_efi_call_virt_setup/teardown macros. This
commit simply replaces the duplicated code with those macros.

Signed-off-by: Alex Thorlton <athorlton@sgi.com>
Suggested-by: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Russ Anderson <rja@sgi.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi_64.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 6e7242be1c87..4cc2b9688dc2 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -469,18 +469,13 @@ extern efi_status_t efi64_thunk(u32, ...);
 	unsigned long flags;						\
 	u32 func;							\
 									\
-	efi_sync_low_kernel_mappings();					\
 	local_irq_save(flags);						\
-									\
-	efi_scratch.prev_cr3 = read_cr3();				\
-	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
-	__flush_tlb_all();						\
+	arch_efi_call_virt_setup();					\
 									\
 	func = runtime_service32(f);					\
-	__s = efi64_thunk(func, __VA_ARGS__);			\
+	__s = efi64_thunk(func, __VA_ARGS__);				\
 									\
-	write_cr3(efi_scratch.prev_cr3);				\
-	__flush_tlb_all();						\
+	arch_efi_call_virt_teardown();					\
 	local_irq_restore(flags);					\
 									\
 	__s;								\
-- 
2.7.3
