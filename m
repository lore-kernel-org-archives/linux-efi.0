Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795588634;
	b=I5TVFQUYGv1LEF0JKiBcD+D7qAeVqo9bv3+EYh1oYhhiTCwEbu9bryFu6AezYpgvleTJ
	 C8GhJYXKYNwM4d7CVJMBHfP68K2f6iy2nDuViSRyyjSW8tRiH3NkG5cDAeCTfNdz1Biye
	 gdIht0rZTowgK4XpI3yfsc+/Wn37sV87CJqyZoVRf85uUrp3oai2urWZ0D5JfRHECbqLm
	 3HvAAq0JR7SAjmenZiO9XHXAFopyGXAOTZ30IZP1lE6UHM8cvUpAfnloNX/U033aWijd9
	 1z4OgqeJfwVsMkUoYrofcRFvH4Yigro8hOIgnRiNRn5m9oe8LS5Fz/No+IHo+tAj+Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795588634;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RszRfCKfbcgcbLkX4hDIS/N4LcUZfX68oWST1IeO/EU=;
	b=3/phIeEpHSwFl2byFCPrQRqnQEXa/KRVT2wmNRrLXP22uCTvQHboTWHcin7sizcgBs8f
	 cmk8nbM7EynWkTL+MAE6bnh4aFVCtlI976EgA8ntdPQhQM4pGs6hzsgk3pkdqNt9OVsdT
	 P/CP6pwI3u3TvMZNBunYoXDC1C4mDXfV+7no1JtL4u8nwzZQbye/1J8E7a9HDTERUSJF4
	 8oAjWE5tP4LysGtq5dfc40we8K8ozICxYtmOfTs2IfvFEBPrJkgvRJdoe5nAuVIpPpfFJ
	 icm/F+4fgdeSYg00b8WPUfDjEKJE2lfeRrJT6dfS1je6RrR4H49L014Yrhbl7xaqseg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nibebcfs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8514E606A31E;
	Wed, 25 Nov 2026 06:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nibebcfs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B211F000D0;
	Wed, 25 Nov 2026 06:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795588634;
	bh=RszRfCKfbcgcbLkX4hDIS/N4LcUZfX68oWST1IeO/EU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nibebcfsU9mj8cSUzsxuTfZ9vOxoWLO3oET56dfD2Y7MfogwFR89AkVQMhRpQg9Jt
	 vWQ3sz5AzLFKLMMMRuz2HxjMvvXR9q/uEuHApp4+pCN/bE4bS7DSU64GD7VBpgjcSZ
	 VclnJDdLZq51vZ1Hi2HreXdqr/+FSglVL+H5cSDzoFB7CunHviXlCsu2v5p7i8JN4U
	 XhoR7z3G94TKFFNF+HbtnftZD/18xrVcrOXYuj04Yl08H+HfPVoMqRt8TfOjGuvEoM
	 VIM8/nus6WVMG6qNtyHMynSjsviOxGptUUYyAdF4YbBaM01R0NGNBFwvqOstqMPWL6
	 KrRrLw8mVs8og==
Message-ID: <sashiko-outbox-232718@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 26/30] tools/unwind: Add standalone libLLVM
 Minimal DWARF CFI verifier
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ian Rogers" <irogers@google.com>, linux-trace-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, rostedt@goodmis.org, peterz@infradead.org, mingo@redhat.com, tglx@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, acme@kernel.org, namhyung@kernel.org, linux-perf-users@vger.kernel.org, mhiramat@kernel.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, bpf@vger.kernel.org, nathan@kernel.org, nsc@kernel.org, linux-kbuild@vger.kernel.org, ojeda@kernel.org, ardb@kernel.org, linux-efi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, shuah@kernel.org, indu.bhagat@oracle.com, jremus@linux.ibm.com, wnliu@google.com, dylanbhatch@google.com, gary@garyguo.net
In-Reply-To: <20261125061523.1540234-27-irogers@google.com>
References: <20261125061523.1540234-1-irogers@google.com>
 <20261125061523.1540234-27-irogers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 06:37:11 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] tools/unwind: missing host arch include path breaks build on
  RISC-V hosts
- [Low] tools/unwind: uint64_t overflow in verifyFile() kmem_arena
  bounds check
--

commit 8799e1737c7df626cec2cf3930d6a2c81661a407
Author: Ian Rogers <irogers@google.com>

tools/unwind: Add standalone libLLVM Minimal DWARF CFI verifier

This commit adds a standalone host tool (tools/unwind/verify_cfi) that links
against kernel/unwind/dwarf_cfi.c and compares its unwind results against
libLLVM's reference DWARFUnwindTable.

> diff --git a/tools/unwind/Makefile b/tools/unwind/Makefile
> new file mode 100644
> index 0000000000000..ca6b84dbd31a3
> --- /dev/null
> +++ b/tools/unwind/Makefile
> @@ -0,0 +1,123 @@

[ ... ]

> +TOOLS_INCLUDES :=3D -I$(srctree)/tools/include -I$(srctree)/tools/includ=
e/uapi \
> +		  -I$(srctree)/tools/arch/x86/include

[Severity: Medium]
Does hardcoding only tools/arch/x86/include in TOOLS_INCLUDES break the bui=
ld
on RISC-V hosts?

dwarf_cfi_host.c includes kernel/unwind/dwarf_cfi.c, which pulls in
tools/include/linux/nospec.h -> tools/include/asm/barrier.h ->
tools/arch/riscv/include/asm/barrier.h -> <asm/fence.h>.  Without
-I$(srctree)/tools/arch/$(HOSTARCH)/include (via ../scripts/Makefile.arch),
the compiler cannot find tools/arch/riscv/include/asm/fence.h when building
on riscv64.

> diff --git a/tools/unwind/verify_cfi.cpp b/tools/unwind/verify_cfi.cpp
> new file mode 100644
> index 0000000000000..15d99ba57ce35
> --- /dev/null
> +++ b/tools/unwind/verify_cfi.cpp
> @@ -0,0 +1,789 @@

[ ... ]

> +static int verifyFile(const char *path, const VerifyOptions &opts)
> +{

[ ... ]

> +	uint64_t min_eh_vma =3D std::min(eh_hdr_vma, eh_vma);
> +	uint64_t max_eh_end =3D std::max(eh_hdr_vma + eh_hdr_bytes.size(),
> +				       eh_vma + eh_bytes.size());
> +	std::vector<uint8_t> kmem_arena;
> +	bool can_test_kmem =3D
> +		(max_eh_end >=3D min_eh_vma) &&
> +		(max_eh_end - min_eh_vma) <=3D (64ULL * 1024 * 1024) &&
> +		isRelativeEhEncoding((uint8_t)eh_hdr_bytes[1]) &&
> +		isRelativeEhEncoding((uint8_t)eh_hdr_bytes[3]);
> +	const uint8_t *kmem_hdr =3D nullptr;
> +	const uint8_t *kmem_eh_start =3D nullptr;
> +	const uint8_t *kmem_eh_end =3D nullptr;
> +	if (can_test_kmem) {
> +		kmem_arena.assign(max_eh_end - min_eh_vma, 0);
> +		memcpy(kmem_arena.data() + (eh_hdr_vma - min_eh_vma),
> +		       eh_hdr_bytes.data(), eh_hdr_bytes.size());
> +		memcpy(kmem_arena.data() + (eh_vma - min_eh_vma),
> +		       eh_bytes.data(), eh_bytes.size());

[Severity: Low]
Can an integer overflow in the section end calculation bypass the kmem_arena
bounds check and write out of bounds?

In a malformed ELF file where one section end addition wraps around 64 bits
(for example eh_hdr_vma + eh_hdr_bytes.size()) while the other does not,
std::max() selects the un-wrapped end address.  max_eh_end >=3D min_eh_vma =
and
the 64 MiB limit can then both hold, leaving kmem_arena smaller than
(eh_hdr_vma - min_eh_vma) + eh_hdr_bytes.size() when memcpy() runs.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125061523.1540=
234-1-irogers@google.com?part=3D26
