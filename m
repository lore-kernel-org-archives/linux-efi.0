Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1771366542;
	Tue, 15 Sep 2026 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789481484; cv=none; b=sYNBIMrm/NqC0DLvLGbhdl6BJp+OcPHKpM60AmfX4+tkGjSRD0zNYxm2sq8yg0GKGK8abPQLPHte/FiyEwXhy6JTn9l8mk6XcxWsaDFzagOfdhrfs2/GqvKO6RId9fCpCvGVm3f7topcI1kDm3VTouXeupkgbhCCfzgUGfD0mZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789481484; c=relaxed/simple;
	bh=zTmABsZ2slNTNTqR5g2nelZscwg4Mg0EJTyMFrNzVrM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yh9alABjawkqnEl4VE1gFC9YcAYB90GDlmtgMqBpQHsNA8OkZCDIaXZi8oBtpJ6CS6VVjLIanEXQJbTlaYhh0w1FVP6By831a0Kn9XyTqpX2Wi+epy8hL9ygVZlHV3QtyxzoRrsFq3bz+luH61Ywc1XQBU+89nNp2dno3EI0AyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=baDlUtFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="baDlUtFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A209A1F000FF;
	Tue, 15 Sep 2026 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789481482;
	bh=U0YAPSCzjIvx9j5UuO3la71ldkiY663ti2cQ1z7Zo34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=baDlUtFwZ7KCV4ufgTF//oU9YijykM7UmGP8RPQrD+I8pBO+jchLE29xCD1JteFFG
	 uJ0SOqHSmDC+KQ4IZxr7tzq7M6U2SU8TAl5BBntbdoZ5zj1na3pmN7vXwcO9Wpx5SC
	 rY25b6BGE0yPe+0Mswb8tlBkv5+sXjFsGykikSy1u4unUQZWAkHACiourVm8X4+O/E
	 HDneJHgr8sfHh5bwIaTnsDcvU/1uJxa2dZ/oPSwy0lhieD/NUrLxIJRS5tFAt/jW1D
	 l3m84KwUcryVRdWgYhgaA0nOxBWmOhcjT4OkTN+OlDGJuUQa+LciWoQcxHs7mQDkuq
	 cZRjH/f/KpnBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Reply-To: sashiko-reviews@lists.linux.dev
To: "Oscar Salvador" <osalvador@suse.de>, "Suren Baghdasaryan" <surenb@google.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Michal Hocko" <mhocko@suse.com>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Zi Yan" <ziy@nvidia.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Borislav Petkov" <bp@alien8.de>, "Thomas
 Gleixner" <tglx@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Mike Rapoport" <rppt@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, x86@kernel.org, "David
 Hildenbrand" <david@kernel.org>, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, shakeel.butt@linux.dev, "Brendan
 Jackman" <brendan.jackman@linux.dev>, hannes@cmpxchg.or, "Ard Biesheuvel" <ardb@kernel.org>, kas@kernel.org, "Ingo
 Molnar" <mingo@redhat.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "Breno
 Leitao" <leitao@debian.org>
Cc: linux-cxl@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-efi@vger.kernel.org, harry@kernel.org, driver-core@lists.linux.dev, kexec@lists.infradead.org, riel@surriel.com
In-Reply-To: <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:11:20 +0000
Message-Id: <20260915141120.A209A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: memory_failure_stats data race in hwpoison_boot_page()
--

commit 95ab593413859ad843df67ede9095a08529eb0cd
Author: Breno Leitao <leitao@debian.org>

mm/memory-failure: add hwpoison_boot_page() to flag an inherited frame

This commit adds a helper, hwpoison_boot_page(), to flag inherited frames
recorded as poisoned by the previous kernel before they reach the allocator.
It leaves the frame in the state expected for poisoned frames, allowing
existing PG_hwpoison logic to cover it appropriately.

> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d9b8be696aac3..60e9682434700 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
[ ... ]
> @@ -137,6 +137,32 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, u=
nsigned long size)
>  	return range_hwpoison(start, size, false);
>  }
> =20
> +static void update_per_node_mf_stats(unsigned long pfn, enum mf_result r=
esult);
> +
> +void __meminit hwpoison_boot_page(struct page *page,
> +				  enum meminit_context context)
> +{
> +	unsigned long pfn =3D page_to_pfn(page);
> +
> +	if (PageHWPoison(page))
> +		return;
> +
> +	SetPageHWPoison(page);
> +	set_page_count(page, 1);
> +	/* The page has been completely isolated =3D=3D MF_RECOVERED */
> +	update_per_node_mf_stats(pfn, MF_RECOVERED);

[Severity: Medium]
Is it safe to call update_per_node_mf_stats() here without acquiring mf_mut=
ex?

During memory hotplug (when context =3D=3D MEMINIT_HOTPLUG), if
hwpoison_boot_page() is called for inherited poisoned frames, it appears th=
is
could race with runtime hardware error processing on other CPUs.

Other paths like memory_failure() update these same per-node statistics whi=
le
holding mf_mutex. Because update_per_node_mf_stats() performs non-atomic
increments:

mm/memory-failure.c:update_per_node_mf_stats() {
        ...
        case MF_RECOVERED:
                ++mf_stats->recovered;
                break;
        ...
        ++mf_stats->total;
}

Could calling it here circumvent the mutex and corrupt the memory failure
sysfs statistics by losing counter updates?

> +
> +	/*
> +	 * The per memory block half of num_poisoned_pages_inc() has no block to
> +	 * find at boot, and divides by zero looking for one. A hotplugged block
> +	 * is already there.
> +	 */
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D8
