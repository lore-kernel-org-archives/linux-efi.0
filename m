Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9F346D09A
	for <linux-efi@vger.kernel.org>; Fri, 28 Aug 2026 13:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787925592; cv=none; b=TbPml6B4AayfG4dT8wlHaud2VAQE3vWz1jtqbV4YACtxlN38yiLV/9/Lsx4brrV9fH8swrHBhp/paN/KMGlywnAm2VRuV/TUdLke8XiBW4sPXVhteKoEb9NiTmRjBrbdKzMJQ00CuOOpwHAHSwgd/wJiZ9EM9FUpNtpeWWOEueE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787925592; c=relaxed/simple;
	bh=sySEeVbrbCmBslxSfBPjwbOWGmobkRhzLZzR/OdbRLQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtmQCZ0HaXfPLRP05Hn+ri5wSpx/9rY5I68OLyDLI9fYbJT3NH8eDLs9FcBJrIOTIgW/+x358M4a6TI8A0uUa6zEQhRc7glpVIIapbh0do3xP9WjrpvZE4fnujMpkEeVYh8mx3eu6OoaubjMPmU1zYUBiUW9PgY3p0LGZUcYfmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDLgEYHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDLgEYHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122FC1F00A3A;
	Fri, 28 Aug 2026 13:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787925591;
	bh=GMsq4s9H5sslOOoHpaDnzK693uMuIdL+zLKvHUgSCOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lDLgEYHxqyMExx7XGHQ1jMOssFVfuXXHoEzbBFpy5flN3Ib4Bd3XgGWIWJMp6arLJ
	 uQVbfv7J5ZyA4dhS8/bZdYE+uBBMnrDV8e0fo5PloBITeSUDghfkfYw1D9c5wdWYwu
	 XZQit9lHQy1bSrPTtaQxgXbGCzJ7ybYZKFJ2vKJmyZ3gfcQ9S9Zux7MV4EHTe8WKIF
	 cQvwZk10zsIwVNSeF02O73cQgZkIW8VKvcKbmR4S3FO1bWytcWw/EKysYqo2DV0DeN
	 8tK1MPeAD1ya67qILgrYnKWGC/cyVNaPzFTPrj302CK1H26FHwBHo62CzeDmiZRHiZ
	 FnDhPRSM8Ictw==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8F1C61980045;
	Fri, 28 Aug 2026 09:59:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 28 Aug 2026 09:59:48 -0400
X-ME-Sender: <xms:UZSRapkyHK92xpfCc7gC34L_khXR3QDyMijHbidWAs220sKQ8lkFUg>
    <xme:UZSRan8Dpwoy1eVqQ6ejwtpK5aDyWpuAHSF3GZvcF9ux2kRifDcfxgdrhN5UbMiT2
    kcCkZeB7jDWyXr2cnergQkITcqHPmjzoSUgbqYkVaV59rMStIDBniI>
X-ME-Received: <xmr:UZSRatEolRX4Ox6wFQ1OGkjYzS9-u6dOHl9Sw-ITv6dXf-KAx_Tttsv0TF8>
X-ME-Proxy-Cause: dmFkZTFllgFcBPPxWyh7H7Ya97cPF2z+CaYPZAeFHJRUEOI7iP7NbK/RD+h7m0XG7mWy16
    fIZCnkd80l4AcUG6PCl7E90y1FlqRmxxmociQ31S8wZQTE+r/ShOn2X3FGZoq2J0Vdf97p
    nuFw4AqeM/WomfxoyRgLOaOyXPCImUEPhxoNz4O6fJf9J9swOyN5utIVT2r0XabJbA4HxF
    oILQMURKy3DfTYUUGeeYdtTqPn4upMBcTfKSGqNc5c6xt9AM949lwP1kFNdph86l+6pYNc
    RLrozyUVEmo7eSsWX5/dVPnhXM37BJYxN8ROLEVvUcuC0Xxxx2BGLKc00OiMUuXhlN+6X0
    1vEX6V9DH/wtIWZy7pT2JUHc34pYq9bNE1mhzx6gPcCLaoh6ZOIx6UPo5fsw2jPVelT/oM
    +RkCwxR1y6cCiBY7aJLTWgDUQPbYSswR7CrwcwhuhPYs7IJmoS7+ghC4sDkXaU/AkAnIJc
    Gu0NQkXGvpCFrPL0K1sJJ0/HBEE6GTdYLrk1kEZpfjVXn0h1VASbWIyC8kJ92dmWrjl1FK
    b/EgQHbOIgf+5hE5GMQ3LfKop5IEUj8L2oPdH4UNTLw/ZUAu52OAWj7ERMa3mq8u4Fpfvf
    n43K7EzhAX+ZsBpBswrS7KKCqwtaiiqzNVHDXonWeXfntyQUnXrftzSFTLNg
X-ME-Proxy: <xmx:UZSRauKl_CC_sQ4ifO52hn5UJgg2-F_7akOIxsy_CfM2VI_jq2wh2w>
    <xmx:UZSRamfb0Cvb9NxgQOQKnEarX-NxrqGf7K4MrHcRGhmLSPArbpa-Mg>
    <xmx:UZSRamXYit9R7Sub6lx6kW99a3nAu5AU_EaeCy2263Rn6OZWl3cyFA>
    <xmx:UZSRauCS1sl_ngYBSDZMZE-MXPsW_dD3EDJf5Eky0u9G8cqeVWsMZA>
    <xmx:UZSRat9eai9o-Upb0C9Q7D893HN4Q13Z1LausSAOpkC8N-eK7DnIl2aI>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 09:59:44 -0400 (EDT)
Date: Fri, 28 Aug 2026 14:59:43 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <apGSy78NoCov0MWr@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-2-6f79c4b605bc@debian.org>

On Wed, Aug 26, 2026 at 05:03:53AM -0700, Breno Leitao wrote:
> A EFI config table can only be installed while boot services are still
> up, so the stub has to create it; the running kernel can only flip bits
> in a table that already exists.
> 
> Size the bitmap from the top of usable RAM, which efi_get_ram_top()
> works out by walking the UEFI memory map, since the stub has no max_pfn.
> Bit N covers unit N counting from address 0, so the table tracks
> max_pfn. Memory the firmware hot-adds later sits above it and is not
> carried across a kexec.
> 
> One table has to serve every architecture, so efi_get_ram_top() takes
> the union of the memory types they turn into RAM: what setup_e820() maps
> to E820_TYPE_RAM on x86, plus the EFI_ACPI_RECLAIM_MEMORY and
> EFI_PERSISTENT_MEMORY that is_usable_memory() accepts on arm64. Sizing
> wide only costs bitmap bytes; sizing narrow silently drops the records
> for every frame above the top.

x86 and ARM doesn't seem to agree what RAM is. On x86 it is by ->type
and on ARM it is by ->attribute (anything WB/WC/WT).

is_usable_memory() only decides nomap. Everything is_memory() lets in
lands in memblock.memory, and max_pfn is PFN_DOWN(memblock_end_of_DRAM()),
so the top of RAM there can be a type that is not on your list.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
