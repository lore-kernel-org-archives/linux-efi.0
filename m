Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.216
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794985256;
	b=FRA1YUcefMGxw+y+9son6LtJm29alcMbRic2S8yR+Ny+zTG/BRDhC1si05GVEm5VSxAv
	 63zvRcVaP2QE20l1eoJwISvNSyoM8szQK6OomRtNU0FuwPYeIZPbROu0SYtWw1Z25E5G+
	 jqhFfkiV8StPMCM4cTfjVvVhcKoXwoZ8gmYJJ3FGhy/JVASzazAS2LPJ8VMmbAm7dpT2X
	 2s755UXV/a06hyCpc6YVyK416LabUZyM87wd9SsGR2GpzuwPgS0qpHHUpig8VYH3Wt11B
	 QlCXgRQOCe/vbfvn4HP/qhmTbiUxYQykRPASwgJ5KQvha7NExTkY0I5XevaDk0YW4Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794985256;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Language:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=P7MAWPsIyxJf7EbFe+B6P/kIKs4QOghNXNz4nngxpow=;
	b=PLxOrYEPAcv0IEKTDmj+kkofVW0R1UTnSe8sun/RJYpQUqEGWsFAZIvB3nfyltxJQ98v
	 IOMR4xYtTi15oJ7kOYmMGOSQ4QcMagvyc+HiSFYDwLtSxBz9opLJYB+eUD7WAAi6kYfrm
	 kVulOVDqN2gL/HG71mwy7rja3YwTCOECoClR5gj1DIeLzTpWPkPIIc/BaaPUn5OVC1uyb
	 tBeGXX4v9ToUWLpJUXWrJoVHnp/U3FQl1QR0gfCPCevW1c3IVUdeTPHWVGBDjH6wm9He6
	 NBzRiZ6JIJL1cSbgelaznULXLWoXXvqhgQlI396VifNq7s2m2pDTp+RYj/0ikc8pzCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=J7jSSrjT;
	arc=none smtp.remote-ip=113.46.200.216
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D38606A32A;
	Wed, 18 Nov 2026 07:00:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C6D38606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=J7jSSrjT
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=P7MAWPsIyxJf7EbFe+B6P/kIKs4QOghNXNz4nngxpow=;
	b=J7jSSrjT45mE5pHwCz2jP6dil7Qtqxs30D1JSCVyUZxDpTWnLABaUARqY/hWeyFvY/IB9XGsp
	P+tfgFIg8WIVjm1rA89skfheUdG6YkoeqBaYgCDEUNGssDh+oDpRHRydEVFk6/GpGQol0k0xnUJ
	vFIRtHpdkDpniGa5blvowA4=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jTstD2f2Yz1T4KR;
	Wed, 18 Nov 2026 15:00:04 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id E0224203AB;
	Wed, 18 Nov 2026 15:00:43 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 18 Nov 2026 15:00:40 +0800
Subject: Re: [PATCH v6 5/7] drivers/base/memory: count the poison a block
 already holds when creating it
To: Breno Leitao <leitao@debian.org>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<driver-core@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<rmikey@meta.com>, <riel@surriel.com>, <harry@kernel.org>,
	<kernel-team@meta.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas
	<ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
	<liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador
	<osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark
 Rutland <mark.rutland@arm.com>, <kas@kernel.org>,
	<kexec@lists.infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	<shakeel.butt@linux.dev>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-5-f304255147da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f0f5e60a-819e-68e7-09b2-4080f4716e9e@huawei.com>
Date: Wed, 18 Nov 2026 15:00:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
In-Reply-To: <20261016-hwpoison-kho-v6-5-f304255147da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 whupemk100004.china.huawei.com (7.152.185.74)

On 2026/10/16 20:15, Breno Leitao wrote:
> A frame flagged poisoned before memory_dev_init() runs cannot be counted
> on its memory block. memblk_nr_poison_inc() divides by sections_per_block,
> which memory_dev_init() sets, and the block does not exist yet. The block
> is then created reading zero, however many of its frames are poisoned.
> 
> Until now nothing could poison a frame that early. It becomes possible
> once a kernel flags the frames it inherits from the one that kexeced into
> it, as it initializes its memmap.
> 
> memory_block_online() refuses a block that holds a poisoned frame, and a
> counter stuck at zero lets one through.
> 
> Count what a block holds when it is created at boot. The walk sits behind
> num_poisoned_pages, so a machine with no poison does not pay for it.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  drivers/base/memory.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 5eead3346f1e32..77481f375c2206 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -220,11 +220,16 @@ int memory_notify(enum memory_block_state state, void *v)
>  
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
>  static unsigned long memblk_nr_poison(struct memory_block *mem);
> +static void memblk_nr_poison_init(struct memory_block *mem);
>  #else
>  static inline unsigned long memblk_nr_poison(struct memory_block *mem)
>  {
>  	return 0;
>  }
> +
> +static inline void memblk_nr_poison_init(struct memory_block *mem)
> +{
> +}

If defined(CONFIG_MEMORY_FAILURE) but CONFIG_MEMORY_HOTPLUG is not defined, memory block
created at boot time will lose nr_hwpoison count. Is this expected?

>  #endif
>  
>  /*
> @@ -807,6 +812,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
>  	mem->state = state;
>  	mem->nid = nid;
>  	INIT_LIST_HEAD(&mem->group_next);
> +	memblk_nr_poison_init(mem);
>  
>  #ifndef CONFIG_NUMA
>  	if (state == MEM_ONLINE)
> @@ -1251,4 +1257,28 @@ static unsigned long memblk_nr_poison(struct memory_block *mem)
>  {
>  	return atomic_long_read(&mem->nr_hwpoison);
>  }
> +
> +/*
> + * Frames poisoned before the block existed were never counted on it. Count
> + * them now, or the first unpoison takes the counter below zero.
> + */
> +static void memblk_nr_poison_init(struct memory_block *mem)
> +{
> +	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
> +	unsigned long end = pfn + PAGES_PER_SECTION * sections_per_block;
> +	unsigned long nr = 0;
> +
> +	/* A hotplugged block is created before its pages are online. */
> +	if (mem->state != MEM_ONLINE || !atomic_long_read(&num_poisoned_pages))
> +		return;
> +
> +	for (; pfn < end; pfn++) {
> +		struct page *page = pfn_to_online_page(pfn);

Above comment says the pages of this memory block are not online. So pfn_to_online_page
here will return the wanted page?

> +
> +		if (page && PageHWPoison(page))
> +			nr++;

Now that the table is a bitmap with one bit per 2MB of physical memory, would it be more
appropriate to process it at 2 MB granularity?

Thanks.
.
