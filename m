Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3D3552947;
	Wed,  9 Sep 2026 13:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788960091; cv=none; b=aHRIcdL0xs8errVbE6BLAxTOon/Uyn08YY/ylabK/kIyOqnkFt+RtjBKs6mX2k5DMC0MrGLn11cmG5UXajj6bv/rlbxWAOWSil7hJkilY4h9DKZzxAicMJvykKImDwYSQTQdan2qGP6JvF7bz8DdkC4b5vq5+jVLWy7Ddq/KPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788960091; c=relaxed/simple;
	bh=jL14stIA2rn68YKG4zCHQgGa1C9S4Qh+DLrH7ru852E=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iMO6kRLzfrWeLEMP27Wt8XepsADdAsYYVlY1Oe0zTE3CEkvNlcdB4fHDd2D9aDmDYII8tCtAcPU0xRKy7G0SjgQY/OJOSfT4aredxAbrVcCorJaGWKK9WBPVyEdJKvHbuJaB20pEptGAw21YQcnuUK/OjGLW2fEzzlwsXbhYdIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cSZMaNiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cSZMaNiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4D01F00A3A;
	Wed,  9 Sep 2026 13:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960090;
	bh=Et8Tc+zJYrlmS7IHYeOD4T4P7eMPWgKqQ5XzB6XXw7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cSZMaNiFDM/iBbEtipO42XrDHprhWxCTfMIycSPNBvU57qYx7auTLKBkEex9w0WQv
	 SKXEtl/3ZYJyMM9IfTMl9feHqT1bnBoVu9ONikLN8FktK7fjmOAnJKTIVbtELsgJuy
	 TPdXsRaftBDkIpm7qDvNYomLzyPH1TPmwnH1PGdM12W6ZhNR+5Fnw1iw4t+TnvdC3F
	 NMmn/RKfetqFCNdf3nAuvQU/PsWuHEapuyYy2BRPB4Udq6FMVRXMTrVzQguhktAZzL
	 9lgZzW2BlYbgPpL4s3q0ps1mvZVlFFCx7QgDQ1MPp6UegTTYvLhQPoclSHHsMP2THN
	 z1OtfDX0svuIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Michal Hocko" <mhocko@suse.com>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, kas@kernel.org, "Vlastimil
 Babka" <vbabka@kernel.org>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "David
 Hildenbrand" <david@kernel.org>, "Breno Leitao" <leitao@debian.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Borislav Petkov" <bp@alien8.de>, "Suren
 Baghdasaryan" <surenb@google.com>, "Ard Biesheuvel" <ardb@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Zi
 Yan" <ziy@nvidia.com>, "Thomas Gleixner" <tglx@kernel.org>
Cc: kernel-team@meta.com, rmikey@meta.com, harry@kernel.org, linux-efi@vger.kernel.org, riel@surriel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
In-Reply-To: <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:21:28 +0000
Message-Id: <20260909132128.AD4D01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Missing overflow check when computing the end address of the EFI p=
oisoned memory table can lead to an unbounded memblock reservation and memo=
ry corruption.
--

commit 7216d7e029930900ac5741a5f5bbfe7a2107b408
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: record hardware-poisoned frames into the poisoned-m=
emory table

This commit hooks action_result() to efi_hwpoison_record_pfn() to record ha=
rd
offlined frames in the LINUX_EFI_POISONED_MEMORY table, ensuring they are
passed down to the next kernel via kexec. It also adds early initialization
code to vet the table inherited from previous boots.

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> new file mode 100644
> index 0000000000000..c18edf111c710
> --- /dev/null
> +++ b/drivers/firmware/efi/poison.c
[ ... ]
> +static bool __init
> +efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
> +{
> +	u64 nbits;
> +
> +	/* Whole words, and a bit count that can be taken without wrapping. */
> +	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
> +	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
> +		return false;

[Severity: High]
Does this validation fully protect against an excessively large pm->size?

While check_mul_overflow() validates the size for bit conversion, it appears
it does not verify that the table's footprint fits within the physical addr=
ess
space without overflowing when combined with efi.poisoned_memory.

> +
> +	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
> +		return false;
> +
> +	return IS_ALIGNED(pm->phys_base, pm->unit_size);
> +}
[ ... ]
> +void __init efi_poisoned_memory_reserve(void)
> +{
> +	struct linux_efi_poisoned_memory *pm;
> +	phys_addr_t start, end;
> +
> +	if (efi.poisoned_memory =3D=3D EFI_INVALID_TABLE_ADDR)
> +		return;
> +
> +	pm =3D early_memremap(efi.poisoned_memory, sizeof(*pm));
> +	if (!pm) {
> +		pr_warn("Could not map poisoned-memory table\n");
> +		efi.poisoned_memory =3D EFI_INVALID_TABLE_ADDR;
> +		return;
> +	}
> +
> +	if (!efi_poison_table_valid(pm)) {
> +		efi.poisoned_memory =3D EFI_INVALID_TABLE_ADDR;
> +		early_memunmap(pm, sizeof(*pm));
> +		return;
> +	}
> +
> +	start =3D PAGE_ALIGN_DOWN(efi.poisoned_memory);
> +	end =3D PAGE_ALIGN(efi.poisoned_memory + sizeof(*pm) + pm->size);

[Severity: High]
Can this computation wrap around if pm->size is maliciously large?

Because pm->size is only constrained to be less than U64_MAX / 8 in
efi_poison_geometry_valid(), an unvalidated addition here could overflow,
resulting in end < start. If that happens, an enormous end - start would
be passed to memblock_add() and memblock_reserve().

This could result in memblock capping the size to PHYS_ADDR_MAX - start,
blindly marking the rest of the physical address space (including MMIO) as
RAM. This forces direct-map cacheable page table entries for MMIO regions,
leading to system crashes or memory layout corruption.

> +	early_memunmap(pm, sizeof(*pm));
> +
> +	memblock_add(start, end - start);
> +	memblock_reserve(start, end - start);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D3
