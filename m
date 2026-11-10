Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313865;
	b=LzVSHXP8h7NHoCSfqxs7drE/u4ACGHDn/Ip0n1HUt0kAaZj/RTMZNPpt0aA/3bR1PE1B
	 i+XauViTLKrnBC3asm7Cw5s6FdKj1K+mY25S8QoiPt+BqQd0AKK0jTTUIWBfnImgGKb9/
	 1Jm1JEN4adqSw7id9VIpzG/YPSs7MA2l82IOSl9DoRDWylVPvk2BOYH+RDtEqUErOiLsI
	 /VvE58+MRtxinS3t8U3+Ij7xj6FzYTRCf4NpAzoiA1PiMS97DGGqrWT1hP45xuuvzhoyV
	 KAW8OCrOPm41euCMFesfzXAOAIV2zU3AfS/rmaJ7l03fm5G2ZvjXuqssHOJKwpOSLXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313865;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Xp1tYOHsoib51sVlLRtojGz6nU1ioJm/CSw3LZAqOuY=;
	b=p/SbhR3dtXn5MZzJe2dwHG0x/BV074GRnELlrMNMpH1FeKKIsEfC7f1eHJIcbP6p/zLB
	 bWWdd6NZeLng3uOKrxJUmnCewnpRK8xF1CnBSDOBTwJOEJfE2MvayGDWrmF3ARqNCTzcJ
	 egJf9xImAUK02rFCezuuFGgp5rI6q8rvvGlO+9KVAo8Z/cL1NOokMK7IpdH3/V2hpNjDU
	 GGv+Mx5p8rwU8xnMMArV9ptHXl4h/iDG7iQ6NDMwxRG+iCTGHjsmPoV+ZzuccxJod/t7C
	 6yatUBrK3DTK8Viz6MQzYgFPNTHjf8TeMzBFrHUfFDRRV0p0Egkk92toBWy8fNa4MsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G9fKnlAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C73606A31C
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=G9fKnlAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A253C1F0089F;
	Tue, 10 Nov 2026 12:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794313865;
	bh=Xp1tYOHsoib51sVlLRtojGz6nU1ioJm/CSw3LZAqOuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=G9fKnlAbCHcpVP6ne/xJClZnO2UQ7lObaQJN9J0GUKqyc5JrnNRH8UN/AV8vECQcF
	 Mmb8YI8z8i3+XhVfZ/WrbBquck/W+wFfNnyUn6fyYSnm5bUhKVTD4YWXCx6rGkz0ZU
	 rUTiYroyFVJ9M+EbBMi/0AyKWPPnxIchHZD7YKhmEiCHGj/setMMkFagTAcFm6ldYb
	 0PsIa9ajCUNN32O4+OV2cEgbSCwqoW7vmWK1OeqSFes5GO5nnsoAbTHeCF4OnZQ87w
	 N28NCwkjGvmgAyqMqBPCKzer4OshSd7bBaVvDhVyzNF68TCfDJx2KKXHOYOQBl/XC1
	 WX7/ldYmuSyag==
Message-ID: <sashiko-outbox-207020@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 01/10] efi/zboot: arm64: Add missing barrier after
 cache maintenance
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261110121731.2728824-13-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-13-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:31:04 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] efi/zboot: arm64: missing dsb(ish) in efi_cache_sync_image()
  when IDC is set
- [Low] efi/zboot: arm64: missing Fixes trailer for
  efi_cache_sync_image() barrier fix
--

commit e6570e5cb733b9a306b82caaabc5d43037fdb9b0
Author: Ard Biesheuvel <ardb@kernel.org>

> efi/zboot: arm64: Add missing barrier after cache maintenance
>
> Prevent the I-cache from fetching stale data by issuing a barrier after
> the data cache maintenance completes but before performing the I-cache
> maintenance.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

[Severity: Low]
Should this bug fix include a Fixes tag for the commit that introduced
efi_cache_sync_image()?

  Fixes: d9ffe524a538 ("efi/arm64: libstub: Split off kernel image relocati=
on for builtin stub")

> diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/=
libstub/arm64.c
> index e57cd3de0a00f..62fc8e53c8a04 100644
> --- a/drivers/firmware/efi/libstub/arm64.c
> +++ b/drivers/firmware/efi/libstub/arm64.c
> @@ -107,6 +107,8 @@ void efi_cache_sync_image(unsigned long image_base,
>  			base +=3D lsize;
>  			size -=3D lsize;
>  		} while (size >=3D lsize);
> +
> +		dsb(ish);
>  	}
> =20
>  	asm("ic ialluis");

[Severity: Medium]
Should dsb(ish) be placed outside the !(ctr & BIT(CTR_EL0_IDC_SHIFT))
block, immediately before asm("ic ialluis")?

When CTR_EL0.IDC is set, explicit data cache clean instructions are not
needed, but a DSB is still required to ensure the prior stores from
decompressing the kernel image have completed before "ic ialluis"
invalidates the instruction cache (matching caches_clean_inval_pou_macro
in arch/arm64/mm/cache.S).  Otherwise the I-cache invalidation can
complete before those stores drain, allowing stale instructions to be
fetched.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110121731.2728=
824-12-ardb+git@google.com?part=3D1
