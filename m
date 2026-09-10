Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D0A3ACEE2;
	Thu, 10 Sep 2026 07:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789024595; cv=none; b=BnJTtk2VkGdmZqVOI5piPzfd+FhU27zVWbtJ1TsPrKocGnt74SALxVaDEJwLyhnfEW6tdR96shwCgkFvnFn3e9D6WTNnEAACg4gEiYP8iYkBR67ljHrvOSZOUgfdFugqYDflfrpT7hi3oGz4nWw9OoJD9eKKF0UUFU3u+z9qkao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789024595; c=relaxed/simple;
	bh=QtA0agCrSir2LhBEoa9vRZ4yDIUN5xw2sZBVWCPMvDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HdH/5vXSZi5YTJS38wOmSV6/eZANHfps7mXDTsrPs6jkKcUQJIaBj4zPqw8VmpUSSwIyBqjKttSkd+DtRtq1QBTjsy1J0uILQg6gpimsIZNVywRsc3ptxWuD2KWjuSMGbIcmlnrKuY2AYQ9RlalUSOZ6MbiXrsGVEnSYlNuVHHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aoAvCeOC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aoAvCeOC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vRMmMPmDHVL8OZnlyMe4BHRBBMq+LX7AXO63NQkHNvw=; b=aoAvCeOCtrFrzRNLfK/pIFW1bc
	bUPEGPxhNRXgAb7D+6qEgITUaIvBp6aalxGMfElam3F0cr/EXO3rlfta+F4a43QvyN+ZRpmjGaKOB
	sc05MKwEbuO3EugerrMhAvpzEy93naNAbemKVJVVjnWjysA+PKb5/tRTlfZWLcoO3D3Pji5Cmm2jl
	CnBVpqfl9PNZn0VFhepIaO1sZV4MtK5qMs/LPrs8kXRieHckD1Ea3mriwGF81LrgUanrUI7cSDuf/
	vcEtV3OmoRyGrWnVu0FfJNo9pf+gjh9wAKfCHdfX/8yzM66QfKuJ9ufzljYVPhOcpAoHFIpZGpYQz
	sJX6dOdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4Z1L-0000000DbnT-29DI;
	Thu, 10 Sep 2026 07:16:31 +0000
Date: Thu, 10 Sep 2026 00:16:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Vincent Mailhol <mailhol@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>, Jens Axboe <axboe@kernel.dk>,
	linux-efi@vger.kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] block: store GPT attributes as a raw value
Message-ID: <aqJZT68QsAq18676@infradead.org>
References: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-fix_gpt_entry_attributes-v1-1-a4dcb417e8fc@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 08, 2026 at 08:58:26PM +0200, Vincent Mailhol wrote:
> struct _gpt_entry_attributes currently models the GPT partition entry
> attributes field with bitfields. This is broken on machines using the
> __BIG_ENDIAN_BITFIELD ABI because GPT always stores the attributes on
> disk as a 64-bit little-endian.
> 
> No current code consumes individual fields from that structure. So just
> remove struct _gpt_entry_attributes entirely and replace it by an __le64
> value in struct _gpt_entry instead. This lets users apply endian-aware
> masks explicitly when inspecting attribute bits.

This is much better.  If we ever need to interpret it swe should use
le64_to_cpu and masking/shifting anyway.

Reviewed-by: Christoph Hellwig <hch@lst.de>

