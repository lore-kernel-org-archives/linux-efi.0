Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE334A64F4;
	Tue, 22 Sep 2026 06:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790058493; cv=none; b=Jq4DlFveoA8WCV6gCuZsXThUHlLgzLuGCBKsdZizI6zX4y9pqW6ACYWW8FCmLLuyVR5VSaP3xuSc2Xk9NP7NP4m/vKW+HsnrYs1e/1w6ZbL9EAdfRhkLYbGcRoRdxtnfmypIfQJunVtZijAzQM9xQY8DiFfBUs6AeVlST9ZJUYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790058493; c=relaxed/simple;
	bh=2JIymY9yv7UEMLFvfjDgIn3mrJFnccBF1D2xhLC1wTM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BmHhrKBTat+ielF3ie1mBOY7h3d2KtCTWrqxM25V/IPgBuPZ4ePh6qAenyw5JtaOL0gQieQScljiZ2Gptw0juGb4PgQrZ4d5Xj+e58pgyfOn+SZmvSl1ax9wqskZ8Il6LOpTi7GEXnD5a2oMdm9YeidYTc9mZ/qU3i/4R4dvbac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=TVb/Xxdn; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="TVb/Xxdn"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=FGbhkQwIGfdAyVtjg1Ql4s8k82iByJqzyE4qhg2yGrY=;
	b=TVb/XxdniyjxDFy7pVMTRQxolIRi+rQVHqCEnlKh1dbNqIt3c2xKfhY78rYOnafftzF8lAstD
	xy2sKyyG+aKfvZphbGF6i0pqXqKi4+Lx7oBYcGyOLnBdBgO4nzlpnNBmoKdAIsiGoqcxSUoEfMe
	/ubLcOzVXiphJvNeeFaqF5c=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hpqcs4qVZzLlXZ;
	Tue, 22 Sep 2026 14:17:01 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id EDB3440573;
	Tue, 22 Sep 2026 14:28:03 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 14:28:00 +0800
Subject: Re: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages
 out of the next kexec
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <rmikey@meta.com>, <riel@surriel.com>,
	<harry@kernel.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <kernel-team@meta.com>, Ard Biesheuvel
	<ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>, <kas@kernel.org>, <kexec@lists.infradead.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
	<hannes@cmpxchg.or>, <shakeel.butt@linux.dev>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
Date: Tue, 22 Sep 2026 14:27:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)

On 2026/9/15 20:53, Breno Leitao wrote:
> Problem:
> ========
> 
> When a page is hard-offlined due to an uncorrectable memory error (multi
> bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
> the buddy allocator. This information is not carried to the next kernel
> that is kexeced. The new kernel kexecs and trip over that bad memory
> bank _again_.
> 
> Why now:
> ========
> 
> Several industry trends make this increasingly important:
> 
>     1) DRAM is getting more expensive
>     2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
>        failing part can no longer simply be swapped;
>     3) memory is kept in service far longer (at Meta, DRAM lifetime is being
>        drastically extended).
>     4) It is more and more common to kexec instead of full reboot
>     5) Increase of memory per system with CXL
> 
> What was done already:
> ======================
> 
> In order make linux deal better with the problem above, I've done
> already fixed a bunch of stuff in this area, such as:
> 
> 1) Panic on unrecoverable errors, instead of "printk and carry over":
> https://lore.kernel.org/all/20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org/
> 
> 2) Respect poisoned memory at kexec time
> https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/
> 
> Now, the natural follow up is to carry the poisoned memory information
> to the next kexec kernel, avoiding tripping over a known "bad page".
> 
> Proposed Solution:
> ==================
> 
> Carry the poisoned frames to the next kernel in a new EFI configuration
> table, LINUX_EFI_POISONED_MEMORY.
> 
> The table is a bitmap with one bit per 2MB of physical memory, modeled
> on LINUX_EFI_UNACCEPTED_MEMORY. The stub sizes it from the EFI memory
> map and installs it empty while boot services are up -- a running kernel
> cannot install a configuration table, it can only flip bits -- and a
> table inherited from an earlier boot is reused as-is. That is one
> fixed-size allocation, 64KB per TiB of the span the memory map describes,
> with no list to grow at runtime and no chain to trust at parse time.
> 
> The mechanism is architecture independent, so x86 and arm64 use the same
> code.
> 
> Each hard offline sets the bit for its unit. Soft-offlined pages are not
> recorded: they are still functional, and were offlined predictively.
> 
> The next kernel takes the table into use from efi_config_parse_tables(),
> which vets the inherited header and hands the table's pages to memblock.
> It is EFI ACPI reclaim memory, which x86 leaves out of memblock and so
> out of the direct map; the unaccepted memory table is handled the same
> way for the same reason.
> 
> The frames themselves are poisoned in __free_pages_core(), as each block
> reaches the buddy allocator. That is the one point every producer passes
> through -- memblock_free_pages() early, deferred_free_pages() once the
> deferred struct pages are up, and generic_online_page() at any later
> hotplug -- and it is already where the unaccepted memory table is
> consulted. The recorded frames are held back and the rest of the block is
> freed, so they never enter the allocator instead of being taken back out
> of it. They end up in the state a frame poisoned by this kernel would be
> in, so everything that already understands PG_hwpoison covers them --
> including the kexec segment placement check from the series linked above,
> which keeps the segments a kexec places off these frames.
> 
> Granularity is the trade-off: one bad 4KB frame costs a whole 2MB unit in
> every later kernel of the chain. In exchange, a row or column fault --
> roughly a quarter of the DRAM faults reported in [1], and potentially
> thousands of 4KB pages scattered over gigabytes -- collapses into a bit
> or two.
> 
> A bit is never cleared, which is a known limitation: it stands for a
> whole unit, so an unpoison of one frame cannot tell whether the unit as a
> whole is good again.

Thanks for your patches. I have a question about unpoison: If a bit is never
cleared, after we do some memory-failure+unpoison tests, kexec will lose the
tested memory without reboot?

Thanks.
.

