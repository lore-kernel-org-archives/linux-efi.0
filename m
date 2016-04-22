From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCHv2 4/6] x86/efi: move to generic {__,}efi_call_virt
Date: Fri, 22 Apr 2016 14:51:21 +0100
Message-ID: <1461333083-15529-5-git-send-email-mark.rutland@arm.com>
References: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461333083-15529-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hpa@zytor.com, leif.lindholm@linaro.org, linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, mark.rutland@arm.com, matt@codeblueprint.co.uk, mingo@redhat.com, tglx@linutronix.de, will.deacon@arm.com
List-Id: linux-efi@vger.kernel.org

Now there's a common template for {__,}efi_call_virt, remove the
duplicate logic from the x86 efi code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/include/asm/efi.h | 41 ++++++++++++-----------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 53748c4..34bd38b 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -33,28 +33,16 @@
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
+#define arch_efi_call_virt_setup()	kernel_fpu_begin()
+#define arch_efi_call_virt_teardown()	kernel_fpu_end()
+
 /*
  * Wrap all the virtual calls in a way that forces the parameters on the stack.
  */
-
-/* Use this macro if your virtual returns a non-void value */
-#define efi_call_virt(f, args...) \
-({									\
-	efi_status_t __s;						\
-	kernel_fpu_begin();						\
-	__s = ((efi_##f##_t __attribute__((regparm(0)))*)		\
-		efi.systab->runtime->f)(args);				\
-	kernel_fpu_end();						\
-	__s;								\
-})
-
-/* Use this macro if your virtual call does not return any value */
-#define __efi_call_virt(f, args...) \
+#define arch_efi_call_virt(f, args...)					\
 ({									\
-	kernel_fpu_begin();						\
 	((efi_##f##_t __attribute__((regparm(0)))*)			\
 		efi.systab->runtime->f)(args);				\
-	kernel_fpu_end();						\
 })
 
 #define efi_ioremap(addr, size, type, attr)	ioremap_cache(addr, size)
@@ -78,10 +66,8 @@ struct efi_scratch {
 	u64	phys_stack;
 } __packed;
 
-#define efi_call_virt(f, ...)						\
+#define arch_efi_call_virt_setup()					\
 ({									\
-	efi_status_t __s;						\
-									\
 	efi_sync_low_kernel_mappings();					\
 	preempt_disable();						\
 	__kernel_fpu_begin();						\
@@ -91,9 +77,13 @@ struct efi_scratch {
 		write_cr3((unsigned long)efi_scratch.efi_pgt);		\
 		__flush_tlb_all();					\
 	}								\
-									\
-	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
-									\
+})
+
+#define arch_efi_call_virt(f, args...)					\
+	efi_call((void *)efi.systab->runtime->f, args)			\
+
+#define arch_efi_call_virt_teardown()					\
+({									\
 	if (efi_scratch.use_pgd) {					\
 		write_cr3(efi_scratch.prev_cr3);			\
 		__flush_tlb_all();					\
@@ -101,15 +91,8 @@ struct efi_scratch {
 									\
 	__kernel_fpu_end();						\
 	preempt_enable();						\
-	__s;								\
 })
 
-/*
- * All X86_64 virt calls return non-void values. Thus, use non-void call for
- * virt calls that would be void on X86_32.
- */
-#define __efi_call_virt(f, args...) efi_call_virt(f, args)
-
 extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
 					u32 type, u64 attribute);
 
-- 
1.9.1
