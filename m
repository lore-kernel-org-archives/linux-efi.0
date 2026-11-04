Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793791735;
	b=zrfvLezYXgAQYjLHh5SmMCY3U8JHvyvdxYsNKZSg7NqueIFK8z6rmMdWfB9GDP7PcRZm
	 MB+dWKh9yLDMpWY3gWS6XrqBOr72ERXEZNMtR/7AZfigjoo5tS/15IwNTHkzzBMfOEfn0
	 E0a/FMcFM70iLKC5PVx4zvkG5Jkr72+5fNWrzV6Z7grmihHoqOdskjn6NNOAHJ8cax4JK
	 spsIjJP/W//7D00ZtHXt5FelG0BCj84K0xkuX3oUCEyfEhjFGAZD8DDv/677k9qhnVPyQ
	 XuQA46aiaowVVy7nr7xWXw2Mndbb1KesF5VkD6ZphpqLYRmiqAzxP/tVfjIDpXTz1vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793791735;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=9is/N8s+P77nIizr4iOPWVN8ElLFZtGDMyfkjPVV7ok=;
	b=hW393tfNZK/tqOslZX1z46c8iBLX1ESyVC/FoQhseFZO7/ZM8JvhBI7iDx2+v+f7BOgn
	 Vt9K+zUPcET4zhRn/wQeyud9OIGnP17O7FYbFptV8FYWnMz3AA4bnT1vgKMaEIJrcov/c
	 tqcutTaC8Rkg5ViKSnnMj92d2ohIyuN4nhohPciAlUW9vXzTYbffTYEODQ9B6sdyEv2uZ
	 P0BNNVLFp+jUve88cCdzMAQerhrKfxHBkB4g+Wb/grWGhqjcNNZazGmLP2UqdnU9ta+kN
	 jVcmDIjdO5wIknbt1TtXFtKAABBCg8djZGR+p8affNB5pnYB8uCVi7VnDa7ur48ck4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=jgdm78Gz;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A81606A329;
	Wed,  4 Nov 2026 11:28:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02A81606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=jgdm78Gz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9is/N8s+P77nIizr4iOPWVN8ElLFZtGDMyfkjPVV7ok=; b=jgdm78Gz9UGB9lEHqxYvlou0CF
	KutGa9kqLufeOHXyPksfalr8TGDd7Qjd3tQH2L7oBQHupX+kTlaaKzW1afMCyCYUaiJJ2iGGB70oX
	yUwrmnE7OVoMMYHZNTAmgbJKDUS5vKef2pVnD0LoEXB9jvIDd7ptVKguMRqbrtt0cXmhCr/XvjZAb
	7Gy6NMigdFntWPLB7BRi98TVcjr6fDcS6ocN6VGuh0+C8sJnMrobb1gCe0+zouonWA3lnpu1nkE8h
	RQ+Voe4lQl/aCzyPhyOrVaick563cL76U22efAn/kPb650EoOY0iEXzUm6cLk6F9GHhuBZQp4RtUI
	ZHYjfeYQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOZA6-007g5u-2T;
	Wed, 04 Nov 2026 11:28:15 +0000
Date: Wed, 4 Nov 2026 03:28:06 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
	kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, shakeel.butt@linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <ausWvcPv20yznl_8@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
 <aumvVjoHo4KeuyEp@gmail.com>
 <auovL7i1rEcXCeGS@kernel.org>
 <auo3ScXy6dk0Gr3-@gmail.com>
 <ausLkNhb8ZPz0ra_@kernel.org>
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
In-Reply-To: <ausLkNhb8ZPz0ra_@kernel.org>
X-Debian-User: leitao

On Wed, Nov 04, 2026 at 12:40:16PM +0200, Mike Rapoport wrote:
> On Tue, Nov 03, 2026 at 11:49:44AM -0800, Breno Leitao wrote:
> > On Tue, Nov 03, 2026 at 08:59:59PM +0200, Mike Rapoport wrote:
> > > On Tue, Nov 03, 2026 at 02:06:17AM -0800, Breno Leitao wrote:
> > > > On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > > > > > --- a/mm/internal.h
> > > > > > +++ b/mm/internal.h
> > > > > 
> > > > > We've been splitting internal.h to smaller headers, maybe it's time to add
> > > > > "memory-faulure.h"?
> > > > 
> > > > Ack. I'm happy to move the "mm/memory-failure.c" section out of
> > > > mm/internal.h into a new mm/memory-failure.h, as preparation for this
> > > > patch.
> > > > 
> > > > Since this patchset is moving slowly, I'll start the header split in
> > > > parallel as a separate series, and rebase this patchset on top of it
> > > > when I respin. Is it this ok?
> > > 
> > > Sounds good to me.
> > > 
> > > Just be aware that MM folks are knee deep into fixes this cycle, so both
> > > sets could be moving slowly :)
> > 
> > Appreciate the heads up. In that case, should I hold off on the header
> > split until the next cycle instead of starting it now?
> 
> I believe one header split patch is small enough and not controversial to
> have it this cycle.

Ack, on it!

Thanks,
--breno
