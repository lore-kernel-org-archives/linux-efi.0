Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794536260;
	b=XHekmmH/qBRsXa8fvIRnsIx95HF439vIED+nYvMsMrUVWp3qcs6Cb5m5Q2mjwleFOaw/
	 ZnFszYg0Ajv9DnnTktt4GWZfa6dbmL8P02KVkv93ZXUPM6nvNS1rRGNzhV1T/4wjFjzUg
	 amOUlSNIK4p2+L/cM0Op+iqv/FChfe4MAhLM/irVanyu0AJeKJy0Pc7HdpTlKr9cP6XK7
	 Za71d6X01hmGLX1BcnmngmeMy5ASI4ONrwYNhGFavc5ycGHxOWq/E/zc+QWs9bGzr6FHi
	 EK5fSNPSOWoFABd5clDXS2q8wJvDCegN+x1WQtJARyH945wfyznbb+/TTDjB+RT5KYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794536260;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gt6ngKrXj6yZVMJTkP9nM4ErkggxYHCpOSCFFeCgg7I=;
	b=qY5Tv5yc4XVDZbnl3Oi4lKafyc6Ss39+PNrtUIMJLH/MU60u9XxHgoKQeBSy/5J4n0z1
	 u6Aux+Pj8PJQRkfvYT72YGPqF0NbkcahSrIzIzFHH8BSoe1A2/ETI0wuexpU1pIZE3G9S
	 ZURLZokbvX9l2/LXdTPd/ko8t2dRkgEeXCwh4H+zlAtWyxAv6u8pA3y3QApd5eW/BIUei
	 rL+LswA83D6FE/fc8/ll65UmdwvrUP1R/qlFO3BarBdpmV6tlLy1oioXbZanUuE3E6ReG
	 LeswbqhhjLYLJR5P/9oK5LQyRNTqcQDXoi9eAo8YWM4dKFjqh0QRgVf7FGmr3YPCW6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPEUAYlL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4F240606A327;
	Fri, 13 Nov 2026 02:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPEUAYlL
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 696881F000C4;
	Fri, 13 Nov 2026 02:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794536259;
	bh=gt6ngKrXj6yZVMJTkP9nM4ErkggxYHCpOSCFFeCgg7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LPEUAYlL2s7GPMEubG75O1rS6e6tzr4NOAx46UXUuSAxG2Im1JWKVo7QZTH2W+U0b
	 JccgrMBI5WA+y4ctbE/lcHEDoXWgmbj4GmnWFs4ytWCm7kwGNV9TEC625gGONdIYZ2
	 ct2YSEXOAft0fSoMOkUG9eBx476gTli8uhqHBfQ4EuVMRNQ0tM2p/wLLqbtBzwcOla
	 mg14LQjrBNTmYIfJfnyCWGgygsX0OmPDGCF7PdCU6WKAOQFBe5IZDmeDywoeR++TRM
	 x/0xmPY/l6N2YEGx3TdSrLFJriJ2JHtd0XtZ3pEJqF7eydBEYdTFUCOeF3esw/9lFX
	 iCw8HjQ+xv/2w==
Date: Fri, 13 Nov 2026 04:17:36 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Matthew Garrett <matthewg@nvidia.com>
Cc: mjg59@srcf.ucam.org, keyrings@vger.kernel.org,
	James.Bottomley@hansenpartnership.com,
	linux-integrity@vger.kernel.org, rafael@kernel.org,
	linux-pm@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 03/17] tpm: Allow tpm2_start_auth_session() to start an
 audit session
Message-ID: <avZzQOKQeagXMDaE@kernel.org>
References: <20261008132532.1155166-1-matthewg@nvidia.com>
 <20261008132532.1155166-4-matthewg@nvidia.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008132532.1155166-4-matthewg@nvidia.com>

On Thu, Oct 08, 2026 at 06:20:19AM -0700, Matthew Garrett wrote:
>  	struct aes_enckey aes_key;
>  	/* saved session attributes: */
>  	u8 attrs;

I think the comment above should be removed and the field renamed
as saved_attributes.

> +	/* set TPM2_SA_AUDIT on every command using this session */
> +	bool audit;

This is not probably needed as you could just as for me it looks
like this reflects auth->saved_attributes & TPM2_SA_AUDIT.

Br, Jarkko
