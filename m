Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393474;
	b=Fn4B5L07GWSGJtb1CqGSDaHBYNh0Iu7Hfd9XA57RWDd2yPMVmo0FyVJJRnsHTlTFjAQR
	 M0qRvatu8/xi/OdIbce5FkzxGt3+iqNDwTCqyQQgEClveCx47unRmdmimCAIUrLiqeECC
	 JIhukB9OIkSCDt1exodgO3SJ1HXSRYo69KcKn0HH/WXaKe4sSdn2EjisIZUZAZ6ByXBLO
	 2tLkiMnBobFc5TnXDs/8uVydn7n2kl1zpRYojM97AGcMVk2jTBi+aqULCopE0cyeS5YOn
	 qnXSm5tw0PpHfaPZc5jIRSpzgFWfzakJUwDf/n+22/MCqwxFylGiBORueagl/dw7O7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393474;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=djsWLBwq9SIi46w4Fd2jJqnlvhKzFWkr+C9x7VawO40=;
	b=i1J5OmlQw+yv26G99bjiBVl4+g9i810dHABZz1FtpMR/7S+GmcH+xhPpk2uo+Y7nORNC
	 vYWtxq7BNrOLJVLbQNjfub2NzBWndGCcDWFpz0Wd5IwAa7RqY7SATKOyA/z4fOhZUMMNf
	 aW2WtHzg0iPNL4IZ+h4DwqYwviX7LClVc9sveSi3C6zH/Au0l2UZdMc7GUaFqaUPHk0SI
	 Dnx7x8vvjbs52wCVpsmr48c7L67MNirMdyDI/Dlzc5gi4GuD+fdaPGnpI4CO12RTOUypi
	 qSEDc3Hsl2/p80jYRuHV0cKt/4tDY9H8HIe2KPD86Z5cEgwmSEsAw/DXv8QJx2vimXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="j6hWi/h+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F7B0606A31A;
	Mon, 23 Nov 2026 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6hWi/h+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6351F000CA;
	Mon, 23 Nov 2026 00:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393473;
	bh=djsWLBwq9SIi46w4Fd2jJqnlvhKzFWkr+C9x7VawO40=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j6hWi/h+3EpQ4VunZrDM2ttRU8IoQfcUW2cfv+l+9uj5l82ktQpyzndp9yWI294fL
	 Od2h4e32otM+00+76uSDu/ViKuG/TZ4AtxbP2xqDFdsnurCgPFBkhZSa0oJ7YFSNKq
	 mFXEtRVzJxtqrVx4PGyVlpCcDerjjREqwhW8ezK6X8owXuOZzbNPjNZNDfRcl1U/Gi
	 7eN6sBREAxKd0m2th4N7kQkmlYDntEAUC7W15GB6HkddW9bUMoSnc/xBZD7Oh/JhgO
	 t5EMNPrHds3e4P/TXCp7GNlp97g/UDLteqQc2Ex4Z8cNsDE0OXLlu+uQlMiqQPVIr3
	 UXkaOpj3hdodA==
Message-ID: <sashiko-outbox-228470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 07/11] arm64/unwind: Add Minimal DWARF CFI kernel
 unwinder
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261122235757.3456048-8-irogers@google.com>
References: <20261122235757.3456048-1-irogers@google.com>
 <20261122235757.3456048-8-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 00:24:31 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] arm64: perf: eager CFI walk and off-by-4 PC in
  perf_arch_fetch_caller_regs()
- [Medium] arm64: vdso: -fomit-frame-pointer breaks vDSO unwinding with
  DWARF CFI
- [Low] arm64: Kconfig disables LATENCYTOP and fault-injection filter
  with DWARF CFI
- [Low] arm64: stacktrace: unused frame_key in
  kunwind_recover_return_address()
--

commit 2d8be9c8d60de13378d6fcee8e46e78f6a7a8167
Author: Ian Rogers <irogers@google.com>

arm64/unwind: Add Minimal DWARF CFI kernel unwinder

This commit adds CONFIG_UNWINDER_DWARF_CFI as a kernel unwinder choice
alongside CONFIG_UNWINDER_FRAME_POINTER on arm64, building the kernel
with -fomit-frame-pointer and unwinding kernel frames via Minimal DWARF
CFI tables.

> diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
> index 265c4461031f4..4f5c99a2fa967 100644
> --- a/arch/arm64/Kconfig.debug
> +++ b/arch/arm64/Kconfig.debug
> @@ -1,5 +1,37 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> =20
> +choice
> +	prompt "Choose kernel unwinder"
> +	default UNWINDER_FRAME_POINTER
> +	help
> +	  This determines which method will be used for unwinding kernel stack
> +	  traces for panics, oopses, bugs, warnings, perf, /proc/<pid>/stack,
> +	  livepatch, lockdep, and more.  If unsure, keep the default frame
> +	  pointer unwinder.
> +
> +config UNWINDER_FRAME_POINTER
> +	bool "Frame pointer unwinder"
> +	select ARCH_WANT_FRAME_POINTERS
> +	select FRAME_POINTER
> +	help
> +	  This option enables the standard frame pointer (x29) unwinder for
> +	  unwinding kernel stack traces on arm64.  Kernel code is compiled
> +	  with frame records stored on the stack at a small runtime register
> +	  and code-size cost.
> +
> +config UNWINDER_DWARF_CFI
> +	bool "Minimal DWARF CFI unwinder"
> +	depends on (!FUNCTION_TRACER || DYNAMIC_FTRACE_WITH_ARGS) && (!SHADOW_C=
ALL_STACK || DYNAMIC_SCS)
> +	select UNWIND_DWARF_CFI
> +	select UNWIND_TABLES

[Severity: Low]
Moving select FRAME_POINTER out of config ARM64 and under
CONFIG_UNWINDER_FRAME_POINTER leaves CONFIG_FRAME_POINTER disabled when
CONFIG_UNWINDER_DWARF_CFI=3Dy.  Because LATENCYTOP and
FAULT_INJECTION_STACKTRACE_FILTER in lib/Kconfig.debug still depend on:

	depends on FRAME_POINTER || MIPS || PPC || S390 || MICROBLAZE || ARM || AR=
C || X86

should ARM64 (or UNWINDER_DWARF_CFI) be added to those dependency lists
so both features remain selectable with the DWARF CFI unwinder?

> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index ed28f94be428e..7ec8e96b20329 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -23,6 +23,11 @@ ifeq ($(CONFIG_ARM64_ERRATUM_843419),y)
>  LDFLAGS_vmlinux	+=3D --fix-cortex-a53-843419
>  endif
> =20
> +ifeq ($(CONFIG_UNWINDER_DWARF_CFI),y)
> +KBUILD_CFLAGS	+=3D -fomit-frame-pointer
> +LDFLAGS_vmlinux	+=3D --eh-frame-hdr
> +endif

[Severity: Medium]
Does adding -fomit-frame-pointer globally to KBUILD_CFLAGS break user
stack unwinding through the arm64 vDSO?

Unlike arch/arm64/kvm/hyp/nvhe/Makefile, arch/arm64/kernel/vdso/Makefile
does not filter out -fomit-frame-pointer or pass -fno-omit-frame-pointer,
and arch/arm64/kernel/vdso/vdso.lds.S discards *(.eh_frame .eh_frame_hdr).
Non-leaf vDSO C functions (such as __kernel_getrandom and
clock_gettime_fallback) are therefore built without frame records and
linked without .eh_frame tables, breaking both arch_stack_walk_user() and
user-space frame-pointer unwinders when a thread is inside the vDSO.

> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm=
/perf_event.h
> index ee45b4e773470..4a7dbb7ce41c9 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -13,11 +13,26 @@
>  #define perf_arch_bpf_user_pt_regs(regs) &regs->user_regs
>  #endif
> =20
> +#ifdef CONFIG_UNWINDER_DWARF_CFI
> +void arm64_unwind_perf_caller_regs(struct pt_regs *regs, unsigned long p=
c,
> +				   unsigned long caller_ip, unsigned long sp,
> +				   unsigned long fp);
> +
> +#define perf_arch_fetch_caller_regs(regs, __ip) do {			\
> +	unsigned long __here_pc, __here_fp;				\
> +	asm volatile("1: adr %0, 1b\n\t"				\
> +		     "mov %1, x29"					\
> +		     : "=3Dr" (__here_pc), "=3Dr" (__here_fp));		\
> +	arm64_unwind_perf_caller_regs((regs), __here_pc, (__ip),	\
> +				      current_stack_pointer, __here_fp);\
> +} while (0)

[Severity: High]
Does perf_arch_fetch_caller_regs() need to perform a full DWARF CFI
lookup and bytecode evaluation eagerly on every call, and does storing
__ip in regs->pc cause kunwind_next_cfi() to look up the caller FDE at
an off-by-4 address?

perf_fetch_caller_regs() runs unconditionally on every tracepoint hit in
do_perf_trace_##call() and on every context switch with active software
events in __perf_sw_event_sched(), even when no callchain is requested.
Replacing the four inline register stores with
arm64_unwind_perf_caller_regs() constructs stack_info descriptors, binary
searches .eh_frame_hdr (and module FDE tables), and evaluates DWARF CFI
bytecode on every event.

In addition, perf_fetch_caller_regs() passes CALLER_ADDR0 (call_insn + 4)
as __ip.  arm64_unwind_perf_caller_regs() steps regs->sp and
regs->regs[29] to the caller frame and sets regs->pc =3D caller_ip, but
when perf_callchain_kernel() later unwinds those regs,
kunwind_init_from_regs() sets state->source =3D KUNWIND_SOURCE_REGS_PC.
kunwind_next_cfi() then skips the - 4 adjustment:

	lookup_pc =3D (state->source =3D=3D KUNWIND_SOURCE_REGS_PC) ?
		    state->common.pc : state->common.pc - 4;

and evaluates the caller's CFI at call_insn + 4 instead of call_insn,
which can mis-unwind if call_insn sits immediately before an epilogue or
FDE boundary.

> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrac=
e.c
> index 3ebcf8c53fb04..9ce0e3f6cabe6 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c

[ ... ]

> @@ -124,19 +363,35 @@ kunwind_init_from_task(struct kunwind_state *state,
> =20
>  	state->common.fp =3D thread_saved_fp(task);
>  	state->common.pc =3D thread_saved_pc(task);
> +	state->sp =3D thread_saved_sp(task);
>  	state->source =3D KUNWIND_SOURCE_TASK;
>  }
> =20
> +/**
> + * kunwind_recover_return_address() - Restore fgraph/kretprobe return ad=
dresses
> + * @state: Current ARM64 kernel unwind state.
> + *
> + * Replaces return_to_handler and __kretprobe_trampoline return addresse=
s with
> + * the original caller PC from @state->task's shadow stacks in either ho=
oking
> + * order. Under CONFIG_UNWINDER_DWARF_CFI (-fomit-frame-pointer), entrie=
s are
> + * keyed on the frame's entry SP (@state->sp, equal to the callee's CFA)=
 rather
> + * than x29.
> + *
> + * Return: 0 on success, or -EINVAL if a shadow return address cannot be=
 found.
> + */
>  static __always_inline int
>  kunwind_recover_return_address(struct kunwind_state *state)
>  {
> +	void *frame_key =3D IS_ENABLED(CONFIG_UNWINDER_DWARF_CFI) ?
> +			  (void *)state->sp : (void *)state->common.fp;

[Severity: Low]
When both CONFIG_FUNCTION_GRAPH_TRACER and CONFIG_KRETPROBES are
disabled, frame_key is unused in kunwind_recover_return_address(),
triggering a -Wunused-variable warning.  Should frame_key be marked
__maybe_unused?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122235757.3456=
048-1-irogers@google.com?part=3D7
