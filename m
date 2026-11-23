Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395412;
	b=zbb4j5twS0oSeDDYGSxwamoYEyfXGcWOtovsbesxDZeYEaRNG02Qh0SxJaNQUBFVLdWm
	 sliVEOFtqmItO8wtx00l7876kfoaQYpSaG2NFXikTdNHkfH1XEB8sRSrzwtZfni8RhhFc
	 BK9aOEJ3QjdwCz6nDQ+GVvy5CC6xQegO/CqKJFS/mQUkkCfFiFq7vehqy/wD7PxluSiNm
	 FdyKp5yAFCPmDpZUof2CNFLOMRQjhbJV7Vw2T3qF4CXXFD7YegPdkWITNOXnZBw68Pmvz
	 X1ep66g5ny++0yHOxWJEQdCcKD8k1Fi0fKVqX5wSa8H/0Nii6s8aDkO2Qm6PDhjZq6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395412;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=QdnPsgi1JIpYuT67tkiyD2Yhhu+XpkvNkVZj99xVutw=;
	b=O4hwl1MjhZERhtW7BBuNxzLAL0Ikj+03LpNw1WMo63vyfDVFNcWvV7K3ficpJYwcZgCb
	 Y7jAal1kcrelyhak9tszM6vudd1sJgxf4erRz5u7WCV/DDVRhvBwGzQOO2NHnhMwyefWM
	 UkdAQ3GxmZM9aLeJY9H3veoC07qsthWbjU9zQueyyrtl14wXRnbtKn+0RTyGO20SFKeMw
	 4vnd3iqgrRrRqoh1zp0IKpYWb3pgukVcozWT7PcCWRISZjGCB7nnfQFE5e87MpMuMHQV0
	 XnqNt/B3nx+U4MhbtqdxXIaMc44QvGzIMKPpWpdlNSK/vc+1J+JtZnDrQ0g11uXONgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jP+DtLo+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9E5606A31A;
	Mon, 23 Nov 2026 00:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jP+DtLo+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542311F000D3;
	Mon, 23 Nov 2026 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395411;
	bh=QdnPsgi1JIpYuT67tkiyD2Yhhu+XpkvNkVZj99xVutw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jP+DtLo+pqEUL+mgGFb9mK+7wS/vZ3NQ0YFGncVbMKxXBhLmtQjw+LuGYYE9lnNlQ
	 Nagngxn0TqdQ0GBwZnzCTHa2hrjZaECs9NcpfEbEM38NPqYu8+J1uSHi9og59Ea+EQ
	 ECWfZhb3+VTt9llhlkMSGnzohunE7u4wPjibueusM5OEdbuotPWqJa+sPw8dUCOlTc
	 ibG9Phx5qC1NyZiTVCLD9BkeZQeYqVxieYZ8ub/DYmsKGiNy29etddHd3Kb158wW0a
	 xB5IwIvhrQV5tm8/VQ3k4WhP7kmddGQFr/mEjZgKQCzY35EU8Z/L2c8WJo+8Znx2WB
	 w7mU5PB8Ye1XA==
Content-Type: multipart/mixed; boundary="===============4215518125547156487=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <56e463aa6609799b8bd62ffd74e9791eb3f012b1e9f72a6460f7a978bf8b6162@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-8-irogers@google.com>
References: <20261122235757.3456048-8-irogers@google.com>
Subject: Re: [RFC PATCH v1 07/11] arm64/unwind: Add Minimal DWARF CFI kernel unwinder
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:56:47 +0000 (UTC)

--===============4215518125547156487==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> arm64/unwind: Add Minimal DWARF CFI kernel unwinder

TL;DR:
- DWARF CFI unwinder may WARN or truncate traces when IRQ hits the
  ftrace_caller epilogue under function_graph
- CFI lookups called from noinstr walks are kprobe-able
- Build may fail without PERF_EVENTS; unconditional notrace/KCOV exclusion

> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -8,6 +8,7 @@ CFLAGS_armv8_deprecated.o := -I$(src)
>  CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
>  CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
>  CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
> +CFLAGS_REMOVE_stacktrace.o = $(CC_FLAGS_FTRACE)
[ ... ]
> @@ -24,6 +25,7 @@ KASAN_SANITIZE_stacktrace.o := n
>  KCOV_INSTRUMENT_entry-common.o := n
>  KCOV_INSTRUMENT_idle.o := n
> +KCOV_INSTRUMENT_stacktrace.o := n

Both of these are unconditional, so they also apply to the default
CONFIG_UNWINDER_FRAME_POINTER build, where the unwinder is unchanged.

Do dump_backtrace(), show_stack(), arch_stack_walk_user() and the other
non-noinstr functions in stacktrace.c now lose function tracer, fentry/fexit
BPF attachment and KCOV coverage for frame pointer kernels?  The commit
message does not mention this.

The noinstr walkers were already excluded, and the only new function that
plausibly needs notrace is arm64_unwind_perf_caller_regs(), which exists
only with CONFIG_UNWINDER_DWARF_CFI.  Could these switches be made
conditional on CONFIG_UNWINDER_DWARF_CFI, or could that one function be
marked notrace instead?

> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c

[ ... ]

> + * Uses rcu_read_lock_sched_notrace() and rcu_dereference_raw() so lookups are
> + * safe inside noinstr stack walks and NMI contexts.
[ ... ]
> +static __always_inline int
> +arm64_dwarf_cfi_find(unsigned long pc, struct dwarf_cfi_row *row)
> +{
> +	size_t hdr_size = __stop_eh_frame_hdr - __start_eh_frame_hdr;
> +	int err;
> +
> +	err = dwarf_cfi_unwind_eh_frame_hdr(__start_eh_frame_hdr, hdr_size,
> +					    __start_eh_frame, __stop_eh_frame,
> +					    pc, &arm64_cfi_arch, row);
> +	if (!err)
> +		return 0;
> +
> +	return arm64_dwarf_cfi_module_find(pc, row);
> +}

arch_stack_walk(), arch_stack_walk_reliable() and arch_bpf_stack_walk() are
noinline noinstr, with every helper __always_inline, so that the walk cannot
be kprobed (see commit 0fbcd8abf337, "arm64: Prohibit instrumentation on
arch_stack_walk()").  Lockdep and irq tracing reach the walk through
return_address(), e.g. trace_hardirqs_off_finish() in arm64_enter_el1_dbg().

Doesn't this inlined helper make ordinary out-of-line calls into .text for
every frame?

  dwarf_cfi_unwind_eh_frame_hdr()   (kernel/unwind/dwarf_cfi.c, no
                                     NOKPROBE_SYMBOL)
  __module_address()                (kernel/module/main.c, for PCs outside
                                     vmlinux)
  dwarf_cfi_mod_eval()              (dwarf_cfi.c, for module PCs)

None of these are in __noinstr_text or __kprobes_text, so the kprobe
blacklist does not cover them.  A probe on dwarf_cfi_unwind_eh_frame_hdr()
can then be hit from inside the debug exception stack walk, which is the
path the noinstr marking was meant to close.  I could not show a nested
KPROBE_REENTER BUG in this tree because reenter_kprobe() now recovers from
KPROBE_HIT_SS reentry (23f851ac0078), but such probes would still be
reentered and counted as missed.

Is the kernel-doc claim that these lookups are "safe inside noinstr stack
walks and NMI contexts" accurate as written?  Should the interpreter and
module lookup entry points be noinstr or NOKPROBE_SYMBOL(), or the comment
be corrected?

[ ... ]

> +void arm64_unwind_perf_caller_regs(struct pt_regs *regs, unsigned long pc,
> +				   unsigned long caller_ip, unsigned long sp,
> +				   unsigned long fp)

arm64_unwind_perf_caller_regs() is a global function whose only prototype is
in arch/arm64/include/asm/perf_event.h.  stacktrace.c only gets that header
through <linux/perf_event.h>, which includes <asm/perf_event.h> under
CONFIG_PERF_EVENTS.  CONFIG_PERF_EVENTS is user selectable on arm64 and
UNWINDER_DWARF_CFI does not depend on it.

With CONFIG_PERF_EVENTS=n and CONFIG_UNWINDER_DWARF_CFI=y, doesn't this
definition get compiled with no previous prototype, so that
-Wmissing-prototypes (always enabled by scripts/Makefile.warn) fails the
build under CONFIG_WERROR=y?  The function and its EXPORT_SYMBOL_GPL() are
also dead code in that configuration, since perf_fetch_caller_regs() has no
callers without perf.

Should the definition and export be under CONFIG_PERF_EVENTS, or the
prototype moved to a header that is always included?

[ ... ]

> @@ -159,6 +414,22 @@ kunwind_recover_return_address(struct kunwind_state *state)
[ ... ]
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +	if (state->task->ret_stack &&
> +	    (state->common.pc == (unsigned long)return_to_handler)) {
> +		unsigned long orig_pc;
> +
> +		orig_pc = ftrace_graph_ret_addr(state->task, &state->graph_idx,
> +						state->common.pc, frame_key);
> +		if (state->common.pc == orig_pc) {
> +			WARN_ON_ONCE(state->task == current);
> +			return -EINVAL;
> +		}
> +		state->common.pc = orig_pc;
> +		state->flags.fgraph = 1;
> +	}
> +#endif /* CONFIG_FUNCTION_GRAPH_TRACER */

Under CONFIG_UNWINDER_DWARF_CFI, frame_key is state->sp, which matches the
retp recorded by ftrace_graph_func() only if the previous step computed a
CFA.  The link register fallback in kunwind_next_cfi() does not compute one:

	if (state->lr_valid && !is_bpf_text_address(lookup_pc)) {
		state->common.pc = state->lr;
		state->lr_valid = false;
		state->source = KUNWIND_SOURCE_FRAME;
		state->unreliable = true;
		return 0;
	}

state->sp is left at the interrupted SP, and kunwind_init_from_regs() and
kunwind_next_regs_pc() now set lr_valid = !!regs->regs[30].  The
ftrace_caller epilogue can reach this fallback:

	ldr  x29, [sp, #FREGS_FP]	// x29 = callsite FP
	ldr  x30, [sp, #FREGS_LR]	// x30 = return_to_handler if hooked
	ldr  x9,  [sp, #FREGS_PC]	// <- IRQ here
	add  sp, sp, #FREGS_SIZE + 32	// <- or here
	ret  x9

If an IRQ or pseudo-NMI lands on the ldr x9 or add sp instruction for a
function F hooked by ftrace_graph_func():

- regs->pc is in ftrace_caller, so arm64_dwarf_cfi_find() fails.
- x29 is already restored, so the old_fp == state->sp + sizeof(struct
  __arch_ftrace_regs) check is false and the ftrace_caller special case is
  skipped.
- The fallback sets pc = regs->regs[30] = return_to_handler, and state->sp
  stays at the interrupted SP, which is below F's CFA.
- kunwind_next()->kunwind_recover_return_address() then finds no ret_stack
  entry whose retp equals that SP, so ftrace_graph_ret_addr() returns
  return_to_handler unchanged.

At that point state->common.pc == orig_pc, so WARN_ON_ONCE(state->task ==
current) fires and the walk returns -EINVAL, cutting the trace off.  Current
task walks that can reach this include perf_callchain_kernel(),
show_regs()->dump_backtrace(regs), and any stack_trace_save() from IRQ
context (lockdep, KASAN, kmemleak, page_owner).  With function_graph tracing
and perf -g sampling the two instruction window can be hit regularly, and
with panic_on_warn it panics.

The frame pointer unwinder follows regs->regs[29] here and does not hit
this.  Can the ftrace_caller epilogue be recognised without relying on x29
(fregs->sp == state->sp + fsize is still valid until the add sp), or should
the walk stop without a WARN when return_to_handler is recovered from an LR
fallback whose SP was never advanced to a CFA?

[ ... ]

> @@ -251,6 +531,212 @@ kunwind_next_frame_record(struct kunwind_state *state)
>   * records (e.g. a cycle), determined based on the location and fp value of A
>   * and the location (but not the fp value) of B.
>   */
> +#ifdef CONFIG_UNWINDER_DWARF_CFI
> +/**
> + * kunwind_next_cfi() - Step one ARM64 kernel frame using Minimal DWARF CFI

Doesn't inserting kunwind_next_cfi() here leave the existing block comment
("Unwind from one frame record (A) to the next frame record (B). We
terminate early if ...") sitting above the new #ifdef and kernel-doc, about
200 lines away from kunwind_next(), which it was documenting?

The orphaned text describes frame record chaining, whereas
kunwind_next_cfi() steps by DWARF CFI and only uses frame records as a
fallback, so it is misleading for both functions.  Could the
CONFIG_UNWINDER_DWARF_CFI block be placed before that comment, directly
after kunwind_next_frame_record()?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============4215518125547156487==--
