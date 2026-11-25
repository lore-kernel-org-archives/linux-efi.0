Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588852;
	b=UkcEg4SQBEelmlbGBd893ccRT5v2/D4LZ/UinGZ5VYD0v90egjuFuKZwkzwTaIQ+Yjgr
	 NHwCpydetUkj6aikVfGZ+1MzPWCfNsSAm8ykIaT+G4VnV0m6kidbKdcPtdZv0WwqISkWS
	 IAF4HFuLDzCSSEwXGuDuPv0U1XsSN37fyiyyUcn8H/7E+TugBu+fUyEPG7DwjGs/coMHo
	 G7U9Px/VCMctm74jlMk9fXF5H4oo3jgXgn5yiKKzeth81T25Srmm/ttptAGCdVEyRV9bP
	 g3b5oLS0G2euwFYIDftIN1Nxp+AzviC5812VJ1Zbpk2WF9+kZPDwGpEn+8Zd/qQbCGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588852;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=5wHiCqQ5RJKdTEaymXEWQCXKotqpwnEC2TLXNJY03WQ=;
	b=laQVQXAMGdU585rAel2+ey6DhePwzqF1X55uXhsuhGdFhjFFp5pwjLFNtdTOWEo6pQhe
	 VgWcWxxEa6jmC4uhVBIjQAyxCrEeEi9d34iprhcc8K/ejZxqfXXVqtRvIcXoAF03c4qpY
	 lsqPJ3+k1TeY6jQ7ZGNdoxTQKHzAJAhsi0KcbXMBgDfRDvbP++s63h+p9q8qTSF6sWigA
	 /1taifLsUBAP4VhFCS7lyGqM0cK2OLH12eichauLSgV4q4GnAVFAVQ6JAwG7nHAPAxwLA
	 zmfrMLNEcckqXHLaKiVODKnWPp9zyb6rrYduJ+4nuMUMxbBqe79qDJ6ZmjHcOfBJ2Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ClgA2X/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEDD606A31E;
	Wed, 25 Nov 2026 06:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ClgA2X/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A561F000C4;
	Wed, 25 Nov 2026 06:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795588851;
	bh=5wHiCqQ5RJKdTEaymXEWQCXKotqpwnEC2TLXNJY03WQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ClgA2X/ckiuiaB40ZujYlDOSDtxO7AmDlxj1QmTRr8vMUqxQSpSUHg8DXfUYRW8JF
	 vxHWkEOuHyNClT22VRPe6l92TWfenahT3FLQqbBtU6pLZKBc4msFym+smmvDlVTLIK
	 Fewot6TbFl6fpFFwX1UQuxbXkNYBd6XbXKPvQmZY0ydDxDQki/2CjNXbzFOwrjJyT2
	 I7gp+c6v8umeWrf/yaEUfBvzXf4Sg3D23Qm2fMNNCUneskiNEPINBsqzFGwa24JWMp
	 JbT1DsUiHG0BCNNOz99C6Pd+W1fQUFFhCfJKRI9z35RyGXPH0WfVstyTlql0PUalpQ
	 bo7rPM8vTEnFg==
Message-ID: <sashiko-outbox-232724@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 29/30] tools/unwind: Add x86-64 ORC cross-check
 oracle to verify_cfi
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261125061523.1540234-30-irogers@google.com>
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-30-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:40:49 +0000
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
- [Low] tools/unwind: missing ORC_TYPE_UNDEFINED tie-break in
  verifyOracle3Orc()
--

commit 21fa29da140895241f891570070d39da3828738f
Author: Ian Rogers <irogers@google.com>

tools/unwind: Add x86-64 ORC cross-check oracle to verify_cfi

This commit adds verifyOracle3Orc() to tools/unwind/verify_orc.cpp to
cross-check x86-64 ORC_TYPE_CALL entries against Minimal DWARF CFI across
every instruction covered by an FDE.

> diff --git a/tools/unwind/verify_orc.cpp b/tools/unwind/verify_orc.cpp
> new file mode 100644
> index 0000000000000..629849f3187ec
> --- /dev/null
> +++ b/tools/unwind/verify_orc.cpp
> @@ -0,0 +1,205 @@

[ ... ]

> +void verifyOracle3Orc(const ArchSpec &AS, uint64_t eh_hdr_vma,
> +		      StringRef eh_hdr_bytes, StringRef orc_bytes,
> +		      StringRef orc_ip_bytes, uint64_t orc_ip_vma,
> +		      const std::vector<ExecSec> &exec_secs,
> +		      const std::vector<FuncSym> &func_syms,
> +		      const MCDisassembler &Disasm, const MCSubtargetInfo &STI,
> +		      MCInstPrinter &InstPrinter, const VerifyOptions &opts,
> +		      VerifyStats &st)
> +{
> +	st.has_orc =3D true;
> +	constexpr size_t kOrcEntSz =3D 6;
> +	size_t n_orc =3D orc_bytes.size() / kOrcEntSz;
> +	size_t n_ip =3D orc_ip_bytes.size() / 4;
> +	size_t n =3D std::min(n_orc, n_ip);
> +	const uint8_t *orc_raw =3D
> +		reinterpret_cast<const uint8_t *>(orc_bytes.data());
> +	const uint8_t *ip_raw =3D
> +		reinterpret_cast<const uint8_t *>(orc_ip_bytes.data());
> +
> +	std::vector<std::pair<uint64_t, size_t>> sorted_orc;
> +	sorted_orc.reserve(n);
> +	for (size_t i =3D 0; i < n; i++) {
> +		int32_t rel =3D (int32_t)support::endian::read32le(ip_raw + i * 4);
> +		uint64_t epc =3D orc_ip_vma + i * 4 + (uint64_t)(int64_t)rel;
> +		sorted_orc.push_back({epc, i});
> +	}
> +	std::stable_sort(sorted_orc.begin(), sorted_orc.end(),
> +			 [](const auto &a, const auto &b) {
> +				 return a.first < b.first;
> +			 });
> +
> +	auto lookupOrcIdx =3D [&](uint64_t pc, size_t &idx_out) -> bool {
> +		auto it =3D std::upper_bound(
> +			sorted_orc.begin(), sorted_orc.end(), pc,
> +			[](uint64_t val, const std::pair<uint64_t, size_t> &e) {
> +				return val < e.first;
> +			});
> +		if (it =3D=3D sorted_orc.begin())
> +			return false;
> +		--it;
> +		idx_out =3D it->second;
> +		return true;
> +	};

[Severity: Low]
Can lookupOrcIdx() return an ORC_TYPE_UNDEFINED section-terminator entry
instead of the real ORC_TYPE_CALL entry at contiguous text section
boundaries?

objtool appends an ORC_TYPE_UNDEFINED terminator at the end address of
each non-empty text section.  When an unsorted .orc_unwind table is used
(such as a vmlinux built with CONFIG_UNWINDER_DWARF_CFI=3Dy where
scripts/sorttable does not sort the ORC table) and a lower-VMA text
section appears after an adjacent higher-VMA text section in ELF section
order, sorting only by epc leaves the terminator after the next section's
first entry at the same address.  Because lookupOrcIdx() picks the
rightmost entry with epc <=3D pc, it selects the ORC_TYPE_UNDEFINED entry
and verifyOracle3Orc() silently skips verifying the boundary instructions.

In arch/x86/kernel/unwind_orc.c and scripts/sorttable.c, orc_sort_cmp()
breaks ties at equal addresses by ordering ORC_TYPE_UNDEFINED entries
before real entries.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061523.1540=
234-1-irogers@google.com?part=3D29
