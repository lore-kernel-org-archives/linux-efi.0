Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792536595;
	b=zAlwCGCvl7/Dnxfzidx7M0cziOMiIHek981Y3ziasCB9Nbf//mASh4rsoGU848etM/j9
	 x3qqDCQtUKwXwN8rk8AnFk+YyepPRkbmDq0A0I3LnsqP9ya132k+0G3riGrPExHP1/pg7
	 T/HbvgiHzc4KZkFAdo2Fwnx4mDBbwdyvtLDrmY8pM1Rle0pJGSzQ2wmk83Tg69TJM+hmF
	 gEEeWAZb+9KUJa+nqogXO9YuMC8mrdMFQFXxZVwM+iXgDQ//1O3s7mGJSthoKkNodn3VD
	 tVlzrdJECsZ79oV6YoiLg7kUi9VFc+y7mt48IeIvZVKHtj/YfbxdKpKUcgT/OBaTtGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792536595;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=8L3dbJg7n3McKQQtwak49EcNPS+ZUeJOE3KFcCfv8HU=;
	b=mnEw/TcJyF3l+yjzmScjwzh7ugTCwszDIbBa0FZFT4RWUtfkVpFTHJZ5Iwb8d1rtJvrh
	 YSMVuZhPOlRJxDJjdfXyzte8FXMECI75xg23NPSA308JU7b3gCTV52Gn3ndPTYJzgX/V4
	 UxfDBk9t8TecnxWzBpiAPuebSJ8M+1Tv3L2QlkFQCVZJqaZE/juInq769mb3QTjtlOJWF
	 VCeJqtGlJZgHjtjRFWo6kEt032nKPxsba7uDQnnIP8a/Yb9m0ddhdrcOIVhqbp3fpHM9H
	 DTs6UW6R/+BQ/YF4S0bs8mwdfBHCi7HAmRIXAm9b/9c3JjIxe5MtMc7LNUph8pk0GOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Iy65iNq2;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41C5A606A32E;
	Tue, 20 Oct 2026 22:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C5A606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Iy65iNq2
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22FC515A1;
	Tue, 20 Oct 2026 15:49:50 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92E9E3F673;
	Tue, 20 Oct 2026 15:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792536593; bh=utolcjwaaJaPzYwJQo9ya2LOeTJaqLosq4TA9Cq4IIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Iy65iNq278aR/8Qr5ADRvjS5ek17DIwYRx5fL1DcFwSqjuxUK3E/82pYbuRw8AJRv
	 LW+A9rVlT44ugB3MLub2pWp75rqYgsVz57A99bXDD0t1WBYfyxBKd1q7eFc3vOG4BJ
	 8mE7Bsb9YISf28302wWCSS0gQPVnGGFFsFBqp1L0=
Date: Tue, 20 Oct 2026 23:49:45 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	Ard Biesheuvel <ardb@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, David Sterba <dsterba@suse.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Simon Glass <sjg@chromium.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Nick Terrell <terrelln@fb.com>, Will Deacon <will@kernel.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	linux-integrity@vger.kernel.org,
	Palmer Dabbelt <palmer@rivosinc.com>, patches@lists.linux.dev,
	Piotr =?iso-8859-1?Q?Kr=F3l?= <piotr.krol@3mdeb.com>,
	Ross Philipson <ross.philipson@gmail.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Song Shuai <songshuaishuai@tinylab.org>
Subject: Re: [PATCH v2 12/15] arm64: drtm: Update the linker script for
 EFI_STUB_DRTM
Message-ID: <atfwCcRfC6rWFywH@e129823.arm.com>
References: <0-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
 <12-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>
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
In-Reply-To: <12-v2-989a18390eb1+486-arm64_drtm_jgg@nvidia.com>

Hi,

> Implement the link layout that CONFIG_EFI_STUB_DRTM requires. This maps
> vmlinux into the Dynamic Launch Measured Environment (DLME) defined by the
> spec.
> 
> Broadly, Image fits into the spec defined DLME region memory layout in
> this order:
>  - Program headers and padding up to _stext. EFI can write to these while
>    loading the stub so they do not have a stable measurement.
>  - All the boot-time immutable data, including .text, .data, .init
>    and so on (measured)
>  - Data written by the EFI stub
>  - .bss, padding and other 0'd data up to _end
>  - The "DLME Data" written by the launch process. This is a datastructure
>    the post launch kernel will parse to get trusted information about th
>    launch.
> 
> New linker symbols are added to mark these areas and their offsets are
> placed into the efi_image_info so both stubs can get them.
> 
> The spec's design of the DLME was intended to fit a typical OS image like
> this, with two areas that are unmeasured and an inner measured region.
> 
> Linux zeroes the unmeasured area of .bss/etc after the DRTM launch so it
> also reaches a known value. The DLME data is written by the launch and is
> trusted. The EFI stub data is either ignored or will have to be sanitized.
> 
> Add a section for the unmeasured data before the PECOFF padding. This is
> an allocated section so it is zero'd in the image and is only 64 bytes in
> my builds. There is a high chance it gets absorbed into the padding
> region.
> 
> The post-launch kernel will have to reserve the "DLME Data" before
> starting the allocator since it falls outside the linker map. This will
> happen in the first series to consume this data.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/include/asm/image.h  |  8 +++++
>  arch/arm64/kernel/vmlinux.lds.S | 64 ++++++++++++++++++++++++++++++++-
>  2 files changed, 71 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/image.h b/arch/arm64/include/asm/image.h
> index b18ce23a2cba7f..36afe95ffa7544 100644
> --- a/arch/arm64/include/asm/image.h
> +++ b/arch/arm64/include/asm/image.h
> @@ -5,7 +5,11 @@
>  
>  #define ARM64_IMAGE_MAGIC	"ARM\x64"
>  
> +#ifdef CONFIG_ARM64_DRTM
> +#define EFI_IMAGE_INFO_SIZE	40

Small nit. I know according to #13, This should be 40 with drtm_entry
and arm64_drtm_handoff. but in this patch, should EFI_IMAGE_INFO_SIZE
be 24 and be change to 40 at #13?

> +#else
>  #define EFI_IMAGE_INFO_SIZE	8
> +#endif
>  
>  #define ARM64_IMAGE_FLAG_BE_SHIFT		0
>  #define ARM64_IMAGE_FLAG_PAGE_SIZE_SHIFT	(ARM64_IMAGE_FLAG_BE_SHIFT + 1)
> @@ -62,6 +66,10 @@ struct arm64_image_header {
>   */
>  struct efi_image_info {
>  	u64 code_size;
> +#ifdef CONFIG_ARM64_DRTM
> +	u64 drtm_measured_start;
> +	u64 dlme_measured_size;
> +#endif
>  };
>  static_assert(sizeof(struct efi_image_info) == EFI_IMAGE_INFO_SIZE);
>  
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> index 8305b47995954b..5c14decf0dd4d3 100644
> --- a/arch/arm64/kernel/vmlinux.lds.S
> +++ b/arch/arm64/kernel/vmlinux.lds.S
> @@ -190,10 +190,24 @@ SECTIONS
>  
>  	.head.text : {
>  		_text = .;
> +#ifdef CONFIG_ARM64_DRTM
> +		/* DEN0113 R314010: The DLME region must start at a 4KB aligned address. */
> +		ASSERT((_text & (SZ_4K - 1)) == 0,
> +		       "DLME region is not 4 KiB aligned");
> +#endif
>  		HEAD_TEXT
>  	}
>  	.text : ALIGN(SEGMENT_ALIGN) {	/* Real text segment		*/
>  		_stext = .;		/* Text and read-only data	*/
> +#ifdef CONFIG_ARM64_DRTM
> +		__drtm_measured_start = _stext;
> +		/*
> +		 * DEN0113 R314020: The DLME image must start at a 4KB aligned
> +		 * address. This happens always because SEGMENT_ALIGN is big.
> +		 */
> +		ASSERT((__drtm_measured_start & (SZ_4K - 1)) == 0,
> +		       "DLME measured start is not 4 KiB aligned");
> +#endif
>  			IRQENTRY_TEXT
>  			SOFTIRQENTRY_TEXT
>  			ENTRY_TEXT
> @@ -285,6 +299,11 @@ SECTIONS
>  		EFI_IMAGE_INFO(
>  			/* code_size */
>  			EFI_IMAGE_INFO_OFFSET(__inittext_end);
> +#ifdef CONFIG_ARM64_DRTM
> +			EFI_IMAGE_INFO_OFFSET(__drtm_measured_start);
> +			/* dlme_measured_size */
> +			EFI_IMAGE_INFO_ENTRY(__drtm_measured_end - __drtm_measured_start);
> +#endif
>  		)
>  	}
>  	.exit.data : {
> @@ -348,6 +367,44 @@ SECTIONS
>  		__mmuoff_data_end = .;
>  	}
>  
> +	/*
> +	 * DRTM layout for DEN0113 as it relates to the link layout, refer
> +	 * to Figure 8 in 1.4b. In that language:
> +	 *  "Free Space 1" is the PE header and padding between _text and
> +	 *        __drtm_measured_start (_stext)
> +	 *  "DLME Image" is from __drtm_measured_start to __drtm_measured_end
> +	 *  "Free Space 2" is kernel efi data/bss/etc till __drtm_dlme_start
> +	 *  "DLME Data" is a memory sized "Minimum Size of DLME data"
> +	 *        and is retained after boot for use by the kernel
> +	 *
> +	 * Thus, the DRTM_PARAMETERS follow from that:
> +	 *   DLME Region Address = _text's PA ie the start of Image
> +	 *   DLME Region Size = DLME Data Offset + "Minimum Size of DLME data"
> +	 *   DLME Image Start Offset = __drtm_measured_start - _text
> +	 *   DLME Image Size = __drtm_measured_end - __drtm_measured_start
> +	 *   DLME Data Offset = __drtm_dlme_start - _text
> +	 *   Normal World DCE region address = PA of __drtm_dlme_start +
> +	 *                                  "Minimum Size of DLME data"
> +	 *
> +	 * The EFI stub will place any optional "Normal World DCE" region
> +	 * immediately after the "DLME data". It is only used internally by the
> +	 * FW during the launch and has no effect on the link layout.
> +	 */
> +#ifdef CONFIG_ARM64_DRTM
> +	__drtm_measured_end = .;
> +
> +	/*
> +	 * Writable EFI stub state. When DRTM is being used the stub's mutable
> +	 * data cannot reside in the normal .init.data because that section
> +	 * will be measured.
> +	 */
> +	.unmeasured.data : {
> +		*(.unmeasured.data)
> +		*(.init.efidata .init.efidata.*)
> +		*(.init.efibss .init.efibss.*)
> +	}
> +#endif
> +
>  	PECOFF_EDATA_PADDING
>  	__pecoff_data_rawsize = ABSOLUTE(. - __initdata_begin);
>  	_edata = .;
> @@ -370,10 +427,15 @@ SECTIONS
>  
>  	. += SZ_4K;		/* stack for the early C runtime */
>  	early_init_stack = .;
> -
>  	. = ALIGN(SEGMENT_ALIGN);
>  	__pecoff_data_size = ABSOLUTE(. - __initdata_begin);
>  	_end = .;
> +#ifdef CONFIG_ARM64_DRTM
> +	/* DEN0113 R314030: The DLME data must start at a 4KB aligned address. */
> +	__drtm_dlme_start = .;
> +	ASSERT((__drtm_dlme_start & (SZ_4K - 1)) == 0,
> +	       "DLME data is not 4 KiB aligned")
> +#endif
>  	__pi__end = .;
>  
>  	STABS_DEBUG
> -- 
> 2.43.0
> 
> 

-- 
Sincerely,
Yeoreum Yun
