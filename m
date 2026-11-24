Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795518911;
	b=qhVW7hkKCLL0dFEiSD/ORl5U06pkVDvN7f8+gRdKJH/rL1kq8C+LmmY5pORGU8okFTBV
	 MDZwytL0Ktz4YgAJXgMBJvxF/qiCp+OsPKE/CxHxnfsiMXiCYZKlJAKrOm2Xq2+MU1B0f
	 4B3zM+4VJB1so+bez8FoGRGA/Q4aPtbMOhwsXHrx/W31btgPRx2/fR/9m7m25iY3Nzy0I
	 YUnfIgO/9uoEg91KsY6ICTFANCiC/re37m4PKYxKKsK+LrEIlF58eeFB7/cxEDvMUAzSX
	 TNydawCMNnHYnQHtYxioquHRR0ku1bPPDyVDta2jXUvakY8aM46zb6fJz3gC8MC6Bbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795518911;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=8i/f5Mw0BzF5sopOUkbpDZCAF4TkByS4VU50Gtq+ByQ=;
	b=h9kmwXgbEMbsNUtCLM6YBTbedAfHzl3ciJZh09JO908Yzo4k2qCOnPY9pKALTYOsaqb+
	 KgpQkJSkm1To9C1BpaIIzZnn7C44d24Q7WzxKw5+kTjrzRiTDYphtnhVQHi/+VoA/eN9D
	 QgrGCcW1MhAq43J/uivOF/h0MEK9K17ZD7UvAN/2Z6BiFYgQx15p8blOtPVckwKTMgAqa
	 IUHD7xx3OfrlMqa6j1+wKerz4YKyOWZ9Fu7/byPfN2hf1skhGgP+ghngtn2gFBRb3G7sU
	 gcyB+RIuq7iWM0cFMSOPEv/koLsp9HjiX6Z6PB/nHebdIeGpZcGIJKWVAgMKh7SHQsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dq3o6ci9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3E8606A32C
	for <linux-efi@vger.kernel.org>; Tue, 24 Nov 2026 11:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dq3o6ci9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC17B1F000C0;
	Tue, 24 Nov 2026 11:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795518911;
	bh=8i/f5Mw0BzF5sopOUkbpDZCAF4TkByS4VU50Gtq+ByQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Dq3o6ci9svexUCE/Ij1ourK6jUqxZOeHWdUl2vpAyqQAAxv82hdw59TR5en5Y3nlU
	 uMUzfa2IClGQO3Sui6PCf1cSWun+omcYF8dY0ggbvDcuwpwKZeIrujM2Tba8F6h1Kb
	 PuA6P/e47zqCPPtRoB5jK6yRf7jgTB5czWb7DNLzO+ofQsVv2wSpVg6yz3yVbL4yuu
	 cpbGRDULPVMORskasFFR1bCeTJeuWZrmeWJzviQtxGPHuDbOOO3yRFtEbx+88B2bAu
	 Zd2GNUgtfSueQ59hb0+TlI+F3rNMW0s2pbZEHA9HlkIRw9i7IJA72UidXY9l3V30qP
	 mAfAVeGWiv8mg==
Message-ID: <sashiko-outbox-231026@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] x86: Always permit the kernel to be placed at any
 physical address
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, x86@kernel.org
Cc: linux-efi@vger.kernel.org, "Ard Biesheuvel" <ardb@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>
In-Reply-To: <20261124110522.1371247-2-ardb+git@google.com>
References: <20261124110522.1371247-2-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 24 Nov 2026 11:15:10 +0000
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
- [Medium] x86/Kconfig: config RELOCATABLE uses def_bool y instead of
  bool
--

commit c734084ffe5143387f2c8e1cef5938ed63060e83
Author: Ard Biesheuvel <ardb@kernel.org>

x86: Always permit the kernel to be placed at any physical address

This commit removes the CONFIG_RELOCATABLE gating around physical load
address handling in the x86 decompressor and boot header, and restricts
CONFIG_RELOCATABLE to 32-bit kernels and KASLR builds.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 15fd9ec5ecacb..5af340f77b5c6 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig

[ ... ]

> @@ -1994,66 +1994,37 @@ config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
>  	  Don't change this unless you know what you are doing.
> +	  Legacy i386 kdump use cases based on vmlinux rather than bzImage
> +	  might need to override this, otherwise leave at its default.
> =20
>  config RELOCATABLE
> -	bool "Build a relocatable kernel"
> -	default y
> +	def_bool y
>  	help
> -	  This builds a kernel image that retains relocation information
> -	  so it can be loaded someplace besides the default 1MB.
> -	  The relocations tend to make the kernel binary about 10% larger,
> -	  but are discarded at runtime.
> +	  This builds a kernel image that retains relocation information,
> +	  allowing its placement in the virtual address space to deviate from
> +	  the build time default. The relocations are applied at boot and then
> +	  discarded, so their runtime memory footprint is zero.
> =20
> -	  One use is for the kexec on panic case where the recovery kernel
> -	  must live at a different physical address than the primary
> -	  kernel.
> +	  On i386, the virtual displacement relative to PAGE_OFFSET must equal
> +	  the physical displacement relative to LOAD_OFFSET, and so this option
> +	  must always be set.
> =20
> -	  Note: If CONFIG_RELOCATABLE=3Dy, then the kernel runs from the address
> -	  it has been loaded at and the compile time physical address
> -	  (CONFIG_PHYSICAL_START) is used as the minimum location.
> +	  On x86_64, the virtual displacement is independent from the physical
> +	  placement, and the relocations are only used when randomizing the
> +	  virtual address space (KASLR).
> =20
>  config RANDOMIZE_BASE
>  	bool "Randomize the address of the kernel image (KASLR)"
> -	depends on RELOCATABLE
> +	select RELOCATABLE
>  	default y
>  	help
>  	  In support of Kernel Address Space Layout Randomization (KASLR),
> @@ -2089,30 +2060,19 @@ config RANDOMIZE_BASE
>  # Relocation on x86 needs some additional build support
>  config X86_NEED_RELOCS
>  	def_bool y
> -	depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
> +	depends on RELOCATABLE
>  	select ARCH_VMLINUX_NEEDS_RELOCS

[Severity: Medium]
Should config RELOCATABLE be declared as bool rather than def_bool y?

With def_bool y, CONFIG_RELOCATABLE is unconditionally enabled even when
neither X86_32 nor RANDOMIZE_BASE selects it. Because X86_NEED_RELOCS now
depends only on RELOCATABLE, an x86_64 build with CONFIG_RANDOMIZE_BASE=3Dn
has CONFIG_RELOCATABLE=3Dy and CONFIG_X86_NEED_RELOCS=3Dy forced on, still
emitting and compressing vmlinux.relocs into the image and running
handle_relocations() at boot.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124110522.1371=
247-2-ardb+git@google.com?part=3D1
