Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2721E5678EE;
	Wed,  9 Sep 2026 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962451; cv=none; b=XgCqwwNzApfz1pBKy2Hvf31ihJG6AOb2VMS6+12F7gFTbWS78kxAvuzJo7miMvTkm52gfY6TyB7EY2QE+wbbzt/aRG8fdZuNONHNBLi+kCSrxH1HwRj020clnQ70rqQZrub8wSv+s73NVMimbOwNZZL8pecrDUydJLUBAoaKkws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962451; c=relaxed/simple;
	bh=41JPlRh0qfoMonH4MWA9VgLNLi8v66uH8M35E0E2oSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6e4DZefPIR7wCCLKc4/iARMaI7CCrYDXG5oyMLAjI8eYxsptZXsZ9h+QhqhkkY3Kd2NKmsvoeWW0pJ02daIh1rKSw8bUPfrnry23MgZRcQt0WwrBnp8c/KPMXzuffChwgAUasuL5NCh7j3CrEqon6xFOR4shQQoUxCM6yFwXEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=cTCDZr6Z; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="cTCDZr6Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZqGD6+EIHmen/yXXRwBLkUFq1BO6jBImOTP5fEBlNDw=; b=cTCDZr6ZCnhsx+vTe2Bu439RDN
	zgmXwoq1tVj2rx1oPZhMrSaFompcN5ZiFJdN/lhLCVc6R5T3U/Utt6CUPXc2qguLiC9jxT+VCRK/F
	U3ncOktFQ9HN+NnyyZ2Y71JQr6LSiFDnT8eLQMzOY+g97udoqNxU3Fjkl8/RX0cwOuFk45/Cl2qcu
	J+drc+sx7Y2+76t/NIr7LdQcnx66ZNjf3vXefaNaYQXDTvp4kor32JZGM20hxOsmjbCdHPvyiR5XX
	2GFIhX2leHw0/Vg/YI7PM1Vmbtf7uRgGps32nBAS2NlQyuwr3fpCx4xgVi5FR/JZs92o3FEwfD2zb
	H3lcLMpQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Iqs-0036XE-0I;
	Wed, 09 Sep 2026 14:00:38 +0000
Date: Wed, 9 Sep 2026 07:00:30 -0700
From: Breno Leitao <leitao@debian.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ardb@kernel.org>, kas@kernel.org, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "Liam R. Howlett" <liam@infradead.org>, x86@kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, harry@kernel.org, 
	linux-efi@vger.kernel.org, riel@surriel.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org, rmikey@meta.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqFmJao8Os0ySPjF@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <20260909131911.76D361F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909131911.76D361F00A3A@smtp.kernel.org>
X-Debian-User: leitao

On Wed, Sep 09, 2026 at 01:19:11PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Integer truncation in efi_poison_alloc leads to a massive heap buffer overflow during memset on 32-bit or mixed-mode systems.
> --
> 
> commit 626632820fe1fdcddc73aaeb109705cbddc9828c
> Author: Breno Leitao <leitao@debian.org>
> Subject: mm/memory-failure: libstub: install the poisoned-memory EFI table
> 
> This patch introduces functionality in the EFI stub to create and install a
> poisoned-memory EFI configuration table. It walks the UEFI memory map to find
> the RAM range and allocates a bitmap to track poisoned memory granules.
> 
> > diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> > index 48f93f7758e9e..5cbe675491333 100644
> > --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> > +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> [ ... ]
> > +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> > +							  u64 bitmap_size)
> > +{
> > +	struct linux_efi_poisoned_memory *pm;
> > +	efi_status_t status;
> > +
> > +	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> > +			     sizeof(*pm) + bitmap_size, (void **)&pm);
> 
> [Severity: Critical]
> Could sizeof(*pm) + bitmap_size overflow 32 bits on 32-bit or mixed-mode
> systems?

This feature (EFI_POISONED_MEMORY) is only enabled on 32-bits system,
so, 32-bit issues is not a real issue. See very first patch:

	+config EFI_POISONED_MEMORY
	+	def_bool y
	+	depends on EFI_STUB && MEMORY_FAILURE && 64BIT

So, this is a false positive
