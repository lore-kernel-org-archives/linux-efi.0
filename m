Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4313D13777E;
	Tue, 15 Sep 2026 00:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789430544; cv=none; b=faZnA88vvThGThquxcgaPmomY5+h9SpHOahzzxVSVuyHOq0+c63fHu0DH2atLdyJDgO23iG7ByyAqeTOdHIfxz+UuJ6N4v+I+xnjZsw40dgdPwEVF8LScTNlgbpBP7ifoKPBIFzSnf9fd5+tFR1PmotDWPExhrFYicakHF2YoPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789430544; c=relaxed/simple;
	bh=NJfHtM03swQF0uZl+7QEnzYxlJxfAuSvzCRdiP7XaSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O4lvUS8I/SZaHo5jQE7SKv7kDXDRQHTvQbJCVMU0/4a0CJgsI2F+NIQtczQLF/f+GQ4PP9vMu5rIu4OxQabzVkzvRgsD2Cjrnj2A9ST60FGhp4IosSkI3xaQakgaftyLPbwqhoJSieDftFs5y73STBW+RUIra4U+zszo49J0n/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=e+UJx1oQ; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="e+UJx1oQ"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3799D40E015D;
	Tue, 15 Sep 2026 00:02:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id toROeyS8Wv_3; Tue, 15 Sep 2026 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1789430531; bh=iRmgXTUv9HXiuTgQu0nzskb1YRU+ZqE9qUW7qnXMjNA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e+UJx1oQ/N8olu9TZYeiAv0SsIwFyPbJTGwlQxhoAsEj623EQfSt1myEQZHbFdLit
	 OLCKP9s+clTs6VrQrF//2wljNCdGR75YxdOOrrbtcYVxM6Vk6TcTpVCdvBg+fZJPrr
	 ORWHn4Dm0mYh84rIUZTEhS8+3ZDnix9CMbKm+RDTLmvLpJezihdaPWaZPU7Wk3DxOn
	 9o8iajrppssIl39CHehF7vMCRLxS+fO7oarfyEuHto467QgQgiYATZcV653rHJ+KwZ
	 bOB/ECgdOO/7bjsh6u1ZaYxG3kdmUwOm0+MO9s4eNUHcUnrUbd6b/FagYNL7UN1wNK
	 mk2X673+gxZeaQtXRHFC3OvASCf7QsoPZrEJgUM8yQLbhVImOoVj9qZPifn7aJorkB
	 BfAUhGkEjaSc/IR9G0IJxANWpa/ziqNxM0xRXKe8S2kUTsKNbzLQ818qnauV4tZ1FZ
	 Z99BtGzcCTIfzvAW+koARQRpuyoKpkge1V8r1/1AzOQc5rsRDUAOLSv0vn3UrIix6E
	 VyDclMlh49ry0UkIW5sGF3iPMscJxABLyvtmr/TMygVaWSVPV1heZUa2kO2iwrLOxB
	 fIO7gvjoxoKOcOhDr9dpF1fLb6YwJf3AKdFN3bg21M0H7yVKqoGa+udpSRdCferZ/a
	 mwEC/odlocb3NitLirsWvgiw=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::e])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 9AA1F40E00B9;
	Tue, 15 Sep 2026 00:02:03 +0000 (UTC)
Date: Mon, 14 Sep 2026 17:02:00 -0700
From: Borislav Petkov <bp@alien8.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	CoCo ML <linux-coco@lists.linux.dev>
Subject: Re: [PATCH 1/3] x86/tdx: Share tdx_panic() with the EFI stub
Message-ID: <20260915000200.GCaqiK-LBCI63KE9F7@fat_crate.local>
References: <20260914183745.37538-5-ardb@kernel.org>
 <20260914183745.37538-6-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260914183745.37538-6-ardb@kernel.org>

On Mon, Sep 14, 2026 at 08:37:47PM +0200, Ard Biesheuvel wrote:
> +void __noreturn tdx_panic(const char *msg)
> +{
> +	struct tdx_module_args args = {
> +		.r10 = TDX_HYPERCALL_STANDARD,
> +		.r11 = TDVMCALL_REPORT_FATAL_ERROR,
> +		.r12 = 0, /* Error code: 0 is Panic */
> +	};
> +	union {
> +		/* Define register order according to the GHCI */
> +		struct { u64 r14, r15, rbx, rdi, rsi, r8, r9, rdx; };
> +
> +		char bytes[64] __nonstring;
> +	} message = {};
> +
> +	/* VMM assumes '\0' in byte 65, if the message took all 64 bytes */
> +	memcpy(message.bytes, msg, strnlen(msg, sizeof(message)));

I'd probably do here:

#define MSG_SZ	64

right above them in the function and use that everywhere, esp. instead of
sizeof(message).

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
