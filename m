Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7907450255B;
	Fri, 18 Sep 2026 15:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789745279; cv=none; b=LX7PpTAYXr3M7tqhgC3QXQD1NzcukPgIUx92OdtoeZIS2+beeumE8RCiAFWssLBhBHaVf7HFYvBFBytjr1QZmZyoGlhvoH8xy8W1RRBpq3Tu66XreL4wPV3oLVJ62yvy5k1eJsRLD6vFGLj7/GRpZ3Iha02Q24QKB0uKdfzEO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789745279; c=relaxed/simple;
	bh=N/jmJ7LZZR/1sSBpc7h3MkpctCTbA/0VAY284FY63k8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VG/8dEuB/TVdkqRaZvdMnO2EChMuL1Dvk+gghBErXX7bpA6+Gg4pchdt5k7GOyhEn76+tx5iwbhmAlhJAj85L6m8KnE1TRq+X0ID47ORfODeUsYRntWAEIEIQXmTUfG3Hd71rrCdAyBuCMSNplmvP/rcmc1Jc5GyWPMKcU1ijys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=JTa7w1HA; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="JTa7w1HA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N/jmJ7LZZR/1sSBpc7h3MkpctCTbA/0VAY284FY63k8=; b=JTa7w1HAnYJLKRzmXqqM/n26PT
	XVERCbe9w1NQse8+JSAoioonymw9wi5vLK9SsZzoN90WrTjgDiQwU+OaXAp86a5/Ii5tYXQO0izMZ
	WX3CS0Yp/ScF6ORLsZwJdjG0A8aw1LN3XlrQpakTWPsxfB8JhzZju1bTK5R9AUbrp80nVpHrrGN8W
	cO/aaM8VEcxuEkf9hIJ8w5Fw5SYwXC785b4tlNiGKvsPXbFNEfZX+l/g9v18MiAIoQ6lzvR5ExgL9
	wCKQBPI9INQ+fzEGLXsrYkcM/qtQ7d2mMNwXEyD6BVVjQsIoDNuO/UZoL9gq9ZB+qWbNT33nHTli7
	CDjYGqYA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7aVB-006p7a-0M;
	Fri, 18 Sep 2026 15:27:49 +0000
Date: Fri, 18 Sep 2026 08:27:40 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.or, Borislav Petkov <bp@alien8.de>, 
	Danilo Krummrich <dakr@kernel.org>, Brendan Jackman <brendan.jackman@linux.dev>, x86@kernel.org, 
	kas@kernel.org, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, shakeel.butt@linux.dev, Johannes Weiner <hannes@cmpxchg.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-cxl@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	harry@kernel.org, rmikey@meta.com, kernel-team@meta.com, 
	driver-core@lists.linux.dev, riel@surriel.com
Subject: Re: [PATCH v5 6/9] mm/memory-failure: efi: answer whether a range is
 poisoned
Message-ID: <aq1Xr4b7BXZForCe@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-6-3bc7a57bd503@debian.org>
 <20260915134535.C3FC91F00899@smtp.kernel.org>
 <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edafd246-0bd8-4335-9037-77f552968b56@kernel.org>
X-Debian-User: leitao

On Wed, Sep 16, 2026 at 08:44:30AM +0200, David Hildenbrand (Arm) wrote:
> On 9/15/26 15:45, sashiko-bot@kernel.org wrote:
> >> The bitmap an earlier kernel filled in gets in this one through EFI,
> >> but nothing reads it back yet.
> >>
> >> Introduce range_contains_poisoned_memory(), which the page allocator
> >> will use to ask about a block before handing it out.
> >>
> >> Signed-off-by: Breno Leitao <leitao@debian.org>
> >
> > Sashiko has reviewed this patch and found no issues. It looks great!
> >
>
> David has reviewed this mail and it annoyed him.

Breno is curious what annoyed David here.
