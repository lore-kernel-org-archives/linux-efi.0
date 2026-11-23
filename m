Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795475407;
	b=j66mCvT+KSaM6NM/6KyI5caQ43FyTDZf/r0KF+ii4yO7nz1sUdM2IoElY3KDwk01q8qf
	 GAd/VcvClTYlXbcnQBeil6gjgNcosqqq7oWjFsm9zBH4KZ59iglDDEptSp7oCGG32vzqZ
	 59dWkHIcfFQjD5J2wMoNyJOMofYanG6SKAX4WMbmxiroATh7+Hmfkl2s1z1wgsS/SeIJC
	 EYQdNgBVwdW+WObXm7IsoilIOwk0k1WdIt8lyVh04N7oWitUoFvxoSDs5R/JzNMi28hsF
	 DCh9G4bSmmpkYHgHSdeVtbZx2Kbv1i1j6OMoF3rV812gE3zKcorcqojuud1zrr+qmHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795475407;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:
	 X-Google-Original-Date:Subject:In-Reply-To:CC:From:To:Message-ID:
	 Mime-Version:Content-Type:Content-Transfer-Encoding;
	bh=omPzYJsyHFXBTWaYCXRuHKP+shwbFJ7ykCdiwHLxPZA=;
	b=GE+JWdxD06ht61ZzgCALFAgz6d1Jpil9A1HOhz9TcjJcaeP2hwh9hUT/e8vs4g1+5YIb
	 nLbYfoTUtsIFArq+rU2KfgaXAdax6LTknb8b/XPBfblWj5Ie3QLGXpesuMFNla3ioUL0R
	 ZaqAL/7rWMo8mKpSPaZF02YzuUoCG5e3bR0fLTH5qbD7RzWLhtLLZWjMziKML0rv43+VP
	 6rhXdlKPJBSsc/gL0HO4Zh3ahEKS4cz/qXlZX2I3gdp4OeeZghLrg8jgi0/cYNBcDQ0wg
	 fKSnqCTTLSlwyyfhPe3v1vsSCRNhjnlu7I1GEP8vxgB6yOr0Ot+usYf0jOPTYvT/74w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dabbelt.com;
	spf=pass smtp.mailfrom=dabbelt.com;
	dkim=pass header.d=dabbelt-com.20260707.gappssmtp.com header.i=@dabbelt-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H1CXrOaO;
	arc=none smtp.remote-ip=74.125.82.53
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8DC606A339
	for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 23:10:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B8DC606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20260707.gappssmtp.com header.i=@dabbelt-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=H1CXrOaO
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1b24f4b15c4so1637376c88.1
        for <linux-efi@vger.kernel.org>; Mon, 23 Nov 2026 15:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20260707.gappssmtp.com; s=20260707; t=1795475406; x=1796080206; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:to
         :from:cc:in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=omPzYJsyHFXBTWaYCXRuHKP+shwbFJ7ykCdiwHLxPZA=;
        b=H1CXrOaOt0XKBPGgM1vS0S0sY+evPqAZ9OfNsIw0kJkeQrTDYuytYBOZY81t1ZQIPx
         wiuYFGWqDja9V3LcqyclGdQSTNC8kybj8IQyp2jfYSi2KZJtugim1WLq1yK3S5kND1Ag
         9E4lQ/BERygtHJJk2d2SSWJwLmfBtCV6AZc1logCh4FsKVEtpq8yWySozoaEAGzz1NS2
         325BArhj9wH1fXckvW9GbSM2jACSjiMjSINpiy3pp3/SX4uy2tLZTE1GXfdpHEZNdpQT
         so6aGyDx0nCXMv5SdeOTIyrIJRMbQ818XhhqMQmPHMoDuNAjVGszI9S6kQHVAlWeBAW1
         V9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795475406; x=1796080206;
        h=content-transfer-encoding:content-type:mime-version:message-id:to
         :from:cc:in-reply-to:subject:date:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=omPzYJsyHFXBTWaYCXRuHKP+shwbFJ7ykCdiwHLxPZA=;
        b=fioi6Ju234BBLJXgqnRZK8U4R6szNKJKI9xay8BmjMn3vaZyHilSyCn1wLa23jEYXs
         /GLez0tHB9M2edVP38xX3yDGC/z/+GSx8LU9o4zU798m25Zn9VUUE7gVJxikRSdajwjO
         LLzD8MZ/0PmX01yS6SpC59iXt1pbFXOhUjIaQB9pvhOXWVHtO/sTOzYWhRObGA/6xvbt
         SnUqcW80wzMhWnTSAJtRId+9b81wtDI/23yalUV4o5mLSNPeGBm7Fa+xk86eiQSbMrQo
         RHmZLgJpcDd8WnSJUJhYNJSeaThlGfrmE402ettq4oS6PnROYiEcIowAfXRKqn/+JxuG
         mD0Q==
X-Gm-Message-State: APuU4Z/cjYoOeuOPge0YCBy8cyiv3LqTG1EUAM78YrkzPYhW7QtGnDI1
	U2jAkaKbU4x1sDVmLhpBCBHnn0fAzGHn9PSj4dIZb3aZolMhz8Mj6320qnIMUt4WSbFkuzk37F8
	CaLgGJyc=
X-Gm-Gg: AZFdTZepKKOboefOUQ+e1YXoHmXFnx24W3WUG6vF0WT/BIoFfjzyrwNVownl3tkty81
	n+vUUcqufb5V16yi1S8yM3y3DIy6pOD2CJGr9bkehvuHZ+efXZRa1aJA2BTFdCCzndDLJCsDKpy
	K/UnbZKKX6ezvoNDkRcCzOBTx0uce1aqMdJVGWJ0Iyd568p6bzxaClu79VfQGR1n8Odul0k+L0I
	Hy3um9BfAQvZ4CFbGiE3SUY4sNEtvX+0zCivneQK4hTQ4y6K3x6bJFocJgMUs/kLgVndFZ9FzGA
	iXinMm2r4t2G1b6YfgCNMkWvcQBW+QCNF1XG+fA2BrD1JxhJr2//XM8TEFFITotK9xDEfFi8tTX
	LOXuv995SmHPKpt1fRuSqQm/fA4g7rJvclYpUdLzG10/uOZ23L7f3b4Hpr1QtHoNvpGU3L24yPT
	iC+St/hH8TXrvfytMPcb1Ic2UGY9tuC3ImroVzimOkpNFxuZPsoUEWLiS+ZP0gAeCl4Yi7+zSNn
	Z76sChFUeHXYIbqRzhlvkztKQVqjv729wqnPe+8b50VccR0RmPam9tpGnonnNuSVMrBQevcIhnM
	B863kb+hgClmz9Jn+BtwlCKDxb44uqw6ZMeE4WgMJjwfBzHmTj9cmtGwXxRJbCrFGarBdqt7nl/
	3KtEIfTfiFXUPLeqUJqKYM7dy8Tk=
X-Received: by 2002:a05:7022:4181:b0:14a:a6dc:9cbf with SMTP id a92af1059eb24-1b5568abf0bmr18844780c88.4.1795475406085;
        Mon, 23 Nov 2026 15:10:06 -0800 (PST)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ff27bsm33422877c88.6.2026.11.23.15.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 15:10:05 -0800 (PST)
Date: Mon, 23 Nov 2026 15:10:05 -0800 (PST)
X-Google-Original-Date: Mon, 23 Nov 2026 15:09:50 PST (-0800)
Subject:     Re: [PATCH v4 04/19] efi/riscv: Rename __init_text_end to __inittext_end like other archs
In-Reply-To: <20261118182105.1633603-25-ardb+git@google.com>
CC: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
  Ard Biesheuvel <ardb@kernel.org>, jgg@nvidia.com, pjw@kernel.org, aou@eecs.berkeley.edu, chenhuacai@kernel.org,
  loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
From: Palmer Dabbelt <palmer@dabbelt.com>
To: ardb+git@google.com
Message-ID: <mhng-D54B7D56-AACE-456E-AF40-670E83DF8B47@Palmers-Mini.rwc.dabbelt.com>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 18 Nov 2026 10:21:10 PST (-0800), ardb+git@google.com wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> Align RISC-V with arm64, LoongArch and x86, and drop the underscore
> between 'init' and 'text' in the section markers. This allows the value
> to be captured by generic EFI stub code that can be shared between all
> those architectures.
>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/riscv/include/asm/sections.h         | 2 +-
>  arch/riscv/kernel/image-vars.h            | 2 +-
>  arch/riscv/kernel/vmlinux.lds.S           | 4 ++--
>  drivers/firmware/efi/libstub/riscv-stub.c | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/arch/riscv/include/asm/sections.h b/arch/riscv/include/asm/sections.h
> index a393d5035c54..4a882a28f414 100644
> --- a/arch/riscv/include/asm/sections.h
> +++ b/arch/riscv/include/asm/sections.h
> @@ -11,7 +11,7 @@
>  extern char _start[];
>  extern char _start_kernel[];
>  extern char __init_data_begin[], __init_data_end[];
> -extern char __init_text_begin[], __init_text_end[];
> +extern char __inittext_begin[], __inittext_end[];
>  extern char __alt_start[], __alt_end[];
>  extern char __exittext_begin[], __exittext_end[];
>
> diff --git a/arch/riscv/kernel/image-vars.h b/arch/riscv/kernel/image-vars.h
> index 7b44b94f1283..bf703eba3fa5 100644
> --- a/arch/riscv/kernel/image-vars.h
> +++ b/arch/riscv/kernel/image-vars.h
> @@ -27,7 +27,7 @@ __efistub__start		= _start;
>  __efistub__start_kernel		= _start_kernel;
>  __efistub__end			= _end;
>  __efistub__edata		= _edata;
> -__efistub___init_text_end	= __init_text_end;
> +__efistub___inittext_end	= __inittext_end;
>  #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
>  __efistub_sysfb_primary_display	= sysfb_primary_display;
>  #endif
> diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
> index 9849a3e4d102..0ec1b4b55e41 100644
> --- a/arch/riscv/kernel/vmlinux.lds.S
> +++ b/arch/riscv/kernel/vmlinux.lds.S
> @@ -46,7 +46,7 @@ SECTIONS
>
>  	. = ALIGN(SECTION_ALIGN);
>  	__init_begin = .;
> -	__init_text_begin = .;
> +	__inittext_begin = .;
>  	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) ALIGN(SECTION_ALIGN) { \
>  		_sinittext = .;						\
>  		INIT_TEXT						\
> @@ -72,12 +72,12 @@ SECTIONS
>  	}
>  	__exittext_end = .;
>
> -	__init_text_end = .;
>  	. = ALIGN(SECTION_ALIGN);
>  #ifdef CONFIG_EFI
>  	. = ALIGN(PECOFF_SECTION_ALIGNMENT);
>  	__pecoff_text_end = .;
>  #endif
> +	__inittext_end = .;
>  	/* Start of init data section */
>  	__init_data_begin = .;
>  	INIT_DATA_SECTION(16)
> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware/efi/libstub/riscv-stub.c
> index 725b634c5179..5cbc50a814e1 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -34,7 +34,7 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
>  	efi_status_t status;
>
>  	kernel_size = _edata - _start;
> -	kernel_codesize = __init_text_end - _start;
> +	kernel_codesize = __inittext_end - _start;
>  	kernel_memsize = kernel_size + (_end - _edata);
>  	*image_addr = (unsigned long)_start;
>  	*reserve_size = kernel_memsize;

Reviewed-by: Palmer Dabbelt <palmer@dabbelt.com>
Acked-by: Palmer Dabbelt <palmer@dabbelt.com>
