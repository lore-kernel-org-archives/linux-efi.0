Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391961;
	b=SKhOKzQMPnZx1A/B+FusZYVNpe2ZguDa6pc9oxabEUzX1O4A+BiqT+D1qO800U2lnwoo
	 dKiOWIC9wxYmJps2D/J7KjDPpr66Wf/siLb8ftKW4Cyehux+my49iZHLT567KZRR+qD8T
	 nrDat33CzsLuf97Tk0Gd/kySCSYEtwGba2KTHcaGqzxB3aFHfQItXvBYmcQlA5W231a6N
	 MOglM91+dsZIqRnLsac8Qno+1rqfYvidgYdmNuFceRErefUj+k9HxwfEF9Sszq7OihDiA
	 zM9Vm9z0Rikr+KYUfbboGF7yGB2e+G8Gc/ymesLkzyhOxoC62Nk5GuHU/RNwD+AQb/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=7M8NPSyIu5zyrKo+IM6G4ntT9OQ7yZBQQTdskzVMyBM=;
	b=3v7lBGctyJAKGys9D8pfHrFu7x8d7e/RWd87H/UzfYCxdCThStQ2CeF63gp3GxaBY7JZ
	 V0z1CPJPxuQndBo/XHGs7CDY6oeTuJXD5GyyrbinbgHh9V0hGiETZ6HyaVCzQgKkHshmU
	 mqSFJ7exkYpqVOYFh63OOTDDgbzn0WuDZ8AcPrYI869lYpeD/1Zpq52x28SKiwWBT1O0d
	 pVOM4rY24pr8YRjffSedoGbtZSVRdfZRIPBIt2+CAkOijgSCilCezwlV+TFg+alWjrhiR
	 Oiqxp4PS7120vB3+XyHhXQ8Xc11kFNlAKSK/FOGIZoL0emU1Fp9U018NgCkO7mTCXnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=l4ptuOO6;
	arc=none smtp.remote-ip=209.85.214.200
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A7606A32C
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:59:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E08A7606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=l4ptuOO6
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2f0651873abso12536285ad.2
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391959; x=1795996759; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7M8NPSyIu5zyrKo+IM6G4ntT9OQ7yZBQQTdskzVMyBM=;
        b=l4ptuOO6+cSg9ZP/UeGF6VNshSMDKoGHOCSnuIPxBMa966FS/4DGGg9c11L7Usk6E4
         2eeVMldUtGh61IZc5Xku52JVK193kwLTD/9GPxVuR7A3GTwrTt+lPNjk9LGfT/gBsWDn
         STGCza0E/ZBIB83ujJ6/G1QGl4W4RbHnZu6UPipzw9fKTo5DmcQtJ4uDMKPa/G2koH8z
         M90uvM5fbAQdlEnFGWRr8PM00Awdug/cA2UvHKWyjSsx4EhhVvJbV353Y3hLgDvyezAz
         SoUnbKqrAHzJAT1zXKBjclh4kav0jbMmRfnxYZa4KNdDw4q6LGcBXuuHzjxuJnycIipr
         SqBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391959; x=1795996759;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7M8NPSyIu5zyrKo+IM6G4ntT9OQ7yZBQQTdskzVMyBM=;
        b=Yz6FtSG80tpktOpxDrpg394R0TS6aNjRTFE1+JsrjmHvdC39EGpj3FI9u96T3/2Isf
         KCgd1B8iwGF0fg2c9/xWipQBGS77Tizi9beOVzjElFxZw/fH9zNkUoyEFNc0kOVHZb5Y
         lfE8Zau9iQ0VshrjVXO65D0FJM8kwm2DMbTaonanAkRGzJI1oG1XVZnNIpPsxO/9XIzJ
         HO0fkFYzfb0MdQ0+j5JA5PC6X6n7LrPSBUtujwDFMch0jaPu1cK4c0cfzZJIFfkFpeEu
         yxjAjuQRuUxoLjFoZrlqxH1pO2kQQyz7R4CWAHtV4qBjjqoTBl0Y3CNKTHAz3Mzu3Sbx
         QFfw==
X-Forwarded-Encrypted: i=1; AL+hErGcBxbNOQY2nfyJR2lrsRlL74wRC/QkdopNls6gzJtXufhV9qHfCstcciImjm1TIuNdjih6jh7QY98=@vger.kernel.org
X-Gm-Message-State: APuU4Z8Gix+CGlH2svzRO7QRGxHoIk44Up3jyN8Y12anXc2mEi+BnmKc
	7MSNYfAZY0ow3QIcqwiMH9YS+irAqCNEYnFPAfWZmOaLfyxOW3vklY+lgcrODzzh+rrzw/6M98M
	MdKU+QBkI0g==
X-Received: from pjbbk11.prod.google.com ([2002:a17:90b:80b:b0:3b4:1df5:9b9])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b:b0:3b4:1265:740b
 with SMTP id 98e67ed59e1d1-3b41c9cf6efmr7890602a91.28.1795391958939; Sun, 22
 Nov 2026 15:59:18 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:55 -0800
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
Message-ID: <20261122235757.3456048-10-irogers@google.com>
Subject: [RFC PATCH v1 09/11] riscv/unwind: Add Minimal DWARF CFI kernel unwinder
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

Add CONFIG_UNWINDER_DWARF_CFI for 64-bit MMU-enabled RISC-V kernels in
arch/riscv/kernel/stacktrace.c, enabling frame-pointer-free kernel stack
unwinding and HAVE_RELIABLE_STACKTRACE (arch_stack_walk_reliable()):

 - Gate ARCH_WANT_FRAME_POINTERS and FRAME_POINTER on
   !UNWINDER_DWARF_CFI, build kernel C and Rust objects with
   asynchronous unwind tables and -fomit-frame-pointer, link vmlinux
   with --eh-frame-hdr, and suppress unwind tables in purgatory and the
   EFI libstub.
 - Index SHF_ALLOC loadable module .eh_frame sections via
   dwarf_cfi_mod_alloc() and dwarf_cfi_mod_free_rcu() in
   arch/riscv/kernel/module.c.
 - Annotate return_to_handler() and arch_rethook_trampoline() with
   .cfi_* directives, key rethook shadow stacks on entry SP (CFA) rather
   than s0, and implement walk_stackframe_cfi(),
   arch_stack_walk_reliable(), and bounds-checked
   riscv_unwind_perf_caller_regs() across task, IRQ, and overflow
   stacks, supporting RVC 16-bit call sites (pc - 2), ftrace_caller /
   return_to_handler / rethook recovery, BPF JIT and trampoline frame
   records, handle_exception / ret_from_fork_asm / head.S root
   terminations, and call_on_irq_stack() transitions.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/riscv/Kconfig                            |   5 +-
 arch/riscv/Kconfig.debug                      |  16 +
 arch/riscv/Makefile                           |  15 +-
 arch/riscv/include/asm/module.h               |  22 +
 arch/riscv/include/asm/perf_event.h           |  15 +
 arch/riscv/include/asm/stacktrace.h           |  11 +
 arch/riscv/kernel/Makefile                    |   4 +
 arch/riscv/kernel/entry.S                     |   2 +
 arch/riscv/kernel/mcount-dyn.S                |   6 +-
 arch/riscv/kernel/mcount.S                    |  34 +-
 arch/riscv/kernel/module.c                    |   9 +
 arch/riscv/kernel/probes/rethook.c            |  13 +-
 arch/riscv/kernel/probes/rethook_trampoline.S |  30 +
 arch/riscv/kernel/stacktrace.c                | 732 +++++++++++++++++-
 arch/riscv/kernel/vmlinux.lds.S               |  13 +
 arch/riscv/purgatory/Makefile                 |   3 +-
 drivers/firmware/efi/libstub/Makefile         |   4 +-
 17 files changed, 919 insertions(+), 15 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 84b61c755db3..14d64a3fa33c 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -83,7 +83,7 @@ config RISCV
 	select ARCH_USES_CFI_TRAPS if CFI
 	select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH if MMU
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT if MMU
-	select ARCH_WANT_FRAME_POINTERS
+	select ARCH_WANT_FRAME_POINTERS if !UNWINDER_DWARF_CFI
 	select ARCH_WANT_GENERAL_HUGETLB if !RISCV_ISA_SVNAPOT
 	select ARCH_WANT_HUGE_PMD_SHARE if 64BIT
 	select ARCH_WANT_LD_ORPHAN_WARN
@@ -101,7 +101,7 @@ config RISCV
 	select CPU_PM if CPU_IDLE || HIBERNATION || SUSPEND
 	select DYNAMIC_FTRACE if FUNCTION_TRACER
 	select EDAC_SUPPORT
-	select FRAME_POINTER if PERF_EVENTS || (FUNCTION_TRACER && !DYNAMIC_FTRACE)
+	select FRAME_POINTER if !UNWINDER_DWARF_CFI && (PERF_EVENTS || (FUNCTION_TRACER && !DYNAMIC_FTRACE))
 	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY if DYNAMIC_FTRACE
 	select FUNCTION_ALIGNMENT_8B if DYNAMIC_FTRACE_WITH_CALL_OPS
 	select GENERIC_ARCH_TOPOLOGY
@@ -195,6 +195,7 @@ config RISCV
 	select HAVE_PERF_USER_STACK_DUMP
 	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
 	select HAVE_REGS_AND_STACK_ACCESS_API
+	select HAVE_RELIABLE_STACKTRACE if UNWINDER_DWARF_CFI
 	select HAVE_RETHOOK
 	select HAVE_RSEQ
 	select HAVE_RUST if RUSTC_SUPPORTS_RISCV && CC_IS_CLANG
diff --git a/arch/riscv/Kconfig.debug b/arch/riscv/Kconfig.debug
index eafe17ebf710..afc8be5ec97f 100644
--- a/arch/riscv/Kconfig.debug
+++ b/arch/riscv/Kconfig.debug
@@ -1 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+config UNWINDER_DWARF_CFI
+	bool "Minimal DWARF CFI kernel unwinder"
+	depends on 64BIT && MMU
+	depends on (!FUNCTION_TRACER || DYNAMIC_FTRACE_WITH_ARGS) && !SHADOW_CALL_STACK
+	select HAVE_MOD_ARCH_SPECIFIC if MODULES
+	select UNWIND_DWARF_CFI
+	select UNWIND_TABLES
+	help
+	  This option enables the Minimal DWARF Call Frame Information (CFI)
+	  unwinder for kernel stack traces on 64-bit RISC-V.  It interprets a
+	  strictly bounded subset of compiler-generated .eh_frame /
+	  .eh_frame_hdr tables matching SFrame's stack state model without
+	  requiring frame pointers.
+
 source "arch/riscv/kernel/tests/Kconfig.debug"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 44f5a439741a..ffa8842e7959 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -7,6 +7,9 @@
 #
 
 LDFLAGS_vmlinux := -z norelro
+ifeq ($(CONFIG_UNWINDER_DWARF_CFI),y)
+	LDFLAGS_vmlinux += --eh-frame-hdr
+endif
 ifeq ($(CONFIG_RELOCATABLE),y)
 	LDFLAGS_vmlinux += -shared -Bsymbolic -z notext
 	KBUILD_CFLAGS += -fPIE
@@ -96,8 +99,18 @@ ifeq ($(CONFIG_CMODEL_MEDANY),y)
 	KBUILD_CFLAGS += -mcmodel=medany
 endif
 
-# Avoid generating .eh_frame sections.
+# Avoid generating .eh_frame sections unless runtime unwind tables are enabled.
+ifeq ($(CONFIG_UNWIND_TABLES),y)
+KBUILD_CFLAGS += -fasynchronous-unwind-tables
+KBUILD_AFLAGS += -fasynchronous-unwind-tables
+ifeq ($(CONFIG_UNWINDER_DWARF_CFI),y)
+KBUILD_CFLAGS += -fomit-frame-pointer
+KBUILD_RUSTFLAGS += -Cforce-unwind-tables=y -Zuse-sync-unwind=n
+KBUILD_RUSTFLAGS += $(if $(call rustc-min-version,109800),,-Zllvm_module_flag=uwtable:u32:2:max)
+endif
+else
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
+endif
 
 # The RISC-V attributes frequently cause compatibility issues and provide no
 # information, so just turn them off.
diff --git a/arch/riscv/include/asm/module.h b/arch/riscv/include/asm/module.h
index 0f3baaa6a9a8..ff783889774b 100644
--- a/arch/riscv/include/asm/module.h
+++ b/arch/riscv/include/asm/module.h
@@ -11,18 +11,40 @@ struct module;
 unsigned long module_emit_got_entry(struct module *mod, unsigned long val);
 unsigned long module_emit_plt_entry(struct module *mod, unsigned long val);
 
+struct mod_dwarf_cfi_index;
+
 #ifdef CONFIG_MODULE_SECTIONS
 struct mod_section {
 	Elf_Shdr *shdr;
 	int num_entries;
 	int max_entries;
 };
+#endif
 
+#if defined(CONFIG_MODULE_SECTIONS) || defined(CONFIG_UNWINDER_DWARF_CFI)
 struct mod_arch_specific {
+#ifdef CONFIG_MODULE_SECTIONS
 	struct mod_section got;
 	struct mod_section plt;
 	struct mod_section got_plt;
+#endif
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	struct mod_dwarf_cfi_index __rcu *dwarf_cfi_index;
+#endif
 };
+#endif
+
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+void riscv_unwind_module_init(struct module *mod, void *eh_frame,
+			      size_t eh_frame_size);
+void riscv_unwind_module_cleanup(struct module *mod);
+#else
+static inline void riscv_unwind_module_init(struct module *mod, void *eh_frame,
+					    size_t eh_frame_size) {}
+static inline void riscv_unwind_module_cleanup(struct module *mod) {}
+#endif
+
+#ifdef CONFIG_MODULE_SECTIONS
 
 struct got_entry {
 	unsigned long symbol_addr;	/* the real variable address */
diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
index bcc928fd3785..cfe95b9106e5 100644
--- a/arch/riscv/include/asm/perf_event.h
+++ b/arch/riscv/include/asm/perf_event.h
@@ -12,6 +12,20 @@
 #include <linux/perf_event.h>
 #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+void riscv_unwind_perf_caller_regs(struct pt_regs *regs, unsigned long pc,
+				   unsigned long caller_ip, unsigned long sp,
+				   unsigned long fp);
+
+#define perf_arch_fetch_caller_regs(regs, __ip) do {			\
+	unsigned long __here_pc, __here_fp;				\
+	asm volatile("1: auipc %0, 0\n\t"				\
+		     "mv %1, s0"					\
+		     : "=r" (__here_pc), "=r" (__here_fp));		\
+	riscv_unwind_perf_caller_regs((regs), __here_pc, (__ip),	\
+				      current_stack_pointer, __here_fp);\
+} while (0)
+#else
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->epc = (__ip); \
 	(regs)->s0 = (unsigned long) __builtin_frame_address(0); \
@@ -19,5 +33,6 @@
 	(regs)->status = SR_PP; \
 }
 #endif
+#endif
 
 #endif /* _ASM_RISCV_PERF_EVENT_H */
diff --git a/arch/riscv/include/asm/stacktrace.h b/arch/riscv/include/asm/stacktrace.h
index b1495a7e06ce..5a7b77367041 100644
--- a/arch/riscv/include/asm/stacktrace.h
+++ b/arch/riscv/include/asm/stacktrace.h
@@ -15,6 +15,17 @@ extern void notrace walk_stackframe(struct task_struct *task, struct pt_regs *re
 				    bool (*fn)(void *, unsigned long), void *arg);
 extern void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
 			   const char *loglvl);
+extern char _start[];
+asmlinkage void ret_from_fork_kernel_asm(void);
+asmlinkage void ret_from_fork_user_asm(void);
+extern unsigned long ret_from_fork_asm_end;
+#ifdef CONFIG_IRQ_STACKS
+extern unsigned long call_on_irq_stack_end;
+#endif
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_ARGS
+void ftrace_caller_saved(void);
+void ftrace_caller_restore(void);
+#endif
 
 static inline bool on_thread_stack(void)
 {
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f54c336bf547..f2e1f342e3d7 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -42,8 +42,12 @@ CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_stacktrace.o = $(CC_FLAGS_FTRACE)
 endif
 
+KASAN_SANITIZE_stacktrace.o := n
+KCOV_INSTRUMENT_stacktrace.o := n
+
 always-$(KBUILD_BUILTIN) += vmlinux.lds
 
 obj-y	+= head.o
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
 
diff --git a/arch/riscv/kernel/module.c b/arch/riscv/kernel/module.c
index 1961135689db..93092b17b53a 100644
--- a/arch/riscv/kernel/module.c
+++ b/arch/riscv/kernel/module.c
@@ -902,5 +902,14 @@ int module_finalize(const Elf_Ehdr *hdr,
 	if (s)
 		apply_module_alternatives((void *)s->sh_addr, s->sh_size);
 
+	s = find_section(hdr, sechdrs, ".eh_frame");
+	if (s && (s->sh_flags & SHF_ALLOC))
+		riscv_unwind_module_init(me, (void *)s->sh_addr, s->sh_size);
+
 	return 0;
 }
+
+void module_arch_cleanup(struct module *mod)
+{
+	riscv_unwind_module_cleanup(mod);
+}
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
index c3aa8d8cf5af..50c68105c76b 100644
--- a/arch/riscv/kernel/probes/rethook_trampoline.S
+++ b/arch/riscv/kernel/probes/rethook_trampoline.S
@@ -78,9 +78,27 @@
 	REG_L x31, PT_T6(sp)
 	.endm
 
+/*
+ * Under CONFIG_UNWINDER_DWARF_CFI, PT_EPC(sp) is seeded with
+ * &arch_rethook_trampoline before rethook_trampoline_handler() overwrites
+ * regs->epc with the restored caller PC prior to running rethook handlers,
+ * enabling reliable CFI unwinding across kretprobe and fprobe return hooks.
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
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index c7555447149b..05f846c14787 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -6,16 +6,22 @@
 
 #include <linux/export.h>
 #include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/perf_event.h>
+#include <linux/rcupdate.h>
+#include <linux/rethook.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 #include <linux/ftrace.h>
+#include <linux/unwind_dwarf_cfi.h>
 
+#include <asm/irq_stack.h>
+#include <asm/module.h>
+#include <asm/sections.h>
 #include <asm/stacktrace.h>
 
-#ifdef CONFIG_FRAME_POINTER
-
 /*
  * This disables KASAN checking when reading a value from another task's stack,
  * since the other task could be running on another CPU and could have poisoned
@@ -35,6 +41,726 @@
 extern asmlinkage void handle_exception(void);
 extern unsigned long ret_from_exception_end;
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+
+static const struct dwarf_cfi_arch riscv_cfi_arch = {
+	.ws	= sizeof(unsigned long),
+	.sp_reg	= 2,	/* sp (x2) */
+	.fp_reg	= 8,	/* s0/fp (x8) */
+	.ra_reg	= 1,	/* ra (x1) */
+};
+
+#ifdef CONFIG_MODULES
+/**
+ * riscv_unwind_module_init() - Build Minimal DWARF CFI index for a module
+ * @mod: Module being loaded.
+ * @eh_frame: Pointer to the module's SHF_ALLOC .eh_frame section.
+ * @eh_frame_size: Size in bytes of @eh_frame.
+ *
+ * Scans and sorts the module's FDEs and publishes the index to
+ * @mod->arch.dwarf_cfi_index for RCU-protected lockless unwinding.
+ */
+void riscv_unwind_module_init(struct module *mod, void *eh_frame,
+			      size_t eh_frame_size)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = dwarf_cfi_mod_alloc(eh_frame, eh_frame_size, &riscv_cfi_arch);
+	if (idx)
+		rcu_assign_pointer(mod->arch.dwarf_cfi_index, idx);
+}
+
+/**
+ * riscv_unwind_module_cleanup() - Unpublish and RCU-free module DWARF CFI index
+ * @mod: Module being unloaded or cleaned up after a failed load.
+ */
+void riscv_unwind_module_cleanup(struct module *mod)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = rcu_replace_pointer(mod->arch.dwarf_cfi_index, /*ptr=*/NULL,
+				  /*c=*/true);
+	dwarf_cfi_mod_free_rcu(idx);
+}
+
+/**
+ * riscv_dwarf_cfi_module_find() - Look up Minimal DWARF CFI in loadable modules
+ * @pc: Kernel instruction pointer to evaluate.
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Uses rcu_read_lock_sched_notrace() and rcu_dereference_raw() so lookups are
+ * safe inside noinstr stack walks and NMI contexts.
+ *
+ * Return: 0 on success, -ENOENT if @pc is not in a module FDE, or a negative
+ * errno on invalid FDE bytecode.
+ */
+static __always_inline int
+riscv_dwarf_cfi_module_find(unsigned long pc, struct dwarf_cfi_row *row)
+{
+	struct mod_dwarf_cfi_index *idx;
+	struct module *mod;
+	int ret;
+
+	rcu_read_lock_sched_notrace();
+	mod = __module_address(pc);
+	if (!mod) {
+		rcu_read_unlock_sched_notrace();
+		return -ENOENT;
+	}
+	idx = rcu_dereference_raw(mod->arch.dwarf_cfi_index);
+	ret = dwarf_cfi_mod_eval(idx, pc, &riscv_cfi_arch, row);
+	rcu_read_unlock_sched_notrace();
+	return ret;
+}
+#else
+static __always_inline int
+riscv_dwarf_cfi_module_find(unsigned long pc, struct dwarf_cfi_row *row)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_MODULES */
+
+/**
+ * riscv_dwarf_cfi_find() - Evaluate Minimal DWARF CFI for core or module @pc
+ * @pc: Kernel instruction pointer to look up.
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Return: 0 on success, -ENOENT if no FDE covers @pc, or a negative errno on
+ * malformed CFI data.
+ */
+static __always_inline int
+riscv_dwarf_cfi_find(unsigned long pc, struct dwarf_cfi_row *row)
+{
+	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
+	int err;
+
+	err = dwarf_cfi_unwind_eh_frame_hdr(__start_eh_frame_hdr, hdr_size,
+					    __start_eh_frame, __stop_eh_frame,
+					    pc, &riscv_cfi_arch, row);
+	if (!err)
+		return 0;
+
+	return riscv_dwarf_cfi_module_find(pc, row);
+}
+
+/**
+ * riscv_fgraph_recover() - Recover original return address from ftrace_graph
+ * @task: Task being unwound.
+ * @graph_idx: Shadow-stack index cursor for ftrace_graph_ret_addr().
+ * @pc: Candidate return address (potentially &return_to_handler).
+ * @cfa: Callee frame's Canonical Frame Address (entry SP).
+ * @ra_slot: Stack slot where @pc was saved (overridden when DYNAMIC_FTRACE_WITH_ARGS).
+ *
+ * Return: Restored caller PC if @pc matched &return_to_handler, or @pc.
+ */
+static __always_inline unsigned long
+riscv_fgraph_recover(struct task_struct *task, int *graph_idx,
+		     unsigned long pc, unsigned long cfa,
+		     unsigned long *ra_slot)
+{
+#if defined(CONFIG_FUNCTION_GRAPH_TRACER) && defined(CONFIG_DYNAMIC_FTRACE_WITH_ARGS)
+	unsigned long fregs_addr = cfa - ALIGN(sizeof(struct __arch_ftrace_regs),
+					       STACK_ALIGN);
+
+	ra_slot = &((struct __arch_ftrace_regs *)fregs_addr)->ra;
+#endif
+	return ftrace_graph_ret_addr(task, graph_idx, pc, ra_slot);
+}
+
+/**
+ * riscv_recover_ret_addr() - Recover ftrace_graph and rethook return addresses
+ * @task: Task being unwound.
+ * @graph_idx: Shadow-stack cursor for ftrace_graph_ret_addr().
+ * @kr_cur: Shadow-list cursor for rethook_find_ret_addr().
+ * @pc: Candidate return address to recover.
+ * @cfa: Callee frame's Canonical Frame Address (entry SP).
+ * @ra_slot: Stack slot where @pc was saved (or NULL if still in ra).
+ *
+ * Recovers original caller PCs across both ftrace_graph and rethook shadow
+ * stacks in either hooking order, keying rethook lookups on @cfa (matching
+ * arch_rethook_prepare() under CONFIG_UNWINDER_DWARF_CFI).
+ *
+ * Return: Restored caller PC, or 0 if recovery failed.
+ */
+static __always_inline unsigned long
+riscv_recover_ret_addr(struct task_struct *task, int *graph_idx,
+		       struct llist_node **kr_cur, unsigned long pc,
+		       unsigned long cfa, unsigned long *ra_slot)
+{
+	pc = riscv_fgraph_recover(task, graph_idx, pc, cfa, ra_slot);
+#ifdef CONFIG_RETHOOK
+	if (is_rethook_trampoline(pc)) {
+		pc = rethook_find_ret_addr(task, cfa, kr_cur);
+		if (!pc || is_rethook_trampoline(pc))
+			return 0;
+	}
+#endif
+	pc = riscv_fgraph_recover(task, graph_idx, pc, cfa, ra_slot);
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (pc == (unsigned long)return_to_handler)
+		return 0;
+#endif
+	return pc;
+}
+
+#define RISCV_STACK_TASK	BIT(0)
+#define RISCV_STACK_IRQ		BIT(1)
+#define RISCV_STACK_OVERFLOW	BIT(2)
+
+/**
+ * riscv_stack_bounds() - Validate that [@addr, @addr + @size) lies on a stack
+ * @task: Task whose stacks are checked.
+ * @addr: Start virtual address of the stack access.
+ * @size: Access size in bytes.
+ * @out_low: Output lower bound of the matched stack.
+ * @out_high: Output upper bound of the matched stack.
+ *
+ * Checks @task's task stack, and when unwinding @current in non-preemptible
+ * context, also checks the per-CPU IRQ and vmap overflow stacks.
+ *
+ * Return: RISCV_STACK_* bit for the matched stack, or 0 if out of bounds.
+ */
+static __always_inline unsigned int
+riscv_stack_bounds(struct task_struct *task, unsigned long addr,
+		   size_t size, unsigned long *out_low,
+		   unsigned long *out_high)
+{
+	unsigned long low, high;
+
+	low = (unsigned long)task_stack_page(task);
+	high = low + THREAD_SIZE;
+	if (addr >= low && addr < high && addr + size >= addr &&
+	    addr + size <= high) {
+		*out_low = low;
+		*out_high = high;
+		return RISCV_STACK_TASK;
+	}
+
+	if (task == current && !preemptible()) {
+#ifdef CONFIG_IRQ_STACKS
+		low = (unsigned long)raw_cpu_read(irq_stack_ptr);
+		high = low + IRQ_STACK_SIZE;
+		if (low && addr >= low && addr < high && addr + size >= addr &&
+		    addr + size <= high) {
+			*out_low = low;
+			*out_high = high;
+			return RISCV_STACK_IRQ;
+		}
+#endif
+#ifdef CONFIG_VMAP_STACK
+		low = (unsigned long)raw_cpu_ptr(overflow_stack);
+		high = low + OVERFLOW_STACK_SIZE;
+		if (addr >= low && addr < high && addr + size >= addr &&
+		    addr + size <= high) {
+			*out_low = low;
+			*out_high = high;
+			return RISCV_STACK_OVERFLOW;
+		}
+#endif
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_PERF_EVENTS
+/**
+ * riscv_unwind_perf_caller_regs() - Populate caller pt_regs for perf events
+ * @regs: Output pt_regs initialized for the caller frame.
+ * @pc: Current instruction pointer inside the function invoking perf_fetch_caller_regs.
+ * @caller_ip: Target caller instruction pointer to record in @regs->epc.
+ * @sp: Current stack pointer corresponding to @pc.
+ * @fp: Current s0 value corresponding to @pc.
+ *
+ * Steps one frame via Minimal DWARF CFI at @pc so @regs->sp, @regs->s0, and
+ * @regs->epc reflect the caller's stack state under -fomit-frame-pointer.
+ */
+void riscv_unwind_perf_caller_regs(struct pt_regs *regs, unsigned long pc,
+				   unsigned long caller_ip, unsigned long sp,
+				   unsigned long fp)
+{
+	unsigned long cur_low = 0, cur_high = 0, low = 0, high = 0;
+	struct llist_node *kr_cur = NULL;
+	struct dwarf_cfi_row row;
+	int graph_idx = 0;
+
+	regs->epc = caller_ip;
+	regs->ra = 0;
+	regs->s0 = fp;
+	regs->sp = sp;
+	regs->status = SR_PP;
+
+	if ((sp & (sizeof(long) - 1)) ||
+	    !riscv_stack_bounds(current, sp, /*size=*/0, &cur_low, &cur_high))
+		return;
+
+	if (riscv_dwarf_cfi_find(pc, &row))
+		return;
+
+	switch (row.cfa_base) {
+	case DWARF_CFI_BASE_SP:
+		sp += row.cfa_off;
+		break;
+	case DWARF_CFI_BASE_FP:
+		sp = fp + row.cfa_off;
+		break;
+	case DWARF_CFI_BASE_FP_INDIRECT: {
+		unsigned long cfa_addr = fp + row.cfa_off;
+
+		if ((cfa_addr & (sizeof(long) - 1)) ||
+		    !riscv_stack_bounds(current, cfa_addr, sizeof(long),
+					&low, &high) ||
+		    low != cur_low)
+			return;
+		sp = READ_ONCE(*(unsigned long *)cfa_addr);
+		break;
+	}
+	default:
+		return;
+	}
+
+	if ((sp & (sizeof(long) - 1)) || sp < cur_low || sp > cur_high)
+		return;
+
+	if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
+		unsigned long fp_addr = sp + row.fp_off;
+
+		if ((fp_addr & (sizeof(long) - 1)) ||
+		    !riscv_stack_bounds(current, fp_addr, sizeof(long),
+					&low, &high) ||
+		    low != cur_low)
+			return;
+		fp = READ_ONCE(*(unsigned long *)fp_addr);
+	} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
+		unsigned long fp_addr = fp + row.fp_off;
+
+		if ((fp_addr & (sizeof(long) - 1)) ||
+		    !riscv_stack_bounds(current, fp_addr, sizeof(long),
+					&low, &high) ||
+		    low != cur_low)
+			return;
+		fp = READ_ONCE(*(unsigned long *)fp_addr);
+	}
+
+	caller_ip = riscv_recover_ret_addr(current, &graph_idx, &kr_cur,
+					   caller_ip, sp, /*ra_slot=*/NULL);
+	if (caller_ip)
+		regs->epc = caller_ip;
+	regs->sp = sp;
+	regs->s0 = fp;
+}
+EXPORT_SYMBOL_GPL(riscv_unwind_perf_caller_regs);
+#endif /* CONFIG_PERF_EVENTS */
+
+/**
+ * walk_stackframe_cfi() - Unwind a RISC-V kernel stack via Minimal DWARF CFI
+ * @task: Target task to unwind (NULL defaults to current).
+ * @regs: Optional starting register state (rejected when @require_reliable).
+ * @fn: Callback invoked for each unwound PC; returning false stops the walk.
+ * @arg: Opaque cookie passed to @fn.
+ * @require_reliable: When true, reject exception boundaries, unannotated leaf
+ *                    fallbacks, and non-CFI frame-pointer guesses.
+ *
+ * Return: 0 on clean stack termination (or early callback stop when
+ * !@require_reliable), or -EINVAL when a reliable walk cannot be guaranteed.
+ */
+static __always_inline int
+walk_stackframe_cfi(struct task_struct *task, struct pt_regs *regs,
+		    bool (*fn)(void *, unsigned long), void *arg,
+		    bool require_reliable)
+{
+	unsigned long fp, sp, pc, ra = 0;
+	bool ra_valid = false, exact_pc = false, unreliable = false;
+	struct llist_node *kr_cur = NULL;
+	unsigned int used_stacks = 0;
+	int graph_idx = 0;
+	int level = 0;
+
+	if (!task)
+		task = current;
+
+	if (regs) {
+		if (require_reliable)
+			return -EINVAL;
+		fp = frame_pointer(regs);
+		sp = kernel_stack_pointer(regs);
+		pc = instruction_pointer(regs);
+		ra = regs->ra;
+		ra_valid = !!ra;
+		exact_pc = true;
+	} else if (task == current) {
+		asm volatile("1: auipc %0, 0\n\t"
+			     "mv %1, s0"
+			     : "=r"(pc), "=r"(fp));
+		sp = current_stack_pointer;
+		ra = (unsigned long)__builtin_return_address(0);
+		ra_valid = true;
+		exact_pc = true;
+		level = -1;
+	} else {
+		fp = task->thread.s[0];
+		sp = task->thread.sp;
+		pc = task->thread.ra;
+	}
+
+	for (;;) {
+		unsigned long lookup_pc, cfa, next_pc, next_fp = fp;
+		unsigned long cur_low = 0, cur_high = 0, low = 0, high = 0;
+		unsigned long tsk_low = (unsigned long)task_stack_page(task);
+		unsigned int cur_stk, next_stk;
+		struct dwarf_cfi_row row;
+		int err;
+
+		if (!pc) {
+			if (exact_pc && ra_valid && !require_reliable) {
+				pc = ra;
+				ra_valid = false;
+				exact_pc = false;
+				unreliable = true;
+				continue;
+			}
+			return require_reliable ? -EINVAL : 0;
+		}
+
+		/*
+		 * Boot and secondary CPU idle tasks enter C code from
+		 * .head.text ([_start, _stext)), which precedes _stext.
+		 */
+		if (is_idle_task(task) &&
+		    sp >= (unsigned long)task_pt_regs(task) &&
+		    sp <= tsk_low + THREAD_SIZE &&
+		    pc >= (unsigned long)_start &&
+		    pc < (unsigned long)_stext)
+			return 0;
+
+		if (!__kernel_text_address(pc))
+			return require_reliable ? -EINVAL : 0;
+
+		if (sp == (unsigned long)task_pt_regs(task) &&
+		    pc >= (unsigned long)ret_from_fork_kernel_asm &&
+		    pc < (unsigned long)&ret_from_fork_asm_end) {
+			if (level++ >= 0 && !fn(arg, pc))
+				return require_reliable ? -EINVAL : 0;
+			return 0;
+		}
+
+		if (level++ >= 0 && !fn(arg, pc))
+			return require_reliable ? -EINVAL : 0;
+
+		if (pc >= (unsigned long)handle_exception &&
+		    pc < (unsigned long)&ret_from_exception_end) {
+			struct pt_regs *er = (struct pt_regs *)sp;
+			unsigned long status, next_sp, next_ra;
+
+			if (sp & (sizeof(long) - 1))
+				return -EINVAL;
+			cur_stk = riscv_stack_bounds(task, sp, sizeof(*er),
+						     &cur_low, &cur_high);
+			if (!cur_stk)
+				return -EINVAL;
+			status = READ_ONCE_TASK_STACK(task, er->status);
+			if ((status & SR_PP) == 0)
+				return 0;
+			if (require_reliable)
+				return -EINVAL;
+
+			next_pc = READ_ONCE_TASK_STACK(task, er->epc);
+			next_sp = READ_ONCE_TASK_STACK(task, er->sp);
+			next_fp = READ_ONCE_TASK_STACK(task, er->s0);
+			next_ra = READ_ONCE_TASK_STACK(task, er->ra);
+			if (next_sp & (sizeof(long) - 1))
+				return -EINVAL;
+			next_stk = riscv_stack_bounds(task, next_sp,
+						      sizeof(long),
+						      &low, &high);
+			if (!next_stk)
+				return -EINVAL;
+			if (low == cur_low) {
+				if (next_sp <= sp)
+					return -EINVAL;
+			} else {
+				if (used_stacks & next_stk)
+					return -EINVAL;
+				used_stacks |= cur_stk;
+			}
+			pc = next_pc;
+			sp = next_sp;
+			fp = next_fp;
+			ra = next_ra;
+			ra_valid = true;
+			exact_pc = true;
+			unreliable = true;
+			continue;
+		}
+
+		lookup_pc = exact_pc ? pc : pc - 2;
+		err = riscv_dwarf_cfi_find(lookup_pc, &row);
+		if (err) {
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_ARGS
+			if (lookup_pc >= (unsigned long)ftrace_caller_saved &&
+			    lookup_pc < (unsigned long)ftrace_caller_restore &&
+			    (!exact_pc || !require_reliable)) {
+				size_t fsize = ALIGN(sizeof(struct __arch_ftrace_regs),
+						     STACK_ALIGN);
+				struct __arch_ftrace_regs *fregs = (void *)sp;
+
+				if ((sp & (sizeof(long) - 1)) ||
+				    !riscv_stack_bounds(task, sp, fsize,
+							&cur_low, &cur_high) ||
+				    READ_ONCE_TASK_STACK(task, fregs->sp) != sp + fsize)
+					return -EINVAL;
+				pc = READ_ONCE_TASK_STACK(task, fregs->epc);
+				fp = READ_ONCE_TASK_STACK(task, fregs->s0);
+				ra = READ_ONCE_TASK_STACK(task, fregs->ra);
+				sp += fsize;
+				ra_valid = true;
+				exact_pc = true;
+				if (!pc)
+					return -EINVAL;
+				continue;
+			}
+#endif
+#ifdef CONFIG_IRQ_STACKS
+			/*
+			 * call_on_irq_stack() saves {fp, ra} below s0 on the
+			 * task stack before switching sp to irq_stack_ptr.
+			 */
+			if (!require_reliable &&
+			    task == current && !preemptible() &&
+			    !(used_stacks & RISCV_STACK_TASK) &&
+			    pc >= (unsigned long)call_on_irq_stack &&
+			    pc < (unsigned long)&call_on_irq_stack_end) {
+				unsigned long irq_low =
+					(unsigned long)raw_cpu_read(irq_stack_ptr);
+
+				if (irq_low && sp > irq_low &&
+				    sp <= irq_low + IRQ_STACK_SIZE &&
+				    fp && !(fp & 0x7) &&
+				    fp >= tsk_low + sizeof(struct stackframe) &&
+				    fp <= tsk_low + THREAD_SIZE) {
+					struct stackframe *fr =
+						(struct stackframe *)fp - 1;
+					unsigned long old_fp = fp;
+
+					next_fp = READ_ONCE_TASK_STACK(task, fr->fp);
+					next_pc = READ_ONCE_TASK_STACK(task, fr->ra);
+					next_pc = riscv_recover_ret_addr(task,
+							&graph_idx, &kr_cur,
+							next_pc, old_fp,
+							&fr->ra);
+					if (!next_pc)
+						return 0;
+					used_stacks |= RISCV_STACK_IRQ;
+					fp = next_fp;
+					pc = next_pc;
+					sp = old_fp;
+					ra_valid = false;
+					exact_pc = false;
+					unreliable = true;
+					continue;
+				}
+			}
+#endif
+			if (exact_pc && ra_valid && !require_reliable &&
+			    pc >= (unsigned long)_stext &&
+			    pc < (unsigned long)_etext) {
+				pc = riscv_recover_ret_addr(task, &graph_idx,
+							    &kr_cur, ra, sp,
+							    /*ra_slot=*/NULL);
+				if (!pc)
+					return 0;
+				ra_valid = false;
+				exact_pc = false;
+				unreliable = true;
+				continue;
+			}
+
+			/*
+			 * Fallback to frame-pointer record at (fp - 16) for
+			 * JITed BPF programs and BPF trampolines.
+			 */
+			if (!require_reliable && !(sp & 0x7) &&
+			    riscv_stack_bounds(task, sp, /*size=*/0, &cur_low,
+					       &cur_high) &&
+			    !(fp & 0x7) &&
+			    fp >= sp + sizeof(struct stackframe) &&
+			    fp <= cur_high) {
+				struct stackframe *fr = (struct stackframe *)fp - 1;
+				unsigned long old_fp = fp;
+
+				next_fp = READ_ONCE_TASK_STACK(task, fr->fp);
+				next_pc = READ_ONCE_TASK_STACK(task, fr->ra);
+				if (exact_pc && ra_valid &&
+				    !(next_pc & 0x7) &&
+				    next_pc >= old_fp && next_pc <= cur_high) {
+					/* Leaf BPF prog without saved ra */
+					fp = next_pc;
+					pc = ra;
+				} else {
+					next_pc = riscv_recover_ret_addr(task,
+							&graph_idx, &kr_cur,
+							next_pc, old_fp,
+							&fr->ra);
+					if (!next_pc)
+						return 0;
+					fp = next_fp;
+					pc = next_pc;
+				}
+				sp = old_fp;
+				ra_valid = false;
+				exact_pc = false;
+				unreliable = true;
+				continue;
+			}
+
+			if (exact_pc && ra_valid && !require_reliable) {
+				pc = riscv_recover_ret_addr(task, &graph_idx,
+							    &kr_cur, ra, sp,
+							    /*ra_slot=*/NULL);
+				if (!pc)
+					return 0;
+				ra_valid = false;
+				exact_pc = false;
+				unreliable = true;
+				continue;
+			}
+			return -EINVAL;
+		}
+
+		if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED)
+			return require_reliable ? -EINVAL : 0;
+
+		if ((sp & (sizeof(long) - 1)) ||
+		    !riscv_stack_bounds(task, sp, /*size=*/0, &cur_low,
+					&cur_high))
+			return -EINVAL;
+
+		switch (row.cfa_base) {
+		case DWARF_CFI_BASE_SP:
+			cfa = sp + row.cfa_off;
+			break;
+		case DWARF_CFI_BASE_FP:
+			cfa = fp + row.cfa_off;
+			break;
+		case DWARF_CFI_BASE_FP_INDIRECT:
+			if (((fp + row.cfa_off) & (sizeof(long) - 1)) ||
+			    !riscv_stack_bounds(task, fp + row.cfa_off,
+						sizeof(long), &low, &high) ||
+			    low != cur_low)
+				return -EINVAL;
+			cfa = READ_ONCE_TASK_STACK(task,
+				*(unsigned long *)(fp + row.cfa_off));
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if ((cfa & (sizeof(long) - 1)) || cfa < cur_low || cfa > cur_high)
+			return -EINVAL;
+
+		if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
+			unsigned long fp_addr = cfa + row.fp_off;
+
+			if ((fp_addr & (sizeof(long) - 1)) ||
+			    !riscv_stack_bounds(task, fp_addr, sizeof(long),
+						&low, &high) ||
+			    low != cur_low)
+				return -EINVAL;
+			next_fp = READ_ONCE_TASK_STACK(task, *(unsigned long *)fp_addr);
+		} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
+			unsigned long fp_addr = fp + row.fp_off;
+
+			if ((fp_addr & (sizeof(long) - 1)) ||
+			    !riscv_stack_bounds(task, fp_addr, sizeof(long),
+						&low, &high) ||
+			    low != cur_low)
+				return -EINVAL;
+			next_fp = READ_ONCE_TASK_STACK(task, *(unsigned long *)fp_addr);
+		}
+
+		if (row.ra_rule == DWARF_CFI_RULE_SAME) {
+			if (!ra_valid) {
+				/*
+				 * Non-struct_ops BPF trampolines push a
+				 * synthetic parent frame record above the
+				 * inner traced-function frame record.
+				 */
+				if (!require_reliable && unreliable &&
+				    row.cfa_base == DWARF_CFI_BASE_SP &&
+				    row.cfa_off == 0 &&
+				    fp == sp + sizeof(struct stackframe) &&
+				    fp <= cur_high) {
+					struct stackframe *fr =
+						(struct stackframe *)fp - 1;
+					unsigned long old_fp = fp;
+
+					next_fp = READ_ONCE_TASK_STACK(task, fr->fp);
+					next_pc = READ_ONCE_TASK_STACK(task, fr->ra);
+					next_pc = riscv_recover_ret_addr(task,
+							&graph_idx, &kr_cur,
+							next_pc, old_fp,
+							&fr->ra);
+					if (!next_pc)
+						return 0;
+					sp = old_fp;
+					fp = next_fp;
+					pc = next_pc;
+					ra_valid = false;
+					exact_pc = false;
+					continue;
+				}
+				return -EINVAL;
+			}
+			if (cfa < sp)
+				return -EINVAL;
+			next_pc = riscv_recover_ret_addr(task, &graph_idx,
+							 &kr_cur, ra, cfa,
+							 /*ra_slot=*/NULL);
+		} else if (row.ra_rule == DWARF_CFI_RULE_OFFSET) {
+			unsigned long *ra_p = (unsigned long *)(cfa + row.ra_off);
+
+			if (cfa <= sp ||
+			    ((unsigned long)ra_p & (sizeof(long) - 1)) ||
+			    !riscv_stack_bounds(task, (unsigned long)ra_p,
+						sizeof(long), &low, &high) ||
+			    low != cur_low)
+				return -EINVAL;
+			next_pc = READ_ONCE_TASK_STACK(task, *ra_p);
+			next_pc = riscv_recover_ret_addr(task, &graph_idx,
+							 &kr_cur, next_pc, cfa,
+							 ra_p);
+		} else {
+			return -EINVAL;
+		}
+
+		if (!next_pc)
+			return require_reliable ? -EINVAL : 0;
+
+		sp = cfa;
+		fp = next_fp;
+		pc = next_pc;
+		ra_valid = false;
+		exact_pc = row.signal;
+	}
+}
+
+noinline void notrace walk_stackframe(struct task_struct *task,
+				      struct pt_regs *regs,
+				      bool (*fn)(void *, unsigned long),
+				      void *arg)
+{
+	walk_stackframe_cfi(task, regs, fn, arg, /*require_reliable=*/false);
+}
+
+noinline noinstr int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry,
+					      void *cookie,
+					      struct task_struct *task)
+{
+	return walk_stackframe_cfi(task, /*regs=*/NULL, consume_entry, cookie,
+				   /*require_reliable=*/true);
+}
+
+#elif defined(CONFIG_FRAME_POINTER)
+
 static inline int fp_is_valid(unsigned long fp, unsigned long sp)
 {
 	unsigned long low, high;
@@ -102,7 +828,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 	}
 }
 
-#else /* !CONFIG_FRAME_POINTER */
+#else /* !CONFIG_FRAME_POINTER && !CONFIG_UNWINDER_DWARF_CFI */
 
 void notrace walk_stackframe(struct task_struct *task,
 	struct pt_regs *regs, bool (*fn)(void *, unsigned long), void *arg)
diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 1f4f8496941a..f2bd07e08d5e 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -125,6 +125,19 @@ SECTIONS
 		*(.srodata*)
 	}
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	.eh_frame_hdr : ALIGN(4) {
+		__start_eh_frame_hdr = .;
+		*(.eh_frame_hdr)
+		__stop_eh_frame_hdr = .;
+	}
+	.eh_frame : ALIGN(8) {
+		__start_eh_frame = .;
+		*(.eh_frame)
+		__stop_eh_frame = .;
+	}
+#endif
+
 	. = ALIGN(SECTION_ALIGN);
 	_data = .;
 
diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index b0358a78f11a..29c23c58b26c 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -60,8 +60,9 @@ targets += purgatory.ro purgatory.chk
 # These are adjustments to the compiler flags used for objects that
 # make up the standalone purgatory.ro
 
-PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel
+PURGATORY_CFLAGS_REMOVE := -mcmodel=kernel -fasynchronous-unwind-tables -funwind-tables
 PURGATORY_CFLAGS := -mcmodel=medany -ffreestanding -fno-zero-initialized-in-bss
+PURGATORY_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
 PURGATORY_CFLAGS += $(DISABLE_KSTACK_ERASE) -DDISABLE_BRANCH_PROFILING
 PURGATORY_CFLAGS += -fno-stack-protector -g0
 
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index d62dabfdc1c3..19c2822eb302 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -30,7 +30,9 @@ cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
 				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
 				   -DEFI_HAVE_STRCMP -fno-builtin -fpic \
 				   $(call cc-option,-mno-single-pic-base)
-cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax
+cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax \
+				   -fno-unwind-tables \
+				   -fno-asynchronous-unwind-tables
 cflags-$(CONFIG_LOONGARCH)	+= -fpie
 
 cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt
-- 
2.56.1.750.gf70dc682cf-goog

