Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E846DFF7;
	Mon,  7 Sep 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788792492; cv=none; b=T3LH3IvJtsXxVdVGTAcy6m5XVG2F/6LY+HITJUWSjcMXqpxMAzZL4EenCmvXiRwAh9bqqBwUEk2R2HHBYh3GnPkOmkt7SnRjNSkib/G+59jAJl8x3AcF3mPShWLB56NypEHmPTzHdLWUSWpaIuPx0XDUUkCXOb5lIRI5qSHWGm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788792492; c=relaxed/simple;
	bh=49Aa4H1qnvtFpsBuJ+dOSTi5a4PnkG/KF6KUQT5tTXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TosGg1g32YKCykCq5GWnM7IVTHH13pyKW1zMDU1HgIXiYbDKTxNWFgh8Uh7cNzchINYLs85yCE4RgvvDwEXXk+WHzny4TmhsYbo3rPMdz6OkQvhtuJgyK/UCsxs7CZYeNEgt/cGSpXszeIJa+kn+96bgMP3soxT8UCVXWJonQak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=LEdbSJ1v; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="LEdbSJ1v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ICYiSV43kYcKi3w/xRQ/Uas9brIt0oFdfmwI0JjU7/I=; b=LEdbSJ1vptFInpVZGgZaULk+vd
	DQo37X+q6ZRORyORTGdTprPmHsz6SWYLBydsnmvcR/ypYchTuPBNEz5dEaaQ/IlL9wG3KF84rhmLc
	tYOJUtnytxIrIUK91YfkX+U6C5DRjmsM/tF8IFi+i3g11jArKPgR/nAHRe9gSguz3O3uP4ltR70Hw
	p5dNMZ6wBrYxBXHx9Mt+/rGGGk6OOAc6v7KTPJJef7+pNWMRkHPIUiQsJx+UD6l0EZz191tpJvWU0
	m7txRONOs2qSVH/PVsXEBeWVTCCewenoKvSngeUrN2XTnxwZLGCfA5b+3kqhCVoIXvhLnPGWnYAJP
	+2NnDqtQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3adP-001a5u-0c;
	Mon, 07 Sep 2026 14:47:47 +0000
Date: Mon, 7 Sep 2026 07:47:41 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <ap7OBwOs8BKGUJh8@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>
 <apGSy78NoCov0MWr@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGSy78NoCov0MWr@thinkstation>
X-Debian-User: leitao

On Fri, Aug 28, 2026 at 02:59:43PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 05:03:53AM -0700, Breno Leitao wrote:
> > A EFI config table can only be installed while boot services are still
> > up, so the stub has to create it; the running kernel can only flip bits
> > in a table that already exists.
> > 
> > Size the bitmap from the top of usable RAM, which efi_get_ram_top()
> > works out by walking the UEFI memory map, since the stub has no max_pfn.
> > Bit N covers unit N counting from address 0, so the table tracks
> > max_pfn. Memory the firmware hot-adds later sits above it and is not
> > carried across a kexec.
> > 
> > One table has to serve every architecture, so efi_get_ram_top() takes
> > the union of the memory types they turn into RAM: what setup_e820() maps
> > to E820_TYPE_RAM on x86, plus the EFI_ACPI_RECLAIM_MEMORY and
> > EFI_PERSISTENT_MEMORY that is_usable_memory() accepts on arm64. Sizing
> > wide only costs bitmap bytes; sizing narrow silently drops the records
> > for every frame above the top.
> 
> x86 and ARM doesn't seem to agree what RAM is. On x86 it is by ->type
> and on ARM it is by ->attribute (anything WB/WC/WT).
> 
> is_usable_memory() only decides nomap. Everything is_memory() lets in
> lands in memblock.memory, and max_pfn is PFN_DOWN(memblock_end_of_DRAM()),
> so the top of RAM there can be a type that is not on your list.

Thanks. I will just ignore the memory types and get the base and top
based on the memory map descriptors.

Now that I need to get the phys base (from previous patch discussion),
I will need to get the range, doing something like:

	static efi_status_t efi_get_ram_range(u64 *base, u64 *top)
	{
	       struct efi_boot_memmap *map __free(efi_pool) = NULL;
	       u64 ram_base = ULLONG_MAX, ram_top = 0;
	       efi_status_t status;
	       int i, nr_desc;
	
	       status = efi_get_memory_map(&map, false);
	       if (status != EFI_SUCCESS)
	               return status;
	
	       nr_desc = map->map_size / map->desc_size;
	       for (i = 0; i < nr_desc; i++) {
	               efi_memory_desc_t *d;
	
	               d = efi_memdesc_ptr((unsigned long)map->map, map->desc_size, i);
	               ram_base = min(ram_base, d->phys_addr);
	               ram_top = max(ram_top,
	                             d->phys_addr + d->num_pages * EFI_PAGE_SIZE);
	       }
	       if (!ram_top)
	               return EFI_NOT_FOUND;
	
	       *base = round_down(ram_base, EFI_POISON_UNIT_SIZE);
	       *top = round_up(ram_top, EFI_POISON_UNIT_SIZE);

	       return EFI_SUCCESS;
	}

is it what you had in mind?

Thanks,
--breno
