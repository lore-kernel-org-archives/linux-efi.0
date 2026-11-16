Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840029;
	b=Fp3OQC+SounIZYhAIFV9ykcecTEKB1TRnc9uCmAhMAgiL6CxcIj28d24Lpr+PTEJHMtA
	 XU4M/Ktsshmtf5scn1nCclEf/D63+M4ld4ZVmVphYDHlNFkxz1jzyDOqee7pATpjVT5pW
	 lxltXkOuMpq/aZECK4JT5Idk02Nz/hVYLFl2Ej612xTjYhMJFfl3EJKtg1X2Lp2ZJUNVg
	 JbYndTKWLwiRUwtXFYNtAxwiOllQBmEfebYOIAQtYVG/TFKiNOSFsSIXQtHsm4kNTW6t9
	 fH+lKu4+6exbDwhgKe+uU82hYFuiixzhifYmcFKg2t3UwLq1OyyZcCN9SFfiSssQk7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840029;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=yvDAO/62n/wWYhcsf9pAJBqQXbA6kX4/kmCyKi4Odl4=;
	b=RC4D5sqQMJlKWt0W1QOwoHACTlPlMgZlpez9BRJf1E2YQz05D5muLkdPjdLZeDlBxRsW
	 FYkAtiswQ+WARaCfENbMPsVmP2MWF7thCUFaZMNrD/2izRSStDDkHz1eiiowjKY0997G/
	 UExn6p8KS+gvjgXAaHT+cwwaM0WsFF6h6vIhfTS39CL1TPFdOcSMfNctDx6oLE3VjovoB
	 33rWbRZwtcEq8AIk6SH5ojMOxKKEnZzvPUerN9wIu3H13/87m5hUzb2/gIUMBBLy/ECpx
	 pWZ49uuGZYIFVAwQA+X+CJTsfA6Orx+LwvNQkXTgWX5GxCoJ/kPJjDiNSWfp0dlRxZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYmISZot;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252EC606A33F
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VYmISZot
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B7A1F000C4;
	Mon, 16 Nov 2026 14:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840028;
	bh=yvDAO/62n/wWYhcsf9pAJBqQXbA6kX4/kmCyKi4Odl4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VYmISZot5grpvqSo27+wu9WNCu1FDgSOMSSPbColqrkIUATwyOInTPH0FiflOxoEy
	 umxyWRbERnCi5izDHLaltM1w1k5c+V+PuEJDrdxKENrpdk2dI3PPLYXY4QmBcVU6qt
	 iNdwYj1D6YstuU1//azEK/kvlQxsk9Hm0e8XUY6gzNOfsQ/600oXlDKENZU3XyRXMp
	 InURVhbzyhJYYhXMZvPJ4DNtg8zdni/aNYyJg4gNMF0VBEhrgQnUgIbz6TSKuTgLOU
	 aAlnU4/tf86AHbT1oySf0gWGOsMQp4V5zrhExa3V1zd5+T6oOi2e7E9FtlhuoXsNM5
	 9zR6v2/QDQNzQ==
Message-ID: <sashiko-outbox-217185@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/15] efi/libstub: loongarch: Use struct
 efi_image_info to access image properties
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261116142618.1687025-26-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-26-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:40:27 +0000
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
- [Low] efi/libstub: loongarch: dead declarations left after image_info
  conversion
--

commit d80068564b9cb3b54d5e07eb729d7302295ab088
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: loongarch: Use struct efi_image_info to access image properties

This commit switches the LoongArch EFI stub to resolve the kernel entry
point through struct efi_image_info and drops kernel_entry_address() and
unused linker script symbol aliases.

> diff --git a/arch/loongarch/kernel/image-vars.h b/arch/loongarch/kernel/i=
mage-vars.h
> index e557ebd46c2b3..b01022ce6bb8a 100644
> --- a/arch/loongarch/kernel/image-vars.h
> +++ b/arch/loongarch/kernel/image-vars.h
> @@ -8,12 +8,8 @@
>  #ifdef CONFIG_EFI_STUB
> =20
>  __efistub_strcmp		=3D strcmp;
> -__efistub_kernel_entry		=3D kernel_entry;
>  __efistub_kernel_asize		=3D kernel_asize;
>  __efistub_kernel_fsize		=3D kernel_fsize;
> -#if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
> -__efistub_sysfb_primary_display	=3D sysfb_primary_display;
> -#endif
> =20
>  #endif
> =20
> diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firm=
ware/efi/libstub/loongarch-stub.c
> index d57e3d3557a54..6126b05e99fbe 100644
> --- a/drivers/firmware/efi/libstub/loongarch-stub.c
> +++ b/drivers/firmware/efi/libstub/loongarch-stub.c
> @@ -116,11 +116,3 @@ efi_status_t handle_kernel_image(unsigned long *imag=
e_addr,
>  	*(unsigned long *)image_info +=3D *image_addr - (unsigned long)image->i=
mage_base;
>  	return status;
>  }
> -
> -unsigned long kernel_entry_address(unsigned long kernel_addr,
> -		efi_loaded_image_t *image)
> -{
> -	unsigned long base =3D (unsigned long)image->image_base;
> -
> -	return (unsigned long)&kernel_entry - base + kernel_addr;
> -}

[Severity: Low]
This isn't a bug, but removing kernel_entry_address() and
__efistub_kernel_entry leaves behind "extern int kernel_entry;" in
drivers/firmware/efi/libstub/loongarch-stub.c as well as
drivers/firmware/efi/libstub/loongarch-stub.h (which only declares
kernel_entry_address()) and its #include directives in loongarch-stub.c
and loongarch.c.

Also, should handle_kernel_image() use efistub_kernel_size(*image_info)
and efistub_kernel_memsize(*image_info) so that __efistub_kernel_fsize and
__efistub_kernel_asize can be dropped from
arch/loongarch/kernel/image-vars.h as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116142618.1687=
025-17-ardb+git@google.com?part=3D9
