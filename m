Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E50136215D;
	Mon,  7 Sep 2026 15:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788794651; cv=none; b=t3dC52fKonvo+7tuHa8aYxluaf3JFcn9Ea7QcdHKqIGsNZE5D/4Bq2OmFIKvq23SlEbHu2NxXBqsB8ljmOaGOFQ3Tk4/Uuq/LjHqu/Nrcdezx4s4emFHzUWeRr1uNXRjHjk1eYw+VwT5rMkuNjCknlRoEiz72Zn8ptCkGi61HaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788794651; c=relaxed/simple;
	bh=77OB6XLSPGdx1mrtaqK7OaOPUS+8dLBkb8o1P9wfP/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o2Y24HnE2Sa4brKQQ27NDwtNuXKFgPImg/C88fmauW3jZE5p9bXx4XvbHXeSvQ2E2iHywE5B5RdKU5QRXX8juXoj9hsSPxB0L3NdtHOGlJfgdycyTRg+VQQgBaBOXaVBB2f5Z42cqGe5XiMLR03Nemyq9fIo1DsAwJUwqgWRFdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=TwhS7pT7; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="TwhS7pT7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6c435i0Ybwx2SpPArP3T09GV23HR1EORsj2zutcyrsA=; b=TwhS7pT7b6MrSEMKFQfGDeSRIA
	mv6TiijYkOzV3ljABhwcKRIImezX6VdLF59YDNzKwVu9XJSBnGJI+8bj+Zieec2dbmSX+dI64ObiU
	C6HdX1Joy5LOL3lb5qIr5LcgDoacSanCjFIsu3Kvf6RuotHWPs8FxHINv1Mo6Jw8NyZsEJZmyioRK
	Ei8ZzeJcwumibhpITvX9zwoCt14QChw+J8HOtulb9LVA4kEShJ+v6nO0XqbRUzgWQ7L1V+pSaiCHT
	tbHwZpkOABgvU1Qwurrtp391g+wt6DKKAT7yXWR5gRPtkmNkPLKZHrevAIYTNDGTBgmBkr3mc7fuO
	e3n1TF0Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3bCK-001bGs-0M;
	Mon, 07 Sep 2026 15:23:52 +0000
Date: Mon, 7 Sep 2026 08:23:46 -0700
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
Subject: Re: [PATCH v3 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Message-ID: <ap7Tup6mahjIljVF@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-3-6f79c4b605bc@debian.org>
 <apGWUWi5-RbhFHpe@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGWUWi5-RbhFHpe@thinkstation>
X-Debian-User: leitao

On Fri, Aug 28, 2026 at 03:11:10PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 05:03:54AM -0700, Breno Leitao wrote:
> > +#include <linux/memblock.h>
> 
> Is it leftover? I don't see any memblock usage.

Yes, good catch, I will remove.
> > +#include <linux/mm.h>
> > +#include <linux/overflow.h>
> > +
> > +static struct linux_efi_poisoned_memory *efi_poison __ro_after_init;
> > +static u64 efi_poison_nbits __ro_after_init;
> > +
> > +static u64 __init
> > +efi_poison_usable_size(const struct linux_efi_poisoned_memory *pm)
> > +{
> > +	u64 nr_units = DIV_ROUND_UP(PFN_PHYS(max_pfn), pm->unit_size);
> > +	u64 bytes = DIV_ROUND_UP(nr_units, BITS_PER_BYTE);
> > +
> > +	/* Whole words: the bitmap is reached an unsigned long at a time. */
> > +	return min(round_up(bytes, sizeof(unsigned long)), pm->size);
> 
> Hm. Why bother to clamp to max_pfn? What's what's wrong with just using
> pm->size directly?

The clamp is a min(), so it can only ever make the kernel use less of
the table than the table claims, just a silly and cheap optimization.

That said, pm->size is more than enought for now, and we optimize later.

I will drop efi_poison_usable_size() completely and replace it by
pm->size.

Thanks,
--breno
