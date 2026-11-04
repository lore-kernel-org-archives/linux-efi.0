Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793788833;
	b=AChHRBJQ9eXHZu44tsnlvP+RZiyJJfo3VUF6K7WAyLcC6h1h/D4EYboyTlYlt2xRt7eA
	 gnHoH6YwHSVFP2JJC9kD8flJ57dCO0+DYTtanjqoXIK6TmBNc3wyZjQZ1C9uBdG8cFLtJ
	 4LwsSRKLbXtjqYAvmpBWup/gNTxvnjed4zUVHLHcAZgWUc5jFQLgVqMivN5AD4Cu8kdmY
	 ZuERU6J+sTFQ6KrvZyLaQJVpYbqn2flrvdtx3R2TinpxZXKIftXEabGypy7VVK6uj9w5C
	 30H4NP+MJspSzQtz9cb0gJSC7S0Am7ngwjhtMAxo0edXInmi3Vj+nAG8dbqaKnHE78g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793788833;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OHhrH3mVCZL9F+uul7Pko5LwqezUEkg/0ds9TVqWkW0=;
	b=5RCWKwpjtnQej81oKuXr8ZjP/iYBhJ+bR/n4dfeV3oC9HScPGN1n+pBg7lwSuqfM268Q
	 CjiIM2eyt2qlqWTeKcKsj+mBOJzWWSZkTH7mnWd2kHIa50BMOe+nHct7kvhIPx4TRAqRl
	 G+Bj40VgCgDtrN/gXoMe9m/KqJgOGA63212Crij/2wQCRmTww0Ktr+SlwQXUs8Wuq6prl
	 gGhUgKTTFaALbD8QyFV+bRNVvFEr/iMauy++nX6dKNH2XDjkCIcp1hkEb6OKeE8+ub4Dr
	 /0GwkXDi9/qkZM148YVmgeA3HlzQy3k/gYw926fQ0v51ZqgX2vFNE8P0/iMCFIxeuWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EeMZhO8D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7936606A31B;
	Wed,  4 Nov 2026 10:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EeMZhO8D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962121F000C1;
	Wed,  4 Nov 2026 10:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793788832;
	bh=OHhrH3mVCZL9F+uul7Pko5LwqezUEkg/0ds9TVqWkW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EeMZhO8DjG4Z1LNGDG6wdfrR5/jvvahFgvuj3m7HOQrS5HMxi/U+6lT8CdBS1mQBG
	 IC79mPKN5pooYxKGcfp/3nadOdWf8Fym3XSVAO968hO1SW6hTg6elGvzxmkBPwmNaS
	 v9T63ChJrQAQbad0an5kGXooCbmvv9MDXmPvDoorGg+XyLiYGBnkViAIHcypGwqbpJ
	 ppQezfycclcHYH/cH5pj6vY3QPZi1ua1tE+LaTlont55dEIEeB+v8CFlcxuVMlA3hL
	 myTh9yVFL8UBjo6Snz+ghL8sE2j0/RkU7G36RxL7WrUdRykGnhNHAiwYwIXZ3Ksf2n
	 rYu3AjolMYkzw==
Date: Wed, 4 Nov 2026 12:40:16 +0200
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
Message-ID: <ausLkNhb8ZPz0ra_@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
 <auovL7i1rEcXCeGS@kernel.org>
 <auo3ScXy6dk0Gr3-@gmail.com>
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
In-Reply-To: <auo3ScXy6dk0Gr3-@gmail.com>

On Tue, Nov 03, 2026 at 11:49:44AM -0800, Breno Leitao wrote:
> On Tue, Nov 03, 2026 at 08:59:59PM +0200, Mike Rapoport wrote:
> > On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> > > On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > > > --- a/mm/internal.h
> > > > > +++ b/mm/internal.h
> > > > 
> > > > We've been splitting internal.h to smaller headers, maybe it's time to add
> > > > "memory-faulure.h"?
> > > 
> > > Ack. I'm happy to move the "mm/memory-failure.c" section out of
> > > mm/internal.h into a new mm/memory-failure.h, as preparation for this
> > > patch.
> > > 
> > > Since this patchset is moving slowly, I'll start the header split in
> > > parallel as a separate series, and rebase this patchset on top of it
> > > when I respin. Is it this ok?
> > 
> > Sounds good to me.
> > 
> > Just be aware that MM folks are knee deep into fixes this cycle, so both
> > sets could be moving slowly :)
> 
> Appreciate the heads up. In that case, should I hold off on the header
> split until the next cycle instead of starting it now?

I believe one header split patch is small enough and not controversial to
have it this cycle.
 
> Thanks,
> --breno

-- 
Sincerely yours,
Mike.
