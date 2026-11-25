Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590327;
	b=Yc3qYCS8iMWZspbnY8gBNKwOOUmNnDMTGBiR3K0QueKPBNWia4zUybcBPzo5dR+D0pd9
	 CryDKmZqTKA/DPoslZ5i4QMTvslkKouDF43Ov/uyfY03Z9fQKN1JxQRpjQHJjJSZiRI9X
	 ajTQvthubHoySKKbMTsCJot01Ouwsv1MB+UtN40IILgHRlx2aL93u4+Gq45kQ0ZYik6Td
	 fRwwYOImvSlH3J3te7ijmHRIhkASvXCP9MNRhJVhYWw6b7GsZcgJuvdeRUzijyflDyM9/
	 7VSI3+hNPVQ66R7Gs97yJ79lxRB+zxcTTaGHvAi6PBsdVLmcVxCGoYIq2ES3V0i/dSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590327;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=NV4tHvm//FRxecZaBUoWqlVkU+JTcbeh9ucCxkt6nvY=;
	b=np0LrgTbpErm7W+wkcrkb4KciZj4JTSMG8WVs9M904LGkR9cFHIBkF+rsmuIMKzG273q
	 RSmA9i5A9KV4NN86W4MRQzO3uQhK/++vvXDGTMEuVAf/X+Xtydy7/GbqJ5vpClvUEGPkv
	 5gqDyV2GSJP8OVCOF347jJUJWL72HtBO1uEfQOnkeezaQletheJxR98uzw4xqzIrzuhwr
	 M4L7MirIs//uOy2ckIRNOTBThoUe1YjTjLuQlTvFvY6TWOTvfxUCokU/XcT0cTe/CzJ70
	 Ih4XZrZEE8ybdKnYxGaSaNOC89qj+RXFZKBA9Tg1x0XA91I67vqIbw6kJF18U4rk2bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f9ryw9Ss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A14606A321;
	Wed, 25 Nov 2026 07:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f9ryw9Ss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E660B1F008B2;
	Wed, 25 Nov 2026 07:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590326;
	bh=NV4tHvm//FRxecZaBUoWqlVkU+JTcbeh9ucCxkt6nvY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=f9ryw9SsJWxv7Waw5QeUwV/Pg9d70/gdXG1J85QsjdoNvADrlx/CbzMXBEaQQqanG
	 aOrZjv8/lCGzBktU9nEi02WyCp5Se/77h8S/hy7T/gOMaBlUTKShP6T+5frZlL3FYs
	 lWxUAPV6yekSUrjNOtzQHxTtKIrrkpPJ7aD9h1vAvv+GW+cTHwpRxxrnV/pEXDBFkY
	 vYD3QI/NVlCLqvpkOCNQ1frtFc8ZI48DX9Jbcwh+zMOXnjPUhqVL/hWxjHA6iRCKke
	 x7Kx/V43slJOTtvU6L+KQuAqa9ED5iMpxtPhX+9AxGblq+WKigcJIE5w0CCZXTPtlu
	 r+4Javm+vhfwA==
Content-Type: multipart/mixed; boundary="===============0385700896231025658=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <bfa6da75b5dc0cdd6d9e9227dfa134aa117e4bb14b2a11c911506747c175ae94@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-2-irogers@google.com>
References: <20261125061523.1540234-2-irogers@google.com>
Subject: Re: [RFC PATCH v2 01/30] unwind: Add Minimal DWARF CFI bytecode interpreter
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:05:21 +0000 (UTC)

--===============0385700896231025658==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> unwind: Add Minimal DWARF CFI bytecode interpreter

TL;DR: Nits only: duplicated DWARF CFI parsing, register-check and CIE-lookup
code could share helpers, and the UNWIND_TABLES Kconfig move may belong in a
later patch or be explained. No bugs found.

> diff --git a/arch/Kconfig b/arch/Kconfig
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -500,6 +500,12 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
>  	  It uses the same command line parameters, and sysctl interface,
>  	  as the generic hardlockup detectors.
>
> +config UNWIND_TABLES
> +	bool
> +
> +config UNWIND_DWARF_CFI
> +	bool
> +
>  config UNWIND_USER
>  	bool

This isn't a bug, but could the move of UNWIND_TABLES into arch/Kconfig go
in the patch that first selects it from another architecture, or could the
changelog say why it is needed here?

[ ... ]

> diff --git a/kernel/unwind/dwarf_cfi.c b/kernel/unwind/dwarf_cfi.c
> --- /dev/null
> +++ b/kernel/unwind/dwarf_cfi.c

[ ... ]

> +static __always_inline int
> +cfi_parse_indirect_cfa_expr(struct dwarf_cfi_stream *s, u32 expr_len,
> +			    const struct dwarf_cfi_arch *arch,
> +			    struct dwarf_cfi_row *row, bool is_user)
> +{
> +	struct dwarf_cfi_stream es;
> +	u8 expr_buf[8], op0, op_end;
> +	enum dwarf_cfi_base base;
> +	s32 off;
> +	int err;
> +
> +	if (expr_len < 3 || expr_len > 7)
> +		return -EINVAL;
> +	/* Prevent Spectre v1.1 speculative stack overflow of expr_buf[8] */
> +	barrier_nospec();
> +
> +	err = cfi_read_bytes(s, expr_buf, expr_len, is_user);
> +	if (err)
> +		return err;
> +
> +	cfi_stream_init_kmem(&es, expr_buf, expr_len - 1);
> +	err = cfi_read_u8(&es, &op0, /*is_user=*/false);
> +	if (err)
> +		return err;
> +
> +	if (arch->fp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->fp_reg))
> +		base = DWARF_CFI_BASE_FP_INDIRECT;
> +	else if (arch->sp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->sp_reg))
> +		base = DWARF_CFI_BASE_SP_INDIRECT;
> +	else
> +		return -EINVAL;
> +
> +	err = cfi_read_sleb128_s32(&es, &off, /*is_user=*/false);
> +	if (err || !cfi_stream_empty(&es, /*is_user=*/false))
> +		return -EINVAL;

[ ... ]

> +static __always_inline int
> +cfi_parse_reg_expr(struct dwarf_cfi_stream *s, u32 reg, u32 expr_len,
> +		   const struct dwarf_cfi_arch *arch, u8 ra_reg,
> +		   struct dwarf_cfi_row *row, bool is_user)
> +{
> +	struct dwarf_cfi_stream es;
> +	u8 expr_buf[8], op0;
> +	enum dwarf_cfi_rule rule;
> +	s32 off;
> +	int err;
> +
> +	if (expr_len < 2 || expr_len > 6)
> +		return -EINVAL;
> +	/* Prevent Spectre v1.1 speculative stack overflow of expr_buf[8] */
> +	barrier_nospec();
> +
> +	err = cfi_read_bytes(s, expr_buf, expr_len, is_user);
> +	if (err)
> +		return err;
> +
> +	cfi_stream_init_kmem(&es, expr_buf, expr_len);
> +	err = cfi_read_u8(&es, &op0, /*is_user=*/false);
> +	if (err)
> +		return err;
> +
> +	if (arch->fp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->fp_reg))
> +		rule = DWARF_CFI_RULE_FP_OFFSET;
> +	else if (arch->sp_reg <= 31 && op0 == (u8)(DW_OP_breg0 + arch->sp_reg))
> +		rule = DWARF_CFI_RULE_SP_OFFSET;

This isn't a bug, but cfi_parse_indirect_cfa_expr() and cfi_parse_reg_expr()
share almost the same DW_OP_breg decode sequence, including the
barrier_nospec() bounds handling.

Could they use one helper that decodes the breg operand and offset, so each
caller only adds its own trailing check?

[ ... ]

> +		if (hi == 0x80) {
> +			/* DW_CFA_offset */
> +			err = cfi_read_uleb128_u32(s, &uval, is_user);
> +			if (err)
> +				return err;
> +			if (lo == arch->fp_reg || lo == cie->ra_reg ||
> +			    lo == arch->sp_reg) {
> +				err = cfi_factored_offset(uval, cie->data_align, &off);
> +				if (err)
> +					return err;
> +				cfi_apply_reg_rule(lo, DWARF_CFI_RULE_OFFSET,
> +						   off, arch, cie->ra_reg, row);
> +			}
> +			continue;
> +		}

This isn't a bug, but could the repeated fp/ra/sp check in
dwarf_cfi_exec_insns() become a small inline helper such as
cfi_reg_is_tracked(reg, arch, cie->ra_reg)?

The same three-way test appears in the DW_CFA_offset, DW_CFA_offset_extended,
DW_CFA_offset_extended_sf, DW_CFA_GNU_negative_offset_extended,
DW_CFA_register, DW_CFA_val_offset, DW_CFA_val_offset_sf, DW_CFA_expression
and DW_CFA_val_expression cases, so the set of tracked registers would be
defined in one place.

[ ... ]

> +	} else {
> +		while (lo < hi) {
> +			u32 mid = lo + (hi - lo) / 2;
> +			const u8 *ent = table + (size_t)mid * ent_sz;
> +			unsigned long e_pc = (unsigned long)ent +
> +					     (long)(s32)get_unaligned_le32(ent);
> +
> +			if (e_pc <= pc)
> +				lo = mid + 1;
> +			else
> +				hi = mid;
> +		}
> +		if (!lo)
> +			return -ENOENT;
> +		{
> +			const u8 *fent = table + (size_t)(lo - 1) * ent_sz + 4;
> +
> +			fde_addr = (unsigned long)fent +
> +				   (long)(s32)get_unaligned_le32(fent);
> +		}
> +	}

This isn't a bug, but could the kernel lookup in
dwarf_cfi_unwind_eh_frame_hdr() use eh_hdr_entry_addr() in one binary-search
loop, the way dwarf_cfi_unwind_user_eh_frame_hdr() does, rather than two
hand-written loops and the bare block around fent?

[ ... ]

> +			if (cie_delta < 4 ||
> +			    (size_t)((p + 4) - eh_start) < cie_delta)
> +				return -EINVAL;
> +			cie = (p + 4) - cie_delta;
> +			if (cie < eh_start || cie >= eh_end ||
> +			    (size_t)(eh_end - cie) < 8)
> +				return -EINVAL;
> +			cie_len = get_unaligned_le32(cie);
> +			if (cie_len <= 4 || cie_len > DWARF_CFI_MAX_CIE_LEN ||
> +			    (size_t)(eh_end - cie) - 4 < (size_t)cie_len ||
> +			    get_unaligned_le32(cie + 4) != 0)
> +				return -EINVAL;
> +
> +			cfi_stream_init_kmem(&cie_s, cie + 8, cie_len - 4);

This isn't a bug, but could the CIE resolution here in
dwarf_cfi_scan_eh_frame_kmem() and the one in dwarf_cfi_eval_fde_kmem() share
a small __always_inline helper?

That way the module index scan and the evaluator could not drift apart on
which CIEs they accept.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============0385700896231025658==--
