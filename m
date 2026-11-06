Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793975234;
	b=1/M7QFmR1bf/T9X7jR3GCnx/5wYEOs6gT2HhAXlcdnfeVyPQdKokfV7nCIsdKLGysdf7
	 QXafGC5+Qx3SHaevgo4dwa2SgAt+Kq0pIP9Get7pGjGrE1D/X6Ev7JpgkQpYpHX6UjbR8
	 KP/IenuvamHV/ErcEQI4lI3vT1a9pxE47jdJ7yJNmfuq6cdX5a9FY0DHyNz80x8LAb59I
	 0vmzLKT5OHGWz0MzI3VURHe9deayeLpg8Q0WPaLi9+0bb3UhTqDK/hY5CEQYowq/XAuTM
	 OBE0AKuYZuDA2IL4jwUQhSEYOYlnwUwb6UgxHpXybCIeozrvbdQW35C7riF5dC6AGMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975234;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=McL+qlRafJt4/CvILnPjwSzZJgK/KTNvUdlPEjYpNAo=;
	b=cQTnC6pZPia1Ez+AyB6ZcUGX3c1UwUwHbKYuFLiu6YIyKkBHmLlU61k8xVF1xYMXkNve
	 wQHb9g/IXBANq/9BAMtAHnC9DZRX6+rniI+/023jZTEEUkHq38fdiNFNSu7kMCOTPYLNk
	 mjPksYdmXy8Pgh9CV4Aazc6WyleX/3OvcKmdSQEqrhdNZeoknEAPaHgcRpKxJTSgW6UtG
	 iACnhILk6B6zSpNbFLbz/z2DJf256VDYNm7oFFqTRvoQa2X3EnGIqV7GZ6QcQyhQh4YYu
	 Dy4tm+SPrcYvUKIOsxMQb4eatQY1s0RjguiA8ym7BtWHCPGqjGCry+5XHDStsG4+tbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yxur28cM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45E606A329
	for <linux-efi@vger.kernel.org>; Fri,  6 Nov 2026 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yxur28cM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D541F0089F;
	Fri,  6 Nov 2026 14:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975233;
	bh=McL+qlRafJt4/CvILnPjwSzZJgK/KTNvUdlPEjYpNAo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Yxur28cMGmqX44lThFiepwmjJvpDTyOYr2lhZc3O9caGAbTncz+2zaluBZSB5RJmM
	 sYs5jDoDCuqgVcko2Ri/QjtVBq/bovHprGDcPMv1twcbNRJpO07QuQUVzzLiITyOu+
	 Uud+NyU3h0rxIsg55fwqOe47StxvNdDR3zXakLjjurJz0+Qw4JPC9WoLrVuEkKBUwk
	 0JQTTrsztan/R8lNK2eh5Puk5Fw6+I4MMT7T45zpBSqZelBOEM+Vtrpa2yRXVYuSCf
	 zpG8VHt7HRt4nVZMcPINEiIoX/lYfZXHOlRXlB7gb0Zm1/gsrhBDgm1x3EqYAWpMV4
	 /elDIHVlnCAhQ==
Message-ID: <sashiko-outbox-201577@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] efi/libstub: Pass a struct efi_image_info to
 efi_stub_common()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: mark.rutland@arm.com, will@kernel.org, catalin.marinas@arm.com, "Ard
 Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>
In-Reply-To: <20261106141936.2744481-9-ardb+git@google.com>
References: <20261106141936.2744481-7-ardb+git@google.com>
 <20261106141936.2744481-9-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 14:27:12 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] efi/libstub: freed memory retains RO/XP attributes in
  efi_zboot_entry() [1]
--

commit ddd62e73ed528e3f2c2ae65f0467b40b21e1c353
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: Pass a struct efi_image_info to efi_stub_common()

This commit passes a struct efi_image_info pointer from both efi_pe_entry()
and efi_zboot_entry() into efi_stub_common().

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/=
libstub/zboot.c
> index 4a5ffe164873e..97ae706c034ad 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
[ ... ]
> @@ -93,9 +98,15 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_=
t *systab)
>  	}
> =20
>  	// Decompress the payload into the newly allocated buffer
> -	status =3D efi_zboot_decompress((void *)image_base, alloc_size) ?:
> -	         efi_stub_common(handle, image, image_base, cmdline_ptr);
> +	status =3D efi_zboot_decompress((void *)image_base, alloc_size);
> +	if (status !=3D EFI_SUCCESS)
> +		goto error;
> +
> +	auto image_info =3D zboot_get_image_info(image_base);
> +	status =3D efi_stub_common(handle, image, image_base, cmdline_ptr,
> +				 image_info);
> =20
> +error:
>  	efi_free(alloc_size, image_base);
>  	return status;
>  }

[Severity: High]
This problem wasn't introduced by this patch, but can efi_free() return
pages at image_base to the firmware pool while they still carry EFI_MEMORY_=
RO
and EFI_MEMORY_XP attributes [1]?

When efi_zboot_decompress() succeeds, it remaps the decompressed image's co=
de
as read-only and its data as non-executable via efi_remap_image().  If
efi_stub_common() then fails, efi_free() frees image_base without clearing
those attributes, and UEFI does not require FreePages() to clear memory
attributes automatically.  Later firmware allocations that reuse those pages
(such as during boot fallback) can fault and crash when writing data or
executing code.

[1] https://sashiko.dev/#/bug/linux-e232037c-ef9b-47bd-b6d0-1bea4732c0e2

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106141936.2744=
481-7-ardb+git@google.com?part=3D2
