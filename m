Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795395418;
	b=MjdS9M9d+mR3aFIyKGnmAnquUgQxocTrEiiz9KhL1Wkij3jyaKBIW6+iqTpLDFFHnthG
	 A27mDAJLdXC2KNQLEHuGbQMHrP8HN3HZiCM7+38dKCpJS2XN4iEE7jKJWR2io/ogD7zol
	 kzttsHV0TPk46jBshZVrKJIT4hCA/o83ARqS2Kkkgt0ITKwwppF1Goh/DNHaOXvOhhxDs
	 T/OoNiPtU/5xuLpiX4QzSPyA7XMLwoQddMVtOr8a2M1QkqvrObbF3khCYHiUm0zsIOTbR
	 H4Tf9VH79GwBtDLfhPk0ItiR/PWJTwzF3QnYvO/BVE9XIz0bgb42tfAcT7pkZMOpz4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795395418;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=KA+34nbUB7XMJi78mwUnZXOmvWf/xqj1Zhx5rlyn5JE=;
	b=l+hBIR5RMDqVq/0jYfzhfkbQLXiymteT22e65PI+3XxmQ6J9nYJO5wTpVHo9mannWkAe
	 WWcMeWN0O+aF/Eyg3AO++joRuBrgi/VWXX+yhz6QVX//8KRtYQhFCPylhMiYfUFAPEsaL
	 XpaztUNKuSViTmIYFjYSwhNEmFFkcN0TItHYsu8A31pX3LCK1Jez9/eNZV1tqJUCoVDu9
	 X9Ow8Y1Bz7d4JAcSW4h0RJ7t7lyROtrYqz8PdlrSx6h3GANorStWHMOl6Ue8O9LOEoSIy
	 wrgWganVsp0hZXLOBs9mNwgqav9+ZckA86H4+KjdHV79Z2rXPJsMsgZag2mPt9kQgdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wwd4xK3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD5606A31A;
	Mon, 23 Nov 2026 00:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wwd4xK3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2317B1F000D0;
	Mon, 23 Nov 2026 00:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795395418;
	bh=KA+34nbUB7XMJi78mwUnZXOmvWf/xqj1Zhx5rlyn5JE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Wwd4xK3ubjWx19oPCMp9zWlFrE8juKoWZFCxK/5NkekvdxK/qa51b1bI863dR+Jr0
	 hNY6ijfHa2GZJbWR8L8ohbm82ZIb9vGJLPfnKs0uxlhMz89ds16bo4bjfo7nZzZIvm
	 CqZ9VBAyrw25Uq0Hnrd96UoU6t7L6WYhpxkClU+iV+3FdDtheHJs0/CcfA5ywqMRip
	 JknvBJjAGgj29NOZsa/IIqFVqtnBbpCQEJpo98T/sTgLbY88wLRq256Er7gXFaEoa0
	 3RryNB9N+JudV0I8P2nR949MUFqU+sE/kBpxBYOfmJkfdc0PIREHhrXnQ3vPafsL9R
	 16I8CrkXe55Eg==
Content-Type: multipart/mixed; boundary="===============3299975069991723205=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <446a1b870b63e07c6456e140f4fc260d09bd33cbc94fe9dbed4126be9c1e9844@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-10-irogers@google.com>
References: <20261122235757.3456048-10-irogers@google.com>
Subject: Re: [RFC PATCH v1 09/11] riscv/unwind: Add Minimal DWARF CFI kernel unwinder
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:56:54 +0000 (UTC)

--===============3299975069991723205==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv/unwind: Add Minimal DWARF CFI kernel unwinder

TL;DR:
- struct mod_arch_specific may be redefined (build error) with
  CONFIG_MODULES=n
- Stack walk may stop at IRQ stack top, losing frames
- return_address(n) may be off by one frame (unverified)
- fprobe comment nit

> diff --git a/arch/riscv/include/asm/module.h b/arch/riscv/include/asm/module.h
> --- a/arch/riscv/include/asm/module.h
> +++ b/arch/riscv/include/asm/module.h

[ ... ]

> +#if defined(CONFIG_MODULE_SECTIONS) || defined(CONFIG_UNWINDER_DWARF_CFI)
>  struct mod_arch_specific {
> +#ifdef CONFIG_MODULE_SECTIONS
>  	struct mod_section got;
>  	struct mod_section plt;
>  	struct mod_section got_plt;
> +#endif
> +#ifdef CONFIG_UNWINDER_DWARF_CFI
> +	struct mod_dwarf_cfi_index __rcu *dwarf_cfi_index;
> +#endif
>  };
> +#endif

Can this define struct mod_arch_specific twice when CONFIG_MODULES=n?

UNWINDER_DWARF_CFI only does 'select HAVE_MOD_ARCH_SPECIFIC if MODULES', and
MODULE_SECTIONS is selected by RELOCATABLE only 'if MODULES'.  With
CONFIG_MODULES=n and CONFIG_UNWINDER_DWARF_CFI=y, CONFIG_HAVE_MOD_ARCH_SPECIFIC
is unset, so include/asm-generic/module.h (included first) already provides:

	#ifndef CONFIG_HAVE_MOD_ARCH_SPECIFIC
	struct mod_arch_specific
	{
	};
	#endif

include/linux/module.h includes <asm/module.h> even with CONFIG_MODULES=n, so
the block above would then fail with a redefinition of struct
mod_arch_specific.

Before this patch, MODULE_SECTIONS guarded the struct and also selected
HAVE_MOD_ARCH_SPECIFIC, so the two always agreed.

Would guarding the struct with CONFIG_HAVE_MOD_ARCH_SPECIFIC, adding
'&& defined(CONFIG_MODULES)' to the UNWINDER_DWARF_CFI half of the condition,
or selecting HAVE_MOD_ARCH_SPECIFIC unconditionally from UNWINDER_DWARF_CFI
be better?

> diff --git a/arch/riscv/kernel/probes/rethook_trampoline.S b/arch/riscv/kernel/probes/rethook_trampoline.S
> --- a/arch/riscv/kernel/probes/rethook_trampoline.S
> +++ b/arch/riscv/kernel/probes/rethook_trampoline.S

[ ... ]

> +/*
> + * Under CONFIG_UNWINDER_DWARF_CFI, PT_EPC(sp) is seeded with
> + * &arch_rethook_trampoline before rethook_trampoline_handler() overwrites
> + * regs->epc with the restored caller PC prior to running rethook handlers,
> + * enabling reliable CFI unwinding across kretprobe and fprobe return hooks.
> + */
>  SYM_CODE_START(arch_rethook_trampoline)

This isn't a bug, but does fprobe use rethook in this tree?

FPROBE selects FUNCTION_GRAPH_TRACER and kernel/trace/fprobe.c has no rethook
references; the only rethook_hook() caller is pre_handler_kretprobe() in
kernel/kprobes.c.  So fprobe exits run through return_to_handler() in
mcount.S rather than arch_rethook_trampoline().

Should the comment mention only kretprobes, or point fprobe readers at
return_to_handler?

> diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
> --- a/arch/riscv/kernel/stacktrace.c
> +++ b/arch/riscv/kernel/stacktrace.c

[ ... ]

> +		if ((sp & (sizeof(long) - 1)) ||
> +		    !riscv_stack_bounds(task, sp, /*size=*/0, &cur_low,
> +					&cur_high))
> +			return -EINVAL;

Can this reject a valid sp at the top of the IRQ stack?

The CFA check only rejects values above the top:

	if ((cfa & (sizeof(long) - 1)) || cfa < cur_low || cfa > cur_high)

and the call_on_irq_stack() transition accepts the top:

	sp <= irq_low + IRQ_STACK_SIZE &&

but riscv_stack_bounds(task, sp, /*size=*/0, ...) only matches when
'addr < high'.

When the walker reaches the function that call_on_irq_stack() called while it
is still at its entry, sp is irq_stack_ptr + IRQ_STACK_SIZE, and the walk
returns -EINVAL before it can use the entry row.

One way to reach it:

local_bh_enable()
  do_softirq()
    do_softirq_own_stack()
      call_on_irq_stack(NULL, ___do_softirq)

If an ftrace callback on ___do_softirq takes a stack trace (func_stack_trace,
or an fprobe event with a stacktrace trigger), the ftrace_caller branch sets
sp to the IRQ stack top, and riscv_stack_bounds() then matches none of the
task, IRQ or overflow stacks.  The same happens for walks starting from
ftrace_partial_regs() pt_regs where regs->sp is the top, for example
fprobe/kprobe_multi BPF programs calling bpf_get_stackid()
-> perf_callchain_kernel() -> walk_stackframe(NULL, regs).  It also happens to
__do_softirq() when ___do_softirq() tail-calls it.

The trace then stops at ___do_softirq and loses call_on_irq_stack(),
do_softirq_own_stack() and every frame on the task stack.  There is no
memory-safety impact, and the old frame-pointer unwinder could not cross the
IRQ stack either, but this defeats the call_on_irq_stack() transition support
the commit message describes.

Should riscv_stack_bounds() accept addr == high when size == 0, or should the
IRQ stack top be special-cased here?

[ ... ]

> +noinline void notrace walk_stackframe(struct task_struct *task,
> +				      struct pt_regs *regs,
> +				      bool (*fn)(void *, unsigned long),
> +				      void *arg)
> +{
> +	walk_stackframe_cfi(task, regs, fn, arg, /*require_reliable=*/false);
> +}

Does return_address(n) now return an address one frame too far up with
CONFIG_UNWINDER_DWARF_CFI=y?

return_address() in arch/riscv/kernel/return_address.c does:

	data.level = level + 3;
	...
	arch_stack_walk(save_return_addr, &data, current, NULL);

The three skipped entries are arch_stack_walk, return_address and the caller
of return_address, which assumes arch_stack_walk() has its own frame.  That
held because CONFIG_FRAME_POINTER builds pass -fno-optimize-sibling-calls
(top-level Makefile).  This patch makes FRAME_POINTER unavailable under
UNWINDER_DWARF_CFI and adds -fomit-frame-pointer, so sibling-call
optimisation is back on at -O2.

arch_stack_walk() is a single forwarding call:

	noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
					      void *cookie,
					      struct task_struct *task,
					      struct pt_regs *regs)
	{
		walk_stackframe(task, regs, consume_entry, cookie);
	}

which is a candidate for 'tail walk_stackframe', leaving no frame of its own.
The walk would then report return_address, F, G, H instead of arch_stack_walk,
return_address, F, G, so return_address(n) yields __builtin_return_address(n+1)
of F.

That affects get_lock_parent_ip() (current->preempt_disable_ip, shown as
"Preemption disabled at:") and the preemptirq tracepoints and the
irqsoff/preemptoff tracers that use CALLER_ADDR1.  s390, which also unwinds
without frame pointers, adds CFLAGS_stacktrace.o += -fno-optimize-sibling-calls
in arch/s390/kernel/Makefile for this reason.

I haven't verified this by compiling for RISC-V, so it is inferred from the
compiler rules and the s390 precedent.  Would adding -fno-optimize-sibling-calls
for stacktrace.o under UNWINDER_DWARF_CFI, having arch_stack_walk() call an
always-inline walker directly, or adjusting the skip count in return_address()
be appropriate?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============3299975069991723205==--
