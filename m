From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 34/40] x86/efi: Move to generic {__,}efi_call_virt
Date: Mon, 25 Apr 2016 21:07:06 +0100
Message-ID: <1461614832-17633-35-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

Now there's a common template for {__,}efi_call_virt, remove the
duplicate logic from the x86 efi code.

Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/include/asm/efi.h | 41 ++++++++++++-----------------------------
 1 file changed, 12 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 8747abe8872f..fb085ce00bd2 100644
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
2.7.3
