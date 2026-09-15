Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D13921DE;
	Tue, 15 Sep 2026 09:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789463089; cv=none; b=jVKOu8TJ24CO8ytH7yfUhvWfG0fFSUer2Ux+zfrIDo83Is1nTsm8G07g1nuZK166wZH2i5mVTkV8ItOVg9OidqZET02WqArW+PHVEHP2YqQyVVZEVCRYM9EL60wCagnOksjoAst3bbemxRl3BhihEx+J3K3n4FZydDdqoVxTCLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789463089; c=relaxed/simple;
	bh=p0h4aQ5J6VKqVoOvm5wl4GvsMACdo4QPqVFYbbqUt88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sMToRC4DGIJc9ryqfu9oYzLZ3N+K0bx/y4AEdsR5vO/5tU6o9dZKsuggyN7dsvTfAmEMhdQBTi7sf7+QfLKcrLs84asQcND1syOzd0d/q79twvlXlxE5vspILqX0dVC1JvlRe1AF0cqvi6wl0cwqu4AwNuanKhPAuF3j6+wJdkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=lRl6heYd; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="lRl6heYd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xj97Gm+bFVDZhjwESgxXGsr/TcYPbbFLUTQH8EasuOs=; b=lRl6heYdFmWobjqmP6MVFkL3cc
	hrfWmOjJy7y8JC4vaFY0trfhscwmnfFCx1TYA24UxzrPt41+U6Va+vFZDeo0p8FcrkDmBpzjqVsgk
	JPSe9jy/AB4dPNiYIpvuvQxdT30cSTNu7IIhDxsViLxrY5mk/yPbs+ARWqEFH2WX3MI9gNbnBwrqb
	ytBsRGkqSb7XmPuwpl/2f6Mr7KW5Uo2R/ImOZsT+mPaFhkFGTH2UfO/Dd+a9OIIJ30Hcc4lFqiRhc
	vl/N2nSH9zs66d5eQQM/R4y4PtD/9V0nDRpXZEkq7o/gZMcDF6vJOmqeMv6iu2rs80VEGFFXzMAsF
	oKG4ogTQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6P51-004HQC-0I;
	Tue, 15 Sep 2026 09:03:55 +0000
Date: Tue, 15 Sep 2026 02:03:48 -0700
From: Breno Leitao <leitao@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqkIdVhoG2wwVBtb@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqKhgPKzRf0e22s3@gmail.com>
X-Debian-User: leitao

On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> So I'd say we have two options:
>
> 1) Keep it similar to unaccepted memory, with 2M granularity.
>    - Pro : Similar mental model as unnacepted memory
>    - Cons: 2 MB might be a bit wasteful
>
> 2) Move to a linked list like the RFC, keeping it outside of the EFI
>    table.
>    - Pro: Reduce the memory granularities to page instead of 2M blocs.
>    - Cons: Another way of passing memory information between kexec
>      kernels.
>
> Any any other option or strong preference?

Since nobody voiced a strong preference, I will stick with option (1),
the bitmap, for these reasons:

1) It follows the same mental model as unaccepted memory, which people
   are already familiar with.

2) It is simpler to query at boot time, especially as the number of
   poisoned memory regions grows. Walking a bitmap is easier than
   walking a linked list when freeing memory back to the buddy
   allocator.

--breno
