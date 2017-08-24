From: Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 2/2] x86_64: boot, extract efi_pe_entry from startup_64
Date: Thu, 24 Aug 2017 09:33:27 +0200
Message-ID: <20170824073327.4129-2-jslaby@suse.cz>
References: <20170824073327.4129-1-jslaby@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170824073327.4129-1-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: matt@codeblueprint.co.uk
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, David Woodhouse <dwmw2@infradead.org>
List-Id: linux-efi@vger.kernel.org

efi_pe_entry body is somehow squashed into startup_64. In the old days,
we forced startup_64 to start at offset 0x200 and efi_pe_entry to start
at 0x210. But this requirement was removed in 99f857db8857 ("x86, build:
Dynamically find entry points in compressed startup code") long time
ago.

The way it is now makes the code less readable and illogical. And given
we can now safely extract the inlined efi_pe_entry body from
startup_64 into a separate function, we do so.

We also annotate the function appropriatelly by ENTRY+ENDPROC.

ABI offsets are preserved:
0000000000000000 T startup_32
0000000000000200 T startup_64
0000000000000390 T efi64_stub_entry

On the top-level, it looked like:
	.org 0x200
	ENTRY(startup_64)
	#ifdef CONFIG_EFI_STUB		; start of inlined
		jmp     preferred_addr
	GLOBAL(efi_pe_entry)
		... ; a lot of assembly (efi_pe_entry)
		leaq    preferred_addr(%rax), %rax
		jmp     *%rax
	preferred_addr:
	#endif				; end of inlined
		... ; a lot of assembly (startup_64)
	ENDPROC(startup_64)

And it is converted into:
	.org 0x200
	ENTRY(startup_64)
		... ; a lot of assembly (startup_64)
	ENDPROC(startup_64)

	#ifdef CONFIG_EFI_STUB
	ENTRY(efi_pe_entry)
		... ; a lot of assembly (efi_pe_entry)
		leaq    startup_64(%rax), %rax
		jmp     *%rax
	ENDPROC(efi_pe_entry)
	#endif

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <x86@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/boot/compressed/head_64.S | 112 ++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 59 deletions(-)

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index fbf4c32d0b62..b4a5d284391c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -243,65 +243,6 @@ ENTRY(startup_64)
 	 * that maps our entire kernel(text+data+bss+brk), zero page
 	 * and command line.
 	 */
-#ifdef CONFIG_EFI_STUB
-	/*
-	 * The entry point for the PE/COFF executable is efi_pe_entry, so
-	 * only legacy boot loaders will execute this jmp.
-	 */
-	jmp	preferred_addr
-
-ENTRY(efi_pe_entry)
-	movq	%rcx, efi64_config(%rip)	/* Handle */
-	movq	%rdx, efi64_config+8(%rip) /* EFI System table pointer */
-
-	leaq	efi64_config(%rip), %rax
-	movq	%rax, efi_config(%rip)
-
-	call	1f
-1:	popq	%rbp
-	subq	$1b, %rbp
-
-	/*
-	 * Relocate efi_config->call().
-	 */
-	addq	%rbp, efi64_config+40(%rip)
-
-	movq	%rax, %rdi
-	call	make_boot_params
-	cmpq	$0,%rax
-	je	fail
-	mov	%rax, %rsi
-	leaq	startup_32(%rip), %rax
-	movl	%eax, BP_code32_start(%rsi)
-	jmp	2f		/* Skip the relocation */
-
-handover_entry:
-	call	1f
-1:	popq	%rbp
-	subq	$1b, %rbp
-
-	/*
-	 * Relocate efi_config->call().
-	 */
-	movq	efi_config(%rip), %rax
-	addq	%rbp, 40(%rax)
-2:
-	movq	efi_config(%rip), %rdi
-	call	efi_main
-	movq	%rax,%rsi
-	cmpq	$0,%rax
-	jne	2f
-fail:
-	/* EFI init failed, so hang. */
-	hlt
-	jmp	fail
-2:
-	movl	BP_code32_start(%esi), %eax
-	leaq	preferred_addr(%rax), %rax
-	jmp	*%rax
-
-preferred_addr:
-#endif
 
 	/* Setup data segments. */
 	xorl	%eax, %eax
@@ -413,6 +354,59 @@ lvl5:
 	jmp	*%rax
 
 #ifdef CONFIG_EFI_STUB
+
+/* The entry point for the PE/COFF executable is efi_pe_entry. */
+ENTRY(efi_pe_entry)
+	movq	%rcx, efi64_config(%rip)	/* Handle */
+	movq	%rdx, efi64_config+8(%rip) /* EFI System table pointer */
+
+	leaq	efi64_config(%rip), %rax
+	movq	%rax, efi_config(%rip)
+
+	call	1f
+1:	popq	%rbp
+	subq	$1b, %rbp
+
+	/*
+	 * Relocate efi_config->call().
+	 */
+	addq	%rbp, efi64_config+40(%rip)
+
+	movq	%rax, %rdi
+	call	make_boot_params
+	cmpq	$0,%rax
+	je	fail
+	mov	%rax, %rsi
+	leaq	startup_32(%rip), %rax
+	movl	%eax, BP_code32_start(%rsi)
+	jmp	2f		/* Skip the relocation */
+
+handover_entry:
+	call	1f
+1:	popq	%rbp
+	subq	$1b, %rbp
+
+	/*
+	 * Relocate efi_config->call().
+	 */
+	movq	efi_config(%rip), %rax
+	addq	%rbp, 40(%rax)
+2:
+	movq	efi_config(%rip), %rdi
+	call	efi_main
+	movq	%rax,%rsi
+	cmpq	$0,%rax
+	jne	2f
+fail:
+	/* EFI init failed, so hang. */
+	hlt
+	jmp	fail
+2:
+	movl	BP_code32_start(%esi), %eax
+	leaq	startup_64(%rax), %rax
+	jmp	*%rax
+ENDPROC(efi_pe_entry)
+
 	.org 0x390
 ENTRY(efi64_stub_entry)
 	movq	%rdi, efi64_config(%rip)	/* Handle */
-- 
2.14.1
