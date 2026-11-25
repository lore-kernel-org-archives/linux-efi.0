Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795590393;
	b=1kugWJb6F8kJl4oHMdHxZakYCM6Tc7yExKSqtvrBJI6T8I6sJuDn50KUCgZTltN/BGhZ
	 bapX5qulDEHi3lr4M/m4O/CzqVvICFL4Gjd7XKelczaxKoMJcidVUNi/+4w3RRlXRsNg8
	 F0k2uyA1Eo8L8nGXTvD5DWjCBHSt2SiCdzNBG7220af640HaUyyWlpSZ6evycUo1pUflF
	 G2v14HLDSfMj0IhhmChWSf8eZAYAKG5DxfeqBAyqyX5smBKinPxMHCFmiIhyHFSXCwi2I
	 lxgT1Vi9J93XAu8PYSqlUEC98rdrTVhQAs2Z7aOtUwwX4UPMe52h5B/tR5PrUEK+Bow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795590393;
	h=Received:DKIM-Signature:Content-Type:MIME-Version:Message-Id:
	 In-Reply-To:References:Subject:From:To:Cc:Date;
	bh=VTt6zMI2ZGQuNoT+pwSmNZDKDB0qjlMH2g2+jbHu2XY=;
	b=AuLcW1LeXGFse289Gl3psyjvcpeJAtv6mQ6N8iHvfMWkuDPojV2heu9Pl6Q5Eod/9HQc
	 x53wKwzbSALD84wR1irLckrNZ7M7OkTmbkdONFIIUzr2zhyeHBgKhQkYyt31wHVm1Wg4J
	 s6PXWcTWc7lTfYxMsssqAZsXNFSX7OuiyZopgPtJNkgRkR18YtfEILxW3PwSXXTrJHL8U
	 gDaWzxnVUoBc2qrAvPVi1JgrfuldurXFcE5fNVW8xcaf2T7fyLzCb8X1C+4aoprfG+ssx
	 p6xhhnNS/iXObQipfdIBx1ZHBfDhARCFtm1qwdGy2BZ7nvhz2PIm61nSk6eCURZzu0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=fail reason="signature verification failed" header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIxG2thy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65F5606A682;
	Wed, 25 Nov 2026 07:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIxG2thy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F044B1F000F2;
	Wed, 25 Nov 2026 07:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795590393;
	bh=VTt6zMI2ZGQuNoT+pwSmNZDKDB0qjlMH2g2+jbHu2XY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=LIxG2thye0IyoCFQLznqiCsfloMK+HyPBWcMhmtvKlkCCTAGM516w86ppow7+t0Wi
	 S8tEgxGpmuywrn3dtFQq2+/sfaxq9M0jtPi62cPTdDfmVUBKNjXdXDSzePHicx2EAl
	 gP9miaHBZYG/gPtS1Urf7+69ATVVqe1mdFnLhGfDodGry/LRKM//nrxgDpwFXGZhAC
	 TCGUFIN1jnDQFwlw7JLPbKVbnG237L4wNmWS251n98BEOeXzDdf+tgFKIzLNkVffY0
	 ZSQpA0DOcxS357Np5CD/2tPYtzD7yEvWKEwxumpPX/fRC8XigC0wdgdWd88omgSqOU
	 BW7CpLaYqd0BA==
Content-Type: multipart/mixed; boundary="===============7460090708809915497=="
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Message-Id: <81b431617bdfcaad9c3627e79a5bf34391a223ab5ba8135ef4996642e56673e2@mail.kernel.org>
In-Reply-To: <20261125061523.1540234-6-irogers@google.com>
References: <20261125061523.1540234-6-irogers@google.com>
Subject: Re: [RFC PATCH v2 05/30] scripts: Add min_eh_frame build-time .eh_frame minifier
From: bot+bpf-ci@kernel.org
To: irogers@google.com,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-arch@vger.kernel.org
Cc: jpoimboe@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@redhat.com,tglx@kernel.org,bp@alien8.de,dave.hansen@linux.intel.com,x86@kernel.org,catalin.marinas@arm.com,will@kernel.org,mark.rutland@arm.com,linux-arm-kernel@lists.infradead.org,pjw@kernel.org,palmer@dabbelt.com,aou@eecs.berkeley.edu,alex@ghiti.fr,linux-riscv@lists.infradead.org,acme@kernel.org,namhyung@kernel.org,linux-perf-users@vger.kernel.org,mhiramat@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,bpf@vger.kernel.org,nathan@kernel.org,llvm@lists.linux.dev,nsc@kernel.org,linux-kbuild@vger.kernel.org,ojeda@kernel.org,rust-for-linux@vger.kernel.org,ardb@kernel.org,linux-efi@vger.kernel.org,maz@kernel.org,oupton@kernel.org,kvmarm@lists.linux.dev,shuah@kernel.org,linux-kselftest@vger.kernel.org,indu.bhagat@oracle.com,jremus@linux.ibm.com,wnliu@google.com,dylanbhatch@google.com,irogers@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yongho
 ng.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 25 Nov 2026 07:06:28 +0000 (UTC)

--===============7460090708809915497==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> scripts: Add min_eh_frame build-time .eh_frame minifier

TL;DR: Nits only, none described as bugs, in scripts/min_eh_frame.c: use a
named enum instead of bare rule numbers (which differ from the kernel's), and
share the duplicated register-rule and cleanup code.

> diff --git a/scripts/min_eh_frame.c b/scripts/min_eh_frame.c
> new file mode 100644
> index 000000000000..55b07b11c635
> --- /dev/null
> +++ b/scripts/min_eh_frame.c

[ ... ]

> +static bool rows_equal(const struct min_row *a, const struct min_row *b)
> +{

[ ... ]

> +	if ((a->fp_rule == 1 || a->fp_rule == 2 || a->fp_rule == 4) &&
> +	    a->fp_off != b->fp_off)
> +		return false;
> +	if ((a->ra_rule == 1 || a->ra_rule == 4) &&
> +	    a->ra_off != b->ra_off)
> +		return false;

This isn't a bug, but would a small local enum for the rule and CFA-kind
codes make rows_equal() and the restore paths easier to check?

struct min_row documents fp_rule as 0=same, 1=cfa_off, 2=fp_off, 3=undef,
4=sp_off, and these bare numbers are tested about 38 times in the file.

The kernel interpreter in include/linux/unwind_dwarf_cfi.h numbers the same
concepts differently (DWARF_CFI_RULE_SP_OFFSET is 3 and
DWARF_CFI_RULE_UNDEFINED is 4), so "fp_rule == 4" means different things on
each side.  Matching the dwarf_cfi_rule numbering would avoid that.

[ ... ]

> +				if (reg == arch->fp_reg) {
> +					row.fp_rule = 1;
> +					row.fp_off = off;
> +				} else if (reg == cie->ra_reg) {
> +					row.ra_rule = 1;
> +					row.ra_off = off;
> +				} else {
> +					row.sp_rule = 1;
> +					row.sp_off = off;
> +				}

This isn't a bug, but could these fp/ra/sp assignment blocks share a small
helper, along the lines of cfi_apply_reg_rule() in kernel/unwind/dwarf_cfi.c?

The same ladder appears in minify_insns() for DW_CFA_offset_extended,
DW_CFA_offset_extended_sf, DW_CFA_GNU_negative_offset_extended,
DW_CFA_undefined and DW_CFA_same_value, differing only in the rule value
and offset.  The restore paths (DW_CFA_restore and DW_CFA_restore_extended)
repeat a similar three-way copy from cie_base, which cfi_restore_reg() covers
on the kernel side.

[ ... ]

> +	free(anchors.data);
> +	free(cies);
> +	free(sorted_relas);
> +	free(out_eh.data);
> +	free(out_relas);
> +	return 0;
> +
> +bail:
> +	/* Leave unusual/hand-crafted .eh_frame untouched rather than failing build */
> +	free(anchors.data);
> +	free(cies);
> +	free(sorted_relas);
> +	free(out_eh.data);
> +	free(out_relas);
> +	return 0;

This isn't a bug, but since the success path and bail: free the same buffers
and both return 0, could the success path fall through to a single cleanup
label, with a ret variable for the -1 case, as minify_insns() does?

process_elf64() has a third copy of the same five frees in the record-length
error path, which returns -1.  The FDE branch also repeats
"free(rmaps); free(min_fde_insns.data); free(fde_rec.data); goto bail;" three
times.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/45561209846
--===============7460090708809915497==--
