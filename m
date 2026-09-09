Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88F555D87B;
	Wed,  9 Sep 2026 13:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959959; cv=none; b=uD8ejriNOV9JOmviMaOx8azQEMvIdQ0KmrkQdtN22MrB7+z7eGveJugfstzdGpkH5oOy2iVDBIE8MLLt0FncVgA6uz+P4Qsdbp8H2ZEq+1EgzuIDRVAvYrbq6nKzMqN/5C0hgMznJ1sMX47K+yNjU/Z6fbv55lFe13GLnOuPyO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959959; c=relaxed/simple;
	bh=D+0JTv0vjj7jVq9/XgjezPU8HO5CeV6B7pgjm/VaupU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=M3XZpIYxjgJepFKg1nxSMsY3sZGmQQ8+SjdIx8AWsvyrhXWbj86DcSNg3DivR/i+O1MSVY0TaRiE0RqN7qFvLO3qxHPsdc7kE10TdJQ9Smm+WGLK+3aLY1Ccl1AlaRp/YqEaijwQTB6J6RNvU4XDImTLHDpGDrE2vQa1of0lcOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jifU7nYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jifU7nYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D361F00A3A;
	Wed,  9 Sep 2026 13:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959953;
	bh=VF44nhzHiC16881Gb5iN9h+Bgx6pDfvd8nvJKSSNfOA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jifU7nYaAmhEue3ZYS6hL0mgYz8TAE2Dz8MLMyM0RGevIig9ehKh8qykWRHAfYsiA
	 z1r8vfttWhtJrvznAsmQdAhsI/5V6KgHMyMbZ/wH2+uJ2FV0zXLba5O84c8wX2KyOO
	 Q7Y3zuCqdn+GB6I4hS8XN9KVqJgl7OnRW79NXrj2KrVp4RyTXQ6ceX9oCDWI52ZRyt
	 HhNRMTB96EMZ47gBlPlLYwLjBDhkZTbdV5P4lhJsbs6/6bxgnjoFay7J0A1QF71p1D
	 Sb7KNx7hgZzzTIj/pbNoW+dmFMMwYtT6Bn3s5MjKIaX6Szh+RRcbCsIuBuHJbes2yo
	 FFL2fdsv3bxnw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hildenbrand" <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Breno Leitao" <leitao@debian.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Ingo Molnar" <mingo@redhat.com>, "Zi
 Yan" <ziy@nvidia.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Borislav Petkov" <bp@alien8.de>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "H. Peter Anvin" <hpa@zytor.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb@kernel.org>, kas@kernel.org, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Liam R. Howlett" <liam@infradead.org>, x86@kernel.org, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>
Cc: harry@kernel.org, linux-efi@vger.kernel.org, riel@surriel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org, rmikey@meta.com, kernel-team@meta.com
In-Reply-To: <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:19:11 +0000
Message-Id: <20260909131911.76D361F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] Integer truncation in efi_poison_alloc leads to a massive heap=
 buffer overflow during memset on 32-bit or mixed-mode systems.
--

commit 626632820fe1fdcddc73aaeb109705cbddc9828c
Author: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: libstub: install the poisoned-memory EFI table

This patch introduces functionality in the EFI stub to create and install a
poisoned-memory EFI configuration table. It walks the UEFI memory map to fi=
nd
the RAM range and allocates a bitmap to track poisoned memory granules.

> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/fir=
mware/efi/libstub/efi-stub-helper.c
> index 48f93f7758e9e..5cbe675491333 100644
> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
[ ... ]
> +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> +							  u64 bitmap_size)
> +{
> +	struct linux_efi_poisoned_memory *pm;
> +	efi_status_t status;
> +
> +	status =3D efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> +			     sizeof(*pm) + bitmap_size, (void **)&pm);

[Severity: Critical]
Could sizeof(*pm) + bitmap_size overflow 32 bits on 32-bit or mixed-mode
systems? If the EFI memory map describes a very large physical address space
(such as a 32PB physical address provided by an untrusted hypervisor in a
TDX/SEV environment), bitmap_size could approach 4GB.

Because the size argument to allocate_pool is a UINTN, a value like
0x100000008 (sizeof(*pm) + 0xFFFFFFF0) would truncate to 8 bytes on 32-bit
EFI systems, resulting in an undersized allocation.

> +	if (status !=3D EFI_SUCCESS)
> +		return NULL;
> +
> +	pm->version =3D 1;
> +	pm->unit_size =3D EFI_POISON_UNIT_SIZE;
> +	pm->phys_base =3D phys_base;
> +	pm->size =3D bitmap_size;
> +	memset(pm->bitmap, 0, bitmap_size);

[Severity: Critical]
If the allocate_pool calculation overflowed and truncated as described abov=
e,
does this memset trigger an out-of-bounds write regression?

Since bitmap_size (e.g., 0xFFFFFFF0) fits within a 32-bit size_t, memset
will use the large untruncated size, potentially overwriting up to 4GB of E=
FI
boot services memory following the undersized allocation.

> +
> +	return pm;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D2
