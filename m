Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1148F14AD0D;
	Mon, 14 Sep 2026 23:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789428446; cv=none; b=GGSun3vOtATlIojx5XoSkFnkTuL6s8e8AGGWOX+MBt3/eUNtsjhhc5CHIkorjpCFi/FUyWiXe2jWI6yBpnkwvsCTTdVkVBzp08ktg3kNTV7y87qD/Ke4YIdw9kQeVv7JEfD5S5U32e+aWV7L3EVTRFCA5/0+2p8XS0R124MDGbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789428446; c=relaxed/simple;
	bh=szujVo5dGjMwau5lO3V8Ko7qA5dX74h9/P2Aqs+6iKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+640t/GP/VfnfeVPKbBzz97hP+e2M2BDxdn69IjD7+n1a7JoE1pjiVixHL4aJpeWYDiPJqoNGv11n+FziSc9LODOE8KaWV66pUdMNu4J5K6KEliYcqfoBrvucIG8rKOAO2ZolLlUvFgzYlQ2WaCmeRhXkye3Wsr0lKXjc4/9Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SA16P+ze; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SA16P+ze"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 754A540E01DD;
	Mon, 14 Sep 2026 23:27:20 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OnKcrYgxZEM1; Mon, 14 Sep 2026 23:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789428429; bh=PUYY/jgMXk7820/qpoGN0zvwLGgfCUXovR7y++xId08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SA16P+zejLsGFE2kaIC8CqrFkHsKFS42TeGhlqtSrLre1SzJZ9MN15V44mPtpkQcw
	 pHdYyGLbwZCyLLIxodJdfsrWb14AtD+f3Yoy/V+OGYSgyAQp4EMmN7UrUz3rsuPIu5
	 H90pYBaDQvExhaKvUUdb2NWRlrVYHU/sZIFmoUig/hjUz3eqNrmEzGz6CzbQ7pTyPX
	 Grgpu+pQOTvq3rxT+cpKiAT2rmfcxsHcpJoqp71GzSgN1NBilKZq0kAScw4W+ES9Zi
	 qsQMQwqcKrPp+aQbLmkJDYLV6QwmNqXJXn6GcpzjmLs2T5K0cunAJFOmYvcBQF0CHT
	 tqghhT0CRENjMH+rflFRzN5aaxLHEta3kWm+Bo1OwfgFSGv9p4OHdpWgXdKYLLbUVB
	 49tfPjiU4yxD0KRF8ehnTnr0WGqUR7x48g7Jj4xfgz1dav/y+mmJ4XmqCEiPty23B3
	 swSTkYC7vl64SWarGKTcwGjqDE/66FmEf1l8OSegpRqTzf3ybwhoV2tbqoSHbTRzEo
	 6PIh3/t3cN7YpS+XpRpzs0qPPT78yTJzyo9Wnh+CEUM87U4fHE+WlFoc20VPVAAC/E
	 mUzPcP7zDs/UNbH1mXS1Ie2g4XpNcBYr+5uB3ctxNnLYznZWBoqC5BnBO/mDmXxzGL
	 4IWEA+Vykc8L1/+oKOUehr3Q=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1AB6C40E0173;
	Mon, 14 Sep 2026 23:27:02 +0000 (UTC)
Date: Mon, 14 Sep 2026 16:26:59 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	linux-coco@lists.linux.dev
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <20260914232659.GBaqiCwyPTxm5wL0Ay@fat_crate.local>
References: <20260914183745.37538-5-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260914183745.37538-5-ardb@kernel.org>

+ Rick and linux-coco

On Mon, Sep 14, 2026 at 08:37:46PM +0200, Ard Biesheuvel wrote:
> This is a follow-up to [0].
> 
> Move arch_accept_memory(), which is only called by the EFI stub and
> never by the decompressor on a non-EFI boot, into the EFI stub, and
> avoid relying directly on decompressor APIs such as error().
> 
> Instead, call tdx_panic() on a failure to accept memory in a TDX guest.
> 
> This makes the decompressor's implementation of panic() obsolete, and
> allows it to be removed. This is a prerequisite for dropping the
> implementation of snprintf() from the EFI stub entirely, which is what
> the series containing [0] implements.
> 
> [0] http://lore.kernel.org/r/20260909115530.1924665-13-ardb+git@google.com
> 
> Cc: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> 
> Ard Biesheuvel (3):
>   x86/tdx: Share tdx_panic() with the EFI stub
>   x86/boot: Move unaccepted memory handling out of the decompressor
>   x86/boot: Drop unused implementation of panic()
> 
>  arch/x86/boot/compressed/error.c        | 19 ---------
>  arch/x86/boot/compressed/error.h        |  1 -
>  arch/x86/boot/compressed/mem.c          | 42 --------------------
>  arch/x86/boot/compressed/sev.h          |  2 -
>  arch/x86/coco/tdx/tdx-shared.c          | 35 ++++++++++++++++
>  arch/x86/coco/tdx/tdx.c                 | 35 ----------------
>  arch/x86/include/asm/sev.h              |  2 +
>  arch/x86/include/asm/shared/tdx.h       |  1 +
>  drivers/firmware/efi/libstub/x86-stub.c | 40 +++++++++++++++++++
>  9 files changed, 78 insertions(+), 99 deletions(-)
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.47.3
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
