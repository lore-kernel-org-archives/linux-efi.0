Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A59F5013D0;
	Fri, 18 Sep 2026 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745018; cv=none; b=ZWl6zEViUDfFfXjmoYoR3XbhCXezJkNIz/AJHVABiG8bqA7NZyHRh1+HBPtG23QEczrdwPB2sgXb15cXqjdruHloi2GAYfhbYpVZcZABbTcGFQq8wPHzRq6RVTDfcF4IjPBYEG0gtxUCwIVUCZgFpC5loza3Fpba8ThxZF8INi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745018; c=relaxed/simple;
	bh=AgtCk1IR2NnW2csAy3ZG2AVpreeujXaGKrRl+JM98QE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FFsyCMLGtKHPUYhMnQe2pYf+oiCSsKp0Sa/US5uOmf5LyLGGEsmZIIldblAWuQUCDZA2ZXWAt30WGKngyWHFwgS0zz220sHqf8lBSh6C9U6ovmFTomtX8u4YODEo+RXEzStFk98o3Wpr233+W7hbRicRUTSFV/z1oOJ3CJWT8lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Rd/CzOJ4; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Rd/CzOJ4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wEcH5E4AEzqLkF0Ir17t22goJx7MrsfhZ+RepQ30l9U=; b=Rd/CzOJ4Wdpu0aeXB7YKPQv3Px
	AjPJ9UARjooUYAYq3DQxrzJq+fUfuC5JUayYjmsvt8yCxCbZj0VeTNPtxZLNFTM8YMGDnrpqBM+Yq
	b/WUexOikEof1KpPd+VepJJAc8Dd6Ym2ANAzqeLfjDmhnYKZmNAouR29ft6Rmnr1cjRHt/D95Tq6J
	ktHYO3BsruwP/wwhSUheRPB8nqU8mlkq/t99Xgierr9euxpXG/HqAPyUQeiLSPVuSeLsQYjTB5bbc
	rNocdUJT8Ii177MByzY5QFDdsCVelqAU2U7i1reluFG+QDcod7VoHIYunualBSHBhMS57u3Gwj1r5
	yJ0+/IgQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7aQN-006oxZ-1y;
	Fri, 18 Sep 2026 15:22:51 +0000
Date: Fri, 18 Sep 2026 08:22:42 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Message-ID: <aq1RaH0eE0hZfNpr@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
X-Debian-User: leitao

On Fri, Sep 18, 2026 at 02:18:03PM +0200, David Hildenbrand (Arm) wrote:
> On 9/17/26 15:01, Breno Leitao wrote:
> > On Wed, Sep 16, 2026 at 04:51:40PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/16/26 11:35, Breno Leitao wrote:
> >>>
> >>> hmmm, I am not sure I see it that way.
> >>>
> >>> The loop only runs for a block the bitmap marks. On a machine with nothing
> >>> recorded the bitmap is all zeros, the range_contains_poisoned_memory() check
> >>> right above it returns false, and the loop never executes.
> >>>
> >>> What every boot does pay is that check, once per block. The stub installs
> >>> the table whether or not anything was ever recorded in it, so this is not a
> >>> NULL test: it is two 64-bit divisions by the unit size plus a
> >>> find_next_bit() over the single word a 128M block covers at one bit per 2M.
> >>>
> >>> The real cost (that "for loop above"), comes when you kexec (not on cold
> >>> boot -- given the bitmap is empty), and you are trying to init
> >>> a memory block that has poisoned pages into it. Which seems the right
> >>> trade-off, no?
> >>>
> >>> That said, can we do better? Yes. The silly win is to let the table say
> >>> whether anything was ever recorded in it, something like a
> >>> linux_efi_poisoned_memory->empty that the first recorded frame clears,
> >>> and return on that before the bitmap is reached at all.
> >>>
> >>> Is this what you are looking for, or something more drastic?
> >>
> >> Ah, that magical "range_contains_poisoned_memory" does a bitmap scan?
> >>
> >> I'm sorry, but that is absolutely confusing.
> >>
> >> There is no way someone will figure out that range_contains_poisoned_memory()
> >> queries some efi specific bitmap that won't even be able to represent any memory
> >> outside of it's range.
> >>
> >> I don't really have time to give a better solution, but starting with the
> >> naming, range_contains_poisoned_memory() is just absolutely misleading.
> > 
> > Fair point, I'll clean up the naming in the next revision.
> > 
> > I'll also add that ->empty field, which should help locate this bit
> > faster and may let us skip the bitmap query entirely on the happy path.
> > 
> > Anything else you'd like addressed?
> > 
> > Good to know this moved the needle from "David hates this feature" to
> > "David only hates the naming" -- I'll take that as progress.  :-P
> 
> ;)
> 
> I think the crucial part is to find a way to cleanly distinguish our source of
> information, and also how the source does only apply to some memory.

Right, we have two source for poisoned page information, today.

1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
   poisioned, and will be passed around during kexec.
2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
   touching it.

And I understand that this design is fine, and we want to be easy to
identify what we are querying on function name. For instance,
I understand you confusion in range_contains_poisoned_memory() came
from:

range_contains_poisoned_memory():
   * What the caller reads: 
	* "is any memory in this range hardware poisoned?"
   * What actually runs:
	* "is any bit set in an EFI table that a PREVIOUS kernel wrote,
	   at 2 MiB granularity, for this memory region?"

So, I think think this is a naming issue, and I need to think more about
it. Maybe appending efiposioned (on data that is coming from EFI config
table). Let me think more about it.

> Regarding this patch here, I'd assume it's sufficient.
> 
> But I do wonder why we are walking pages when we have a bitmap to walk/process
> at hand?

Because the counter has to agree with the page flag, and the page flag is
not the bitmap.

PG_hwpoison in a block is the union of every source that poisoned a
frame; the inherited EFI table is one of them, and it is the coarse and
partial one.

You might ask why I do not just count the bits set in the bitmape and
multiply by the frames a unit covers.

That was my first try. It over-counts: a bit stands for a whole 2M unit,
but only the frames that reach __free_pages_core() get flagged -- CMA
comes back through __free_pages(), the initrd and __init memory through
free_reserved_pages(), and KHO-preserved frames never get an initialised
struct page at all.

And the over-count cannot be undone later. 

If the walk itself is what bothers you, the way out is not the bitmap
but counting as we flag: hwpoison_boot_page() already knows the pfn, so
it can bump a per-block-id counter in a small memblock array that
memblk_nr_poison_init() then just reads.

Exact by construction, no walk. Happy to go that way instead if you
prefer it.
