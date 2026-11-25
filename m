Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587389;
	b=LpHMWwvXolv9fElvW4ZIBW4r7SblPrZEN2FVYpXNCGpxFQ1dKia4fNTXuXgRI8uzlqPp
	 E4BP8BQNirGm4cpz6FjneqpvgYv9M7s6ssDMP6ZA2epXisAMreE2keGHVv4gFMrXuRxyK
	 0UlgainvhopND3hzN29XLbOtxMGiC19IxDPCTZzjUnlTuSNZQzi7SHIKM7u0FDWmdIrSn
	 M7cJJJdPuC8vAIC9Jt6VA5giCr+eDfhULPbXOYkAWdutbAB8uBt2czNhwFStN+FbHGfgt
	 k9MbfBIWOJtw08KVVBgduQ+zZXXmo7H/vEMHDHylWWcRHq2p9rVPwa8N4bY/DkWYgaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587389;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=MvZ1Apa0kG0tOQFjdr93l8HqQxxrkaONSQJCjsrGQW8=;
	b=Sk3WdNmrpeXC9mt0r3frL0+NTAE9F8R9UMxiHRmCMK6kykEA/yEqXKwQHdb/vrSWCovj
	 3KaLBP/8NBPo1MlvKxaZkUHodPGK5byKAexutmwOTwL+6KZm9P2aargW7Ev39Q7DFoMau
	 O9FNKxZXgGCBckknyaLDxAiz7EwHB9cOgfzqZ2NsoKreyNOMDJvdaePp1oTTJlwT3it01
	 VfHXUhAzea38JDaqUu/FrB8FhLP6/knfYnVWCoSCOyY33eDjWj9Ikx7tHJS0Y8EbShRYE
	 /ePseN2kmetAGOSj+FFAyS82nWHADdPxhb9F2fT8UPFUGkrBh1c2mMMmybHNoqOje7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lObC260V;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A609B6070A27
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A609B6070A27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lObC260V
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-847e2926d94so10374503a34.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587388; x=1796192188; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MvZ1Apa0kG0tOQFjdr93l8HqQxxrkaONSQJCjsrGQW8=;
        b=lObC260VDOtlnuZB1KhtZWdIUP92sQfYLLDXabX0TYfAAY5ncL4HH4H6c1zw0oFgez
         Z2P22iOHneHuMpxCTw6J10yjqpH0OCdwJJTFZAvnFpmDFX1S/kreMPRkNK0LvfWV5Vi5
         8I1nklX4C4oO+RXRJgESbg+PwPJKS23qdczCDjh6Rk8dJoTYN9ksJLnwpRNKhx5tVvau
         UA4YypHAmhPLFs0qFP0H2tJbMoYPQ//+WnBKjBIB2xVCEa+aYFp4bsj46QAlNjMfEbgD
         c3g1q/CWpIg3DrHKHyX9rgDvzmtDpKEqY8Ok+LKWExBuQammKQ3FMN09mZP51Tlg7e3e
         wnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587388; x=1796192188;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MvZ1Apa0kG0tOQFjdr93l8HqQxxrkaONSQJCjsrGQW8=;
        b=LwXiVrONXDi63wzJ2jzMPcyTrt1yKySLk2mIvZtMuSDfSDCVhdHVrZvIPMAMfhfZoF
         rE3iYJD3ZahLoGfzfHzKPELFJo3GGpg6A6KBR8olnk15STSeW8enDYeP0/STtNh6i+hE
         DsKhN9+EcuRm31UEkNJgAC5LaO58XEW689MNKfg6PhcSOle2M1XvnVN7aFm+dMo03k7c
         Bq7Vr+/p0KruyHxn5oZZAbeL/EuesQ9iy4/AfDDXctPkvCQS1Z+1GOnfixGhLDsvu2nN
         jkN3LA+3dzVO9lrK3MBUFTKA+UJdkPBPzrLftGOkdMjPsf4/TQ5Bpy+fFEm9khp59caG
         1OXQ==
X-Forwarded-Encrypted: i=1; AL+hErFQXVJxKTr7y0l4v5WJusVmi6Fx4ThsURrNTGmnKAoTiVgT5ulI6Ynr+6jiliV8T7KZHFZjIBwhHWw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9lr0bqlKBGsIefhQ4WxIXTSoS6OReMuwOZzSEDCD0rzhKuOC8/
	/2V7l670LEoYzB+ZIAZe9qx3FMYaILc6fNdsaHkbOGMUZ/atGWCkgvqT/88cdHBkh3qdwJBxkv3
	3HcRYqDFwJg==
X-Received: from jafo16-n1.prod.google.com ([2002:a05:6639:310:10b0:620:c289:80b])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:50a7:b0:571:846e:6f06
 with SMTP id 5614622812f47-57a0a60f070mr19095260b6e.21.1795587387382; Tue, 24
 Nov 2026 22:16:27 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:08 -0800
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
Message-ID: <20261125061523.1540234-16-irogers@google.com>
Subject: [RFC PATCH v2 15/30] arm64: Add DWARF CFI annotations to entry,
 ftrace, EFI, BPF, and KASAN
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

Annotate arm64 hand-written assembly helpers with .cfi_* directives
under CONFIG_UNWINDER_DWARF_CFI so runtime .eh_frame unwinding traverses
call_on_irq_stack(), __efi_rt_asm_wrapper(), return_to_handler() (and
exports ftrace_caller_end), __hwasan_tag_mismatch(), and
arch_bpf_timed_may_goto(), and allow bpf_jit_supports_exceptions() when
CONFIG_UNWINDER_DWARF_CFI is enabled.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/arm64/kernel/efi-rt-wrapper.S  | 22 ++++++++++++++++++
 arch/arm64/kernel/entry-ftrace.S    | 35 ++++++++++++++++++++++++++++-
 arch/arm64/kernel/entry.S           | 22 ++++++++++++++++++
 arch/arm64/lib/kasan_sw_tags.S      | 16 +++++++++++++
 arch/arm64/net/bpf_jit_comp.c       |  9 ++++----
 arch/arm64/net/bpf_timed_may_goto.S | 19 ++++++++++++++++
 6 files changed, 118 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index e8ae803662cf..4ddfa5362e4f 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -7,8 +7,19 @@
 #include <asm/assembler.h>
 
 SYM_FUNC_START(__efi_rt_asm_wrapper)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+#endif
 	stp	x29, x30, [sp, #-112]!
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 112
+	.cfi_offset 29, -112
+	.cfi_offset 30, -104
+#endif
 	mov	x29, sp
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_register 29
+#endif
 
 	/*
 	 * Register x18 is designated as the 'platform' register by the AAPCS,
@@ -48,11 +59,19 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 
 	mov	x16, sp
 	mov	sp, x29
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_register 31
+#endif
 	str	xzr, [x16, #8]			// clear recorded task SP value
 
 	ldp	x1, x2, [sp, #16]
 	cmp	x2, x18
 	ldp	x29, x30, [sp], #112
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 0
+	.cfi_restore 29
+	.cfi_restore 30
+#endif
 	b.ne	0f
 	ret
 0:
@@ -69,6 +88,9 @@ SYM_FUNC_START(__efi_rt_asm_wrapper)
 #endif
 
 	b	efi_handle_corrupted_x18	// tail call
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_FUNC_END(__efi_rt_asm_wrapper)
 
 SYM_CODE_START(__efi_rt_asm_recover)
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index 025140caafe7..d112a29fd1a7 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -167,6 +167,7 @@ SYM_INNER_LABEL(ftrace_caller_direct, SYM_L_LOCAL)
 	 */
 	br	x17
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS */
+SYM_INNER_LABEL(ftrace_caller_end, SYM_L_GLOBAL)
 SYM_CODE_END(ftrace_caller)
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
@@ -327,10 +328,23 @@ SYM_FUNC_END(ftrace_stub_graph)
  *
  * Run ftrace_return_to_handler() before going back to parent.
  * @fp is checked against the value passed by ftrace_graph_caller().
+ *
+ * Under CONFIG_UNWINDER_DWARF_CFI, FREGS_PC is seeded with &return_to_handler
+ * before calling ftrace_return_to_handler(), which then overwrites FREGS_PC
+ * with the restored caller PC prior to invoking return callbacks. Tracking the
+ * return address at FREGS_PC allows kunwind_next_cfi() to unwind cleanly from
+ * inside ftrace_return_to_handler(), graph return callbacks, and interrupts.
  */
 SYM_CODE_START(return_to_handler)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+	.cfi_def_cfa sp, 0
+#endif
 	/* Make room for ftrace_regs */
 	sub	sp, sp, #FREGS_SIZE
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset FREGS_SIZE
+#endif
 
 	/* Save return value regs */
 	stp	x0, x1, [sp, #FREGS_X0]
@@ -338,12 +352,24 @@ SYM_CODE_START(return_to_handler)
 	stp	x4, x5, [sp, #FREGS_X4]
 	stp	x6, x7, [sp, #FREGS_X6]
 
-	/* Save the callsite's FP */
+	/* Save the callsite's FP and clear unused LR slot in ftrace_regs */
 	str	x29, [sp, #FREGS_FP]
+	str	xzr, [sp, #FREGS_LR]
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_offset x29, FREGS_FP - FREGS_SIZE
+	adr	x9, return_to_handler
+	add	x10, sp, #FREGS_SIZE
+	str	x10, [sp, #FREGS_SP]
+	str	x9, [sp, #FREGS_PC]
+	.cfi_offset x30, FREGS_PC - FREGS_SIZE
+#endif
 
 	mov	x0, sp
 	bl	ftrace_return_to_handler	// addr = ftrace_return_to_hander(fregs);
 	mov	x30, x0				// restore the original return address
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_same_value x30
+#endif
 
 	/* Restore return value regs */
 	ldp	x0, x1, [sp, #FREGS_X0]
@@ -351,7 +377,14 @@ SYM_CODE_START(return_to_handler)
 	ldp	x4, x5, [sp, #FREGS_X4]
 	ldp	x6, x7, [sp, #FREGS_X6]
 	add	sp, sp, #FREGS_SIZE
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 0
+	.cfi_restore x29
+#endif
 
 	ret
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_CODE_END(return_to_handler)
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 8d17f61d1b5b..15a591996307 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -882,6 +882,9 @@ NOKPROBE(ret_from_fork)
  * Calls func(regs) using this CPU's irq stack and shadow irq stack.
  */
 SYM_FUNC_START(call_on_irq_stack)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+#endif
 	save_and_disable_daif x9
 #ifdef CONFIG_SHADOW_CALL_STACK
 	get_current_task x16
@@ -891,7 +894,15 @@ SYM_FUNC_START(call_on_irq_stack)
 
 	/* Create a frame record to save our LR and SP (implicit in FP) */
 	stp	x29, x30, [sp, #-16]!
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 16
+	.cfi_offset 29, -16
+	.cfi_offset 30, -8
+#endif
 	mov	x29, sp
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_register 29
+#endif
 
 	ldr_this_cpu x16, irq_stack_ptr, x17
 
@@ -906,10 +917,21 @@ SYM_FUNC_START(call_on_irq_stack)
 	 * record.
 	 */
 	mov	sp, x29
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_register 31
+#endif
 	ldp	x29, x30, [sp], #16
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 0
+	.cfi_restore 29
+	.cfi_restore 30
+#endif
 	scs_load_current
 	restore_irq x9
 	ret
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_FUNC_END(call_on_irq_stack)
 NOKPROBE(call_on_irq_stack)
 
diff --git a/arch/arm64/lib/kasan_sw_tags.S b/arch/arm64/lib/kasan_sw_tags.S
index 20784ce75def..7959b5f3c6b0 100644
--- a/arch/arm64/lib/kasan_sw_tags.S
+++ b/arch/arm64/lib/kasan_sw_tags.S
@@ -38,6 +38,12 @@
  * incremented by 256 prior to return).
  */
 SYM_CODE_START(__hwasan_tag_mismatch)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+	.cfi_def_cfa_offset 256
+	.cfi_offset x29, -24
+	.cfi_offset x30, -16
+#endif
 	bti	c
 	add	x29, sp, #232
 	stp	x2, x3, [sp, #8 * 2]
@@ -66,9 +72,19 @@ SYM_CODE_START(__hwasan_tag_mismatch)
 	ldr	x18, [sp, #8 * 18]
 #endif
 	ldp	x29, x30, [sp, #8 * 29]
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_restore x29
+	.cfi_restore x30
+#endif
 
 	/* remove the structure from the stack */
 	add	sp, sp, #256
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 0
+#endif
 	ret
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_CODE_END(__hwasan_tag_mismatch)
 EXPORT_SYMBOL(__hwasan_tag_mismatch)
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 33632fb20997..ee1436295046 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -3489,10 +3489,11 @@ bool bpf_jit_supports_ptr_xchg(void)
 
 bool bpf_jit_supports_exceptions(void)
 {
-	/* We unwind through both kernel frames starting from within bpf_throw
-	 * call and BPF frames. Therefore we require FP unwinder to be enabled
-	 * to walk kernel frames and reach BPF frames in the stack trace.
-	 * ARM64 kernel is always compiled with CONFIG_FRAME_POINTER=y
+	/*
+	 * We unwind through both kernel frames starting from within bpf_throw
+	 * call and BPF frames. Both UNWINDER_FRAME_POINTER and
+	 * UNWINDER_DWARF_CFI preserve x29 across kernel frames and walk
+	 * JITed BPF frame records.
 	 */
 	return true;
 }
diff --git a/arch/arm64/net/bpf_timed_may_goto.S b/arch/arm64/net/bpf_timed_may_goto.S
index f8732b13bb1e..6d0aa023c1f4 100644
--- a/arch/arm64/net/bpf_timed_may_goto.S
+++ b/arch/arm64/net/bpf_timed_may_goto.S
@@ -4,9 +4,20 @@
 #include <linux/linkage.h>
 
 SYM_FUNC_START(arch_bpf_timed_may_goto)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+#endif
 	/* Allocate stack space and emit frame record */
 	stp     x29, x30, [sp, #-96]!
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 96
+	.cfi_offset 29, -96
+	.cfi_offset 30, -88
+#endif
 	mov     x29, sp
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_register 29
+#endif
 
 	/* Save BPF registers R0 - R5 (x8, x0-x4)*/
 	stp	x8, x0, [sp, #16]
@@ -35,6 +46,14 @@ SYM_FUNC_START(arch_bpf_timed_may_goto)
 
 	/* Restore FP and LR */
 	ldp     x29, x30, [sp], #96
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa 31, 0
+	.cfi_restore 29
+	.cfi_restore 30
+#endif
 
 	ret
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_FUNC_END(arch_bpf_timed_may_goto)
-- 
2.56.1.831.g720f3f5937-goog

