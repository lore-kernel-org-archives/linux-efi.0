Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49343D7D89;
	Wed, 16 Sep 2026 09:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551374; cv=none; b=ILHaIrNFZsen1neeegdXEntV2Md1UBwhOqPzut6cM+QLT3zMP2FX7kB4kG5m9aJF/GlpCFz4XEHa9e5cq/Ve5MgCdViNsbTRoAxaKjBn0Q4KGlb/kMADqpQx3O1dJokcztNoEzeUOmHy3hAntZERl4OolPGYC3vU1dFBzS90NDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551374; c=relaxed/simple;
	bh=C4Pgd/QE7Npkzcs4mLoH2ntp6E0i7P7iP2KMXQdLf4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GiqVvaeqinEMjmRR/qpcrP7Pkt9JWV5i+JNOdgGGycRkzqtozJXB6cVgNysdZXxTbutVOT9/EHGSDL/T6eGs3rmC5vmEw6X3QzqvBOhuMV/LGHFV5zT15fk6M1WwA4Sp+DqIrNmdGpq1ZLs4++8XPHhlR5j/kKjVAn8CF/m5JD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=FG+PhcCJ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="FG+PhcCJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lQusxUCZOg61iBhz+gh2H7namnoGRC3noT9Nzn5HIqQ=; b=FG+PhcCJdohk4nnU98iT/zoR5N
	BCgB6P043DOhKlGyArs7g31LKrnMGQt2zWbGrRVZDTebMTiVX0hrOpMLGDYK9SjK4Nbhr1XO9Z/oe
	9kYRquCRmoHMSfDt5RL9ZF+HqohR7f9iO3YfQb2nxLasS8aJC+6WBFFBZVtfu5594dMAJdGAlSEor
	T//McaeWE/JqURKCLjDalwcD9SxGNYRZ1Ndf6cU2qsZSXzppknaqswzTmRM1m9nMELechoHJ3sF6b
	SPpSFa5JtX7hBI+K/IGPBKSM0MEmySJV5UgazfmjiDgO8UjZf6aP6k+M7p32sRjJG2WLJIf/ZesHH
	AEqfN1nw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6m2s-0054bo-2i;
	Wed, 16 Sep 2026 09:35:15 +0000
Date: Wed, 16 Sep 2026 02:35:06 -0700
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
Message-ID: <aqpczrtIwSG948iv@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
X-Debian-User: leitao

Hello David,

First of all, thanks for your time looking at this patchset.

On Wed, Sep 16, 2026 at 08:48:56AM +0200, David Hildenbrand (Arm) wrote:
> On 9/15/26 14:53, Breno Leitao wrote:
> > +static void memblk_nr_poison_init(struct memory_block *mem)
> > +{
> > +	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
> > +	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
> > +	unsigned long i, nr_poison = 0;
> > +
> > +	/* A hotplugged block is created before its pages are online. */
> > +	if (mem->state != MEM_ONLINE)
> > +		return;
> > +
> > +	if (!range_contains_poisoned_memory(PFN_PHYS(pfn),
> > +					    nr_pages << PAGE_SHIFT))
> > +		return;
> > +
> > +	for (i = 0; i < nr_pages; i++) {
> > +		struct page *page = pfn_to_online_page(pfn + i);
> > +
> > +		if (page && PageHWPoison(page))
> > +			nr_poison++;
> > +	}
> 
> That just slows down boot unnecessarily on 99.9999999999999999999% of all
> systems out there.

hmmm, I am not sure I see it that way.

The loop only runs for a block the bitmap marks. On a machine with nothing
recorded the bitmap is all zeros, the range_contains_poisoned_memory() check
right above it returns false, and the loop never executes.

What every boot does pay is that check, once per block. The stub installs
the table whether or not anything was ever recorded in it, so this is not a
NULL test: it is two 64-bit divisions by the unit size plus a
find_next_bit() over the single word a 128M block covers at one bit per 2M.

The real cost (that "for loop above"), comes when you kexec (not on cold
boot -- given the bitmap is empty), and you are trying to init
a memory block that has poisoned pages into it. Which seems the right
trade-off, no?

That said, can we do better? Yes. The silly win is to let the table say
whether anything was ever recorded in it, something like a
linux_efi_poisoned_memory->empty that the first recorded frame clears,
and return on that before the bitmap is reached at all.

Is this what you are looking for, or something more drastic?

Thanks for your review,
--breno
