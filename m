Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEBA4A2A42;
	Tue, 15 Sep 2026 13:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789480764; cv=none; b=Fwyufkx5jQf24CRZJK4rSWD9nSESx8x9U/SsPRRTN4vJpulTwr5DG1SZUVz/+lenlv4pnMQva0ZOLZvvCYoBfIST8jjwkkVKpB3XKpOhhyGsMSe1Qn3990/kGGf7WcIMl/K+8U2r3s39psVyKl77hc8U8n6eLjKI2A2Ix46TU5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789480764; c=relaxed/simple;
	bh=M9jbckzgXh08eXx6L+BzdLTihu4jBUCNmlrGBM6kK30=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=oq2faNFOBQ/tAqlY/3WwU+xXJzCvl3+f+P00VGfZDmliUKP6z/2Z39iJ6fCMImTYsNfVcIAgksxulgFfPaU/OWXeUI0syy26g+wfMSH+A+369Jf/tAGVxjYERmfOEEmk3rIupi53eKqq86xVigwSPBszRK9PmfvZOVbkqMi1gKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/4120la; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/4120la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2161F00899;
	Tue, 15 Sep 2026 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789480761;
	bh=ebYm8TSC4CYUtZj4Q5hjjIqj2aKy0owa4swW8JAI55c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X/4120la222Bs4d30xrI6T2e2igizjI0fR2kIKouHR8SDHTVn82+yUVGlqeN5q3ZT
	 69wf05F9PrURI1xpqdtwsrnbEJiiw6qHYKmnktgZQKMH+D0HTrQnwxWBmtvAZAwBzq
	 5T+ofFUPcF76KMrVEwqVrbqdM41tzXYzPCW0HxPSz95Cp73YYFRT6E2nwW3ICze+S8
	 s8KRWENXyoy/fkDYiltMZv6BL/kq3mYVE9s1CWhofBRj6ikwYdQ13qN+J7HR7T5Ugs
	 O53AH9t8xLoZ4kjUcjbEODdjIaOjVBewOE24Ev9XyL/Hn8gpWQB1Eh1xFPqy3K8Oey
	 WaiSxWw8jjqwg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ingo Molnar" <mingo@redhat.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Danilo
 Krummrich" <dakr@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Zi Yan" <ziy@nvidia.com>, "Michal Hocko" <mhocko@suse.com>, "Borislav
 Petkov" <bp@alien8.de>, "David Hildenbrand" <david@kernel.org>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Oscar
 Salvador" <osalvador@suse.de>, kas@kernel.org, "Naoya Horiguchi" <nao.horiguchi@gmail.com>, hannes@cmpxchg.or, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, x86@kernel.org, "Breno
 Leitao" <leitao@debian.org>, "Miaohe Lin" <linmiaohe@huawei.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>, shakeel.butt@linux.dev, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, "Thomas Gleixner" <tglx@kernel.org>
Cc: rmikey@meta.com, linux-efi@vger.kernel.org, kernel-team@meta.com, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, harry@kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, riel@surriel.com, kexec@lists.infradead.org
In-Reply-To: <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 13:59:19 +0000
Message-Id: <20260915135919.ED2161F00899@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: TOCTOU race in memblk_nr_poison_init() drops early MCE counts
--

commit a8282f47e9b2f9ae014e9948a2edfc336de13cd0
Author: Breno Leitao <leitao@debian.org>

drivers/base/memory: count inherited poisoned frames into the block

This commit initializes the poisoned frame count for memory blocks created
during early boot by scanning for pre-existing poisoned pages. It addresses
an issue where kexec-inherited poisoned frames would later cause a counter
underflow on unpoisoning, preventing the block from being onlined.

> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 5eead3346f1e3..49a33ddbb2e71 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
[ ... ]
> @@ -807,6 +812,7 @@ static int add_memory_block(unsigned long block_id, i=
nt nid, unsigned long state
>  	mem->state =3D state;
>  	mem->nid =3D nid;
>  	INIT_LIST_HEAD(&mem->group_next);
> +	memblk_nr_poison_init(mem);
> =20
>  #ifndef CONFIG_NUMA
>  	if (state =3D=3D MEM_ONLINE)

[Severity: Medium]
Could this ordering create a Time-Of-Check to Time-Of-Use (TOCTOU) race
during early boot?

If a hardware machine check exception (MCE) occurs concurrently after
memblk_nr_poison_init() runs but before __add_memory_block() publishes the
block via xa_store(), does the memory_failure() worker set the page flag
but drop the block counter increment because memory_block_get() still
returns NULL?

If this concurrent increment is dropped, could a subsequent unpoison
operation underflow mem->nr_hwpoison to ULONG_MAX, permanently breaking
memory_block_online() with -EHWPOISON?

[ ... ]
> @@ -1251,4 +1257,33 @@ static unsigned long memblk_nr_poison(struct memor=
y_block *mem)
>  {
>  	return atomic_long_read(&mem->nr_hwpoison);
>  }
> +
> +/*
> + * Frames a kexec handed over are flagged as they reach the allocator, l=
ong
> + * before this block exists, so memblk_nr_poison_inc() had nowhere to co=
unt
> + * them. Take them from the page flag instead.
> + */
> +static void memblk_nr_poison_init(struct memory_block *mem)
> +{
> +	unsigned long pfn =3D section_nr_to_pfn(mem->start_section_nr);
> +	unsigned long nr_pages =3D PAGES_PER_SECTION * sections_per_block;
> +	unsigned long i, nr_poison =3D 0;
> +
> +	/* A hotplugged block is created before its pages are online. */
> +	if (mem->state !=3D MEM_ONLINE)
> +		return;
> +
> +	if (!range_contains_poisoned_memory(PFN_PHYS(pfn),
> +					    nr_pages << PAGE_SHIFT))
> +		return;

[Severity: Medium]
Does this check unconditionally return false for a fresh early MCE because
the MCE is not in the inherited EFI table?

If so, would this skip the manual walk, leaving the counter entirely
dependent on the concurrent memory_failure() increment that might be
dropped in the race window described in add_memory_block() above?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915-hwpoison-k=
ho-v5-0-3bc7a57bd503@debian.org?part=3D7
