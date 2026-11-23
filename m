Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395406;
	b=zo4IZ+aBaBBOEEmU0HzwzeAu/T1PxybR7RLmMgDfdCAVnbxexyzffLMSr9mlm2ABa8bd
	 UhYb/OQirXFojEHqS+kw+peikR9wJwNy/mcQAmhcA1m1CA72E9Upb1KNdNofvdc1Xk59l
	 DVIFkxCbFqKzsk5WVW13y/PK1KavsUYrYBhQeYG7d+ZOaVY7HD+gXF+d3h84Ljc/6Pm6t
	 5oZBToyE3tmm2Scmyj2Iwh7/zCssWAzeieOc9xUWensDD5775fNyB46qLXK1MO/MFLSIH
	 ezFbTDSyAGo9TpDioTGlfV/Y4OTH2SYGtCStKdifvAs3aXt0Gv1cg1SljJXASv6ycjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395406;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=uTz3mW9UKrEnlqFfj/fzx/b3WxL/xNZZb7PTMzwp8Ik=;
	b=I9i6PhUASezrllNSnFWvwbr+pqlk/lwOSaetMouOmG0Ft/RX6n3UM8AQG96qI3Q2JL+8
	 YQQXBtLP8KTg9/y6+lLFRL7RqyW4rWJkZjOUKs/fO67EpcmNqgtBpOFLkdVNRdfOiRXVJ
	 bfITQBRVsgcLrR7Kfg9aC7pMagMWEXQI7D8x7e3c4PGQ+/rVea5Z4/y45C/RpCB1iQlZ8
	 eLgpG/RLY57W+RkmNKWHNmktJa3SY4qvtXEW8fINQ2N0c0Lh4o2A1/FREklcJ3vpl/XcY
	 j441YozU+Nsp94VoaVnvdzuzsANZapl8OJ5ob1A8CLDBGu72/5yEZ0nblzQpL3eAxcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TujLdVfb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5291606A31D;
	Mon, 23 Nov 2026 00:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TujLdVfb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227BF1F000C6;
	Mon, 23 Nov 2026 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395405;
	bh=uTz3mW9UKrEnlqFfj/fzx/b3WxL/xNZZb7PTMzwp8Ik=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TujLdVfbVp9rmurgDoSOgagC8ZiFfXGx1C9kYckkatHkbEOdYiXp5LOS7Kl0yzW3p
	 dQVzFv/1ed4xFjWXIsyD83z04oJZ6VVc3QGpPCbb3+vDIO7q9g8ZgO4aa9dylmeLkz
	 7qhhDxtVUU1Szb5SQ3RXIphlQMPApXHNXlNchtT8FhegwPUmwK/YTUSj9Lk2r84ehn
	 ECRtBqcNByL3qrhShzOVfj9UHxM51mqdvEb06cWQI+uJWlcEvZpYSW1laU5H6EUXM4
	 +Bhi/Wjy5Kk24nfsXSl4eMLzAHkAWQeR9TC/4tY15+trcGeLAXJ/pS1WKsEoA3MtNj
	 CwfXh2LHgobKw==
Content-Type: multipart/mixed; boundary="===============6395608148127476390=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <0b034cf88655a8541a880e294e84f1067a0e1b83681ae3ca3e5d9d3b2a4f86d8@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-6-irogers@google.com>
References: <20261122235757.3456048-6-irogers@google.com>
Subject: Re: [RFC PATCH v1 05/11] x86/unwind: Add Minimal DWARF CFI kernel unwinder
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:56:41 +0000 (UTC)

--===============6395608148127476390==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> x86/unwind: Add Minimal DWARF CFI kernel unwinder

TL;DR:
- Reliable stacktrace may wrongly succeed on kernel pt_regs inside inline asm,
  so livepatch could miss a sleeping function
- Build may fail with KPROBES=n (rethook symbol)
- KMSAN false reports; ftrace skip counts drop frames

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -288,7 +288,7 @@ config X86
>  	select MMU_GATHER_MERGE_VMAS
>  	select HAVE_POSIX_CPU_TIMERS_TASK_WORK
>  	select HAVE_REGS_AND_STACK_ACCESS_API
> -	select HAVE_RELIABLE_STACKTRACE		if UNWINDER_ORC || STACK_VALIDATION
> +	select HAVE_RELIABLE_STACKTRACE		if UNWINDER_ORC || UNWINDER_DWARF_CFI || STACK_VALIDATION
>  	select HAVE_FUNCTION_ARG_ACCESS_API
>  	select HAVE_SETUP_PER_CPU_AREA
>  	select HAVE_SOFTIRQ_ON_OWN_STACK

Is HAVE_RELIABLE_STACKTRACE justified for UNWINDER_DWARF_CFI?

arch_stack_walk_reliable() only refuses kernel-mode pt_regs when frame
pointers are enabled:

    regs = unwind_get_entry_regs(&state, NULL);
    if (regs) {
        if (user_mode(regs))
            return 0;
        ...
        if (IS_ENABLED(CONFIG_FRAME_POINTER))
            return -EINVAL;
    }

With UNWINDER_DWARF_CFI, FRAME_POINTER is n, so the walk continues.
unwind_next_frame() then reaches the pt_regs through the encoded %rbp, sets
state->ip = regs->ip and state->sp = regs->sp, and evaluates the
compiler-generated .eh_frame row at regs->ip.

The compiler's .eh_frame only describes stack changes the compiler made
itself.  It knows nothing about push/pop inside inline asm, for example
native_save_fl(), which arch_local_irq_save() inlines into every
spin_lock_irqsave():

    asm volatile("# __raw_save_flags\n\t"
                 "pushf ; pop %0"

The paravirt save_fl alternative, KVM's fastop() and iret_to_self() do the
same.  ORC handles these because objtool decodes the instructions, but no
objtool stack validation runs here (STACK_VALIDATION depends on
UNWINDER_FRAME_POINTER).

Consider CONFIG_PREEMPTION=y, IRQs on, preempt_count 0, and a task in
__raw_spin_lock_irqsave().  An IRQ arrives after pushf and before pop, and
irqentry_exit() calls preempt_schedule_irq(), so the task sleeps with
regs->ip at the pop.  Later:

klp_try_switch_task()
  klp_check_stack()
    stack_trace_save_tsk_reliable()

walks the task.  At regs->ip the CFA computed from %rsp is 8 bytes too low,
so the return address is read from the wrong slot.

If that slot holds a pushed flags value, the walk fails safely.  If it holds
a kernel text address, such as a callee-saved function pointer, the walk
records a bogus frame and drops the real caller.  If it then resynchronises
and reaches task_pt_regs(), it returns 0, and livepatch treats a function
the task is sleeping in as absent.

Documentation/livepatch/reliable-stacktrace.rst section 4.3 says:
"Architectures which cannot identify when it is reliable to unwind such
cases ... must reject unwinding across exception boundaries."

Should arch_stack_walk_reliable() also return -EINVAL on kernel-mode regs
for UNWINDER_DWARF_CFI, or should the unwinder otherwise prove that
regs->ip is not inside an inline-asm stack adjustment?

[ ... ]

> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -246,6 +246,19 @@ config UNWINDER_ORC
>  	  Enabling this option will increase the kernel's runtime memory usage
>  	  by roughly 2-4MB, depending on your kernel config.
>  
> +config UNWINDER_DWARF_CFI
> +	bool "Minimal DWARF CFI unwinder"
> +	depends on X86_64
> +	select UNWIND_DWARF_CFI
> +	select UNWIND_TABLES

The new unwinder skips frames the same way unwind_orc.c does, and the
kernel is built without frame pointers, so -fno-optimize-sibling-calls is
dropped just as under ORC.  But the tracing code picks its skip counts by
testing CONFIG_UNWINDER_ORC alone:

kernel/trace/trace.c:__ftrace_trace_stack() {
#ifndef CONFIG_UNWINDER_ORC
    if (!regs)
        skip++;
#endif
}

trace_dump_stack() has the same extra skip++, and:

kernel/trace/trace_functions.c: STACK_SKIP is 3 instead of 2 and
FTRACE_STACK_SKIP is 5 instead of 3
kernel/trace/trace_events_trigger.c: STACK_SKIP is 4 instead of 2

These values were calibrated separately for ORC and frame pointers (commit
2ee5b92a2598).  With UNWINDER_DWARF_CFI=y, the func_stack_trace option, the
stacktrace event trigger, the stacktrace probe command and
trace_dump_stack() take the frame-pointer branch and would drop one or two
real caller frames from their output.

Should these tests be CONFIG_UNWINDER_ORC || CONFIG_UNWINDER_DWARF_CFI, or
be keyed on !CONFIG_FRAME_POINTER?

[ ... ]

> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -25,6 +26,7 @@ KASAN_SANITIZE_dumpstack.o				:= n
>  KASAN_SANITIZE_dumpstack_$(BITS).o			:= n
>  KASAN_SANITIZE_stacktrace.o				:= n
>  KASAN_SANITIZE_paravirt.o				:= n
> +KASAN_SANITIZE_unwind_dwarf.o				:= n
>  
>  # With some compiler versions the generated code results in boot hangs, caused
>  # by several compilation units. To be safe, disable all instrumentation.
> @@ -41,6 +43,7 @@ KCOV_INSTRUMENT_stacktrace.o				:= n
>  KCOV_INSTRUMENT_dumpstack.o				:= n
>  KCOV_INSTRUMENT_dumpstack_$(BITS).o			:= n
>  KCOV_INSTRUMENT_unwind_orc.o				:= n
> +KCOV_INSTRUMENT_unwind_dwarf.o				:= n
>  KCOV_INSTRUMENT_unwind_frame.o				:= n
>  KCOV_INSTRUMENT_unwind_guess.o				:= n

With CONFIG_KMSAN=y, will this report false "uninit-value in
unwind_next_frame" on ordinary stack walks?

KASAN and KCOV are turned off for unwind_dwarf.o, but KMSAN stays on, while
the interpreter it calls is built with no KMSAN instrumentation
(kernel/unwind/Makefile has KMSAN_SANITIZE_dwarf_cfi.o := n).

In unwind_next_frame():

    struct dwarf_cfi_row row;
    ...
    err = dwarf_cfi_find(lookup_ip, &row);
    ...
    if (row.ra_rule == DWARF_CFI_RULE_UNDEFINED)

KMSAN poisons row on entry.  dwarf_cfi_find() fills it through
dwarf_cfi_unwind_eh_frame_hdr() or dwarf_cfi_mod_eval(), both out-of-line in
the uninstrumented dwarf_cfi.c, so their stores never clear the shadow.  The
later row.ra_rule, row.cfa_base and row.fp_rule tests then read poisoned
memory.

KMSAN depends only on HAVE_ARCH_KMSAN, clang and a few other options, and
UNWINDER_DWARF_CFI depends only on X86_64, so nothing prevents this
combination.  INIT_STACK_ALL_ZERO and INIT_STACK_ALL_PATTERN depend on
!KMSAN, so row is not pre-initialised.

Callers that would report include stack_trace_save() -> arch_stack_walk(),
arch_stack_walk_reliable(), perf_callchain_kernel() and __get_wchan().

unwind_frame.c marks unwind_next_frame() and update_stack_state()
__no_kmsan_checks for a related reason (commit 37ad4ee83642).

Would marking unwind_next_frame() __no_kmsan_checks, calling
kmsan_unpoison_memory(&row, sizeof(row)) after a successful
dwarf_cfi_find(), or building dwarf_cfi.o with
KMSAN_ENABLE_CHECKS_dwarf_cfi.o := n instead be needed here?  Adding
KMSAN_SANITIZE_unwind_dwarf.o := n alone would leave the callers' struct
unwind_state poisoned.

[ ... ]

> diff --git a/arch/x86/kernel/unwind_dwarf.c b/arch/x86/kernel/unwind_dwarf.c
> --- /dev/null
> +++ b/arch/x86/kernel/unwind_dwarf.c

[ ... ]

> +	lookup_ip = state->signal ? state->ip : state->ip - 1;
> +	err = dwarf_cfi_find(lookup_ip, &row);
> +	if (err) {
> +		/*
> +		 * Handle an interrupt/unwind starting right at the entry of
> +		 * arch_rethook_trampoline() before pushq $arch_rethook_trampoline.
> +		 */
> +		if (state->signal && is_rethook_trampoline(state->ip)) {
> +			state->ip = dwarf_recover_ret_addr(state, state->ip,
> +					(unsigned long *)(state->sp - sizeof(long)));
> +			if (!state->ip || is_rethook_trampoline(state->ip))
> +				goto err;

Can this fail to link when CONFIG_UNWINDER_DWARF_CFI=y and CONFIG_KPROBES=n?

unwind_next_frame() calls is_rethook_trampoline() unconditionally in
several places, and nothing guards those calls with CONFIG_RETHOOK.
is_rethook_trampoline() in include/linux/rethook.h is an unconditional
static inline:

    static inline bool is_rethook_trampoline(unsigned long addr)
    {
        return addr == (unsigned long)dereference_symbol_descriptor(arch_rethook_trampoline);
    }

On x86, arch_rethook_trampoline is defined only in
arch/x86/kernel/rethook.c, which is built only with
obj-$(CONFIG_RETHOOK).  RETHOOK is a hidden bool whose only selector is
KRETPROBE_ON_RETHOOK, which depends on KRETPROBES and therefore KPROBES.
UNWINDER_DWARF_CFI depends only on X86_64 and selects neither, so KPROBES=n
is a valid configuration.  There unwind_dwarf.o references
arch_rethook_trampoline, no object defines it, and vmlinux fails with an
undefined reference.

Other users are guarded: unwind_recover_rethook() in
arch/x86/include/asm/unwind.h and unwind_recover_ret_addr() in
arch/s390/include/asm/unwind.h use #ifdef CONFIG_RETHOOK, and this file
already guards the return_to_handler checks with
#ifdef CONFIG_FUNCTION_GRAPH_TRACER, but the rethook checks next to them
have no matching guard.

Should the rethook branch and comparisons be wrapped in
IS_ENABLED(CONFIG_RETHOOK), or should is_rethook_trampoline() get a stub
returning false when !CONFIG_RETHOOK?  No later patch in the series touches
unwind_dwarf.c, rethook.h or the x86 Kconfig.

[ ... ]

> +	while (!unwind_done(state) &&
> +	       (!on_stack(&state->stack_info, first_frame, sizeof(long)) ||
> +		state->sp <= (unsigned long)first_frame))
> +		unwind_next_frame(state);

This is the same skip loop as in unwind_orc.c, and a DWARF build has the
same code generation as an ORC build: CONFIG_FRAME_POINTER is off, so the
top-level Makefile does not add -fno-omit-frame-pointer
-fno-optimize-sibling-calls and sibling calls stay enabled.

The ftrace stack-trace skip counts are chosen only by CONFIG_UNWINDER_ORC
(kernel/trace/trace.c __ftrace_trace_stack() and trace_dump_stack(),
trace_functions.c STACK_SKIP and FTRACE_STACK_SKIP, trace_events_trigger.c
STACK_SKIP), so with CONFIG_UNWINDER_DWARF_CFI=y each takes the
frame-pointer branch.  Going by the ORC calibration, that would drop about
two frames for the function tracer's stacktrace option and trace_dump_stack(),
and about three for the stacktrace event trigger and func-probe command.
The exact count was inferred from the ORC calibration and not measured.

This patch already updates the ORC-keyed check in
arch/x86/net/bpf_jit_comp.c to
IS_ENABLED(CONFIG_UNWINDER_ORC) || IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI),
but not the ones in kernel/trace, and no later commit in the series touches
kernel/trace.

Should these conditionals also cover CONFIG_UNWINDER_DWARF_CFI, or be keyed
on whether frame pointers are used rather than on one unwinder?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============6395608148127476390==--
