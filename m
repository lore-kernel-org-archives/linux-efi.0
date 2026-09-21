Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F083B3BF5;
	Mon, 21 Sep 2026 07:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789976284; cv=none; b=HZ/vd+SDbPh//Z0G3up+iVOVWosAL8TH7lq2e/9xNYXyTTbHZPj5cLqyQXPI9CQkZ1BjP1/jvwM36YOqM74MiAtNlAhiowazvERXljP3gPaJ3KvVKjl1ieeTE7xcE//PMRFW2Ly/TrNXJV4oHwUq6D4MSMyVYAi7sr40M5gppuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789976284; c=relaxed/simple;
	bh=nrUjuFhT3s2+v/gwSala4pCbrkVM+7IhP9tittz2bGU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EkTxHPA9J2G54wSuw29t252701+/D82Ul1NxOIZZQMpFcJYWB5ryr8IMaDDt4n6uDwA7bKpuDDY4vtBbpC/5nKOwqCWOE0OIGZifPM9ou98tZz2cO0qYXP9v0IqDw5dVvDZEm+jg1r1OQda9zZTGG/FmqeDvtzyQgs5nuK1GdJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=l6ko2rle; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="l6ko2rle"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5BB42175A;
	Mon, 21 Sep 2026 00:37:58 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC0733F86F;
	Mon, 21 Sep 2026 00:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789976281; bh=nrUjuFhT3s2+v/gwSala4pCbrkVM+7IhP9tittz2bGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l6ko2rleUboMNNtjiHiGjklemMccKDrVkhFCxBZ8Sdh5DR4atC+hN8GMVuMwMP5mz
	 35t8eGH82Xntk2lduJ6VuzvD4tP1J1d2XqoJr0PaLohuTpW2PjZwo3fxqWq6vXhlxV
	 DDTrpBYl7OVsuGeT/5runOY5gbLovztguwJGGIsY=
Message-ID: <8d36a988-f6e2-446b-92fd-dc13a4fa691a@arm.com>
Date: Mon, 21 Sep 2026 08:37:55 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
 <829523cd-85a4-4f8e-b9f2-f3c1d7ce4fb1@arm.com>
 <1d1e38d8-cc1a-4a53-80c7-c0ef75a70105@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <1d1e38d8-cc1a-4a53-80c7-c0ef75a70105@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/09/2026 21:00, David Hildenbrand (Arm) wrote:
> On 9/18/26 18:03, Ryan Roberts wrote:
>> On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
>>> fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
>>> installs those arrays as page tables. Their elements are therefore
>>> HW PTEs.
>>>
>>> Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
>>> pointers returned and passed to the accessors. This is needed before
>>> ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
>>> array dimensions and placement are unchanged.
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>>  arch/arm64/mm/fixmap.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
>>> index 237a9136bc73b..709a97fe327d8 100644
>>> --- a/arch/arm64/mm/fixmap.c
>>> +++ b/arch/arm64/mm/fixmap.c
>>> @@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
>>>  
>>>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>>>  
>>> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>>> +static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>>
>> I think in my original proposal it was impossible to have a hw_pte value; only a
>> hw_pte pointer was possible. Being able to create hw_pte values means that it is
>> possible that a hw_pte_t pointer is not actually pointing to an entry in a HW
>> pgtable. The main motivation for this is that we want to dereference neighbours
>> of a hw pte based on it's pointer and be confident that it is safe. I think this
>> removes some of the safety.
> 
> If you follow some of the related discussions on the core-mm series, there is a
> path forward to go further into that direction.

OK, as long as we have a path to the "full" solution if we ever need it, then
sounds good to me.

> 
> People instantiating a hw_pte_t on the stack are not really a concern right now.
> 

