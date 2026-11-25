Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587397;
	b=Gj3jvZGC4td7BZTa80Oh5jCmFVy/o+K2xcUIvxFpAX4I+27D65EbSuWE0KZfuRM4VEM4
	 L5FfHW0YIiXs+ThZWnzYArRyC7JcKt/NXrWE//f9AjLdq4+xkVzA6SndxZcsco/5Fa3la
	 muqthYyfSAZB52CNGvmLTsLC+cMbXgPcmtwE8txk22jZ6Ho3NCn70YmZnISMtDeOValIS
	 FDbUQIwgNnxG88wmllpoptkHsxKWkvd2/urFxd9IuFW0mWTJz+es03RT44bahwDLHzril
	 36l0iu9Jc/jfrfDT4ckmW2a17k9bt0A6dmUNRXh6YW4EjtySVjHHud0owbNDOIcmjRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587397;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=1M39M3BC8RejWKp1a99LR6YnpQFze4DNErRt/k0WGKw=;
	b=V0aRM4a6pEEcrfO1sQHEyHnNwUccXFRlgIwGAfnZ3D5OMkMGVzfjYURydA5xW8gRGaVU
	 xf2kqn5Bt1ZF/gnN4ThfLfn7njFUYtfxConl5cXfGX46U08zMB6HyIHG6KiYyzyx55Gjt
	 KLcRqBXq4lPIh3M3a1aFhY+PT4SXP557R2cNDI1XOtZCzDYoHXWh5f43RBgMib/HtvrO+
	 j6SQd8PjcnMf+q/r2xasJqTm1ZnraVKY4J6zWSXmwgtGNGSI/XDUwO38bRDsfiGpkg4Va
	 ZGh7HCV4FVD2khAJjIV1pbh214S7edEHkCKxXUjMD6KCCXrp+5Swdi3YLNhFv/+03BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kgyHL+iL;
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50544606B3FB
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50544606B3FB
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kgyHL+iL
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b56c696405so6030810c88.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587395; x=1796192195; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1M39M3BC8RejWKp1a99LR6YnpQFze4DNErRt/k0WGKw=;
        b=kgyHL+iLJNuq4/mr65T4ynzKd9BJkZ4HeTKgRlcZ1UmoQ1G5pkb0BjhXIPlXi0kKh+
         +iJZUSP7cZFw+SF+IuD36baLIZechr1LL01RBZ0/OI22ZgA/TurhzVSjUnjsRrrGw+uY
         T+imq3DbN8y4gqnefRotr9GJ6CHEhN9z1M3d/HIANmve2/3ZI8OQIageeYSdn2NJFm1H
         V2kIRdSg0b+ZfgVj5ncG44T+UEkGtl0xOmoZuu5dXInzvmk9dMau3wtv0PGjVXnIzfbm
         tIszpclsQx7KR+DmAjco+vZr62lytIphmwEoqjtCxRuxNxu2xLE0l4ppwfwsaE75h7sT
         UDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587395; x=1796192195;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1M39M3BC8RejWKp1a99LR6YnpQFze4DNErRt/k0WGKw=;
        b=pPuXY0TwBGAwutVYrekTMhJf1dvXbSdnNNWi/d4pMxWncxbbjy7PpuvOBOD66iqDm7
         gBnHTDYjpKDaVMwCoU6jbwsBaOHPKRd44pvmcxQnY6xCTZXxqmqp7dQNPgOegChBgbo3
         dJRoxcCarnk643+wRx3xR1Htcd42Fhlv0xzvC3LRN8uxne0bk9jj6Q2/k70NCC3Uv2pp
         Z6Z0ny619L51ApP57JBgnI41n0xMWakXYCdqnL8FpH2EB2K4A2SzR7yzwHqnoTr6aiAT
         xeF27fEJ0+Qb7Bo4TpPrJxs56qtbDQFcCA82vaexH25JJFFFz+RNOomltbex5pM1L+19
         RQWA==
X-Forwarded-Encrypted: i=1; AL+hErGWiAXfOm11xUdh3xfxDJo/cOexqv7yWCdlgSRbLnpUbWQNyngkagE7jN8FBQVPgHBnujdCJ72JFs0=@vger.kernel.org
X-Gm-Message-State: APuU4Z8w7vzsFmCQfzCR2Q3/mW+RWNM5DUpbj+Eow/+ULDF4tRxB1CD8
	0wRKygrWBkA1m9JolFHmTIkZvF89HxAbkQx13LxcDlYa+H5zkybPe6swvXgjjeQadfazQ4Fq//6
	p+nI4J6gBsg==
X-Received: from dlep20-n2.prod.google.com ([2002:a05:701b:4594:20b0:1b5:7578:79ee])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:e80e:b0:1b5:3b6e:e1ed
 with SMTP id a92af1059eb24-1b55690bcf3mr20050632c88.32.1795587394845; Tue, 24
 Nov 2026 22:16:34 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:12 -0800
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
Message-ID: <20261125061523.1540234-20-irogers@google.com>
Subject: [RFC PATCH v2 19/30] riscv/unwind: Add Minimal DWARF CFI kernel unwinder
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

Add CONFIG_UNWINDER_DWARF_CFI as a selectable 64-bit RISC-V kernel
unwinder (selecting HAVE_RELIABLE_STACKTRACE) in
arch/riscv/kernel/stacktrace.c:
 - Build C and Rust kernel code with -fomit-frame-pointer and
   -fasynchronous-unwind-tables, link vmlinux with --eh-frame-hdr, place
   .eh_frame_hdr and .eh_frame in RO_DATA, and index SHF_ALLOC module
   .eh_frame sections via dwarf_cfi_mod_alloc()/dwarf_cfi_mod_free_rcu().
 - Implement walk_stackframe_cfi() and arch_stack_walk_reliable() across
   task, IRQ, and overflow stacks with RVC 16-bit call-site support,
   SP-keyed ftrace_graph/rethook recovery, BPF frame fallback, and
   exception/entry root termination.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/riscv/Kconfig                  |   5 +-
 arch/riscv/Kconfig.debug            |  16 +
 arch/riscv/Makefile                 |  15 +-
 arch/riscv/include/asm/ftrace.h     |   1 +
 arch/riscv/include/asm/module.h     |  22 +
 arch/riscv/include/asm/perf_event.h |   2 +
 arch/riscv/include/asm/stacktrace.h |  11 +
 arch/riscv/kernel/Makefile          |   9 +
 arch/riscv/kernel/module.c          |   9 +
 arch/riscv/kernel/stacktrace.c      | 650 +++++++++++++++++++++++++++-
 arch/riscv/kernel/vmlinux.lds.S     |  13 +
 arch/riscv/purgatory/Makefile       |   3 +-
 12 files changed, 749 insertions(+), 7 deletions(-)

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
diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index e5026cd8f022..663831d950e5 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -217,6 +217,7 @@ ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
 	regs->sp = afregs->sp;
 	regs->s0 = afregs->s0;
 	regs->t1 = afregs->t1;
+	regs->cause = 0;
 	return regs;
 }
 
diff --git a/arch/riscv/include/asm/module.h b/arch/riscv/include/asm/module.h
index 0f3baaa6a9a8..2a8dd969c1f8 100644
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
 
+#ifdef CONFIG_HAVE_MOD_ARCH_SPECIFIC
 struct mod_arch_specific {
+#ifdef CONFIG_MODULE_SECTIONS
 	struct mod_section got;
 	struct mod_section plt;
 	struct mod_section got_plt;
+#endif
+#if defined(CONFIG_UNWINDER_DWARF_CFI) && defined(CONFIG_MODULES)
+	struct mod_dwarf_cfi_index __rcu *dwarf_cfi_index;
+#endif
 };
+#endif
+
+#if defined(CONFIG_UNWINDER_DWARF_CFI) && defined(CONFIG_MODULES)
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
index bcc928fd3785..30d0c6b37e91 100644
--- a/arch/riscv/include/asm/perf_event.h
+++ b/arch/riscv/include/asm/perf_event.h
@@ -14,9 +14,11 @@
 
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->epc = (__ip); \
+	(regs)->ra = 0; \
 	(regs)->s0 = (unsigned long) __builtin_frame_address(0); \
 	(regs)->sp = current_stack_pointer; \
 	(regs)->status = SR_PP; \
+	(regs)->cause = ~0UL; \
 }
 #endif
 
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
index f54c336bf547..7ad74377dd4c 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -42,6 +42,15 @@ CFLAGS_REMOVE_patch.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_sbi.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o	= $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_sbi_ecall.o = $(CC_FLAGS_FTRACE)
+ifdef CONFIG_UNWINDER_DWARF_CFI
+CFLAGS_REMOVE_stacktrace.o = $(CC_FLAGS_FTRACE)
+endif
+endif
+
+ifdef CONFIG_UNWINDER_DWARF_CFI
+CFLAGS_stacktrace.o += -fno-optimize-sibling-calls
+KASAN_SANITIZE_stacktrace.o := n
+KCOV_INSTRUMENT_stacktrace.o := n
 endif
 
 always-$(KBUILD_BUILTIN) += vmlinux.lds
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
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index c7555447149b..45d81aa11a8e 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -6,16 +6,20 @@
 
 #include <linux/export.h>
 #include <linux/kallsyms.h>
+#include <linux/module.h>
+#include <linux/rcupdate.h>
+#include <linux/rethook.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
 #include <linux/ftrace.h>
+#include <linux/unwind_dwarf_cfi.h>
 
+#include <asm/irq_stack.h>
+#include <asm/sections.h>
 #include <asm/stacktrace.h>
 
-#ifdef CONFIG_FRAME_POINTER
-
 /*
  * This disables KASAN checking when reading a value from another task's stack,
  * since the other task could be running on another CPU and could have poisoned
@@ -35,6 +39,646 @@
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
+	if (addr >= low && (addr < high || (!size && addr == high)) &&
+	    addr + size >= addr && addr + size <= high) {
+		*out_low = low;
+		*out_high = high;
+		return RISCV_STACK_TASK;
+	}
+
+	if (task == current && !preemptible()) {
+#ifdef CONFIG_IRQ_STACKS
+		low = (unsigned long)raw_cpu_read(irq_stack_ptr);
+		high = low + IRQ_STACK_SIZE;
+		if (low && addr >= low &&
+		    (addr < high || (!size && addr == high)) &&
+		    addr + size >= addr && addr + size <= high) {
+			*out_low = low;
+			*out_high = high;
+			return RISCV_STACK_IRQ;
+		}
+#endif
+#ifdef CONFIG_VMAP_STACK
+		low = (unsigned long)raw_cpu_ptr(overflow_stack);
+		high = low + OVERFLOW_STACK_SIZE;
+		if (addr >= low && (addr < high || (!size && addr == high)) &&
+		    addr + size >= addr && addr + size <= high) {
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
+	unsigned long fp, sp, pc, ra = 0, min_sp = 0, caller_fp = 0, caller_pc = 0;
+	bool ra_valid = false, exact_pc = false, unreliable = false;
+	struct llist_node *kr_cur = NULL;
+	unsigned int used_stacks = 0;
+	int graph_idx = 0;
+	int level = 0;
+
+	if (!task)
+		task = current;
+
+	if (regs && regs->cause == ~0UL && !regs->ra) {
+		if (require_reliable || task != current)
+			return -EINVAL;
+		min_sp = regs->sp;
+		caller_fp = regs->s0;
+		caller_pc = regs->epc;
+		regs = NULL;
+	}
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
+		bool skip_emit;
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
+		skip_emit = (level++ < 0) ||
+			    (min_sp && (sp < min_sp ||
+					(sp == min_sp && sp < caller_fp &&
+					 pc != caller_pc)));
+
+		if (sp == (unsigned long)task_pt_regs(task) &&
+		    pc >= (unsigned long)ret_from_fork_kernel_asm &&
+		    pc < (unsigned long)&ret_from_fork_asm_end) {
+			if (!skip_emit && !fn(arg, pc))
+				return require_reliable ? -EINVAL : 0;
+			return 0;
+		}
+
+		if (!skip_emit && !fn(arg, pc))
+			return require_reliable ? -EINVAL : 0;
+		if (!skip_emit)
+			min_sp = 0;
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
+						      /*size=*/0,
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
+					next_pc =
+						riscv_recover_ret_addr(task, &graph_idx,
+								       &kr_cur, next_pc,
+								       old_fp, &fr->ra);
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
+				next_pc = riscv_recover_ret_addr(task,
+								 &graph_idx, &kr_cur,
+								 next_pc, old_fp, &fr->ra);
+				if (!next_pc)
+					return 0;
+				fp = next_fp;
+				pc = next_pc;
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
+						   *(unsigned long *)(fp + row.cfa_off));
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
+					next_pc =
+						riscv_recover_ret_addr(task, &graph_idx,
+								       &kr_cur, next_pc,
+								       old_fp, &fr->ra);
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
@@ -102,7 +746,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
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
 
-- 
2.56.1.831.g720f3f5937-goog

