Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795392973;
	b=ka1WpEQKkW8PPCKtFRIlLoKMWlfZ49oFmb2om8Dul/1L/BVsO87R5yKJsXEaeGZPamxF
	 otOcyha8F2XG64IPx4bv2J062yH+WYAPjluOSCei6Wj8GDSkIkaXtMhtHojVX6XuijVGa
	 yQgyoUz51CRorWnFUFhQ77rUixpJK3BGraJe3vQzlkmGTffJdkM3xMCYbMNMWoyxWsgf/
	 yVjsxUnC72A/grZUeI2lmm1DoCGx5i0VRR1n5GS1nSPelhUHcB8SDF6+QjQfOw/Vr53Tn
	 dD3b9+V/qb4+77t57UHNS/T6aC93XSjf/P2jljCvkfI6OH+ZTKHb9KZCCftUptr2QtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795392973;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=o9IKmZIDwKu2UGvl4Q/EBHjx1Uw5srJEMY+bSgiOP5I=;
	b=hO9iBxvfe/DNx/yGf5IsoiBLn6zzMFaIdNbemvW7P64nLx6tmCi7qGlI1Hqlzf+P38H1
	 qRd8HfxcXZaQtCrYeGqFtaD0lVJw2lKYgitdSSWUAnc3HsgcSePhNr+2mRK/TVn+ju3cG
	 Pms50DA7ERbMDlz9/BROOpjSXXme235iZKBrPW9hK6hqX4xDg6bSpbdm3HbirDKfSaoAY
	 tzCMOBgJfk6gFB1ydRArhrXIIQ4ZcnCrQeMPUlph+Gkh5Y5osAHpP09By/MK0HuIPUs0w
	 Zrwc7z6pu6Yd1j52Mz2PJwBvQK5igya8nL43XmZ08okGcIdSyAh1cGfH71L2p2tshbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="H/EKoOiA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A497606A31A;
	Mon, 23 Nov 2026 00:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H/EKoOiA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B791F000D3;
	Mon, 23 Nov 2026 00:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392972;
	bh=o9IKmZIDwKu2UGvl4Q/EBHjx1Uw5srJEMY+bSgiOP5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H/EKoOiAOSMP9yfS7utxSK0NOO2XNSxImajkYw2STFhfkx79dUev8Wpi5+9AlRNwF
	 QAabdMx9ylxA0BoqLhfhF9hnmtYDlTK7AgecNQGljeVmjL0TK8S3aekCuJFEu5oJ3S
	 MGSzZn8q0QHKAsvD+RCdixNGAEak8WbEPNFXS5pPDtNGIIgbE04106n7UvFMbC4+PJ
	 MoKtzfgDjlBWC5OKq7Ug9H6exUeXJnQ/qY8cKgsPsgdSAHoMaM/LYL0iplPNosxQj5
	 TMVR3GqwJN5B+LUWRK5R5Bv4rlFt5lQGjVx+3B1fBZZJqpCEbbE28vMeFw4WnCARUy
	 UPhyBvu/DITBQ==
Message-ID: <sashiko-outbox-228465@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 06/11] arm64: unwind_user: Support Minimal DWARF
 CFI and FP user unwinding
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261122235757.3456048-7-irogers@google.com>
References: <20261122235757.3456048-1-irogers@google.com>
 <20261122235757.3456048-7-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 00:16:10 +0000
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
- [Medium] arm64: unwind_user: shifted rt_sigframe base in
  unwind_user_sigreturn()
- [Medium] arm64: unwind_user: wrong state->sp on FP-to-CFI frame
  transition
- [Medium] arm64: unwind_user: Thumb bit 0 not stripped in
  unwind_user_strip_pac()
--

commit 6b2ce687ccf3b40dba131fb7a09e5054f9d0557a
Author: Ian Rogers <irogers@google.com>

arm64: unwind_user: Support Minimal DWARF CFI and FP user unwinding

This commit adds arm64 support for user-space DWARF CFI and frame pointer
unwinding, including register mappings, pointer authentication stripping,
and vDSO signal trampoline recovery.

> diff --git a/arch/arm64/include/asm/unwind_user.h b/arch/arm64/include/as=
m/unwind_user.h
> new file mode 100644
> index 0000000000000..38d0641ae5549
> --- /dev/null
> +++ b/arch/arm64/include/asm/unwind_user.h
> @@ -0,0 +1,126 @@
[ ... ]
> +static inline unsigned long unwind_user_strip_pac(unsigned long ip,
> +						  bool ra_signed)
> +{
> +	if (IS_ENABLED(CONFIG_COMPAT) &&
> +	    compat_user_mode(task_pt_regs(current)))
> +		return ip;
> +	return ptrauth_strip_user_insn_pac(ip);
> +}
> +#define unwind_user_strip_pac unwind_user_strip_pac

[Severity: Medium]
Should unwind_user_strip_pac() clear bit 0 (ip & ~1UL) for 32-bit compat
tasks?

In AArch32 Thumb mode, BL/BLX and compat_setup_return() set bit 0 of LR to
indicate Thumb state.  Leaving bit 0 set records odd addresses in the
callchain and causes lookup_ip =3D state->ip - 1 in unwind_user_next_cfi() =
to
evaluate to return_pc rather than return_pc - 1, applying post-call CFA rule
changes prematurely or missing the FDE when a call is at the end of a
function.

[ ... ]

> +#ifdef CONFIG_HAVE_UNWIND_USER_FP
> +
> +/*
> + * AArch64 PCS stores {fp, lr} at [fp, fp + 16), while 32-bit AArch32 co=
mpat
> + * APCS stores struct compat_frame_tail {fp, sp, lr} at [compat_fp - 12,=
 compat_fp).
> + */
> +#define ARCH_INIT_USER_FP_FRAME(ws)			\
> +	.cfa_off	=3D (ws) =3D=3D 8 ? 2 * (ws) : 0,	\
> +	.ra_off		=3D -1 * (ws),			\
> +	.fp_off		=3D (ws) =3D=3D 8 ? -2 * (ws) : -3 * (ws), \
> +	.use_fp		=3D true,
> +
> +#endif /* CONFIG_HAVE_UNWIND_USER_FP */

[Severity: Medium]
Does ARCH_INIT_USER_FP_FRAME() leave state->sp inaccurate when an inner
frame unwound via FP transitions to an outer frame unwound via SP-based
DWARF CFI?

On AArch64, a function with frame size N > 16 places its frame record at the
lowest address of its frame (callee_fp =3D caller_sp - N).  Setting cfa_off=
 =3D
16 with use_fp =3D true updates state->sp to callee_fp + 16 =3D caller_sp -
(N - 16) rather than caller_sp (and on AArch32, cfa_off =3D 0 sets state->sp
to compat_fp rather than loading compat_frame_tail.sp from [compat_fp - 8]).
If unwind_user_next() then resumes UNWIND_USER_TYPE_CFI on an outer caller
whose FDE uses DWARF_CFI_BASE_SP, the outer CFA is computed from the wrong
state->sp and reads the caller's saved registers from the wrong stack
offset.

> diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
> index 80398ac83c3b1..41dfbfcc1d2eb 100644
> --- a/arch/arm64/kernel/signal.c
> +++ b/arch/arm64/kernel/signal.c
[ ... ]
> @@ -1705,6 +1706,59 @@ void __init minsigstksz_setup(void)
> +bool unwind_user_sigreturn(struct unwind_user_state *state)
> +{
> +	struct mm_struct *mm =3D current->mm;
> +	struct rt_sigframe __user *sf;
> +	unsigned long sigtramp;
> +	u64 fp_lr[2], sp_pc[2];
> +
> +	if (!mm || state->ws !=3D 8 || !mm->context.vdso)
> +		return false;
> +
> +	sigtramp =3D (unsigned long)VDSO_SYMBOL(mm->context.vdso, sigtramp);
> +	if (state->ip !=3D sigtramp &&
> +	    !(state->topmost && state->ip =3D=3D sigtramp + 4))
> +		return false;
> +
> +	if (state->sp & 0xfUL)
> +		return false;
> +
> +	sf =3D (struct rt_sigframe __user *)state->sp;
> +	if (copy_from_user(fp_lr, &sf->uc.uc_mcontext.regs[29], sizeof(fp_lr)) =
||
> +	    copy_from_user(sp_pc, &sf->uc.uc_mcontext.sp, sizeof(sp_pc)))
> +		return false;

[Severity: Medium]
Can unwind_user_sigreturn() read from a shifted struct rt_sigframe pointer
when the signal handler was unwound via frame pointers?

When a signal handler with stack frame size S > 16 is unwound via
UNWIND_USER_TYPE_FP, unwind_user_next_fp() sets state->ip =3D sigtramp and
state->sp =3D handler_fp + 16 =3D (unsigned long)user->sigframe - (S - 16),
which remains 16-byte aligned.  On the next step, unwind_user_sigreturn()
casts that shifted state->sp to struct rt_sigframe __user *; for a 32-byte
handler frame, sf is user->sigframe - 16, so reading regs[29..30] and
{sp, pc} actually reads regs[27..28] and regs[29..30] from the real
sigcontext, passing the alignment and non-zero checks and corrupting the
rest of the unwind walk.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122235757.3456=
048-1-irogers@google.com?part=3D6
