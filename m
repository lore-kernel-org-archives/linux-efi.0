Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975661;
	b=QQ0+dpsXgbGoGWfS+cDSIJ5LmuJTONAXIoNPfjP2hXvbv+YpdvxcSVx7wJUptw2oyofg
	 djI2skIwNG3+goQWmL5jsvfZ7z5yQ+BsC1KM1S/Mzj3as6vJA8bo3CsJAx4veYkjiQO5X
	 8zj/iOuPibgO9+u4ERkj1ZyoNzySfhyPhqxDUli5+cSXTUyDkffpi7LcNG2MoFMTRQgEh
	 TpOqFqA7p3EIENguf2E38HlgcOGYL9a433pwjQv/vwnuYUxXQr/arPD7/+PGXfTLSVA3K
	 ul72EPF6MSB2KRmlgcQkmfZKKbm6e2lObB1xHzuWRiy8zqtPbTPk+u7jQ12sW5fPU8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975661;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kXmXl/Rwf8V1iqZXYuEqdBxWJuGqqtcyLegwix+W4r8=;
	b=MdTNpoqkbPgFxlNZPNlRxHp5SS6LKacUuxnSYeYUy0H4IEMR/cUIca4vrES0VwyCiRYN
	 7Idm6Ghq6uEggS/qhsNl7i4MK9EVRlw01oXEa2QHBY8nKfKLX6FYAdkBWfJCzx69AaKVM
	 i6lKWsrezYDwNIM0YzWffWmgF6/IZMsDENsQoiZJZHUgGQHPPcKmQO/NJUUmLeEZi0vWO
	 0b5zOlDkHPREUJ8lfCVyEcxPlt3SUr80OWTx/k2luJlyWO1ZKSwdY/QA11uMWnoljlga5
	 P/8FeEy+F4UUONXp96IyEHGuPRCbfGnjGEjJeJIsPnifS/9Jl9GW7KkS9iqrXrCu5iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cTUCAJqK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEDA606A336
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cTUCAJqK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DC91F008A5;
	Fri,  6 Nov 2026 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975660;
	bh=kXmXl/Rwf8V1iqZXYuEqdBxWJuGqqtcyLegwix+W4r8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cTUCAJqKq6zfhnXgYrMqouHzaH/nNQ6SHsvHHLGJuAjsLIkuLHcL0GdJalAsIifUU
	 8qQ2n1T5Toeo1pjOPYGgcWEr9Yx0QOqx+rmIQr+/K6QGkCtnldeYHUO9vPFM7yXgf3
	 EL2O2uvo/QTjTosAr+j00bdv62aBFiIEUvXF1Xt9qghH7V7D2vhvkoOMcIu322rkKs
	 xRTJtbH+pEgym+8de3txKSVIfYnmTsTUIQPR5opdSndJazvCKLvWb5cauCPufIZayz
	 RAxwtlMQZ5Y2TYj7kApQNHf8JgPLOZBXyF4VfLT0qauPtqhNdgVPCW5sTRle6cAvAX
	 vUTdZ1k4lSBBg==
Message-ID: <sashiko-outbox-201591@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/5] efi/zboot: Disentangle efi_remap_image() from
 efi_cache_sync_image()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, "Ard
 Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>
In-Reply-To: <20261106141936.2744481-10-ardb+git@google.com>
References: <20261106141936.2744481-7-ardb+git@google.com>
 <20261106141936.2744481-10-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 14:34:19 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] efi/zboot: duplicate efi_cache_sync_image() calls after
  decompression
--

commit c04555ab5ec2e8a3cceff169f625d907a16b1267
Author: Ard Biesheuvel <ardb@kernel.org>

efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()

This commit moves the efi_remap_image() call out of arm64's
efi_cache_sync_image() into a new efi_zboot_remap_image() helper called from
efi_zboot_entry().

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/=
libstub/zboot.c
> index 97ae706c034ad..27f6661253c08 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -36,6 +36,26 @@ const struct efi_image_info * __weak zboot_get_image_i=
nfo(unsigned long image_ba
>  	return NULL;
>  }
> =20
> +static efi_status_t efi_zboot_remap_image(const struct efi_image_info *i=
mage_info,
> +					  unsigned long image_base,
> +					  unsigned long image_size)
> +{
> +	unsigned long code_size =3D efistub_get_code_size(image_info);
> +	efi_status_t status;
> +
> +	if (code_size) {
> +		efi_cache_sync_image(image_base, code_size);
> +
> +		status =3D efi_remap_image(image_base, image_size, code_size);
> +		if (status !=3D EFI_SUCCESS)
> +			return status;
> +	} else {
> +		efi_cache_sync_image(image_base, image_size);
> +	}
> +
> +	return EFI_SUCCESS;
> +}

[Severity: Low]
Does calling efi_cache_sync_image() in efi_zboot_remap_image() duplicate the
cache sync already performed at the end of efi_zboot_decompress()?

0dc1754e16b4 ("efi/libstub: Avoid legacy decompressor zlib/zstd wrappers")
moved efi_cache_sync_image((unsigned long)out, outlen) into
efi_zboot_decompress() in both zboot-decompress-gzip.c and
zboot-decompress-zstd.c.  Because efi_zboot_entry() calls
efi_zboot_remap_image() right after efi_zboot_decompress(),
efi_cache_sync_image() now runs twice back-to-back on every zboot boot, fir=
st
over the full allocation and then over code_size.  Should the
efi_cache_sync_image() calls in efi_zboot_decompress() be dropped?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106141936.2744=
481-7-ardb+git@google.com?part=3D3
