Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393451;
	b=tZ3VlEHpl6DRQg+EFeOo1SvwJk34sGUKLyAo8HF+AXxeFHA2VzJQ0UmEZdbXJX1vym8M
	 kZaNoCDqpqVgkbjO0gOUpkftWVXwzfuuvjpBfq4Snzu9JNOhthWSA4jLQf1ik5DHiOoRB
	 Tu9kHRJvwj8owMgRRyGvZBbN0cSwnRQ4eLE647I0agDcsscTg0E5Z1aQ1mJKjdRMCXAKf
	 4quTjNA/PXPaNN5m8gSDL55DLr/EfcJNi6Sc09zwiYd5XkNd5BAbGjUur8MNwcT1C3y9u
	 6QFKYcvhhwiDA3YVv7woe43UDumoKHeiIhP7PB/11kKMFG5Fe6TNogtha1CMVO5PClg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393451;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=eh79uWAdA4uD7RQrhb8Dgr/GdCQ0cYJwj+v2wkXzKDQ=;
	b=T6X3Z2ZeO46q7CLfKO5z8JciByCR7vsEXh+IjzEBK/TPS5BsHaTTJtDmRyX/ZoWfS+yy
	 QCpm9VKGGQOBqDk7n4q/R/8iotHxxyRt9BdSpAzoO7gZ6jrEYa0MFWYqB3bmgMZ+4XEKG
	 9fGwAUF9+dtIry6tND0CZOoCYQjgOD7sIFd7DI44Adw+LSaNcdHmiMgkegwTC/+Ori3m5
	 +AW1gBuVKQX/wkHu9fH6KaMF3eXm8pH8+LnnbxSBI8rhuvaGhzPUewTXvXQeXzYTqINwU
	 a0lLqjr7kpWkBSsvDyn8qniW0Q602tT1noSpqE/VtPrx62HnELyBl3TyqbF5bv7soCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJfcUn5C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF18D606A31A;
	Mon, 23 Nov 2026 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJfcUn5C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE491F000C6;
	Mon, 23 Nov 2026 00:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393451;
	bh=eh79uWAdA4uD7RQrhb8Dgr/GdCQ0cYJwj+v2wkXzKDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DJfcUn5ClW/3R9MGD5bLbXdGbGCSq/mCbfj7c92skPjNImvH69D+wA4ljZYj+UTmu
	 2lO+RRGQgfko7O3l1ZQaNVITvv/FnBNX6SnnTkiWjFkc/UsXFsekbaXO8rl1ltiffG
	 +xCrrX7vj4uKJvMBLDSxZYzCIGW5N02sruvUax8NjwV4JSOVfrvi4EQRq8dZmb1AoY
	 9EukDEHGJub8FKTA43yp1+vCGVmUGc5PmLalFwm3VpOKWYRiV4zlTUZf55Pmag7oZi
	 6Ll1pL7zAeHQucmONxFL6LM8nFU8FmztbziHRP+EwZXbyTf+3l6YLaH0uvNI8/wQlW
	 Y6TiBnUCr+7tw==
Message-ID: <sashiko-outbox-228469@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 09/11] riscv/unwind: Add Minimal DWARF CFI kernel
 unwinder
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261122235757.3456048-10-irogers@google.com>
References: <20261122235757.3456048-1-irogers@google.com>
 <20261122235757.3456048-10-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 00:24:09 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] riscv/unwind: off-by-one in return_address() from
  arch_stack_walk() tail call
- [Medium] riscv/unwind: broken leaf BPF frame detection in
  walk_stackframe_cfi()
- [Medium] riscv/unwind: riscv_stack_bounds() and handle_exception
  reject sp =3D=3D high
--

commit fd04e120d9c16cff3a5efd054c9692101ae1abd1
Author: Ian Rogers <irogers@google.com>

riscv/unwind: Add Minimal DWARF CFI kernel unwinder

This commit adds CONFIG_UNWINDER_DWARF_CFI to enable frame-pointer-free
kernel stack unwinding and reliable stack traces on 64-bit MMU-enabled
RISC-V kernels using Minimal DWARF CFI.

> diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrac=
e.c
> index c7555447149bf..05f846c147877 100644
> --- a/arch/riscv/kernel/stacktrace.c
> +++ b/arch/riscv/kernel/stacktrace.c
[ ... ]
> +static __always_inline unsigned int
> +riscv_stack_bounds(struct task_struct *task, unsigned long addr,
> +		   size_t size, unsigned long *out_low,
> +		   unsigned long *out_high)
> +{
> +	unsigned long low, high;
> +
> +	low =3D (unsigned long)task_stack_page(task);
> +	high =3D low + THREAD_SIZE;
> +	if (addr >=3D low && addr < high && addr + size >=3D addr &&
> +	    addr + size <=3D high) {
> +		*out_low =3D low;
> +		*out_high =3D high;
> +		return RISCV_STACK_TASK;
> +	}
> +
> +	if (task =3D=3D current && !preemptible()) {
> +#ifdef CONFIG_IRQ_STACKS
> +		low =3D (unsigned long)raw_cpu_read(irq_stack_ptr);
> +		high =3D low + IRQ_STACK_SIZE;
> +		if (low && addr >=3D low && addr < high && addr + size >=3D addr &&
> +		    addr + size <=3D high) {
> +			*out_low =3D low;
> +			*out_high =3D high;
> +			return RISCV_STACK_IRQ;
> +		}
> +#endif
> +#ifdef CONFIG_VMAP_STACK
> +		low =3D (unsigned long)raw_cpu_ptr(overflow_stack);
> +		high =3D low + OVERFLOW_STACK_SIZE;
> +		if (addr >=3D low && addr < high && addr + size >=3D addr &&
> +		    addr + size <=3D high) {
> +			*out_low =3D low;
> +			*out_high =3D high;
> +			return RISCV_STACK_OVERFLOW;
> +		}
> +#endif
> +	}
> +
> +	return 0;
> +}
[ ... ]
> +		if (pc >=3D (unsigned long)handle_exception &&
> +		    pc < (unsigned long)&ret_from_exception_end) {
> +			struct pt_regs *er =3D (struct pt_regs *)sp;
> +			unsigned long status, next_sp, next_ra;
> +
> +			if (sp & (sizeof(long) - 1))
> +				return -EINVAL;
> +			cur_stk =3D riscv_stack_bounds(task, sp, sizeof(*er),
> +						     &cur_low, &cur_high);
> +			if (!cur_stk)
> +				return -EINVAL;
> +			status =3D READ_ONCE_TASK_STACK(task, er->status);
> +			if ((status & SR_PP) =3D=3D 0)
> +				return 0;
> +			if (require_reliable)
> +				return -EINVAL;
> +
> +			next_pc =3D READ_ONCE_TASK_STACK(task, er->epc);
> +			next_sp =3D READ_ONCE_TASK_STACK(task, er->sp);
> +			next_fp =3D READ_ONCE_TASK_STACK(task, er->s0);
> +			next_ra =3D READ_ONCE_TASK_STACK(task, er->ra);
> +			if (next_sp & (sizeof(long) - 1))
> +				return -EINVAL;
> +			next_stk =3D riscv_stack_bounds(task, next_sp,
> +						      sizeof(long),
> +						      &low, &high);
> +			if (!next_stk)
> +				return -EINVAL;

[Severity: Medium]
Does riscv_stack_bounds() reject a valid stack pointer at the top of the
IRQ stack (sp =3D=3D irq_stack_ptr + IRQ_STACK_SIZE)?

call_on_irq_stack() sets sp to irq_stack_ptr + IRQ_STACK_SIZE before
calling handle_riscv_irq() or ___do_softirq().  At the pre-prologue entry
(such as after unwinding ftrace_caller) or post-epilogue ret of that root
function, sp equals high.  Because riscv_stack_bounds() requires addr <
high even when size =3D=3D 0, and the handle_exception check passes size =3D
sizeof(long) instead of 0 for next_sp, unwinding from or across that point
aborts with -EINVAL.

[ ... ]

> +			/*
> +			 * Fallback to frame-pointer record at (fp - 16) for
> +			 * JITed BPF programs and BPF trampolines.
> +			 */
> +			if (!require_reliable && !(sp & 0x7) &&
> +			    riscv_stack_bounds(task, sp, /*size=3D*/0, &cur_low,
> +					       &cur_high) &&
> +			    !(fp & 0x7) &&
> +			    fp >=3D sp + sizeof(struct stackframe) &&
> +			    fp <=3D cur_high) {
> +				struct stackframe *fr =3D (struct stackframe *)fp - 1;
> +				unsigned long old_fp =3D fp;
> +
> +				next_fp =3D READ_ONCE_TASK_STACK(task, fr->fp);
> +				next_pc =3D READ_ONCE_TASK_STACK(task, fr->ra);
> +				if (exact_pc && ra_valid &&
> +				    !(next_pc & 0x7) &&
> +				    next_pc >=3D old_fp && next_pc <=3D cur_high) {
> +					/* Leaf BPF prog without saved ra */
> +					fp =3D next_pc;
> +					pc =3D ra;
> +				} else {
> +					next_pc =3D riscv_recover_ret_addr(task,
> +							&graph_idx, &kr_cur,
> +							next_pc, old_fp,
> +							&fr->ra);
> +					if (!next_pc)
> +						return 0;
> +					fp =3D next_fp;
> +					pc =3D next_pc;
> +				}
> +				sp =3D old_fp;
> +				ra_valid =3D false;
> +				exact_pc =3D false;
> +				unreliable =3D true;
> +				continue;
> +			}

[Severity: Medium]
Will the leaf BPF program check fail when its C caller was built with
-fomit-frame-pointer?

In bpf_jit_build_prologue(), a leaf BPF program omits saving RV_REG_RA and
saves the caller's s0 at fp - 8 (fr->ra):

arch/riscv/net/bpf_jit_comp64.c:bpf_jit_build_prologue() {
    ...
	if (seen_reg(RV_REG_RA, ctx)) {
		emit_sd(RV_REG_SP, store_offset, RV_REG_RA, ctx);
		store_offset -=3D 8;
	}
	emit_sd(RV_REG_SP, store_offset, RV_REG_FP, ctx);
	store_offset -=3D 8;
    ...
}

Under CONFIG_UNWINDER_DWARF_CFI=3Dy, the C caller uses s0 as an ordinary
callee-saved register rather than a frame pointer in [old_fp, cur_high].
When an interrupt or perf sample lands inside a leaf BPF program, next_pc
(the caller's s0) fails the [old_fp, cur_high] check and the else branch
treats that s0 value as the return PC, truncating the stack trace above the
BPF frame.

[ ... ]

> +noinline void notrace walk_stackframe(struct task_struct *task,
> +				      struct pt_regs *regs,
> +				      bool (*fn)(void *, unsigned long),
> +				      void *arg)
> +{
> +	walk_stackframe_cfi(task, regs, fn, arg, /*require_reliable=3D*/false);
> +}

[Severity: Medium]
Can tail-call optimization of arch_stack_walk() -> walk_stackframe() shift
return_address(level) by one frame under CONFIG_UNWINDER_DWARF_CFI=3Dy?

return_address() sets data.level =3D level + 3 expecting return_address(),
arch_stack_walk(), and walk_stackframe() to be separate frames:

arch/riscv/kernel/return_address.c:return_address() {
    ...
	data.level =3D level + 3;
	data.addr =3D NULL;

	arch_stack_walk(save_return_addr, &data, current, NULL);
    ...
}

Unlike CONFIG_FRAME_POINTER=3Dy, CONFIG_UNWINDER_DWARF_CFI=3Dy does not add
-fno-optimize-sibling-calls, so arch_stack_walk() tail-calls the noinline
walk_stackframe() without creating a stack frame.  When
walk_stackframe_cfi() skips walk_stackframe() via level =3D -1, the first
frame reported to save_return_addr() is return_address() instead of
arch_stack_walk(), causing return_address(level) and CALLER_ADDR* to return
the caller at level + 1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122235757.3456=
048-1-irogers@google.com?part=3D9
