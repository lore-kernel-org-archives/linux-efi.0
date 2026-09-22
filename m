Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CED03DB62B;
	Tue, 22 Sep 2026 09:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790069366; cv=none; b=h2kg+tAqPVPyI36wb6eVMSCkSi5H25pLRJ8UqzBTxQvpD//2hzYZ1yzRHesulnWILmdbjcJ8u4xGED1d/n8BM4PoJ3FnddGZBZTKteQQceQiWQBDBG67adeBE54zovqq2gIw0WpUgabe7GNF5e1UyedOB55H1bUsbsoUh8kFjxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790069366; c=relaxed/simple;
	bh=j2jR10kCHvpHCNyicsNRz78S1Ffisd+3RzqfY0lLzkI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CKmHmGh00MYG/6ePCQfWCGDJMPSqow7DcCQInd5q/rQfVxz25H2EBtPUD6l6uxdpTClJQoFV5H+IY8gso/b4wyNojvSjjMMVkMQNrmhz6qY8d/MY6kjnxHvEsRI9Z61KEeis2hqCASEbxaY2AsCFd9k5hLRDQcNd+5l0mfZvhM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=stpcFFVU; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="stpcFFVU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HGkT9Ui8IWBvThLwNwtH5JiFUDnabT7ULMWL9InJHFU=;
	b=stpcFFVUA5sWEn3kkPHrfPiLr8qBRiZbNZDh7aVd9XnAuytPymZceOrcl8vSrbJBulCPVDCTw
	olYFpOv609kH+6MaWDjwTkqVpeODVsVsPvdBngDQ3tJ8srYzmm23k97FGyQxixbsn8Vuj4RMKxU
	zUe4jbOpnHoBTAbKsk4aHxI=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hpvd5362fz1T4JM;
	Tue, 22 Sep 2026 17:17:29 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 69CFE202E6;
	Tue, 22 Sep 2026 17:29:19 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 22 Sep 2026 17:29:15 +0800
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
 <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
 <arJBkNOgbR8NrgFP@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <16baab50-692c-308b-d60d-1b0a328df1e3@huawei.com>
Date: Tue, 22 Sep 2026 17:29:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <arJBkNOgbR8NrgFP@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 whupemk100004.china.huawei.com (7.152.185.74)

On 2026/9/22 17:14, Breno Leitao wrote:
> Hello Miaohe,
> 
> On Tue, Sep 22, 2026 at 02:27:59PM +0800, Miaohe Lin wrote:
>>> A bit is never cleared, which is a known limitation: it stands for a
>>> whole unit, so an unpoison of one frame cannot tell whether the unit as a
>>> whole is good again.
>>
>> Thanks for your patches. I have a question about unpoison: If a bit is never
>> cleared, after we do some memory-failure+unpoison tests, kexec will lose the
>> tested memory without reboot?
> 
> Correct, A bit stands for a 2M unit, so every tested page that falls in
> a distinct unit costs 2M in each kernel after the kexec.
> 
> Worth being precise about the state today: the unpoison itself works.
> The frame goes back to the allocator and num_poisoned_pages drops. Only
> the bit stays, so the next kernel poisons the frame again. Test loop
> in, memory out, and nothing gives it back.
> 
> Important to say that nothing block us from unpoison the bitmap, and in
> fact my initial patchset had it. I also _think_ we should unpoison the
> bitmap once we unpoison the page. 
> 
> I have just kept it out of this patch in order to simplify the patchset and
> get the basis correct, and then evolve on top of it.
> 

Makes sense to me. Thanks for your work.

> That said, If you think this is a must have in first patchset, I am more
> than happy to do it now, but just keep it in mind that it will grow the
> patchset by about 2 extra functions.
> 
> Thanks the review,
> --breno
> .
> 

