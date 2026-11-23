Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795394390;
	b=wkR17IfvotiDZVaJ1nwcvGSQcpOKIC86iqa+iXWa9cxlfkMg6FVEJtk5kbj+1wQbSdZY
	 5dCXJvLZ2eEgRAJS93yiGGMALdsBkNoeZGdROG/WZOqFTQQ07rsHfu6HBPTJzjEArN7+Y
	 Z+JiIbvg6Hyx9rBBAL+5+OT6g2n5Nqc6Dh9CN8G9HJ30HL8nFtk6Gh/VznjQOWTGd+eWU
	 7gFcpNdM+MxjbqTJ1q6GvRYseQG8wLEhEztaIFqMbt5+beEfQ0yFgSVrmXFwku4NYhkWb
	 /o/CZihtXzFNfw+hXeBJ5jeSD0lR3SAGh5wG+rMNmwikSpw6yoHe8CrmFt/kC8OpZVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795394390;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=PoQAgAi4SsG/ALVfUnoUkJyn+DyGMuCfLxAQhCZvy1U=;
	b=GJHzsyXOo0H6H1aQ6RlR8veU31WCbBKk2I78A6BqBKpux2U9yQL9nd/jE9uIErv2FguM
	 DT7ceDugUbQa1BziJVbn5L5TKFC77D96RBGZWvjNSWmWCYuH+uFXVWeOH9nzFgIo1ePPh
	 eFHQV3f4oE6rs7MX73N68mlU2GRyXnO1/B1IVXDc1qL3A4ryPdQiyU/ZHAxm2hxW+cdB8
	 Ts5rta9JEO0PRpVZ1A3ntOnzx5uamovgDlyTxG3bjKgEINmMUCRTV9qDqNO7Pvb9ATSEE
	 7CnVPSbSZzWkf34z2dB18t8WqjuLlJzzF9AJCxIJWfIJWLv2lxBh9iq39+qAryMH3KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQyg0+hy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44EE606A31A;
	Mon, 23 Nov 2026 00:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jQyg0+hy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879B01F000CA;
	Mon, 23 Nov 2026 00:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795394389;
	bh=PoQAgAi4SsG/ALVfUnoUkJyn+DyGMuCfLxAQhCZvy1U=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jQyg0+hyIOUk5ZUyV35FWjse5XowVORSf874N4s6kc8mr2FsoTNaawGmqqpQCkjS9
	 ZwDRYmI0saY6rlsrczcP/rB3PIa+akAwyvKzcK6reziBxFWamgV8edcWzxXSOCdAcY
	 Np1I9BaTgKWLXBX6ABscXy97xhTu9tsuTO9Me0ecZeUgnJdsAjxTXyn1dCCxzZTSii
	 zA1vphX2daI3J96L1I3YIK+1wqe0d7mHE6Al2pPzx2EiI/qR6tbwLTDXTVj+nkoYfM
	 C7UMQ/NlJxXLnP6PHPmAga4Em6YJjVb2Q7UYely1UtvU/ZjJlCrzjLca4VHj4ei9ZR
	 ZTn3txTyJls3Q==
Content-Type: multipart/mixed; boundary="===============8029890971532200664=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <1a25d1706794155410612608bd28a535e5f6796b96cd294439b19f55ac467c82@mail.kernel.org>
In-Reply-To: <20261122235757.3456048-9-irogers@google.com>
References: <20261122235757.3456048-9-irogers@google.com>
Subject: Re: [RFC PATCH v1 08/11] riscv: unwind_user: Support Minimal DWARF CFI and FP user unwinding
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mas
 on@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 23 Nov 2026 00:39:45 +0000 (UTC)

--===============8029890971532200664==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv: unwind_user: Support Minimal DWARF CFI and FP user unwinding

TL;DR:
- Nits only: a comment names a nonexistent __compat_vdso_rt_sigreturn symbol
- The !CONFIG_MMU branch in the sigreturn unwinder looks like dead code, since
  Kconfig requires MMU

> diff --git a/arch/riscv/kernel/compat_signal.c b/arch/riscv/kernel/compat_signal.c
> --- a/arch/riscv/kernel/compat_signal.c
> +++ b/arch/riscv/kernel/compat_signal.c

[ ... ]

> +#ifdef CONFIG_UNWIND_USER
> +/**
> + * compat_unwind_user_sigreturn() - Unwind an RV32 compat vDSO rt_sigreturn frame
> + * @state: Current user unwind state.
> + *
> + * Return: true if @state was at __compat_vdso_rt_sigreturn and advanced to the
> + * interrupted 32-bit user context, false otherwise.
> + */

This isn't a bug, but __compat_vdso_rt_sigreturn does not appear to exist
anywhere in the tree.

arch/riscv/kernel/compat_vdso/rt_sigreturn.S just includes
../vdso/rt_sigreturn.S, so the compat vDSO symbol is also
__vdso_rt_sigreturn, which COMPAT_VDSO_SYMBOL(mm->context.vdso,
rt_sigreturn) resolves through compat__vdso_rt_sigreturn_offset.

Could the comment say "the compat vDSO __vdso_rt_sigreturn" instead?

> diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
> --- a/arch/riscv/kernel/signal.c
> +++ b/arch/riscv/kernel/signal.c

[ ... ]

> +#ifdef CONFIG_UNWIND_USER

[ ... ]

> +	frame = (struct rt_sigframe __user *)state->sp;
> +#ifdef CONFIG_MMU
> +	if (!mm->context.vdso)
> +		return false;
> +	sigret = (unsigned long)VDSO_SYMBOL(mm->context.vdso, rt_sigreturn);
> +#else
> +	sigret = (unsigned long)&frame->sigreturn_code;
> +#endif

Can the !CONFIG_MMU branch here ever be built?

This function is inside #ifdef CONFIG_UNWIND_USER, and UNWIND_USER is only
selected by HAVE_UNWIND_USER_FP and HAVE_UNWIND_USER_CFI.  The Kconfig
change in this patch selects both only when MMU is set:

	select HAVE_UNWIND_USER_CFI if MMU
	select HAVE_UNWIND_USER_FP if MMU

So CONFIG_UNWIND_USER=y on riscv implies CONFIG_MMU=y, and the
&frame->sigreturn_code path can never be compiled or tested.  Should the
#ifdef CONFIG_MMU / #else be dropped, leaving only the vDSO lookup?  A
nommu variant could come together with the Kconfig change that enables it.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45087188604
--===============8029890971532200664==--
