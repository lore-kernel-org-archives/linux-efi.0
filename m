Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794986681;
	b=WlkAp4b/6dhnvDl28E3QFOw7EshibypQWgESinGV0j9/HERkt9mWf4AaVXDo1OHdmCun
	 qLyO5EFcs7xR89bFs8YIHwJCQ3Kg2F7Q66Pz5qcqdfuFiW/T08e0KyL6yT5qCxrCbLjc2
	 9bB21O/9D1PZX5LYgtbfQv/sY4wAmMyh61Ci5/ca+udINHQur+xKDZHb35uw4YIQMbmoT
	 4RSjLL2BWwU0u2N+5XvNBO0IzyhTUhzQKqTjNb2GNQwqvmFNmh95+yi28gfrNPct6s93y
	 h3r9+5w2pIpECAofD5PQ70/D0jOVkkHEZvS4R3k7090uJOTRcrMRdX01MD6EEDsmc1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794986681;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Subject:To:CC:
	 References:From:Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
	 Content-Type:Content-Language:Content-Transfer-Encoding:
	 X-Originating-IP:X-ClientProxiedBy;
	bh=YxfLuSOt8ET85QiZh6OvB/zGAowvN5z/7eyIr5ItJTU=;
	b=QF56Jz5/PZSIF/8zteb54gQEaWKaFTFqK19tjyJEv82HKzlVdeWsXiTPXoMEU5v3LALp
	 45uvJfmHiyIZfUrjokcWYpFmx3Z8Z7G1uAEk5KE1+az8haiKLjurkyTKdbXmwsHJWL47Z
	 R8UgYra0hGM+qpNsOVCivOh8mzwT3sWnvSoIrb01NFe39jAF0CsP6JQh7mYVd5/Rp9C65
	 jIIV7qsRtGKzEFRUwZQ9SGwB1tAd2ff5QCQMRku19xyrs6sAcnYpB/YiyQ9dfBhZd8Jup
	 795oCcTyZXJLYS2u1hA20MKmSQDOwzdjNHWS3aML3H03b8n/U+UMwrPGOHyxFd25Cpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=vUvwXW2W;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5FA606A325;
	Wed, 18 Nov 2026 07:24:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E5FA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=vUvwXW2W
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YxfLuSOt8ET85QiZh6OvB/zGAowvN5z/7eyIr5ItJTU=;
	b=vUvwXW2WIA+PKi7kpUQn/IdJA3tUeSnR/DAy6nHLaKc51qgaH4uezVDugKTwg71dSQ0iQnYz5
	7qfqxPWENL8AfnzkCAe0uglj9oduqtAzDO52wcZSeb5b7e7OqW+v6g0PKUzKYgC0I/sddQ8CfqM
	XuwpFrFNaB2bAcjdpHKAdqo=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jTtPZ0n3fzpSyt;
	Wed, 18 Nov 2026 15:23:46 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id D205D4056E;
	Wed, 18 Nov 2026 15:24:35 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 18 Nov 2026 15:24:32 +0800
Subject: Re: [PATCH v6 7/7] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
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
 <20261016-hwpoison-kho-v6-7-f304255147da@debian.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f04d766b-2942-3627-14b4-dc3c88c899dd@huawei.com>
Date: Wed, 18 Nov 2026 15:24:31 +0800
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
In-Reply-To: <20261016-hwpoison-kho-v6-7-f304255147da@debian.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemk100004.china.huawei.com (7.152.185.74)

On 2026/10/16 20:15, Breno Leitao wrote:
> When memory_failure() reports the outcome of a hard offline, set the
> frame's bit in the LINUX_EFI_POISONED_MEMORY bitmap, so that the next
> kernel reserves its unit.
> 
> Hook action_result() ahead of the statistics guard. A hard error on a
> frame that was soft-offlined earlier comes in as MF_MSG_ALREADY_POISONED,
> which skips the statistics, but it is a real failure and has to be
> recorded. MF_MSG_PFN_MAP is left out, as it is not System RAM.
> 
> A bit is only ever set, never cleared (for now). Several frames share
> a bit, and an unpoison cannot tell whether the unit as a whole is good
> again. That is a known limitation.
> 
> The table is mapped with memremap() from an early_initcall rather than
> through the direct map. On arm64, mem= and the usable memory range of a
> crash kernel trim memblock, which drops the table's pages from the direct
> map, and the first recorded error then faults.
> 
> Recording is skipped on a host with SME active. The stub writes the table
> in the clear, so reading it back there needs a decrypted mapping. That is
> left for a follow up.
> 
> memory_failure() has already taken the frame out of this kernel's
> allocator, so only the cross-kexec record happens here.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

For memory-failure part:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

