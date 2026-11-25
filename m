Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590340;
	b=Ry8lmEFsdiWTQ9gqNC/4oWbVYrZykwPP73iyKrExZqk1C69XO2P6V08yt4JsJMgsEOnN
	 E7lZClA1bL5L8p28aG5IOYqjFneu+62KVgn/DQSaSqpeMLobKlYdL1wX5htWIKSD3nLvA
	 RN/2P+/bhM8m8XX/pBzEay3DIvqtcuglAR49579Usas5TZkLFMVPvdU7Hkqlu0cIoPS0x
	 mV3Brv758ltmW551Tk850q1r6WEThd0MTBtKoY3xsL12LAYLrJUELn3GDBFbuTfXZca7b
	 cKK+cwtHzW8DoWAi++iM9tp+vzoDYzXqpmLLozY1QIENWlOllxPYoQCFGWw1VA6p7lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590340;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=3Rjs+hf79BZIi0D+eaQi3V4duXTfNTgtE9+NKqARO4s=;
	b=lPZHhNhmdHwpZsMiK1WRTJx5y2hlvKhCOu8q4Msh8JXvDWzVakzpJe1bL7Kz4QVPMMk4
	 WawAGCHjchiuWO7mstDYyBEokzfqS1Oxr9LX0j4Q+3HKgPo4/L8t5/4aFH5jvAaZV7Yxn
	 ChHsE7IXkSMQZPKp1sPLrK54alPs/0mbiQh81lmdW7gzxl40Tj1Zsp1vdkHT9fM6L0I3l
	 bwPPhsWxoIqeZ4FSULYCljiUTUG0hbHgqLPD72WRwYSVwAArdQWDrWcylDCOq+d+Y+VaA
	 IyoZ3MUPyJgxeCIOdlVrOq9VRjJukOKwdyD2/rJoaPFX8izJBCklShzjZqVnpKZEFtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Fvfa/TaF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474C3606A337;
	Wed, 25 Nov 2026 07:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Fvfa/TaF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFC91F000D1;
	Wed, 25 Nov 2026 07:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590339;
	bh=3Rjs+hf79BZIi0D+eaQi3V4duXTfNTgtE9+NKqARO4s=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=Fvfa/TaF/5uRajXxAtOrYOty3mxmlgYptKUjtuCqQDhMs+J9RxOV5Nel6HK+7FhBq
	 LaJBXEzWytsu0Tv+aYlegSeyCBpi/OzE8h38mmyaecQIkf+SVjbX6+B3IWjQZYG72/
	 BHv4UVcWlK/A8E6p2UOAIlKy3Ys+8EZP/36IIYJYjCKQrlfOzLYsx0g+NpvrmGMJWB
	 X0mKO/Mq8dyuwxWpFPAt7j6yz9qg8D085iKX+l2pyrLYcXJ9T6pgwhqtSY4dgLGaDp
	 xCgIXTyUP17AXbQejQQuMOpNXJy7h3sSN18861+XmIEkWMEZWkGWailSHzHLiQQnlw
	 tOYY3S7k0YmrQ==
Content-Type: multipart/mixed; boundary="===============8402610718020353362=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <4d4c5055e3810e6955b671c7694f4c69f23e2893e276855fa5688dc8c2838b90@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-28-irogers@google.com>
References: <20261125061523.1540234-28-irogers@google.com>
Subject: Re: [RFC PATCH v2 27/30] tools/unwind: Add multi-arch symbolic instruction lifters for verify_cfi
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:35 +0000 (UTC)

--===============8402610718020353362==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> tools/unwind: Add multi-arch symbolic instruction lifters for verify_cfi

TL;DR:
- x86 PUSH64r/POP64r prefix tests likely catch memory forms, possibly
  clobbering %rbp and causing false CFI mismatches
- arm64 sub/add sp, sp, xN probably matches wrong opcodes, leaving SP unknown
- RISC-V jal x0 may clobber ra; LDP W scale looks wrong

> diff --git a/tools/unwind/verify_insn_arch.cpp b/tools/unwind/verify_insn_arch.cpp
> --- /dev/null
> +++ b/tools/unwind/verify_insn_arch.cpp

[ ... ]

> +	if (Desc.isCall()) {
> +		for (int d = 0; d < 32; d++) {
> +			if (AS.llvm_arch == Triple::x86_64) {

[ ... ]

> +			} else if (AS.llvm_arch == Triple::riscv64) {
> +				if (d == 0 || d == 2 || d == 3 || d == 4 ||
> +				    d == 8 || d == 9 || (d >= 18 && d <= 27))
> +					continue;
> +				st.regs[d] = {VK_UNKNOWN, 0};

On riscv64, `jal ra, sym` and `jalr ra, off(rs)` do not set isCall in their
MCInstrDesc, and stepInstructionRiscv() does not model JAL/JALR.  Is this
riscv64 arm of the Desc.isCall() loop reachable for a real call?

In the later patch "tools/unwind: Add CFG instruction abstract execution
oracle to verify_cfi" (9528bbf0f915), verifyOracle2Instructions() sends
every RISC-V call around stepInstruction() and repeats the same register
list:

    if (AS.llvm_arch == Triple::riscv64 && is_call) {
            for (int d = 1; d < 32; d++) {
                    if (d == 2 || d == 3 || d == 4 ||
                        d == 8 || d == 9 ||
                        (d >= 18 && d <= 27))
                            continue;
                    next_st.regs[d] = {VK_UNKNOWN, 0};
            }
    } else {
            stepInstruction(next_st, MI, OpName, Desc, MCRI, ...);
    }

So the RISC-V caller-saved set is kept in two places that have to stay in
sync, and any other caller of clobberGenericDefs()/stepInstruction() leaves
a0-a7 and t0-t6 live across `jal ra`/`jalr ra`, contrary to the "ABI
caller-saved registers across call instructions" comment.

Could the normalized is_call be passed into stepInstruction() and
clobberGenericDefs() so the oracle can drop its copy, or could this arm be
removed with a note that the caller handles RISC-V calls?

[ ... ]

> +	if (OpName.starts_with("PUSH64r")) {
> +		int src = ctx.regD(0);
> +		st.regs[7] = addSymImm(st.regs[7], -8);
> +		st.store(st.regs[7], ctx.getRegVal(st, src));
> +		return true;
> +	}
> +	if (OpName == "PUSHF64" || OpName.starts_with("PUSH64i") ||
> +	    OpName == "PUSH64rmm" || OpName == "PUSH64rmr") {
> +		st.regs[7] = addSymImm(st.regs[7], -8);
> +		st.store(st.regs[7], {VK_UNKNOWN, 0});
> +		return true;
> +	}
> +	if (OpName.starts_with("POP64r")) {
> +		int dst = ctx.regD(0);
> +		SymVal loaded = st.load(st.regs[7]);
> +		st.regs[7] = addSymImm(st.regs[7], 8);
> +		if (dst != 7)
> +			ctx.setRegVal(st, dst, loaded);
> +		return true;
> +	}
> +	if (OpName == "POPF64" || OpName == "POP64rmm") {
> +		st.regs[7] = addSymImm(st.regs[7], 8);
> +		return true;
> +	}

Don't starts_with("PUSH64r") and starts_with("POP64r") also match the memory
forms PUSH64rmm and POP64rmm?  If so, the explicit "PUSH64rmm",
"PUSH64rmr" and "POP64rmm" tests below them can never be reached.

For those memory forms, MCInst operand 0 is the base register of the memory
reference, so ctx.regD(0) returns the address base rather than a data
register.

For `pushq -8(%r10)` (PUSH64rmm) this stores the symbolic value of %r10 into
the new stack slot, where the intended branch would store VK_UNKNOWN.  That
is the DRAP sequence the function's kernel-doc says it models:

    lea 8(%rsp), %r10
    and $-64, %rsp
    pushq -8(%r10)

The same happens for any `pushq disp(%rbp)` or `pushq disp(%rsp)`, such as
GCC pushing stack-passed arguments for calls with more than six arguments.

For `popq disp(%base)` (POP64rmm), ctx.setRegVal(st, base, loaded) overwrites
the base register's symbolic value with the popped value instead of storing
to memory.  With base == %rbp, for example `pushf; popq -0x10(%rbp)` from
native_save_fl() with the "=rm" output constraint, %rbp becomes VK_UNKNOWN.
Every following row with an rbp-based CFA would then fail in
evalRowAgainstAbs() with cfa_clobbered_or_opaque or fp_recovery_mismatch for
a correct function.

Would testing exact names (OpName == "PUSH64r" || OpName == "PUSH64rmr", and
OpName == "POP64r" || OpName == "POP64rmr"), or moving the memory-form
branches ahead of the prefix tests, give the intended behaviour?  No later
patch in the series (up to 0278f019673d) touches verify_insn_arch.cpp.

[ ... ]

> +	if ((OpName == "ADDXrs" || OpName == "SUBXrs" ||
> +	     OpName == "ADDXrx" || OpName == "SUBXrx") &&
> +	    MI.getNumOperands() >= 4 && MI.getOperand(3).isImm()) {

[ ... ]

> +		} else if (OpName.ends_with("rx") &&
> +			   ((imm_arg >> 3) == 3 || (imm_arg >> 3) == 7) &&
> +			   (imm_arg & 7) == 0) {
> +			ok_shift = true;
> +		}

Are these the right LLVM opcode names for `add/sub sp, sp, xN`?  In LLVM's
AArch64 AddSub multiclass, ADDXrx/SUBXrx take a GPR32 Rm with the
UXTB..SXTW extends.  The 64-bit Rm forms that allow only UXTX/SXTX are the
separate opcodes ADDXrx64/SUBXrx64, and the aliases used when Rd or Rn is SP
(`sub sp, sp, x12` == `sub sp, sp, x12, uxtx #0`) bind to those.

If so, the (imm_arg >> 3) == 3 || == 7 test can never be true for a decoded
ADDXrx/SUBXrx, so this sub-branch is dead.  "SUBXrx64"/"ADDXrx64" match no
case, stepInstructionArm64() returns false, and clobberGenericDefs() sets
operand 0 (SP, DWARF 31) to VK_UNKNOWN.

This prologue shape is common with GCC when the adjustment is not a valid
add immediate but can be loaded with one mov:

	mov	x12, 4160
	sub	sp, sp, x12
	.cfi_def_cfa_offset 4160

After that instruction sp is VK_UNKNOWN, and evalRowAgainstAbs() would report
cfa_clobbered_or_opaque for the SP-based CFA.  Even with the CFA moved to
x29, the matching `add sp, sp, x12` / `ldp x29, x30, [sp], #N` epilogue
would still report a mismatch.  The MOVZXi/MOVNXi/MOVKXi constant tracking
added for this case then has no consumer for SP.

Should this match "ADDXrx64"/"SUBXrx64" (and adjust the ends_with("rx")
test), with the current ADDXrx/SUBXrx names dropped or handled separately
with W-register extend semantics?  No later patch in the series fixes this.

[ ... ]

> +	auto scaleOf = [](StringRef N) -> int64_t {
> +		if (N.contains("Q"))
> +			return 16;
> +		if (N.contains("X") || N.contains("D"))
> +			return 8;
> +		if (N.contains("W") || N.contains("S"))
> +			return 4;

Doesn't N.contains("D") also match the "D" in the "LDP" mnemonic prefix?
scaleOf("LDPWpost") and scaleOf("LDPWpre") would then return 8 instead of 4.

The MC operand for LDP/STP is the raw signed imm7, so the scale is used
directly here:

	ctx.setRegVal(st, wb,
		      addSymImm(addr,
				MI.getOperand(4).getImm() * scaleOf(OpName)));

For example `ldp w19, w20, [sp], #8` would advance the abstract SP by 16 and
desynchronise it from the CFI, giving a spurious CFA mismatch for the rest
of the path.  The STP W forms come out right only because "STP" contains
neither 'D' nor 'X'.  Compiler-generated prologues and epilogues do not use
W-pair writeback on SP, so this mainly affects hand-written assembly.

Would selecting the scale from the register-class character after
"LDP"/"STP" (OpName[3]) avoid the substring ambiguity?

[ ... ]

> +void normalizeRiscvControlFlow(const MCInst &MI, StringRef OpName,
> +			       const MCRegisterInfo &MCRI,
> +			       bool &is_ret_or_ind_jump, bool &is_uncond_branch,
> +			       bool &is_call)
> +{

[ ... ]

> +	if (OpName == "JAL") {
> +		if (rd == 0) {
> +			is_uncond_branch = true;
> +			is_call = false;

normalizeRiscvControlFlow() clears is_call for an uncompressed `j` (JAL
x0), but doesn't stepInstruction() still see it as a call and clobber ra?

The caller verifyOracle2Instructions() added in 9528bbf0f915 starts from
is_call = Desc.isCall(), which is true for JAL since LLVM marks JAL/JALR
isCall = 1.  After normalisation is_call is false, so the caller takes the
else branch and calls stepInstruction().  stepInstructionRiscv() has no
"JAL" case and returns false, so stepInstruction() falls back to:

	if (!handled)
		clobberGenericDefs(st, MI, Desc, MCRI, AS);

clobberGenericDefs() re-reads Desc.isCall(), which is still true for JAL,
and the riscv64 arm sets ra (x1), t0-t6 and a0-a7 to VK_UNKNOWN on every
plain unconditional jump.  The state is then enqueued at the branch target.
If the RA rule there is DWARF_CFI_RULE_SAME, evalRowAgainstAbs() reads
st.regs[1] == VK_UNKNOWN and records a spurious ra_recovery_mismatch.  RA is
SAME throughout leaf functions, and before the prologue or after the
epilogue in shrink-wrapped paths.

With RVC, `c.j` (C_J, not isCall) is unaffected, but an uncompressed `jal
x0` is still emitted when the target is outside the +/-2KB c.j range, and
for every jump in code built without the C extension.  The real call paths
never reach this clobber because the caller handles riscv64 calls itself, so
the riscv64 isCall branch in clobberGenericDefs() only fires for JAL x0, the
one case that is not a call.

Could "JAL" with rd == x0 (and C_J) be modelled in stepInstructionRiscv() as
a no-op returning true, or could stepInstruction() take the normalised
is_call instead of using Desc.isCall()?  No later patch in the series fixes
this.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============8402610718020353362==--
