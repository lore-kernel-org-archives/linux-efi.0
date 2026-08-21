Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2437247606E;
	Fri, 21 Aug 2026 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787321521; cv=none; b=DFoYjK5tx1cAcyc4GxVXs/ujRr/NvJH+vRoC1miKess61mr25+3b4q6BbLTPRTYHPGlOoBLshMcrHxq0jpTPJPZfEGTTeuAIDXIigMVJ0rUb5GcAmI5JWn7Sb0AfzXW0Ypzme2IRl4xXS56i6SW1vqt5Cpan5gj5PIq7hzOnP74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787321521; c=relaxed/simple;
	bh=+s8nrVru3lVt51o3WPC0OWAgHhejkRrpE7BPTflxZfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0eCMTmYi7nPK7r7ddCCsi85clgAGsro8ftFgR91MYSIGBocMQb/90BiuaTpFxHaN/q13mEwVDpv51wOwpz3t9JcEQARuzIdRrBNV9yD4xP8jZW5+PZjrSJCWEc8afcqHN2ZHr/zirdUPngq5y1UEKkskrSgUQh7RRqYvszsbIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=fsH1sn0f; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="fsH1sn0f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eb7xA0CZoUY2QWL9JJY5cm27fWnsNVXdbEb3sAd4rNw=; b=fsH1sn0fhWE8VQ6z44pz/Lqc0a
	aCuIa4UarAIbljORKpZoWr5R+6hCDAZCFRXWhw03ztEtOLQEAiso10RmuGAuvbUom2dZRqwfOts8T
	DflDsj6s87G8SrgSKJetC2hOs7bkiC5VmU2tr2ONT1PGzK6UZUTOEQHT6mVos88136eN0KHVzSi5K
	kEArKhSiS0hL+otnGvynq3ETl9EJ1kxDAJqglojE0UsKQfqDM+QahbRafrvAGQQlQLrRwQjQDLIKt
	JNqShfQBu8zJgRuB1Ydjc2ADFaEYuvhsRvRcFilDMT7zEAi5QYlXu1ebTL23bI1fh9M1+lAqt8HI+
	Fi8v6Zug==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxPyJ-00BOWn-2i;
	Fri, 21 Aug 2026 14:11:52 +0000
Date: Fri, 21 Aug 2026 07:11:47 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] efi: add the LINUX_EFI_POISONED_MEMORY
 configuration table
Message-ID: <aohbRisiQ9Mn-ldY@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-2-5743791e48e6@debian.org>
 <aog7bwfMVpSy9LcY@thinkstation>
 <2vxz5x13znn1.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxz5x13znn1.fsf@kernel.org>
X-Debian-User: leitao

Hello Pratyush,

On Fri, Aug 21, 2026 at 02:03:30PM +0200, Pratyush Yadav wrote:
> >> +config EFI_POISONED_MEMORY
> >> +	bool "Carry hardware-poisoned pages across kexec"
> >> +	depends on EFI_STUB && MEMORY_FAILURE && 64BIT
> >> +	help
> >> +	  Record page frames that are hardware-poisoned while this kernel runs
> >> +	  into an EFI configuration table, and honor that table early on the
> >> +	  next kernel so a kexec does not hand known-bad RAM back out.
> >> +
> >> +	  If unsure, say N.
> >> +
> >
> > Do we want to make it conditional? Maybe just for everyone with EFI_STUB
> > && MEMORY_FAILURE?
>
> +1. Each config we add is a decision someone has to make when compiling
> the kernel. If they rely on the default, they will miss out on this
> fairly useful feature.
>
> So, is there any downside to just doing this by default without any
> config?

The only downside I see is that this extra config table gets carved
out of main memory for every MEMORY_FAILURE user.

That is roughly 64 KiB per TiB of RAM, though, so maybe it is small
enough to just enable by default?!

Thanks for the review,
--breno
