Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4946129993F;
	Tue, 15 Sep 2026 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789478132; cv=none; b=mOkYTG7fruC8UEKpews2EAlRP29eVEYvrnzoyCWT6OBoYYxDKC84QyfFOcAQSKKG6Q3w8m+66FYosoM2myhgWBeACusQpy7vsiCI8ojbvdV1wjhHeho+ju6Wdo6vgYdSN1kRUE8CjzQF5o91mvHiilfmEDQNoS3k4Q7RvQqwGPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789478132; c=relaxed/simple;
	bh=qZeokzXWIiLmJvazIOfaehqd+JttbxxVqV2hdZXETeI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=IwM2aSyRgx4nGQ2D8cjp6ds0/2+RqbFKXdtbAkuAzixPrETHyjGEY10fBtzcQcwzo+W4baw6hzUXsMypJd1oEvUk6/4waOiVOcjhqkLO5RrvqP2Te8MlkpPpRE3V3J8B6YlmAXB2oSkTMEHkqeQx5u73C7WSlZ9uzvYf6KHz53A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V4EdpEhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V4EdpEhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB261F0089A;
	Tue, 15 Sep 2026 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789478130;
	bh=VzikfrdXoe4OKdqIVI5MhWMg7/FGoAHvmjSaSoohyws=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V4EdpEhkDelvZkC/X/3bK3vl9pG/mNCj4Y9fnQXsUyUjfO/C0WIiHtAE7wUFnpIJl
	 hf0m/zLPCJxaZOLx5gA1XcJJcyM0/Uwj48vUqKR2OOSz37Capy4w5XMFn4On3XQ+Qf
	 KJpsPuIDKAOrTGf4xYES5OyMcVKeiupxsGAG72zhWHFQTMAf7voR40D27dtYgU3ApH
	 8lKtecKBw1KA6sqz/3HTKKHhPKKiHHj46fRvgiZoudqwdy24NRL7Gtou8rddlFICmZ
	 SZ2KeUkDOqE1SfCUntS3mJ5Sx3OL7g5dd9LgQ4Mx2s5CqVa8s6KdFslIYwtccHAxlo
	 ocVNOhI1yr1Xg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 3/9] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Reply-To: sashiko-reviews@lists.linux.dev
To: "Suren Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Zi Yan" <ziy@nvidia.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "H. Peter Anvin" <hpa@zytor.com>, shakeel.butt@linux.dev, kas@kernel.org, "Ard
 Biesheuvel" <ardb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, x86@kernel.org, hannes@cmpxchg.or, "Thomas
 Gleixner" <tglx@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, "Ingo
 Molnar" <mingo@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Borislav Petkov" <bp@alien8.de>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, "Oscar Salvador" <osalvador@suse.de>, "David
 Hildenbrand" <david@kernel.org>, "Breno Leitao" <leitao@debian.org>
Cc: kernel-team@meta.com, driver-core@lists.linux.dev, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, kexec@lists.infradead.org, linux-efi@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:15:27 +0000
Message-Id: <20260915131527.AFB261F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm: efi: integer overflow in poisoned memory bitmap allocation on =
32-bit
--

commit 591eef51f672049b14b50a75d67dac823925a19a
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: libstub: install the poisoned-memory EFI table

This commit introduces a new poisoned-memory EFI table installed by the stu=
b.
It sizes a bitmap based on the UEFI memory map to describe the RAM span and
allocates it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take it
as free RAM.

> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/fir=
mware/efi/libstub/efi-stub-helper.c
> index 48f93f7758e9e..9c66e06c972c5 100644
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

[Severity: High]
Could this allocation size wrap around on 32-bit EFI architectures if the
memory map is extremely sparse?

In efi_get_ram_range(), ram_top is determined from EFI memory map
descriptors. If a descriptor is placed at a very high physical address,
bitmap_size could be large enough to wrap around 32-bit arithmetic.

On 32-bit EFI, the allocation size passed to allocate_pool (which takes
a 32-bit UINTN) is implicitly truncated. For example, if bitmap_size modulo
2^32 is very large (e.g., 0xFFFFFFF0), sizeof(*pm) + bitmap_size could
truncate to a tiny allocation (e.g., 8 bytes).

> +	if (status !=3D EFI_SUCCESS)
> +		return NULL;
> +
> +	pm->version =3D 1;
> +	pm->unit_size =3D EFI_POISON_UNIT_SIZE;
> +	pm->phys_base =3D phys_base;
> +	pm->size =3D bitmap_size;
> +	memset(pm->bitmap, 0, bitmap_size);

[Severity: High]
If the allocation size wrapped around, could this memset cause a heap
buffer overflow?

The 64-bit bitmap_size is passed to memset, which takes a 32-bit size_t on
32-bit architectures. This independently truncates bitmap_size (e.g., to
0xFFFFFFF0). Since the prior allocation could have wrapped to a very small
size, this would write gigabytes of zeroes into a tiny allocation, causing
boot-time memory corruption.

Would it be safer to check if bitmap_size exceeds the maximum allocation
size for the architecture, or use a safe addition helper before allocating?

> +
> +	return pm;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D3
