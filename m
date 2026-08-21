Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF6A494803;
	Fri, 21 Aug 2026 14:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321010; cv=none; b=G+EMcQ27Rq9slrV8Ql9LLBHW5+LzI0ojCoez+22ILmTrqeERgj8GfzKXxeH6FiiuRPaDnXnjGE1EpP5aY7A1+bpXVfoDKwm0GeLg3wcyA0yHzKZxRXvcTEppqhfIc+yoxfjeGYtfRuYAxj9LcXQsEgxMhUH1YQjm8QWsDuRWZOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321010; c=relaxed/simple;
	bh=u/RQKBphUH4WnE+vJCnb34MhsptQyWfw8Dejk+d/Yko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dI0qNKjvQVMVycsjjSmEl42No89e+6ccx5lUN16K+F/KVLJvt/8nRLv7qf2oGegFQOVDz0xQfmVfZkUhYnUZXbnU2+NVTxrn7kUcG5iaD31pr8mwD6m/bvAK4A9XgrTWzynBWaoK4Et/NO7lgBQrwPp0NsT1HsF7ghaRjIFXbw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=v4t1fRjU; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="v4t1fRjU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F32vh1cW82UZDB5HN9KvxKsrYdAwaYCJf4XRNKjoE0k=; b=v4t1fRjU+hHjijXSBFO1sRJvkK
	oNEaUfynGiwy3mvwySfb6wmBhB535/V1dlFfhVZQH8XmuvHnIUL5t+RcaPLZEoL5wMwqO0PLjpsq8
	O64R4Wy6JTsXXT1plbPyI9oHzfxLd0TJ16c6SQ1cNDojZa69mcnQSzY5G9RKDGp8ndWWVDOFo+s2z
	PiQseMLGdmzrhXrgmU1Ft01i7UR08O/6c5NOyNklVfbEQsBDKyx3Ganv8AHFbOLZvD3LdUrp8QjCM
	cU6q9MJot6cWTCwGZHATXDkxh7/TrZxB+8Z4g0LP2TQKQdCCr5NCiH6p6QjMPvMurGwGnExILcNXJ
	v2j39dYg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxPpv-00BOEL-2E;
	Fri, 21 Aug 2026 14:03:12 +0000
Date: Fri, 21 Aug 2026 07:03:06 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aohIF6MmjiQpbz5j@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aog_uH5fTsJzXjjx@thinkstation>
X-Debian-User: leitao

On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > +	/* Reserve the table itself so it survives a further kexec. */
> > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > +			 PAGE_ALIGN_DOWN(ppm));
> 
> Hm. I don't think it is enough.
> 
> On x86, kernel doesn't keep memblock around after boot (see
> CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> from page allocator. But kexec can place the image there.

You mean the third kexec?

1) Kernel A hits an ECC error and marks page X poisoned.
2) Kernel A kexecs into kernel B, which won't use that page since
   it's in EFI_POISONED_PAGE and memblock-reserved.
3) Kernel B kexecs into kernel C, which doesn't respect
   EFI_POISONED_PAGE.

Is this the scenario you mean?

If so, the config table, once installed, persists forever, right?

So kernel C will see the poisoned pages, but could still step into
one during the kexec itself?

> For !CONFIG_ARCH_KEEP_MEMBLOCK, kexec uses walk_system_ram_res() that
> looks into iomem_resource. And memblock does nothing to exclude the
> memory from iomem_resource.

Maybe we need something similar to "efi: mm/memory-failure: keep
hardware-poisoned pages out of the next kexec"[1], but checking
EFI_POISONED_PAGE instead?

Link: https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/ [1]

Thanks for the review,
--breno
