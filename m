Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D90954145E;
	Tue, 22 Sep 2026 13:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790084715; cv=none; b=oSGBW56Q/1tsXbdFsgJ2REkv5ZkZJQvbo8WWvSIy94EbUD7lCFocnb1XpIoUd4ztwGljZMvH81T1nv/Nf55MgbVbrfmf2o/kV04QYP1zEgElNn1b6LEUx4Ye9hULaF/lmN2J5iB5kbUZnL3wv/KiypYdlTVjhbY6lNY7UnWbtNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790084715; c=relaxed/simple;
	bh=v9qyHtambzUjm8w7CFlZ9z7g517tSac197iyBh0N/YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bmkF2TkE91v9Vl4vSjfJQxOwRBT6HRAq05oK465PfOqmX54dS0nNoJIcZNkVADut91WQI8HTuxGRozOjdmJo7l0t5Rk+s8L/Smf1wByYed5XQlpliPZIszd5aMAgsevwXvdOT6vD9sxfn89Oml1iOnpAVI1zH3T80TfmCjTRLKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nXn4KJ5Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nXn4KJ5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96561F00893;
	Tue, 22 Sep 2026 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084713;
	bh=vQogC0AaDJB13p395CjVa0K8IHFuyempieXINkDBjmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nXn4KJ5YCt7msZuBG7rmlIi53n8XfETgu6aRe4PZFQxj1jg1WctsRsI2laIFPKxcq
	 KFMjOH9RfXFKsqQOGPuzUbM1RgW0kn9wvT8gHMwy6Ph6yX9efU/mBk0nhmEGM1d23+
	 1u7KQ5pwBezqsOs+QxAjhex7Kad0ZPmmkOhxooTgsWA5epfHfE5rHF+9hp9ODHG9eG
	 wGF9mgKd9HvUwnBMxAUyfAtAv8S4k4QW7tED3m8IwIQnoh+QcXgam+BAV5yJSeZNCv
	 mXg9ZdNE+JflO8CbRUQCBwti/hKJlm1tIbegXIgF56GBM8wz088RoehPQhlg9uCrFf
	 35pYat0LXjbHQ==
Date: Tue, 22 Sep 2026 14:45:11 +0100
From: Harry Yoo <harry@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
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
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Message-ID: <arKCBl7Ee7fSyKoR@thinkstation>
References: <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
 <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
 <arE3UjqPsxctWckg@gmail.com>
 <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
 <arJ5I9QHHBvuGH_F@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ5I9QHHBvuGH_F@thinkstation>

On Tue, Sep 22, 2026 at 01:51:08PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 22, 2026 at 01:33:51PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/21/26 16:31, Breno Leitao wrote:
> > > On Fri, Sep 18, 2026 at 10:16:25PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 9/18/26 17:22, Breno Leitao wrote:
> > >>>
> > >>> Right, we have two source for poisoned page information, today.
> > >>>
> > >>> 1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
> > >>>    poisioned, and will be passed around during kexec.
> > >>> 2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
> > >>>    touching it.
> > >>
> > >> How are both kept in sync? See below.
> > > 
> > > The EFI table is only written when there is a memory failure. That is
> > > the only thing that writes to it:
> > > 
> > > 	action_result() -> efi_hwpoison_record_pfn() -> set_bit()
> > > 
> > > You can see it on patch "mm/memory-failure: efi: record
> > > hardware-poisoned frames into the poisoned-memory table"
> > > 
> > > Then, when the kernel kexecs into a second kernel, the EFI config table
> > > is queried and the pages are poisoned from it at boot, as they are
> > > getting into the buddy allocator, in __free_pages_core().
> > 
> > I am not sure that is really the right place. That means we only poison free
> > memory. Shouldn't we poison as soon as we initialize the memmap, and check
> > whether any memblock allocations ended up on that poisoned memory and bail out?
> 
> __free_pages_core() is how we hand over pages from memblock to page allocator
> initially -- from memblock_free_pages(), deferred_free_pages() and
> hotplug. It is the right place to never allow them on free lists.

One limitation with that is that (as David mentioned)

by poisoning memory when freeing memory from memblock to the buddy,
the kernel might end up allocating the bad memory from memblock
during the early boot process. I don't think we have a functionality
to poison memory in memblock.

Hmm, will it be a problem if we just reserve area memblock....?
Well, that was the case in v2!
https://lore.kernel.org/all/aohldTtzE2GJ76md@thinkstation

IIUC the problem there was: when the architecture does not keep memblock
metadata, nothing prevents kexec from allocating memory from the
reserved space.

So, what should we do know? Reserve the poisoned areas in memblock AND
free those reserved spaces to the buddy to pass poison information? ;-)

-- 
Cheers,
Harry / Hyeonggon
