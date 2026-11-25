Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587392;
	b=kMLnEVQO4TLpllV9kx83+++JtDzregtUtpt6ZGONv5u+0s81HjbuDbReA5UpN31GRVgn
	 wzh0ftPsqAblrBIbq0WzgqYBGZMlCxB1pDkS7OSscZygnXcfZKx3tz3aE16sDCZ+QV+Jc
	 mL+ynHsO19EsIZMBBPrKDabJHcrZWAsd6MXgY1GKhCwVHP/UvEasqngPhnMstLzo25URj
	 bQ3ClMbuspraIXZRK+NedUH2oSMvVqncpjBXgULPkua9aNlsbVufcg0xoGv3JnkyntbVF
	 SKt0dw5Ewwrvoy7cTl1DhTpJOx9FLjP14t9ZCn+ifFYf6kuloo2wQetSuvmCgbgrpnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587392;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=p6F/7YwPxRSYynZkgqeZi8PTBkMQbw/vJf7xQZyDuq0=;
	b=1wVmZg4HhMzp5WkjCVDlZovaATH0nukxbHUSoFJzNGAHH3Xb+BjaPDvjKYqbiZjh3D4L
	 ZPHRF4FGrKAj8c7Fn5OMmlDN5Ya/rv0206h3vYwUjEWEkFDZX5EBQlkV7VMflaY3HnJke
	 Mexhdnvwtmo1DZX6jqHwqjEbvUqnBqsEZGbUszi8MJ7uNyVUySaOLZZyMNPQbV0vf2u31
	 uWJD4XwtVziqe4Ru/sbAViBqmD9XCf0YwMsWIfFSyE06yUjZfedwbPn2RxdCDpLCcm2lT
	 IEiU8O4F0tLwocWZaFj9MRxAcBlnc1QpiNZvRPYWzoYzwEJrhwCUzDue7COCW9ymFkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iqK1MS4K;
	arc=none smtp.remote-ip=74.125.82.72
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA086072DA3
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DA086072DA3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iqK1MS4K
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1b55f4f3bb8so3024837c88.0
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587390; x=1796192190; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p6F/7YwPxRSYynZkgqeZi8PTBkMQbw/vJf7xQZyDuq0=;
        b=iqK1MS4K9KtDhZhGeI2nGJDGm2G3piS527KpiD/gXv8KylTSsdlzvm8Nk2Evl3F9fN
         1wLYXdTC6GRMQJ3sFljgxGgPfdfkDPomCQWyDvndJ3nHN3nvxI6YBk1GzJwVJs6X5mw4
         +pGlly5NDQoWNvk/WMkkk/0L6Xmw5rrXBZH6bNAxU4dbLWZSMJcYfelLypmabCbgMdDa
         uAXmbuWorcjNQlUGcAF6YRbpkKBB/JEuJItm4VLZSQVvTM6YeXpKHGMoDgts/c7KlC96
         SY6NliNVpTsJSFtMXnVKhdoSF2FHMACdGKzgxMK1bqJy9/1VMSGmtULlppybluERCGN+
         orUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587390; x=1796192190;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p6F/7YwPxRSYynZkgqeZi8PTBkMQbw/vJf7xQZyDuq0=;
        b=fxUXs/Kb1rpECMkXMmqrWxp5x+gSbD1HaD11Lbi2NWNG/o8PTWfILlgKZkGiEA+Jxs
         MKLEO8MFf/y4+5FpyjOYjuXKrVOyJigqwhrkdFY4ZOejrIGd7fYx3RCPa8GXAiBzXgnj
         m6jxRTt/IHoJkjVoaGsCPXrErjy5+WSvcBHbSm72VlE51wkP/Qcum8yVCT42wa5RlD64
         O3V+UFJSnzxyNNMa3ni1CzkzObH/YuVzwMf+PiUTIqjmIQHq7zXoEZT/C7LGhgO5qERy
         fIiqxiOPA/6AtSlzpaQ0bS1LQtdEHmJ9jZq/1u4uuYALMGFpxaoRwieUPFEBvwmJ49Ja
         iBCA==
X-Forwarded-Encrypted: i=1; AL+hErEA8PnIfJ+4dhAt9ehaA2MTHpqTYBh1zK66kGOKh7+v6RAehrFxqlax0olH+lv6+NHJtoPo4rSsDlk=@vger.kernel.org
X-Gm-Message-State: APuU4Z/OEa49CR5/IZ43hwZo12OMJKeD37Wuf4JUd7XZ3WRrNXTVVreh
	BTdsFnRX6rdJGoDCI1vztIrrvLpIijs+bzbdECN2TGs0XKedQMoN4A+cxFStH/yN5xUvLtpyx1p
	ufba0+RsPJA==
X-Received: from dlfd10-n2.prod.google.com ([2002:a05:701a:c9ca:20b0:1a0:a0b4:204c])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:e981:b0:1b4:caae:3324
 with SMTP id a92af1059eb24-1b5568ac1d5mr21346134c88.21.1795587389053; Tue, 24
 Nov 2026 22:16:29 -0800 (PST)
Date: Tue, 24 Nov 2026 22:15:09 -0800
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
Message-ID: <20261125061523.1540234-17-irogers@google.com>
Subject: [RFC PATCH v2 16/30] arm64/unwind: Add Minimal DWARF CFI kernel unwinder
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

Add CONFIG_UNWINDER_DWARF_CFI as a kernel unwinder choice alongside
CONFIG_UNWINDER_FRAME_POINTER on arm64:
 - Move select ARCH_WANT_FRAME_POINTERS and select FRAME_POINTER under
   UNWINDER_FRAME_POINTER and pass -fomit-frame-pointer and
   -fasynchronous-unwind-tables under UNWINDER_DWARF_CFI, while keeping
   -fno-omit-frame-pointer for the user vDSO and nVHE EL2 objects.
 - Emit --eh-frame-hdr and place .eh_frame_hdr and .eh_frame in vmlinux
   RO_DATA while preserving __pi___eh_frame_start/__pi___eh_frame_end
   for Dynamic Shadow Call Stack patching, and index SHF_ALLOC module
   .eh_frame sections with RCU-safe lifetime.
 - Key function_graph and kretprobe shadow return stacks on entry SP
   (CFA) rather than x29, mark caller-fetched perf regs via
   FRAME_META_TYPE_CALLER, and implement noinstr-safe kunwind_next_cfi()
   in arch/arm64/kernel/stacktrace.c.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 arch/arm64/Kconfig                        |   2 -
 arch/arm64/Kconfig.debug                  |  32 ++
 arch/arm64/Makefile                       |   5 +
 arch/arm64/include/asm/ftrace.h           |  18 +-
 arch/arm64/include/asm/module.h           |  16 +
 arch/arm64/include/asm/module.lds.h       |   2 +-
 arch/arm64/include/asm/perf_event.h       |   2 +
 arch/arm64/include/asm/stacktrace/frame.h |   6 +
 arch/arm64/kernel/Makefile                |   6 +
 arch/arm64/kernel/ftrace.c                |  12 +-
 arch/arm64/kernel/module.c                |  17 +-
 arch/arm64/kernel/probes/kprobes.c        |  14 +-
 arch/arm64/kernel/stacktrace.c            | 477 ++++++++++++++++++++--
 arch/arm64/kernel/vdso/Makefile           |   7 +-
 arch/arm64/kernel/vmlinux.lds.S           |  21 +-
 arch/arm64/kvm/hyp/nvhe/Makefile          |   1 +
 16 files changed, 596 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 918d7e278f7d..0c0b24d1ec4a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -91,7 +91,6 @@ config ARM64
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_BPF_JIT
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
-	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANTS_EXECMEM_LATE
@@ -118,7 +117,6 @@ config ARM64
 	select DMA_BOUNCE_UNALIGNED_KMALLOC
 	select DMA_DIRECT_REMAP
 	select EDAC_SUPPORT
-	select FRAME_POINTER
 	select FUNCTION_ALIGNMENT_4B
 	select FUNCTION_ALIGNMENT_8B if DYNAMIC_FTRACE_WITH_CALL_OPS
 	select GENERIC_ALLOCATOR
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 265c4461031f..4f5c99a2fa96 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -1,5 +1,37 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
+choice
+	prompt "Choose kernel unwinder"
+	default UNWINDER_FRAME_POINTER
+	help
+	  This determines which method will be used for unwinding kernel stack
+	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
+	  livepatch, lockdep, and more.  If unsure, keep the default frame
+	  pointer unwinder.
+
+config UNWINDER_FRAME_POINTER
+	bool "Frame pointer unwinder"
+	select ARCH_WANT_FRAME_POINTERS
+	select FRAME_POINTER
+	help
+	  This option enables the standard frame pointer (x29) unwinder for
+	  unwinding kernel stack traces on arm64.  Kernel code is compiled
+	  with frame records stored on the stack at a small runtime register
+	  and code-size cost.
+
+config UNWINDER_DWARF_CFI
+	bool "Minimal DWARF CFI unwinder"
+	depends on (!FUNCTION_TRACER || DYNAMIC_FTRACE_WITH_ARGS) && (!SHADOW_CALL_STACK || DYNAMIC_SCS)
+	select UNWIND_DWARF_CFI
+	select UNWIND_TABLES
+	help
+	  This option enables the Minimal DWARF Call Frame Information (CFI)
+	  unwinder for kernel stack traces.  It interprets a strictly bounded
+	  subset of compiler-generated .eh_frame / .eh_frame_hdr tables
+	  matching SFrame's stack state model without requiring frame pointers.
+
+endchoice
+
 config PID_IN_CONTEXTIDR
 	bool "Write the current PID to the CONTEXTIDR register"
 	help
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index ed28f94be428..7ec8e96b2032 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -23,6 +23,11 @@ ifeq ($(CONFIG_ARM64_ERRATUM_843419),y)
 LDFLAGS_vmlinux	+= --fix-cortex-a53-843419
 endif
 
+ifeq ($(CONFIG_UNWINDER_DWARF_CFI),y)
+KBUILD_CFLAGS	+= -fomit-frame-pointer
+LDFLAGS_vmlinux	+= --eh-frame-hdr
+endif
+
 cc_has_k_constraint := $(call try-run,echo				\
 	'int main(void) {						\
 		asm volatile("and w0, w0, %w0" :: "K" (4294967295));	\
diff --git a/arch/arm64/include/asm/ftrace.h b/arch/arm64/include/asm/ftrace.h
index 1621c84f44b3..57f19103c526 100644
--- a/arch/arm64/include/asm/ftrace.h
+++ b/arch/arm64/include/asm/ftrace.h
@@ -56,6 +56,7 @@ unsigned long arch_ftrace_get_symaddr(unsigned long fentry_ip);
 #define ftrace_get_symaddr(fentry_ip) arch_ftrace_get_symaddr(fentry_ip)
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_ARGS
+void ftrace_caller_end(void);
 #define HAVE_ARCH_FTRACE_REGS
 struct dyn_ftrace;
 struct ftrace_ops;
@@ -154,14 +155,21 @@ ftrace_partial_regs(const struct ftrace_regs *fregs, struct pt_regs *regs)
 	regs->regs[29] = afregs->fp;
 	regs->regs[30] = afregs->lr;
 	regs->pstate = PSR_MODE_EL1h;
+	regs->stackframe.type = FRAME_META_TYPE_NONE;
 	return regs;
 }
 
-#define arch_ftrace_fill_perf_regs(fregs, _regs) do {		\
-		(_regs)->pc = arch_ftrace_regs(fregs)->pc;			\
-		(_regs)->regs[29] = arch_ftrace_regs(fregs)->fp;		\
-		(_regs)->sp = arch_ftrace_regs(fregs)->sp;			\
-		(_regs)->pstate = PSR_MODE_EL1h;		\
+#define arch_ftrace_fill_perf_regs(fregs, _regs) do {			\
+		const struct __arch_ftrace_regs *__afregs =		\
+			arch_ftrace_regs(fregs);			\
+		struct pt_regs *__regs = (_regs);			\
+									\
+		__regs->pc = __afregs->pc;				\
+		__regs->regs[29] = __afregs->fp;			\
+		__regs->regs[30] = __afregs->lr;			\
+		__regs->sp = __afregs->sp;				\
+		__regs->pstate = PSR_MODE_EL1h;				\
+		__regs->stackframe.type = FRAME_META_TYPE_NONE;		\
 	} while (0)
 
 int ftrace_regs_query_register_offset(const char *name);
diff --git a/arch/arm64/include/asm/module.h b/arch/arm64/include/asm/module.h
index fb9b88eebeb1..71f423be20c2 100644
--- a/arch/arm64/include/asm/module.h
+++ b/arch/arm64/include/asm/module.h
@@ -13,6 +13,8 @@ struct mod_plt_sec {
 	int			plt_max_entries;
 };
 
+struct mod_dwarf_cfi_index;
+
 struct mod_arch_specific {
 	struct mod_plt_sec	core;
 	struct mod_plt_sec	init;
@@ -20,8 +22,22 @@ struct mod_arch_specific {
 	/* for CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry	*ftrace_trampolines;
 	struct plt_entry	*init_ftrace_trampolines;
+
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	struct mod_dwarf_cfi_index __rcu *dwarf_cfi_index;
+#endif
 };
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+void arm64_unwind_module_init(struct module *mod, void *eh_frame,
+			      size_t eh_frame_size);
+void arm64_unwind_module_cleanup(struct module *mod);
+#else
+static inline void arm64_unwind_module_init(struct module *mod, void *eh_frame,
+					    size_t eh_frame_size) {}
+static inline void arm64_unwind_module_cleanup(struct module *mod) {}
+#endif
+
 u64 module_emit_plt_entry(struct module *mod, Elf64_Shdr *sechdrs,
 			  void *loc, const Elf64_Rela *rela,
 			  Elf64_Sym *sym);
diff --git a/arch/arm64/include/asm/module.lds.h b/arch/arm64/include/asm/module.lds.h
index 603f92a8a73e..d754f3743487 100644
--- a/arch/arm64/include/asm/module.lds.h
+++ b/arch/arm64/include/asm/module.lds.h
@@ -4,7 +4,7 @@ SECTIONS {
 	.text.ftrace_trampoline 0 : { BYTE(0) }
 	.init.text.ftrace_trampoline 0 : { BYTE(0) }
 
-#ifdef CONFIG_UNWIND_TABLES
+#if defined(CONFIG_UNWIND_TABLES) && !defined(CONFIG_UNWINDER_DWARF_CFI)
 	/*
 	 * Currently, we only use unwind info at module load time, so we can
 	 * put it into the .init allocation.
diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index ee45b4e77347..3ee32cb68c5c 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -16,8 +16,10 @@
 #define perf_arch_fetch_caller_regs(regs, __ip) { \
 	(regs)->pc = (__ip);    \
 	(regs)->regs[29] = (unsigned long) __builtin_frame_address(0); \
+	(regs)->regs[30] = 0; \
 	(regs)->sp = current_stack_pointer; \
 	(regs)->pstate = PSR_MODE_EL1h;	\
+	(regs)->stackframe.type = FRAME_META_TYPE_CALLER; \
 }
 
 #endif
diff --git a/arch/arm64/include/asm/stacktrace/frame.h b/arch/arm64/include/asm/stacktrace/frame.h
index 796797b8db7e..b6138367d50f 100644
--- a/arch/arm64/include/asm/stacktrace/frame.h
+++ b/arch/arm64/include/asm/stacktrace/frame.h
@@ -18,12 +18,18 @@
  *   an arbitrary point in time.
  *   Unwinding should consume pt_regs::pc, followed by pt_regs::lr.
  *
+ * - FRAME_META_TYPE_CALLER
+ *
+ *   Synthetic caller-fetched struct pt_regs from perf_arch_fetch_caller_regs()
+ *   (not linked into the stack frame chain).
+ *
  * Note: all other values are reserved and should result in unwinding
  * terminating with an error.
  */
 #define FRAME_META_TYPE_NONE		0
 #define FRAME_META_TYPE_FINAL		1
 #define FRAME_META_TYPE_PT_REGS		2
+#define FRAME_META_TYPE_CALLER		3
 
 #ifndef __ASSEMBLER__
 /* 
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index fc5d1a0c38b3..a2507a4f7531 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -8,6 +8,9 @@ CFLAGS_armv8_deprecated.o := -I$(src)
 CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
+ifdef CONFIG_UNWINDER_DWARF_CFI
+CFLAGS_REMOVE_stacktrace.o = $(CC_FLAGS_FTRACE)
+endif
 
 # Remove stack protector to avoid triggering unneeded stack canary
 # checks due to randomize_kstack_offset.
@@ -24,6 +27,9 @@ KASAN_SANITIZE_stacktrace.o := n
 # inhibit KCOV instrumentation, disable it for the entire compilation unit.
 KCOV_INSTRUMENT_entry-common.o := n
 KCOV_INSTRUMENT_idle.o := n
+ifdef CONFIG_UNWINDER_DWARF_CFI
+KCOV_INSTRUMENT_stacktrace.o := n
+endif
 
 # Softirq stack switching can run outside interrupt context.
 KCOV_INSTRUMENT_irq.o := n
diff --git a/arch/arm64/kernel/ftrace.c b/arch/arm64/kernel/ftrace.c
index e1a3c0b3a051..5f9458a6b477 100644
--- a/arch/arm64/kernel/ftrace.c
+++ b/arch/arm64/kernel/ftrace.c
@@ -553,6 +553,14 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
 {
 	unsigned long return_hooker = (unsigned long)&return_to_handler;
 	unsigned long frame_pointer = arch_ftrace_regs(fregs)->fp;
+	/*
+	 * With -fomit-frame-pointer under CONFIG_UNWINDER_DWARF_CFI, nested
+	 * functions share x29, whereas each frame's entry SP (its DWARF CFA)
+	 * uniquely keys its shadow stack slot for ftrace_graph_ret_addr().
+	 */
+	unsigned long *retp = IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
+			      (unsigned long *)arch_ftrace_regs(fregs)->sp :
+			      (unsigned long *)frame_pointer;
 	unsigned long *parent = &arch_ftrace_regs(fregs)->lr;
 	unsigned long old;
 
@@ -561,10 +569,8 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
 
 	old = *parent;
 
-	if (!function_graph_enter_regs(old, ip, frame_pointer,
-				       (void *)frame_pointer, fregs)) {
+	if (!function_graph_enter_regs(old, ip, frame_pointer, retp, fregs))
 		*parent = return_hooker;
-	}
 }
 #else
 /*
diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
index 24adb581af0e..88d07ecf6e64 100644
--- a/arch/arm64/kernel/module.c
+++ b/arch/arm64/kernel/module.c
@@ -499,6 +499,8 @@ int module_finalize(const Elf_Ehdr *hdr,
 
 	if (scs_is_dynamic()) {
 		s = find_section(hdr, sechdrs, ".init.eh_frame");
+		if (!s)
+			s = find_section(hdr, sechdrs, ".eh_frame");
 		if (s) {
 			/*
 			 * Because we can reject modules that are malformed
@@ -515,5 +517,18 @@ int module_finalize(const Elf_Ehdr *hdr,
 		}
 	}
 
-	return module_init_ftrace_plt(hdr, sechdrs, me);
+	ret = module_init_ftrace_plt(hdr, sechdrs, me);
+	if (ret)
+		return ret;
+
+	s = find_section(hdr, sechdrs, ".eh_frame");
+	if (s && (s->sh_flags & SHF_ALLOC))
+		arm64_unwind_module_init(me, (void *)s->sh_addr, s->sh_size);
+
+	return 0;
+}
+
+void module_arch_cleanup(struct module *mod)
+{
+	arm64_unwind_module_cleanup(mod);
 }
diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index 4e0efad5caf2..eae1f2326efa 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -416,10 +416,13 @@ kprobe_ss_brk_handler(struct pt_regs *regs, unsigned long esr)
 int __kprobes
 kretprobe_brk_handler(struct pt_regs *regs, unsigned long esr)
 {
+	void *frame = IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
+		      (void *)regs->sp : (void *)regs->regs[29];
+
 	if (regs->pc != (unsigned long)__kretprobe_trampoline)
 		return DBG_HOOK_ERROR;
 
-	regs->pc = kretprobe_trampoline_handler(regs, (void *)regs->regs[29]);
+	regs->pc = kretprobe_trampoline_handler(regs, frame);
 	return DBG_HOOK_HANDLED;
 }
 
@@ -452,7 +455,14 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	ri->ret_addr = (kprobe_opcode_t *)regs->regs[30];
-	ri->fp = (void *)regs->regs[29];
+	/*
+	 * Under CONFIG_UNWINDER_DWARF_CFI (-fomit-frame-pointer), nested C
+	 * functions do not update x29; key the kretprobe instance on the
+	 * probed function's entry SP (its DWARF CFA), which matches regs->sp
+	 * upon returning to __kretprobe_trampoline.
+	 */
+	ri->fp = IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
+		 (void *)regs->sp : (void *)regs->regs[29];
 
 	/* replace return addr (x30) with trampoline */
 	regs->regs[30] = (long)&__kretprobe_trampoline;
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 3ebcf8c53fb0..d19dbd6982ac 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -10,16 +10,130 @@
 #include <linux/filter.h>
 #include <linux/ftrace.h>
 #include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/task_stack.h>
 #include <linux/stacktrace.h>
+#include <linux/unwind_dwarf_cfi.h>
 
 #include <asm/efi.h>
 #include <asm/irq.h>
+#include <asm/sections.h>
 #include <asm/stack_pointer.h>
 #include <asm/stacktrace.h>
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+static const struct dwarf_cfi_arch arm64_cfi_arch = {
+	.ws	= 8,
+	.sp_reg	= 31,	/* sp */
+	.fp_reg	= 29,	/* x29 */
+	.ra_reg	= 30,	/* x30 (lr) */
+};
+
+#ifdef CONFIG_MODULES
+/**
+ * arm64_unwind_module_init() - Build Minimal DWARF CFI index for a module
+ * @mod: Module being loaded.
+ * @eh_frame: Pointer to the module's SHF_ALLOC .eh_frame section.
+ * @eh_frame_size: Size in bytes of @eh_frame.
+ *
+ * Scans and sorts the module's FDEs and publishes the index to
+ * @mod->arch.dwarf_cfi_index for RCU-protected lockless unwinding.
+ */
+void arm64_unwind_module_init(struct module *mod, void *eh_frame,
+			      size_t eh_frame_size)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = dwarf_cfi_mod_alloc(eh_frame, eh_frame_size, &arm64_cfi_arch);
+	if (idx)
+		rcu_assign_pointer(mod->arch.dwarf_cfi_index, idx);
+}
+
+/**
+ * arm64_unwind_module_cleanup() - Unpublish and RCU-free module DWARF CFI index
+ * @mod: Module being unloaded or cleaned up after a failed load.
+ */
+void arm64_unwind_module_cleanup(struct module *mod)
+{
+	struct mod_dwarf_cfi_index *idx;
+
+	idx = rcu_replace_pointer(mod->arch.dwarf_cfi_index, /*ptr=*/NULL,
+				  /*c=*/true);
+	dwarf_cfi_mod_free_rcu(idx);
+}
+
+/**
+ * arm64_dwarf_cfi_module_find() - Look up Minimal DWARF CFI in loadable modules
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
+arm64_dwarf_cfi_module_find(unsigned long pc, struct dwarf_cfi_row *row)
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
+	ret = dwarf_cfi_mod_eval(idx, pc, &arm64_cfi_arch, row);
+	rcu_read_unlock_sched_notrace();
+	return ret;
+}
+#else
+static __always_inline int
+arm64_dwarf_cfi_module_find(unsigned long pc, struct dwarf_cfi_row *row)
+{
+	return -ENOENT;
+}
+#endif /* CONFIG_MODULES */
+
+/**
+ * arm64_dwarf_cfi_find() - Evaluate Minimal DWARF CFI for core or module @pc
+ * @pc: Kernel instruction pointer to look up.
+ * @row: Output evaluated Minimal DWARF CFI row.
+ *
+ * Return: 0 on success, -ENOENT if no FDE covers @pc, or a negative errno on
+ * malformed CFI data.
+ */
+static __always_inline int
+arm64_dwarf_cfi_find(unsigned long pc, struct dwarf_cfi_row *row)
+{
+	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
+	int err;
+
+	err = dwarf_cfi_unwind_eh_frame_hdr(__start_eh_frame_hdr, hdr_size,
+					    __start_eh_frame, __stop_eh_frame,
+					    pc, &arm64_cfi_arch, row);
+	if (!err)
+		return 0;
+
+	return arm64_dwarf_cfi_module_find(pc, row);
+}
+#endif /* CONFIG_UNWINDER_DWARF_CFI */
+
+/**
+ * enum kunwind_source - Origin of the current frame's PC during kernel unwind
+ * @KUNWIND_SOURCE_UNKNOWN: Uninitialized or invalid unwind state.
+ * @KUNWIND_SOURCE_FRAME: Unwound from a callee stack frame or return address.
+ * @KUNWIND_SOURCE_CALLER: Initialized from the immediate caller of the walker.
+ * @KUNWIND_SOURCE_TASK: Initialized from a blocked task's saved thread_struct.
+ * @KUNWIND_SOURCE_REGS_PC: Exact PC from an exception/interrupt &struct pt_regs.
+ */
 enum kunwind_source {
 	KUNWIND_SOURCE_UNKNOWN,
 	KUNWIND_SOURCE_FRAME,
@@ -36,37 +150,49 @@ union unwind_flags {
 	};
 };
 
-/*
- * Kernel unwind state
- *
- * @common:      Common unwind state.
- * @task:        The task being unwound.
- * @graph_idx:   Used by ftrace_graph_ret_addr() for optimized stack unwinding.
- * @kr_cur:      When KRETPROBES is selected, holds the kretprobe instance
- *               associated with the most recently encountered replacement lr
- *               value.
+/**
+ * struct kunwind_state - ARM64 kernel stack unwind iteration state
+ * @common: Common stack-bounds, PC, and FP unwind state.
+ * @task: The task being unwound.
+ * @sp: Current frame's stack pointer (equal to the callee's CFA after stepping).
+ * @lr: Saved link register (x30) when @lr_valid is true.
+ * @graph_idx: Shadow-stack cursor for ftrace_graph_ret_addr().
+ * @kr_cur: Cursor into @task->kretprobe_instances for kretprobe_find_ret_addr().
+ * @source: How @common.pc was obtained (&enum kunwind_source).
+ * @flags: Return-address recovery annotations (fgraph / kretprobe) for printing.
+ * @lr_valid: True if @lr holds a live return address for leaf/entry frames.
+ * @unreliable: True if an unannotated fallback (LR guess or non-CFI frame
+ *              record) was used, disqualifying reliable stacktraces.
  */
 struct kunwind_state {
 	struct unwind_state common;
 	struct task_struct *task;
+	unsigned long sp;
+	unsigned long lr;
 	int graph_idx;
 #ifdef CONFIG_KRETPROBES
 	struct llist_node *kr_cur;
 #endif
 	enum kunwind_source source;
 	union unwind_flags flags;
-	struct pt_regs *regs;
+	bool lr_valid;
+	bool unreliable;
 };
 
+static __always_inline int kunwind_next(struct kunwind_state *state);
+
 static __always_inline void
 kunwind_init(struct kunwind_state *state,
 	     struct task_struct *task)
 {
 	unwind_init_common(&state->common);
 	state->task = task;
+	state->sp = 0;
+	state->lr = 0;
+	state->lr_valid = false;
+	state->unreliable = false;
 	state->source = KUNWIND_SOURCE_UNKNOWN;
 	state->flags.all = 0;
-	state->regs = NULL;
 }
 
 /*
@@ -82,9 +208,11 @@ kunwind_init_from_regs(struct kunwind_state *state,
 {
 	kunwind_init(state, current);
 
-	state->regs = regs;
 	state->common.fp = regs->regs[29];
 	state->common.pc = regs->pc;
+	state->sp = regs->sp;
+	state->lr = regs->regs[30];
+	state->lr_valid = !!state->lr;
 	state->source = KUNWIND_SOURCE_REGS_PC;
 }
 
@@ -101,9 +229,29 @@ kunwind_init_from_caller(struct kunwind_state *state)
 {
 	kunwind_init(state, current);
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+	{
+		unsigned long pc, fp;
+
+		asm volatile("1: adr %0, 1b\n\t"
+			     "mov %1, x29"
+			     : "=r"(pc), "=r"(fp));
+		state->common.pc = pc;
+		state->common.fp = fp;
+		state->sp = current_stack_pointer;
+		state->lr = (unsigned long)__builtin_return_address(0);
+		state->lr_valid = true;
+		state->source = KUNWIND_SOURCE_REGS_PC;
+		if (!kunwind_next(state))
+			state->source = KUNWIND_SOURCE_CALLER;
+		else
+			state->source = KUNWIND_SOURCE_UNKNOWN;
+	}
+#else
 	state->common.fp = (unsigned long)__builtin_frame_address(1);
 	state->common.pc = (unsigned long)__builtin_return_address(0);
 	state->source = KUNWIND_SOURCE_CALLER;
+#endif
 }
 
 /*
@@ -124,21 +272,39 @@ kunwind_init_from_task(struct kunwind_state *state,
 
 	state->common.fp = thread_saved_fp(task);
 	state->common.pc = thread_saved_pc(task);
+	state->sp = thread_saved_sp(task);
 	state->source = KUNWIND_SOURCE_TASK;
 }
 
+/**
+ * kunwind_recover_return_address() - Restore fgraph/kretprobe return addresses
+ * @state: Current ARM64 kernel unwind state.
+ *
+ * Replaces return_to_handler and __kretprobe_trampoline return addresses with
+ * the original caller PC from @state->task's shadow stacks in either hooking
+ * order. Under CONFIG_UNWINDER_DWARF_CFI (-fomit-frame-pointer), entries are
+ * keyed on the frame's entry SP (@state->sp, equal to the callee's CFA) rather
+ * than x29.
+ *
+ * Return: 0 on success, or -EINVAL if a shadow return address cannot be found.
+ */
 static __always_inline int
 kunwind_recover_return_address(struct kunwind_state *state)
 {
+	void *frame_key __maybe_unused = IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
+					 (void *)state->sp :
+					 (void *)state->common.fp;
+
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
 	if (state->task->ret_stack &&
-	    (state->common.pc == (unsigned long)return_to_handler)) {
+	    state->common.pc == (unsigned long)return_to_handler) {
 		unsigned long orig_pc;
+
 		orig_pc = ftrace_graph_ret_addr(state->task, &state->graph_idx,
-						state->common.pc,
-						(void *)state->common.fp);
+						state->common.pc, frame_key);
 		if (state->common.pc == orig_pc) {
-			WARN_ON_ONCE(state->task == current);
+			WARN_ON_ONCE(state->task == current &&
+				     !state->unreliable);
 			return -EINVAL;
 		}
 		state->common.pc = orig_pc;
@@ -149,8 +315,8 @@ kunwind_recover_return_address(struct kunwind_state *state)
 #ifdef CONFIG_KRETPROBES
 	if (is_kretprobe_trampoline(state->common.pc)) {
 		unsigned long orig_pc;
-		orig_pc = kretprobe_find_ret_addr(state->task,
-						  (void *)state->common.fp,
+
+		orig_pc = kretprobe_find_ret_addr(state->task, frame_key,
 						  &state->kr_cur);
 		if (!orig_pc)
 			return -EINVAL;
@@ -159,6 +325,23 @@ kunwind_recover_return_address(struct kunwind_state *state)
 	}
 #endif /* CONFIG_KRETPROBES */
 
+#ifdef CONFIG_FUNCTION_GRAPH_TRACER
+	if (state->task->ret_stack &&
+	    state->common.pc == (unsigned long)return_to_handler) {
+		unsigned long orig_pc;
+
+		orig_pc = ftrace_graph_ret_addr(state->task, &state->graph_idx,
+						state->common.pc, frame_key);
+		if (state->common.pc == orig_pc) {
+			WARN_ON_ONCE(state->task == current &&
+				     !state->unreliable);
+			return -EINVAL;
+		}
+		state->common.pc = orig_pc;
+		state->flags.fgraph = 1;
+	}
+#endif /* CONFIG_FUNCTION_GRAPH_TRACER */
+
 	return 0;
 }
 
@@ -178,10 +361,11 @@ int kunwind_next_regs_pc(struct kunwind_state *state)
 	unwind_consume_stack(&state->common, info, (unsigned long)regs,
 			     sizeof(*regs));
 
-	state->regs = regs;
 	state->common.pc = regs->pc;
 	state->common.fp = regs->regs[29];
-	state->regs = NULL;
+	state->sp = regs->sp;
+	state->lr = regs->regs[30];
+	state->lr_valid = !!state->lr;
 	state->source = KUNWIND_SOURCE_REGS_PC;
 	return 0;
 }
@@ -201,11 +385,19 @@ kunwind_next_frame_record_meta(struct kunwind_state *state)
 	meta = (struct frame_record_meta *)fp;
 	switch (READ_ONCE(meta->type)) {
 	case FRAME_META_TYPE_FINAL:
-		if (meta == &task_pt_regs(tsk)->stackframe)
+		if (meta == &task_pt_regs(tsk)->stackframe) {
+			if (IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) &&
+			    state->sp != (unsigned long)task_pt_regs(tsk))
+				return -EINVAL;
 			return -ENOENT;
+		}
 		WARN_ON_ONCE(tsk == current);
 		return -EINVAL;
 	case FRAME_META_TYPE_PT_REGS:
+		if (IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) &&
+		    state->sp != (unsigned long)container_of(meta, struct pt_regs,
+							     stackframe))
+			return -EINVAL;
 		return kunwind_next_regs_pc(state);
 	default:
 		WARN_ON_ONCE(tsk == current);
@@ -244,6 +436,215 @@ kunwind_next_frame_record(struct kunwind_state *state)
 	return 0;
 }
 
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+/**
+ * kunwind_next_cfi() - Step one ARM64 kernel frame using Minimal DWARF CFI
+ * @state: Current ARM64 kernel unwind state.
+ *
+ * Evaluates the Minimal DWARF CFI table at @state->common.pc (or pc - 4 for
+ * call return addresses), validates stack bounds and monotonic stack
+ * consumption across task/IRQ/overflow/SDEI/EFI stacks, and handles ftrace
+ * trampolines, SP-verified exception frame_record_meta boundaries, and
+ * frame-pointer fallbacks for JITed BPF code.
+ *
+ * Return: 0 on success, -ENOENT at the final user/kthread boundary or an
+ * explicit DW_CFA_undefined root frame, or -EINVAL on invalid unwind state.
+ */
+static __always_inline int kunwind_next_cfi(struct kunwind_state *state)
+{
+	unsigned long lookup_pc, cfa, ra_addr = 0, new_pc, new_fp = state->common.fp;
+	struct stack_info *info, *ra_info = NULL;
+	struct dwarf_cfi_row row;
+	int err;
+
+	lookup_pc = (state->source == KUNWIND_SOURCE_REGS_PC) ?
+		    state->common.pc : state->common.pc - 4;
+
+	err = arm64_dwarf_cfi_find(lookup_pc, &row);
+	if (err) {
+		unsigned long old_fp = state->common.fp;
+
+#ifdef CONFIG_DYNAMIC_FTRACE_WITH_ARGS
+		if (lookup_pc >= (unsigned long)ftrace_caller &&
+		    lookup_pc < (unsigned long)ftrace_caller_end &&
+		    !(state->sp & 0x7)) {
+			struct __arch_ftrace_regs *fregs = (void *)state->sp;
+			size_t fsize = sizeof(*fregs) + 32;
+
+			info = unwind_find_stack(&state->common, state->sp, fsize);
+			if (info && READ_ONCE(fregs->sp) == state->sp + fsize) {
+				unwind_consume_stack(&state->common, info,
+						     state->sp, fsize);
+				state->common.pc = READ_ONCE(fregs->pc);
+				if (old_fp == state->sp + sizeof(*fregs))
+					state->common.fp = READ_ONCE(fregs->fp);
+				state->lr = ptrauth_strip_kernel_insn_pac(READ_ONCE(fregs->lr));
+				state->lr_valid = true;
+				state->sp += fsize;
+				state->source = KUNWIND_SOURCE_FRAME;
+				return 0;
+			}
+		}
+#endif
+		if (!(old_fp & 0x7) &&
+		    unwind_find_stack(&state->common, old_fp,
+				      sizeof(struct frame_record_meta))) {
+			struct frame_record_meta *m = (void *)old_fp;
+
+			if (state->sp == (unsigned long)container_of(m,
+								     struct pt_regs,
+								     stackframe) &&
+			    !READ_ONCE(m->record.fp) &&
+			    !READ_ONCE(m->record.lr))
+				return kunwind_next_frame_record_meta(state);
+		}
+
+		if (state->lr_valid && !is_bpf_text_address(lookup_pc)) {
+			state->common.pc = state->lr;
+			state->lr_valid = false;
+			state->source = KUNWIND_SOURCE_FRAME;
+			state->unreliable = true;
+			return 0;
+		}
+
+		info = !(old_fp & 0x7) ?
+		       unwind_find_stack(&state->common, old_fp,
+					 sizeof(struct frame_record)) : NULL;
+		if (!info ||
+		    (stackinfo_on_stack(info, state->sp, /*size=*/0) &&
+		     old_fp < state->sp)) {
+			if (state->lr_valid) {
+				state->common.pc = state->lr;
+				state->lr_valid = false;
+				state->source = KUNWIND_SOURCE_FRAME;
+				state->unreliable = true;
+				return 0;
+			}
+			return -EINVAL;
+		}
+
+		err = kunwind_next_frame_record(state);
+		if (!err && state->source == KUNWIND_SOURCE_FRAME) {
+			state->sp = old_fp + sizeof(struct frame_record);
+			state->lr_valid = false;
+			state->unreliable = true;
+		} else if (err && state->lr_valid) {
+			state->common.pc = state->lr;
+			state->lr_valid = false;
+			state->source = KUNWIND_SOURCE_FRAME;
+			state->unreliable = true;
+			return 0;
+		}
+		return err;
+	}
+
+	if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED)
+		return -ENOENT;
+
+	switch (row.cfa_base) {
+	case DWARF_CFI_BASE_SP:
+		cfa = state->sp + row.cfa_off;
+		break;
+	case DWARF_CFI_BASE_FP:
+		cfa = state->common.fp + row.cfa_off;
+		break;
+	case DWARF_CFI_BASE_FP_INDIRECT:
+		info = unwind_find_stack(&state->common,
+					 state->common.fp + row.cfa_off,
+					 sizeof(long));
+		if (!info)
+			return -EINVAL;
+		cfa = READ_ONCE(*(unsigned long *)(state->common.fp + row.cfa_off));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (cfa & 0x7)
+		return -EINVAL;
+
+	if (row.ra_rule == DWARF_CFI_RULE_SAME) {
+		if (!state->lr_valid) {
+			/*
+			 * Non-struct_ops BPF trampolines push a synthetic
+			 * parent frame record above the inner traced-function
+			 * frame record; consume it at the pre-prologue entry.
+			 */
+			if (state->unreliable &&
+			    row.cfa_base == DWARF_CFI_BASE_SP &&
+			    row.cfa_off == 0 &&
+			    state->common.fp == state->sp) {
+				unsigned long old_fp = state->common.fp;
+
+				err = kunwind_next_frame_record(state);
+				if (!err && state->source == KUNWIND_SOURCE_FRAME)
+					state->sp = old_fp + sizeof(struct frame_record);
+				return err;
+			}
+			return -EINVAL;
+		}
+		if (cfa < state->sp)
+			return -EINVAL;
+		new_pc = state->lr;
+	} else if (row.ra_rule == DWARF_CFI_RULE_OFFSET) {
+		ra_addr = cfa + row.ra_off;
+
+		ra_info = unwind_find_stack(&state->common, ra_addr, sizeof(long));
+		if (!ra_info || !stackinfo_on_stack(ra_info, cfa, /*size=*/0))
+			return -EINVAL;
+		new_pc = READ_ONCE(*(unsigned long *)ra_addr);
+	} else {
+		return -EINVAL;
+	}
+
+	if (row.fp_rule == DWARF_CFI_RULE_OFFSET) {
+		unsigned long fp_addr = cfa + row.fp_off;
+
+		info = unwind_find_stack(&state->common, fp_addr, sizeof(long));
+		if (!info)
+			return -EINVAL;
+		new_fp = READ_ONCE(*(unsigned long *)fp_addr);
+	} else if (row.fp_rule == DWARF_CFI_RULE_FP_OFFSET) {
+		unsigned long fp_addr = state->common.fp + row.fp_off;
+
+		info = unwind_find_stack(&state->common, fp_addr, sizeof(long));
+		if (!info)
+			return -EINVAL;
+		new_fp = READ_ONCE(*(unsigned long *)fp_addr);
+	}
+
+	if (row.ra_rule == DWARF_CFI_RULE_OFFSET) {
+		if (stackinfo_on_stack(ra_info, state->sp, /*size=*/0)) {
+			if (cfa <= state->sp ||
+			    !stackinfo_on_stack(ra_info, state->sp,
+						cfa - state->sp))
+				return -EINVAL;
+			unwind_consume_stack(&state->common, ra_info, state->sp,
+					     cfa - state->sp);
+		} else {
+			if (row.cfa_base == DWARF_CFI_BASE_SP || cfa <= ra_addr)
+				return -EINVAL;
+			unwind_consume_stack(&state->common, ra_info, ra_addr,
+					     cfa - ra_addr);
+		}
+	} else if (cfa > state->sp) {
+		info = unwind_find_stack(&state->common, state->sp,
+					 cfa - state->sp);
+		if (!info)
+			return -EINVAL;
+		unwind_consume_stack(&state->common, info, state->sp,
+				     cfa - state->sp);
+	}
+
+	state->sp = cfa;
+	state->common.fp = new_fp;
+	state->common.pc = new_pc;
+	state->lr_valid = false;
+	state->source = KUNWIND_SOURCE_FRAME;
+	return 0;
+}
+#endif /* CONFIG_UNWINDER_DWARF_CFI */
+
 /*
  * Unwind from one frame record (A) to the next frame record (B).
  *
@@ -263,7 +664,11 @@ kunwind_next(struct kunwind_state *state)
 	case KUNWIND_SOURCE_CALLER:
 	case KUNWIND_SOURCE_TASK:
 	case KUNWIND_SOURCE_REGS_PC:
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+		err = kunwind_next_cfi(state);
+#else
 		err = kunwind_next_frame_record(state);
+#endif
 		break;
 	default:
 		err = -EINVAL;
@@ -285,6 +690,9 @@ do_kunwind(struct kunwind_state *state, kunwind_consume_fn consume_state,
 {
 	int ret;
 
+	if (state->source == KUNWIND_SOURCE_UNKNOWN)
+		return -EINVAL;
+
 	ret = kunwind_recover_return_address(state);
 	if (ret)
 		return ret;
@@ -356,7 +764,26 @@ kunwind_stack_walk(kunwind_consume_fn consume_state,
 	if (regs) {
 		if (task != current)
 			return -EINVAL;
-		kunwind_init_from_regs(&state, regs);
+		if (IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) &&
+		    regs->stackframe.type == FRAME_META_TYPE_CALLER &&
+		    !regs->regs[30]) {
+			unsigned long target_pc =
+				ptrauth_strip_kernel_insn_pac(regs->pc);
+
+			kunwind_init_from_caller(&state);
+			while (state.source != KUNWIND_SOURCE_UNKNOWN &&
+			       (state.sp < regs->sp ||
+				(state.sp == regs->sp &&
+				 state.sp <= regs->regs[29] &&
+				 state.common.pc != target_pc))) {
+				if (kunwind_next(&state)) {
+					state.source = KUNWIND_SOURCE_UNKNOWN;
+					break;
+				}
+			}
+		} else {
+			kunwind_init_from_regs(&state, regs);
+		}
 	} else if (task == current) {
 		kunwind_init_from_caller(&state);
 	} else {
@@ -401,7 +828,7 @@ arch_reliable_kunwind_consume_entry(const struct kunwind_state *state, void *coo
 	 * All that matters is whether the *entire* unwind is reliable, so give
 	 * up as soon as we hit an exception boundary.
 	 */
-	if (state->source == KUNWIND_SOURCE_REGS_PC)
+	if (state->source == KUNWIND_SOURCE_REGS_PC || state->unreliable)
 		return false;
 
 	return arch_kunwind_consume_entry(state, cookie);
@@ -474,8 +901,8 @@ static bool dump_backtrace_entry(const struct kunwind_state *state, void *arg)
 	return true;
 }
 
-void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
-		    const char *loglvl)
+noinline void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk,
+			     const char *loglvl)
 {
 	pr_debug("%s(regs = %p tsk = %p)\n", __func__, regs, tsk);
 
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index f6619e1cb2ce..94f1ad06c6ab 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -35,13 +35,16 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 
 # -Wmissing-prototypes and -Wmissing-declarations are removed from
 # the CFLAGS to make possible to build the kernel with CONFIG_WERROR enabled.
-CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
+CC_FLAGS_REMOVE_VDSO := $(CC_FLAGS_FTRACE) -Os -fomit-frame-pointer \
+			$(CC_FLAGS_SCS) \
 			$(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
 			$(GCC_PLUGINS_CFLAGS) \
 			$(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
 			-Wmissing-prototypes -Wmissing-declarations
 
-CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fasynchronous-unwind-tables $(CONFIG_CC_OPT_INLINE_MEMSET)
+CC_FLAGS_ADD_VDSO := -O2 -mcmodel=tiny -fno-omit-frame-pointer \
+		     -fasynchronous-unwind-tables \
+		     $(CONFIG_CC_OPT_INLINE_MEMSET)
 
 CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_REMOVE_VDSO)
 CFLAGS_REMOVE_vgetrandom.o = $(CC_FLAGS_REMOVE_VDSO)
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index c95243a8b24e..3d70eb12fa11 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -144,7 +144,23 @@ jiffies = jiffies_64;
 #define TRAMP_TEXT
 #endif
 
-#ifdef CONFIG_UNWIND_TABLES
+#ifdef CONFIG_UNWINDER_DWARF_CFI
+#define UNWIND_RODATA_SECTIONS				\
+	.eh_frame_hdr : ALIGN(4) {			\
+		__start_eh_frame_hdr = .;		\
+		*(.eh_frame_hdr)			\
+		__stop_eh_frame_hdr = .;		\
+	}						\
+	.eh_frame : ALIGN(8) {				\
+		__start_eh_frame = .;			\
+		__pi___eh_frame_start = .;		\
+		*(.eh_frame)				\
+		__pi___eh_frame_end = .;		\
+		__stop_eh_frame = .;			\
+	}
+#define UNWIND_DATA_SECTIONS
+#elif defined(CONFIG_UNWIND_TABLES)
+#define UNWIND_RODATA_SECTIONS
 #define UNWIND_DATA_SECTIONS				\
 	.eh_frame : {					\
 		__pi___eh_frame_start = .;		\
@@ -152,6 +168,7 @@ jiffies = jiffies_64;
 		__pi___eh_frame_end = .;		\
 	}
 #else
+#define UNWIND_RODATA_SECTIONS
 #define UNWIND_DATA_SECTIONS
 #endif
 
@@ -212,6 +229,8 @@ SECTIONS
 	/* everything from this point to __init_begin will be marked RO NX */
 	RO_DATA(PAGE_SIZE)
 
+	UNWIND_RODATA_SECTIONS
+
 	HYPERVISOR_RODATA_SECTIONS
 
 #ifdef CONFIG_NVHE_EL2_TRACING
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 56a7e2c05f73..bb9907b8ec7f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -104,6 +104,7 @@ KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAG
 # when profile optimization is applied. gen-hyprel does not support SHT_REL and
 # causes a build failure. Remove profile optimization flags.
 KBUILD_CFLAGS := $(filter-out -fprofile-sample-use=% -fprofile-use=%, $(KBUILD_CFLAGS))
+KBUILD_CFLAGS := $(filter-out -fomit-frame-pointer, $(KBUILD_CFLAGS)) -fno-omit-frame-pointer
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables -fno-unwind-tables
 
 ifeq ($(CONFIG_UBSAN_KVM_EL2),y)
-- 
2.56.1.831.g720f3f5937-goog

