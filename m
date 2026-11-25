Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795589282;
	b=mV3NAxv74YpI6wJb/8Wwo86IchkrmkRqo/kU2Ix8vlIPySX0bJMMBKza2IzlHDZSWpHH
	 gQGk7sbfy3geNdvjN9eb7hc4PP7epRRA30qW4PozjZ80n+RRneWt15MpPTQyA3uGgFUZk
	 X5B7j7zZ0/YUhUjkzrLb9su77QTXu1d77MTtDulrMnq1pDF4M9r9Fpc1HDN26XGG9JHXO
	 PkyiXL4KkvWgD+IX1Tq5F5gtgAdMKi/IeGhl5bL9pAgxACxFcUdoVCefhS0BJQLtokKbr
	 Ed/D65mrnKKMONvPnm3pZDY2Hnbq73qCHDJGt93zYCv9WLb33e/Q4vFSsPLd5NnZgYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589282;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=w/FTXqrH5AIrzUuo8YH2Y9Z6F/zJk24rjcjm0U0HEHw=;
	b=edsYtGe5z5tQmonDDCzzZn5mW0lSxZl/dbCJ/NFXH7AWIzNPveHxnH5GfMfRmUuNbmef
	 ro97UQ40v+eaIcHTsEl8wXtnBRKU2q+2kGYih9Xk0qfDXSyJVPKI1fVLWvmVQTVBXbFk3
	 WF+dYJuGY8+9ojoJLojb5h9u3eL0M+potjLeDRsRDLjjW387XG5/63aoKRVicVFi1zjOX
	 yPY0CubV5daVSoSKaD4kGm3zASCdKnB+4j3OJR1YMksXLtkW55Hx4VpJJlaEAWKhS8A1H
	 SGVCac6dzUHvc5PpVerOfSCfd/zt1iHbrdtz9cCbFUsE0wJQixwwbdEWQHmGP3MTLng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGD2OyfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D892606A31E;
	Wed, 25 Nov 2026 06:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGD2OyfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B72A1F000C6;
	Wed, 25 Nov 2026 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795589281;
	bh=w/FTXqrH5AIrzUuo8YH2Y9Z6F/zJk24rjcjm0U0HEHw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=RGD2OyfZOoXrJx6S4zQf9OrP6dpeguJeek9JYgL019ncKwNu3vVCRtpWDD1PVCyjH
	 XGIiho4GvZQoNZDuGevBp+EdPfLyYnYBKxPYhI3VwGdOgdK+bWzvAHSM/CNeK406f7
	 TmzV2LP8jrZy6nkvCbZuAwuWLkM7SYmVX6wmIu5tPdC2MBLMxztD5HB/cEmVBcFq9j
	 QGm0OEgsUIqrWfLnEgHSGubLihKCRqAMN8vwCGfz5tjr+LPwWp0T2a6x/X04cNqxDv
	 UVjUV9xvfT8hCmcg64r+XQoR+0gazgtCATLmvOzMBF+K6Igq+1vn67kLjJGMdMv5X4
	 dj1EETaUgvHPQ==
Content-Type: multipart/mixed; boundary="===============6730931518485205145=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <c5a12d8c446ae04259b5ff4edbcccd0326d5476575d18cdaa5050d57a50b9c51@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-5-irogers@google.com>
References: <20261125061523.1540234-5-irogers@google.com>
Subject: Re: [RFC PATCH v2 04/30] x86: unwind_user: Support Minimal DWARF CFI user unwinding
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 06:47:56 +0000 (UTC)

--===============6730931518485205145==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> x86: unwind_user: Support Minimal DWARF CFI user unwinding

TL;DR: Nit only: unrelated comment additions in this x86 CFI patch aren't in
the changelog; suggests moving them to a separate documentation patch.

> diff --git a/arch/x86/include/asm/unwind_user.h b/arch/x86/include/asm/unwind_user.h
> --- a/arch/x86/include/asm/unwind_user.h
> +++ b/arch/x86/include/asm/unwind_user.h

[ ... ]

> +/**
> + * unwind_user_word_size() - Return the user-space word size in bytes on x86
> + * @regs: User-mode register state.
> + *
> + * Return: 8 for 64-bit user mode, 4 for 32-bit IA-32/compat mode, or 0 for
> + * VM86 mode stacks which cannot be unwound.
> + */
>  static inline int unwind_user_word_size(struct pt_regs *regs)

[ ... ]

> +/* Standard x86 frame record: {saved_bp, ret_addr} at [bp, bp + 2 * ws). */
>  #define ARCH_INIT_USER_FP_FRAME(ws)			\

[ ... ]

> +/* At function entry before push %rbp: return address is at [sp, sp + ws). */
>  #define ARCH_INIT_USER_FP_ENTRY_FRAME(ws)		\

[ ... ]

> +/**
> + * unwind_user_at_function_start() - Check if @regs is at a function entry point
> + * @regs: User-mode register state.
> + *
> + * Return: true if stopped on an entry uprobe before the frame prologue ran.
> + */
>  static inline bool unwind_user_at_function_start(struct pt_regs *regs)

This isn't a bug, but the new comments on unwind_user_word_size(), the
ARCH_INIT_USER_FP_* macros and unwind_user_at_function_start() don't look
related to adding CFI support, and the changelog doesn't mention them.

Would they fit better in a separate documentation patch, so this one only
carries the x86 CFI register mapping and the Kconfig select?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============6730931518485205145==--
