Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206732C08D0;
	Tue, 22 Sep 2026 12:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790080497; cv=none; b=DNR4VnZiZc2gOMHek+zE5r6jPDkF/RCyJaC/7ipUMx48puOY4Dm9NhFGjnr02tGkcdvwXEbiMZS0sJZRTrdIJMLoe4u4l+JWuHY2R1A/zoZ8sx6m7m3hnQITkjE9Q4HFFRwoAtDBBYqDQpMbzSTMyWd1/d1ulvcn+4LzuWDnWSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790080497; c=relaxed/simple;
	bh=TFhrQlMEGgMHz2W9rVsCr3+0JhHuhHn0+XE1zAx6XcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZFNy3FFZ2ok7cqGD3YdciX9LbZD7AMhMZcHcN9g3G4Iq+TciTF0y/eXtKi0bV9WEZE9kHzFWBElmZRA0Iw6J76m6pVUIHNc1D5q3ZpigegmBTvpIEznpY7E3lu6iosKyDu4GSvoSyXn2UyPp26i5OefpllzupWP/JtX54dEpk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=ApDtHShH; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="ApDtHShH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/b2H83sBKLfZiu8TvApIXihDp5UwTxcEl76P0l59dTc=; b=ApDtHShHX9N6Hse7lBfOPq8nb+
	TgSY0Dz571CzSHnonuArzlVIuV7weX7CI3axguEuQWcj0BzXmXuLDDqrzOazmizDLYycePe+wsP6J
	SXQEt3zut1yHJ+rcqSJTH7kKPtZxQrXcDcuP5MtN6UzaKC+czp1RebfbbNH2/YmUuYt4NGYNItEl8
	vWOYEyEWHdXMSNzv8P3B4eTZ7c6pdJ4pnYmV/+Y6jCBUOAoTz5qF4FPI1NuSEecEh2ShBZ3T/aKEz
	wg1V5O840zlQLXVW+DXm18LCxo4pi4E48gE8KqJJ5derJP9tKG2ucy8SJjybNSKzyS0BsuPtFRwIP
	HWocWaJA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8zhO-002yym-2k;
	Tue, 22 Sep 2026 12:34:15 +0000
Date: Tue, 22 Sep 2026 05:34:06 -0700
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
Message-ID: <arJqVWN-prvI_0NP@gmail.com>
References: <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
 <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
 <arE3UjqPsxctWckg@gmail.com>
 <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
X-Debian-User: leitao

Hello David,

On Tue, Sep 22, 2026 at 01:33:51PM +0200, David Hildenbrand (Arm) wrote:
> On 9/21/26 16:31, Breno Leitao wrote:
> > On Fri, Sep 18, 2026 at 10:16:25PM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/18/26 17:22, Breno Leitao wrote:
> >>>
> >>> Right, we have two source for poisoned page information, today.
> >>>
> >>> 1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
> >>>    poisioned, and will be passed around during kexec.
> >>> 2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
> >>>    touching it.
> >>
> >> How are both kept in sync? See below.
> > 
> > The EFI table is only written when there is a memory failure. That is
> > the only thing that writes to it:
> > 
> > 	action_result() -> efi_hwpoison_record_pfn() -> set_bit()
> > 
> > You can see it on patch "mm/memory-failure: efi: record
> > hardware-poisoned frames into the poisoned-memory table"
> > 
> > Then, when the kernel kexecs into a second kernel, the EFI config table
> > is queried and the pages are poisoned from it at boot, as they are
> > getting into the buddy allocator, in __free_pages_core().
> 
> I am not sure that is really the right place. That means we only poison free
> memory.

Right, and that is a real gap. A frame only reaches __free_pages_core()
if it is handed to the buddy allocator, so anything this kernel already
took from memblock -- the memmap itself, early page tables, percpu --
can be sitting on a recorded frame with nobody noticing.

> Shouldn't we poison as soon as we initialize the memmap, and check
> whether any memblock allocations ended up on that poisoned memory and bail out?


That is close to what I had until v2, where the bitmap was walked at EFI
parse time and every set unit was memblock_reserve()d:

	for (off = 0; off < bitmap_size; off += PAGE_SIZE) {
		...
		for_each_set_bit(bit, map, nbits) {
			u64 unit = off * BITS_PER_BYTE + bit;

			memblock_reserve(phys_base + unit * unit_size, unit_size);
			nr_units++;
		}
		...
	}

Set the full v2 patch at
https://lore.kernel.org/all/20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org/

Kiryl raised some concerns, such as x86 does not keep memblock past
boot, and kexec picks placement from iomem_resource via
walk_system_ram_res(), which memblock_reserve() does not touch. So the
frames stay out of buddy, but the next image can still be placed on
them, and since nothing sets PG_hwpoison none of the existing hwpoison
users see them either.

Most of the discussion happened here:
https://lore.kernel.org/all/aog_uH5fTsJzXjjx@thinkstation/

v3 then poisoned the frames from mm_core_init(), right after
memblock_free_all(), taking them back off buddy. That breaks with
CONFIG_DEFERRED_STRUCT_PAGE_INIT, where the struct pages above
first_deferred_pfn do not exist yet at that point, and Kiryl's other
point was that the shape was wrong regardless: flag the frame on its
first add to buddy, not after buddy is up.

See the discussion at:
https://lore.kernel.org/all/apGbDOnPm5VXP5ez@thinkstation/

Which is how it ended up in __free_pages_core().

> >> The inconsistency is what worries me.
> >>
> >> And that we have pages we are told are hwpoisoned but we seem to ignore that and
> >> carry on with our kernel letting it boot?
> > 
> > The walk exists precisely because of that inconsistency: the counter has
> > to match the frames that actually carry the flag, and the bitmap says
> > more than that.
> > 
> > If we drop the page walk, then there is change for inconsistency, but,
> > as-is, there is no inconsistency.
> > 
> > So, I am planning to keep the page walk above, when there is a poisoned
> > page in the memory block, avoiding any inconsitency.
>
> How about we keep it very simple and don't mix information from two different
> sources? That is, remove that bitmap scan here entirely. We should process the
> bitmap exactly once when initializing the memmap.
> 
> From that point on, the memmap should be our reliable source of information.

Sure, is this approach better?

  - the bitmap is read as the struct pages are initialised, and the only
    thing it does there is SetPageHWPoison();

  - __free_pages_core() keeps the hook but tests PageHWPoison() instead
    of the table, so a recorded frame is still held back before it can
    enter buddy;

  - nothing else queries the table.

One caveat on "exactly once": if that means one pass at one point in
boot, it is what v3[1] did -- hwpoison_init_boot() from mm_core_init(),
right after memblock_free_all() -- and it does not work. With
CONFIG_DEFERRED_STRUCT_PAGE_INIT the struct pages above
first_deferred_pfn are not there yet at that point.

Link: https://lore.kernel.org/all/20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org/

So I _think_ we want to do it once per frame, as that frame's struct
page comes up. __init_single_page() is the single function they all pass
through. Is __init_single_page() the right place to query the bitmap and
mark is as poisoned?

> For this code here, just remember globally whether we hwpoisoned any page. If
> so, just walk the memmap. If not (the 99.9999% of all systems, no need to scan
> anything).

Yes, and the counter already exists: num_poisoned_pages and we can query
it. I am also planning to add something similar in the EFI table, like
an ->empty field, which will be cleared when a bit is set, avoiding
doing bitmap walk on the happy path (not a single poisoned page).

Anyway, range_hwpoison() short-circuits on it today,

      if (!size || !atomic_long_read(&num_poisoned_pages))
              return poison;

so memblk_nr_poison_init() can gate on the same thing and walk the
memmap, with no EFI call left in drivers/base/memory.c at all. That
disposes of the misleading name there too, which was where this
started.

Now, the half I am less sure about is checking whether a memblock
allocation landed on a recorded frame. Poisoning at memmap init cannot
prevent that -- the memmap is itself a memblock allocation, so the
struct pages do not exist while the early allocations are being made --
it can only detect it afterwards, as a pass over memblock.reserved
before memblock_free_all().

The alternative is to bring v2's memblock_reserve() back purely to keep
the early allocator off those frames, and still poison at memmap init
so the flag is there for everyone else. That gets both properties, at
the cost of frames that are Reserved and HWPoison and never in buddy,
which I have not thought through for unpoison.

Thanks for the suggestions!
--breno
