Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588720;
	b=dMB1hYXxm2BmMl/X+q5/l3sm0Cwlu0C3stbObp2a5Vxcc5JV9PYnaKxUlE0P5KNsx0Oe
	 PymLSWePwBvon50wkZcCcvtT2i6Es6H8P79StFRKEFblLa5oFL7l52QUzZoLQSnTWFU1/
	 yeBfnwPz3WVsq4ntq9WxJb0/2RlQQOc+QDu20deu9Ntoc6MkofwnDOnBe4l4g75Paw56T
	 mte6TynbEhQm/1NdHBi8PeOMVU3fWUAKf6eFm/Idv/xbmp5uBJS91g50gR7z9YOnkbfsr
	 gwzuCqicByDONO1vD1MUbr5qTUUQqJoqOrsevmR1zzjHV8ppGl4zi3TDz7kApOzOwWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588720;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JKfN2RJ4ujIAvTc1ET+V2cTmefVv4H2RzdHvZBBGb9I=;
	b=TkVU94ljbNM+REAXD0F6qM39Bu7rQXl5PidzAlGi5T1gMD4J1Jpvs52SfKkIa6wkXLCD
	 tm9KnsbEevcKkT1bU0H/syJJ3tjDwieKSWDc3wMmS0ZevAud1urZC+GfpbpvqbJDgaSXF
	 iRHv4dx1QwHskRfp0zgx8vg0k44awhebY46JLb6ZBEbWggj0HGLGz47G3lU9lqFku/XLE
	 9CUs68L4bnHvDVIK27M0/wWEb0gq+cuQK8UMmBf3udTKYjvHOC4ucGKqNbqD+CJIrEv9u
	 q4/3YmM3yFc+SjyluTl5uDbeU3Pch00aq28caD+avMgcAmbtB2E0/JMzQj2aUbtQ5NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TsyjpEqq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B084606A31E;
	Wed, 25 Nov 2026 06:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TsyjpEqq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0415D1F000C6;
	Wed, 25 Nov 2026 06:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795588719;
	bh=JKfN2RJ4ujIAvTc1ET+V2cTmefVv4H2RzdHvZBBGb9I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TsyjpEqqxKqF5RaDkquJbjEtj9Yq6WCduMXTWRTCZ/v5vDbFwYFtyXLQ+BYOaBaZO
	 emLguPusQ45lFXpZVmFCt7O5UWNlA5Yy3Tdju4rP+AebKcHQ0A77x4wStHLF1im5+1
	 63BYTUtwJ+4auVYft7ogPu1vz024JkUvnWkcq3e4DhasgOGcBZqKlTurol6eVBouyc
	 GJfIbVCSjZ7djNKq/jq1ol1TJcvI2vK3limTVgyQm2CfqoGDxCdIsIRLyzAgWKAsqI
	 os9YeUi2QTn9zjXedarSRFxN+CFe6GYhbAzfE4PeWwClojiwQ6pbLatxhdIO+IAa1R
	 yQGkUCAPhHcUw==
Message-ID: <sashiko-outbox-232722@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 27/30] tools/unwind: Add multi-arch symbolic
 instruction lifters for verify_cfi
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261125061523.1540234-28-irogers@google.com>
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-28-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:38:37 +0000
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
- [Medium] tools/unwind: prefix checks in stepInstructionX86() shadow
  PUSH64rmm/POP64rmm
--

commit 706436be3648ce84ad4baf3ce57398690cc2b113
Author: Ian Rogers <irogers@google.com>

tools/unwind: Add multi-arch symbolic instruction lifters for verify_cfi

This commit adds the symbolic stack and register abstract domain along with
per-architecture instruction lifters and a generic register-def clobber
fallback for verify_cfi.

> diff --git a/tools/unwind/verify_insn_arch.cpp b/tools/unwind/verify_insn=
_arch.cpp
> new file mode 100644
> index 0000000000000..3005c8a9d9bda
> --- /dev/null
> +++ b/tools/unwind/verify_insn_arch.cpp
[ ... ]
> +static bool stepInstructionX86(AbsState &st, StringRef OpName,
> +			       const MCInstrDesc &Desc, const InsnStepCtx &ctx)
> +{
> +	const MCInst &MI =3D ctx.MI;
[ ... ]
> +	if (OpName.starts_with("PUSH64r")) {
> +		int src =3D ctx.regD(0);
> +		st.regs[7] =3D addSymImm(st.regs[7], -8);
> +		st.store(st.regs[7], ctx.getRegVal(st, src));
> +		return true;
> +	}
> +	if (OpName =3D=3D "PUSHF64" || OpName.starts_with("PUSH64i") ||
> +	    OpName =3D=3D "PUSH64rmm" || OpName =3D=3D "PUSH64rmr") {
> +		st.regs[7] =3D addSymImm(st.regs[7], -8);
> +		st.store(st.regs[7], {VK_UNKNOWN, 0});
> +		return true;
> +	}
> +	if (OpName.starts_with("POP64r")) {
> +		int dst =3D ctx.regD(0);
> +		SymVal loaded =3D st.load(st.regs[7]);
> +		st.regs[7] =3D addSymImm(st.regs[7], 8);
> +		if (dst !=3D 7)
> +			ctx.setRegVal(st, dst, loaded);
> +		return true;
> +	}
> +	if (OpName =3D=3D "POPF64" || OpName =3D=3D "POP64rmm") {
> +		st.regs[7] =3D addSymImm(st.regs[7], 8);
> +		return true;
> +	}

[Severity: Medium]
Do the OpName.starts_with("PUSH64r") and OpName.starts_with("POP64r") checks
shadow the PUSH64rmm, PUSH64rmr and POP64rmm branches right below them?

Because those opcodes share the "PUSH64r" and "POP64r" prefixes, they always
take the register-operand branch first, where ctx.regD(0) is the memory
address base register rather than a value register.  As a result, PUSH64rmm
(such as pushq -8(%r10) in a DRAP prologue) pushes the base register's
symbolic value onto the stack instead of VK_UNKNOWN, and POP64rmm overwrites
the base register with the popped stack value.

In addition, in the POP64r handler, guarding ctx.setRegVal(st, dst, loaded)
with dst !=3D 7 prevents pop %rsp from updating st.regs[7] with the value
loaded from the stack.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061523.1540=
234-1-irogers@google.com?part=3D27
