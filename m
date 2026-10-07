Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F664734E2;
	Wed,  7 Oct 2026 09:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791364975; cv=none; b=H3o8sxa+7nM/2Mvvq6foHGPML2kmy4cLDJKQlkOEqsUqTBJZS9Hl7nhyDX0x70jZv0SMlGwxQNJm7WKY3xCEw1fDxmC/9mT0IQ5qflPZfT84qS8t1ydMb5BkJ4MNzyDLI/bCBBd90nvpNvh9O0BT/IS7Cn/YeugL9PieZm9s+Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791364975; c=relaxed/simple;
	bh=fnSW+3AR72ChOdqsxlgqTdRget1O9ocqVPzS+ZkIgng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LfpP4THC88rjJLypsh8822bqCRoqhkrM36r5RjOz1c/BEJlkOavqrhHr7p7fHsbS8CUahvxZvc+F72TzhfyS00dmqLKdFp087Dm2/O675jJwQXzKONkOLhnvI9dBnDTj4HHT0Y4oYQ3qIfr3B9WvYlsl8bgMUvJ3RxGB2/GtDnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cymeLU7l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cymeLU7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61C41F0089D;
	Wed,  7 Oct 2026 09:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791364868;
	bh=/or6rG5Mrt09bN2sohgJYCp41mJB8Pe1pSfr6ygKD10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cymeLU7lc07pxVCvy/4xQZgAUcsH1vM6QJMf3HzA9/ptd8Ikg7D8qOWvQ+KJRzsk5
	 ldaGIVLEg019lRk/7vC+N4gHV35IcOsp4qa3doJwpYNms1gcBYcbewg4vEbfOhC9Mv
	 n/UaVF5DENDmiTCqbvPtFJ23IwQwUKpWdFRfrqnLNvK+yRkMY6kfPXjUuqkwJQ40lT
	 CmgHn9mU88tpYXUQuIEOylo2mrX4NnPIQWZ8ga3HJGmy4Lr1/VgGp45mMk0hx8EbKX
	 u96A6YA+fmWhU68HEy3HZyYU4IqxUyxWo2NARoX8WmAiE5gzyraWTHTWr1SQfz3ROn
	 S2iKXkpm3vhwA==
Date: Wed, 7 Oct 2026 11:21:04 +0200
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nicolas Schier <nsc@kernel.org>, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v1 3/3] efi/libstub: Disable kernel stack erasing in the
 common flags
Message-ID: <20261007092104.GC1504630@ax162>
References: <20261006204210.i.137-kees@kernel.org>
 <20261006204224.1536491-3-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006204224.1536491-3-kees@kernel.org>

On Tue, Oct 06, 2026 at 01:42:23PM -0700, Kees Cook wrote:
> Every architecture that builds the stub now adds $(DISABLE_KSTACK_ERASE)
> to its own flags, so add it once to the flags they share instead.
> 
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/firmware/efi/libstub/Makefile | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 1f588591f458..d6fe69c3af87 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -19,22 +19,18 @@ cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
>  				     $(PADDING_CFLAGS), $(cflags-y))
>  cflags-$(CONFIG_X86_32)		+= -march=i386
>  cflags-$(CONFIG_X86_64)		+= -mcmodel=small
> -cflags-$(CONFIG_X86)		+= -fPIC $(DISABLE_KSTACK_ERASE)
> +cflags-$(CONFIG_X86)		+= -fPIC
>  # Nothing enables IBT while the stub runs, so ENDBR would only take space.
>  cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)
>  
> -# arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
> -# disable the stackleak plugin
> -cflags-$(CONFIG_ARM64)		+= -fpie $(DISABLE_KSTACK_ERASE) \
> -				   -fno-unwind-tables -fno-asynchronous-unwind-tables
> +cflags-$(CONFIG_ARM64)		+= -fpie -fno-unwind-tables \
> +				   -fno-asynchronous-unwind-tables
>  cflags-$(CONFIG_ARM)		+= -DEFI_HAVE_STRLEN -DEFI_HAVE_STRNLEN \
>  				   -DEFI_HAVE_MEMCHR -DEFI_HAVE_STRRCHR \
>  				   -DEFI_HAVE_STRCMP -fno-builtin -fpic \
> -				   $(call cc-option,-mno-single-pic-base) \
> -				   $(DISABLE_KSTACK_ERASE)
> -cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax \
> -				   $(DISABLE_KSTACK_ERASE)
> -cflags-$(CONFIG_LOONGARCH)	+= -fpie $(DISABLE_KSTACK_ERASE)
> +				   $(call cc-option,-mno-single-pic-base)
> +cflags-$(CONFIG_RISCV)		+= -fpic -DNO_ALTERNATIVE -mno-relax
> +cflags-$(CONFIG_LOONGARCH)	+= -fpie
>  
>  cflags-$(CONFIG_EFI_PARAMS_FROM_FDT)	+= -I$(srctree)/scripts/dtc/libfdt
>  
> @@ -44,6 +40,7 @@ KBUILD_CFLAGS			:= $(subst $(CC_FLAGS_FTRACE),,$(cflags-y)) \
>  				   -D__NO_FORTIFY \
>  				   -ffreestanding \
>  				   -fno-stack-protector \
> +				   $(DISABLE_KSTACK_ERASE) \
>  				   $(call cc-option,-fno-addrsig) \
>  				   -D__DISABLE_EXPORTS
>  
> -- 
> 2.55.0
> 

-- 
Cheers,
Nathan
