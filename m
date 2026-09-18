Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596551E443;
	Fri, 18 Sep 2026 20:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789762600; cv=none; b=ojt+CgmomFRMeXuwCMV5R14H7tF6whFmGWDAK0iXmAa438YioRqCEwr9qnBzdnaLEzP8hcBQW2KCDi9sHrndOeoblBpHL8viqUQIQywpvKSsWL0EetiKRmlpmTr+ysuFY04nya3aIa7OPkcMUd+ke6kIqW83aBukJ89vNNTYDNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789762600; c=relaxed/simple;
	bh=cv8vVpnnj2UGKdGTLGRsq3sewTuHTVIFj4FS+qbfjPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DaH0+Z6ht5pGFdHzf5cXI9o6ckthveTukdij+oULYZTa3KIgZTyZpEb/8a2fmeutn1ya+w3pncTzm6pUErOkg2EYtAL2knwLwuPm/z3uNw8W3yzUSVUQKIdPrMBBniNJ52nYme5wjW0Uj4NevXIdDWoYd0ilMHtiXd3lUbVg++Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+iUhoEv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+iUhoEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64EE61F000FF;
	Fri, 18 Sep 2026 20:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789762598;
	bh=VYaubdXxcUwKWOQn0o2fbISMmeIi1yDg6KMH9HfcrUU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C+iUhoEvnenOGPfNailivpYzYDg4gP4jzv2/IuKp3jznRu06ADQgAx90OX+8tzfVM
	 B9Yy395vy8nHpvbsNsEdnZK5BTNHynIWxmwy0l9LnA1UVoHyIG1OOQCcCRrzzuclMF
	 //WgBqUYUiSUqV67tzfCKagvLO4BFwf5WHeCYWmAC9MqXMuul4bJCEz2EhZg1Uv2CY
	 UD88hLIVddkWZCw39GqlrX9l/dWuu8zk1flxzWPU0XX+gPLgK5NcRtAoV8wHOegtM8
	 Bhp5RIgTGmlvDgkT2ZcDFnxXk2SYgSfJuCQ3chKm5Usrxe2Vof2AwfYkbb2yNb8uVC
	 I5+8TWkbDl+kg==
Message-ID: <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
Date: Fri, 18 Sep 2026 22:16:25 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 kas@kernel.org, kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 hannes@cmpxchg.or, shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com,
 riel@surriel.com, harry@kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, kernel-team@meta.com
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aq1RaH0eE0hZfNpr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/26 17:22, Breno Leitao wrote:
> On Fri, Sep 18, 2026 at 02:18:03PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/17/26 15:01, Breno Leitao wrote:
>>>
>>> Fair point, I'll clean up the naming in the next revision.
>>>
>>> I'll also add that ->empty field, which should help locate this bit
>>> faster and may let us skip the bitmap query entirely on the happy path.
>>>
>>> Anything else you'd like addressed?
>>>
>>> Good to know this moved the needle from "David hates this feature" to
>>> "David only hates the naming" -- I'll take that as progress.  :-P
>>
>> ;)
>>
>> I think the crucial part is to find a way to cleanly distinguish our source of
>> information, and also how the source does only apply to some memory.
> 
> Right, we have two source for poisoned page information, today.
> 
> 1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
>    poisioned, and will be passed around during kexec.
> 2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
>    touching it.

How are both kept in sync? See below.

> 
> And I understand that this design is fine, and we want to be easy to
> identify what we are querying on function name. For instance,
> I understand you confusion in range_contains_poisoned_memory() came
> from:
> 
> range_contains_poisoned_memory():
>    * What the caller reads: 
> 	* "is any memory in this range hardware poisoned?"
>    * What actually runs:
> 	* "is any bit set in an EFI table that a PREVIOUS kernel wrote,
> 	   at 2 MiB granularity, for this memory region?"

Right, and we should use that only as a source for anything during early boot.
So maybe it should hint at the "early" aspect somehow.

Which brings me back to: is the bitmap kept in sync when memory gets hwpoisoned?

That is: as memory gets hwpoisoned, will the bitmap get set immediately?

> 
> So, I think think this is a naming issue, and I need to think more about
> it. Maybe appending efiposioned (on data that is coming from EFI config
> table). Let me think more about it.
> 
>> Regarding this patch here, I'd assume it's sufficient.
>>
>> But I do wonder why we are walking pages when we have a bitmap to walk/process
>> at hand?
> 
> Because the counter has to agree with the page flag, and the page flag is
> not the bitmap.

But how could they go out of sync? I'd assume only for memory holes
(!pfn_to_online_page), but for that we don't need to test actual page flags.

> 
> PG_hwpoison in a block is the union of every source that poisoned a
> frame; the inherited EFI table is one of them, and it is the coarse and
> partial one.

So you're saying that this code is possibly racy with other setting code? Or
which other sources might there be if the generically called

range_contains_poisoned_memory()

wouldn't be able to identify it (and it only queries the bitmap?).

> 
> You might ask why I do not just count the bits set in the bitmape and
> multiply by the frames a unit covers.
> 
> That was my first try. It over-counts: a bit stands for a whole 2M unit,
> but only the frames that reach __free_pages_core() get flagged -- CMA
> comes back through __free_pages(), the initrd and __init memory through
> free_reserved_pages(), and KHO-preserved frames never get an initialised
> struct page at all.

Why are other hwpoisoned pages not flagged? If initrd or anything else is
hwpoisoned, we should not be running this kernel?

> 
> And the over-count cannot be undone later. 

The inconsistency is worrisome.
I wouldn't say that I hate it but it certainly has "great, more hwpoison hacks"
smell to it.

We have enough semi-broken hwpoison ... stuff ... in our code base already. So
I'm hoping we're not adding more to it?

> If the walk itself is what bothers you, the way out is not the bitmap
> but counting as we flag: hwpoison_boot_page() already knows the pfn, so
> it can bump a per-block-id counter in a small memblock array that
> memblk_nr_poison_init() then just reads.

The inconsistency is what worries me.

And that we have pages we are told are hwpoisoned but we seem to ignore that and
carry on with our kernel letting it boot?

> 
> Exact by construction, no walk. Happy to go that way instead if you
> prefer it.

Let me first try to understand the semantics here.

-- 
Cheers,

David
