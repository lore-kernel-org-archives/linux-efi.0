From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 39/40] x86/efi: Enable runtime call flag checking
Date: Mon, 25 Apr 2016 21:07:11 +0100
Message-ID: <1461614832-17633-40-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Ben Hutchings <ben@decadent.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Christoph Hellwig <hch@lst.de>, Darren Hart <dvhart@infradead.org>, David Herrmann <dh.herrmann@gmail.com>, David Howells <dhowells@redhat.com>, Greg KH <gregkh@linuxfoundation.org>, Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Leif Lindholm <leif.lindholm@linaro.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Raphael Hertzog <hertzog@debian.org>, Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

Define ARCH_EFI_IRQ_FLAGS_MASK for x86, which will enable the generic
runtime wrapper code to detect when firmware erroneously modifies flags
over a runtime services function call.

For x86 (both 32-bit and 64-bit), we only need check the interrupt flag.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Harald Hoyer harald@redhat.com
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Raphael Hertzog <hertzog@debian.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: David Herrmann <dh.herrmann@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/include/asm/efi.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index fb085ce00bd2..78d1e7467eae 100644
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
2.7.3
