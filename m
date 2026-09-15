Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1895633C1B4;
	Tue, 15 Sep 2026 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789480855; cv=none; b=kxPDNrsCesDPGDX5jLx3PYbfwus1SyLy9PHqQkURGXBuqU1wey98b/oCJF9FZeZUvWaO8fRQAB2d2DuARfQMWoiHRTnvU7HYlxHMO5N+RF00mKSqmilQGnY1ePQ03LAwXjp/VRjG2wds08qMb/JdYw8LFdxNXDk5atyeDIxpcx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789480855; c=relaxed/simple;
	bh=+5wQwKbqcBslcbuDlmsI4q6fFTEx6nmV4uQisRE6REo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L1fWFpyZICjcgJ6n6s1/ai+wjJpnshqsL3znFixWiC27IXDAxwhsnh0kkCeDTMGXIc6O3a6zrQFs2f6tZ75rVI81g6RO4bv5MVKJbvL70p9BsA/ce+xZUFWQ4Z7dHRNvjqb6VzU+qQrDGvdqsLIZahuKBhQKD/V75V7gJLSAEKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=vqajrmCt; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="vqajrmCt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=P0JxQYBjmO1vYJSywAUW1OOBMLXNRVrkgSCeVPxsXPU=; b=vqajrmCt1aMjHrgjKgf9nsMc8t
	1HTSPbrZ2Nu9GG4g/qb+VIW8VrZfKXNfmRiDThFCCgEbVDUPaF2MOej9pzOvolOO1Q4ULqu61+vWA
	JUHnoFVkpIBkIeFhbh44R1GkHpUH4RmS/d8uEKQHexTpSubRTJ9JmtyjJP5ZB71J43qi+QIxG0miR
	JC65jdSlXGG3axUCE8+IDglXpMmSaBmLQyZ8pivc9K5fqmz88ngwG++duTsmzfmH7dJnPqJVHuvQo
	Z58o30vNw2QLRJymW71I3AEVrmdxMAUI0O3y/MSbGXx0CDPON0t7fbMHwIjQ6x6hWv69xAJRAf1gQ
	09t+H54A==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6Thi-004RXm-32;
	Tue, 15 Sep 2026 14:00:11 +0000
Date: Tue, 15 Sep 2026 07:00:02 -0700
From: Breno Leitao <leitao@debian.org>
To: sashiko-bot@kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Zi Yan <ziy@nvidia.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, shakeel.butt@linux.dev, kas@kernel.org, 
	Ard Biesheuvel <ardb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, x86@kernel.org, hannes@cmpxchg.or, 
	Thomas Gleixner <tglx@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Ingo Molnar <mingo@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, kernel-team@meta.com, 
	driver-core@lists.linux.dev, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
	rmikey@meta.com, riel@surriel.com, harry@kernel.org, kexec@lists.infradead.org, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 3/9] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqlPIbH1zCHtPNcZ@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-3-3bc7a57bd503@debian.org>
 <20260915131527.AFB261F0089A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915131527.AFB261F0089A@smtp.kernel.org>
X-Debian-User: leitao

On Tue, Sep 15, 2026 at 01:15:27PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] mm: efi: integer overflow in poisoned memory bitmap allocation on 32-bit
> --
> 
> commit 591eef51f672049b14b50a75d67dac823925a19a
> Author: Breno Leitao <leitao@debian.org>
> 
> mm/memory-failure: libstub: install the poisoned-memory EFI table
> 
> This commit introduces a new poisoned-memory EFI table installed by the stub.
> It sizes a bitmap based on the UEFI memory map to describe the RAM span and
> allocates it as EFI_ACPI_RECLAIM_MEMORY so the next kernel does not take it
> as free RAM.
> 
> > diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> > index 48f93f7758e9e..9c66e06c972c5 100644
> > --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> > +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> 
> [ ... ]
> 
> > +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> > +							  u64 bitmap_size)
> > +{
> > +	struct linux_efi_poisoned_memory *pm;
> > +	efi_status_t status;
> > +
> > +	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> > +			     sizeof(*pm) + bitmap_size, (void **)&pm);
> 
> [Severity: High]
> Could this allocation size wrap around on 32-bit EFI architectures if the
> memory map is extremely sparse?

This feature is limited to 64-bits only, so, these wraps on 32-bit
architectures are not real:

config EFI_POISONED_MEMORY
	def_bool y
	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
