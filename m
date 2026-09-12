Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619519463;
	Sat, 12 Sep 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789235676; cv=none; b=Tj7abiPSrDejes8VMVXTjdeZh4XmYJMCuknjGtoeaPkP1untTmVTerKmJamV3e80vORBGJAGCyBymAWZPFa1hJUrWKM4xs/jcxPQkTR/WrgDS8iRnkV7Uo1D3o8SSgSI3NL9HUfPXWG9epvHWf42St1w25WaBT8hSzosNsk9deo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789235676; c=relaxed/simple;
	bh=NuDhMiuXjUDPsvc1rMiisSOBLgbGolSicgyeSQRAP8c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEQ0HvxS4NLqn396EWgjdUiIp2fgyAgT+wJ3ohbMDS1xefN8nVw7jUj500DmoAi9/FVOxGFP4YCfDv/J63LKUBS94iXUlPxmjEUmWI5L+RM9/3Nv6EDv0HFvo8NLyFeQLKJvYPSnS7wk+DUOE9ay7VsQvPfL8v8sTdfG82CbmzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SV1jhgZZ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SV1jhgZZ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8AFE740E022C;
	Sat, 12 Sep 2026 17:54:30 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id cKapIw-jtpu0; Sat, 12 Sep 2026 17:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789235660; bh=zKIKkC+gkaHV0EF1bnyPpxID0VcZErDzjbOFlvEE/EE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SV1jhgZZv2LcJQpG4AojPe7aJqtpVaObgDPcNMYOC/a4Wp937O1wH869ePf5gd1V2
	 ChxCjsEV9TY4dhwyeIFzgx5cAY5uUJd3pevHgjaTCzRV0Xca1dSO0hdIAGcpsiuOZP
	 /4djKa81pxzQfJl1olkcv3OJfaIWDFk5jcZhQ7Q5cD8lne7teYvqmSRLTl1Cy9Xorc
	 xK/rqPBjDo8a0Q0x4YVjhLsS9h5citgdnPR5qqdwYVRS7LfzZjTzio/wxMWyjCz4RQ
	 D6DhK8qEP2vMzHT6VL/Mg1BXwFY7LQ/Q6AJhZbtJPf2yOebMyKx+XQbUfHHkxDSq4U
	 rwO2De8ArvlV4POlPKYoU0qjh+wqsvW+orhhSrhP63syauMPmcPnQAbqDtxSegq8cl
	 69esYRN2SRRpydWEFQ2R1YWOmWv17/cRT16qCG1MjkkYTjbA6t0TjnRyzOV6C9oktn
	 iTdYFXSw00xUFPkjJK3zaNfnQ/B+mFLLGeu9q+168csF2DUsrHhh/rbiq4L9EtHqwB
	 aI8fgEaGztjCTeqp3pjOs+HBcidPsGNL8Q44a8SVoHqsdURnUfvIaWaO0PxDX27mwh
	 A5GWpdcAlU2uOlD/xNSH60/h+MX3fJFsoReycL5biweobLx3nk7Dvc1A1P9wDBkNzt
	 Dhn7PBs+0I7msRz8j0IQas5A=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2882C40E00B8;
	Sat, 12 Sep 2026 17:54:12 +0000 (UTC)
Date: Sat, 12 Sep 2026 10:54:10 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of
 panic()
Message-ID: <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
 <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
 <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>

On Sat, Sep 12, 2026 at 10:41:56AM +0200, Ard Biesheuvel wrote:
> If you're not taking it as a fix, then yes, please.

Help me understand the exact problem pls: 

That panic() function gets called by arch_accept_memory() and *that* gets
called only by code in drivers/firmware/efi/libstub/unaccepted_memory.c or
drivers/firmware/efi/unaccepted_memory.c (but that uses the kernel proper
panic() one).

So we *are* in the context of EFI boot services.

What am I missing?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
