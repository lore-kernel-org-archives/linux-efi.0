Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794656032;
	b=wDf7s/TZmPyc/8UwXbc7QLBodXG7VB0p3WcJt1H2Xr9/lKTizsEkYBxWkakPNqkweTUp
	 dHwmhFUc5czx1NRaoYEE6r6t+DUbBDRhsqVZrh+e8jmHOxsDJ3K5qkbDUw6oO3f2In19m
	 FbryNhSovteGBLuwStVWGc63NWNYST1KQ/f7fqtJjUH9aLxVNqvTOb7ft0NO2dasHPW1y
	 wWldcW+b2Hgcl7wNqyLMi6P3mPhxLsPaUXCSuM9Ki2HgE5YbnGLylRGHKDVZkxxoVexJo
	 W83rDCjfDFNyRvbJ0I+TatwZIAuxA59g/hiU64Er2yNQykzkePm78V4sKIEtjcLDagw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794656032;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=JOohzSTuBgrSfk0jf37SnktRbQ4WRgnCUv6nrKxrSi4=;
	b=ID5dx85czbyCqb52YH1VkmF5FiZLQJ8OJpC7u0NMKFtrvnz9eoxgK1+Jom+V+gTEeKv4
	 zsmbFAcjiuQm+E+vK5RQx0Ygb41oEITRBYLSX0ATyJJ/fwLTYgQleTEn/BUaPNuKrjHt7
	 3feXetpO87vKzb7Qz4fM6FKsYeR3SaOluDhD0sRzGZppYxnDgJCmO8CIR9d7zOC0kgLxy
	 6eYT816JHxI5CyDsKZnaz565CWgupEvflStvGyZgEbpFoCbJv9wvzqqq4hcf8MNzZ+CCh
	 73jyujY2/kg7w9zz1InxmN5OyJ+u/6a/nNSVvIVpgLumF+Ng4QTQxYMg5NSDoocEQXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SqVkgSqH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0C4606A327
	for <linux-efi@vger.kernel.org>; Sat, 14 Nov 2026 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SqVkgSqH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51111F000CF;
	Sat, 14 Nov 2026 11:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794656032;
	bh=JOohzSTuBgrSfk0jf37SnktRbQ4WRgnCUv6nrKxrSi4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SqVkgSqHCr+86lKgqZHxDXqljji8NEnM9TBsv95upQudlE4cf/gCMtfwBdiQSe9lG
	 GAaQgDdsrQjHcVQjQk57Z7CrTKCTI0m9y92zJMhiRkkpzKj8jzFIBdyYPbIIfQh06/
	 Z4k7rpfD/0joKsbQgWG+88j+ydNSyEcu1NbGGg8mBdzYS5WJhu5e0KYkvjXhfqSoDS
	 Z+cYoLk8jMH8nbD5QYmyo6d6i7WwGiZaEWuhtBc6k53EGcEn3it3yyHxPzu8i7dqBc
	 oD0krgmQBSRNmM72Tne0gRBNi2K/gxAPlHQMPgB/NwmaTi6dw4BU30WIGVOreYxlAO
	 z9cu0itUO3O9A==
Message-ID: <sashiko-outbox-214406@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] x86/unaccepted_memory: Do not accept ranges that are
 no longer E820 RAM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pankaj Gupta" <pankaj.gupta@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: "H . Peter Anvin" <hpa@zytor.com>, "Tom Lendacky" <thomas.lendacky@amd.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Kiryl Shutsemau" <kas@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Mike Rapoport" <rppt@kernel.org>, linux-mm@kvack.org, linux-efi@vger.kernel.org, Pankaj.gupta.linux@gmail.com
In-Reply-To: <20261113105554.199912-1-pankaj.gupta@amd.com>
References: <20261113105554.199912-1-pankaj.gupta@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 11:33:51 +0000
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
- [Medium] x86/unaccepted_memory: uncleared hole bits in
  arch_clear_accepted()
- [Medium] x86/unaccepted_memory: outward unit rounding in
  arch_clear_accepted()
--

commit ddcd20a91b6aa10c63b863069cf031e61f95c5fc
Author: Pankaj Gupta <pankaj.gupta@amd.com>

x86/unaccepted_memory: Do not accept ranges that are no longer E820 RAM

This commit restricts x86 memory acceptance to page-aligned E820_TYPE_RAM
ranges and updates accept_memory() to clear bitmap bits via
arch_clear_accepted() only for ranges that were accepted.

> diff --git a/arch/x86/include/asm/unaccepted_memory.h b/arch/x86/include/=
asm/unaccepted_memory.h
> index f5937e9866ac1..9e27a9953dd83 100644
> --- a/arch/x86/include/asm/unaccepted_memory.h
> +++ b/arch/x86/include/asm/unaccepted_memory.h
> @@ -2,10 +2,11 @@
>  #define _ASM_X86_UNACCEPTED_MEMORY_H
> =20
>  #include <linux/efi.h>
> +#include <asm/e820/api.h>
>  #include <asm/tdx.h>
>  #include <asm/sev.h>
> =20
> -static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
> +static inline void __arch_accept_memory(phys_addr_t start, phys_addr_t e=
nd)
>  {
>  	/* Platform-specific memory-acceptance call goes here */
>  	if (cpu_feature_enabled(X86_FEATURE_TDX_GUEST)) {
> @@ -18,6 +19,47 @@ static inline void arch_accept_memory(phys_addr_t star=
t, phys_addr_t end)
>  	}
>  }
> =20
> +static inline bool e820_ram_pages(struct e820_entry *entry, phys_addr_t =
start,
> +				  phys_addr_t end, phys_addr_t *s, phys_addr_t *e)
> +{
> +	if (entry->type !=3D E820_TYPE_RAM)
> +		return false;
> +
> +	*s =3D PAGE_ALIGN(max_t(phys_addr_t, start, entry->addr));
> +	*e =3D PAGE_ALIGN_DOWN(min_t(phys_addr_t, end, entry->addr + entry->siz=
e));
> +	return *s < *e;
> +}
> +
> +static inline void arch_accept_memory(phys_addr_t start, phys_addr_t end)
> +{
> +	phys_addr_t s, e;
> +	u32 i;
> +
> +	for (i =3D 0; i < e820_table->nr_entries; i++) {
> +		if (e820_ram_pages(&e820_table->entries[i], start, end, &s, &e))
> +			__arch_accept_memory(s, e);
> +	}
> +}
> +
> +static inline void arch_clear_accepted(unsigned long *bitmap, phys_addr_=
t base,
> +				       unsigned long unit_size,
> +				       phys_addr_t start, phys_addr_t end)
> +{
> +	phys_addr_t s, e;
> +	u32 i;
> +
> +	for (i =3D 0; i < e820_table->nr_entries; i++) {
> +		unsigned long first, last;
> +
> +		if (!e820_ram_pages(&e820_table->entries[i], start, end, &s, &e))
> +			continue;
> +
> +		first =3D (s - base) / unit_size;
> +		last =3D DIV_ROUND_UP(e - base, unit_size);
> +		bitmap_clear(bitmap, first, last - first);
> +	}
> +}

[Severity: Medium]
Does rounding first down and last up to unit_size boundaries clear the
bitmap bit for an entire 2 MiB unit even when only part of that unit was
accepted?

When a memmap=3D reservation or mem=3D limit is smaller than unit_size (2 M=
iB)
or not aligned to it, arch_accept_memory() only accepts the [s, e)
E820_TYPE_RAM sub-range within that unit and leaves the remaining pages of
the unit unaccepted in hardware.  Because first is rounded down via
(s - base) / unit_size and last is rounded up via
DIV_ROUND_UP(e - base, unit_size), arch_clear_accepted() clears the unit's
bit in unaccepted->bitmap anyway.  If a new kernel is later booted via
kexec (which reuses the EFI unaccepted memory table alongside the
pre-cmdline e820_table_kexec map), it sees the whole 2 MiB unit as
E820_TYPE_RAM with its unaccepted bit already cleared and faults when
accessing the unaccepted pages.

[ ... ]

> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/=
efi/unaccepted_memory.c
> index 4a8ec8d6a571e..b8a0c0d1d2891 100644
> --- a/drivers/firmware/efi/unaccepted_memory.c
> +++ b/drivers/firmware/efi/unaccepted_memory.c
> @@ -130,7 +130,6 @@ void accept_memory(phys_addr_t start, unsigned long s=
ize)
>  	for_each_set_bitrange_from(range_start, range_end, unaccepted->bitmap,
>  				   range.end) {
>  		unsigned long phys_start, phys_end;
> -		unsigned long len =3D range_end - range_start;
> =20
>  		phys_start =3D range_start * unit_size + unaccepted->phys_base;
>  		phys_end =3D range_end * unit_size + unaccepted->phys_base;
> @@ -150,7 +149,8 @@ void accept_memory(phys_addr_t start, unsigned long s=
ize)
>  		arch_accept_memory(phys_start, phys_end);
> =20
>  		spin_lock(&unaccepted_memory_lock);
> -		bitmap_clear(unaccepted->bitmap, range_start, len);
> +		arch_clear_accepted(unaccepted->bitmap, unaccepted->phys_base,
> +				    unit_size, phys_start, phys_end);
>  	}

[Severity: Medium]
If a unit_size-aligned hole such as memmap=3D2M$0x1ffe00000 leaves its bit =
set
in unaccepted->bitmap, doesn't range_contains_unaccepted_memory() permanent=
ly
report the accepted RAM range immediately preceding the hole as unaccepted?

Both accept_memory() and range_contains_unaccepted_memory() extend any
unit_size-aligned end address by one extra unit_size to cover
load_unaligned_zeropad() across the boundary:

drivers/firmware/efi/unaccepted_memory.c:range_contains_unaccepted_memory()=
 {
	...
	if (!(end % unit_size))
		end +=3D unit_size;
	...
	while (start < end) {
		if (test_bit(start / unit_size, unaccepted->bitmap)) {
			ret =3D true;
			break;
		}

		start +=3D unit_size;
	}
}

When the valid RAM before the hole is accepted, accept_memory() extends
phys_end into the hole, but arch_clear_accepted() leaves the hole's bitmap
bit set to 1 because it contains no E820_TYPE_RAM.  After that, calling
pfn_is_unaccepted_memory() on the valid, already-accepted 4 KiB RAM page
immediately below the hole (for example PFN 0x1ffdff before 0x1ffe00000)
has end aligned to unit_size, so range_contains_unaccepted_memory() steps
into the hole's unit, sees the set bit, and always returns true.  As a
result, read_kcore_iter() zero-fills that valid RAM page in /proc/kcore,
unaccepted_memory_vmcore_pfn_is_ram() omits it from /proc/vmcore, and page
freeing paths repeatedly call accept_memory() on ranges ending at the hole
boundary.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113105554.1999=
12-1-pankaj.gupta@amd.com?part=3D1
