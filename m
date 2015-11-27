From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH v4 4/6] x86/efi: Hoist page table switching code into efi_call_virt()
Date: Fri, 27 Nov 2015 21:09:33 +0000
Message-ID: <1448658575-17029-5-git-send-email-matt@codeblueprint.co.uk>
References: <1448658575-17029-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448658575-17029-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This change is a prerequisite for pending patches that switch to a
dedicated EFI page table, instead of using 'trampoline_pgd' which
shares PGD entries with 'swapper_pg_dir'. The pending patches make it
impossible to dereference the runtime service function pointer without
first switching %cr3.

It's true that we now have duplicated switching code in
efi_call_virt() and efi_call_phys_{prolog,epilog}() but we are
sacrificing code duplication for a little more clarity and the ease of
writing the page table switching code in C instead of asm.

Reviewed-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
Cc: Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/include/asm/efi.h          | 25 +++++++++++++++++++++
 arch/x86/platform/efi/efi_64.c      | 24 ++++++++++-----------
 arch/x86/platform/efi/efi_stub_64.S | 43 -------------------------------------
 3 files changed, 36 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0010c78c4998..63a15de789d5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -3,6 +3,7 @@
 
 #include <asm/fpu/api.h>
 #include <asm/pgtable.h>
+#include <asm/tlb.h>
 
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
@@ -64,6 +65,17 @@ extern u64 asmlinkage efi_call(void *fp, ...);
 
 #define efi_call_phys(f, args...)		efi_call((f), args)
 
+/*
+ * Scratch space used for switching the pagetable in the EFI stub
+ */
+struct efi_scratch {
+	u64 r15;
+	u64 prev_cr3;
+	pgd_t *efi_pgt;
+	bool use_pgd;
+	u64 phys_stack;
+} __packed;
+
 #define efi_call_virt(f, ...)						\
 ({									\
 	efi_status_t __s;						\
@@ -71,7 +83,20 @@ extern u64 asmlinkage efi_call(void *fp, ...);
 	efi_sync_low_kernel_mappings();					\
 	preempt_disable();						\
 	__kernel_fpu_begin();						\
+									\
+	if (efi_scratch.use_pgd) {					\
+		efi_scratch.prev_cr3 = read_cr3();			\
+		write_cr3((unsigned long)efi_scratch.efi_pgt);		\
+		__flush_tlb_all();					\
+	}								\
+									\
 	__s = efi_call((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+									\
+	if (efi_scratch.use_pgd) {					\
+		write_cr3(efi_scratch.prev_cr3);			\
+		__flush_tlb_all();					\
+	}								\
+									\
 	__kernel_fpu_end();						\
 	preempt_enable();						\
 	__s;								\
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 102976dda8c4..b19cdac959b2 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,16 +47,7 @@
  */
 static u64 efi_va = EFI_VA_START;
 
-/*
- * Scratch space used for switching the pagetable in the EFI stub
- */
-struct efi_scratch {
-	u64 r15;
-	u64 prev_cr3;
-	pgd_t *efi_pgt;
-	bool use_pgd;
-	u64 phys_stack;
-} __packed;
+struct efi_scratch efi_scratch;
 
 static void __init early_code_mapping_set_exec(int executable)
 {
@@ -83,8 +74,11 @@ pgd_t * __init efi_call_phys_prolog(void)
 	int pgd;
 	int n_pgds;
 
-	if (!efi_enabled(EFI_OLD_MEMMAP))
-		return NULL;
+	if (!efi_enabled(EFI_OLD_MEMMAP)) {
+		save_pgd = (pgd_t *)read_cr3();
+		write_cr3((unsigned long)efi_scratch.efi_pgt);
+		goto out;
+	}
 
 	early_code_mapping_set_exec(1);
 
@@ -96,6 +90,7 @@ pgd_t * __init efi_call_phys_prolog(void)
 		vaddress = (unsigned long)__va(pgd * PGDIR_SIZE);
 		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), *pgd_offset_k(vaddress));
 	}
+out:
 	__flush_tlb_all();
 
 	return save_pgd;
@@ -109,8 +104,11 @@ void __init efi_call_phys_epilog(pgd_t *save_pgd)
 	int pgd_idx;
 	int nr_pgds;
 
-	if (!save_pgd)
+	if (!efi_enabled(EFI_OLD_MEMMAP)) {
+		write_cr3((unsigned long)save_pgd);
+		__flush_tlb_all();
 		return;
+	}
 
 	nr_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
 
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 86d0f9e08dd9..32020cb8bb08 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -38,41 +38,6 @@
 	mov %rsi, %cr0;			\
 	mov (%rsp), %rsp
 
-	/* stolen from gcc */
-	.macro FLUSH_TLB_ALL
-	movq %r15, efi_scratch(%rip)
-	movq %r14, efi_scratch+8(%rip)
-	movq %cr4, %r15
-	movq %r15, %r14
-	andb $0x7f, %r14b
-	movq %r14, %cr4
-	movq %r15, %cr4
-	movq efi_scratch+8(%rip), %r14
-	movq efi_scratch(%rip), %r15
-	.endm
-
-	.macro SWITCH_PGT
-	cmpb $0, efi_scratch+24(%rip)
-	je 1f
-	movq %r15, efi_scratch(%rip)		# r15
-	# save previous CR3
-	movq %cr3, %r15
-	movq %r15, efi_scratch+8(%rip)		# prev_cr3
-	movq efi_scratch+16(%rip), %r15		# EFI pgt
-	movq %r15, %cr3
-	1:
-	.endm
-
-	.macro RESTORE_PGT
-	cmpb $0, efi_scratch+24(%rip)
-	je 2f
-	movq efi_scratch+8(%rip), %r15
-	movq %r15, %cr3
-	movq efi_scratch(%rip), %r15
-	FLUSH_TLB_ALL
-	2:
-	.endm
-
 ENTRY(efi_call)
 	SAVE_XMM
 	mov (%rsp), %rax
@@ -83,16 +48,8 @@ ENTRY(efi_call)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
-	SWITCH_PGT
 	call *%rdi
-	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
 ENDPROC(efi_call)
-
-	.data
-ENTRY(efi_scratch)
-	.fill 3,8,0
-	.byte 0
-	.quad 0
-- 
2.6.2
