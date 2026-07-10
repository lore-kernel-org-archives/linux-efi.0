Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559B83F927B;
	Fri, 10 Jul 2026 10:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783679452; cv=none; b=PrVW6uOAz2xW6JWRsxVN/UdkbWV2p55gGN/b2ZLrW0a/DMTS3jZnBGaxfXyStUfiV1B7ZvWYcR16dmLBaK1JDy3DSIoKnHPK8kF/DbpKFMiVyWZfi+0SWgEg+Q1T896mQrtHtudo1TmNX2LBhEBH2VCf+Ik1eqyovCengIb3T1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783679452; c=relaxed/simple;
	bh=eTE9te8IlgS4t8DPW2J7FTCETDyWuLrYDq1Dr9d+Wto=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGJF30gndC+Le5cbfEY6y6ncYhe1IpdQpVtaRm9R34D54M/k9dd9yg8mElMBPLyMsDVlW4Jul4/k1IbS0JVqPgYS0tJx4E7VI//szeLiCpnUS9N3gQ9/906pKB5fG5PUCu5K2LYQmnegW/bgWfgkqwgETRM95FSpdrWoZl1VE24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=vo+e80HG; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="vo+e80HG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aVkvyZirvmvuldtKXU3SK6JQ1BYkg3/bw93KoV+bSoU=; b=vo+e80HGpExdlttM8SulM6SpqV
	kfpoUDppD7jaNq++2yhzlebvQuHXyN/lPBR1/JQ9dgQuuwXmwTr9ksyNadGBTIbwqrhv7eyP56suI
	DWQPCSk7BOXJIVZCcIzhxQPz0Ifu+kaX7cr3WCdFEpnK06QUxvRPp4vlZYJUKc9vJr97Wy3ZYd1q/
	tzTBo4ScaYryn80BmhR+nl1BsJ/JuPHh9YnGAvYqfOFQpeagbLfOE0dsEuyO6Y52vRlnTU0ai3EKz
	SR0Lahmuve90sIiTkWxRRdQtWTZybyYwOMd3kzV/knR5ZWY2ZgTixKSi+v7jr1j0WDP03dD0vjsaZ
	6rRLmuJA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wi8Ux-004Phv-2d;
	Fri, 10 Jul 2026 10:30:24 +0000
Date: Fri, 10 Jul 2026 03:30:18 -0700
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
Message-ID: <alDJNWZdBpkIZrcM@gmail.com>
References: <20260616-efi_timeout-v3-0-76dd1d26657b@debian.org>
 <20260616-efi_timeout-v3-5-76dd1d26657b@debian.org>
 <ak9GEtPuFv_1Sqcw@e129823.arm.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9GEtPuFv_1Sqcw@e129823.arm.com>
X-Debian-User: leitao

Hello Yeoreum,

On Thu, Jul 09, 2026 at 07:56:18AM +0100, Yeoreum Yun wrote:
> 
> One of my concern is for the UpdateCapsule runtime service.
> It might have a case where takes more then 2 mins and there's one
> RFC to support a runtime capsule update for arm platform [1].

I'm not familiar with UpdateCapsule. Are you suggesting that a 2-minute
wait for an EFI call should be acceptable (?!)

Wouldn't that trigger stalls and hung-task/wq warnings throughout the
kernel?
