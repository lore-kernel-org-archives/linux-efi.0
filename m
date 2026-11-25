Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590360;
	b=3tryk9ifD5KaXESDtftyOAT1Uz3HMZJz+hT8q6We1HDB+25THd2pq76DU7BJ5i6PA2Ce
	 DFRp0qS5mrjnF7ksmUQgLFuImFZ7OhwwWE9EQpx5jGRITIvZ0das6dHKnHrIIigW4QJ7G
	 zPPxW3Ku90NjUsZjvPCFqviOkpOu/oxRY2Y1um6K8+xTpgaXiKA0YGMGZmwPUsqlpVQEu
	 SyKUcRuPp/xi5yQ3uoxKKevcT0kuXYgQlrsEZmKLtnrQv4hha6HIr9yboagNTYG6RYu1B
	 XMG9HORRoD4bT3Y/UokQ0rtp04+Psa1t9lrdge7eQCBGIi/t2D5XAzMuO3LzMRy2klQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590360;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=34IkE98ay9uD1UXazw384CiIG9xjTfNiMAYl39k2cwg=;
	b=47melN6RQLcJt8vSBZNeZ/I4X/BN0QW0xSPgdqq/T2FVRl+NdDqYp06e4oaVcbMn0wR7
	 cdSMc++3Vw4UBtgYIE1WkGEb6N16m5i8IuA55TLX2kuLKDhFmW5eivJ8uXwfRjX9uYG/w
	 6FbS8hUv31fERXGs0V0qZx3MAsKVR9Oj9R8BygtXjTcbYEPr5IXarH+lbsrQA6h6H8jtL
	 /MMYQ0I4P28og3fu7j8ZT/i1CQCtdZ/5ktI/YwWw9GWulxhFj1tNXkb4I4K08jd+sf7EM
	 lVBh67RU3RiYBDqPzGNIvSlTsc7y4AL5vhD3LLmu2/FhL0zETtql7PoyDHQ8i/rMXOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QUrfkKKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB35606A32C;
	Wed, 25 Nov 2026 07:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QUrfkKKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E471F000D3;
	Wed, 25 Nov 2026 07:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590360;
	bh=34IkE98ay9uD1UXazw384CiIG9xjTfNiMAYl39k2cwg=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=QUrfkKKYin6SUsE7qd6BRGlRB/HIkWrriuppajmIOrJ5ONqdmuMIi147C0OIl/z6a
	 f+bSohz+cw93b2FNOPy3NGqs2d2W744/EdQsn8CC948QxweQC0nyd9YHAtwPVwV8Fu
	 k1zwxaR7wrRWl4jCMnblFe8s5L2Hqoxn7v4m+ILt4Ea2ugY45gzaEXR0yRtQNWfpTB
	 5Gtms3+FPkLlZTX4uslLiJxexFZC67YyZf6QmWuYpYlZImCI9sNHvhcY8HOB5c07b8
	 CqLgEHUdVT8UukRsTvQUN2iHGkoObnyv24GZLqTi0IVBXjuRG9BohgaJbbLuGMlZPi
	 4F3hWV+ngD9Dg==
Content-Type: multipart/mixed; boundary="===============8760472991523024919=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <da45f3c72c6c359d7a2d029b5a0fd9c2cd0d28b849cfde0bc57669d12a7e34d1@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-12-irogers@google.com>
References: <20261125061523.1540234-12-irogers@google.com>
Subject: Re: [RFC PATCH v2 11/30] x86: Add DWARF CFI annotations to entry, ftrace, frame, and rethook
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:55 +0000 (UTC)

--===============8760472991523024919==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> x86: Add DWARF CFI annotations to entry, ftrace, frame, and rethook

TL;DR:
- Commit message omits that ENCODE_FRAME_POINTER and FRAME_BEGIN/END are newly
  enabled for DWARF CFI
- Nits: duplicated frame.h condition block
- Nits: rethook copies kprobes SAVE_REGS_STRING, duplicating the pt_regs
  layout

>     x86: Add DWARF CFI annotations to entry, ftrace, frame, and rethook
>
>     Prepare x86-64 hand-written and inline assembly paths for runtime
>     Minimal DWARF CFI kernel unwinding when CONFIG_UNWINDER_DWARF_CFI is
>     enabled:
>      - Emit .eh_frame alongside .debug_frame in asm/dwarf2.h and preserve
>        FRAME_BEGIN/FRAME_END frame setup for non-leaf assembly helpers in
>        asm/frame.h.
>      - Annotate THUNK (arch/x86/entry/calling.h), ftrace_caller /
>        ftrace_regs_caller / return_to_handler (arch/x86/kernel/ftrace_64.S),
>        and arch_rethook_trampoline() (arch/x86/kernel/rethook.c) with .cfi_*
>        directives.
>
>     Signed-off-by: Ian Rogers <irogers@google.com>

This isn't a bug, but the commit message says FRAME_BEGIN/FRAME_END are
"preserved".  Without CONFIG_FRAME_POINTER they used to expand to nothing,
so with CONFIG_UNWINDER_DWARF_CFI they are newly enabled.

The same hunk also enables ENCODE_FRAME_POINTER and encode_frame_pointer()
for CONFIG_UNWINDER_DWARF_CFI, so entry_64.S, SAVE_REGS_STRING
(kprobes/rethook), ftrace_regs_caller and copy_thread() now load an encoded
pt_regs pointer into %rbp in builds without frame pointers.  The message
doesn't mention this.

Could the changelog say that ENCODE_FRAME_POINTER/encode_frame_pointer()
are also enabled, and explain that the DWARF unwinder relies on %rbp frames
and encoded pt_regs pointers for asm that has no .eh_frame?

> diff --git a/arch/x86/include/asm/frame.h b/arch/x86/include/asm/frame.h
> index 0ab65073c1cc..62939fbb6668 100644
> --- a/arch/x86/include/asm/frame.h
> +++ b/arch/x86/include/asm/frame.h

[ ... ]

> @@ -22,6 +22,30 @@
>  	pop %_ASM_BP
>  .endm
>
> +#else /* !__ASSEMBLER__ */
> +
> +#define FRAME_BEGIN				\
> +	"push %" _ASM_BP "\n"			\
> +	_ASM_MOV "%" _ASM_SP ", %" _ASM_BP "\n"
> +
> +#define FRAME_END "pop %" _ASM_BP "\n"
> +
> +#endif /* __ASSEMBLER__ */
> +
> +#define FRAME_OFFSET __ASM_SEL(4, 8)
> +
> +#else /* !CONFIG_FRAME_POINTER && !CONFIG_UNWINDER_DWARF_CFI */
> +
> +#define FRAME_BEGIN
> +#define FRAME_END
> +#define FRAME_OFFSET 0
> +
> +#endif /* CONFIG_FRAME_POINTER || CONFIG_UNWINDER_DWARF_CFI */
> +
> +#if defined(CONFIG_FRAME_POINTER) || defined(CONFIG_UNWINDER_DWARF_CFI)
> +
> +#ifdef __ASSEMBLER__
> +
>  #ifdef CONFIG_X86_64

This isn't a bug, but both blocks here use the identical condition
"defined(CONFIG_FRAME_POINTER) || defined(CONFIG_UNWINDER_DWARF_CFI)".
Could the original single block be kept, with only its
"#ifdef CONFIG_FRAME_POINTER" line changed, so the diff stays small?

> diff --git a/arch/x86/kernel/rethook.c b/arch/x86/kernel/rethook.c
> index 85e2f2d16a90..2bff76758024 100644
> --- a/arch/x86/kernel/rethook.c
> +++ b/arch/x86/kernel/rethook.c
> @@ -15,6 +15,87 @@ __visible void arch_rethook_trampoline_callback(struct pt_regs *regs);
>  #define ANNOTATE_NOENDBR
>  #endif
>
> +#if defined(CONFIG_X86_64) && defined(CONFIG_UNWINDER_DWARF_CFI)
> +#define RETHOOK_CFI_STARTPROC		"	.cfi_startproc\n"
> +#define RETHOOK_CFI_ENDPROC		"	.cfi_endproc\n"
> +#define RETHOOK_CFI_ADJUST(off)		"	.cfi_adjust_cfa_offset " #off "\n"
> +#define RETHOOK_SAVE_REGS_STRING	\
> +	"	subq $24, %rsp\n"	\
> +	RETHOOK_CFI_ADJUST(24)		\
> +	"	pushq %rdi\n"		\
> +	RETHOOK_CFI_ADJUST(8)		\

[ ... ]

> +	"	pushq %rbp\n"		\
> +	RETHOOK_CFI_ADJUST(8)		\
> +	"	.cfi_offset rbp, -144\n"\

[ ... ]

> +#define RETHOOK_RESTORE_REGS_STRING	\
> +	"	popq %r15\n"		\
> +	RETHOOK_CFI_ADJUST(-8)		\

[ ... ]

This isn't a bug, but RETHOOK_SAVE_REGS_STRING and
RETHOOK_RESTORE_REGS_STRING are an instruction-for-instruction copy of
SAVE_REGS_STRING and RESTORE_REGS_STRING in arch/x86/kernel/kprobes/common.h
with a CFI line added after each push and pop.  The pt_regs save order is now
defined in two places, and the hard-coded ".cfi_offset rbp, -144" depends on
that layout.

optprobe_template_func() in kprobes/opt.c also uses the shared macros and
has no .cfi_startproc, so they can't be annotated unconditionally.

Could kprobes/common.h's SAVE_REGS_STRING/RESTORE_REGS_STRING instead take an
optional per-push annotation hook that is empty by default, so the register
list stays in one place?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============8760472991523024919==--
