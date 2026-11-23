Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795392685;
	b=qIYHaSpFOOhS2zSZQRXnsTDyKtJ10n6fKkvezz0iiw9KPKK3cu6WUrUpWaTacGf3NGeN
	 JLCVJJKVa2Q6z8SjeEWxBamRhMjMS8DrGizYTNmBeFtTJUfS6qrvhmZE7guYD092gCs5j
	 KY7tXRBT8LqIiXsWHfJE8gObVl4q2ofshnM4qNN7TlSfrW0A5QtD2whbXDATf5w+QHXBI
	 O5LOHr//YcTtvvqnnhT6s7d29xDPl8jK9iJxDjHGTVwZyqh900V9NdKYsuB8GLOelDFsW
	 +O6JJUFLBSQu2wcenX4K9M6rZXtEXeh8Irnt7w4sQ2Ps9Q5rDRcNblSthOKnp23NNNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795392685;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=hUBXPUTSh1Mif4HrNZ0RSTwmhunuVo8syBnjs+cVsyQ=;
	b=TAt68MR7Rl66cU4sHuXl8OIC83oSFst0qVDnpOgaF4KTkpRp6ZjZSwoRJ2nWeksSF/Zw
	 705YiZHVWSFLzVpmSN8nb7MeTjAycRUBBf02vMQyRKvaoP2HerRANORBfKZtbNXEpiKa8
	 YwKoBylrJTFxqUzTULk2EOnp5I+BYrqrfNMfjqKx9JfA0TeYyHEscDreGfmAY4kbuBj64
	 zOalZ8byRKyZlthTc/ZX+ZWsHAb7ENEw+l0FHSqbkM82BIeW0c/ySV3aCP2oxaKc2mF+x
	 uqi/enpjadPZPtGGvsRWY7PWBx6WDtxXefi+V1usDbf9vhj+CamdLNrM9ACyReOQcIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mu8DXyjU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D5D606A31A;
	Mon, 23 Nov 2026 00:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mu8DXyjU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF6D1F000C0;
	Mon, 23 Nov 2026 00:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392684;
	bh=hUBXPUTSh1Mif4HrNZ0RSTwmhunuVo8syBnjs+cVsyQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mu8DXyjUMCpjQEfKuorK0vW5hwF3MXt9pqufuJVW6q41/SUlWbm8mxEgYUycyErxM
	 opq1093Le7AqK4nA5dRTxbDnsz7zWFl/pw9w6ej+1Nfjn1DCF45ipc6eQ0oEAQWJrb
	 8kd/bfEFZ+iBN0xvkUs98lDYomV676MXXEMfOGIzQA/IrVfztuC/IRqApvTm761XO6
	 Xn+7oqGraPSC3eTQyIJnRuLSofEcuXjUEJowZCELKDT8ZU2qZi5267f56iIp0w33w+
	 bpW2xg61m1DcPtt/EPTuT0njgPl3cM2J41xARv1J3KInhSF/jvI0zpkVsNdHF61oNI
	 1TYDVK/ciE6Xw==
Message-ID: <sashiko-outbox-228460@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v1 01/11] unwind: Add Minimal DWARF CFI bytecode
 interpreter and KUnit tests
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261122235757.3456048-2-irogers@google.com>
References: <20261122235757.3456048-1-irogers@google.com>
 <20261122235757.3456048-2-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 00:11:22 +0000
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
- [Medium] unwind: missing CONFIG_STACKTRACE dependency for
  dwarf_cfi_kunit.c
- [Medium] unwind: signed FDE range sign-extension in
  dwarf_cfi_eval_fde_streams()
- [Medium] unwind: high-order kmalloc() for FDE index table in
  dwarf_cfi_mod_alloc()
--

commit 31c297accf2da5579a418d80b5e8b6a08f8ba8e6
Author: Ian Rogers <irogers@google.com>

unwind: Add Minimal DWARF CFI bytecode interpreter and KUnit tests

This commit adds a bounded DWARF Call Frame Information (.eh_frame and
.eh_frame_hdr) bytecode interpreter, module FDE indexing helpers, and a
KUnit test suite.

> diff --git a/arch/Kconfig b/arch/Kconfig
> index 1163736de1f99..03399120aa8f7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -500,6 +500,22 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
>  	  It uses the same command line parameters, and sysctl interface,
>  	  as the generic hardlockup detectors.
> =20
> +config UNWIND_TABLES
> +	bool
> +
> +config UNWIND_DWARF_CFI
> +	bool
> +
> +config UNWIND_DWARF_CFI_KUNIT_TEST
> +	bool "KUnit tests for Minimal DWARF CFI unwinder" if !KUNIT_ALL_TESTS
> +	depends on KUNIT=3Dy && UNWIND_DWARF_CFI
> +	default KUNIT_ALL_TESTS

[Severity: Medium]
Does UNWIND_DWARF_CFI_KUNIT_TEST fail to build when CONFIG_STACKTRACE is
disabled?

unwind_test_leaf() in kernel/unwind/dwarf_cfi_kunit.c unconditionally calls
stack_trace_save(), which include/linux/stacktrace.h only declares under
CONFIG_STACKTRACE.  In addition, test_live_kernel_stack_walk() guards
stack_trace_save_tsk_reliable() only with CONFIG_HAVE_RELIABLE_STACKTRACE,
so with CONFIG_STACKTRACE=3Dn it calls the fallback stub returning -ENOSYS.
Either UNWIND_DWARF_CFI_KUNIT_TEST should depend on STACKTRACE, or the live
stack walk test should be guarded by IS_ENABLED(CONFIG_STACKTRACE).

> diff --git a/kernel/unwind/dwarf_cfi.c b/kernel/unwind/dwarf_cfi.c
> new file mode 100644
> index 0000000000000..3e474bce1ab5e
> --- /dev/null
> +++ b/kernel/unwind/dwarf_cfi.c

[ ... ]

> +static int dwarf_cfi_eval_fde_streams(struct dwarf_cfi_stream *cie_s,
> +				      struct dwarf_cfi_stream *fde_s,
> +				      unsigned long pc,
> +				      const struct dwarf_cfi_arch *arch,
> +				      struct dwarf_cfi_row *out_row)
> +{
> +	struct dwarf_cfi_cie cie;
> +	struct dwarf_cfi_row cie_row, row;
> +	unsigned long init_loc, pc_range, end_loc;
> +	int err;
> +
> +	err =3D dwarf_cfi_parse_cie(cie_s, arch, &cie, &cie_row);
> +	if (err)
> +		return err;
> +
> +	if (likely(cie.fde_enc =3D=3D (DW_EH_PE_pcrel | DW_EH_PE_sdata4) &&
> +		   fde_s->pos + 8 <=3D fde_s->win_len)) {
> +		unsigned long faddr =3D cfi_stream_addr(fde_s);
> +		s32 rel =3D (s32)get_unaligned_le32(fde_s->buf + fde_s->pos);
> +		u32 rng =3D get_unaligned_le32(fde_s->buf + fde_s->pos + 4);
> +
> +		fde_s->pos +=3D 8;
> +		init_loc =3D faddr + (long)rel;
> +		if (arch->ws =3D=3D 4)
> +			init_loc =3D (u32)init_loc;
> +		pc_range =3D rng;
> +	} else {
> +		err =3D cfi_read_encoded_ptr(fde_s, cie.fde_enc, arch->ws,
> +					   /*datarel_base=3D*/0, &init_loc);
> +		if (err)
> +			return err;
> +		err =3D cfi_read_encoded_ptr(fde_s, cie.fde_enc & DW_EH_PE_FORM,
> +					   arch->ws, /*datarel_base=3D*/0,
> +					   &pc_range);
> +		if (err)
> +			return err;
> +	}
> +
> +	if (!pc_range || check_add_overflow(init_loc, pc_range, &end_loc))
> +		return -EINVAL;
> +	if (pc < init_loc || pc >=3D end_loc)
> +		return -ENOENT;

[Severity: Medium]
Can a negative FDE range in the slow path sign-extend into pc_range and
bypass the end_loc overflow check?

cie.fde_enc & DW_EH_PE_FORM preserves the signed encoding bit (0x08), so
unlike the fast path above (which reads rng as u32), cfi_read_encoded_ptr()
sign-extends negative sdata2, sdata4, sdata8, or sleb128 values to s64
before casting to unsigned long.  When the decoded value is negative with a
magnitude greater than init_loc (for example, init_loc =3D 0x400000 and a
range of -0x500000), init_loc + pc_range does not wrap unsigned long and
sets end_loc near ULONG_MAX, causing the FDE to match any pc >=3D init_loc.

[ ... ]

> +struct mod_dwarf_cfi_index *dwarf_cfi_mod_alloc(const void *eh_frame,
> +						size_t eh_frame_size,
> +						const struct dwarf_cfi_arch *arch)
> +{
> +	struct mod_dwarf_cfi_index *idx;
> +	unsigned int num_fdes =3D 0;
> +	unsigned long base;
> +
> +	if (!eh_frame || !eh_frame_size)
> +		return NULL;
> +
> +	base =3D (unsigned long)eh_frame;
> +	if (dwarf_cfi_scan_eh_frame_kmem(eh_frame, eh_frame_size, arch, base,
> +					 /*entries=3D*/NULL, /*max_entries=3D*/0,
> +					 &num_fdes) || !num_fdes)
> +		return NULL;
> +
> +	idx =3D kmalloc(struct_size(idx, entries, num_fdes), GFP_KERNEL);
> +	if (!idx)
> +		return NULL;
> +
> +	idx->num_fdes =3D num_fdes;
> +	idx->eh_frame =3D eh_frame;
> +	idx->eh_frame_size =3D eh_frame_size;
> +
> +	if (dwarf_cfi_scan_eh_frame_kmem(eh_frame, eh_frame_size, arch, base,
> +					 idx->entries, num_fdes, &num_fdes)) {
> +		kfree(idx);
> +		return NULL;
> +	}

[Severity: Medium]
Should dwarf_cfi_mod_alloc() use kvmalloc() and kvfree() instead of
kmalloc() and kfree()?

Each function in a module produces an 8-byte eh_frame_hdr_entry, so any
module with more than ~4,093 functions requires an allocation above
PAGE_ALLOC_COSTLY_ORDER (32 KiB on 4 KiB page systems), and large modules
such as amdgpu or i915 can need 64 KiB to 256+ KiB of physically contiguous
memory, risking compaction stalls or allocation failure under fragmentation.
dwarf_cfi_mod_free_rcu() already frees idx with kfree_rcu_mightsleep(),
which handles vmalloc pointers.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122235757.3456=
048-1-irogers@google.com?part=3D1
