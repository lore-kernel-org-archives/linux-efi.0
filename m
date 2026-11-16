Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794841156;
	b=B7xXyA/XnttqRJ5hPWK5CEuZ5Tm4BL0ttN3EYPJZ0g4gObUEi+hwr0q04Sjxb3BtcHQK
	 yrvVTtzB7tqr+pBsYkqC/gJFniZ+DHLIyin75xJvbNaKlZoAjuSG4qpF1lFvcoOWnx0P0
	 koeLvYU4YiOLIP9MhSja/9tUWvqU1TpIBThtpfkXIhMFnmSpyOQ4vYmQhaFbnImkc6emx
	 kDUrsUNjl1e2+FDYpgU4h/8IOoBOn/iw5kBHA983ZNO/sq0T7KGWfCh1j3PljZ9ERgBRX
	 ecuZ2jI5drF5jZ9+x+y9leOjT/8bba5uHwpOFm5RO1GoeuuoOAjGQF23zG51Z5uLD6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794841156;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=Ek1qIyIG3rNlVovDuSGqPCyT/zX+ni2+pfT0PwMZvN0=;
	b=cirwkgbqwMP2APzMeg54zoY7uUKW2ABwLwaBxGfiOOWYcCcmXM1pIcKEtmWpwWO+Jwq5
	 /WqUkONH5cB9DzgnxvZWopogQJntyVvi5b9ZtP15ky0CftXnyjG9KmOoKmTFKyQLOXBX+
	 ldQGK7rqGcPEBQLEAtlPUuQEHRuP85q1yBlB47r6zzVyRZJSK+L1oaV3ZBSrEo5R4lf8q
	 wb2QYv1YUvtBcWwSDk/6TL43yX5zR2uGNHQkoTlpuKG4//AYVT4ODwUfKNr56ecyZI9sw
	 wI/rxCpvD1Y/+fNTVqieCNQU3odsB9tIv3xE0811ZZd9rnvqP9uaqITFH+gHP39OqBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kq4fTIQk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66568606A329
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kq4fTIQk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFFD1F000C4;
	Mon, 16 Nov 2026 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841155;
	bh=Ek1qIyIG3rNlVovDuSGqPCyT/zX+ni2+pfT0PwMZvN0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kq4fTIQk6Q4ihiR42L5SPlFabAWV3f79Fh8C55qykp/bt8gMbVN5R6TrYaeO/9mku
	 FBGFfZV2aLbfqF1CEPzD586Min0M2SfyZC6pixC0SitaNJIPTgEhTGhCFh+Dq9tiE6
	 80XiF7AL7aaavhQ5Vl5pxdynjAxpRsbp+E4zYkDWBx8SugFZJhCyxnAEN8JM9Gdq0P
	 ZWUAkFHqebRYUObkvM+ClabwAzUUmT0S1OlJ/CDBMH4sTqYVMpLolbiPr7n62pBt7b
	 CeeO/YlFnVm7WZpUnJ2a/P0XdAvsDMgJy6zIdO39JAjUoOree++FQtA2enWkTQRE88
	 RrH7fB9+ppjYg==
Message-ID: <sashiko-outbox-217208@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/15] efi/libstub: Capture loaded image information
 in struct efi_image_info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261116142618.1687025-23-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-23-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:59:15 +0000
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
- [High] efi/libstub: broken kernel base address in efi_stub_common() on
  32-bit ARM
--

commit 10e52dbaf9d058d012ab6c3df52814b120d5f9e3
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: Capture loaded image information in struct efi_image_info

This commit introduces struct efi_image_info to hold loaded kernel image
offsets and passes it to efi_stub_common() in place of the raw image base
address.

> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware=
/efi/libstub/arm32-stub.c
> index 1073dd9475160..f7151a4915ba2 100644
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -76,12 +76,15 @@ void efi_handle_post_ebs_state(void)
>  		      &efi_entry_state->sctlr_after_ebs);
>  }
> =20
> +struct efi_image_info efistub_image_info =3D {};
> +
>  efi_status_t handle_kernel_image(unsigned long *image_addr,
>  				 unsigned long *image_size,
>  				 unsigned long *reserve_addr,
>  				 unsigned long *reserve_size,
>  				 efi_loaded_image_t *image,
> -				 efi_handle_t image_handle)
> +				 efi_handle_t image_handle,
> +				 const struct efi_image_info **image_info)

[ ... ]

> diff --git a/drivers/firmware/efi/libstub/efi-stub.c b/drivers/firmware/e=
fi/libstub/efi-stub.c
> index 6db10590f89b2..bf9a9f53a95cc 100644
> --- a/drivers/firmware/efi/libstub/efi-stub.c
> +++ b/drivers/firmware/efi/libstub/efi-stub.c
> @@ -160,9 +161,10 @@ efi_status_t efi_handle_cmdline(efi_loaded_image_t *=
image, char **cmdline_ptr)
> =20
>  efi_status_t efi_stub_common(efi_handle_t handle,
>  			     efi_loaded_image_t *image,
> -			     unsigned long image_addr,
> +			     const struct efi_image_info *image_info,
>  			     char *cmdline_ptr)
>  {
> +	unsigned long image_addr =3D efistub_kernel_base(image_info);

[Severity: High]
Does efistub_kernel_base(image_info) compute a bogus image_addr on 32-bit
ARM?

In arm32-stub.c, efistub_image_info is zero-initialized and
handle_kernel_image() writes kernel_base + TEXT_OFFSET only to *image_addr,
which efi_pe_entry() no longer passes to efi_stub_common().  As a result,
efistub_kernel_base(image_info) evaluates offset_to_ptr(&image_info->_text_=
offset)
to &efistub_image_info inside the running zImage decompressor instead of
kernel_base + TEXT_OFFSET.  Passing that address to efi_get_max_initrd_addr=
()
and efi_boot_kernel() -> efi_enter_kernel() causes the decompressor to
overwrite itself and crash boot.

Even with the follow-up commit "efi/libstub: Pass kernel entrypoint down to
efi_enter_kernel()" setting efistub_image_info._text_offset to the absolute
address kernel_base + TEXT_OFFSET, offset_to_ptr(&image_info->_text_offset)
still adds &image_info->_text_offset to that absolute address, passing a
corrupted image_addr to efi_get_max_initrd_addr(image_addr).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116142618.1687=
025-17-ardb+git@google.com?part=3D6
