Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590373;
	b=j7k/5CRyYGumiPpg+QLYSGa9wLHpOF0n5OyoMG2IsmuQiuFH8znjcFI7Ot2NMKpbdxFy
	 ZlwsozZgAABiGslvE7WLd3+GEBR/PSkRY/f6N3vHVMMKElsjymKGWdji4ICQ8H0n7rwEL
	 GevcmVdaqVZ5zrg5C9PzCpBuXE1MkbcLET6CbFMLAfw+ckdrcfyvAJdVTWbtOY5Vuwl84
	 GztqcHvV3O/+fKwd6JB1hJTJdiekR0HR+v3T5bYR0ySOkLrTuyNdIdU+7GECG1gw52+zI
	 f1TdWAXYXD/RuA1fpD55Q1zuG7FpNwgEYqLMkFl7RUAVWAEz+/8bp3rKYFiuxvQzNfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590373;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=K/q9nzsqStoipM5sT6ZTuum3AE/ZNSxJh2qnRm/7r7g=;
	b=ONTdmj5EAJq+3dCCrSjYMdsot/T4FXJbl/XETLRkFvg/y5WKWKJ2GPCjqAyG6UsP3upo
	 Cp7/TFKsACMglnoJAtyeLeAZ5pYYnOrTIs/Rd2LTLq8BrxiU3dpA+lRYLTJ9bC+2COS1S
	 zxNlHo43MeAwHlWoA2/QvU2zd51VRjavK/OwGRhfJ05hpxxxAlatWVJr2l+KaZuqpK+zB
	 VGYewbS9+JBX3aGRft7UeLnBPrF+82hA3sDvtsJ9lEBnuDemp7iAc8ChRYF7pRFKHEGKY
	 Yem77oEfL5KO62eYhhtvj4Ec+Gv/FvmGJG3ouXEy+Jsjyyk2GZVG5Qruvmaz4ZVS0Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="duLO0Th/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF74360A260C;
	Wed, 25 Nov 2026 07:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=duLO0Th/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C2C1F0281F;
	Wed, 25 Nov 2026 07:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590373;
	bh=K/q9nzsqStoipM5sT6ZTuum3AE/ZNSxJh2qnRm/7r7g=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=duLO0Th/pmEW6BN6ZR8s5sDooJ28xxC8dPQ31BIo3oi+5i5YTuHpQPi8sYx+k5JGD
	 T2FnDZibpqF3AdGleFRajL9gi1WyykPkja3VUvrQImQiM4drULWbiQ8djoGlqE0tEh
	 UQawTQwvy68XlUmytoAM/8K87/Pk79CDHE72HJA3Evy37lq19UgmjH9uKhf92JJvOA
	 9jkqzLKhi5AJB/2vDAHH9qNaos+lR71jmC4ryRxvo0qS7ni/BPIJu++u22lEz9AlGP
	 fyduRg9pzZysRfaceVYF9QzTCWDhhJg5QLhHch8GV7DX+Kryskluvso19BS8pySXSa
	 zC4A2lRBgTRsw==
Content-Type: multipart/mixed; boundary="===============5830286129240094792=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <136ad6946f19e98a0c37189368cca4b26e036e29b242d21b61f9925d9925f896@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-29-irogers@google.com>
References: <20261125061523.1540234-29-irogers@google.com>
Subject: Re: [RFC PATCH v2 28/30] tools/unwind: Add CFG instruction abstract execution oracle to verify_cfi
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:08 +0000 (UTC)

--===============5830286129240094792==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> tools/unwind: Add CFG instruction abstract execution oracle to verify_cfi

TL;DR:
- verify_cfi may skip code after returning calls or syscall/svc/ecall, and
  silently skips past 4096 instructions, yet still counts functions clean, so
  --strict may miss CFI mismatches
- noreturn name list may be wrong

> diff --git a/tools/unwind/verify_insn.cpp b/tools/unwind/verify_insn.cpp
> --- /dev/null
> +++ b/tools/unwind/verify_insn.cpp

[ ... ]

> +bool isKnownNoreturnName(StringRef Name)
> +{
> +	static const char *const Exact[] = {
> +		"panic", "do_exit", "make_task_dead", "__stack_chk_fail",
> +		"__stack_chk_fail_local", "fortify_panic", "usercopy_abort",
> +		"__bug", "bug_at", "do_group_exit", "complete_and_exit",

[ ... ]

> +	if (Name.starts_with("__throw_") || Name.starts_with("_ZSt7__throw") ||
> +	    Name.starts_with("_ZSt9__throw") || Name.contains("panicking") ||
> +	    Name.starts_with("rust_begin_unwind") || Name.contains("noreturn") ||
> +	    Name.starts_with("__bad_"))
> +		return true;
> +	return false;
> +}

The kernel-doc says this returns true only when calls to @Name never return.
Can Name.starts_with("__bad_") match functions that do return?

__bad_area() and __bad_area_nosemaphore() in arch/x86/mm/fault.c are
ordinary static void functions, and bad_area_nosemaphore() returns after
calling __bad_area_nosemaphore().  Similarly, Name.contains("panicking")
also matches returning Rust std helpers such as
std::panicking::panic_count::is_zero_slow_path() -> bool.

verifyFile() puts the address of every such symbol into noreturn_addrs, and
verifyOracle2Instructions() then does:

	if (has_target &&
	    noreturn_addrs.count(CallTarget))
		continue;

so the fallthrough PC is never enqueued.  Instructions only reachable past
such a call (e.g. the epilogue after call __bad_area_nosemaphore) are never
checked, yet the function is still counted in funcs_clean.  Could these two
rules be narrowed to exact names (or core::panicking only)?

The kernel names in Exact[] also differ from tools/objtool/noreturns.h:
complete_and_exit and bug_at do not exist in this tree, and fortify_panic
is a macro (the symbol is __fortify_panic).  __fortify_panic,
kthread_complete_and_exit, vpanic and do_task_dead are not recognized.
Could the kernel names come from tools/objtool/noreturns.h instead of a
separate hand-kept list?

The prefixes _ZSt7__throw and _ZSt9__throw can only match a 7- or
9-character std:: identifier starting with __throw, so helpers like
_ZSt16__throw_bad_castv or _ZSt28__throw_bad_array_new_lengthv are missed.

[ ... ]

> +		bool func_ok = true;
> +		unsigned steps = 0;
> +		while (!worklist.empty() && steps < 4096) {
> +			uint64_t pc = worklist.front();
> +			worklist.pop();
> +			steps++;

Each PC enters the worklist at most once, so steps counts distinct checked
instructions.  When a function has more than 4096 reachable instructions,
the loop exits with the worklist still non-empty.  Is it intended that the
function is then still counted by:

> +		if (func_ok)
> +			st.funcs_clean++;

func_ok is only cleared by an fde_eval_error or an evalRowAgainstAbs()
failure on one of the first 4096 PCs.  Nothing records the truncation, so
the function is listed as "Functions 100% instruction-clean", and a
CFA/RA/FP mismatch after the cutoff is not counted in insns_*_mismatch, so
--strict still exits 0.  Large functions such as sqlite3VdbeExec exceed this
easily.

The decode-failure path behaves the same way:
`if (DStat != MCDisassembler::Success || InsnSize == 0) continue;` drops all
successors of an undecodable instruction and the function can still be
counted clean.  This also seems to contradict the commit message's
"verifying at every reachable instruction".  Could a truncated or abandoned
walk clear func_ok, or be recorded with recordIssue() (for example as
"step_limit")?

[ ... ]

> +			if (is_ret_or_ind_jump || Desc.isTrap() ||
> +			    OpName == "UD2" || OpName == "BRK" ||
> +			    OpName == "EBREAK" || OpName == "C_EBREAK" ||
> +			    OpName == "SVC" || OpName == "ECALL" ||
> +			    OpName == "SYSCALL" || OpName == "IRET64" ||
> +			    OpName == "SYSRET64" || OpName == "ERET" ||
> +			    OpName == "SRET" || OpName == "MRET")
> +				continue;

SVC, ECALL and SYSCALL return to the next instruction, but here they end the
path and next_pc is never enqueued.  Everything after them on that path is
unchecked, and the function can still be counted in funcs_clean.

Examples are the arm64 vDSO fallbacks in
arch/arm64/include/asm/vdso/gettimeofday.h (svc #0 followed by the return
and the caller's epilogue), RISC-V sbi_ecall(), and user-space syscall
wrappers (syscall; cmp $-4095,%rax; ...; ret).  The address after a syscall
instruction is also the user PC that dwarf_cfi_unwind_user_eh_frame_hdr()
starts from for a task that entered the kernel through a syscall.

sigreturn trampolines are already excluded by the earlier
`if (fr->signal) continue;`, and HVC/SMC are not in the list and fall
through.  Should SVC/ECALL/SYSCALL be dropped from this terminator list so
the fallthrough is verified, with stepInstruction() clobbering their defs?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============5830286129240094792==--
