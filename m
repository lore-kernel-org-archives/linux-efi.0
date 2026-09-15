Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD2D3F4DD0;
	Tue, 15 Sep 2026 13:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478664; cv=none; b=czmz/Ui3E1tGhxdbbEOK6tCdkYNJV7UtlBRmOwOFCKzvDVNZOhwnmXOxvak+123lYq1mFk/1q/nc5ezSPgzHDIZgLtM10KxPTmBmbVsSfVUdjuy0vYjtpywtaC+6jcjwWa94j9HW2Mq8hTxUG00W+hf7ipzWF6e1925adRsKdjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478664; c=relaxed/simple;
	bh=fazyMcUIBCQ1kA4F+gSzM2y6PVWHCTuOmgI9z2/zr+c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XxN18WfTyE6lvKEpsCYrnUlbdj9MaTrW2uxsg9+PNE6qd7VjvjJ2DaBAIL1uCiEoklE4pSkqte4bvj6QnYDR+0RT0ycjqM25Euq+z4uJvMKUgitXY2T31hKXCsDVn3/ZOe4bi2P0dffWmRFeDtMmEQQYIBsAS3KGrALnWW6vXP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clJ0vaxp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clJ0vaxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5371F00899;
	Tue, 15 Sep 2026 13:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789478662;
	bh=kk0XHrASJtDcqcoYjyv1OoIDFhfagge458V6XsyOmPk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=clJ0vaxp3sZXKwdBpf8y7D4hViqM4nFJmYSCrnv83plK3mCCe1Vo5znC49uX5JNHp
	 6wrATjKzdnxnx3VpdI1iP7I6QMX7RQAwtLdtLnna1m+FdWYHgCtbX4LUcMSkd5rKqM
	 vku4yNaOwmyZlw88cwMp1mr/E5vrxzrwO6eqRPMKYdn976UFdvVX7nvi8OB3baQ9Re
	 9ovAl0QjkuXwklvSyFLaHZdl/yNn6+scd83y/4dwu22IQuhTLRWuPGPOPyQKH4CV5d
	 iJzdHcs7SQMO+Jwp3IPkfx1iVIY2Z5TlFHKYC20wxoA75OJUkwf5p786a7f7mYPXnh
	 5HlyU+wH7Cf9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 4/9] mm/memory-failure: efi: adopt the inherited
 poisoned-memory table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Breno Leitao" <leitao@debian.org>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Oscar Salvador" <osalvador@suse.de>, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, hannes@cmpxchg.or, "Ard
 Biesheuvel" <ardb@kernel.org>, shakeel.butt@linux.dev, "Borislav Petkov" <bp@alien8.de>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Thomas Gleixner" <tglx@kernel.org>, x86@kernel.org, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "H. Peter Anvin" <hpa@zytor.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Lorenzo Stoakes" <ljs@kernel.org>, kas@kernel.org, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Danilo Krummrich" <dakr@kernel.org>
Cc: linux-mm@kvack.org, linux-efi@vger.kernel.org, rmikey@meta.com, harry@kernel.org, riel@surriel.com, driver-core@lists.linux.dev, kernel-team@meta.com, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
In-Reply-To: <20260915-hwpoison-kho-v5-4-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-4-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:24:19 +0000
Message-Id: <20260915132420.7A5371F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] efi: ABI incompatibility in poisoned-memory table due to unsigned =
long
- [High] efi: ABI incompatibility in poisoned-memory table due to PAGE_SIZE=
 check
--

commit 213ea31d156bf79dbf85ad9fc8678fe09bddbde2
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: efi: adopt the inherited poisoned-memory table

This commit takes the inherited EFI poisoned-memory table into use by parsi=
ng
it in efi_config_parse_tables(). It validates the table header and hands its
pages to memblock so everything afterwards can reach it with phys_to_virt().

> diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
> new file mode 100644
> index 0000000000000..3f12db3dc9b84
> --- /dev/null
> +++ b/drivers/firmware/efi/poison.c
> @@ -0,0 +1,93 @@
[ ... ]
> +static bool __init
> +efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
> +{
> +	u64 nbits, end;
> +
> +	/* Whole words, and a bit count that can be taken without wrapping. */
> +	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
> +	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
> +		return false;

[Severity: High]
Does this validation logic break binary compatibility across different kern=
el
bitnesses by relying on unsigned long?

The ABI structure definition for linux_efi_poisoned_memory uses a
variable-width type for the bitmap (unsigned long bitmap[]) rather than a
fixed-width type like u64. If a 32-bit kernel (or 32-bit EFI environment)
creates the table with a size that is a multiple of 4 (but not 8) and
passes it via kexec to a 64-bit kernel, this validation will fail since
sizeof(unsigned long) is 8.

The 64-bit consumer kernel will reject the valid poisoned-memory table,
losing hardware memory poison information. Accessing the unpoisoned memory
subsequently triggers a Machine Check Exception (MCE), crashing the system.

> +
> +	/* And a footprint that can be page aligned without wrapping either. */
> +	if (check_add_overflow(efi.poisoned_memory, sizeof(*pm) + pm->size,
> +			       &end) || end > PHYS_ADDR_MAX - PAGE_SIZE)
> +		return false;
> +
> +	if (pm->unit_size < PAGE_SIZE || !is_power_of_2(pm->unit_size))
> +		return false;

[Severity: High]
Can this logic break kexec chains by tying the acceptance of an external ABI
table to the consumer's local compile-time PAGE_SIZE?

If a kernel configured with a smaller PAGE_SIZE (e.g., 4KB) sets
pm->unit_size to 4096 and kexecs into a kernel configured with a larger
PAGE_SIZE (e.g., 64KB), the new kernel evaluates 4096 < 65536 and entirely
rejects the table.

Discarding all hardware memory poison records can result in MCEs and system
crashes when the supposedly good memory is allocated and accessed. Should
the consumer instead accept the table and safely round up poisoned ranges to
its native page granularity?

> +
> +	return IS_ALIGNED(pm->phys_base, pm->unit_size);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D4
