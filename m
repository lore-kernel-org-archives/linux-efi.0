From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/4] efi/arm64: map the stack and entry wrapper into the UEFI page tables
Date: Thu, 25 Jan 2018 10:31:29 +0000
Message-ID: <20180125103131.19168-3-ard.biesheuvel@linaro.org>
References: <20180125103131.19168-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180125103131.19168-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org
Cc: joakim.bech-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, graeme.gregory-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

As a preparatory step towards unmapping the kernel entirely while
executing UEFI runtime services, move the stack and the entry
wrapper routine mappings into the EFI page tables. Also, create a
vector table that overrides the main one while executing in the
firmware so we will be able to remap/unmap the kernel while taking
interrupts.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h          |  5 ++
 arch/arm64/include/asm/efi.h        | 23 ++++++++-
 arch/arm64/include/asm/stacktrace.h |  4 ++
 arch/arm64/kernel/efi-rt-wrapper.S  | 51 +++++++++++++++++++-
 arch/arm64/kernel/efi.c             | 24 +++++++++
 arch/arm64/kernel/entry.S           |  1 +
 drivers/firmware/efi/arm-runtime.c  |  2 +
 7 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 17f1f1a814ff..3a63e7cc1dfa 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -99,4 +99,9 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 	return dram_base + SZ_512M;
 }
 
+static inline int efi_allocate_runtime_regions(struct mm_struct *mm)
+{
+	return 0;
+}
+
 #endif /* _ASM_ARM_EFI_H */
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 192d791f1103..b9b09a734719 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -2,11 +2,13 @@
 #ifndef _ASM_EFI_H
 #define _ASM_EFI_H
 
+#include <asm/memory.h>
+
+#ifndef __ASSEMBLY__
 #include <asm/boot.h>
 #include <asm/cpufeature.h>
 #include <asm/fpsimd.h>
 #include <asm/io.h>
-#include <asm/memory.h>
 #include <asm/mmu_context.h>
 #include <asm/neon.h>
 #include <asm/ptrace.h>
@@ -30,8 +32,9 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 #define arch_efi_call_virt(p, f, args...)				\
 ({									\
 	efi_##f##_t *__f;						\
+	typeof(__efi_rt_asm_wrapper) *__wrap = (void *)EFI_CODE_BASE;	\
 	__f = p->f;							\
-	__efi_rt_asm_wrapper(__f, #f, args);				\
+	__wrap(__f, #f, args);						\
 })
 
 #define arch_efi_call_virt_teardown()					\
@@ -146,4 +149,20 @@ static inline void efi_set_pgd(struct mm_struct *mm)
 void efi_virtmap_load(void);
 void efi_virtmap_unload(void);
 
+int __init efi_allocate_runtime_regions(struct mm_struct *mm);
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * When running with vmap'ed stacks, we need the base of the stack to be aligned
+ * appropriately, where the exact alignment depends on the page size. Let's just
+ * put the stack at address 0x0, which is guaranteed to be free and aligned.
+ */
+#define EFI_STACK_BASE		0x0
+#define EFI_STACK_SIZE		THREAD_SIZE
+
+/* where to map the pivot code in the UEFI page tables */
+#define EFI_CODE_BASE		0x200000
+#define EFI_CODE_SIZE		PAGE_SIZE
+
 #endif /* _ASM_EFI_H */
diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
index 472ef944e932..b1212b3b3df5 100644
--- a/arch/arm64/include/asm/stacktrace.h
+++ b/arch/arm64/include/asm/stacktrace.h
@@ -72,6 +72,8 @@ static inline bool on_overflow_stack(unsigned long sp)
 static inline bool on_overflow_stack(unsigned long sp) { return false; }
 #endif
 
+bool on_efi_stack(unsigned long sp);
+
 /*
  * We can only safely access per-cpu stacks from current in a non-preemptible
  * context.
@@ -88,6 +90,8 @@ static inline bool on_accessible_stack(struct task_struct *tsk, unsigned long sp
 		return true;
 	if (on_sdei_stack(sp))
 		return true;
+	if (on_efi_stack(sp))
+		return true;
 
 	return false;
 }
diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 05235ebb336d..09e77e5edd94 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -7,7 +7,10 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/efi.h>
 
+	.section	".rodata", "a"
+	.align		PAGE_SHIFT
 ENTRY(__efi_rt_asm_wrapper)
 	stp	x29, x30, [sp, #-32]!
 	mov	x29, sp
@@ -19,6 +22,12 @@ ENTRY(__efi_rt_asm_wrapper)
 	 */
 	stp	x1, x18, [sp, #16]
 
+	/* switch to the EFI runtime stack and vector table */
+	mov	sp, #EFI_STACK_BASE + EFI_STACK_SIZE
+	adr	x1, __efi_rt_vectors
+	msr	vbar_el1, x1
+	isb
+
 	/*
 	 * We are lucky enough that no EFI runtime services take more than
 	 * 5 arguments, so all are passed in registers rather than via the
@@ -32,10 +41,50 @@ ENTRY(__efi_rt_asm_wrapper)
 	mov	x4, x6
 	blr	x8
 
+	/* switch back to the task stack and primary vector table */
+	mov	sp, x29
+	ldr	x1, 2f
+	msr	vbar_el1, x1
+	isb
+
 	ldp	x1, x2, [sp, #16]
 	cmp	x2, x18
 	ldp	x29, x30, [sp], #32
 	b.ne	0f
 	ret
-0:	b	efi_handle_corrupted_x18	// tail call
+0:	ldr	x8, 1f
+	br	x8				// tail call
 ENDPROC(__efi_rt_asm_wrapper)
+	.align	3
+1:	.quad 	efi_handle_corrupted_x18
+2:	.quad	vectors
+
+	.macro	ventry
+	.align	7
+.Lv\@ :	stp	x29, x30, [sp, #-16]!		// preserve x29 and x30
+	mrs	x29, elr_el1			// preserve ELR
+	adr	x30, .Lret			// take return address
+	msr	elr_el1, x30			// set ELR to return address
+	ldr	x30, 2b				// take address of 'vectors'
+	msr	vbar_el1, x30			// set VBAR to 'vectors'
+	isb
+	add	x30, x30, #.Lv\@ - __efi_rt_vectors
+	br	x30
+	.endm
+
+.Lret:	msr	elr_el1, x29
+	adr	x30, __efi_rt_vectors
+	msr	vbar_el1, x30
+	isb
+	ldp	x29, x30, [sp], #16
+	eret
+
+	.align	11
+__efi_rt_vectors:
+	.rept	8
+	ventry
+	.endr
+	/*
+	 * EFI runtime services never drop to EL0, so the
+	 * remaining vector table entries are not needed.
+	 */
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index af4f943cffac..68c920b2f4f0 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -130,3 +130,27 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	pr_err_ratelimited(FW_BUG "register x18 corrupted by EFI %s\n", f);
 	return s;
 }
+
+bool on_efi_stack(unsigned long sp)
+{
+	return sp >= EFI_STACK_BASE && sp < (EFI_STACK_BASE + EFI_STACK_SIZE);
+}
+
+int __init efi_allocate_runtime_regions(struct mm_struct *mm)
+{
+	static u8 stack[EFI_STACK_SIZE] __page_aligned_bss;
+
+	/* map the stack */
+	create_pgd_mapping(mm, __pa_symbol(stack),
+			   EFI_STACK_BASE, EFI_STACK_SIZE,
+			   __pgprot(pgprot_val(PAGE_KERNEL) | PTE_NG),
+			   false);
+
+	/* map the runtime wrapper pivot function */
+	create_pgd_mapping(mm, __pa_symbol(__efi_rt_asm_wrapper),
+			   EFI_CODE_BASE, EFI_CODE_SIZE,
+			   __pgprot(pgprot_val(PAGE_KERNEL_ROX) | PTE_NG),
+			   false);
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index b34e717d7597..3bab6c60a12b 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -204,6 +204,7 @@ alternative_if ARM64_HAS_PAN
 alternative_else_nop_endif
 
 	.if	\el != 0
+	tbz	x21, #63, 1f			// skip if TTBR0 covers the stack
 	mrs	x21, ttbr0_el1
 	tst	x21, #TTBR_ASID_MASK		// Check for the reserved ASID
 	orr	x23, x23, #PSR_PAN_BIT		// Set the emulated PAN in the saved SPSR
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 1cc41c3d6315..e84f4d961de2 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -107,6 +107,8 @@ static bool __init efi_virtmap_init(void)
 	if (efi_memattr_apply_permissions(&efi_mm, efi_set_mapping_permissions))
 		return false;
 
+	efi_allocate_runtime_regions(&efi_mm);
+
 	return true;
 }
 
-- 
2.11.0
