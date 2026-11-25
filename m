Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590366;
	b=xfR1qx4szNhF+9dmERmHOEsKzV6ZrCIvyx6p/2Hr1q9/qFPBRLQa49mOyc9WdDZtulYn
	 dhIGwoH6Hf9zO1zwNCGPDo89HDZ//CVJQi38BJBtk/Fn5usLYHED5l1v6Wn+Rag7oH5FD
	 FN/jTg6c7BkPL4079GyoBD+NOqcmrUAPensYl9UxOZnDiQgv95vhV6WlcgQUN54OeP0uh
	 RZ9plno2ssL223SQo4hdKbTMx9pIqYP1rAwgaFo9xuF1tuhr4sH937axMTOnRRdEXNUSt
	 dSYoRk55Cu7kWFt1f8/K5k3CzuGqLpOj0Yd9M/IbucpLuihw103+cRq1A8AujX3CE+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590366;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=hyUGVDmprxQhAj50WjzUk1/vaaBy//3iaYrzXIMA2eA=;
	b=SE/AoHq8YkLU3EEHoQMf3g7ME/iI737dEWeLmIEKdr1SW/cLNeiP1/OE8h9CiV9Ran3y
	 EI3f/zmM2HaMDwP3d1RxQDQqpYOYyxUzfCEUw6VNppehc9D4OMVIKj/Nk+SyQE+dhnArf
	 yGWcGBalUBz1krt8gasy2f5PIXQioj2S1UdozP3lXVpX7MHo7YcsVLeITSWaj64qPqpHl
	 1aTieAiPVkg0RKNGGK32mfuydlVBt8k44ArTKtNKpdBLZvKuQPtZD9eL3KtC09uwUbvq6
	 wDGymQ5ThhoUEtilDI2wxPx7yNtFdOLeH92p2yKXr+c2xoNtQXxw0YUJFfWfF1yCMBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvKoL5qI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B397E606A329;
	Wed, 25 Nov 2026 07:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvKoL5qI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3591F00ACF;
	Wed, 25 Nov 2026 07:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590366;
	bh=hyUGVDmprxQhAj50WjzUk1/vaaBy//3iaYrzXIMA2eA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=YvKoL5qIpzrIqVi7SNh+5Muu2JJaxW1V9tBNRWWqZ+I8zV3a4XkLT0APhVQMuzBC7
	 JHOmVjUtZeiGIuu5ektu1FulpCUXEf8IfpQoN2m4eUuI0JVKjHalBp7/CIxGzLzFsy
	 D46UXprCgwAbAB018ecPrxILDJBi+k1/Xmp0yBXLaOf5xTRwG2BDx1DWs8f9XR44CT
	 QMuNBRSsFiNcNr9Fibud2FK6wGSHzp/eg/0iLkGpOMewZX5u0IocDHL4FMK0Aqilql
	 VWLgBU/m0lwdvo+h4mDIdYtGNGyDN4dlaBAfrwmIfZ8AVUjtu3fqqEeb2U+uwzpYCz
	 QgWWeupD1rSUQ==
Content-Type: multipart/mixed; boundary="===============5092901143825754910=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <3bd046e1156b06c06b0a3c90eddace99d419b20b620d8980538ce47b314272a9@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-19-irogers@google.com>
References: <20261125061523.1540234-19-irogers@google.com>
Subject: Re: [RFC PATCH v2 18/30] riscv: Add DWARF CFI annotations to entry, ftrace, rethook, and BPF JIT
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:01 +0000 (UTC)

--===============5092901143825754910==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> riscv: Add DWARF CFI annotations to entry, ftrace, rethook, and BPF JIT

TL;DR: Commit message only: it says the return_to_handler() rewrite in riscv
mcount.S is under CONFIG_UNWINDER_DWARF_CFI, but part of it is unconditional.
The code looks functionally correct.

> riscv: Add DWARF CFI annotations to entry, ftrace, rethook, and BPF JIT
>
> Prepare RISC-V assembly, probe trampolines, and RV64 BPF JIT prologues
> for runtime Minimal DWARF CFI kernel unwinding:
>  - Export end labels for ret_from_fork_user_asm, call_on_irq_stack, and
>    ftrace_caller save/restore boundaries, and save s0 in ftrace_caller
>    under CONFIG_UNWINDER_DWARF_CFI.
>  - Annotate return_to_handler() and arch_rethook_trampoline() with
>    .cfi_* directives and key rethook shadow stacks on entry SP (CFA)
>    under CONFIG_UNWINDER_DWARF_CFI.
>  - Save RV_REG_RA unconditionally in RV64 BPF JIT prologues under
>    CONFIG_UNWINDER_DWARF_CFI so leaf BPF programs unwind into frameless C
>    callers.
>
> Signed-off-by: Ian Rogers <irogers@google.com>

The commit message describes the return_to_handler() changes as being
under CONFIG_UNWINDER_DWARF_CFI, but part of that rewrite is not config
gated:

arch/riscv/kernel/mcount.S:
 	call	ftrace_return_to_handler
-	mv	a2, a0
+	mv	ra, a0
 ...
-	jalr	a2
+	ret

and RESTORE_RET_ABI_STATE no longer does:

-	REG_L	ra, FREGS_RA(sp)

This applies to every riscv kernel with CONFIG_FUNCTION_GRAPH_TRACER,
including builds that never enable the new unwinder.  On return, ra now
holds the real return address instead of a value inside return_to_handler,
a2 is no longer written, and ret replaces an indirect jalr.

The new sequence looks functionally correct, but should the commit message
say that this part is unconditional and explain why it is needed (the
.cfi_same_value ra over the final instructions), so riscv and ftrace
maintainers can review it as such?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============5092901143825754910==--
