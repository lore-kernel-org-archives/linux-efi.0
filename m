Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589260;
	b=o8ioq8lB8OQ/rRJSDHG6JEGn7eJyEv9wYH6HGUdSkPd20cpdnytYBY8TLk4uQz/qiK6f
	 QtTnyuCQely+PxXLralDD5BJOmdLR2GasOFisd/iO1fR8LUPLzRK2rP7U2CKFd4eUFSd6
	 yLHnplrDDnMjUfQdLH7Gb0tUFBvQwE0VZE45KMm7YAluvXysDfF6zUoo48irsqbH1LXmv
	 I1VFbKDWv1QDtzz0M7yAIm3DXO9g939q8hFwJtN7I5zH+53hQCuRTGBAQcUIiqv1tQnO7
	 OLBhWxA0gS91RX8QWTQIRPPKcNQ0eLEqoK7RpIOXXHvg649gujuM+uvTXoKe7OwyetQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589260;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=c6E3vhJF18VT/ALtmOG218hDUmfoGGhX7E17vVzgQpc=;
	b=Ah4L1f8i2K2rQGZfUxEMVmOqAMbLbJAmiTVT0SOFDk/0NPPXzoxZCDPWC7f9L6GY1x5G
	 Yrrvwm+mXOK7q/4B0OJDrUnUxhvRxy18OklfIV1YqoOTssbb4HizMwiBKsIAymascRuNF
	 kj94Bl2AySeMIzix8uE6AmaRt6enONVn0pTTszNqzElTlib+Fp6hcW+A6amb6zXfW0Q6+
	 R4h3OlZ05RvFlWwMwkPqnCfgC18lHXf1yw3ePMg+d6ubDG46QsLmHFtk974qygoXx+7oV
	 nMK8s7D2dBeab8fCX1QFXGAqn52BttK0tY0KitOXPhq3xVH3OCAN3dr6TZk5aVpp4cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZuOoomng;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92618606A31E;
	Wed, 25 Nov 2026 06:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZuOoomng
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402E21F000C6;
	Wed, 25 Nov 2026 06:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795589260;
	bh=c6E3vhJF18VT/ALtmOG218hDUmfoGGhX7E17vVzgQpc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZuOoomng7Q0qCBf3+h0s8WhDgOeLPtQNBhGaQ7/q/g9+tToaiE3s8xa3c+h3BFVfd
	 lE/dWb+paBw8VYwJdpNPvOJouCekbYBYXKBfuZN8V9kCSumeiH+dMppie69Y4tr3kl
	 FvG8eBLYdLrtdpYVVyc89TOsec71ZwEJJveINY84Qb0r+fvo7478W3J5OzpFM0/YuL
	 ie5dZMbS030VExWdAhTY7OoYC92yqcjK3eq/xpJa+pOpUBoGzzO6b3xAphe2e3r50Y
	 c+lEzjS8EUwCO+zvwq6Y1S7+GG2Mbj5he07cCJOmgens0p4ggxiq5kCVaDvBQv6OGK
	 sQea1O/gfXBIw==
Message-ID: <sashiko-outbox-232735@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 19/30] riscv/unwind: Add Minimal DWARF CFI kernel
 unwinder
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261125061523.1540234-20-irogers@google.com>
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-20-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:47:37 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] riscv: ftrace: missing arch_ftrace_fill_perf_regs() breaks
  fprobe unwind
--

commit 3d24292fed2450c8bd95936a258cfa1db43fe2ca
Author: Ian Rogers <irogers@google.com>

riscv/unwind: Add Minimal DWARF CFI kernel unwinder

This commit adds a Minimal DWARF CFI kernel unwinder
(CONFIG_UNWINDER_DWARF_CFI) and reliable stack trace support for 64-bit
RISC-V.

> diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftr=
ace.h
> index e5026cd8f022f..663831d950e57 100644
> --- a/arch/riscv/include/asm/ftrace.h
> +++ b/arch/riscv/include/asm/ftrace.h
> @@ -217,6 +217,7 @@ ftrace_partial_regs(const struct ftrace_regs *fregs, =
struct pt_regs *regs)
>  	regs->sp =3D afregs->sp;
>  	regs->s0 =3D afregs->s0;
>  	regs->t1 =3D afregs->t1;
> +	regs->cause =3D 0;
>  	return regs;
>  }
> =20

[ ... ]

> diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm=
/perf_event.h
> index bcc928fd3785c..30d0c6b37e910 100644
> --- a/arch/riscv/include/asm/perf_event.h
> +++ b/arch/riscv/include/asm/perf_event.h
> @@ -14,9 +14,11 @@
> =20
>  #define perf_arch_fetch_caller_regs(regs, __ip) { \
>  	(regs)->epc =3D (__ip); \
> +	(regs)->ra =3D 0; \
>  	(regs)->s0 =3D (unsigned long) __builtin_frame_address(0); \
>  	(regs)->sp =3D current_stack_pointer; \
>  	(regs)->status =3D SR_PP; \
> +	(regs)->cause =3D ~0UL; \
>  }
>  #endif
> =20

[ ... ]

> diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrac=
e.c
> index c7555447149bf..45d81aa11a8e2 100644
> --- a/arch/riscv/kernel/stacktrace.c
> +++ b/arch/riscv/kernel/stacktrace.c

[ ... ]

> +static __always_inline int
> +walk_stackframe_cfi(struct task_struct *task, struct pt_regs *regs,
> +		    bool (*fn)(void *, unsigned long), void *arg,
> +		    bool require_reliable)
> +{
> +	unsigned long fp, sp, pc, ra =3D 0, min_sp =3D 0, caller_fp =3D 0, call=
er_pc =3D 0;
> +	bool ra_valid =3D false, exact_pc =3D false, unreliable =3D false;
> +	struct llist_node *kr_cur =3D NULL;
> +	unsigned int used_stacks =3D 0;
> +	int graph_idx =3D 0;
> +	int level =3D 0;
> +
> +	if (!task)
> +		task =3D current;
> +
> +	if (regs && regs->cause =3D=3D ~0UL && !regs->ra) {
> +		if (require_reliable || task !=3D current)
> +			return -EINVAL;
> +		min_sp =3D regs->sp;
> +		caller_fp =3D regs->s0;
> +		caller_pc =3D regs->epc;
> +		regs =3D NULL;
> +	}

[Severity: Medium]
Should arch/riscv/include/asm/ftrace.h also define
arch_ftrace_fill_perf_regs()?

fentry_perf_func() and fexit_perf_func() in kernel/trace/trace_fprobe.c
allocate regs from the per-CPU __perf_regs[rctx] buffer via
perf_trace_buf_alloc() and populate it with ftrace_fill_perf_regs().
Without arch_ftrace_fill_perf_regs(), ftrace_fill_perf_regs() is a no-op
that only calls ftrace_partial_regs().  If an earlier tracepoint or
software perf event on the same CPU ran perf_arch_fetch_caller_regs(),
__perf_regs[rctx] retains regs->cause =3D=3D ~0UL and regs->ra =3D=3D 0 alo=
ng
with the earlier event's sp, s0 and epc, causing walk_stackframe_cfi() to
match the sentinel and filter the fprobe callchain against stale frame
bounds (or if __perf_regs[rctx] was never initialized, regs->status =3D=3D 0
causes user_mode(regs) to skip kernel callchain unwinding in
get_perf_callchain()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061523.1540=
234-1-irogers@google.com?part=3D19
