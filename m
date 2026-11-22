Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391947;
	b=ENah1yK82QeR94euea4QNtEE3Ek1Ctx7D3eZ+LsElwRWoEv+5wp3tTX7g9LkIrZ/mumO
	 3xADDzmIRoBx2egiQsZ1n954LwXK1LqseX28NMcmgf503xXtkHDHUfq/xDocDt4WSCGdp
	 KmnE6cK6Er6VNkHBCiYlmTvju4fnRtOju4jg/AJE9G7oHvNfvRaVYFk7FYD7jklN2vvEc
	 ry0Dq7MOTeGSSLFu1X2w/PjeNRgRRMp/p5uFv3/Cg+C8qSV4Uaq8O2CoklDUVz2ubRkU4
	 psHCna+1OgxndPW2pZOopb1yN966cN8E01zLc3PZCRLJPinh1e4FbrMMiyfLKfm+7jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391947;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=ncQGO4JuIitxmk5155J5XL1KqhcSRq/3dJf0u26PCVc=;
	b=2UIexIacf0mAoo/MyXWYJLsfQxrsVH+yYKvlNQspqsqnUIuoqiqsOP7Rvj2lefNqAc1l
	 OEhwRIxLG++VnUmWtLBD2zEMT8c4d+M0qZgv7KdGouqTniOJiLn214Q2f09NCox7zH2Nb
	 OnMivwCmXun6F+vK+/wKFbBqfBtUe4/PvQqWeV/5T68ApElENe4nXWNLIpVeFirBSgFVb
	 frlBZ470b6XdO098wGn38KKE6Mu5f2J0g6aGyZxfAtHImck98cVYofFoWyCfOxajJiY3f
	 ngSvADrMdvpIujRec7SPjPhIFps7hiXEEpUD96vfskaEW0YF4mxIcsnAGdwgvRwG0TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=naTWtkgx;
	arc=none smtp.remote-ip=74.125.82.71
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB32B606A684
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:59:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB32B606A684
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=naTWtkgx
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b25d977b91so2936424c88.1
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391945; x=1795996745; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ncQGO4JuIitxmk5155J5XL1KqhcSRq/3dJf0u26PCVc=;
        b=naTWtkgx1efplHUvDzOAFJScso1+vpbVwYkmhS5hEQgdJ3zO/+eA4D0YtVMc0rFzm7
         0W7CVp+T7DA9i3lCOcFCA/8AEdoxAsEvQYPqpC6CoNu/n2R/cndi3P/AJrMo0CE0UmPN
         /XCF3rbhvIZ/iOXnGSAIhZfHVRWkyYkO+DijzKZS21XnqrnH69KIm6kH5+9nP51Zj7mP
         Zgo2Tl/6HKEXhfIWG/qeOCJdWK7wcYTzQlJNsLcUN8Fjj2PLP/mcfWIEV356UQvVRXs6
         zqH9sDvHCIyu5pQFCLzMplbCtJD7ggYe8BLMf+A7Z8GzjyQXP6lCOm1ggepWIyXP5Wuy
         Gqow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391945; x=1795996745;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ncQGO4JuIitxmk5155J5XL1KqhcSRq/3dJf0u26PCVc=;
        b=RLkPbJBMsevSxNqi6kkUGJIfB460Nx7+kYmTmi2bLAWNuBX4vhh5c4jTV1ahh/l70n
         POJ9qPr64ZNhbN+/OfeuMX+6lxVVoqS/5z7AM28aPU2pZvRxQSGKBf5Yn65mAkCsUXk1
         aTRBXX8IVtY7CD9yeeQsPBPW9zu6RUGw2illQSRlFYdXc4ziWVAwRPTUxXywUaTyXLGR
         7xV/avLWz2RBTujPXrAlruwYJICo4LLN7oqSipf4SnWFMjaQ85QwsBDFU/CEwwayqxmN
         6W2DL4fRfkP9hbKQq3QvNsIsjisyds1SL+O4yiV9IoNYu+U9t3qxPxjKaM9OgRodcOOm
         GB2A==
X-Forwarded-Encrypted: i=1; AL+hErEpzL938cpGou36Z+3bX3nPzlXToHNHejwUEGPuZ8R3bxg4E9rG2HEVO+kWaKG8/4CZZ7fk4ZIpuaM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+tpwia3cufT/8R/YT/dmAzLkIismghQHGDX4ZDFAUu91K4pyo0
	xdixkf0BAKBxzfzfKeq3o3CwXzT4rvJhNmurexHuI8GKPvqdbFvqd40TXENtp738kitT0dwzOmV
	ZVIX18FOwzw==
X-Received: from dlbqq2.prod.google.com ([2002:a05:7022:ed02:b0:1ab:7a71:e7])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:2608:b0:1b2:6eef:3f32
 with SMTP id a92af1059eb24-1b5568f1322mr8780291c88.37.1795391944454; Sun, 22
 Nov 2026 15:59:04 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:51 -0800
In-Reply-To: <20261122235757.3456048-1-irogers@google.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <20261122235757.3456048-1-irogers@google.com>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122235757.3456048-6-irogers@google.com>
Subject: [RFC PATCH v1 05/11] x86/unwind: Add Minimal DWARF CFI kernel unwinder
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
	nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, 
	ojeda@kernel.org, rust-for-linux@vger.kernel.org, ardb@kernel.org, 
	linux-efi@vger.kernel.org, maz@kernel.org, oupton@kernel.org, 
	kvmarm@lists.linux.dev, shuah@kernel.org, linux-kselftest@vger.kernel.org, 
	indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, 
	dylanbhatch@google.com, Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"

Add CONFIG_UNWINDER_DWARF_CFI as a selectable x86-64 kernel stack
unwinder in arch/x86/kernel/unwind_dwarf.c, implementing the asm/unwind.h
and HAVE_RELIABLE_STACKTRACE interfaces over compiler-generated
.eh_frame and linker-generated --eh-frame-hdr tables.

 - Build kernel C and Rust objects with asynchronous unwind tables and
   -fomit-frame-pointer, while disabling unwind table emission in
   special boot, purgatory, and EFI libstub objects and enabling BPF
   exception stack walks in arch/x86/net/bpf_jit_comp.c.
 - Place .eh_frame_hdr and .eh_frame inside RO_DATA via
   ARCH_RODATA_SECTIONS so mark_rodata_ro() write-protects them without
   freeing them as rodata/data gap pages, and index loadable module
   .eh_frame sections via dwarf_cfi_mod_alloc()/dwarf_cfi_mod_free_rcu().
 - Annotate THUNK, ftrace_64.S, and arch_rethook_trampoline() with
   .cfi_* directives, preserve FRAME_BEGIN/FRAME_END for non-leaf asm,
   and pair with ENCODE_FRAME_POINTER (%rsp-verified against pt_regs) in
   entry assembly stubs and call_on_stack() IRQ stack pivots so
   unwind_next_frame() transitions cleanly across task, IRQ, exception,
   ftrace, fgraph, rethook, BPF, and NMI frames.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/x86/Kconfig                      |   2 +-
 arch/x86/Kconfig.debug                |  13 +
 arch/x86/Makefile                     |   7 +
 arch/x86/boot/startup/Makefile        |   1 +
 arch/x86/entry/calling.h              |  17 +
 arch/x86/include/asm/dwarf2.h         |   6 +-
 arch/x86/include/asm/frame.h          |  42 +-
 arch/x86/include/asm/module.h         |   5 +
 arch/x86/include/asm/unwind.h         |  15 +-
 arch/x86/kernel/Makefile              |   4 +
 arch/x86/kernel/ftrace_64.S           |  44 +-
 arch/x86/kernel/module.c              |  11 +-
 arch/x86/kernel/rethook.c             |  92 +++-
 arch/x86/kernel/unwind_dwarf.c        | 663 ++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux.lds.S         |  16 +
 arch/x86/net/bpf_jit_comp.c           |  12 +-
 arch/x86/purgatory/Makefile           |   1 +
 drivers/firmware/efi/libstub/Makefile |   3 +-
 include/asm-generic/vmlinux.lds.h     |   5 +
 19 files changed, 925 insertions(+), 34 deletions(-)
 create mode 100644 arch/x86/kernel/unwind_dwarf.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c8096cf66c38..517c2b728752 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -287,7 +287,7 @@ config X86
 	select MMU_GATHER_MERGE_VMAS
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
 	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_RELIABLE_STACKTRACE		if UNWINDER_ORC || STACK_VALIDATION
+	select HAVE_RELIABLE_STACKTRACE		if UNWINDER_ORC || UNWINDER_DWARF_CFI || STACK_VALIDATION
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_SETUP_PER_CPU_AREA
 	select HAVE_SOFTIRQ_ON_OWN_STACK
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index c95c3aaadf97..bd894d76360c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -246,6 +246,19 @@ config UNWINDER_ORC
 	  Enabling this option will increase the kernel's runtime memory usage
 	  by roughly 2-4MB, depending on your kernel config.
 
+config UNWINDER_DWARF_CFI
+	bool "Minimal DWARF CFI unwinder"
+	depends on X86_64
+	select UNWIND_DWARF_CFI
+	select UNWIND_TABLES
+	help
+	  This option enables the Minimal DWARF Call Frame Information (CFI)
+	  unwinder for kernel stack traces.  It interprets a strictly bounded
+	  subset of compiler-generated .eh_frame / .eh_frame_hdr tables
+	  matching SFrame's stack state model (PC advances, SP/FP-based CFA
+	  offsets, and FP/RA stack offsets) without requiring frame pointers
+	  in C code or objtool ORC table generation.
+
 config UNWINDER_FRAME_POINTER
 	bool "Frame pointer unwinder"
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b7e08519b8c1..70c3308653dd 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -208,7 +208,14 @@ endif
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
 #
+ifdef CONFIG_UNWINDER_DWARF_CFI
+KBUILD_CFLAGS += -fasynchronous-unwind-tables
+KBUILD_RUSTFLAGS += -Cforce-unwind-tables=y -Zuse-sync-unwind=n
+KBUILD_RUSTFLAGS += $(if $(call rustc-min-version,109800),,-Zllvm_module_flag=uwtable:u32:2:max)
+LDFLAGS_vmlinux += --eh-frame-hdr
+else
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
+endif
 
 # Avoid indirect branches in kernel to deal with Spectre
 ifdef CONFIG_MITIGATION_RETPOLINE
diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makefile
index 5e499cfb29b5..4e3ad26bfc04 100644
--- a/arch/x86/boot/startup/Makefile
+++ b/arch/x86/boot/startup/Makefile
@@ -7,6 +7,7 @@ KBUILD_CFLAGS		+= -D__DISABLE_EXPORTS -mcmodel=small -fPIC \
 			   $(DISABLE_LATENT_ENTROPY_PLUGIN) \
 			   -fno-stack-protector -D__NO_FORTIFY \
 			   -fno-jump-tables \
+			   -fno-unwind-tables -fno-asynchronous-unwind-tables \
 			   -include $(srctree)/include/linux/hidden.h
 
 # disable ftrace hooks and LTO
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
diff --git a/arch/x86/include/asm/module.h b/arch/x86/include/asm/module.h
index 3c2de4ce3b10..da990da59e2b 100644
--- a/arch/x86/include/asm/module.h
+++ b/arch/x86/include/asm/module.h
@@ -12,11 +12,16 @@ struct its_array {
 #endif
 };
 
+struct mod_dwarf_cfi_index;
+
 struct mod_arch_specific {
 #ifdef CONFIG_UNWINDER_ORC
 	unsigned int num_orcs;
 	int *orc_unwind_ip;
 	struct orc_entry *orc_unwind;
+#endif
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	struct mod_dwarf_cfi_index __rcu *dwarf_cfi_index;
 #endif
 	struct its_array its_pages;
 };
diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 7cede4dc21f0..49bf73193927 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -20,7 +20,7 @@ struct unwind_state {
 	struct llist_node *kr_cur;
 #endif
 	bool error;
-#if defined(CONFIG_UNWINDER_ORC)
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 	bool signal, full_regs;
 	unsigned long sp, bp, ip;
 	struct pt_regs *regs, *prev_regs;
@@ -64,7 +64,8 @@ void unwind_start(struct unwind_state *state, struct task_struct *task,
 	__unwind_start(state, task, regs, first_frame);
 }
 
-#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_FRAME_POINTER)
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI) || \
+	defined(CONFIG_UNWINDER_FRAME_POINTER)
 /*
  * If 'partial' returns true, only the iret frame registers are valid.
  */
@@ -75,7 +76,7 @@ static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state,
 		return NULL;
 
 	if (partial) {
-#ifdef CONFIG_UNWINDER_ORC
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 		*partial = !state->full_regs;
 #else
 		*partial = false;
@@ -92,7 +93,7 @@ static inline struct pt_regs *unwind_get_entry_regs(struct unwind_state *state,
 }
 #endif
 
-#ifdef CONFIG_UNWINDER_ORC
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 void unwind_init(void);
 void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
 			void *orc, size_t orc_size);
@@ -103,6 +104,12 @@ void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
 			void *orc, size_t orc_size) {}
 #endif
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+void unwind_module_cleanup(struct module *mod);
+#else
+static inline void unwind_module_cleanup(struct module *mod) {}
+#endif
+
 static inline
 unsigned long unwind_recover_rethook(struct unwind_state *state,
 				     unsigned long addr, unsigned long *addr_p)
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 31f46fd00527..117cf86617cb 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -18,6 +18,7 @@ CFLAGS_REMOVE_early_printk.o = -pg
 CFLAGS_REMOVE_head64.o = -pg
 CFLAGS_REMOVE_head32.o = -pg
 CFLAGS_REMOVE_rethook.o = -pg
+CFLAGS_REMOVE_unwind_dwarf.o = -pg
 endif
 
 KASAN_SANITIZE_head$(BITS).o				:= n
@@ -25,6 +26,7 @@ KASAN_SANITIZE_dumpstack.o				:= n
 KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
 KASAN_SANITIZE_stacktrace.o				:= n
 KASAN_SANITIZE_paravirt.o				:= n
+KASAN_SANITIZE_unwind_dwarf.o				:= n
 
 # With some compiler versions the generated code results in boot hangs, caused
 # by several compilation units. To be safe, disable all instrumentation.
@@ -41,6 +43,7 @@ KCOV_INSTRUMENT_stacktrace.o				:= n
 KCOV_INSTRUMENT_dumpstack.o				:= n
 KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
 KCOV_INSTRUMENT_unwind_orc.o				:= n
+KCOV_INSTRUMENT_unwind_dwarf.o				:= n
 KCOV_INSTRUMENT_unwind_frame.o				:= n
 KCOV_INSTRUMENT_unwind_guess.o				:= n
 
@@ -159,6 +162,7 @@ obj-$(CONFIG_SCHED_MC_PRIO)		+= itmt.o
 obj-$(CONFIG_X86_UMIP)			+= umip.o
 
 obj-$(CONFIG_UNWINDER_ORC)		+= unwind_orc.o
+obj-$(CONFIG_UNWINDER_DWARF_CFI)	+= unwind_dwarf.o
 obj-$(CONFIG_UNWINDER_FRAME_POINTER)	+= unwind_frame.o
 obj-$(CONFIG_UNWINDER_GUESS)		+= unwind_guess.o
 
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
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 33080ad889b7..9cfd60619acc 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -228,7 +228,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		    struct module *me)
 {
 	const Elf_Shdr *s, *alt = NULL,
-		*orc = NULL, *orc_ip = NULL,
+		*orc = NULL, *orc_ip = NULL, *eh_frame = NULL,
 		*retpolines = NULL, *returns = NULL, *ibt_endbr = NULL,
 		*calls = NULL, *cfi = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
@@ -240,6 +240,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 			orc = s;
 		if (!strcmp(".orc_unwind_ip", secstrings + s->sh_name))
 			orc_ip = s;
+		if (!strcmp(".eh_frame", secstrings + s->sh_name))
+			eh_frame = s;
 		if (!strcmp(".retpoline_sites", secstrings + s->sh_name))
 			retpolines = s;
 		if (!strcmp(".return_sites", secstrings + s->sh_name))
@@ -299,14 +301,19 @@ int module_finalize(const Elf_Ehdr *hdr,
 		apply_seal_endbr(iseg, iseg + ibt_endbr->sh_size);
 	}
 
-	if (orc && orc_ip)
+	if (IS_ENABLED(CONFIG_UNWINDER_ORC) && orc && orc_ip)
 		unwind_module_init(me, (void *)orc_ip->sh_addr, orc_ip->sh_size,
 				   (void *)orc->sh_addr, orc->sh_size);
+	if (IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) && eh_frame &&
+	    (eh_frame->sh_flags & SHF_ALLOC) && eh_frame->sh_addr)
+		unwind_module_init(me, /*orc_ip=*/NULL, /*orc_ip_size=*/0,
+				   (void *)eh_frame->sh_addr, eh_frame->sh_size);
 
 	return 0;
 }
 
 void module_arch_cleanup(struct module *mod)
 {
+	unwind_module_cleanup(mod);
 	its_free_mod(mod);
 }
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
diff --git a/arch/x86/kernel/unwind_dwarf.c b/arch/x86/kernel/unwind_dwarf.c
new file mode 100644
index 000000000000..e591321ed391
--- /dev/null
+++ b/arch/x86/kernel/unwind_dwarf.c
@@ -0,0 +1,663 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Minimal DWARF CFI kernel stack unwinder for x86-64.
+ *
+ * Unwinds kernel stacks using the link-time .eh_frame_hdr / .eh_frame tables
+ * and the strictly bounded Minimal DWARF CFA subset (matching SFrame's state
+ * model), with ENCODE_FRAME_POINTER handling entry/exception pt_regs frames.
+ */
+
+#define pr_fmt(fmt) "unwind_dwarf: " fmt
+
+#include <linux/bpf.h>
+#include <linux/export.h>
+#include <linux/ftrace.h>
+#include <linux/module.h>
+#include <linux/rcupdate.h>
+#include <linux/sched.h>
+#include <linux/sched/task_stack.h>
+#include <linux/unwind_dwarf_cfi.h>
+#include <asm/ptrace.h>
+#include <asm/sections.h>
+#include <asm/stacktrace.h>
+#include <asm/unwind.h>
+
+static bool dwarf_cfi_ready __ro_after_init;
+
+static const struct dwarf_cfi_arch x86_64_cfi_arch = {
+	.ws	= 8,
+	.sp_reg	= 7,	/* %rsp */
+	.fp_reg	= 6,	/* %rbp */
+	.ra_reg	= 16,	/* %rip */
+};
+
+/* Frame-pointer fallback row for BPF JIT frames */
+static const struct dwarf_cfi_row bpf_fp_row = {
+	.cfa_base	= DWARF_CFI_BASE_FP,
+	.cfa_off	= 16,
+	.fp_rule	= DWARF_CFI_RULE_OFFSET,
+	.fp_off		= -16,
+	.ra_rule	= DWARF_CFI_RULE_OFFSET,
+	.ra_off		= -8,
+};
+
+/* Hardcoded row for IP == 0 (NULL function pointer call crash) */
+static const struct dwarf_cfi_row null_call_row = {
+	.cfa_base	= DWARF_CFI_BASE_SP,
+	.cfa_off	= sizeof(long),
+	.fp_rule	= DWARF_CFI_RULE_SAME,
+	.ra_rule	= DWARF_CFI_RULE_OFFSET,
+	.ra_off		= -(s32)sizeof(long),
+};
+
+#ifdef CONFIG_MODULES
+/**
+ * unwind_module_init() - Build Minimal DWARF CFI index for a loadable module
+ * @mod: Module being loaded.
+ * @orc_ip: Unused under CONFIG_UNWINDER_DWARF_CFI (shared prototype with ORC).
+ * @orc_ip_size: Unused under CONFIG_UNWINDER_DWARF_CFI.
+ * @eh_frame: Pointer to the module's SHF_ALLOC .eh_frame section.
+ * @eh_frame_size: Size in bytes of @eh_frame.
+ *
+ * Scans and sorts the module's FDEs and publishes the resulting index to
+ * @mod->arch.dwarf_cfi_index for RCU-protected lockless lookups.
+ */
+void unwind_module_init(struct module *mod, void *orc_ip, size_t orc_ip_size,
+			void *eh_frame, size_t eh_frame_size)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = dwarf_cfi_mod_alloc(eh_frame, eh_frame_size, &x86_64_cfi_arch);
+	if (idx)
+		rcu_assign_pointer(mod->arch.dwarf_cfi_index, idx);
+}
+
+/**
+ * unwind_module_cleanup() - Unpublish and RCU-free a module's DWARF CFI index
+ * @mod: Module being unloaded or torn down on load failure.
+ */
+void unwind_module_cleanup(struct module *mod)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = rcu_replace_pointer(mod->arch.dwarf_cfi_index, /*ptr=*/NULL,
+				  /*c=*/true);
+	dwarf_cfi_mod_free_rcu(idx);
+}
+
+/**
+ * dwarf_cfi_module_find() - Evaluate Minimal DWARF CFI for a module text IP
+ * @ip: Kernel instruction pointer to look up (caller holds RCU read lock).
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Return: 0 on success, -ENOENT if @ip is not in a module with an FDE, or a
+ * negative errno on invalid FDE bytecode.
+ */
+static int dwarf_cfi_module_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	struct mod_dwarf_cfi_index *idx;
+	struct module *mod;
+
+	mod = __module_address(ip);
+	if (!mod)
+		return -ENOENT;
+
+	idx = rcu_dereference_raw(mod->arch.dwarf_cfi_index);
+	return dwarf_cfi_mod_eval(idx, ip, &x86_64_cfi_arch, row);
+}
+#else
+static int dwarf_cfi_module_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_MODULES */
+
+static int dwarf_cfi_find(unsigned long ip, struct dwarf_cfi_row *row);
+
+#ifdef CONFIG_DYNAMIC_FTRACE
+/**
+ * dwarf_cfi_ftrace_find() - Map dynamic ftrace trampolines to template CFI
+ * @ip: Instruction pointer potentially inside a dynamic ftrace ops trampoline.
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Dynamic ftrace trampolines are copied from ftrace_caller or
+ * ftrace_regs_caller templates at runtime and therefore have no static FDEs of
+ * their own; translate @ip to the corresponding offset in the template stub.
+ *
+ * Return: 0 on success, or -ENOENT if @ip is not in a dynamic trampoline.
+ */
+static int dwarf_cfi_ftrace_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	struct ftrace_ops *ops;
+	unsigned long tramp_addr;
+
+	ops = ftrace_ops_trampoline(ip);
+	if (!ops)
+		return -ENOENT;
+
+	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS)
+		tramp_addr = (unsigned long)ftrace_regs_caller;
+	else
+		tramp_addr = (unsigned long)ftrace_caller;
+
+	tramp_addr += ip - ops->trampoline;
+	if (ip == tramp_addr)
+		return -ENOENT;
+
+	return dwarf_cfi_find(tramp_addr, row);
+}
+#else
+static int dwarf_cfi_ftrace_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	return -ENOENT;
+}
+#endif
+
+/**
+ * dwarf_cfi_find() - Locate and evaluate the Minimal DWARF CFI row for @ip
+ * @ip: Kernel instruction pointer (caller holds RCU read lock).
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Checks NULL-call faults (ip == 0), core vmlinux .eh_frame_hdr, loadable
+ * modules, JITed BPF programs/trampolines with frame pointers, and dynamic
+ * ftrace trampolines.
+ *
+ * Return: 0 on success, -ENOENT if no unwind entry covers @ip, or a negative
+ * errno on malformed CFI data.
+ */
+static int dwarf_cfi_find(unsigned long ip, struct dwarf_cfi_row *row)
+{
+	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
+	int err;
+
+	if (ip == 0) {
+		*row = null_call_row;
+		return 0;
+	}
+
+	err = dwarf_cfi_unwind_eh_frame_hdr(__start_eh_frame_hdr, hdr_size,
+					    __start_eh_frame, __stop_eh_frame,
+					    ip, &x86_64_cfi_arch, row);
+	if (!err)
+		return 0;
+
+	err = dwarf_cfi_module_find(ip, row);
+	if (!err)
+		return 0;
+
+#ifdef CONFIG_BPF_JIT
+	if (bpf_has_frame_pointer(ip)) {
+		*row = bpf_fp_row;
+		return 0;
+	}
+#endif
+
+	return dwarf_cfi_ftrace_find(ip, row);
+}
+
+/**
+ * unwind_init() - Validate vmlinux .eh_frame_hdr and enable the CFI unwinder
+ *
+ * Verifies that the linker-generated .eh_frame_hdr version-1 table and
+ * .eh_frame section are present before marking the unwinder ready during early
+ * boot.
+ */
+void __init unwind_init(void)
+{
+	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
+	size_t eh_size = __stop_eh_frame - __start_eh_frame;
+
+	if (hdr_size < 12 || !eh_size || __start_eh_frame_hdr[0] != 1) {
+		pr_warn("Bad or missing .eh_frame_hdr table; disabling Minimal DWARF unwinder.\n");
+		return;
+	}
+
+	dwarf_cfi_ready = true;
+}
+
+/**
+ * unwind_get_return_address() - Return the current frame's kernel text IP
+ * @state: Current x86 unwind state.
+ *
+ * Return: Kernel text instruction pointer for @state, or 0 if unwinding is
+ * complete or @state->ip is outside kernel/module/BPF/ftrace text.
+ */
+unsigned long unwind_get_return_address(struct unwind_state *state)
+{
+	if (unwind_done(state))
+		return 0;
+
+	return __kernel_text_address(state->ip) ? state->ip : 0;
+}
+EXPORT_SYMBOL_GPL(unwind_get_return_address);
+
+/**
+ * unwind_get_return_address_ptr() - Return stack slot address holding @state's IP
+ * @state: Current x86 unwind state.
+ *
+ * Return: Pointer to the saved IP in @state->regs or at @state->sp - 8, or
+ * NULL if unwinding is complete.
+ */
+unsigned long *unwind_get_return_address_ptr(struct unwind_state *state)
+{
+	if (unwind_done(state))
+		return NULL;
+
+	if (state->regs)
+		return &state->regs->ip;
+
+	if (state->sp)
+		return (unsigned long *)state->sp - 1;
+
+	return NULL;
+}
+
+static bool stack_access_ok(struct unwind_state *state, unsigned long _addr,
+			    size_t len)
+{
+	struct stack_info *info = &state->stack_info;
+	void *addr = (void *)_addr;
+
+	if (on_stack(info, addr, len))
+		return true;
+
+	return !get_stack_info(addr, state->task, info, &state->stack_mask) &&
+	       on_stack(info, addr, len);
+}
+
+static bool deref_stack_reg(struct unwind_state *state, unsigned long addr,
+			    unsigned long *val)
+{
+	if (!stack_access_ok(state, addr, sizeof(long)))
+		return false;
+
+	*val = READ_ONCE_NOCHECK(*(unsigned long *)addr);
+	return true;
+}
+
+static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
+			     unsigned long *ip, unsigned long *sp,
+			     unsigned long *bp)
+{
+	struct pt_regs *regs = (struct pt_regs *)addr;
+
+	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
+		return false;
+
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
+	*bp = READ_ONCE_NOCHECK(regs->bp);
+
+	if (!user_mode(regs) &&
+	    !on_stack(&state->stack_info, (void *)*sp, sizeof(long))) {
+		struct stack_info next_info;
+
+		if (!get_stack_info((unsigned long *)*sp, state->task,
+				    &next_info, &state->stack_mask))
+			state->stack_info = next_info;
+	}
+	return true;
+}
+
+static struct pt_regs *decode_frame_pointer(unsigned long bp)
+{
+	if (!(bp & 0x1))
+		return NULL;
+
+	return (struct pt_regs *)(bp & ~0x1UL);
+}
+
+/**
+ * get_scratch_reg() - Read a transient DRAP CFA register from @state's pt_regs
+ * @state: Current x86 unwind state.
+ * @dwarf_reg: x86-64 DWARF register number used by DW_CFA_def_cfa_register.
+ * @val: Output register value.
+ *
+ * Compilers realignment prologues/epilogues (DRAP) briefly define the CFA in a
+ * caller-saved scratch register (%r10, %rcx, etc.) for 1-2 instructions. When
+ * unwinding directly from an interrupt/exception with full pt_regs, recover
+ * that register so asynchronous unwinding succeeds at every instruction.
+ *
+ * Return: true if @dwarf_reg was recovered from full pt_regs, false otherwise.
+ */
+static bool get_scratch_reg(struct unwind_state *state, u8 dwarf_reg,
+			    unsigned long *val)
+{
+	struct pt_regs *regs = state->full_regs ? state->regs : state->prev_regs;
+
+	if (!regs)
+		return false;
+
+	switch (dwarf_reg) {
+	case 0: /* %rax */
+		*val = READ_ONCE_NOCHECK(regs->ax);
+		return true;
+	case 1: /* %rdx */
+		*val = READ_ONCE_NOCHECK(regs->dx);
+		return true;
+	case 2: /* %rcx */
+		*val = READ_ONCE_NOCHECK(regs->cx);
+		return true;
+	case 5: /* %rdi */
+		*val = READ_ONCE_NOCHECK(regs->di);
+		return true;
+	case 10: /* %r10 */
+		*val = READ_ONCE_NOCHECK(regs->r10);
+		return true;
+	case 13: /* %r13 */
+		*val = READ_ONCE_NOCHECK(regs->r13);
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool in_entry_text(unsigned long ip)
+{
+	char *addr = (char *)ip;
+
+	return (addr >= __entry_text_start && addr < __entry_text_end) ||
+	       (void *)ip == ret_from_fork_asm;
+}
+
+/**
+ * dwarf_recover_ret_addr() - Recover ftrace_graph and rethook return addresses
+ * @state: Current x86 unwind state.
+ * @addr: Raw return address read from the stack or pt_regs.
+ * @addr_p: Stack slot address where @addr was stored.
+ *
+ * Handles both single hooks and stacked hooks in either installation order
+ * (fgraph->rethook via unwind_recover_ret_addr(), or rethook->fgraph via a
+ * follow-up ftrace_graph_ret_addr() pass).
+ *
+ * Return: Original caller instruction pointer (or 0 if rethook lookup failed).
+ */
+static unsigned long dwarf_recover_ret_addr(struct unwind_state *state,
+					    unsigned long addr,
+					    unsigned long *addr_p)
+{
+	unsigned long ret;
+
+	ret = unwind_recover_ret_addr(state, addr, addr_p);
+	return ftrace_graph_ret_addr(state->task, &state->graph_idx,
+				     ret, addr_p);
+}
+
+/**
+ * unwind_next_frame() - Advance @state to the next outer x86-64 kernel frame
+ * @state: Current x86 unwind state.
+ *
+ * Evaluates Minimal DWARF CFI for @state->ip, handles top-of-stack task
+ * pt_regs, arch_rethook_trampoline entry, %rsp-verified ENCODE_FRAME_POINTER
+ * entry/exception pt_regs transitions, and call_on_stack() IRQ stack pivots.
+ *
+ * Return: true if a valid outer frame was unwound, or false when the bottom of
+ * the stack is reached or an error terminates the walk.
+ */
+bool unwind_next_frame(struct unwind_state *state)
+{
+	enum stack_type prev_type = state->stack_info.type;
+	unsigned long prev_sp = state->sp;
+	struct dwarf_cfi_row row;
+	unsigned long lookup_ip, cfa, ip_p;
+	struct pt_regs *regs;
+	int err;
+
+	if (unwind_done(state))
+		return false;
+
+	/* Keep module .eh_frame tables alive across lookup and evaluation */
+	guard(rcu)();
+
+	if (state->regs && user_mode(state->regs))
+		goto the_end;
+
+	/*
+	 * Check if we have reached the top-of-task-stack pt_regs boundary
+	 * (syscall entry, newly forked thread, kthread, or idle thread).
+	 */
+	regs = task_pt_regs(state->task);
+	if ((void *)state->ip == ret_from_fork_asm ||
+	    state->sp == (unsigned long)regs) {
+		if (!user_mode(regs))
+			goto the_end;
+
+		if (!deref_stack_regs(state, (unsigned long)regs,
+				      &state->ip, &state->sp, &state->bp))
+			goto err;
+		state->regs = regs;
+		state->prev_regs = NULL;
+		state->full_regs = true;
+		state->signal = true;
+		return true;
+	}
+
+	if (!state->ip && !state->signal)
+		goto err;
+
+	lookup_ip = state->signal ? state->ip : state->ip - 1;
+	err = dwarf_cfi_find(lookup_ip, &row);
+	if (err) {
+		/*
+		 * Handle an interrupt/unwind starting right at the entry of
+		 * arch_rethook_trampoline() before pushq $arch_rethook_trampoline.
+		 */
+		if (state->signal && is_rethook_trampoline(state->ip)) {
+			state->ip = dwarf_recover_ret_addr(state, state->ip,
+					(unsigned long *)(state->sp - sizeof(long)));
+			if (!state->ip || is_rethook_trampoline(state->ip))
+				goto err;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+			if (state->ip == (unsigned long)return_to_handler)
+				goto err;
+#endif
+			state->regs = NULL;
+			state->prev_regs = NULL;
+			state->full_regs = false;
+			state->signal = true;
+			return true;
+		}
+
+		/*
+		 * Entry / interrupt / exception .S stubs without .eh_frame
+		 * encode a pointer to struct pt_regs in %rbp via
+		 * ENCODE_FRAME_POINTER (setting bit 0).  Verify that %rsp has
+		 * actually reached that pt_regs frame (or the 8-byte return
+		 * slot immediately below it in error_entry / paranoid_entry)
+		 * so a stale outer encoded %rbp never skips intermediate frames.
+		 */
+		regs = decode_frame_pointer(state->bp);
+		if (regs &&
+		    (state->sp == (unsigned long)regs ||
+		     (in_entry_text(state->ip) &&
+		      state->sp == (unsigned long)regs - sizeof(long)))) {
+			unsigned long orig_ip;
+
+			if (!deref_stack_regs(state, (unsigned long)regs,
+					      &orig_ip, &state->sp, &state->bp))
+				goto err;
+			state->ip = dwarf_recover_ret_addr(state, orig_ip,
+					(unsigned long *)(state->sp - sizeof(long)));
+			if (is_rethook_trampoline(orig_ip) &&
+			    (!state->ip || is_rethook_trampoline(state->ip)))
+				goto err;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+			if (is_rethook_trampoline(orig_ip) &&
+			    state->ip == (unsigned long)return_to_handler)
+				goto err;
+#endif
+			state->regs = regs;
+			state->prev_regs = NULL;
+			state->full_regs = true;
+			state->signal = true;
+			goto check_progress;
+		}
+
+		/*
+		 * Unencoded entry assembly (pre-ENCODE_FRAME_POINTER or
+		 * post-POP_REGS) or an unaligned/encoded %rbp cannot be
+		 * unwound via a frame-pointer guess.
+		 */
+		if (in_entry_text(state->ip) || (state->bp & (sizeof(long) - 1)))
+			goto err;
+
+		/* Fallback to frame-pointer guess and mark unreliable */
+		row = bpf_fp_row;
+		state->error = true;
+	}
+
+	if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED)
+		goto the_end;
+
+	if (row.ra_rule != DWARF_CFI_RULE_OFFSET)
+		goto err;
+
+	switch (row.cfa_base) {
+	case DWARF_CFI_BASE_SP: {
+		unsigned long sp_base = state->sp;
+
+		/*
+		 * call_on_stack() stores the pre-switch task-stack %rsp at the
+		 * top slot of the per-CPU IRQ stack (info.end - 1) and pivots
+		 * %rsp there before invoking the IRQ/softirq handler.
+		 */
+		if (state->stack_info.type == STACK_TYPE_IRQ &&
+		    state->sp == (unsigned long)(state->stack_info.end - 1)) {
+			if (!deref_stack_reg(state, state->sp, &sp_base))
+				goto err;
+		}
+		cfa = sp_base + row.cfa_off;
+		break;
+	}
+	case DWARF_CFI_BASE_FP:
+		cfa = state->bp + row.cfa_off;
+		break;
+	case DWARF_CFI_BASE_FP_INDIRECT:
+		if (!deref_stack_reg(state, state->bp + row.cfa_off, &cfa))
+			goto err;
+		break;
+	case DWARF_CFI_BASE_REG:
+		if (!get_scratch_reg(state, row.cfa_reg, &cfa))
+			goto err;
+		cfa += row.cfa_off;
+		break;
+	default:
+		goto err;
+	}
+
+	ip_p = cfa + row.ra_off;
+	if (!deref_stack_reg(state, ip_p, &state->ip))
+		goto err;
+
+	state->ip = dwarf_recover_ret_addr(state, state->ip,
+					   (unsigned long *)ip_p);
+	if (!state->ip || is_rethook_trampoline(state->ip))
+		goto err;
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (state->ip == (unsigned long)return_to_handler)
+		goto err;
+#endif
+
+	if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
+		if (!deref_stack_reg(state, cfa + row.fp_off, &state->bp))
+			goto err;
+	} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
+		if (!deref_stack_reg(state, state->bp + row.fp_off, &state->bp))
+			goto err;
+	}
+
+	state->sp = cfa;
+	state->regs = NULL;
+	state->prev_regs = NULL;
+	state->full_regs = false;
+	state->signal = row.signal;
+
+check_progress:
+	if (state->stack_info.type == prev_type &&
+	    on_stack(&state->stack_info, (void *)state->sp, sizeof(long)) &&
+	    state->sp <= prev_sp)
+		goto err;
+
+	return true;
+
+err:
+	state->error = true;
+the_end:
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+	return false;
+}
+EXPORT_SYMBOL_GPL(unwind_next_frame);
+
+/**
+ * __unwind_start() - Initialize an x86-64 Minimal DWARF CFI kernel stack walk
+ * @state: Unwind state structure to initialize.
+ * @task: Task whose kernel stack is being unwound.
+ * @regs: Optional starting register state (e.g. from an interrupt/exception).
+ * @first_frame: Stack pointer threshold to skip frames below the caller.
+ */
+void __unwind_start(struct unwind_state *state, struct task_struct *task,
+		    struct pt_regs *regs, unsigned long *first_frame)
+{
+	memset(state, 0, sizeof(*state));
+	state->task = task;
+
+	if (!dwarf_cfi_ready)
+		goto err;
+
+	if (task_on_another_cpu(task))
+		goto err;
+
+	if (regs) {
+		if (user_mode(regs))
+			goto the_end;
+
+		state->ip = regs->ip;
+		state->sp = regs->sp;
+		state->bp = regs->bp;
+		state->regs = regs;
+		state->full_regs = true;
+		state->signal = true;
+	} else if (task == current) {
+		asm volatile("lea (%%rip), %0\n\t"
+			     "mov %%rsp, %1\n\t"
+			     "mov %%rbp, %2\n\t"
+			     : "=r" (state->ip), "=r" (state->sp),
+			       "=r" (state->bp));
+		state->signal = true;
+	} else {
+		struct inactive_task_frame *frame = (void *)task->thread.sp;
+
+		state->sp = task->thread.sp + sizeof(*frame);
+		state->bp = READ_ONCE_NOCHECK(frame->bp);
+		state->ip = READ_ONCE_NOCHECK(frame->ret_addr);
+		state->signal = (void *)state->ip == ret_from_fork_asm;
+	}
+
+	if (get_stack_info((unsigned long *)state->sp, state->task,
+			   &state->stack_info, &state->stack_mask)) {
+		void *next_page = (void *)PAGE_ALIGN((unsigned long)state->sp);
+
+		state->error = true;
+		if (get_stack_info(next_page, state->task, &state->stack_info,
+				   &state->stack_mask))
+			return;
+	}
+
+	if (regs) {
+		unwind_next_frame(state);
+		return;
+	}
+
+	while (!unwind_done(state) &&
+	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
+		state->sp <= (unsigned long)first_frame))
+		unwind_next_frame(state);
+
+	return;
+
+err:
+	state->error = true;
+the_end:
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+}
+EXPORT_SYMBOL_GPL(__unwind_start);
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 2438b89a4620..20f0fa33ea9c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -21,6 +21,22 @@
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	16
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+#define ARCH_RODATA_SECTIONS						\
+	. = ALIGN(4);							\
+	.eh_frame_hdr : AT(ADDR(.eh_frame_hdr) - LOAD_OFFSET) {		\
+		__start_eh_frame_hdr = .;				\
+		*(.eh_frame_hdr)					\
+		__stop_eh_frame_hdr = .;				\
+	}								\
+	. = ALIGN(8);							\
+	.eh_frame : AT(ADDR(.eh_frame) - LOAD_OFFSET) {			\
+		__start_eh_frame = .;					\
+		*(.eh_frame) *(.eh_frame.*)				\
+		__stop_eh_frame = .;					\
+	}
+#endif
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 4c3e09d98131..84217ce6a283 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -5122,11 +5122,13 @@ void bpf_jit_free(struct bpf_prog *prog)
 
 bool bpf_jit_supports_exceptions(void)
 {
-	/* We unwind through both kernel frames (starting from within bpf_throw
-	 * call) and BPF frames. Therefore we require ORC unwinder to be enabled
-	 * to walk kernel frames and reach BPF frames in the stack trace.
+	/*
+	 * We unwind through both kernel frames (starting from within bpf_throw
+	 * call) and BPF frames. Therefore we require ORC or Minimal DWARF CFI
+	 * unwinder to be enabled to walk kernel frames and reach BPF frames.
 	 */
-	return IS_ENABLED(CONFIG_UNWINDER_ORC);
+	return IS_ENABLED(CONFIG_UNWINDER_ORC) ||
+	       IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI);
 }
 
 bool bpf_jit_supports_private_stack(void)
@@ -5136,7 +5138,7 @@ bool bpf_jit_supports_private_stack(void)
 
 void arch_bpf_stack_walk(bool (*consume_fn)(void *cookie, u64 ip, u64 sp, u64 bp), void *cookie)
 {
-#if defined(CONFIG_UNWINDER_ORC)
+#if defined(CONFIG_UNWINDER_ORC) || defined(CONFIG_UNWINDER_DWARF_CFI)
 	struct unwind_state state;
 	unsigned long addr;
 
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index fad91ea28fe7..ef3ae80f5c06 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -35,6 +35,7 @@ PURGATORY_CFLAGS := -mcmodel=small -ffreestanding -fno-zero-initialized-in-bss -
 PURGATORY_CFLAGS += -fpic -fvisibility=hidden
 PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector
+PURGATORY_CFLAGS += -fno-unwind-tables -fno-asynchronous-unwind-tables
 PURGATORY_CFLAGS += -D__DISABLE_EXPORTS -D__NO_FORTIFY
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index bbab12b8eb4b..d62dabfdc1c3 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -19,7 +19,8 @@ cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
 				     $(PADDING_CFLAGS), $(cflags-y))
 cflags-$(CONFIG_X86_32)		+= -march=i386
 cflags-$(CONFIG_X86_64)		+= -mcmodel=small
-cflags-$(CONFIG_X86)		+= -fPIC
+cflags-$(CONFIG_X86)		+= -fPIC -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 # Nothing enables IBT while the stub runs, so ENDBR would only take space.
 cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3eb732942d69..1bde7a2a19d0 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -472,6 +472,10 @@
 #endif
 #endif
 
+#ifndef ARCH_RODATA_SECTIONS
+#define ARCH_RODATA_SECTIONS
+#endif
+
 /*
  * Read only Data
  */
@@ -554,6 +558,7 @@
 	RO_EXCEPTION_TABLE						\
 	NOTES								\
 	BTF								\
+	ARCH_RODATA_SECTIONS						\
 									\
 	. = ALIGN((align));						\
 	__end_rodata = .;
-- 
2.56.1.750.gf70dc682cf-goog

