Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BC43AB262;
	Mon,  7 Sep 2026 14:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788791302; cv=none; b=fsnc810cG/AuuTx/lokq72xUU/sW0uIU+OEHGcq7Y+Q0R+FsXCkSl0iVctUSBvE8I41MuOSvqY9EksmQhMPfx1+E29U3nzDWrS54sXdRxcJXGSdLM/MLCPuAtzLCXUCV2UCKHEilbn8OHGHlMOOLWOH/jI/ua9LdMdSpUl+kUo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788791302; c=relaxed/simple;
	bh=v6vkwAdMNClO0cjBX3Vj4VwUpx/JSpiErmWLG5U076c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W01FOcbzxfpvomeCTtI1/BF+YBNzFPecegGBmCzRdi+dA5kZ73gUto/GBmXrJhVRFXmi0uAWkFtVQz5tiGB+D65FCgsvbrYE7PGrnFlk8wkro/7nrw2UvMPLMt9ljXr7PxCHibXdqe3ZkkwTX5Ru+td/z9+U+0YCmkQo+Nd7RS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=Umw5ALif; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="Umw5ALif"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rztXTxArE4kzHUFZdIzTTHMPPaOeWfni0CGbnXtVrRk=; b=Umw5ALif/GaeXHkSspbhFvoHpV
	ijLLQm+T/BV/rHhk0gvAwCxMVRwRTOMtx26aNAEHtJIKbdhQM3WxgK4MokEQAWyeeKWPCAJTVlXML
	bmc2f/MAzn+EgE22BwT5eY0Is8BLiPfaf1n6kzhQdx27HssCtRhiyNcPcRoU9gHy+ibvVg0M0nioW
	3IuJob4fpt0JUH/gtsGGD6qsBZRPB705AgrGraAsrtjCn18wDiA9nrnJsMkZcITC2MHW5AijAEs0G
	Ijk7UlL2EHiQ2VcO5N1WnjmfJ2soy0YOdupGKE5BNrIOLkbQ2wmdqdrBHZfhCMFHJJjpUuKqfX4Ts
	ceKTlfCw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x3aJu-001ZS2-1N;
	Mon, 07 Sep 2026 14:27:38 +0000
Date: Mon, 7 Sep 2026 07:27:31 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/5] mm/memory-failure: efi: add the
 LINUX_EFI_POISONED_MEMORY configuration table
Message-ID: <ap7HHvF7tXmz4Nsz@gmail.com>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-1-6f79c4b605bc@debian.org>
 <apGOr0BAFc1DMQe6@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apGOr0BAFc1DMQe6@thinkstation>
X-Debian-User: leitao

On Fri, Aug 28, 2026 at 02:47:39PM +0100, Kiryl Shutsemau wrote:
> On Wed, Aug 26, 2026 at 05:03:52AM -0700, Breno Leitao wrote:
> > @@ -1271,6 +1274,16 @@ struct linux_efi_memreserve {
> >  #define EFI_MEMRESERVE_COUNT(size) (((size) - sizeof(struct linux_efi_memreserve)) \
> >  	/ sizeof_field(struct linux_efi_memreserve, entry[0]))
> >  
> > +/* Bit N covers unit N of physical address space, counting from address 0. */
> > +struct linux_efi_poisoned_memory {
> > +	u32		version;
> > +	u32		unit_size;	/* bytes of phys space per bitmap bit */
> > +	u64		size;		/* bitmap size in bytes */
> > +	unsigned long	bitmap[];
> > +};
> 
> struct efi_unaccepted_memory has 'phys_base'. Do we want it here too?
> 
> It can be helpful if physical memory starts very high for some reason.
> I believe it is common for risc-v.
> 
> Tenstorrent Blackhole card has 4G of RAM based at 0x400030000000.
> Counting from address 0 that is a 4M bitmap for 4G of RAM. :-/

Sure, although this won't be used much right now, it will prepare the
structure for future expansion. It also shouldn't add much complexity to
the process.

I will get the structure like this now

  /* Bit N covers the unit at @phys_base + N * @unit_size. */
  struct linux_efi_poisoned_memory {
        u32             version;
        u32             unit_size;      /* bytes of phys space per bitmap bit */
        u64             phys_base;      /* address bit 0 covers */
        u64             size;           /* bitmap size in bytes */
        unsigned long   bitmap[];
  };

and then offset the entities in the bitmap by phys_base.

Thanks for the feedback,
--breno
