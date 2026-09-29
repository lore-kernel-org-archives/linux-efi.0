Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67C53DA5B0;
	Tue, 29 Sep 2026 03:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790650907; cv=none; b=SBj5ZiyRVepdCHyWkJPyn89ohf3YaaSoo+hDXbjFI36DtGFNFSV0mviCIlvESXIQBAJkm7WzaBQvLKVFNt5cILWmaHlZ9EMDy8SXVepPM/xeMQ5b4QztOEuSAIZ3XNtLNE675hYU+eDLR6u3nqAK8sNX1oLCRo+EmyskdHoC3lI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790650907; c=relaxed/simple;
	bh=auFnrynyRcA0eq7GmZvTDTnsdKeuO5HNHn9SWlKXYZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sR3prbo8A6iD0L3tHhJ3DgnMcYDM1aFw500pgbE6qi9uMVsQi9jLUTdOgnrp0p8CGN96HsRyS9hrNcemAMc2Hmn6b0fKwSze21e60+PjoTqNelJxfHOy2t5mteJaWhP0/gqd+ulF2EpD9pKxJJUKb2+EsdFFEaioJtxzkIW5KD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=aOhNaOqj; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="aOhNaOqj"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BE43540E015D;
	Tue, 29 Sep 2026 03:01:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id DizVyJi-R1iM; Tue, 29 Sep 2026 03:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1790650881; bh=1zsBA5L9q90S6Xmz583yr0sOxlE6J2yiX4OfSsQ85RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aOhNaOqjQlwJ24Jw/KDQFGBTldb9xQJJah5x/5PSyVC2gcxrAJR87p4kHB8gsxHsd
	 jF5/bFeeNQwc0UIl9wNAgoEiLbSbITRF2yhIP1IeSohg5nlHXB/OUzT/mMQNn1fouV
	 pevAgF79w9ZLl91GYrHEWUzyJgk+yMn3iaUce0wnbUqhwwjWQ85PHRJDGxleA3yIWV
	 u6VyGlz4KfeWk+qiz+wEzEtSvJmeBLKUMCtDp7TMa6+phllrE96Y9SvBORUVXpynsm
	 CrugLLGP7u4VFMcGqCL115MTXvu4S54uvljTOB1nmyXYGApB9VV7/ykTP1IRmTwFhd
	 XdweTbGUhIlz58y/7UmKoj5Fuy2VU7foakBtx6tdpEQolIAywqdNA91S/YnVcng/1R
	 dlVPWyLGIrvTO276yvfKuB40HKR7GR9+Aj4Iat2IiGV1UuIUK/4Ug3h3uyQVp5+WsE
	 8dzfwmXM2oyL2duzAdWl1KzkGqN+yZYQ7+c7AkeTevaK93eXAHC+lrCCJJgyZ4vCOA
	 H7aHRAS0SrrwyHyWrYXGjARUZTVtXzQa3OoLNckTzVAlIkoMyoWjqKbOuu82kslYGs
	 iWixnGRYXzlQ7pabG1tImJRGJzS5UKsh+I22vEeChwpsypCgYiv9YC+YXSuFETIcA2
	 rfKWIvTQogsBxKdImsjvhQ/E=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7419840E015B;
	Tue, 29 Sep 2026 03:01:14 +0000 (UTC)
Date: Mon, 28 Sep 2026 20:01:11 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <20260929030111.GBarsp9y94xbrKhb8k@fat_crate.local>
References: <20260925075137.44298-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260925075137.44298-5-ardb@kernel.org>

On Fri, Sep 25, 2026 at 09:51:38AM +0200, Ard Biesheuvel wrote:
> This is a follow-up to [0].
> 
> Move arch_accept_memory(), which is only called by the EFI stub and
> never by the decompressor on a non-EFI boot, into the EFI stub, and
> avoid relying directly on decompressor APIs such as error().

Ok, pushed out.

I've also pushed a tag for you to use:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/tag/?h=tip_x86_boot_immutable_for_Ard

HTH.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
