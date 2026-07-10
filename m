Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E3E413256;
	Fri, 10 Jul 2026 11:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682092; cv=none; b=Ev6uuJ0VQumq3EfLy+QajIVOJsuTwHHv7xl1cN0qvi0RbmqbZtG2f8hO5d2q/vn/tvuUUp6tmxWDVIm+VekQaq4vPZg1VwtXDZPHDBMSKUCc3NmdrpMruWg6ZJlrujTx8n/ej4UJEnOOAEPmWsAwlUoXISSSZe4bhwyQgJ5ncIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682092; c=relaxed/simple;
	bh=dH4eygRRNfaOBK+uSPgS7cFU5t6mhKPfpcm9ebOjtC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tj6iUyAaI48uT962S5qqOaBDAGO4wxai3Tl77oNeqaCmUHWgFlAgiWfGunEzLVc89/UKD2qCco2p/jsubsG7zvFa4DPksFtkyRTzkvrX+eBkGLrhzJz2mr9j5F5LKJG3gHge1tWvwMklIrDn8ZhU5LggIcK/QO1e98ba7dqlDIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=t+fXFaWJ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="t+fXFaWJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=URERyriFwx+r+MkEJq+KkcYJaTrhaxr1UCB3wVvXGNU=; b=t+fXFaWJBtDIqvw6v3GZVFBpC7
	dngXG/4Tbzn22Tlh10cur3g99LT3l/ShNpRrL4ZRsaWQCNKLb05mr/fNP6VlHxE5j0Ejb5g6e3gv5
	17CmcCP9VG8gS/0Vst4nhjmOl9J6ROL0vGRBVXIJJ3Xx6wijd+mI7fCUu/nzcDCKOKQv08wI4/1Ii
	zM3+Lde74LU6XmYgUJDtSqyZQ1MObupEl5hM+CZSHb91cySRrsN5N4ylAVrPOIOjl4hCaybPAKvQD
	1X9hz0shZ88ppETSvb6dBaqt8td0oN7oku7tg1OezA+TG0d3AFzFAfEcz5MfXNIE9Ajgs+VTTulbi
	Apx+3Alw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wi9Be-004RGg-18;
	Fri, 10 Jul 2026 11:14:30 +0000
Date: Fri, 10 Jul 2026 04:14:25 -0700
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
Message-ID: <alDTjHtL5Q4ormKb@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
 <alDJNWZdBpkIZrcM@gmail.com>
 <alDMRabP9s6Pqhxq@e129823.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alDMRabP9s6Pqhxq@e129823.arm.com>
X-Debian-User: leitao

On Fri, Jul 10, 2026 at 11:41:09AM +0100, Yeoreum Yun wrote:
> > Hello Yeoreum,
> > 
> > On Thu, Jul 09, 2026 at 07:56:18AM +0100, Yeoreum Yun wrote:
> > > 
> > > One of my concern is for the UpdateCapsule runtime service.
> > > It might have a case where takes more then 2 mins and there's one
> > > RFC to support a runtime capsule update for arm platform [1].
> > 
> > I'm not familiar with UpdateCapsule. Are you suggesting that a 2-minute
> > wait for an EFI call should be acceptable (?!)
> > 
> > Wouldn't that trigger stalls and hung-task/wq warnings throughout the
> > kernel?
> 
> Might for default config timeout for hung-task. However at least
> its timeout configurable.
> 
> TBH, normally it wouldn't task more than 2 mins.
> But for a in case of *slow firmware*, would be good to make
> runtime-service timeout configurable at least?

OK, that is fair request.

I would suggest we do an additional patch with this change, if Ard is
positive on the idea.

Yeoreum, would you like to do it, or should I do it?

