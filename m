Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588332;
	b=a/JDXD7W7ftQYc8U4b739KEkODbDuegNjkMAIuPYyUgv7cE46q4+Eb8iWcpE9OHjvn49
	 EfGYQyM52oWofD6pFIAxTOwlA2xlbiZ5g2lXiKbjBwtHofOzr5OIeqsGQNW24hVmHcHaj
	 Dq7n+Dhu1h8TQdXsClIDvC+zm7RZsjsDNS/RdvFmzo78Yl5mkyh5HI+YOt2uqBpH7LdqE
	 0DwPR9mH/zd6KYp3L/jfNtenQ2+GLkpZsFIYnO1WewgPxR038GP7H4ZnDUd4zfuj8JCIM
	 +9HVkzg54oiA4Ho0YPfRMg/bRZUrC2qwQpyklDVvKImXSwrNBOjbI20maBhtCAZuQwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588332;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lN0/IceNSq/tJfj0XM571/oGNRiYEMA+7QT5WkAGDPo=;
	b=y5mBJkOt+A23ZROr7X4AEMqX6PytkoQjfdGN9xJRbS5aDUy171SdfAdnWf8XfBRWHj3o
	 jCVFFXgXvbMwFB0EL9gKVZs8WjPoBRdMhQehZ73+55STmaaqXMgmTXd1bJkaHi5naL/pV
	 pGHdnS0f1hsZAEjNMQrsBS4N8TTEUIpTMIouqdqJv1S3z0NBZure+xwchN0K+I5L1EJsg
	 vzRwn0ooxSs+cJBLFRDGWC+HJ4MCqF+Cp/XjYAgZ7f5TTkvl1hNwoV2xgXWYsuV1W91/O
	 mnlSUxr98fhwNTJoYobKBr/B91qHkyHcIZeDwnbDi14AA2plSDpLpEC+rZLZqxMukjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHyDqgjG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E986606A32C;
	Wed, 25 Nov 2026 06:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UHyDqgjG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6692E1F000D3;
	Wed, 25 Nov 2026 06:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795588332;
	bh=lN0/IceNSq/tJfj0XM571/oGNRiYEMA+7QT5WkAGDPo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UHyDqgjGATZQTJAtY/qhXxBpvhVzI3nUCjjnlA+J1+wzYfEh+daYTDwpZPRR8G/a/
	 UXvic48AGJEdsn/7AD13JK/PhMNN8TbDTrR5sfaIuK6RdL34LZNXVbSqkh4tnL8P9/
	 zalBtZflVtve2LXPyIrRdrr0ecP7opSXkGzkHkagC/nNZ/S71BRL96KUsINOQ/+PSu
	 vRjvDrWqCkt4UIj2KZwTD96Ns7q0TT9RADkDWMcx+HeQh8R/FUh9QsUPBEKvnLk4rA
	 dR0kl1zCR/qf6ebS90O1IJGCp85/X5rrx1TOAAv3Dc8nL8WYqT/00bBFR6dp3grynI
	 qtCQTpLBTb30w==
Message-ID: <sashiko-outbox-232708@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 01/30] unwind: Add Minimal DWARF CFI bytecode
 interpreter
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261125061523.1540234-2-irogers@google.com>
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-2-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:32:09 +0000
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
- [Medium] unwind: dwarf_cfi: noinstr violations via
  kmsan_unpoison_memory() and likely()
--

commit a47eb90bddad018f7c1af29e002c5e94dbaf8bab
Author: Ian Rogers <irogers@google.com>

unwind: Add Minimal DWARF CFI bytecode interpreter

This commit adds a bounded DWARF Call Frame Information (.eh_frame and
.eh_frame_hdr) bytecode interpreter for kernel, module, and user-space
stack unwinding.

> diff --git a/kernel/unwind/Makefile b/kernel/unwind/Makefile
> index eae37bea54fdb..f772fc6079855 100644
> --- a/kernel/unwind/Makefile
> +++ b/kernel/unwind/Makefile
> @@ -1 +1,11 @@
> - obj-$(CONFIG_UNWIND_USER)	+=3D user.o deferred.o
> +ifdef CONFIG_FUNCTION_TRACER
> +CFLAGS_REMOVE_dwarf_cfi.o =3D $(CC_FLAGS_FTRACE)
> +endif
> +KASAN_SANITIZE_dwarf_cfi.o :=3D n
> +KCSAN_SANITIZE_dwarf_cfi.o :=3D n
> +UBSAN_SANITIZE_dwarf_cfi.o :=3D n
> +KMSAN_SANITIZE_dwarf_cfi.o :=3D n
> +KCOV_INSTRUMENT_dwarf_cfi.o :=3D n
> +
> +obj-$(CONFIG_UNWIND_DWARF_CFI)		+=3D dwarf_cfi.o
> +obj-$(CONFIG_UNWIND_USER)		+=3D user.o deferred.o
> diff --git a/kernel/unwind/dwarf_cfi.c b/kernel/unwind/dwarf_cfi.c
> new file mode 100644
> index 0000000000000..8b8004b1b8d15
> --- /dev/null
> +++ b/kernel/unwind/dwarf_cfi.c

[ ... ]

> +static __always_inline int
> +dwarf_cfi_eval_fde_streams(struct dwarf_cfi_stream *cie_s,
> +			   struct dwarf_cfi_stream *fde_s,
> +			   unsigned long pc,
> +			   const struct dwarf_cfi_arch *arch,
> +			   struct dwarf_cfi_row *out_row,
> +			   bool is_user)
> +{

[ ... ]

> +	*out_row =3D row;
> +	kmsan_unpoison_memory(out_row, sizeof(*out_row));
> +	return 0;
> +}

[ ... ]

> +noinstr int dwarf_cfi_eval_fde_kmem(const u8 *fde, const u8 *eh_start,
> +				    const u8 *eh_end, unsigned long pc,
> +				    const struct dwarf_cfi_arch *arch,
> +				    struct dwarf_cfi_row *out_row)
> +{

[ ... ]

> +	return dwarf_cfi_eval_fde_streams(&cie_s, &fde_s, pc, arch, out_row,
> +					  /*is_user=3D*/false);
> +}

[Severity: Medium]
Can the noinstr functions in dwarf_cfi.c call into instrumented .text when
CONFIG_KMSAN or CONFIG_TRACE_BRANCH_PROFILING is enabled?

dwarf_cfi_eval_fde_kmem() is marked noinstr and inlines
dwarf_cfi_eval_fde_streams(), which calls kmsan_unpoison_memory().
Because kmsan_unpoison_memory() in include/linux/kmsan-checks.h is gated
on CONFIG_KMSAN rather than __SANITIZE_MEMORY__, KMSAN_SANITIZE_dwarf_cfi.o=
 :=3D n
does not stub it out, leaving a direct call from .noinstr.text to .text.

In addition, neither kernel/unwind/Makefile nor dwarf_cfi.c defines
DISABLE_BRANCH_PROFILING, so under CONFIG_TRACE_BRANCH_PROFILING=3Dy every
likely() and unlikely() in the noinstr functions and their inlined helpers
expands to a call to ftrace_likely_update() in .text, triggering objtool
noinstr warnings and running instrumented code in noinstr contexts.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061523.1540=
234-1-irogers@google.com?part=3D1
