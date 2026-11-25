Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590415;
	b=frJCnlGquNkWNSdncn7y6Mhtf2Lct5BENnPM7Ueu/8HzAOQ+XhyKUOEgeTZw98/GRa6A
	 TwkIcaa/K5/W43+E3F1izvkEF+Ou8y4XJYoAePBdZzc8q/7zaI+dJhEfiyr+ftcFP6/lo
	 M0QL6AzTS5DBHlcsSkK+mZrabrWpCXOCyXU9dWxwoaHdWwEerEhttmtCOhcjeTDg4IBw1
	 PZh2su82GvrOX01ALG1X/bmwYXc4CSOng5eS4rDo/WWxLRUvaktCyfiQNhxaxdh0QHC4g
	 FF9tXH8alJISFAb3vwLrmICG8axmBTRAMdvQFwTxy3ps9CuCRIlH3cuAyZ2pvw9PVIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590415;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=6+2sBF4UGgNSi1pC4PKTKJ+2fuWG4BySrMPF8SXLyvw=;
	b=So79Vvm7lv2y7X/nAg7zcbcGKwKuPmz7hzdZsrfjBrGA8Fd2OUAi7jKt84VpnVNIPygd
	 GZH92WJfO4OudSjBJaFp+nGKgCwNmbiQMcuLDV6pSUEQlxF4zfFh+wtJErF0TB0d9nJws
	 Che1N9YIAdfUj1t5RJgpk6QzzMnIRc0BQy9hbGkhEvZ0Go31yViYba3wzLecMaV3FugUv
	 aGRNCv/kJ6uc7ldmiaJ2i5mL7sgGwN8k0pZ8BQ1fUchBv2tv0CkSyTkEkkLV/fCVlqp83
	 kC/0PGbtQ1x7hkTQ1YxFnNFKFP9QXm8RALp9QerkqbmmnYsBh17qL5kufO7mJLPGDbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EYDA9t8w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BF460A2606;
	Wed, 25 Nov 2026 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EYDA9t8w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362D41F000EB;
	Wed, 25 Nov 2026 07:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590414;
	bh=6+2sBF4UGgNSi1pC4PKTKJ+2fuWG4BySrMPF8SXLyvw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=EYDA9t8wPTTIOmpJQN+1x/1ojVmic2gMFJnin56uQu21yU2ozij8RaQrM+4OddC8c
	 yaV6kxuA0FVl63uhWjhk0Tt0UClD35F5droy0lb8c2KbMrGlt0oNRemaEc2jpn4ZKw
	 veHmUL8m7aOP0O0PFp14n1H8AA2DGm+UgzH7DTLZE0qhOiMEBv+pe4JeLsUEyTy4KO
	 87/WG3vvAVX49+K8oNuIGwQKEyqpEAsaWmwC5dxqAIij70w1ftKqt6BQmCDhJZYDpe
	 NT/TNbzo6EoDnXW9N2T0Fm11Un4rp8nQ5t+ADm4hRyNz3I4dxq6cNnOcsmVgdzc6SK
	 a9j1oqe2P2h5g==
Content-Type: multipart/mixed; boundary="===============8194175368741298771=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <a8cf21b1f0e36cfeac11d08e6093e9abc8037e04d1747d452498bf79941c5ddb@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-17-irogers@google.com>
References: <20261125061523.1540234-17-irogers@google.com>
Subject: Re: [RFC PATCH v2 16/30] arm64/unwind: Add Minimal DWARF CFI kernel unwinder
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:50 +0000 (UTC)

--===============8194175368741298771==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> arm64/unwind: Add Minimal DWARF CFI kernel unwinder

TL;DR: The module lookup (__module_address) called from the noinstr arm64
stack walkers is unannotated, so kprobes or tracing may re-enter the walker
and RCU may not be watching; no concrete crash found.

> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c

[ ... ]

> +/**
> + * arm64_dwarf_cfi_module_find() - Look up Minimal DWARF CFI in loadable modules
> + * @pc: Kernel instruction pointer to evaluate.
> + * @row: Output evaluated Minimal DWARF CFI row.
> + *
> + * Uses rcu_read_lock_sched_notrace() and rcu_dereference_raw() so lookups are
> + * safe inside noinstr stack walks and NMI contexts.
> + *
> + * Return: 0 on success, -ENOENT if @pc is not in a module FDE, or a negative
> + * errno on invalid FDE bytecode.
> + */
> +static __always_inline int
> +arm64_dwarf_cfi_module_find(unsigned long pc, struct dwarf_cfi_row *row)
> +{
> +	struct mod_dwarf_cfi_index *idx;
> +	struct module *mod;
> +	int ret;
> +
> +	rcu_read_lock_sched_notrace();
> +	mod = __module_address(pc);

Is this safe inside the noinstr stack walkers?

arm64_dwarf_cfi_module_find() is __always_inline into arch_stack_walk(),
arch_stack_walk_reliable() and arch_bpf_stack_walk(), which are all
noinline noinstr.  But __module_address() is an ordinary out-of-line
function with no noinstr, notrace or NOKPROBE_SYMBOL() annotation, and it
calls mod_find(), which is also unannotated.

The arm64 walker was made noinstr by commit 0fbcd8abf337 ("arm64: Prohibit
instrumentation on arch_stack_walk()") because the stacktrace code can be
used in kprobe context and cannot be safely probed.  With
CONFIG_UNWINDER_DWARF_CFI=y, any pc not covered by the vmlinux
.eh_frame_hdr (module text, BPF JIT code, asm without CFI such as the
el1h_64_sync vectors) goes to __module_address().  Can a kprobe, fprobe or
function tracer attached to __module_address() or mod_find() now fire from
inside the walker, for example via a kprobe event with a stacktrace trigger
that re-hits the probe?

Separately, rcu_read_lock_sched_notrace() only skips lockdep and tracing.
It does not make RCU watch, so is the RCU-sched read side section valid
in a noinstr region where RCU may not be watching?

The comment claims the lookup is "safe inside noinstr stack walks and NMI
contexts", and the commit message calls kunwind_next_cfi() "noinstr-safe".
Either the module lookup path needs to be noinstr or kprobe-blacklisted,
or the comment and commit message should drop that claim.  I could not
construct a concrete crash through the current kprobe re-entry handling.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============8194175368741298771==--
