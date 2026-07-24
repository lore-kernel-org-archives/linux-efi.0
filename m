Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11FD73033EC;
	Fri, 24 Jul 2026 16:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784910180; cv=none; b=CN62txeyhNF8klL6y4OKVWC7Ne9s/g/NHAdCjf41DsZDBkfoXdgkBg4qYM4RdehwPMqlds7mdtfMBrM6HDhW1ts6b6ZIWFRQ1gY75crkVcl1wCgmq9biYQh6c2b7UHZM/wWrItsSNLOIlluC2cKayAcT4AxS1huP+wGAd207pAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784910180; c=relaxed/simple;
	bh=C02uWs/fpXnABbH43y4jX8fXPGtwBqhc0kWtZDPeayg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YNmxDlhmH35+1gNdD1IbWKulXaE5mLoXCqsZ+UzUk/NJCT8QlSwKF/aJ24HI0gKAQ1B3mM4hc1LGfLuDTQt81xzqDGMzKq8h5zRqKO5tMf3uaJytJp1MZRpTFUOrw7Bpy1bJQPH5a5bYfWE3zL3i7/BFy4Ak7YcuxNzuS5bQHV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=iUC98dpb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="iUC98dpb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91D4F1655;
	Fri, 24 Jul 2026 09:22:52 -0700 (PDT)
Received: from [10.57.0.90] (unknown [10.57.0.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C7F03F66F;
	Fri, 24 Jul 2026 09:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784910176; bh=C02uWs/fpXnABbH43y4jX8fXPGtwBqhc0kWtZDPeayg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iUC98dpbFgd+i9SnSkYL0GKvWGOk7xpTRmX2UXYjyfh9B/6bLE/WuAx7CloLocREN
	 hl9aaz1HKjYAaCZbwP0FbaUIknYs8KANk5nrYXdBG0Da9JXUPnYnhocq3QUWcdY9Et
	 OVQZdbXfa8qUjKcrVhyZR4pIQLBjcpiml/L4ONBo=
Message-ID: <d312f635-7c34-4452-b879-d29137a7f450@arm.com>
Date: Fri, 24 Jul 2026 18:22:40 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/22] mm: use mm_is_kernel() in generic page table code
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-4-44be8a7685d7@arm.com>
 <02565237-d777-4c63-8b17-817df59feac4@arm.com>
 <0d75daa4-a034-4094-bce5-57938d294163@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <0d75daa4-a034-4094-bce5-57938d294163@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/07/2026 17:07, David Hildenbrand (Arm) wrote:
> On 7/16/26 11:35, Kevin Brodsky wrote:
>> On 14/07/2026 16:03, Kevin Brodsky wrote:
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index d5e87624f692..c0244c0b0756 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -3394,13 +3394,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
>>>  	spinlock_t *ptl;
>>>  
>>>  	if (create) {
>>> - mapped_pte = pte = (mm == &init_mm) ?
>>> + mapped_pte = pte = mm_is_kernel(mm) ?
>>>  			pte_alloc_kernel_track(pmd, addr, mask) :
>>>  			pte_alloc_map_lock(mm, pmd, addr, &ptl);
>> As noted by Sashiko, this is a little problematic because if
>> apply_to_page_range() is called on efi_mm, then we will end up with
>> __pte_alloc_kernel() taking the init_mm lock, since that's hardcoded.
>>
>> That probably means we should pass the mm to __pte_alloc_kernel().
> Agreed.
>
> I guess we have to audit all existing init_mm usage?

Indeed, I looked through comparisons with &init_mm but really all
references to init_mm should be checked. Will do for v2.

- Kevin
