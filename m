Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 992C038E5E9;
	Tue, 15 Sep 2026 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482346; cv=none; b=DDuDeGISV6gsmNe8eujF76sJdj7Fd8rPl96Js2zZ9030VUbWk/PP2NgoN51xNmmSEssrm5D39o/L/azMQ/wmNkCxH/lmHSLb+fRrtuGYDPTCmn5yCcA/gJ1caPqK5NqJZaGW9geB5Bv/i8/OAMl6/MAOrmicPkxxb/drp5eHu84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482346; c=relaxed/simple;
	bh=ucTHnbc9VTTokMhg4Q89YI/1gofGkYgVEHd0h0Jm5lk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bJRS2FTVoyZSxEk4y7ak3hr9CJKoQgzN7drkXPqJsCmzuvShLOo/u3vQxCTfU2JfN54BA0lHrH5jiOWiudQ/NZ4dWFDMRtVL553JCgWCuPGeoi4bB1CW21+sorloQqTViZA9845wukM2oibOQ6QOidKsHH/U570lbPoiyxVyvb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpOWlEX6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpOWlEX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5154C1F0089E;
	Tue, 15 Sep 2026 14:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482344;
	bh=41P4RsZFtpH5NGFfQV+UZfxuwGC9lxZAIr1dw8RbTR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XpOWlEX6GlUhNRuKshbD4eV+VEWBxo/aZrSmcGDmlWldOIv2oE0bi2PvRXl6eBz4P
	 RDmTK0sJjLksTMFuzt/fanlQTp8CDwd2ASUZcxjD/mPd5LSu6/vz+2kf3z+RKdoR4Y
	 54d8u34R+rtJn7lOtpEg9sezQx4Fuw88RI/i+JGwTrYovq9jfevfBhs+nfQ+ARliu+
	 bnwHo5WZKnXl9omRdCilRPgX4vGWWWL8czheQi9hZ7UGe570w/e7MBIC5hu5h5OuDi
	 OBpOv3iOs3URkcWqtnKKa+I3OAdzpd7wzPITmwFaT5iKV/8N33zzqTPaKd6nio9Zit
	 SCuNzx4N2FHUw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 9/9] mm/memory-failure: keep inherited poisoned
 frames out of the buddy allocator
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zi Yan" <ziy@nvidia.com>, hannes@cmpxchg.or, "Danilo Krummrich" <dakr@kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Vlastimil Babka" <vbabka@kernel.org>, "Thomas
 Gleixner" <tglx@kernel.org>, shakeel.butt@linux.dev, "Ard Biesheuvel" <ardb@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Dave Hansen" <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Borislav
 Petkov" <bp@alien8.de>, "Ingo Molnar" <mingo@redhat.com>, x86@kernel.org, "Miaohe
 Lin" <linmiaohe@huawei.com>, kas@kernel.org, "Mike Rapoport" <rppt@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Breno Leitao" <leitao@debian.org>, "Suren
 Baghdasaryan" <surenb@google.com>
Cc: kexec@lists.infradead.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, riel@surriel.com, harry@kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, linux-mm@kvack.org, rmikey@meta.com
In-Reply-To: <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-9-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:25:41 +0000
Message-Id: <20260915142542.5154C1F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm: panic when accepting clean pages sharing an unaccepted unit wi=
th poisoned pages
- [Medium] mm: lost memory failure stats due to lockless update in hwpoison=
_boot_page()
--

commit 92cea9db628cbe8f9651b225628684a39c80ddd4
Author: Breno Leitao <leitao@debian.org>
Subject: mm/memory-failure: keep inherited poisoned frames out of the buddy=
 allocator

This commit intercepts inherited poisoned pages before they enter the buddy
allocator. It processes memory blocks by checking for poisoned pages, flagg=
ing
them, and passing the remaining clean pages through the allocator. This
prevents unaccepted memory blocks with poisoned frames from being mistakenly
re-merged.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b07b5f4751cb9..cca67a2702a42 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
[ ... ]
> @@ -1597,6 +1597,25 @@ static void __meminit accept_and_free_block(struct=
 page *page,
>  	__free_pages_ok(page, order, FPI_TO_TAIL);
>  }
> =20
> +static void __meminit free_poisoned_block(struct page *page, unsigned in=
t order,
> +					  enum meminit_context context)
> +{
> +	unsigned long i, nr_pages =3D 1UL << order;
> +
> +	for (i =3D 0; i < nr_pages; i++) {
> +		struct page *p =3D page + i;
> +		phys_addr_t phys =3D page_to_phys(p);
> +
> +		if (range_contains_poisoned_memory(phys, PAGE_SIZE)) {
> +			hwpoison_boot_page(p, context);

[Severity: Medium]
Is this call to hwpoison_boot_page() safe from data races during memory
hotplug?

When called during hotplug (where context =3D=3D MEMINIT_HOTPLUG),
hwpoison_boot_page() calls update_per_node_mf_stats() which performs
non-atomic read-modify-write operations on the node stats:

mm/memory-failure.c:update_per_node_mf_stats() {
    ...
    ++mf_stats->recovered;
    ...
}

Since hwpoison_boot_page() does not acquire mf_mutex, could a concurrent
memory_failure() execution on the same NUMA node corrupt the recovered and
total counters?

> +			continue;
> +		}
> +
> +		/* this part of the block is not poisoned */
> +		accept_and_free_block(p, 0);

[Severity: High]
Can this sequence cause a kernel panic when accepting clean pages that share
an unaccepted memory unit with poisoned pages?

When a clean page belongs to an unaccepted memory region,
accept_and_free_block() invokes accept_memory(). However, accept_memory()
operates at the unit_size granularity (typically 2MB) and rounds down the
start address to this boundary before calling arch_accept_memory():

drivers/firmware/efi/unaccepted_memory.c:accept_memory() {
    ...
    arch_accept_memory(phys_start, phys_end);
    ...
}

Because the clean page and the poisoned page share the same unaccepted
unit_size block, won't arch_accept_memory() be inadvertently executed on the
poisoned page as well?

If arch_accept_memory() attempts to accept physically poisoned memory (such
as via TDX TDG.MEM.PAGE.ACCEPT), could this trigger an unrecoverable Machine
Check Exception?

> +	}
> +}
> +
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D9
