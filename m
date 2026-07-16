Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A9B7395AF1;
	Thu, 16 Jul 2026 09:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194436; cv=none; b=mKQJdYNl5UIvKisy+tU2WvNn835d6nHZc5HVpqeXDnZ2Eo9SP5ZvazT6Ob6XJ3rWaWDWikw68rw8YiQoAPDORdmRDkbu/CnC8T1VML2tcUdlx0x92Rl11xWaVzzz2tTKbC9iODbvpMS7P9JzATmveMD1YlIzVcHt8b2iMKsFH3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194436; c=relaxed/simple;
	bh=Jiq0eRIkC/oi6OkkmArmlbDUuLGok8mQdQh0yrF9YB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tY9JjpwF4dVDkwzFTH0O1AymNullGBqUbrOfla2Rlm3MoiE25T2Pjs3AcBgmV/py8MkE5VpuPgpKLhOFDW6I1xrVOLt5ZZFMGPDcEBN1ULWI6LRBkTKucwtSlQaSXrCpugYFzgez5w3u/Xoefn1Qq7M7t71sp1LsX9xZJtFpjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=IZauRYRl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="IZauRYRl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3B9CE1477;
	Thu, 16 Jul 2026 02:33:43 -0700 (PDT)
Received: from [10.57.83.230] (unknown [10.57.83.230])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1894E3F905;
	Thu, 16 Jul 2026 02:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784194427; bh=Jiq0eRIkC/oi6OkkmArmlbDUuLGok8mQdQh0yrF9YB0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IZauRYRl5ICTEYN8zkstcpXUOGTNSh9WC4OOdZL7resltad2ntP1sTBpfqQKq/LOy
	 NJ7R16g/TBidqac95gDoBdSGmrESHyLIJbhrl3Pu0YR5HqAz6dxQoYwAZrSwLCNC6+
	 RzqdaEwAda9C20R94gG615k7hLEu0nCXftHu3u9w=
Message-ID: <5ce00109-c0ea-43f0-881d-f58a0fda8dcb@arm.com>
Date: Thu, 16 Jul 2026 11:33:33 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/22] mm: introduce MMF_KERNEL flag and set it for
 init_mm
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Dave Hansen <dave.hansen@intel.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
 <20260714-remove_pgtable_cdtor-v1-3-44be8a7685d7@arm.com>
 <71045fa8-89fe-4a0b-a05b-67e19ce89834@intel.com> <alZOs30ziqa7l_Lq@lucifer>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <alZOs30ziqa7l_Lq@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/07/2026 17:04, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 14, 2026 at 07:47:43AM -0700, Dave Hansen wrote:
>> On 7/14/26 07:03, Kevin Brodsky wrote:
>>> +static inline bool mm_is_kernel(const struct mm_struct *mm)
>>> +{
>>> +	return mm && mm_flags_test(MMF_KERNEL, mm);
>>> +}
>> Could we give this some nice comments explaining what a kernel mm is,
>> please? Part of the problem with the init_mm checks is that they're
>> magic and it's not always clear what's special about init_mm.

Agreed, we need to define what this property means exactly, and your
comments on patch 14 show that extending it to efi_mm isn't necessarily
as benign as it appeared to me at first.

My motivation really is about how page tables are handled (in particular
whether ptlocks are used), so as you suggested on patch 19 maybe this
flag should be narrower in scope, and the naming should reflect it.
Possibly MMF_KERNEL_PGTABLES? That's at least one thing that should be
true of all of init_mm, efi_mm and tboot_mm: their page tables use
kernel permissions, not user, and should follow the same rules including
not using ptlocks.

>> Maybe start with this list?
>>
>> 1. There's only one of them.
>> 2. All kernel threads share it. tsk->mm is the same for all kernel
>>    threads.
>> 3. It holds the reference copy of the kernel page tables
>> 4. Userspace can't be entered when it is the current mm
>> 5. It has different TLB flushing rules than userspace mms
>>
>> I _think_ those are universal across all architectures.
> Well point 1 isn't true of efimm or tboot_mm so we possibly need a better
> name :)
>
> "Special" is overloaded too much already. I quite like "eternal" so:
>
> 	static inline bool mm_is_eternal(const struct mm_struct *mm)
> 	{
> 		return mm && mm_flags_test(MMF_ETERNAL, mm);
> 	}

Cheeky but why not! I do wonder whether this conveys the right idea
though. The main point of this flag is that page tables are
allocated/initialised/locked differently; in principle you could have a
temporary non-user mm.

- Kevin
