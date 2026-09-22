Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F4049E5DC;
	Tue, 22 Sep 2026 09:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790068496; cv=none; b=l828bet+qsIN/KPM5YgOM70JZY+8k8fWuJsKCZM1Wk3uUghXA8rzF1V9rIz/sARhGelRpu2HwyAn2CFnlwoyehpX+gulyQUxnc/LrQnyuXMhwTIp3qBPmVtTXZY0CpiIj7jRqwZucAk+PyAA2z030lD2S+C1e1EhzxTJ6B2gwes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790068496; c=relaxed/simple;
	bh=G6g/Ns3DsSE6wdQG/IaMe18C9Nn3sdmR1q26SH/yjGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nQTHjXVtzbz92Vh7+fWyBSFovkMb0WM2/Z6dXBtW62BpXxKsrBrz1GTEe+CcPca+dzdeR+Yy6SlkQVGespk7JjMUBFm/IwdLBIGTwoDTgWynBHiKufMIN29ykk4cIO8KHK3ovR/Bz4RHl7Rz0QE6mwOb9FNAOsHDtoWFS6RadLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=eUPTj9eA; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="eUPTj9eA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FH7I6UR6jBDl/t2avlBDN/FfwVeJE6mNz3ibf6d5W4E=; b=eUPTj9eAaXcbs4q80PbAeG7F41
	9081MjBXTkIMWK+8zT65gf+PM19anFfCRJOI6aZDApSOMevfYWb7efc71TgWLRLz8Exj/Nz6e3oNX
	mp/w6EYIlF0u9JFuQE14R4PxwI4XFehfbZAkhGeX6EqqO11Jmi9aD8og1r8c2WBbO+aoH++ZsQDTq
	5MI3ibU0iCpKRWkSKqMVcUfHWhXxDKZrlmTSKxjS4cR2YGJ5D5lcnutLJShjnAq+FsJHp6txXpr3P
	VyHyIM4Le5aXVewo0dNiv1C6zkiqmZda9lDVm/dor3vG7NOQtXJd4UBmw/Yn3VZTs1fK3FRW1640T
	s6m1xKKg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8wa5-002sKz-0P;
	Tue, 22 Sep 2026 09:14:29 +0000
Date: Tue, 22 Sep 2026 02:14:20 -0700
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
Message-ID: <arJBkNOgbR8NrgFP@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e35901-f74d-bf81-75d3-bac4b26d9d72@huawei.com>
X-Debian-User: leitao

Hello Miaohe,

On Tue, Sep 22, 2026 at 02:27:59PM +0800, Miaohe Lin wrote:
> > A bit is never cleared, which is a known limitation: it stands for a
> > whole unit, so an unpoison of one frame cannot tell whether the unit as a
> > whole is good again.
> 
> Thanks for your patches. I have a question about unpoison: If a bit is never
> cleared, after we do some memory-failure+unpoison tests, kexec will lose the
> tested memory without reboot?

Correct, A bit stands for a 2M unit, so every tested page that falls in
a distinct unit costs 2M in each kernel after the kexec.

Worth being precise about the state today: the unpoison itself works.
The frame goes back to the allocator and num_poisoned_pages drops. Only
the bit stays, so the next kernel poisons the frame again. Test loop
in, memory out, and nothing gives it back.

Important to say that nothing block us from unpoison the bitmap, and in
fact my initial patchset had it. I also _think_ we should unpoison the
bitmap once we unpoison the page. 

I have just kept it out of this patch in order to simplify the patchset and
get the basis correct, and then evolve on top of it.

That said, If you think this is a must have in first patchset, I am more
than happy to do it now, but just keep it in mind that it will grow the
patchset by about 2 extra functions.

Thanks the review,
--breno
