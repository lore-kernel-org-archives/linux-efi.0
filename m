From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 07/13] x86/efi: Add early thunk code to go from 64-bit to 32-bit
Date: Tue,  4 Mar 2014 13:14:15 +0000
Message-ID: <1393938861-16797-8-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393938861-16797-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Implement the transition code to go from IA32e mode to protected mode in
the EFI boot stub. This is required to use 32-bit EFI services from a
64-bit kernel.

Since EFI boot stub is executed in an identity-mapped region, there's
not much we need to do before invoking the 32-bit EFI boot services.
However, we do reload the firmware's global descriptor table
(efi32_boot_gdt) in case things like timer events are still running in
the firmware.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/efi_stub_64.S |  29 +++++++
 arch/x86/platform/efi/efi_stub_64.S    | 150 +++++++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+)

diff --git a/arch/x86/boot/compressed/efi_stub_64.S b/arch/x86/boot/compressed/efi_stub_64.S
index cedc60de86eb..7ff3632806b1 100644
--- a/arch/x86/boot/compressed/efi_stub_64.S
+++ b/arch/x86/boot/compressed/efi_stub_64.S
@@ -1 +1,30 @@
+#include <asm/segment.h>
+#include <asm/msr.h>
+#include <asm/processor-flags.h>
+
 #include "../../platform/efi/efi_stub_64.S"
+
+#ifdef CONFIG_EFI_MIXED
+	.code64
+	.text
+ENTRY(efi64_thunk)
+	push	%rbp
+	push	%rbx
+
+	subq	$16, %rsp
+	leaq	efi_exit32(%rip), %rax
+	movl	%eax, 8(%rsp)
+	leaq	efi_gdt64(%rip), %rax
+	movl	%eax, 4(%rsp)
+	movl	%eax, 2(%rax)		/* Fixup the gdt base address */
+	leaq	efi32_boot_gdt(%rip), %rax
+	movl	%eax, (%rsp)
+
+	call	__efi64_thunk
+
+	addq	$16, %rsp
+	pop	%rbx
+	pop	%rbp
+	ret
+ENDPROC(efi64_thunk)
+#endif /* CONFIG_EFI_MIXED */
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 88073b140298..a790d69cc85e 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -7,6 +7,10 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/msr.h>
+#include <asm/processor-flags.h>
+#include <asm/page_types.h>
 
 #define SAVE_XMM			\
 	mov %rsp, %rax;			\
@@ -164,6 +168,152 @@ ENTRY(efi_call6)
 	ret
 ENDPROC(efi_call6)
 
+#ifdef CONFIG_EFI_MIXED
+
+/*
+ * We run this function from the 1:1 mapping.
+ *
+ * This function must be invoked with a 1:1 mapped stack.
+ */
+ENTRY(__efi64_thunk)
+	subq	$32, %rsp
+	movl	%esi, 0x0(%rsp)
+	movl	%edx, 0x4(%rsp)
+	movl	%ecx, 0x8(%rsp)
+	movq	%r8, %rsi
+	movl	%esi, 0xc(%rsp)
+	movq	%r9, %rsi
+	movl	%esi,  0x10(%rsp)
+
+	sgdt	save_gdt(%rip)
+
+	leaq	1f(%rip), %rbx
+	movq	%rbx, func_rt_ptr(%rip)
+
+	/* Switch to gdt with 32-bit segments */
+	movl	40(%rsp), %eax
+	lgdt	(%rax)
+
+	leaq	efi_enter32(%rip), %rax
+	pushq	$__KERNEL_CS
+	pushq	%rax
+	lretq
+
+1:	addq	$32, %rsp
+
+	lgdt	save_gdt(%rip)
+
+	/*
+	 * Convert 32-bit status code into 64-bit.
+	 */
+	test	%rax, %rax
+	jz	1f
+	movl	%eax, %ecx
+	andl	$0x0fffffff, %ecx
+	andl	$0xf0000000, %eax
+	shl	$32, %rax
+	or	%rcx, %rax
+1:
+	ret
+ENDPROC(__efi64_thunk)
+
+ENTRY(efi_exit32)
+	xorq	%rax, %rax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %ss
+
+	movq	func_rt_ptr(%rip), %rax
+	push	%rax
+	mov	%rdi, %rax
+	ret
+ENDPROC(efi_exit32)
+
+	.code32
+/*
+ * EFI service pointer must be in %edi.
+ *
+ * The stack should represent the 32-bit calling convention.
+ */
+ENTRY(efi_enter32)
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %ss
+
+	/* Reload pgtables */
+	movl	%cr3, %eax
+	movl	%eax, %cr3
+
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
+	/* Disable long mode via EFER */
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btrl	$_EFER_LME, %eax
+	wrmsr
+
+	call	*%edi
+
+	/* We must preserve return value */
+	movl	%eax, %edi
+
+	movl	44(%esp), %eax
+	movl	%eax, 2(%eax)
+	lgdtl	(%eax)
+
+	movl	%cr4, %eax
+	btsl	$(X86_CR4_PAE_BIT), %eax
+	movl	%eax, %cr4
+
+	movl	%cr3, %eax
+	movl	%eax, %cr3
+
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btsl	$_EFER_LME, %eax
+	wrmsr
+
+	xorl	%eax, %eax
+	lldt	%ax
+
+	movl	48(%esp), %eax
+	pushl	$__KERNEL_CS
+	pushl	%eax
+
+	/* Enable paging */
+	movl	%cr0, %eax
+	btsl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+	lret
+ENDPROC(efi_enter32)
+
+	.data
+	.balign	8
+	.global	efi32_boot_gdt
+efi32_boot_gdt:	.word	0
+		.quad	0
+
+save_gdt:	.word	0
+		.quad	0
+func_rt_ptr:	.quad	0
+
+	.global efi_gdt64
+efi_gdt64:
+	.word	efi_gdt64_end - efi_gdt64
+	.long	0			/* Filled out by user */
+	.word	0
+	.quad	0x0000000000000000	/* NULL descriptor */
+	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
+	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
+	.quad	0x0080890000000000	/* TS descriptor */
+	.quad   0x0000000000000000	/* TS continued */
+efi_gdt64_end:
+#endif /* CONFIG_EFI_MIXED */
+
 	.data
 ENTRY(efi_scratch)
 	.fill 3,8,0
-- 
1.8.5.3
