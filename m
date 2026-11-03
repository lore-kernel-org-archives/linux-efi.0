Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793732420;
	b=me+EG5AMSTdUSR5xl82aGKHri8twuxJAVXdWBvoL7KDje7hvo1yz7KpTUd0ppk5UKJ8J
	 joLOm4gtnK1GWlSen2tQMkQBPs2v2uf7u+xLpOFDfBbQtm/u6+FDI8T9MtTDGZamTwKUJ
	 L7n6G5pVamUtiMUqmkylR+nzqcVE7sHVxSWSiHf7avIEuoi9CWTcj5e8O2D7RKteeJhY7
	 YcSUsHUe5egErRWn5c/pIMd51SxvTJzsQPB0fkwv44EDrkvV6225j1+XiO19VlJ0JPQ5u
	 tTv29fK9LurAvJ2oJGcJUvJKpkR2lamhmxgaLAPXh8ywcrj5+oMIZVl5ReXOpqMuH1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793732420;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LaKapLJYP5++dFoozepE0lnkIHdswFBWdj5vNlVLQL4=;
	b=PN4QQRF0zGPuIOqNEmlvBz2EjfG01tjCcKwnU/S50EMD/KFhW6LOmfQdXsVHgZBFYuJm
	 TM/F97jm/XOVXbLWX7Weg2rUk8iztyU2D7ZeO8fFGJnbTWNK+u79WwT+OZyPLLi536HAd
	 nXxgHe87ELWIWWk+DiCawMmGqO5m8QDKiYVrgEit2P5vO0d7EsW+O/6JQWBdcMklbbwHM
	 BIiOP10u/jofGbYAdsFyrFIGeNlTFyHjtCaVLEPfcuajDHKwQQ4AcCRLNOQbqdsHJ2PTc
	 KyPuEtxVbEGLg3LGvGRUjiEz2zGSCFs2+v5RL3zmnDzfHZYLiw52NEN5z1ae8Oytz0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LJZKrIFp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECB8606A328;
	Tue,  3 Nov 2026 19:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LJZKrIFp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615291F000C1;
	Tue,  3 Nov 2026 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732419;
	bh=LaKapLJYP5++dFoozepE0lnkIHdswFBWdj5vNlVLQL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LJZKrIFpProYve6IpbPTPKXS0osYcR7LSfwpwWEti0f5L7GYgObXcdMpRXAruuFy0
	 ykhywq6Ol+JkTewX3xD8MdK787dydcKQIZYtyRmlur1cLQkofvu+bILxkbyvZ7G2OQ
	 bLwK0Z2jqCPTnCgQV4fCiYglEEMQ6m6jFwV8R3TX57kxToxTAYYHKxyleFKcS5rkni
	 a0ttLb93BNHW70VZqvLeOTAbPOXqWJnsMDFCNGJmSmWEhDTWBEVso17CqnU4KWwA1A
	 6WCOKh3oAvyN2aZS9G+yxLYSFjvXrLTj/9Yh5/YlbwTv9u8rSNnSa9JAKNHTmglXhJ
	 8Phvh1cCmq5Wg==
Date: Tue, 3 Nov 2026 20:59:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <auovL7i1rEcXCeGS@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aumvVjoHo4KeuyEp@gmail.com>

On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > 
> > We've been splitting internal.h to smaller headers, maybe it's time to add
> > "memory-faulure.h"?
> 
> Ack. I'm happy to move the "mm/memory-failure.c" section out of
> mm/internal.h into a new mm/memory-failure.h, as preparation for this
> patch.
> 
> Since this patchset is moving slowly, I'll start the header split in
> parallel as a separate series, and rebase this patchset on top of it
> when I respin. Is it this ok?

Sounds good to me.

Just be aware that MM folks are knee deep into fixes this cycle, so both
sets could be moving slowly :)

> Thanks,
> --breno

-- 
Sincerely yours,
Mike.
