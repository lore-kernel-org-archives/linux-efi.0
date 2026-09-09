Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502BA3F99F4;
	Wed,  9 Sep 2026 13:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788959842; cv=none; b=UfUZY7kaa11GpmJCL6sykuTUOB1qB+tR96SrB3eAZu2p6NKBCD6+4ljLYOLrV+3pzo3GGAT+NBpr9+qJzqbrUEwgBFptSN3eHIdHyJdkeXc3Sh1mnLea492L+frnflTZppyUepQb2JBuYGa9THBTZFwEm50l8JvGpb7cBSbZfNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788959842; c=relaxed/simple;
	bh=EIbO75JF037OWKe98YoWMshKxdBcHYagioMlkRoNDjQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u0g3VPLyPNl7E6m8pBuIZkgJhF22U/WlKF20J0oRAEF/6PmgkKj7niTFd3CKGSPNFPzNf8whse7z6Nr9FnxuREzjiEcMObSvFEmEzr1FjAiuDuDhFpecmFFg3cBq9GDPFB8k4kcbiogZkY37cKHFRXjrMScEC1z4s40dR+skC6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R3LmLYbg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R3LmLYbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1F01F00A3A;
	Wed,  9 Sep 2026 13:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788959840;
	bh=bEJmZIALLcjQXIB+g3fXQRl6DWuBiippwKn6sn+DjEU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R3LmLYbgntYK+I4UH4uaxCnCYpQyqZDM2PKlOOWsUfSoMifDN2Xn9LoMlaHh2l+Xn
	 CI4hf7aXtDaTdIs12+sG0yKD00WsPfl11cqaXLv4DoWFow+Wz/n8ybKaLvLXMfHgHL
	 /tnzmxAmYi4c+8FHMgbNhwF1Php8YRjwVCh+IOp72LY3QyAnTG9OEQOMhudzopLfES
	 vWoR0svfqF6zkAUEhH4hCx6zp/tOiAq/wpuyXfghP7qhI/xJZmPhJVm751wxtY7E83
	 8/4XUtkwIB42i1cCOjlyIBM3Lxa5Nc/V5CXWYi/703OAiVam5yVYcdM6w11KL0nZmW
	 BIBg6RLrYfjhA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/5] mm/memory-failure: efi: answer whether a range
 is poisoned
Reply-To: sashiko-reviews@lists.linux.dev
To: "H. Peter Anvin" <hpa@zytor.com>, "Borislav Petkov" <bp@alien8.de>, "Michal
 Hocko" <mhocko@suse.com>, "Zi Yan" <ziy@nvidia.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Breno
 Leitao" <leitao@debian.org>, "David Hildenbrand" <david@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Liam R. Howlett" <liam@infradead.org>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Mike
 Rapoport" <rppt@kernel.org>, x86@kernel.org, "Dave Hansen" <dave.hansen@linux.intel.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Johannes Weiner" <hannes@cmpxchg.org>, kas@kernel.org
Cc: linux-kernel@vger.kernel.org, rmikey@meta.com, harry@kernel.org, linux-mm@kvack.org, kernel-team@meta.com, riel@surriel.com, kexec@lists.infradead.org, linux-efi@vger.kernel.org
In-Reply-To: <20260909-hwpoison-kho-v4-4-359313564495@debian.org>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-4-359313564495@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 13:17:18 +0000
Message-Id: <20260909131719.5E1F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Adjusting `start` without proportionally shrinking `size` shifts t=
he checked memory range out of bounds, causing false positive poison detect=
ion.
--

commit b492314fda14ef47eff8ff738b90a4749a490163
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: answer whether a range is poisoned

This commit introduces range_contains_poisoned_memory() which allows the
page allocator to query whether a memory block overlaps with regions
recorded as poisoned by an earlier kernel via EFI.

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> index c18edf111c710..e16d43f4438ee 100644
> --- a/drivers/firmware/efi/poison.c
> +++ b/drivers/firmware/efi/poison.c
[ ... ]
> +/* Does the range cover a unit an earlier kernel recorded as bad? */
> +bool range_contains_poisoned_memory(phys_addr_t start, unsigned long siz=
e)
> +{
> +	struct linux_efi_poisoned_memory *pm =3D efi_poisoned_memory();
> +	u64 first, last, nbits;
> +
> +	if (!pm)
> +		return false;
> +
> +	nbits =3D pm->size * BITS_PER_BYTE;
> +
> +	if (start + size <=3D pm->phys_base)
> +		return false;
> +	if (start < pm->phys_base)
> +		start =3D pm->phys_base;
> +
> +	first =3D (start - pm->phys_base) / pm->unit_size;
> +	if (first >=3D nbits)
> +		return false;
> +
> +	last =3D (start + size - 1 - pm->phys_base) / pm->unit_size;

[Severity: High]
When start is clamped to pm->phys_base earlier in this function, size is
not proportionally decreased. Does this result in an end boundary calculati=
on
that exceeds the originally requested range?

If the allocator queries a block that starts before the EFI poisoned memory
table (start < pm->phys_base) but extends into it, the unadjusted size added
to the newly shifted start will push the last bit beyond the intended regio=
n.=20
Could this out-of-bounds query cause false positive poison detections for
healthy memory that resides just after the requested block?

> +	last =3D min(last, nbits - 1);
> +
> +	return find_next_bit(pm->bitmap, last + 1, first) <=3D last;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260909-hwpoison-k=
ho-v4-0-359313564495@debian.org?part=3D4
