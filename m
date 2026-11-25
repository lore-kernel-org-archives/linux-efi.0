Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587394;
	b=Ca053o1C6t+Z1+hXc6gzjKCP+8utqo2GE0vkkqEgRvfIglyH6arP55cHx0hKSgAkKoo0
	 JA/95w8BEwJcGqwd40OOkI3b1Kl5rx6CCp7dmpaYEdsS1k6tuiDO0o6qS95c/fTw9LgaJ
	 w4peaNDrATeDQekGQZV9bT03AUR/mGu6dhOS5f1oIq34NZ/nAyfvNw3uueQHpuHS2rSeT
	 bDl6DN/sFlADTe0YVEPwPWGgxqZpJrfQhLRfmpAhpLfTpVU+TP65a2v0bKgCXlRCKXUhm
	 uojb/94TvQT2aHt3EEU58M9Pg/+hee5koVXGkayVRuL778PqrqIOBfwwifcYQD80kSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587394;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=Gv563tOaT9t1DmnC0tzfAtnqlHlK2h3cFSfEVUiDT5g=;
	b=gtsPPGixYVf1QWwZbn46QYkmMv3z0GLh7beG/Pl9SUbhKJb1Ix2hqaURAztHSdfgga0/
	 88b78hl7EKB1O98tRZQKIlELmP16e1EyRe73L+878seinDkHEsRhOycz3o4ZlwRm5pK0S
	 ePGQR+DNTntfrsvOFZcT/jlfrbhDvZRlEtAcUA0/0oabS5Hvc1DsYaqfzkZAT4hyteGnx
	 sWVA/PvubPMs5S20fNY5SP5QSy3qrXnOnLN+k6fv4utO1YQixcYMobZOhzGGTLUA2EK82
	 wIoqma8GTlSM3jbCd+461IDv2OYZGCo+ikHsUrhKH27DfRPxUJ/oyfSDCnyP6OTDFCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="W1f0w/Ye";
	arc=none smtp.remote-ip=74.125.82.200
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E27606B3C1
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42E27606B3C1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=W1f0w/Ye
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-3846d5f54c1so6513735eec.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587393; x=1796192193; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gv563tOaT9t1DmnC0tzfAtnqlHlK2h3cFSfEVUiDT5g=;
        b=W1f0w/YenH4sp5zKBUJ40VIC6OvbdnA2rYKgT6o3AGJmjVHt+M0+N3MzMUveUPjQY+
         jfFaZvkSPGBMSjcrQ8rMSgSIdkt2hPGQxlxn/WnCdXTNxYDjD3dOOpJpJliTCUfJgGJq
         C3Zv9CN+xqjm+71XMjWDtdWfV6AIBA/8Z9/HpriKOjDuXb2hbyVveEDmy0OQ/DoZtcoi
         C15YZptLpF/YGZrkKBtUlcacmsS/jArx8mR7LCaADEPEmGkW1UEBYnlQ6lcsXYtCG1F2
         Q/ZS+ZcG3qFQZLJtN7cgjfuBhHiOM15UJO+2V73+5rzG372Hbl+1JJDlmtqTVSzs1k2f
         385A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587393; x=1796192193;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gv563tOaT9t1DmnC0tzfAtnqlHlK2h3cFSfEVUiDT5g=;
        b=xoXv6MFqmNcuOrp1LKLoSZSna5KUIc3LyXVsVnJxHpmeL+qLs1yOfZqP6gNnjl+LYe
         YIuY/1mpn86MCypWUxKjmrmIgme5pUm4364I4ABqMq3MA3AgkgZ/Lr9mm6CFNkD9OFyU
         DsdoNliVGhXi03rqTdIZOeafXG9RaEfP62nbe7W2/typv+5QuqmcH/8IqZmZLkiHIiXF
         tf8UCCeaZvDAl9FTgIP7awWDTfr/ny/n2is/SHxhEWGtbRejaOwXF6wdcYBnwVUllMFT
         7LEhIDArazoqFXVOi3KwWm6skCBsh+X2PdALgCTfLFm3hqRtb7n8lBhFcTZk5yjUTUgr
         qg6Q==
X-Forwarded-Encrypted: i=1; AL+hErEi3mHx+zfm/ulsNZcn74WlMai5CLdFOFi3tuPAg36zafuD2xPsPLo4gI68DwZ+qd8cUzM8lrG6NLA=@vger.kernel.org
X-Gm-Message-State: APuU4Z8VEWr1DyiGgZwQAFFCKv5FzL6gguM1HZ9Xrs4mzLxGlqDVtk0r
	c8yT8UW4nUDKw1tJdRS47US7Nj8Dc5D3rpupxLmNmmshlUAF7loRX/90VYt1aYQZ2ugOs9DyTBA
	1mPRuvV2/9Q==
X-Received: from dydz30.prod.google.com ([2002:a05:7300:22de:b0:382:e403:7217])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:c696:b0:386:c4bd:7ff0
 with SMTP id 5a478bee46e88-386c4bd8670mr3588594eec.13.1795587393071; Tue, 24
 Nov 2026 22:16:33 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:11 -0800
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
Message-ID: <20261125061523.1540234-19-irogers@google.com>
Subject: [RFC PATCH v2 18/30] riscv: Add DWARF CFI annotations to entry,
 ftrace, rethook, and BPF JIT
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

Prepare RISC-V assembly, probe trampolines, and RV64 BPF JIT prologues
for runtime Minimal DWARF CFI kernel unwinding:
 - Export end labels for ret_from_fork_user_asm, call_on_irq_stack, and
   ftrace_caller save/restore boundaries, and save s0 in ftrace_caller
   under CONFIG_UNWINDER_DWARF_CFI.
 - Annotate return_to_handler() and arch_rethook_trampoline() with
   .cfi_* directives and key rethook shadow stacks on entry SP (CFA)
   under CONFIG_UNWINDER_DWARF_CFI.
 - Save RV_REG_RA unconditionally in RV64 BPF JIT prologues under
   CONFIG_UNWINDER_DWARF_CFI so leaf BPF programs unwind into frameless C
   callers.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/riscv/kernel/entry.S                     |  2 ++
 arch/riscv/kernel/mcount-dyn.S                |  6 ++--
 arch/riscv/kernel/mcount.S                    | 34 +++++++++++++++++--
 arch/riscv/kernel/probes/rethook.c            | 13 +++++--
 arch/riscv/kernel/probes/rethook_trampoline.S | 30 ++++++++++++++++
 arch/riscv/net/bpf_jit_comp64.c               |  6 ++--
 6 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 61b7a7716697..0a37ac12128c 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -374,6 +374,7 @@ SYM_CODE_START(ret_from_fork_user_asm)
 	move a0, sp /* pt_regs */
 	call ret_from_fork_user
 	j ret_from_exception
+SYM_INNER_LABEL(ret_from_fork_asm_end, SYM_L_GLOBAL)
 SYM_CODE_END(ret_from_fork_user_asm)
 
 #ifdef CONFIG_IRQ_STACKS
@@ -410,6 +411,7 @@ SYM_FUNC_START(call_on_irq_stack)
 	addi	sp, sp, STACKFRAME_SIZE_ON_STACK
 
 	ret
+SYM_INNER_LABEL(call_on_irq_stack_end, SYM_L_GLOBAL)
 SYM_FUNC_END(call_on_irq_stack)
 #endif /* CONFIG_IRQ_STACKS */
 
diff --git a/arch/riscv/kernel/mcount-dyn.S b/arch/riscv/kernel/mcount-dyn.S
index 082fe0b0e3c0..06c26725a830 100644
--- a/arch/riscv/kernel/mcount-dyn.S
+++ b/arch/riscv/kernel/mcount-dyn.S
@@ -85,7 +85,7 @@
 	addi	sp, sp, -FREGS_SIZE_ON_STACK
 	REG_S	t0,  FREGS_EPC(sp)
 	REG_S	x1,  FREGS_RA(sp)
-#ifdef HAVE_FUNCTION_GRAPH_FP_TEST
+#if defined(HAVE_FUNCTION_GRAPH_FP_TEST) || defined(CONFIG_UNWINDER_DWARF_CFI)
 	REG_S	x8,  FREGS_S0(sp)
 #endif
 	REG_S	x6,  FREGS_T1(sp)
@@ -113,7 +113,7 @@
 	.macro RESTORE_ABI_REGS
 	REG_L	t0, FREGS_EPC(sp)
 	REG_L	x1, FREGS_RA(sp)
-#ifdef HAVE_FUNCTION_GRAPH_FP_TEST
+#if defined(HAVE_FUNCTION_GRAPH_FP_TEST) || defined(CONFIG_UNWINDER_DWARF_CFI)
 	REG_L	x8, FREGS_S0(sp)
 #endif
 	REG_L	x6,  FREGS_T1(sp)
@@ -183,6 +183,7 @@ SYM_FUNC_START(ftrace_caller)
 #endif
 #endif
 	SAVE_ABI_REGS
+SYM_INNER_LABEL(ftrace_caller_saved, SYM_L_GLOBAL)
 	PREPARE_ARGS
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS
@@ -193,6 +194,7 @@ SYM_INNER_LABEL(ftrace_call, SYM_L_GLOBAL)
 	jalr	ra, 0(ra)
 #endif
 	RESTORE_ABI_REGS
+SYM_INNER_LABEL(ftrace_caller_restore, SYM_L_GLOBAL)
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 	bnez	t1, ftrace_caller_direct
 #endif
diff --git a/arch/riscv/kernel/mcount.S b/arch/riscv/kernel/mcount.S
index da4a4000e57e..c13aa07cdb04 100644
--- a/arch/riscv/kernel/mcount.S
+++ b/arch/riscv/kernel/mcount.S
@@ -27,8 +27,17 @@
 	 */
 	.macro SAVE_RET_ABI_STATE
 	addi	sp, sp, -FREGS_SIZE_ON_STACK
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset FREGS_SIZE_ON_STACK
+#endif
 	REG_S	ra, FREGS_RA(sp)
 	REG_S	s0, FREGS_S0(sp)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_offset s0, FREGS_S0 - FREGS_SIZE_ON_STACK
+	la	t0, return_to_handler
+	REG_S	t0, FREGS_EPC(sp)
+	.cfi_offset ra, FREGS_EPC - FREGS_SIZE_ON_STACK
+#endif
 	REG_S	a0, FREGS_A0(sp)
 	REG_S	a1, FREGS_A1(sp)
 	addi	s0, sp, FREGS_SIZE_ON_STACK
@@ -41,11 +50,16 @@
 	.endm
 
 	.macro RESTORE_RET_ABI_STATE
-	REG_L	ra, FREGS_RA(sp)
 	REG_L	s0, FREGS_S0(sp)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_restore s0
+#endif
 	REG_L	a0, FREGS_A0(sp)
 	REG_L	a1, FREGS_A1(sp)
 	addi	sp, sp, FREGS_SIZE_ON_STACK
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 0
+#endif
 	.endm
 
 SYM_TYPED_FUNC_START(ftrace_stub)
@@ -69,13 +83,27 @@ SYM_FUNC_START(return_to_handler)
  *
  * So alternatively we check the *old* frame pointer position, that is, the
  * value stored in -16(s0) on entry, and the s0 on return.
+ *
+ * Under CONFIG_UNWINDER_DWARF_CFI, FREGS_EPC(sp) is seeded with
+ * &return_to_handler before ftrace_return_to_handler() overwrites fregs->epc
+ * with the popped caller PC, allowing walk_stackframe_cfi() to unwind cleanly
+ * both before and after current->curr_ret_stack is decremented.
  */
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+#endif
 	SAVE_RET_ABI_STATE
 	mv	a0, sp
 	call	ftrace_return_to_handler
-	mv	a2, a0
+	mv	ra, a0
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_same_value ra
+#endif
 	RESTORE_RET_ABI_STATE
-	jalr	a2
+	ret
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_FUNC_END(return_to_handler)
 #endif
 
diff --git a/arch/riscv/kernel/probes/rethook.c b/arch/riscv/kernel/probes/rethook.c
index 5c27c1f50989..1ae3faf48218 100644
--- a/arch/riscv/kernel/probes/rethook.c
+++ b/arch/riscv/kernel/probes/rethook.c
@@ -10,7 +10,10 @@
 /* This is called from arch_rethook_trampoline() */
 unsigned long __used arch_rethook_trampoline_callback(struct pt_regs *regs)
 {
-	return rethook_trampoline_handler(regs, regs->s0);
+	unsigned long frame = IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
+			      regs->sp : regs->s0;
+
+	return rethook_trampoline_handler(regs, frame);
 }
 
 NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);
@@ -18,7 +21,13 @@ NOKPROBE_SYMBOL(arch_rethook_trampoline_callback);
 void arch_rethook_prepare(struct rethook_node *rhn, struct pt_regs *regs, bool mcount)
 {
 	rhn->ret_addr = regs->ra;
-	rhn->frame = regs->s0;
+	/*
+	 * With -fomit-frame-pointer under CONFIG_UNWINDER_DWARF_CFI, nested
+	 * functions share s0; key the rethook node on the function's entry SP
+	 * (its DWARF CFA), which matches regs->sp at arch_rethook_trampoline.
+	 */
+	rhn->frame = IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
+		     regs->sp : regs->s0;
 
 	/* replace return addr with trampoline */
 	regs->ra = (unsigned long)arch_rethook_trampoline;
diff --git a/arch/riscv/kernel/probes/rethook_trampoline.S b/arch/riscv/kernel/probes/rethook_trampoline.S
index c3aa8d8cf5af..f632630846de 100644
--- a/arch/riscv/kernel/probes/rethook_trampoline.S
+++ b/arch/riscv/kernel/probes/rethook_trampoline.S
@@ -78,9 +78,27 @@
 	REG_L x31, PT_T6(sp)
 	.endm
 
+/*
+ * Under CONFIG_UNWINDER_DWARF_CFI, PT_EPC(sp) is seeded with
+ * &arch_rethook_trampoline before rethook_trampoline_handler() overwrites
+ * regs->epc with the restored caller PC prior to running rethook handlers,
+ * enabling reliable CFI unwinding across kretprobe return hooks.
+ */
 SYM_CODE_START(arch_rethook_trampoline)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_startproc
+#endif
 	addi sp, sp, -(PT_SIZE_ON_STACK)
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset PT_SIZE_ON_STACK
+#endif
 	save_all_base_regs
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_offset s0, PT_S0 - PT_SIZE_ON_STACK
+	la t0, arch_rethook_trampoline
+	REG_S t0, PT_EPC(sp)
+	.cfi_offset ra, PT_EPC - PT_SIZE_ON_STACK
+#endif
 
 	move a0, sp /* pt_regs */
 
@@ -88,9 +106,21 @@ SYM_CODE_START(arch_rethook_trampoline)
 
 	/* use the result as the return-address */
 	move ra, a0
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_same_value ra
+#endif
 
 	restore_all_base_regs
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_restore s0
+#endif
 	addi sp, sp, PT_SIZE_ON_STACK
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_def_cfa_offset 0
+#endif
 
 	ret
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.cfi_endproc
+#endif
 SYM_CODE_END(arch_rethook_trampoline)
diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 788fcc21fd5b..fb8cc74cff11 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -201,7 +201,7 @@ static void __build_epilogue(bool is_tail_call, struct rv_jit_context *ctx)
 {
 	int stack_adjust = ctx->stack_size, store_offset = stack_adjust - 8;
 
-	if (seen_reg(RV_REG_RA, ctx)) {
+	if (seen_reg(RV_REG_RA, ctx) || IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI)) {
 		emit_ld(RV_REG_RA, store_offset, RV_REG_SP, ctx);
 		store_offset -= 8;
 	}
@@ -2130,7 +2130,7 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx, bool is_subprog)
 	if (bpf_stack_adjust)
 		mark_fp(ctx);
 
-	if (seen_reg(RV_REG_RA, ctx))
+	if (seen_reg(RV_REG_RA, ctx) || IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI))
 		stack_adjust += 8;
 	stack_adjust += 8; /* RV_REG_FP */
 	if (seen_reg(RV_REG_S1, ctx))
@@ -2168,7 +2168,7 @@ void bpf_jit_build_prologue(struct rv_jit_context *ctx, bool is_subprog)
 
 	emit_addi(RV_REG_SP, RV_REG_SP, -stack_adjust, ctx);
 
-	if (seen_reg(RV_REG_RA, ctx)) {
+	if (seen_reg(RV_REG_RA, ctx) || IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI)) {
 		emit_sd(RV_REG_SP, store_offset, RV_REG_RA, ctx);
 		store_offset -= 8;
 	}
-- 
2.56.1.831.g720f3f5937-goog

