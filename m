Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FFE301486;
	Tue, 22 Sep 2026 10:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790073586; cv=none; b=R3xe5i1JKbGq+2Or5iIysQBh5XAE6sH6oybZjjiXRU4vrDu9/rGI/zsdSosofUQCxOV1yd4bTTC6wuiZzgrkEEQXB5eZs0zdG63On9KO1eCM1GbExOI/n43mA4xlXUrpp1DG8rNCawrJfLY0+aDQBCdAwrDZp3Yw/j3J6zonFNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790073586; c=relaxed/simple;
	bh=wifZY/d5vFSvhmi1LxdZcopZYwRMLPQMjxZ/vhPfDjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFUDH3BRNOHAJhzmbb9W0CPeADHYcB9aJnozQ8FHQfELVoH4gy5B9geGToOa7TkTYUtUdHzK+zXu913krt4TE6Tm/Y+7Ol3F1CtU5TUN9YaXETjm7MemzAmi+Ah2csWoaR69gKktee20Xp3pKxpvhhuqD28U4FULmCPfRwXzSU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=LAJ1KE5f; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="LAJ1KE5f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zkVHXvH6aSNeIiHZsZBLuLPhi5KT7D0PnrCA/uC+Aww=; b=LAJ1KE5fYZ3ToH2JjALIy5lMHl
	M59CT9fHAa0I8HqTqLbRMlnd8o7XvcrxwQXQ6N5/lNLK5KUBcpIkeqh5xwIsQsCF8VO1QMRu2Z/0q
	WX+cDPCgXBS6yzxPgKsUAXJ0sShUnGzJiy6uHMD+mA/E5U1zQp+MF/MwH588ohKVp40f7XrAV2D2r
	z1o1STvQfbXYwaW89gLnyAarb1UbHwFj8HQdGkcs8ImImluh0IcAEH/0XjoV5I4CAYQqIEMmP7z7F
	AKvnZhso8fTnU9daXknVjmAVBb5oTTAjvQ1/ZcIqnO/MulZ1ik0pzxnwUI7OU0bnQvnGja5vlJkgA
	aihXbVZA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8xuL-002vHv-1e;
	Tue, 22 Sep 2026 10:39:29 +0000
Date: Tue, 22 Sep 2026 03:39:21 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com, 
	Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev
Subject: Re: [PATCH v5 0/9] mm/memory-failure: keep hardware-poisoned pages
 out of the next kexec
Message-ID: <arJaHrZfWSQXFgWP@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
 <arJBkNOgbR8NrgFP@gmail.com>
 <16baab50-692c-308b-d60d-1b0a328df1e3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16baab50-692c-308b-d60d-1b0a328df1e3@huawei.com>
X-Debian-User: leitao

On Tue, Sep 22, 2026 at 05:29:14PM +0800, Miaohe Lin wrote:
> On 2026/9/22 17:14, Breno Leitao wrote:
> > Hello Miaohe,
> > 
> > On Tue, Sep 22, 2026 at 02:27:59PM +0800, Miaohe Lin wrote:
> >>> A bit is never cleared, which is a known limitation: it stands for a
> >>> whole unit, so an unpoison of one frame cannot tell whether the unit as a
> >>> whole is good again.
> >>
> >> Thanks for your patches. I have a question about unpoison: If a bit is never
> >> cleared, after we do some memory-failure+unpoison tests, kexec will lose the
> >> tested memory without reboot?
> > 
> > Correct, A bit stands for a 2M unit, so every tested page that falls in
> > a distinct unit costs 2M in each kernel after the kexec.
> > 
> > Worth being precise about the state today: the unpoison itself works.
> > The frame goes back to the allocator and num_poisoned_pages drops. Only
> > the bit stays, so the next kernel poisons the frame again. Test loop
> > in, memory out, and nothing gives it back.
> > 
> > Important to say that nothing block us from unpoison the bitmap, and in
> > fact my initial patchset had it. I also _think_ we should unpoison the
> > bitmap once we unpoison the page. 
> > 
> > I have just kept it out of this patch in order to simplify the patchset and
> > get the basis correct, and then evolve on top of it.
> > 
> 
> Makes sense to me. Thanks for your work.

Ack. I will continue it without the unpoisioned bits for now, and as
soon as this series lands, I will add the unpoision mechanism on top of
this infrastructure.

Thanks for your support so far. I will send a new version soon, with
the fixes I am accumulating so far.

--breno
