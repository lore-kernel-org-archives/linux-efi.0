Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795391915;
	b=OPlBuGBnHU3gHm9n40RZV+/iOJ3Pnf7UzyIKejYknPiRVslARhPUyn1pe6iCP4Ixe2gb
	 AynavfhMO/ObBgzksKb/mjxxDskP+uoAIsXN1BrlEwgkVKhLYs4vsCLEQhyKP75Er+rLL
	 +6WNIeXgt2+Mql6zUvUmtcqINdISRmMkQDvj/Hz1Restn0IU1m8wUF99gs1n3VD+4+m6m
	 pWM8DjBs1WbRC0olu7g5XY/koEh/F7NLxlXwxLBS7GEjhcT6FRjAZ8CO1h1CAwqsdG6Oq
	 Pi0KQagaSby/Bqdk87o/aqqenD1vADCeuZLsG5DXXP5GQoFb3KNWXkou1CFHiJHB8Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795391915;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=Dtc+fr/sr1dsNGUgfanyNVkvmYSADCII8gwg+poCDMI=;
	b=d93ZwITrO9UgZGLKoNV/x21O3l/M0qsdpPAVDGK18jooTiVHy+zsIGiEUL1nxEw1ldqU
	 CIqeqSlcj1UvNVEn9vwDilpMlvWlB5MwkiI33A/fN6sWhWXP8oPA+lE5nw+0wpE1eiDO8
	 mw+j68ODUtHnOgYGLK06+6QDVHNSYGyR4teaYKv2VMlcvlJggenIY+HsTCTerEIkU5MNN
	 CSCQMGm+7Yeblw2vCV+iCWI17lwAaTpLj14Gdnt8C9GvX3LabFyIP9yJKfepxkMigRpKW
	 t5ws5kfF1O034Wpb8P74QXILvOefHR6dGkW3ZVwlNksCUY4VK2US5hKS44/k0bdjwGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--irogers.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ef15mcTS;
	arc=none smtp.remote-ip=74.125.82.69
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com [74.125.82.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256DC606A31D
	for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 23:58:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 256DC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--irogers.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ef15mcTS
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-139b62317d0so74689c88.0
        for <linux-efi@vger.kernel.org>; Sun, 22 Nov 2026 15:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795391913; x=1795996713; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dtc+fr/sr1dsNGUgfanyNVkvmYSADCII8gwg+poCDMI=;
        b=ef15mcTSZZRNLkBnUMdMooPBrSzf/LSrxESFOZW6sawXDQp17th/Zo1gEKCOJfxZ4j
         nOSldRxaJEUHFEDurEqwq7OOECtbHAltbmgfp4of/xKFP6TnQfZpsrCWg7u3KLq9Whah
         qiVEMa3MFJNKlyeYSAfY95GAJY2GlyL63baX02SeG8hEPXgYK3cko8lWFFGQefpsS398
         /pOieC9GN2BjcC1io4296n9u2JnuZmedkIPffRWOJ3hxwcK5wngxncGqkx3rKrIkSym3
         PTw5sXZcJ5Grw/lmS1mkIZdbM5ZQGcG6PilTXlCgsNEW0UnyF8xePKoOUiJJOgtGHvbh
         PPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391913; x=1795996713;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dtc+fr/sr1dsNGUgfanyNVkvmYSADCII8gwg+poCDMI=;
        b=W1JoODHyPX8apEjOH54uS4aB1pcBfIPctkBQAqAL/TkhJvQb+Njo2J69Xw2v109syb
         l3UCIPMu1e83s2aHwk8jjgHnJ7bFMIHyHUQSt23E4r8Z1l2BEaCq6yt/CLR3DlLeh8L2
         RnmKFRue2MvieqReDAxLmg6zb/xc/KvMpLLd3ii9CkJF2+Mjn+g+LCUPlOyu6Hd21mrS
         bdOekzOhowd0xFKdi3z2Fe4azI1Ox9aYg/GCkHBihtgzDMt0SvMy9PfqxGpvJoq5hnBV
         9drNkrPDmbmvK7b8a2LwYiuhKczeOW5baaJ1rF2OYeZBE/okamk5m0ucTQVlqzb66WVf
         +0vg==
X-Forwarded-Encrypted: i=1; AL+hErEtWJKyjhgvMfS63tLjOiFAW/1wUNks2+CuyMWrmmlJOdfAkD0b95CKXetejhaznnYn32747eAf5FI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+AmRTX0mDaLdYMEHlTLWBy8EoIVie6c/Fd464d0WfoElVsFJ7M
	yeAukE9XhsaGsn5hLmFotYZ7bKF8Cm5yXw2QN+k4k/pcKNDt3iDO4qTBvv467W0iu4bfk1aXVkq
	rl1IVRxIDLA==
X-Received: from dldyq15-n1.prod.google.com ([2002:a05:701b:454f:10b0:1b5:1d0c:b35a])
 (user=irogers job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:4513:10b0:1b5:56d8:d596
 with SMTP id a92af1059eb24-1b556d8d6fdmr10404927c88.12.1795391912777; Sun, 22
 Nov 2026 15:58:32 -0800 (PST)
Date: Sun, 22 Nov 2026 15:57:46 -0800
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261122235757.3456048-1-irogers@google.com>
Subject: [RFC PATCH v1 00/11] unwind: Minimal DWARF CFI stack unwinding for
 x86, arm64, and riscv
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

Overview
========

This RFC series introduces Minimal DWARF Call Frame Information (CFI)
stack unwinding in the Linux kernel for both user-space deferred
callchains (unwind_user / PERF_RECORD_CALLCHAIN_DEFERRED) and
kernel-space stack traces (stacktrace.h / HAVE_RELIABLE_STACKTRACE)
across x86-64, ARM64, and RISC-V, paired with an optional standalone C
build-time .eh_frame minifier (scripts/min_eh_frame.c).

It enables reliable stack unwinding across kernel and user-space
binaries compiled with or without frame pointers (-fomit-frame-pointer),
without introducing duplicate .sframe sections in user-space ELF files
or requiring new compiler, assembler, or dynamic-loader formats.


Motivation
==========

1. Limitations of Frame-Pointer-Only Unwinding
----------------------------------------------
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
--------------------------------------
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
------------------------------------
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
CFA, Frame Pointer (FP), and Return Address (RA), plus link-register
leaf state, ARM64 PAC-RET signing (0x2d), a 4-entry remember_state
stack, and a fixed 3-byte pattern match for DRAP/sigreturn frames while
decoding and discarding general callee-saved GPR spill opcodes:

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


Benefits vs. Drawbacks and Trade-offs
=====================================

Benefits
--------
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
    (including SA_ONSTACK and interrupted leaf functions), and mixed
    CFI + JIT frame-pointer stacks.

Drawbacks and Limitations
-------------------------
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
    frames requires .debug_frame (or leaving CONFIG_UNWINDER_DWARF_CFI_MINIFY
    disabled on debug builds).
 4. Reliance on compiler and assembly .cfi_* annotations: Unlike x86
    objtool (which validates machine instructions directly), .eh_frame
    (like .sframe) trusts compiler -fasynchronous-unwind-tables output
    and manual .cfi_* annotations in hand-written .S routines. For this
    reason, arch_stack_walk_reliable() on ARM64 and RISC-V continues to
    conservatively reject stacks containing in-kernel asynchronous
    exception pt_regs boundaries until asynchronous epilogue/.S CFI
    auditing is established.
 5. Hard interpreter bounds: Pathological FDEs with > 4,096 bytes of
    bytecode or DW_CFA_remember_state depth > 4 are rejected with
    -EINVAL (falling back to FP in user space). Across all 195,019
    vmlinux FDEs on x86-64, ARM64, and RISC-V, 0 FDEs hit the size bound
    and the maximum observed remember_state depth is 1.


Execution Contexts and Fallback Mechanics
=========================================

1. When Kernel-Space vs. User-Space CFI Can Run
-----------------------------------------------
  Context                        Kernel CFI   User CFI     Notes
  -----------------------------  -----------  -----------  -------------------
  PMU NMI (in_nmi())             Yes (direct) No (defer)   Pinned vmlinux/RCU
                                                           mod tables vs. cold
                                                           user VMAs
  Hardirq / Softirq / BPF        Yes (direct) No (defer)   bpf_get_stack[id];
                                                           user sync = FP-only
  Return-to-user task_work       Yes          Yes (faults) mmap_read_lock then
                                                           copy_from_user()
  Cross-task /proc/<tid>/stack   Yes          No           current->mm only
  Livepatch reliable walk        Yes (all 3)  N/A          Kernel-only API
  Kernel threads / x86 VM86      Yes (kthd)   No           mm == NULL / 16-bit

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
---------------------------------------------------
unwind_user_next() (kernel/unwind/user.c) evaluates each frame
independently rather than locking an entire walk to one unwinder:

 1. Architectural signal trampoline hook (unwind_user_sigreturn()):
    Checked first (bounded to UNWIND_USER_MAX_SIGNALS = 4 per walk so
    SA_ONSTACK switches cannot loop). On ARM64 (__kernel_rt_sigreturn)
    and RISC-V (__vdso_rt_sigreturn), where vDSO trampolines omit
    .eh_frame register rules for libgcc compatibility, recovers pc, sp,
    fp, and lr/ra (with ra_valid = true) from rt_sigframe. On x86-64,
    .cfi_signal_frame ('S' augmentation) is handled directly by CFI.
 2. Minimal DWARF CFI (highest priority):
    Resolves PT_GNU_EH_FRAME via a 4-slot per-walk VMA cache (or under
    mmap_read_lock_killable(), dropped before copy_from_user()):
     - Explicit bottom of stack (DW_CFA_undefined on RA, or RA == 0):
       sets state->done = true and stops cleanly without FP fallback.
     - Missing PT_GNU_EH_FRAME / FDE (-ENOENT, e.g. anonymous RX JIT
       code) or unsupported bytecode (-EINVAL/-EFAULT): caches a
       negative VMA entry when no PT_GNU_EH_FRAME exists, leaves
       state->done = false, and falls through to FP for this frame.
 3. Frame pointer fallback: Steps out of the JIT/non-CFI frame via FP.
 4. Automatic return to CFI: On the next frame, unwind_user_next() tries
    Minimal DWARF CFI first again, unwinding mixed stacks seamlessly as
    CFI -> FP -> CFI -> FP -> CFI.


Compatibility with Kernel Livepatching (HAVE_RELIABLE_STACKTRACE)
=================================================================

All three architectures support arch_stack_walk_reliable() for kernel
livepatching under CONFIG_UNWINDER_DWARF_CFI, even when compiled with
-fomit-frame-pointer:

 - x86-64 (arch/x86/kernel/unwind_dwarf.c): Unwinds vmlinux and RCU
   module .eh_frame tables, traverses %rsp-verified ENCODE_FRAME_POINTER
   pt_regs frames across task/IRQ/exception stacks, recovers CFA-keyed
   ftrace_graph and rethook return addresses, and sets state->error on
   any missing or invalid FDE so arch_stack_walk_reliable() returns
   -EINVAL rather than guessing.
 - ARM64 (arch/arm64/kernel/stacktrace.c): Preserves ARM64's existing
   HAVE_RELIABLE_STACKTRACE and HAVE_LIVEPATCH guarantees without frame
   pointers. Normal sleeping tasks unwind via kunwind_next_cfi() down to
   the SP-verified FRAME_META_TYPE_FINAL entry boundary. Every non-CFI
   fallback (live x30 guess or AArch64 frame-record fallback for JITed
   eBPF code) sets state->unreliable = true, and in-kernel exception
   boundaries set KUNWIND_SOURCE_REGS_PC -- both of which are rejected
   with -EINVAL by arch_reliable_kunwind_consume_entry().
   Compared to out-of-tree ARM64 SFrame proposals, Minimal DWARF CFI
   works with both Clang/LLVM and GCC today and achieves 100.00% FDE
   coverage (including entry-ftrace.S's return_to_handler where GNU as
   omits .sframe). Moreover, kunwind_next_cfi() already distinguishes
   live LR (DWARF_CFI_RULE_SAME) vs. stack-saved LR
   (DWARF_CFI_RULE_OFFSET) at regs->pc, so if asynchronous epilogue/.S
   CFI is audited across ARM64 in the future, reliable traversal across
   KUNWIND_SOURCE_REGS_PC requires no format changes.
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
   SW-tag KASAN (__hwasan_tag_mismatch .cfi_* annotations), Spectre v1 /
   v1.1 nospec bounds clamping, and JITed eBPF programs (bpf_get_stack,
   bpf_get_stackid).


Worked Examples
===============

Example 1: Single-Function Encoding (Raw vs. Minified .eh_frame vs. SFrame)
---------------------------------------------------------------------------
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
    38 03 20 | 39 03 18 | 3b 03 10 | 3d 03 08   # no shared CIE -> +PC=0 FRE

Example 2: Kernel-Space Walk (eBPF + DRAP Module + kretprobe on ARM64)
----------------------------------------------------------------------
  [Context: JITed eBPF raw_tracepoint("sched_switch") calls bpf_get_stack()]

  Frame 0: bpf_prog_<tag> (JITed eBPF text, no .eh_frame)
    -> .eh_frame lookup: -ENOENT -> falls back to FP record [x29, x29+16]
       (sets state->unreliable = true; allowed for non-reliable bpf walk)
    -> Recovers caller PC in tracepoint hook, resumes CFI on Frame 1

  Frame 1: __schedule (vmlinux .text, built with -fomit-frame-pointer)
    -> Binary search __start_eh_frame_hdr at lookup_pc = pc - 4
    -> Evaluates FDE (skips x19..x28 spills, toggles ra_signed on 0x2d):
       row = { cfa = SP + 144, fp = *(CFA - 144), ra = *(CFA - 136), pac = 1 }
    -> Reads saved x30, strips PAC via ptrauth_strip_kernel_insn_pac()

  Frame 2: mod_unwind_drap [test_unwind_mod] (64B stack-realigned DRAP)
    -> RCU lookup in mod->arch.dwarf_cfi_index matches 3-byte expression
       [DW_OP_breg(fp), -40, DW_OP_deref] -> CFA = *(fp - 40)

  Frame 3: mod_krp_inner [test_unwind_mod] (hijacked by kretprobe)
    -> Stack RA == &__kretprobe_trampoline -> kunwind_recover_return_address()
       matches entry SP == CFA on kretprobe shadow list -> restores real PC

  Frame N: el0t_64_sync_handler (EL0 -> EL1 syscall boundary)
    -> .eh_frame: -ENOENT -> SP-verified FRAME_META_TYPE_FINAL -> clean stop

Example 3: User-Space Deferred Walk (Signal + SA_ONSTACK + Leaf + JIT)
----------------------------------------------------------------------
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
---------------------------------------------------
  Target               .text     ORC       .sframe   Min .eh    Min .eh+_hdr
  -------------------  --------  --------  --------  ---------  ------------
  x86_64 mm/vmscan.o    40.6 KB  14,240 B   7,840 B*   6,432 B       --
  x86_64 ext4/inode.o   60.3 KB  12,980 B   7,486 B    5,840 B       --
  x86_64 vmlinux       20.09 MB  ~4.30 MB     --      2.62 MB      3.16 MB
  arm64 kernel/fork.o   18.5 KB     --      2,617 B    2,040 B     2,548 B
  arm64 mm/vmscan.o     28.4 KB     --      2,423 B    1,744 B     2,136 B
  arm64 vmlinux        17.64 MB     --      2.80 MB    2.19 MB      2.72 MB
  riscv kernel/fork.o   19.8 KB     --        --       2,860 B     3,496 B
  riscv mm/vmscan.o     35.3 KB     --        --       5,916 B     7,168 B
  riscv vmlinux        11.49 MB     --        --       1.93 MB      2.35 MB
  (* SFrame omits DRAP FDEs in x86_64 mm/vmscan.o and ARM64 entry-ftrace.S;
     Minimal DWARF covers 100.00%: 69,958 x86 + 69,765 arm64 + 55,296 riscv.)

2. User-Space ELF Unwind Metadata Sizes (GCC 15.2 / Binutils 2.47)
------------------------------------------------------------------
  Binary                    .text    Raw .eh*  Min .eh*  .sframe  .eh*+.sframe
  ------------------------  -------  --------  --------  -------  ------------
  4,038-fn benchmark (x86)   302 KB  162.4 KB  151.4 KB  137.4 K     299.8 KB
  /bin/bash (Debian x86)     887 KB  124.1 KB  116.5 KB  123.9 K     248.0 KB
  aarch64-linux-gnu-gcc-15   911 KB  163.5 KB     --     164.5 K     328.0 KB
  libc.so.6 (x86-64)        1.47 MB  181.7 KB  171.3 KB    --          --
  /usr/bin/python3 (x86-64) 3.39 MB  548.7 KB  512.5 KB    --          --

3. Unwind Speed (17-Frame Mixed SP/VLA/Shrink-Wrap Walk, 4,038-FDE Binary)
--------------------------------------------------------------------------
  Unwinder Implementation                    17-Frame Walk  ns/Frame  Cyc/Frm
  -----------------------------------------  -------------  --------  -------
  Frame Pointer (-fno-omit-frame-pointer)          16.3 ns   0.96 ns    2.1 c
  SFrame v3 (.sframe)                             321.3 ns  18.90 ns   74.7 c
  Hardened kernel dwarf_cfi.c (Min .eh)           795.9 ns  46.82 ns  185.4 c
  Hardened kernel dwarf_cfi.c (Raw .eh)           860.5 ns  50.62 ns  201.8 c
  Full DWARF (libgcc _Unwind_Backtrace)         1,476.2 ns  86.83 ns  342.2 c


Testing and Verification
========================

 - Static & style checks: 0 errors/warnings from scripts/checkpatch.pl,
   scripts/kernel-doc -Werror -none, and scripts/spdxcheck.py across all
   11 patches.
 - Differential equivalence & fuzzing: 100.00% match across 905,231+
   ASan+UBSan PC probes against reference DWARF evaluation across x86-64,
   ARM64 (PAC-RET), and RISC-V (-mrelax), plus 500,000 ASan+UBSan fuzzer
   iterations on kernel/unwind/dwarf_cfi.c and 5,000 mutated ELF .o
   fuzzer iterations on scripts/min_eh_frame.c with 0 findings.
 - Live multi-architecture QEMU testing (qemu-system-x86_64,
   qemu-system-aarch64 -M virt -cpu max with PAC-RET + BTI, and
   qemu-system-riscv64 -M virt -cpu rv64 with RVC):
   Passed 7/7 KUnit tests, backtracetest, 10x module load/unload cycles
   with DRAP + nested kretprobes/rethook + arch_stack_walk_reliable(),
   50x cross-task /proc/<tid>/stack walks, JITed eBPF bpf_get_stack() +
   bpf_get_stackid(), unwind_user_cfi kselftest (clobbered FP, VLA, DRAP,
   shrink-wrap, anonymous RX JIT CFI->FP->CFI fallback), -m32 IA32 compat,
   'zPLR' DSO + SA_ONSTACK SIGUSR1 rt_sigreturn across interrupted leaf
   functions, and 4-thread hostile ELF VMA fault injection with 0 failures
   and clean dmesg across all three architectures.


Tool-Assistance Disclosure
==========================

Per Documentation/process/generated-content.rst and
Documentation/process/coding-assistants.rst:

 - Tool used: Gemini (AI coding assistant), used interactively across an
   extended engineering session.
 - Scope of assistance: Prototyping and refining the bounded DWARF CFA
   interpreter, user-space PT_GNU_EH_FRAME VMA unwinder, build-time
   scripts/min_eh_frame.c minifier, x86-64/ARM64/RISC-V kernel and
   user-space unwinder integrations, KUnit/kselftest suites, differential
   fuzzers, QEMU multi-arch test harnesses, and series documentation.

Ian Rogers (11):
  unwind: Add Minimal DWARF CFI bytecode interpreter and KUnit tests
  unwind_user: Support Minimal DWARF CFI user-space unwinding
  scripts, unwind: Add build-time .eh_frame minifier
  objtool/ibt: Ignore .eh_frame relocations during ENDBR validation
  x86/unwind: Add Minimal DWARF CFI kernel unwinder
  arm64: unwind_user: Support Minimal DWARF CFI and FP user unwinding
  arm64/unwind: Add Minimal DWARF CFI kernel unwinder
  riscv: unwind_user: Support Minimal DWARF CFI and FP user unwinding
  riscv/unwind: Add Minimal DWARF CFI kernel unwinder
  selftests/perf_events: Add Minimal DWARF CFI deferred user unwind test
  scripts: Add eh_frame_min.py .eh_frame coverage and size analyzer

 arch/Kconfig                                  |   31 +
 arch/arm64/Kconfig                            |    7 +-
 arch/arm64/Kconfig.debug                      |   32 +
 arch/arm64/Makefile                           |    5 +
 arch/arm64/include/asm/ftrace.h               |   10 +-
 arch/arm64/include/asm/module.h               |   16 +
 arch/arm64/include/asm/module.lds.h           |    2 +-
 arch/arm64/include/asm/perf_event.h           |   15 +
 arch/arm64/include/asm/unwind_user.h          |  126 ++
 arch/arm64/kernel/Makefile                    |    2 +
 arch/arm64/kernel/efi-rt-wrapper.S            |   22 +
 arch/arm64/kernel/entry-ftrace.S              |   35 +-
 arch/arm64/kernel/entry.S                     |   22 +
 arch/arm64/kernel/ftrace.c                    |   12 +-
 arch/arm64/kernel/module.c                    |   17 +-
 arch/arm64/kernel/probes/kprobes.c            |   14 +-
 arch/arm64/kernel/signal.c                    |   54 +
 arch/arm64/kernel/stacktrace.c                |  537 ++++-
 arch/arm64/kernel/vmlinux.lds.S               |   21 +-
 arch/arm64/kvm/hyp/nvhe/Makefile              |    1 +
 arch/arm64/lib/kasan_sw_tags.S                |   16 +
 arch/arm64/net/bpf_jit_comp.c                 |    9 +-
 arch/arm64/net/bpf_timed_may_goto.S           |   19 +
 arch/riscv/Kconfig                            |    7 +-
 arch/riscv/Kconfig.debug                      |   16 +
 arch/riscv/Makefile                           |   15 +-
 arch/riscv/include/asm/module.h               |   22 +
 arch/riscv/include/asm/perf_event.h           |   15 +
 arch/riscv/include/asm/signal32.h             |    8 +
 arch/riscv/include/asm/stacktrace.h           |   11 +
 arch/riscv/include/asm/unwind_user.h          |   81 +
 arch/riscv/kernel/Makefile                    |    4 +
 arch/riscv/kernel/compat_signal.c             |   44 +
 arch/riscv/kernel/entry.S                     |    2 +
 arch/riscv/kernel/mcount-dyn.S                |    6 +-
 arch/riscv/kernel/mcount.S                    |   34 +-
 arch/riscv/kernel/module.c                    |    9 +
 arch/riscv/kernel/probes/rethook.c            |   13 +-
 arch/riscv/kernel/probes/rethook_trampoline.S |   30 +
 arch/riscv/kernel/signal.c                    |   62 +
 arch/riscv/kernel/stacktrace.c                |  732 ++++++-
 arch/riscv/kernel/vmlinux.lds.S               |   13 +
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
 arch/x86/kernel/unwind_dwarf.c                |  663 ++++++
 arch/x86/kernel/vmlinux.lds.S                 |   16 +
 arch/x86/net/bpf_jit_comp.c                   |   12 +-
 arch/x86/purgatory/Makefile                   |    1 +
 drivers/firmware/efi/libstub/Makefile         |    7 +-
 include/asm-generic/vmlinux.lds.h             |    5 +
 include/linux/unwind_dwarf_cfi.h              |  174 ++
 include/linux/unwind_user.h                   |   78 +
 include/linux/unwind_user_types.h             |   92 +-
 kernel/unwind/Makefile                        |   14 +-
 kernel/unwind/dwarf_cfi.c                     | 1842 +++++++++++++++++
 kernel/unwind/dwarf_cfi_kunit.c               |  625 ++++++
 kernel/unwind/user.c                          |  155 +-
 kernel/unwind/user_cfi.c                      |  378 ++++
 rust/Makefile                                 |    4 +-
 scripts/Makefile                              |    1 +
 scripts/Makefile.build                        |   12 +-
 scripts/Makefile.lib                          |   13 +-
 scripts/Makefile.vmlinux_o                    |    8 +-
 scripts/eh_frame_min.py                       |  938 +++++++++
 scripts/min_eh_frame.c                        | 1719 +++++++++++++++
 tools/objtool/check.c                         |    1 +
 .../testing/selftests/perf_events/.gitignore  |    1 +
 tools/testing/selftests/perf_events/Makefile  |    4 +-
 .../selftests/perf_events/unwind_user_cfi.c   |  447 ++++
 82 files changed, 9551 insertions(+), 118 deletions(-)
 create mode 100644 arch/arm64/include/asm/unwind_user.h
 create mode 100644 arch/riscv/include/asm/unwind_user.h
 create mode 100644 arch/x86/kernel/unwind_dwarf.c
 create mode 100644 include/linux/unwind_dwarf_cfi.h
 create mode 100644 kernel/unwind/dwarf_cfi.c
 create mode 100644 kernel/unwind/dwarf_cfi_kunit.c
 create mode 100644 kernel/unwind/user_cfi.c
 create mode 100755 scripts/eh_frame_min.py
 create mode 100644 scripts/min_eh_frame.c
 create mode 100644 tools/testing/selftests/perf_events/unwind_user_cfi.c


base-commit: 4843f6873f7c4835e62f2c73ba0fd538e57a2f22
-- 
2.56.1.750.gf70dc682cf-goog

