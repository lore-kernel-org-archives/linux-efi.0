Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587381;
	b=QQ/UnkLi04JTKsCYkrlTXlf79mQ2k+faEHkjL1yQ/kE/ejacgvHvJAXjMO0WjX6nXxZ0
	 ZA7VWHMVd5qvlAPsp+9nrMSajD5prWtQ2nK7IVqByKzU4ZcvWu6yq5GdpxPyPkoq9MHlT
	 fipTqQwnBHKssX/OfJwXbE3tJYG6sFDdeKtAsM4pfiHIzeVOZBc8RiufrqzOYIE9cfLRr
	 VeyAzfNSeZgytTbvcysq9bmb54vj3t+JX4Y/7zIAG9/hqGhTXg5zYEo7b+IqhTvAcM4Cc
	 9Afdk9tfVjcZOdvgUYdo46vAzB9hE2MUHsRYJjVRVYASImwlyo+oLnh281TAjQhpbvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587381;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7RSsSfZmAsaQDGBU/83cZLNmSBWE8xnXwx5ZRwlx4tY=;
	b=Sl6wEQqUkaUldUjKfGAVS5iFSla+9Q30V/0u045E7bI7FVq/R1YNjVfOvwFTERAOvorM
	 FVqdEnYDPZZfrn9CnqlGI3H7CcAZZKJDH9HZ6GS7Y/695HoM9FtZrVLgxrP+PJEWk7zK9
	 C7XCvHAEwMK8BodxIwMJEKwBr/1qKg8SrojyviVOU4IGKHi/oXpjsIQbSN42E8z2qPs3m
	 Edp+HiAXxj5yI3Be1DvSfVQNgF+6vfv5KOr9gkug6HwoEo5YovVA3bvxJsNtG7OjZrW7q
	 wQlqhh3dP2z25yks1MZQPm2Ka5moYBpbT8j0hyu7rGQIWI0Kmk/qJFXjXwVHi5XBFoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bD8jMThr;
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CD56070251
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51CD56070251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bD8jMThr
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-386b8624cf7so555281eec.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587380; x=1796192180; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7RSsSfZmAsaQDGBU/83cZLNmSBWE8xnXwx5ZRwlx4tY=;
        b=bD8jMThrr2rN8grjV/Yf1kkTCKqkEd+5NbJZ4c720Wzieg3VXovIjTKm+FjatrVy7i
         WIY/xW68b3yZVJ6TDYueRzCfAOknJu93DLG8kuXPu52tCz0EkBW1PjPHtBNROxxszTgp
         qB9EGg11mPbcsxGiGZDkxXEXbdibS8FVhCOKVIHJGMYwDkI3xgkBtfFE9RxVt8gHT8Fq
         3wG5q/tdFYYPs/MbicqaT1mb0CRvcI9+EaOQQqEDpMHMDgttV5xRvCAvjBzHJtVvkX5R
         WHknTj7MbVdDoDjeSKbq39zTo6ZuDMO/JPfT3lqvgI9Rx1Zf9iR8pV+OqvCGHCmMs44t
         ucAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587380; x=1796192180;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RSsSfZmAsaQDGBU/83cZLNmSBWE8xnXwx5ZRwlx4tY=;
        b=TUqQUbjvWneefzkFHEeKP+cAnxb62KVcaJdHcQoXRTbmVy8O+9QGOgzPxcmdqgibEY
         9C9XuGt7S0m0LvzKQzRM0TtKAqYJlSE1lYzcizJNUAHeXKWAZ84gRms9icyfhEsB4rOF
         Di+fRKC4m97zDxuyNAfNMS8JN7w14IueXAxw8A+BjzR7ijNROqnaoMsquDYDX1EzIokq
         3V+73aSL9KvjdLrSEYC1l5WOFuK2gd4D6rfW9vakjFON9AZxhH6VSpDKG8e0CmEoYx2/
         26suGJEeZyR9ZWUT/clC8BUJ5Dw71UrWmie7VLB0Gpr2ZiPg6/cXP0ZRiBRn0jyoCkgQ
         64qg==
X-Forwarded-Encrypted: i=1; AL+hErFTFTTFpeuIxj3Nqvw6Q2OUif14NgWlIILaRUTIba22ZixsJITVv78olp4s6rI0nGjPHWmuLJeFeDo=@vger.kernel.org
X-Gm-Message-State: APuU4Z9rMPc3V2tQjFLzO+pdDYUhCnLg5vXGXWArIM3Q5S022N7LRcC1
	KRt1U9DZ4qpc1d+fQZyKEN3afu0gKoIQyNaQTd2Upgm6jw2oE+wV+Pv9usEAai9NXnpPEPaBHrs
	61+d7l8wcbA==
X-Received: from dycol11.prod.google.com ([2002:a05:7301:db8b:b0:385:d2b9:379d])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:d090:b0:386:8bd2:da2c
 with SMTP id 5a478bee46e88-3868bd2db9amr15053728eec.2.1795587379163; Tue, 24
 Nov 2026 22:16:19 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:04 -0800
In-Reply-To: <20261125061523.1540234-1-irogers@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261125061523.1540234-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-12-irogers@google.com>
Subject: [RFC PATCH v2 11/30] x86: Add DWARF CFI annotations to entry, ftrace,
 frame, and rethook
From: Ian Rogers <irogers@google.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, 
	mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, 
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, acme@kernel.org, namhyung@kernel.org, 
	linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, 
	nathan@kernel.org, llvm@lists.linux.dev, nsc@kernel.org, 
	linux-kbuild@vger.kernel.org, ojeda@kernel.org, 
	rust-for-linux@vger.kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, 
	maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, shuah@kernel.org, 
	linux-kselftest@vger.kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, 
	wnliu@google.com, dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Prepare x86-64 hand-written and inline assembly paths for runtime
Minimal DWARF CFI kernel unwinding when CONFIG_UNWINDER_DWARF_CFI is
enabled:
 - Emit .eh_frame alongside .debug_frame in asm/dwarf2.h and preserve
   FRAME_BEGIN/FRAME_END frame setup for non-leaf assembly helpers in
   asm/frame.h.
 - Annotate THUNK (arch/x86/entry/calling.h), ftrace_caller /
   ftrace_regs_caller / return_to_handler (arch/x86/kernel/ftrace_64.S),
   and arch_rethook_trampoline() (arch/x86/kernel/rethook.c) with .cfi_*
   directives.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/x86/entry/calling.h      | 17 +++++++
 arch/x86/include/asm/dwarf2.h |  6 +--
 arch/x86/include/asm/frame.h  | 42 ++++++++++------
 arch/x86/kernel/ftrace_64.S   | 44 ++++++++++++++++-
 arch/x86/kernel/rethook.c     | 92 ++++++++++++++++++++++++++++++++++-
 5 files changed, 180 insertions(+), 21 deletions(-)

diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
index 77e2d920a640..1a133ad44b95 100644
--- a/arch/x86/entry/calling.h
+++ b/arch/x86/entry/calling.h
@@ -432,9 +432,19 @@ For 32-bit we have the following conventions - kernel is built with
 /* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
 .macro THUNK name, func
 SYM_FUNC_START(\name)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+#endif
 	ANNOTATE_NOENDBR
 	pushq %rbp
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 16
+	.cfi_offset rbp, -16
+#endif
 	movq %rsp, %rbp
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_register rbp
+#endif
 
 	pushq %rdi
 	pushq %rsi
@@ -458,7 +468,14 @@ SYM_FUNC_START(\name)
 	popq %rsi
 	popq %rdi
 	popq %rbp
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa rsp, 8
+	.cfi_restore rbp
+#endif
 	RET
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_FUNC_END(\name)
 	_ASM_NOKPROBE(\name)
 .endm
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 09c9684d3ad6..0fa61360f69d 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -22,7 +22,7 @@
 #define CFI_ESCAPE		.cfi_escape
 #define CFI_SIGNAL_FRAME	.cfi_signal_frame
 
-#ifndef BUILD_VDSO
+#if !defined(BUILD_VDSO) && !defined(CONFIG_UNWINDER_DWARF_CFI)
 	/*
 	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
 	 * The latter we currently just discard since we don't do DWARF
@@ -33,8 +33,8 @@
 	.cfi_sections .debug_frame
 #else
 	 /*
-	  * For the vDSO, emit both runtime unwind information and debug
-	  * symbols for the .dbg file.
+	  * For the vDSO or runtime Minimal DWARF unwinding, emit both
+	  * runtime unwind information and debug symbols.
 	  */
 	.cfi_sections .eh_frame, .debug_frame
 #endif
diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
index 0ab65073c1cc..62939fbb6668 100644
--- a/arch/x86/include/asm/frame.h
+++ b/arch/x86/include/asm/frame.h
@@ -9,7 +9,7 @@
  * callable non-leaf asm function to make kernel stack traces more reliable.
  */
 
-#ifdef CONFIG_FRAME_POINTER
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_UNWINDER_DWARF_CFI)
 
 #ifdef __ASSEMBLER__
 
@@ -22,6 +22,30 @@
 	pop %_ASM_BP
 .endm
 
+#else /* !__ASSEMBLER__ */
+
+#define FRAME_BEGIN				\
+	"push %" _ASM_BP "\n"			\
+	_ASM_MOV "%" _ASM_SP ", %" _ASM_BP "\n"
+
+#define FRAME_END "pop %" _ASM_BP "\n"
+
+#endif /* __ASSEMBLER__ */
+
+#define FRAME_OFFSET __ASM_SEL(4, 8)
+
+#else /* !CONFIG_FRAME_POINTER && !CONFIG_UNWINDER_DWARF_CFI */
+
+#define FRAME_BEGIN
+#define FRAME_END
+#define FRAME_OFFSET 0
+
+#endif /* CONFIG_FRAME_POINTER || CONFIG_UNWINDER_DWARF_CFI */
+
+#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_UNWINDER_DWARF_CFI)
+
+#ifdef __ASSEMBLER__
+
 #ifdef CONFIG_X86_64
 /*
  * This is a sneaky trick to help the unwinder find pt_regs on the stack.  The
@@ -53,12 +77,6 @@
 
 #else /* !__ASSEMBLER__ */
 
-#define FRAME_BEGIN				\
-	"push %" _ASM_BP "\n"			\
-	_ASM_MOV "%" _ASM_SP ", %" _ASM_BP "\n"
-
-#define FRAME_END "pop %" _ASM_BP "\n"
-
 #ifdef CONFIG_X86_64
 
 #define ENCODE_FRAME_POINTER			\
@@ -84,9 +102,7 @@ static inline unsigned long encode_frame_pointer(struct pt_regs *regs)
 
 #endif /* __ASSEMBLER__ */
 
-#define FRAME_OFFSET __ASM_SEL(4, 8)
-
-#else /* !CONFIG_FRAME_POINTER */
+#else /* !CONFIG_FRAME_POINTER && !CONFIG_UNWINDER_DWARF_CFI */
 
 #ifdef __ASSEMBLER__
 
@@ -104,10 +120,6 @@ static inline unsigned long encode_frame_pointer(struct pt_regs *regs)
 
 #endif
 
-#define FRAME_BEGIN
-#define FRAME_END
-#define FRAME_OFFSET 0
-
-#endif /* CONFIG_FRAME_POINTER */
+#endif /* CONFIG_FRAME_POINTER || CONFIG_UNWINDER_DWARF_CFI */
 
 #endif /* _ASM_X86_FRAME_H */
diff --git a/arch/x86/kernel/ftrace_64.S b/arch/x86/kernel/ftrace_64.S
index 4b20673a3395..a7afcded8d09 100644
--- a/arch/x86/kernel/ftrace_64.S
+++ b/arch/x86/kernel/ftrace_64.S
@@ -27,6 +27,24 @@
 /* Size of stack used to save mcount regs in save_mcount_regs */
 #define MCOUNT_REG_SIZE		(FRAME_SIZE + MCOUNT_FRAME_SIZE)
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+# define FTRACE_CFI_STARTPROC		.cfi_startproc
+# define FTRACE_CFI_ENDPROC		.cfi_endproc
+# define FTRACE_CFI_ADJUST_CFA(off)	.cfi_adjust_cfa_offset (off)
+# define FTRACE_CFI_OFFSET(reg, off)	.cfi_offset reg, (off)
+# define FTRACE_CFI_RESTORE(reg)	.cfi_restore reg
+# define FTRACE_CFI_REMEMBER		.cfi_remember_state
+# define FTRACE_CFI_RESTORE_STATE	.cfi_restore_state
+#else
+# define FTRACE_CFI_STARTPROC
+# define FTRACE_CFI_ENDPROC
+# define FTRACE_CFI_ADJUST_CFA(off)
+# define FTRACE_CFI_OFFSET(reg, off)
+# define FTRACE_CFI_RESTORE(reg)
+# define FTRACE_CFI_REMEMBER
+# define FTRACE_CFI_RESTORE_STATE
+#endif
+
 /*
  * gcc -pg option adds a call to 'mcount' in most functions.
  * When -mfentry is used, the call is to 'fentry' and not 'mcount'
@@ -80,6 +98,7 @@
 	 * We add enough stack to save all regs.
 	 */
 	subq $(FRAME_SIZE), %rsp
+	FTRACE_CFI_ADJUST_CFA(FRAME_SIZE)
 	movq %rax, RAX(%rsp)
 	movq %rcx, RCX(%rsp)
 	movq %rdx, RDX(%rsp)
@@ -98,6 +117,7 @@
 	movq %rbp, %rdx
 #endif
 	movq %rdx, RBP(%rsp)
+	FTRACE_CFI_OFFSET(rbp, RBP - MCOUNT_REG_SIZE - 8 - \added)
 
 	/* Copy the parent address into %rsi (second parameter) */
 	movq MCOUNT_REG_SIZE+8+\added(%rsp), %rsi
@@ -118,6 +138,7 @@
 
 	/* ftrace_regs_caller or frame pointers require this */
 	movq RBP(%rsp), %rbp
+	FTRACE_CFI_RESTORE(rbp)
 
 	movq R9(%rsp), %r9
 	movq R8(%rsp), %r8
@@ -128,6 +149,7 @@
 	movq RAX(%rsp), %rax
 
 	addq $MCOUNT_REG_SIZE-\save, %rsp
+	FTRACE_CFI_ADJUST_CFA(-(MCOUNT_REG_SIZE - \save))
 
 	.endm
 
@@ -153,6 +175,7 @@ SYM_FUNC_END(__fentry__)
 EXPORT_SYMBOL(__fentry__)
 
 SYM_FUNC_START(ftrace_caller)
+	FTRACE_CFI_STARTPROC
 	ANNOTATE_NOENDBR
 	/* save_mcount_regs fills in first two parameters */
 	save_mcount_regs
@@ -195,13 +218,16 @@ SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 SYM_INNER_LABEL(ftrace_caller_end, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR
 	RET
+	FTRACE_CFI_ENDPROC
 SYM_FUNC_END(ftrace_caller);
 STACK_FRAME_NON_STANDARD_FP(ftrace_caller)
 
 SYM_FUNC_START(ftrace_regs_caller)
+	FTRACE_CFI_STARTPROC
 	ANNOTATE_NOENDBR
 	/* Save the current flags before any operations that can change them */
 	pushfq
+	FTRACE_CFI_ADJUST_CFA(8)
 
 	/* added 8 bytes to save flags */
 	save_mcount_regs 8
@@ -274,9 +300,11 @@ SYM_INNER_LABEL(ftrace_regs_caller_jmp, SYM_L_GLOBAL)
 	ANNOTATE_NOENDBR
 	jnz	1f
 
+	FTRACE_CFI_REMEMBER
 	restore_mcount_regs
 	/* Restore flags */
 	popfq
+	FTRACE_CFI_ADJUST_CFA(-8)
 
 	/*
 	 * The trampoline will add the return.
@@ -286,23 +314,28 @@ SYM_INNER_LABEL(ftrace_regs_caller_end, SYM_L_GLOBAL)
 	RET
 
 1:
+	FTRACE_CFI_RESTORE_STATE
 	/* See ftrace_jmp_set(), jmp to the trampoline */
 	btsq	$63, %rax
 	jc	2f
+	FTRACE_CFI_REMEMBER
 	movq %rax, MCOUNT_REG_SIZE+8(%rsp)
 	restore_mcount_regs
 	/* Restore flags */
 	popfq
+	FTRACE_CFI_ADJUST_CFA(-8)
 	RET
 
 	/* Swap the flags with orig_rax */
-2:	movq MCOUNT_REG_SIZE(%rsp), %rdi
+2:	FTRACE_CFI_RESTORE_STATE
+	movq MCOUNT_REG_SIZE(%rsp), %rdi
 	movq %rdi, MCOUNT_REG_SIZE-8(%rsp)
 	movq %rax, MCOUNT_REG_SIZE(%rsp)
 
 	restore_mcount_regs 8
 	/* Restore flags */
 	popfq
+	FTRACE_CFI_ADJUST_CFA(-8)
 	UNWIND_HINT_FUNC
 
 	/*
@@ -314,11 +347,14 @@ SYM_INNER_LABEL(ftrace_regs_caller_end, SYM_L_GLOBAL)
 	CALL .Ldo_rebalance
 	int3
 .Ldo_rebalance:
+	FTRACE_CFI_ADJUST_CFA(8)
 	add $8, %rsp
+	FTRACE_CFI_ADJUST_CFA(-8)
 	ALTERNATIVE __stringify(RET), \
 		    __stringify(ANNOTATE_UNRET_SAFE; ret; int3), \
 		    X86_FEATURE_CALL_DEPTH
 
+	FTRACE_CFI_ENDPROC
 SYM_FUNC_END(ftrace_regs_caller)
 STACK_FRAME_NON_STANDARD_FP(ftrace_regs_caller)
 
@@ -370,17 +406,21 @@ SYM_CODE_START(return_to_handler)
 	/* Restore return_to_handler value that got eaten by previous ret instruction. */
 	subq $8, %rsp
 	UNWIND_HINT_FUNC
+	FTRACE_CFI_STARTPROC
 
 	/* Save ftrace_regs for function exit context  */
 	subq $(FRAME_SIZE), %rsp
+	FTRACE_CFI_ADJUST_CFA(FRAME_SIZE)
 
 	movq %rax, RAX(%rsp)
 	movq %rdx, RDX(%rsp)
 	movq %rbp, RBP(%rsp)
+	FTRACE_CFI_OFFSET(rbp, RBP - FRAME_SIZE - 8)
 	movq %rdi, RSP(%rsp)
 	movq %rsp, %rdi
 
 	call ftrace_return_to_handler
+	FTRACE_CFI_ENDPROC
 
 	movq %rax, %rdi
 	movq RDX(%rsp), %rdx
@@ -398,8 +438,10 @@ SYM_CODE_START(return_to_handler)
 	int3
 .Ldo_rop:
 	mov %rdi, (%rsp)
+	FTRACE_CFI_STARTPROC
 	ALTERNATIVE __stringify(RET), \
 		    __stringify(ANNOTATE_UNRET_SAFE; ret; int3), \
 		    X86_FEATURE_CALL_DEPTH
+	FTRACE_CFI_ENDPROC
 SYM_CODE_END(return_to_handler)
 #endif
diff --git a/arch/x86/kernel/rethook.c b/arch/x86/kernel/rethook.c
index 85e2f2d16a90..2bff76758024 100644
--- a/arch/x86/kernel/rethook.c
+++ b/arch/x86/kernel/rethook.c
@@ -15,6 +15,87 @@ __visible void arch_rethook_trampoline_callback(struct pt_regs *regs);
 #define ANNOTATE_NOENDBR
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_UNWINDER_DWARF_CFI)
+#define RETHOOK_CFI_STARTPROC		"	.cfi_startproc\n"
+#define RETHOOK_CFI_ENDPROC		"	.cfi_endproc\n"
+#define RETHOOK_CFI_ADJUST(off)		"	.cfi_adjust_cfa_offset " #off "\n"
+#define RETHOOK_SAVE_REGS_STRING	\
+	"	subq $24, %rsp\n"	\
+	RETHOOK_CFI_ADJUST(24)		\
+	"	pushq %rdi\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %rsi\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %rdx\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %rcx\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %rax\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r8\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r9\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r10\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r11\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %rbx\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %rbp\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	.cfi_offset rbp, -144\n"\
+	"	pushq %r12\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r13\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r14\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	"	pushq %r15\n"		\
+	RETHOOK_CFI_ADJUST(8)		\
+	ENCODE_FRAME_POINTER
+#define RETHOOK_RESTORE_REGS_STRING	\
+	"	popq %r15\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r14\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r13\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r12\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %rbp\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	.cfi_restore rbp\n"	\
+	"	popq %rbx\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r11\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r10\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r9\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %r8\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %rax\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %rcx\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %rdx\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %rsi\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	popq %rdi\n"		\
+	RETHOOK_CFI_ADJUST(-8)		\
+	"	addq $24, %rsp\n"	\
+	RETHOOK_CFI_ADJUST(-24)
+#else
+#define RETHOOK_CFI_STARTPROC
+#define RETHOOK_CFI_ENDPROC
+#define RETHOOK_CFI_ADJUST(off)
+#define RETHOOK_SAVE_REGS_STRING	SAVE_REGS_STRING
+#define RETHOOK_RESTORE_REGS_STRING	RESTORE_REGS_STRING
+#endif
+
 /*
  * When a target function returns, this code saves registers and calls
  * arch_rethook_trampoline_callback(), which calls the rethook handler.
@@ -29,17 +110,23 @@ asm(
 	/* Push a fake return address to tell the unwinder it's a rethook. */
 	"	pushq $arch_rethook_trampoline\n"
 	UNWIND_HINT_FUNC
+	RETHOOK_CFI_STARTPROC
 	"       pushq $" __stringify(__KERNEL_DS) "\n"
+	RETHOOK_CFI_ADJUST(8)
 	/* Save the 'sp - 16', this will be fixed later. */
 	"	pushq %rsp\n"
+	RETHOOK_CFI_ADJUST(8)
 	"	pushfq\n"
-	SAVE_REGS_STRING
+	RETHOOK_CFI_ADJUST(8)
+	RETHOOK_SAVE_REGS_STRING
 	"	movq %rsp, %rdi\n"
 	"	call arch_rethook_trampoline_callback\n"
-	RESTORE_REGS_STRING
+	RETHOOK_RESTORE_REGS_STRING
 	/* In the callback function, 'regs->flags' is copied to 'regs->ss'. */
 	"	addq $16, %rsp\n"
+	RETHOOK_CFI_ADJUST(-16)
 	"	popfq\n"
+	RETHOOK_CFI_ADJUST(-8)
 #else
 	/* Push a fake return address to tell the unwinder it's a rethook. */
 	"	pushl $arch_rethook_trampoline\n"
@@ -57,6 +144,7 @@ asm(
 	"	popfl\n"
 #endif
 	ASM_RET
+	RETHOOK_CFI_ENDPROC
 	".size arch_rethook_trampoline, .-arch_rethook_trampoline\n"
 );
 NOKPROBE_SYMBOL(arch_rethook_trampoline);
-- 
2.56.1.831.g720f3f5937-goog

