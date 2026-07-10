Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B9B24DCF6;
	Fri, 10 Jul 2026 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783691313; cv=none; b=oedQGdlPu4oE01Rz6UGSPE1egGdnr+VH7RuqyfoA4Ud2JHpC9fQW/n7CLnq+U0Lqm5KsTiDrRPPON3dfuHgN6cXRYrNoSMFtYOHHieaVICSe38IfW7WlpNeO1vyAj7AnkkgfVHw0DKCAdP9xmkBPNx5uHn1BCkVQGpylG4A8v1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783691313; c=relaxed/simple;
	bh=1rQiDuFmyQTc45dNNlmvidmWC5c+gF53OqATGm3+jUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqyQWAcrRaT8RUCCXK4aq6seqSeikJqicZ5+4ZuRViDD3ANPxXE5ehvG3mmPemEdQQV3kHV6R+yuurjA08qiJH3262F0ZOsHz7ud2wCTuWyMnmx97dobhlgKq+jX9Qg/K1DyoGsPMAFe0+FYHDk3XbY//QxL1GAPowfZVZwCqfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=b/kLjpu2; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="b/kLjpu2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p0xPCXywvWmCNeuSV++rBW+PCnq/E7RY4p8aqyn5l8o=; b=b/kLjpu2lU4T2IJnIRw4mz7gME
	hK4z24HnWSGiYAmVftSaKRkDQCUyMMsojswFoxLAObJ+6YCZ7Ho8XTUdUlW2Fye5cuFkNnXtnpNgV
	l1/d79/BvicUyJxaVbSh+xF8v1o9quDKEgDiv4Npy82/d9y7mFb0240MD/DxyyTiX4nuPBkLiZAq5
	GnJNVxA8PkhWnmB7y75iWfF7U+4V7DHGEHn7x61z7pcgVwwKChreWwbKtQWvkH3PKikDf3fhHyuVh
	icmwrGFyJHNp/SwDj3z4VCCznLjPqmh7FLV/4IERPcSGtltnoOnMPeJBWA2laGaiiflVN4AJNhZmj
	mPheHXCQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wiBaF-004WJa-1B;
	Fri, 10 Jul 2026 13:48:03 +0000
Date: Fri, 10 Jul 2026 06:47:57 -0700
From: Breno Leitao <leitao@debian.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, 
	Kees Cook <kees@kernel.org>, Tony Luck <tony.luck@intel.com>, 
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 5/7] efi/runtime-wrappers: bound the wait for EFI
 runtime service calls
Message-ID: <alD3ZFgfgMj0_qoT@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
 <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com>
 <alDTjHtL5Q4ormKb@gmail.com>
 <alDW8vjjU_f7dkIK@e129823.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alDW8vjjU_f7dkIK@e129823.arm.com>
X-Debian-User: leitao

On Fri, Jul 10, 2026 at 12:26:42PM +0100, Yeoreum Yun wrote:
> > On Fri, Jul 10, 2026 at 11:41:09AM +0100, Yeoreum Yun wrote:
> > > > Hello Yeoreum,
> > > > 
> > > > On Thu, Jul 09, 2026 at 07:56:18AM +0100, Yeoreum Yun wrote:
> > > > > 
> > > > > One of my concern is for the UpdateCapsule runtime service.
> > > > > It might have a case where takes more then 2 mins and there's one
> > > > > RFC to support a runtime capsule update for arm platform [1].
> > > > 
> > > > I'm not familiar with UpdateCapsule. Are you suggesting that a 2-minute
> > > > wait for an EFI call should be acceptable (?!)
> > > > 
> > > > Wouldn't that trigger stalls and hung-task/wq warnings throughout the
> > > > kernel?
> > > 
> > > Might for default config timeout for hung-task. However at least
> > > its timeout configurable.
> > > 
> > > TBH, normally it wouldn't task more than 2 mins.
> > > But for a in case of *slow firmware*, would be good to make
> > > runtime-service timeout configurable at least?
> > 
> > OK, that is fair request.
> > 
> > I would suggest we do an additional patch with this change, if Ard is
> > positive on the idea.
> > 
> > Yeoreum, would you like to do it, or should I do it?
> 
> It's up to you. I don't care who will do this :)
> But if you have no bandwidth, I'll take once your patch is merged
> and Ard agrees for this.

Sounds good. Let's wait for Ard's feedback on the additional patches
[1], and we can decide how to proceed from there.

Link: https://lore.kernel.org/all/alDDv3XGXVdd1mri@gmail.com/ [1]
