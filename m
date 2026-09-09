Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84B155650F4;
	Wed,  9 Sep 2026 14:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962774; cv=none; b=lRhBuK4MgwhTiFgQwR8+g3rn3HWR2Vm7UcTxijRwojye4G/X0+713MpVN/vLXvKiWOdmd2EP1OAqBzghshpX7/EUthBVgvr6/YoHz5QXihy/Ztgsr13kJrR0rKw4TJ4TlO402em5sEni3OGD73HNRgX7RTH1G503sGYVhs8Qk4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962774; c=relaxed/simple;
	bh=FM0laFIlzZynUtkMrD7HptJYgw3fdGZhnsJOQK/Z6iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kIgDpo7ZikhEqjFDfyLYM06Dk6773SKvd0AgMolES8XF5GVv393hSKq2aNbDZeOEmK21uHi3PDjSbgZfPY/GMPa9zbtj5/yF+gfkuTHpfclZsE7tlOwJVMs7OoHkpTyo76xWUBGSZSe44tCdty0a2ok0CAevMvouLQtSrVgkFRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=rcsC1nVJ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="rcsC1nVJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ARyHcdAb0HLmyx/eDFN86Rb81gJGVIXThCIEa265DUA=; b=rcsC1nVJ458PkGkasholnKxN6Y
	8410oN/kuEDXUbOFmM+71oC19ElLRGi06Vt5lELxPN2NRrvCvoeFrsuLjkPROFDyV4u3NzsHyF0Dw
	4EQKOZ0A4I5dZd4/wWWTiaK8hrAjVAFqM33pEkIiQi5D4RBK54/6Ywa0Ltduv+4JyaWasZgqS3bhm
	pPivoqW8OISS6nImyYN3ZxQ2g6tRDXdHf0LegFyAOOcbpFXay9V6Q3b6/OKIBV7i4y9Kf93r21acK
	b5ht4rH+nV412qx7B1mw5ATercq3FkeW0Sku5yJAxhNUuXQRReH+Ypx4/wZnjMY5NPNXqRIGMa9Ru
	AE5xkGuw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Iw9-0036hX-08;
	Wed, 09 Sep 2026 14:06:05 +0000
Date: Wed, 9 Sep 2026 07:05:57 -0700
From: Breno Leitao <leitao@debian.org>
To: sashiko-reviews@lists.linux.dev
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Michal Hocko <mhocko@suse.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Borislav Petkov <bp@alien8.de>, Suren Baghdasaryan <surenb@google.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Zi Yan <ziy@nvidia.com>, Thomas Gleixner <tglx@kernel.org>, kernel-team@meta.com, 
	rmikey@meta.com, harry@kernel.org, linux-efi@vger.kernel.org, riel@surriel.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kexec@lists.infradead.org
Subject: Re: [PATCH v4 3/5] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
Message-ID: <aqFm1ep0mIlJpA-d@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-3-359313564495@debian.org>
 <20260909132128.AD4D01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909132128.AD4D01F00A3A@smtp.kernel.org>
X-Debian-User: leitao

On Wed, Sep 09, 2026 at 01:21:28PM +0000, sashiko-bot@kernel.org wrote:
> > --- /dev/null
> > +++ b/drivers/firmware/efi/poison.c
> >
> > +	/* Whole words, and a bit count that can be taken without wrapping. */
> > +	if (!pm->size || !IS_ALIGNED(pm->size, sizeof(unsigned long)) ||
> > +	    check_mul_overflow(pm->size, (u64)BITS_PER_BYTE, &nbits))
> > +		return false;
> 
> [Severity: High]
> Does this validation fully protect against an excessively large pm->size?

I was clamping the table before, but we decided to drop it in the last
revision. See the discusion in here:

https://lore.kernel.org/all/apGWUWi5-RbhFHpe@thinkstation/

> > +	start = PAGE_ALIGN_DOWN(efi.poisoned_memory);
> > +	end = PAGE_ALIGN(efi.poisoned_memory + sizeof(*pm) + pm->size);
> 
> [Severity: High]
> Can this computation wrap around if pm->size is maliciously large?

Yes, but that means that someone was able to write to EFI memory to
update size?

I can definitely BUG_ON() on "large"  pm->size, but, I don't think this
is what we want here.
