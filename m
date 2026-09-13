Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453123F0777;
	Sun, 13 Sep 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789323110; cv=none; b=rJMRw+zVgcIorXB1mRVDticX/VfrCML52qM6N+pPwcOwBGR8C3zB/YIX4HWrvw1f3ycKTUBzF8eyzydWZno4ITTbXyf40GX16lb3uAHUEjCua6DvOaNRABJD9c+wlJuSIwloW08atWxCgAa99p9bYkicjIi7r1AvUwVXmHKPkCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789323110; c=relaxed/simple;
	bh=8ZnZN7n0Th1y2X1DfV4aT+zqOCSuSfWjhRKR9vQ0LOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vs21DKQyk2bTQmvp6P15QkVAmvuqN0bKb013sOscYVlQRfoqFbDEnjju4ztWA9IwSJiZWP0SrZpb8rWaNc4RUh6RXJKSrb+OwZCbwwEw0xB6ZXIO7wJxrjjLyG1g/YW9muV/m0HJKrNKy9K8a0Dlr/GVyARwJcxhrg2VJ8H2mlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=FywKyipK; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="FywKyipK"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8E52340E00E5;
	Sun, 13 Sep 2026 18:11:26 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id l7WAbKsjbCMl; Sun, 13 Sep 2026 18:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789323076; bh=+T+6MRlx6CAN5xx7gjZjiZoB1gWMFqOP6A2IEw5qQCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FywKyipKs82T6TLEkjfoKj/p1lHrJJoixA7VwE8+gpx7hcm7Hw4WnohINB8u7rhXZ
	 bdzAR5h7OimUp996JZFYhgvQtuApV0G37C24jBm5daC4GJV1ocf/iZzo4YytlxHZza
	 Q1Af5nsFzOURuqg0CkW88e45jtXlE2CEHmLhjCKJH2DwonHdlzUUej9JVcE/X9DwRw
	 CMcGZe0i4AVS15qQwn18i1OxGoQxvmtyBM+JTyPI1Q24/ir48LjcY70PQGtvV9/GXR
	 mxW1lM2cuxzaZO+S6PgHFJLcN1aPBI0oDlgDY1Kl0i0zsHMGcO1U2BPi5Pb1yW9MG5
	 p+y/QlkGOfXTzdFeTdALh6Brp0QITgR0iAhegSg25Z8MEiBs4ciUdfnxvB5CcB2ylh
	 gQm2XnKPTQhEE4ERSad2ZjY3en1m9XidnaDTmNkMMaqhhQdpCVwquWqiRbWUGs8/7z
	 8aN5SBePcFqSl8M5TQ9/C7A+XoyRkGC+SpPTEuCdaOZmNyi8bsK1mP+IOCW9r6/Wlj
	 h4aAXlthQYvLdh6VGIryDa3KiMBGHpwdIHNa8WE16h0/RGRVTl1WlFmEFsSts0xCyt
	 WjhjB342GW2zu8WDOrtz4bhbv/LjOHHkeasvmWl115Hz2keRBeewFLCKl7HS87Da5s
	 z8bqw22Zxqw9Ug4mOcyDvoFE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1D8F340E0173;
	Sun, 13 Sep 2026 18:11:08 +0000 (UTC)
Date: Sun, 13 Sep 2026 11:11:05 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Ard Biesheuvel <ardb+git@google.com>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vincent Mailhol <mailhol@kernel.org>,
	x86@kernel.org
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of
 panic()
Message-ID: <20260913181105.GAaqbnOUDX2YNFW8iQ@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
 <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
 <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>
 <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
 <862d50e1-2072-407b-882d-5e3074a3c225@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <862d50e1-2072-407b-882d-5e3074a3c225@app.fastmail.com>

On Sun, Sep 13, 2026 at 06:35:33PM +0200, Ard Biesheuvel wrote:
> The reason I want to get rid of panic() is because snprintf() is going
> to be removed from the EFI stub.

Ok, I'll queue it into x86/boot and give you an immutable tag it doesn't look
like something urgent to me.
 
> So I think the current patch is still correct. I will follow up with another
> one that moves arch_accept_memory() into the EFI stub, and drops the
> dependency on error().

Ack.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
