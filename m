Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795587358;
	b=UIPAGEqOfKjmEAA+snJYWCgf+AzcY7WtLUgbBWIaEegE8HlhWeQpH376cRGr2bPo3BO9
	 PO5FQVuSY28LRukZP5UcILT0NMSbRyTXKsPRU3Pe1ysfgbI9BVT1Jbwxkufy/6RK39swj
	 w5CpwLnsiAm6vBe6CjxR4Oi+MRmwfWIiilpCHi7CNzPjh5Ll3TRFAat/5v4kauuSuy4FS
	 p+XjOh3RpVf5TrVuNHyM5fkbh+vqP/WlzKpy2vYgyk+1qBsmTMtguxa00CWWuFKapheIE
	 fj/SBSF6Bw/2NE6Ejju0fSme9ITDq/3NLbuHuot7QXLhm8eh2QUXQPxqfSXfR8iMFaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795587358;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=7xQ7NQnXECoY8+/yfLsStJxpA4NcSbywn4gyy8dqi20=;
	b=ncHX2t+CShvWYwoyJ3Ab2M9drZTmcAJ4rjAnAjs1fo92h0HrvAARi5QVcPn57d5+J6y6
	 fPW5LwByyEREauwIdKzjxjtAvS/WLZBl+cGR7ajGdnN7nba4clu5VBWEthRa/dQrK+r/g
	 CyPWdSI/1nPGiRcs7JnVPSh0P/oCLeorgJCHyZFNe75gkqIlIfeH9sZBJ1tRzL+OR3/my
	 v8Mw3zwDZxiVURWXCMH0CUd+Kkj7bZDEOpWCjqW05EMx46PM4a6+CTgy/ZQ1cq3p7j3Pu
	 6avJR1EO2Pg5XXWZ21IdGXGu1OS4cD5cq9Hn8mSfz9E6TkXqA4q6ZrcdmaOGny4Uhcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=js0NsWmq;
	arc=none smtp.remote-ip=74.125.82.198
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1819606A321
	for <linux-efi@vger.kernel.org>; Wed, 25 Nov 2026 06:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1819606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=js0NsWmq
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3854627c1c8so7655879eec.1
        for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 22:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795587357; x=1796192157; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7xQ7NQnXECoY8+/yfLsStJxpA4NcSbywn4gyy8dqi20=;
        b=js0NsWmqTSs38AoojFsBC+QO+eY0tQPsjNHSMydFQ4TxPJQn5iTNomjZYZPzwU1A4h
         xklPboiiKq6louV5RWzS3rkJw6O22dSkHVXbTvJPkdRyFmVnQWT7V+9r4LShPtSnujjT
         JFDryWb+JHEX87aWlwXqI+i4hZCVu7EphP+yob7Yc/Nxj0cV1jsSVMcpqycvYPJWdma+
         KUUaQ7KEf8Yi8nl8re7GHADi2eL7jhC+BxGrT5XdQMftaRP4wZAUtZ2zpiLqjR4Wofah
         DGTlSQOswLg4ICBAucaA82O7Q4Ue/vJLIdcv8OdtYQvwY6QghIWDPwS1/Ew6Ql2wPWzm
         d5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795587357; x=1796192157;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7xQ7NQnXECoY8+/yfLsStJxpA4NcSbywn4gyy8dqi20=;
        b=WtdCKNgDgZLcSGYv/uVscZyaffJLkfGvkUbWBnQMMg005Pa30RWsWHoT7E508t8AvP
         8DSy0Oc/RI0mEEDFesIWGo/xhkazkS4Cd2+CHZu18k7u+ZX4+ZX6c5pLRPbHFoN2JhMd
         KKV168MrUhj6iVq+nCKgJvyfN1yIbyWvUuc4JblfWs7t0fCYFvoXAgcmkiMlNJ6hYMWi
         wFKE4EMtzNvdevibl02NgPav11V9SUpjk/e5m4KjygvKzYokWNkYefA1RNmwLGE0z1GS
         A0mfg4Te/Ud6YqUdWYqB65LTKOrRByjwzb/515EapB6+WEHI2nnaGWnqXgmPHKdClaTv
         txaQ==
X-Forwarded-Encrypted: i=1; AL+hErFxifF0ZgbEHNTtWuVyCB3dJexZbs7ORqPRjH7OZ8mrbO0tt16reYU5uM5nsq08nMymNT9VAGu2x+E=@vger.kernel.org
X-Gm-Message-State: APuU4Z9Y2ZPZxQ/VnwV6UJa6qog/aM/Vu4Dgeu7jg20u4p/rL49l2kfF
	NeyhzBMmLpRI7071wfKaH015q45r9w4a6IY38uNWDahgSNoX2/IAGL+4TNYbYOTEDoq7tZD8mRw
	ihPdUS5ZIxg==
X-Received: from dycc21.prod.google.com ([2002:a05:693c:60d5:b0:36d:8068:9180])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:6187:10b0:386:a193:7eeb
 with SMTP id 5a478bee46e88-386a1938b8dmr12337005eec.30.1795587356364; Tue, 24
 Nov 2026 22:15:56 -0800 (PST)
Date: Tue, 24 Nov 2026 22:14:53 -0800
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.831.g720f3f5937-goog
Message-ID: <20261125061523.1540234-1-irogers@google.com>
Subject: [RFC PATCH v2 00/30] unwind: Minimal DWARF CFI unwinding for user and
 kernel space
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

Overview
========

This RFC v2 series introduces Minimal DWARF Call Frame Information (CFI)
stack unwinding in the Linux kernel for both user-space deferred
callchains (unwind_user / PERF_RECORD_CALLCHAIN_DEFERRED) and
kernel-space stack traces (stacktrace.h / HAVE_RELIABLE_STACKTRACE)
across x86-64, ARM64, and RISC-V, paired with an optional standalone C
build-time .eh_frame minifier (scripts/min_eh_frame.c).

It enables reliable stack unwinding across kernel and user-space
binaries compiled with or without frame pointers (-fomit-frame-pointer),
without introducing duplicate .sframe sections in user-space ELF files
or requiring new compiler, assembler, or dynamic-loader formats.


Changes in v2
=============
Link: https://lore.kernel.org/r/20261122235757.3456048-1-irogers@google.com/

Addressed review findings from Sashiko and BPF CI on RFC v1:
 - Cross-config & non-UNWIND_USER build fixes: Guard default
   unwind_user_frame_pointer() with CONFIG_HAVE_UNWIND_USER_FP (fixes
   s390/loongarch builds); guard x86 is_rethook_trampoline() with
   CONFIG_RETHOOK; guard RISC-V struct mod_arch_specific with
   CONFIG_HAVE_MOD_ARCH_SPECIFIC; guard live KUnit stack walk with
   CONFIG_STACKTRACE; fix UNWINDER_DWARF_CFI_MINIFY Kconfig dependencies
   and unlock LATENCYTOP / FAULT_INJECTION_STACKTRACE_FILTER.
 - Core interpreter & module hardening (dwarf_cfi.c): Mask
   DW_EH_PE_SIGNED on slow-path FDE pc_range decoding; switch module
   table allocation to kvmalloc()/kvfree_rcu_mightsleep(); mark kernel
   unwind entry points noinstr; add kmsan_unpoison_memory() on outputs
   under KMSAN_SANITIZE := n; clarify DW_EH_PE_indirect wording; and add
   KUnit coverage for CALLER_ADDR0/1, 32-bit vdso32 sigreturn, negative
   sdata4 ranges, and dwarf_cfi_scan_eh_frame_kmem().
 - User-space SP tracking & compat fixes: Track DW_CFA_offset on sp_reg
   so 32-bit x86 vdso32 __kernel_rt_sigreturn recovers %esp from
   sigcontext; track state->sp_valid (unwind_user_fp_sets_sp() == false
   on ARM64) across mixed CFI -> FP -> CFI walks and ARM64 sigreturn;
   strip Thumb bit 0 in ARM64 compat unwind_user_strip_pac(); drop
   redundant get_user_word() wrapper checks; and skip unwind_user_cfi
   gracefully on 32-bit ARM EHABI binaries lacking PT_GNU_EH_FRAME.
 - Architecture kernel unwinder fixes: Reject in-kernel pt_regs frames
   in x86 arch_stack_walk_reliable() under CONFIG_UNWINDER_DWARF_CFI
   (where inline asm such as pushf; pop lacks .cfi_adjust_cfa_offset) and
   align kernel/trace/ ftrace stack-skip calibration with ORC; replace
   eager CFI walks in ARM64 and RISC-V perf_arch_fetch_caller_regs()
   with fast inline markers resolved lazily during callchain walks;
   preserve -fno-omit-frame-pointer in the ARM64 user vDSO; fix ARM64
   ftrace_caller epilogue matching via fregs->sp; save RV_REG_RA
   unconditionally in RV64 BPF JIT prologues under UNWINDER_DWARF_CFI;
   add -fno-optimize-sibling-calls to RISC-V stacktrace.o; and accept
   size == 0 at exact stack top in riscv_stack_bounds().
 - Host tools & MAINTAINERS: Add tools/unwind/verify_cfi (optional
   standalone libLLVM verifier cross-checking kernel/unwind/dwarf_cfi.c
   against reference DWARF, multi-arch CFG instruction execution, and
   x86-64 .orc_unwind), add /min_eh_frame to scripts/.gitignore, use
   explicit little-endian ELF field accessors in scripts/min_eh_frame.c
   for big-endian build hosts, fix i386 DRAP register set, malformed
   SLEB128 handling, and .o/.ko summary formatting in eh_frame_min.py, and
   add a MAINTAINERS entry for DWARF CFI stack unwinding (plus
   arch/*/include/asm/unwind_user*.h under USERSPACE STACK UNWINDING).


Motivation
==========

1. Limitations of Frame-Pointer-Only Unwinding
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 - Ecosystem defaults: Many Linux distributions (e.g., Debian, RHEL,
   Alpine), language toolchains, and prebuilt third-party shared
   libraries compile with -fomit-frame-pointer by default. A single
   frameless shared library in a call path breaks frame-pointer walks.
 - Completeness and reliability: Even with -fno-omit-frame-pointer,
   frame-pointer chains miss callers inside leaf functions, function
   prologues/epilogues, and hand-written assembly routines (such as
   libc string/math/crypto primitives), and cannot guarantee reliable
   kernel stack traces across asynchronous boundaries without external
   validation such as objtool.

2. Drawbacks of SFrame (PT_GNU_SFRAME)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SFrame was proposed as a simplified out-of-band unwind format to avoid
placing a full DWARF .eh_frame virtual machine in the kernel. In
practice, introducing a second unwind format carries substantial costs:

 - ~2x user-space unwind metadata bloat: User-space ELF executables and
   shared libraries must already ship .eh_frame and .eh_frame_hdr
   (PT_GNU_EH_FRAME) for C++ exceptions, Rust panics, pthread_cancel
   forced unwinding, and _Unwind_Backtrace(). Because SFrame omits
   callee-saved register locations, personality routines, and LSDA
   pointers, it cannot replace .eh_frame. On binaries built with GNU
   Binutils 2.47 (SFRAME_VERSION_3), .sframe is nearly the same size as
   .eh_frame + .eh_frame_hdr combined (e.g., +123.9 KB atop 124.1 KB in
   /bin/bash, and +164.5 KB atop 163.5 KB in aarch64-linux-gnu-gcc-15),
   roughly doubling unwind table footprint on disk.
 - Toolchain and architecture gaps: SFrame has gone through incompatible
   binary format revisions (v1 -> v2 -> v3), lacks upstream Clang/LLVM
   support, lacks RISC-V -mrelax linker-relaxation support in standard
   binutils, and requires new build flags (-Wa,--gsframe) across the
   entire user-space ecosystem before profiling benefits materialize.
 - Expressiveness gaps and dropped FDEs: SFrame cannot represent
   dynamically realigned DRAP stack frames (CFA = *(fp + off), e.g.,
   64-byte aligned locals in mm/vmscan.c:shrink_lruvec()), and GNU as
   --gsframe silently omits .sframe FDEs when hand-written assembly uses
   non-standard CFI patterns (for example, warning "no SFrame FDE
   emitted; FP without RA on stack" on ARM64's return_to_handler).

3. Core Insight of Minimal DWARF CFI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Historically, in-kernel DWARF .eh_frame unwinding was rejected for two
reasons:

 1. Execution context (predating deferred stack traces): Earlier
    proposals predated deferred user-space stack tracing for perf and
    BPF (unwind_deferred / PERF_RECORD_CALLCHAIN_DEFERRED). When user
    callchains could only be captured synchronously inside NMI/atomic
    context under pagefault_disable(), the kernel could neither take
    mmap_lock to locate PT_GNU_EH_FRAME VMAs nor fault in cold
    .eh_frame pages (forcing perf --call-graph dwarf to copy 8-64 KB of
    raw user stack per sample). Upstream's deferred task_work unwind
    infrastructure now solves that faultability barrier for any
    table-based user unwinder.
 2. Unrestricted DWARF state-machine complexity: Full DWARF permits
    Turing-complete DW_OP_* expressions, arbitrary N-register tracking
    arrays, DW_CFA_set_loc backward PC jumps, and DW_EH_PE_indirect
    pointer dereferences.

With deferred unwinding solving (1) for user space (while kernel
.eh_frame tables remain pinned in RAM for NMI/atomic walks), (2) is
solved if an in-kernel .eh_frame_hdr / .eh_frame interpreter restricts
its state machine to the exact state model of SFrame -- tracking only
CFA, SP (for signal frames), Frame Pointer (FP), and Return Address (RA),
plus link-register leaf state, ARM64 PAC-RET signing (0x2d), a 4-entry
remember_state stack, and a fixed 3-byte pattern match for DRAP/sigreturn
frames while decoding and discarding general callee-saved GPR spill
opcodes:

 - O(1) stack memory, zero heap allocations, zero locks in the core
   interpreter, and strictly bounded single-pass execution;
 - Smaller unwind metadata than SFrame by construction: SFrame stores
   materialized table rows (re-emitting full CFA/FP/RA offsets on every
   FRE, plus an explicit PC+0 entry FRE per function because there is no
   shared CIE), whereas DWARF encodes delta-compressed bytecodes (6-bit
   packed PC advances, alignment-scaled LEB128 deltas for only the rule
   that changed, 1-byte remember/restore_state, and a single 20-24 B CIE
   shared across ~70,000 FDEs). Once unneeded GPR spill ops are stripped,
   minified DWARF is naturally smaller than SFrame;
 - Immediate compatibility with existing unmodified Linux binaries and
   libc.so.6 across x86 (64/32-bit), ARM64 (AArch64/AArch32), and
   RISC-V (RV64/RV32) built with either GCC or Clang/LLVM;
 - 100.00% FDE coverage across x86_64, arm64, and riscv vmlinux builds
   (195,019 / 195,019 functions).

(ARM64 already has in-tree precedent in arch/arm64/kernel/pi/patch-scs.c,
which parses .eh_frame CIEs/FDEs in ~180 lines with zero allocations;
this series preserves __pi___eh_frame_* so Dynamic Shadow Call Stack
boot-time patching continues to work unchanged.)


Comparison with Related Upstream .eh_frame Proposals
====================================================

Two recent upstream RFC series independently arrived at DWARF .eh_frame
as a practical alternative to SFrame:

1. Jens Remus -- unwind_user .eh_frame Handling (x86-64, s390)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Link: https://lore.kernel.org/r/20260821195259.2688377-1-jremus@linux.ibm.com/

Jens's 24-patch RFC v2 shares the same core user-space motivation and
safety model: reusing existing .eh_frame_hdr / .eh_frame sections over
deferred unwind_user without a general DWARF expression VM, evaluating
only CFA/SP/FP/RA rules and fixed-pattern expressions (such as x86 DRAP
and PLT entries). Key differences in this series:

 - Unified user and kernel engine: Jens's series targets user-space
   deferred unwinding only (x86-64 and s390). This series uses a single
   noinstr-safe core interpreter (kernel/unwind/dwarf_cfi.c) across both
   user-space and kernel-space (NMI/IRQ and HAVE_RELIABLE_STACKTRACE)
   unwinding on x86-64, ARM64, and RISC-V, paired with build-time
   minification (scripts/min_eh_frame.c) and static multi-oracle
   verification (tools/unwind/verify_cfi).
 - Zero-registration VMA lookup vs. mm maple tree + prctl(): Following
   earlier sframe_register() designs, Jens's series registers executable
   .eh_frame_hdr sections in fs/binfmt_elf.c into a per-mm maple tree
   (mm->eh_frame_mt, duplicated across fork/clone) and adds UAPI
   prctl(PR_REGISTER_EH_FRAME / PR_UNREGISTER_EH_FRAME), requiring
   dynamic-linker (ld.so) patches before shared libraries can be
   unwound. Here, kernel/unwind/user_cfi.c resolves PT_GNU_EH_FRAME
   directly from mapped ELF VMAs (vm_pgoff == 0) on demand with a 4-slot
   per-walk VMA cache -- requiring zero mm_struct state, zero fork/clone
   duplication, zero new UAPI, and zero libc/ld.so changes to unwind
   unmodified shared libraries today.
 - Signal frames, 32-bit compat, and per-frame FP fallback: Jens's RFC
   v2 leaves signal frames and 32-bit compat as future work and caps
   remember_state depth at 1. This series unwinds signal frames across
   x86-64, 32-bit vdso32, ARM64, and RISC-V (including SA_ONSTACK and
   interrupted leaf functions), supports 32-bit compat tasks (IA-32,
   AArch32, RV32), supports 4-deep remember_state stacks, and falls back
   per frame (CFI -> FP -> CFI) across anonymous JIT code. Conversely,
   Jens's s390 port (CFA = SP_callsite + 160) and 11-byte x86 PLT
   expression pattern are clean additions that fit naturally into this
   model.

2. Dylan Hatch -- ARM64 .lr_unwind Reliable Stacktrace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Link: https://lore.kernel.org/r/20261117043504.1021063-1-dylanbhatch@google.com/
Link: https://lore.kernel.org/r/20261117043504.1021063-3-dylanbhatch@google.com/

Dylan's 12-patch RFC (with Weinan Liu) also builds ARM64 from compiler
.eh_frame tables rather than SFrame for Clang/LLVM compatibility,
factoring arch/arm64/kernel/pi/patch-scs.c's parser into <asm/eh_frame.h>
and distilling .eh_frame at build time (scripts/gen_lr_unwind) into
custom .lr_unwind_fde / .lr_unwind_ranges sections (~800-935 KiB). Key
differences and trade-offs:

 - Frameless (-fomit-frame-pointer) multi-arch unwinder vs. ARM64 FP
   companion table: .lr_unwind retains -fno-omit-frame-pointer across the
   ARM64 kernel and encodes only 3 exception-boundary states (LIVE x30,
   [x29], or [sp + sp_off]) to step across pt_regs before handing off to
   standard x29 frame-pointer walks (omitting frameless x30-spilling
   functions). This series eliminates the frame-pointer overhead across
   x86-64, ARM64, and RISC-V (-fomit-frame-pointer), keeps standard
   minified .eh_frame + .eh_frame_hdr (~2.72 MB on ARM64 vmlinux,
   preserving gdb/crash compatibility without a custom section format or
   sorttable pass), covers 100.00% of vmlinux FDEs, and shares the same
   interpreter with user-space unwinding.
 - Asynchronous pt_regs exception boundaries and CFI verification:
   .lr_unwind specifically targets reliable stacktraces across in-kernel
   pt_regs interrupt boundaries on ARM64 (including annotating crypto/lib
   leaf assembly via SYM_LEAF_FUNC_START), whereas this series
   conservatively rejects in-kernel pt_regs boundaries in
   arch_stack_walk_reliable() today. Notably, running our CFG
   instruction-execution verifier (tools/unwind/verify_cfi) on ARM64
   vmlinux shows why instruction-level validation is needed before
   trusting pt_regs boundaries for livepatching: GCC 15.2 mis-schedules
   epilogue .cfi directives on certain __builtin_frame_address(0) frames
   with outgoing stack arguments (affecting .eh_frame, .sframe, and
   .eh_frame-derived tables such as .lr_unwind alike). Dylan's leaf
   assembly CFI annotations and kunwind_next_cfi()'s existing live-LR vs.
   stack-LR handling at KUNWIND_SOURCE_REGS_PC are directly complementary
   once compiler and assembly asynchronous CFI passes verify_cfi.


Benefits vs. Drawbacks and Trade-offs
=====================================

Benefits
~~~~~~~~
 1. Zero duplicate user-space metadata: Reuses existing PT_GNU_EH_FRAME
    tables already present in standard ELF binaries (~50% smaller total
    unwind metadata than shipping both .eh_frame* and .sframe).
 2. Toolchain and ecosystem readiness: Works out of the box with GCC and
    Clang/LLVM, C and Rust kernel code, RISC-V -mrelax linker
    relaxation, x86 IA32 and ARM32/RV32 compat user binaries, and
    existing distro root filesystems.
 3. Smaller kernel unwind tables: With build-time .eh_frame minification
    (scripts/min_eh_frame.c), kernel .eh_frame tables are 18%-28%
    smaller than SFrame v3 (.sframe) in .o objects and 26.5% smaller
    than x86-64 ORC (~3.16 MB for .eh_frame + .eh_frame_hdr vs. ~4.30 MB
    for .orc_unwind* on x86-64 vmlinux). On ARM64 vmlinux, even combined
    minified .eh_frame + .eh_frame_hdr (2.72 MB) is smaller than linked
    .sframe alone (2.80 MB).
 4. Full frame-shape coverage: Unwinds SP-based frames, VLA/alloca FP
    frames, 64-byte DRAP stack-realigned frames, shrink-wrapped
    prologues/epilogues, ARM64 PAC-RET frames, signal trampolines
    (including SA_ONSTACK, 32-bit vdso32 sigreturn, and interrupted leaf
    functions), and mixed CFI + JIT frame-pointer stacks.

Drawbacks and Limitations
~~~~~~~~~~~~~~~~~~~~~~~~~
 1. Higher per-frame CPU cost than FP, ORC, or SFrame: Interpreting
    linear FDE CFA bytecodes from function entry to target PC takes
    ~47-51 ns/frame (~185-202 cycles) in the hardened C interpreter,
    compared to ~1 ns/frame for frame pointers and ~19 ns/frame for
    fixed-record SFrame/ORC lookups. This is negligible for crash/oops
    dumps, /proc/<tid>/stack, livepatch transitions, and amortized
    task_work user walks, though slightly costlier than ORC if kernel
    callchains are sampled at very high PMU NMI frequencies.
 2. User-space CFI requires deferred task_work context (not NMI): Just
    like user-space SFrame, user .eh_frame* sections live in cold,
    demand-paged user VMAs that cannot be faulted in or VMA-resolved
    under NMI/IRQ (pagefault_disable() / mmap_lock). Synchronous
    perf_callchain_user() in NMI remains FP-only; user CFI runs via
    PERF_RECORD_CALLCHAIN_DEFERRED on return to user space. If an NMI
    fires mid-syscall before execve(), munmap()/dlclose(), or pending
    signal delivery, exit-time user state can differ slightly from
    NMI-time state. (Note: the kernel also must not auto-enable
    defer_callchain behind unaware perf_event_open() callers, as doing
    so alters the PERF_RECORD_SAMPLE ips[] ABI; defaulting belongs in
    user-space tools/perf after probing kernel support.)
 3. Build-time minifier host pass and stripped GPR rules: Achieving
    smaller-than-SFrame kernel .eh_frame sizes uses a fast host C pass
    (scripts/min_eh_frame.c) on .o files until compilers offer an
    optional -funwind-tables=minimal flag under -fno-exceptions. When
    minification is enabled on vmlinux, PC/SP/FP backtraces in gdb/crash
    work normally, but inspecting spilled callee-saved GPRs in outer
    frames requires .debug_frame (or leaving
    CONFIG_UNWINDER_DWARF_CFI_MINIFY disabled on debug builds).
 4. Reliance on compiler and assembly .cfi_* annotations: Unlike x86
    objtool (which validates machine instructions directly), .eh_frame
    (like .sframe) trusts compiler -fasynchronous-unwind-tables output
    and manual .cfi_* annotations in hand-written .S / inline-asm code.
    For this reason, arch_stack_walk_reliable() across x86-64, ARM64,
    and RISC-V conservatively rejects stacks containing in-kernel
    asynchronous exception/preemption pt_regs boundaries (matching
    Documentation/livepatch/reliable-stacktrace.rst), while unwinding
    normal sleeping/synchronous tasks reliably without frame pointers.
 5. Hard interpreter bounds: Pathological FDEs with > 4,096 bytes of
    bytecode or DW_CFA_remember_state depth > 4 are rejected with
    -EINVAL (falling back to FP in user space). Across all 195,019
    vmlinux FDEs on x86-64, ARM64, and RISC-V, 0 FDEs hit the size bound
    and the maximum observed remember_state depth is 1.


Execution Contexts and Fallback Mechanics
=========================================

1. When Kernel-Space vs. User-Space CFI Can Run
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Context                     Kernel CFI   User CFI     Notes
  --------------------------  -----------  -----------  -------------------
  PMU NMI (in_nmi())          Yes (direct) No (defer)   Pinned vmlinux/RCU
                                                        mod vs. cold VMAs
  Hardirq / Softirq / BPF     Yes (direct) No (defer)   bpf_get_stack[id];
                                                        user sync = FP-only
  Return-to-user task_work    Yes          Yes (faults) mmap_read_lock then
                                                        copy_from_user()
  Cross-task /proc/tid/stack  Yes          No           current->mm only
  Livepatch reliable walk     Yes (all 3)  N/A          Kernel-only API
  Kernel threads / x86 VM86   Yes (kthd)   No           mm == NULL / 16-bit

Whenever user-space CFI cannot run synchronously (for example,
non-deferred perf_callchain_user() or atomic bpf_get_stack() /
bpf_get_stackid() with BPF_F_USER_STACK in NMI, IRQ, or preempt-disabled
context), the kernel falls back to the existing synchronous
frame-pointer user stack walk (arch_stack_walk_user()) just as it does
today. When deferred user unwinding is requested in NMI,
unwind_deferred_request() takes ~10-20 ns and emits
[PERF_CONTEXT_USER_DEFERRED, cookie]; even if dozens of PMU NMIs fire
during a slow syscall, unwind_user_faultable() walks the user stack at
most once on return to user space.

2. Per-Frame User-Space Fallback (CFI -> FP -> CFI)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
unwind_user_next() (kernel/unwind/user.c) evaluates each frame
independently rather than locking an entire walk to one unwinder:

 1. Architectural signal trampoline hook (unwind_user_sigreturn()):
    Checked first (bounded to UNWIND_USER_MAX_SIGNALS = 4 per walk so
    SA_ONSTACK switches cannot loop). On ARM64 (__kernel_rt_sigreturn)
    and RISC-V (__vdso_rt_sigreturn), where vDSO trampolines omit
    .eh_frame register rules for libgcc compatibility, recovers pc, sp,
    fp, and lr/ra (with ra_valid = true, sp_valid = true) from
    rt_sigframe. On x86-64 and 32-bit vdso32, .cfi_signal_frame ('S'
    augmentation, including CFI_OFFSET esp) is handled directly by CFI.
 2. Minimal DWARF CFI (highest priority):
    Resolves PT_GNU_EH_FRAME via a 4-slot per-walk VMA cache (or under
    mmap_read_lock_killable(), dropped before copy_from_user()):
     - Explicit bottom of stack (DW_CFA_undefined on RA, or RA == 0):
       sets state->done = true and stops cleanly without FP fallback.
     - Missing PT_GNU_EH_FRAME / FDE (-ENOENT, e.g. anonymous RX JIT
       code) or unsupported/SP-invalid bytecode (-EINVAL/-EFAULT):
       caches a negative VMA entry when no PT_GNU_EH_FRAME exists, leaves
       state->done = false, and falls through to FP for this frame.
 3. Frame pointer fallback: Steps out of the JIT/non-CFI frame via FP
    (tracking state->sp_valid via unwind_user_fp_sets_sp()).
 4. Automatic return to CFI: On the next frame, unwind_user_next() tries
    Minimal DWARF CFI first again, unwinding mixed stacks seamlessly as
    CFI -> FP -> CFI -> FP -> CFI.


Compatibility with Kernel Livepatching (HAVE_RELIABLE_STACKTRACE)
=================================================================

All three architectures support arch_stack_walk_reliable() for kernel
livepatching under CONFIG_UNWINDER_DWARF_CFI, even when compiled with
-fomit-frame-pointer:

 - x86-64 (arch/x86/kernel/unwind_dwarf.c & stacktrace.c): Unwinds
   vmlinux and RCU module .eh_frame tables, recovers CFA-keyed
   ftrace_graph and rethook return addresses, sets state->error on any
   missing or invalid FDE, and rejects stacks containing in-kernel
   pt_regs boundaries in arch_stack_walk_reliable() (matching
   CONFIG_FRAME_POINTER because inline asm such as pushf; pop adjusts
   %rsp without .cfi_adjust_cfa_offset across preemption).
 - ARM64 (arch/arm64/kernel/stacktrace.c): Preserves ARM64's existing
   HAVE_RELIABLE_STACKTRACE and HAVE_LIVEPATCH guarantees without frame
   pointers. Normal sleeping tasks unwind via kunwind_next_cfi() down to
   the SP-verified FRAME_META_TYPE_FINAL entry boundary. Every non-CFI
   fallback (live x30 guess or AArch64 frame-record fallback for JITed
   eBPF code) sets state->unreliable = true, and in-kernel exception
   boundaries set KUNWIND_SOURCE_REGS_PC -- both of which are rejected
   with -EINVAL by arch_reliable_kunwind_consume_entry().
   Compared to ARM64 SFrame proposals (and complementing .lr_unwind as
   noted above), Minimal DWARF CFI works with both Clang/LLVM and GCC
   today and achieves 100.00% FDE coverage (including entry-ftrace.S's
   return_to_handler where GNU as omits .sframe). Moreover,
   kunwind_next_cfi() already distinguishes live LR
   (DWARF_CFI_RULE_SAME) vs. stack-saved LR (DWARF_CFI_RULE_OFFSET) at
   regs->pc, so if asynchronous epilogue/.S CFI is audited across ARM64
   in the future, reliable traversal across KUNWIND_SOURCE_REGS_PC
   requires no format changes.
 - RISC-V (arch/riscv/kernel/stacktrace.c): Selects
   HAVE_RELIABLE_STACKTRACE under CONFIG_UNWINDER_DWARF_CFI.
   walk_stackframe_cfi(..., require_reliable = true) verifies every step
   via .eh_frame CFI and SP-keyed ftrace_graph/rethook recovery while
   rejecting handle_exception pt_regs frames and non-CFI fallbacks with
   -EINVAL.


Compatibility with User Space and Kernel Subsystems
===================================================

 - C++ exceptions, Rust panics, and pthread_cancel: 100% unchanged. The
   kernel only reads PT_GNU_EH_FRAME in user ELF mappings, skipping
   'zPLR' personality ('P') and LSDA ('L') augmentations and ignoring
   callee-saved GPR opcodes. ARM64 and RISC-V vDSO sigreturn trampolines
   are untouched so libgcc's instruction-matching fallback is preserved.
 - Debugging (gdb, lldb, kdump/crash): User debugging is untouched.
   Kernel backtraces (bt), .debug_line, and .debug_info work normally.
 - Hardware security, sanitizers, and eBPF: Supports ARM64 PAC-RET + BTI
   (-mbranch-protection=standard), ARM64 Dynamic Shadow Call Stack
   (patch-scs.c), x86 Kernel IBT (objtool skips .eh_frame* relocations),
   SW-tag KASAN (__hwasan_tag_mismatch .cfi_* annotations), KMSAN output
   unpoisoning, Spectre v1 / v1.1 nospec bounds clamping, and JITed eBPF
   programs (bpf_get_stack, bpf_get_stackid).


Worked Examples
===============

Example 1: Single-Function Encoding (Raw vs. Minified .eh_frame vs. SFrame)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
For a 64-byte C function compiled with gcc -O2 -fomit-frame-pointer
-fasynchronous-unwind-tables -Wa,--gsframe (3 GPR spills: r15, r14, rbx):

  Raw .eh_frame (30 B FDE + 8 B .eh_frame_hdr entry = 38 B; 1 shared CIE):
    42 0e 10 [8f 02]  # +2:  CFA=rsp+16, [r15 at cfa-16 -> ignored]
    45 0e 18 [8e 03]  # +5:  CFA=rsp+24, [r14 at cfa-24 -> ignored]
    44 0e 20 [83 04]  # +4:  CFA=rsp+32, [rbx at cfa-32 -> ignored]
    47 0e 30          # +7:  CFA=rsp+48
    66 0e 20 | 41 0e 18 | 42 0e 10 | 42 0e 08   # epilogue pops

  Minified .eh_frame (24 B FDE + 8 B .eh_frame_hdr entry = 32 B):
    42 0e 10 | 45 0e 18 | 44 0e 20 | 47 0e 30
    66 0e 20 | 41 0e 18 | 42 0e 10 | 42 0e 08

  SFrame v3 .sframe (27 B FREs + 5 B FRE hdr + 16 B FDE index = 48 B):
    00 03 08 | 02 03 10 | 07 03 18 | 0b 03 20 | 12 03 30
    38 03 20 | 39 03 18 | 3b 03 10 | 3d 03 08  # no shared CIE: +PC=0 FRE

Example 2: Kernel-Space Walk (eBPF + DRAP Module + kretprobe on ARM64)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  [Context: JITed eBPF raw_tracepoint("sched_switch") -> bpf_get_stack()]

  Frame 0: bpf_prog_<tag> (JITed eBPF text, no .eh_frame)
    -> .eh_frame lookup: -ENOENT -> falls back to FP record [x29, x29+16]
       (sets state->unreliable = true; allowed for non-reliable bpf walk)
    -> Recovers caller PC in tracepoint hook, resumes CFI on Frame 1

  Frame 1: __schedule (vmlinux .text, built with -fomit-frame-pointer)
    -> Binary search __start_eh_frame_hdr at lookup_pc = pc - 4
    -> Evaluates FDE (skips x19..x28 spills, toggles ra_signed on 0x2d):
       row = { cfa = SP + 144, fp = *(CFA - 144), ra = *(CFA - 136), pac }
    -> Reads saved x30, strips PAC via ptrauth_strip_kernel_insn_pac()

  Frame 2: mod_unwind_drap [test_unwind_mod] (64B stack-realigned DRAP)
    -> RCU lookup in mod->arch.dwarf_cfi_index matches 3-byte expression
       [DW_OP_breg(fp), -40, DW_OP_deref] -> CFA = *(fp - 40)

  Frame 3: mod_krp_inner [test_unwind_mod] (hijacked by kretprobe)
    -> Stack RA == &__kretprobe_trampoline ->
       kunwind_recover_return_address() matches entry SP == CFA on
       kretprobe shadow list -> restores real PC

  Frame N: el0t_64_sync_handler (EL0 -> EL1 syscall boundary)
    -> .eh_frame: -ENOENT -> SP-verified FRAME_META_TYPE_FINAL (clean stop)

Example 3: User-Space Deferred Walk (Signal + SA_ONSTACK + Leaf + JIT)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  [Step A -- In PMU NMI]:
    unwind_deferred_request() emits [PERF_CONTEXT_USER_DEFERRED, cookie]
    and queues TWA_NMI_CURRENT task_work (~15 ns).

  [Step B -- Return to User Space (unwind_user_faultable())]:
    Frame 0: nanosleep() in libc.so.6 (frameless leaf, topmost = true)
      -> Caches libc PT_GNU_EH_FRAME (slot 0), drops mmap_read_lock
      -> FDE at exact ip: CFA = SP + 0, RA = SAME -> consumes live LR
         -> sigusr1_handler + 0x24; clears state->ra_valid = false

    Frame 1: sigusr1_handler (on SA_ONSTACK sigaltstack)
      -> Caches binary PT_GNU_EH_FRAME (slot 1); reads RA = vDSO sigreturn

    Frame 2: [vdso] rt_sigreturn trampoline
      -> unwind_user_sigreturn() reads uc_mcontext from rt_sigframe,
         pivots SP back to main stack, restores ip = dso_leaf_tgkill + 8
         and live LR (ra_valid = true, signal = true, nr_signals = 1)

    Frame 3: dso_leaf_tgkill in libcleanup.so (interrupted frameless leaf)
      -> signal == true -> exact ip lookup; RA = SAME consumes restored LR

    Frame 4: c_dso_trigger in libcleanup.so ('zPLR' C++ CIE, frameless)
      -> Skips personality/LSDA augmentation -> unwinds to jit_bridge

    Frame 5: Anonymous PROT_READ|PROT_EXEC JIT stub (no ELF header, has FP)
      -> Negative VMA cache hit (slot 3) -> CFI returns -ENOENT -> FP step

    Frames 6..9: 64B DRAP -> alloca() VLA -> main -> _start
      -> CFI resumes automatically after JIT frame; _start hits
         DW_CFA_undefined on RA -> state->done = true (clean stop).


Empirical Size and Latency Comparisons
======================================

1. Kernel Unwind Table Sizes (x86_64, arm64, riscv)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Target              .text     ORC       .sframe   Min .eh   Min .eh+_hdr
  ------------------  --------  --------  --------  --------  ------------
  x86_64 mm/vmscan.o   40.6 KB  14,240 B   7,840 B*  6,432 B       --
  x86_64 ext4/inode.o  60.3 KB  12,980 B   7,486 B   5,840 B       --
  x86_64 vmlinux      20.09 MB  ~4.30 MB     --     2.62 MB      3.16 MB
  arm64 kernel/fork.o  18.5 KB     --      2,617 B   2,040 B     2,548 B
  arm64 mm/vmscan.o    28.4 KB     --      2,423 B   1,744 B     2,136 B
  arm64 vmlinux       17.64 MB     --      2.80 MB   2.19 MB      2.72 MB
  riscv kernel/fork.o  19.8 KB     --        --      2,860 B     3,496 B
  riscv mm/vmscan.o    35.3 KB     --        --      5,916 B     7,168 B
  riscv vmlinux       11.49 MB     --        --      1.93 MB      2.35 MB
  (* SFrame omits DRAP FDEs in x86_64 mm/vmscan.o and ARM64 entry-ftrace.S;
     Minimal DWARF covers 100%: 69,958 x86 + 69,765 arm64 + 55,296 riscv.)

2. User-Space ELF Unwind Metadata Sizes (GCC 15.2 / Binutils 2.47)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Binary                    .text    Raw .eh*  Min .eh*  .sframe  .eh*+.sf
  ------------------------  -------  --------  --------  -------  --------
  4,038-fn benchmark (x86)   302 KB  162.4 KB  151.4 KB  137.4 K  299.8 KB
  /bin/bash (Debian x86)     887 KB  124.1 KB  116.5 KB  123.9 K  248.0 KB
  aarch64-linux-gnu-gcc-15   911 KB  163.5 KB     --     164.5 K  328.0 KB
  libc.so.6 (x86-64)        1.47 MB  181.7 KB  171.3 KB    --        --
  /usr/bin/python3 (x86-64) 3.39 MB  548.7 KB  512.5 KB    --        --

3. Unwind Speed (17-Frame Mixed SP/VLA/Shrink-Wrap Walk, 4,038-FDE Binary)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  Unwinder Implementation                  17-Frame Walk  ns/Frame  Cyc/Frm
  ---------------------------------------  -------------  --------  -------
  Frame Pointer (-fno-omit-frame-pointer)        16.3 ns   0.96 ns    2.1 c
  SFrame v3 (.sframe)                           321.3 ns  18.90 ns   74.7 c
  Hardened kernel dwarf_cfi.c (Min .eh)         795.9 ns  46.82 ns  185.4 c
  Hardened kernel dwarf_cfi.c (Raw .eh)         860.5 ns  50.62 ns  201.8 c
  Full DWARF (libgcc _Unwind_Backtrace)       1,476.2 ns  86.83 ns  342.2 c


Testing and Verification
========================

 - Static, style, and edge-config checks: 0 errors/warnings from
   scripts/checkpatch.pl, scripts/kernel-doc -Werror -none, and
   scripts/spdxcheck.py across all 30 patches, plus cross-config build
   verification across CONFIG_RETHOOK=n, CONFIG_MODULES=n,
   CONFIG_PERF_EVENTS=n, CONFIG_STACKTRACE=n, and non-UNWIND_USER
   headers.
 - Multi-architecture libLLVM static verification & x86 ORC cross-check
   (tools/unwind/verify_cfi):
    * Reference DWARF equivalence (Oracle 1): 0 mismatches between
      libLLVM's reference DWARFUnwindTable and kernel/unwind/dwarf_cfi.c
      (both user stream and kmem paths) across 207,450 vmlinux FDEs and
      2,575,276 transition PCs on x86_64 (73,627/73,627), arm64
      (78,116/78,116), and riscv64 (55,707/55,707), plus 0 mismatches
      across libc.so.6, libstdc++.so.6, libcrypto.so.3, and /bin/bash.
    * CFG machine-instruction abstract execution (Oracle 2): 100.00%
      instruction-clean across riscv64 vmlinux (55,411/55,411 functions;
      3,970,473 reachable instructions; 0 CFA/RA/FP diffs) and user
      libraries (libc.so.6 2,270/2,270, libstdc++.so.6 3,984/3,984,
      libcrypto.so.3 5,878/5,878); 99.34% on x86_64 vmlinux (69,207/
      69,665; 0 RA/FP diffs, remaining inline-asm pushfq/popq and
      call_on_stack() IRQ stack pivots); and 98.83% on arm64 vmlinux
      (76,830/77,741; 0 FP diffs, identifying a GCC 15.2 AArch64
      epilogue .cfi scheduling bug on __builtin_frame_address(0) frames
      with outgoing stack arguments that affects .sframe identically,
      plus 1 assembly routine missing .cfi_register).
    * Direct x86-64 .orc_unwind cross-check (Oracle 3): 99.9823% exact
      instruction match (4,467,361 / 4,468,154 ORC_TYPE_CALL instructions
      with FDEs; 0 BP diffs; all 793 CFA instruction diffs confined to
      inline-asm pushfq/iret sequences lacking .cfi_adjust_cfa_offset).
 - Differential equivalence & fuzzing: 100.00% match across 905,231+
   ASan+UBSan PC probes against reference DWARF evaluation across x86-64,
   ARM64 (PAC-RET), and RISC-V (-mrelax), plus 500,000 ASan+UBSan fuzzer
   iterations on kernel/unwind/dwarf_cfi.c and 5,000 mutated ELF .o
   fuzzer iterations on scripts/min_eh_frame.c with 0 findings.
 - Live multi-architecture QEMU testing (qemu-system-x86_64,
   qemu-system-aarch64 -M virt -cpu max with PAC-RET + BTI, and
   qemu-system-riscv64 -M virt -cpu rv64 with RVC):
   Passed 8/8 KUnit tests (including CALLER_ADDR0/1, vdso32 sigreturn,
   negative sdata4 range rejection, and scan_eh_frame_kmem),
   backtracetest, 10x module load/unload cycles with DRAP + nested
   kretprobes/rethook + arch_stack_walk_reliable(), 50x cross-task
   /proc/<tid>/stack walks, JITed eBPF bpf_get_stack() +
   bpf_get_stackid(), unwind_user_cfi kselftest (clobbered FP, VLA, DRAP,
   shrink-wrap, anonymous RX JIT >16B CFI->FP->CFI fallback), -m32 IA32
   compat (including live SIGUSR1 vdso32 rt_sigreturn), 'zPLR' DSO +
   SA_ONSTACK SIGUSR1 rt_sigreturn across interrupted leaf functions, and
   4-thread hostile ELF VMA fault injection with 0 failures and clean
   dmesg across all three architectures.


Tool-Assistance Disclosure
==========================

Per Documentation/process/generated-content.rst and
Documentation/process/coding-assistants.rst:

 - Tools used: Gemini (AI coding assistant), used interactively across an
   extended engineering session; RFC v1 also received automated AI patch
   reviews from upstream Sashiko and BPF CI.
 - Scope of assistance: Prototyping and refining the bounded DWARF CFA
   interpreter, user-space PT_GNU_EH_FRAME VMA unwinder, build-time
   scripts/min_eh_frame.c minifier, x86-64/ARM64/RISC-V kernel and
   user-space unwinder integrations, standalone tools/unwind/verify_cfi
   verifier, KUnit/kselftest suites, differential fuzzers, QEMU
   multi-arch test harnesses, v2 review fixes, and series documentation.

Ian Rogers (30):
  unwind: Add Minimal DWARF CFI bytecode interpreter
  unwind: Add KUnit tests for Minimal DWARF CFI interpreter
  unwind_user: Support Minimal DWARF CFI user-space unwinding
  x86: unwind_user: Support Minimal DWARF CFI user unwinding
  scripts: Add min_eh_frame build-time .eh_frame minifier
  kbuild: Wire up CONFIG_UNWINDER_DWARF_CFI_MINIFY object pass
  objtool/ibt: Ignore .eh_frame relocations during ENDBR validation
  vmlinux.lds.h: Allow architectures to emit custom RO_DATA sections
  efi/libstub: Disable unwind tables in x86 and RISC-V EFI stubs
  tracing: Skip internal ftrace frames under CONFIG_UNWINDER_DWARF_CFI
  x86: Add DWARF CFI annotations to entry, ftrace, frame, and rethook
  x86/unwind: Add Minimal DWARF CFI kernel unwinder
  lib/Kconfig.debug: Allow LATENCYTOP and fault-injection filter with
    DWARF CFI
  arm64: unwind_user: Support Minimal DWARF CFI and FP user unwinding
  arm64: Add DWARF CFI annotations to entry, ftrace, EFI, BPF, and KASAN
  arm64/unwind: Add Minimal DWARF CFI kernel unwinder
  riscv: unwind_user: Support Minimal DWARF CFI and FP user unwinding
  riscv: Add DWARF CFI annotations to entry, ftrace, rethook, and BPF
    JIT
  riscv/unwind: Add Minimal DWARF CFI kernel unwinder
  selftests/perf_events: Add Minimal DWARF CFI deferred user unwind test
  scripts: Add eh_frame_min.py .eh_frame coverage and size analyzer
  tools headers: Add linux/kmsan-checks.h copy from the kernel sources
  tools headers: Add linux/nospec.h copy from the kernel sources
  tools headers: Add linux/unwind_dwarf_cfi.h copy from the kernel
    sources
  tools include: Add linux/uaccess.h stub for userspace tools
  tools/unwind: Add standalone libLLVM Minimal DWARF CFI verifier
  tools/unwind: Add multi-arch symbolic instruction lifters for
    verify_cfi
  tools/unwind: Add CFG instruction abstract execution oracle to
    verify_cfi
  tools/unwind: Add x86-64 ORC cross-check oracle to verify_cfi
  MAINTAINERS: Add DWARF CFI stack unwinding entry

 MAINTAINERS                                   |   16 +
 arch/Kconfig                                  |   31 +
 arch/arm64/Kconfig                            |    7 +-
 arch/arm64/Kconfig.debug                      |   32 +
 arch/arm64/Makefile                           |    5 +
 arch/arm64/include/asm/ftrace.h               |   18 +-
 arch/arm64/include/asm/module.h               |   16 +
 arch/arm64/include/asm/module.lds.h           |    2 +-
 arch/arm64/include/asm/perf_event.h           |    2 +
 arch/arm64/include/asm/stacktrace/frame.h     |    6 +
 arch/arm64/include/asm/unwind_user.h          |  145 ++
 arch/arm64/kernel/Makefile                    |    6 +
 arch/arm64/kernel/efi-rt-wrapper.S            |   22 +
 arch/arm64/kernel/entry-ftrace.S              |   35 +-
 arch/arm64/kernel/entry.S                     |   22 +
 arch/arm64/kernel/ftrace.c                    |   12 +-
 arch/arm64/kernel/module.c                    |   17 +-
 arch/arm64/kernel/probes/kprobes.c            |   14 +-
 arch/arm64/kernel/signal.c                    |   55 +
 arch/arm64/kernel/stacktrace.c                |  477 +++-
 arch/arm64/kernel/vdso/Makefile               |    7 +-
 arch/arm64/kernel/vmlinux.lds.S               |   21 +-
 arch/arm64/kvm/hyp/nvhe/Makefile              |    1 +
 arch/arm64/lib/kasan_sw_tags.S                |   16 +
 arch/arm64/net/bpf_jit_comp.c                 |    9 +-
 arch/arm64/net/bpf_timed_may_goto.S           |   19 +
 arch/riscv/Kconfig                            |    7 +-
 arch/riscv/Kconfig.debug                      |   16 +
 arch/riscv/Makefile                           |   15 +-
 arch/riscv/include/asm/ftrace.h               |    1 +
 arch/riscv/include/asm/module.h               |   22 +
 arch/riscv/include/asm/perf_event.h           |    2 +
 arch/riscv/include/asm/signal32.h             |    9 +
 arch/riscv/include/asm/stacktrace.h           |   11 +
 arch/riscv/include/asm/unwind_user.h          |   82 +
 arch/riscv/kernel/Makefile                    |    9 +
 arch/riscv/kernel/compat_signal.c             |   45 +
 arch/riscv/kernel/entry.S                     |    2 +
 arch/riscv/kernel/mcount-dyn.S                |    6 +-
 arch/riscv/kernel/mcount.S                    |   34 +-
 arch/riscv/kernel/module.c                    |    9 +
 arch/riscv/kernel/probes/rethook.c            |   13 +-
 arch/riscv/kernel/probes/rethook_trampoline.S |   30 +
 arch/riscv/kernel/signal.c                    |   57 +
 arch/riscv/kernel/stacktrace.c                |  650 +++++-
 arch/riscv/kernel/vmlinux.lds.S               |   13 +
 arch/riscv/net/bpf_jit_comp64.c               |    6 +-
 arch/riscv/purgatory/Makefile                 |    3 +-
 arch/x86/Kconfig                              |    3 +-
 arch/x86/Kconfig.debug                        |   13 +
 arch/x86/Makefile                             |    7 +
 arch/x86/boot/startup/Makefile                |    1 +
 arch/x86/entry/calling.h                      |   17 +
 arch/x86/include/asm/dwarf2.h                 |    6 +-
 arch/x86/include/asm/frame.h                  |   42 +-
 arch/x86/include/asm/module.h                 |    5 +
 arch/x86/include/asm/unwind.h                 |   15 +-
 arch/x86/include/asm/unwind_user.h            |   47 +
 arch/x86/kernel/Makefile                      |    4 +
 arch/x86/kernel/ftrace_64.S                   |   44 +-
 arch/x86/kernel/module.c                      |   11 +-
 arch/x86/kernel/rethook.c                     |   92 +-
 arch/x86/kernel/stacktrace.c                  |    8 +-
 arch/x86/kernel/unwind_dwarf.c                |  674 ++++++
 arch/x86/kernel/vmlinux.lds.S                 |   16 +
 arch/x86/net/bpf_jit_comp.c                   |   12 +-
 arch/x86/purgatory/Makefile                   |    1 +
 drivers/firmware/efi/libstub/Makefile         |    7 +-
 include/asm-generic/vmlinux.lds.h             |    5 +
 include/linux/unwind_dwarf_cfi.h              |  181 ++
 include/linux/unwind_user.h                   |  104 +
 include/linux/unwind_user_types.h             |  101 +-
 kernel/trace/trace.c                          |    4 +-
 kernel/trace/trace_events_trigger.c           |    2 +-
 kernel/trace/trace_functions.c                |    4 +-
 kernel/unwind/Makefile                        |   14 +-
 kernel/unwind/dwarf_cfi.c                     | 1923 +++++++++++++++++
 kernel/unwind/dwarf_cfi_kunit.c               |  767 +++++++
 kernel/unwind/user.c                          |  169 +-
 kernel/unwind/user_cfi.c                      |  392 ++++
 lib/Kconfig.debug                             |    4 +-
 rust/Makefile                                 |    4 +-
 scripts/.gitignore                            |    1 +
 scripts/Makefile                              |    1 +
 scripts/Makefile.build                        |   12 +-
 scripts/Makefile.lib                          |   13 +-
 scripts/Makefile.vmlinux_o                    |    8 +-
 scripts/eh_frame_min.py                       |  961 ++++++++
 scripts/min_eh_frame.c                        | 1845 ++++++++++++++++
 tools/Makefile                                |   13 +-
 tools/include/linux/kernel.h                  |    1 +
 tools/include/linux/kmsan-checks.h            |   98 +
 tools/include/linux/nospec.h                  |   74 +
 tools/include/linux/uaccess.h                 |    9 +
 tools/include/linux/unwind_dwarf_cfi.h        |  181 ++
 tools/objtool/check.c                         |    1 +
 tools/perf/check-headers.sh                   |    3 +
 .../testing/selftests/perf_events/.gitignore  |    1 +
 tools/testing/selftests/perf_events/Makefile  |    4 +-
 .../selftests/perf_events/unwind_user_cfi.c   |  482 +++++
 tools/unwind/.gitignore                       |    4 +
 tools/unwind/Makefile                         |  126 ++
 tools/unwind/dwarf_cfi_host.c                 |   80 +
 tools/unwind/dwarf_cfi_host.h                 |   42 +
 tools/unwind/verify_cfi.cpp                   |  789 +++++++
 tools/unwind/verify_cfi.hpp                   |  147 ++
 tools/unwind/verify_insn.cpp                  |  360 +++
 tools/unwind/verify_insn.hpp                  |  103 +
 tools/unwind/verify_insn_arch.cpp             |  757 +++++++
 tools/unwind/verify_orc.cpp                   |  205 ++
 110 files changed, 12930 insertions(+), 145 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_user.h
 create mode 100644 arch/riscv/include/asm/unwind_user.h
 create mode 100644 arch/x86/kernel/unwind_dwarf.c
 create mode 100644 include/linux/unwind_dwarf_cfi.h
 create mode 100644 kernel/unwind/dwarf_cfi.c
 create mode 100644 kernel/unwind/dwarf_cfi_kunit.c
 create mode 100644 kernel/unwind/user_cfi.c
 create mode 100755 scripts/eh_frame_min.py
 create mode 100644 scripts/min_eh_frame.c
 create mode 100644 tools/include/linux/kmsan-checks.h
 create mode 100644 tools/include/linux/nospec.h
 create mode 100644 tools/include/linux/uaccess.h
 create mode 100644 tools/include/linux/unwind_dwarf_cfi.h
 create mode 100644 tools/testing/selftests/perf_events/unwind_user_cfi.c
 create mode 100644 tools/unwind/.gitignore
 create mode 100644 tools/unwind/Makefile
 create mode 100644 tools/unwind/dwarf_cfi_host.c
 create mode 100644 tools/unwind/dwarf_cfi_host.h
 create mode 100644 tools/unwind/verify_cfi.cpp
 create mode 100644 tools/unwind/verify_cfi.hpp
 create mode 100644 tools/unwind/verify_insn.cpp
 create mode 100644 tools/unwind/verify_insn.hpp
 create mode 100644 tools/unwind/verify_insn_arch.cpp
 create mode 100644 tools/unwind/verify_orc.cpp


base-commit: 4843f6873f7c4835e62f2c73ba0fd538e57a2f22
-- 
2.56.1.831.g720f3f5937-goog

