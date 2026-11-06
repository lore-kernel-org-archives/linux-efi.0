Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975615;
	b=HnjAloJCHeYNF1c8GPj08I0NSDhOJ6SpX1JOJnEc65KoikOT0SOHNopTFHi6JzWwQIhs
	 Vao5ou70W2xhmdw2zRwjv52qvHRXdoxnbujWbAxFhQeTMArDZoF6nFbMlB2VcrH9c+rZw
	 UVyG0YpUAK0M+S/icwoQGlRIwDPF0R53DmEPJ84UCFnySm/OIV4lfVI/YldvUfwDV+Ktc
	 6xDReiMedYXkzJEYEvEHF8/EgnQJjBUXzUZZ+zgzWAVJI2E9plgRZwHYRN73CTwYxUlFU
	 UxaC5JC+O0crfFpL+QU8mSz5Du5MVRDucC5mgzscd9nQWa9Ecg4FfpXl7Kgpfgsn3bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975615;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=lLU7ErUhJ3C4lw1lteIKrhZU7YDWmuaEy2OdiaVI1Io=;
	b=yGK/oP3fZiiO/VV/ImQUjlPNLoYtfXiKIG8vBowjGJ45GvbK/QbwMXvadCNTaj2WuEon
	 PMRaPgznwHzNABQiVUOC2FCSJKV+PYZnEBCxwT2ar5TuelXVHCjJgTQ4m6NK0efbeyP0i
	 WHQvQpWPRY0+nhwnWi+sIldV8yKV5ne2aUGIICHoL7yCllUBT46SeCxrEvF/C81K3XP3i
	 UvKQ5qKsha4NmBQO27w7ICoTgwJ0AoPcr74B0ah3qIlUGk+6kn3HylCcKkjJTZY+siyFB
	 lrCuZzz/7GEla8Hu26xnXq4x40qXI9r+sfJ91MYKTf7hl929Umps49/s6cLPxgbrHGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4XrkwXh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B31606D80A
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4XrkwXh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE5F1F008A1;
	Fri,  6 Nov 2026 14:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975614;
	bh=lLU7ErUhJ3C4lw1lteIKrhZU7YDWmuaEy2OdiaVI1Io=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=c4XrkwXhhr096JIfReu2hKr7+tc0E+jAT77vzGGxWHxWcnENQe5uc9zqm8XFFj7lK
	 BsjUm/vGgWG9CowgUGbyagZDsExWVhSp3JuxOlAsRYGoMWGiWVtruMrZAWHSPcdvFg
	 vpI9ddM+UriVN7yeqKGseJijxvdPPHlOhfE2sKbwSguw66wAj5P/tW31XkWMPSM8bx
	 xW57D3d8H9SMeqd9v/fAq/GhX69rsrYw0vG47bFGshn/ebycHJZGd7h8XGY5Gd0oL8
	 2jgpzQIZ2CbzTqJ8aUbu1bbpLNHBA+7peMFO0RYiy/uiNDyH1W4BU4aAoWXhLjzPMC
	 sR1lfjJXVnGlQ==
Message-ID: <sashiko-outbox-201588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] efi/arm64: Drop build and linker script hacks to
 obtain image code size
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, "Ard
 Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>
In-Reply-To: <20261106141936.2744481-12-ardb+git@google.com>
References: <20261106141936.2744481-7-ardb+git@google.com>
 <20261106141936.2744481-12-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 14:33:33 +0000
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
- [Low] efi/zboot: redundant full-image cache sync in
  efi_zboot_decompress()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] efi/libstub: arm64: missing DSB ISH in efi_cache_sync_image()
  [1]
--

commit 579820756d50227a71aeb397996f2064f5e5696a
Author: Ard Biesheuvel <ardb@kernel.org>

efi/arm64: Drop build and linker script hacks to obtain image code size

This commit replaces the build-time symbol injection and linker script
logic for obtaining the kernel code size in EFI zboot with offsets stored
in struct efi_image_info, and updates efi_cache_sync_image() to use its
alloc_size argument.

> diff --git a/drivers/firmware/efi/libstub/arm64.c b/drivers/firmware/efi/=
libstub/arm64.c
> index 190cf180bb234..da6fa2f6c8219 100644
> --- a/drivers/firmware/efi/libstub/arm64.c
> +++ b/drivers/firmware/efi/libstub/arm64.c
> @@ -88,8 +88,6 @@ efi_status_t check_platform_features(void)
>  #define DCTYPE	"cvau"
>  #endif
> =20
> -u32 __weak code_size;
> -
>  void efi_cache_sync_image(unsigned long image_base,
>  			  unsigned long alloc_size)
>  {
> @@ -100,7 +98,7 @@ void efi_cache_sync_image(unsigned long image_base,
>  	/* only perform the cache maintenance if needed for I/D coherency */
>  	if (!(ctr & BIT(CTR_EL0_IDC_SHIFT))) {
>  		unsigned long base =3D image_base;
> -		unsigned long size =3D code_size;
> +		unsigned long size =3D alloc_size;
> =20
>  		do {
>  			asm("dc " DCTYPE ", %0" :: "r"(base));

[Severity: Low]
Does changing size from code_size to alloc_size cause efi_zboot_decompress()
to clean the data cache across the entire decompressed image allocation
before efi_zboot_remap_image() syncs the code region a second time?

Both gzip and zstd implementations of efi_zboot_decompress() still call
efi_cache_sync_image((unsigned long)out, outlen) with the full allocation
size (including rodata, data, and BSS), and efi_zboot_entry() then calls
efi_zboot_remap_image() -> efi_cache_sync_image(image_base, code_size)
immediately afterward.

[Severity: High]
This problem wasn't introduced by this patch, but is a dsb(ish) barrier
needed [1] between the data cache clean loop and ic ialluis in
efi_cache_sync_image()?

drivers/firmware/efi/libstub/arm64.c:efi_cache_sync_image() {
	...
	if (!(ctr & BIT(CTR_EL0_IDC_SHIFT))) {
		unsigned long base =3D image_base;
		unsigned long size =3D alloc_size;

		do {
			asm("dc " DCTYPE ", %0" :: "r"(base));
			base +=3D lsize;
			size -=3D lsize;
		} while (size >=3D lsize);
	}

	asm("ic ialluis");
	dsb(ish);
	isb();
}

Without a barrier after the dc maintenance instructions, ic ialluis can
execute before the data cache cleans complete, allowing the instruction
cache to refetch stale instructions during early boot.

[1] https://sashiko.dev/#/bug/linux-3f5f98cd-053a-49ef-9e97-834ca6744a2c

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106141936.2744=
481-7-ardb+git@google.com?part=3D5
