Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA4F844AB6B;
	Thu, 17 Sep 2026 13:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650164; cv=none; b=e9e0oYHOTMtbhrQe548uy0Cs5ezVQV2nPbEpZ1G8ig7KT6vK+ACVNtCeEx9CjMToFTJr4tgVfFP9mI6fncXQJKYoahtsqdU2Yf/xHhopdAWVWmng4HLbcTosZTN6mZiirwTa7xRfy3p7B5i5b3xFpPzrKr9t7hqn45pTmcR9lps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650164; c=relaxed/simple;
	bh=HiAcY0mLKb4q+iA1pwDijtoI7iZdaVGUa+MaCOA6pUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MfmuclxCL+QWJslDbhZnK9EXdgNvqRySBk9FfsWjqS07gbcxWII+0HmFLAFWMFLuNACMdvgKXhwvpvGwozfymIwNnhrlMqoCgBKBcOqoYI+uApEsY5voEiJKplyyTH0GX/t0wlptShPnvhRgvl+NqM2KM6MjfrY/gcYgs2dtElY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=HUfpaOBv; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="HUfpaOBv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Gi8aEfK6gCS22vyEarpUsr6Hihppu2IQ4JZrnnv3f+s=; b=HUfpaOBvlUMAHPSpVKl1cg93qz
	KXOCSwlbHp33fQy1tODtoNm+wK/hLhdGOwAgob1rF80at4PG1Ji1WR8d09odLnChaiMXjXCUW+VOh
	X90aUzssScG4E9JI58m+o0bf6rqdWsfzxJSj+KpqKT2SqIRMfEPGaLsY5k60aOreSFUM/YZAflK85
	xVmpSKS/iKEmymgRe+ILwgtooc2C2OydulTjF00WkTf5B5TQM4GBBNjgpTMPld4pv6C0ALjKjlnS7
	q1Ul0HRgXganFdkmVBZ+9XQIrMfYt9PPN9nQ4g3ITWymsEhjro60qagJfPugcTL1vSK20kxPpOcno
	Sz5WaqNA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7BkC-005xUi-27;
	Thu, 17 Sep 2026 13:01:40 +0000
Date: Thu, 17 Sep 2026 06:01:32 -0700
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
Message-ID: <aqvHHHuWJ-y4WRJZ@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
X-Debian-User: leitao

On Wed, Sep 16, 2026 at 04:51:40PM +0200, David Hildenbrand (Arm) wrote:
> On 9/16/26 11:35, Breno Leitao wrote:
> >> That just slows down boot unnecessarily on 99.9999999999999999999% of all
> >> systems out there.
> >
> > hmmm, I am not sure I see it that way.
> >
> > The loop only runs for a block the bitmap marks. On a machine with nothing
> > recorded the bitmap is all zeros, the range_contains_poisoned_memory() check
> > right above it returns false, and the loop never executes.
> >
> > What every boot does pay is that check, once per block. The stub installs
> > the table whether or not anything was ever recorded in it, so this is not a
> > NULL test: it is two 64-bit divisions by the unit size plus a
> > find_next_bit() over the single word a 128M block covers at one bit per 2M.
> >
> > The real cost (that "for loop above"), comes when you kexec (not on cold
> > boot -- given the bitmap is empty), and you are trying to init
> > a memory block that has poisoned pages into it. Which seems the right
> > trade-off, no?
> >
> > That said, can we do better? Yes. The silly win is to let the table say
> > whether anything was ever recorded in it, something like a
> > linux_efi_poisoned_memory->empty that the first recorded frame clears,
> > and return on that before the bitmap is reached at all.
> >
> > Is this what you are looking for, or something more drastic?
>
> Ah, that magical "range_contains_poisoned_memory" does a bitmap scan?
>
> I'm sorry, but that is absolutely confusing.
>
> There is no way someone will figure out that range_contains_poisoned_memory()
> queries some efi specific bitmap that won't even be able to represent any memory
> outside of it's range.
>
> I don't really have time to give a better solution, but starting with the
> naming, range_contains_poisoned_memory() is just absolutely misleading.

Fair point, I'll clean up the naming in the next revision.

I'll also add that ->empty field, which should help locate this bit
faster and may let us skip the bitmap query entirely on the happy path.

Anything else you'd like addressed?

Good to know this moved the needle from "David hates this feature" to
"David only hates the naming" -- I'll take that as progress.  :-P
