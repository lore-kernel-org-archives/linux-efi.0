Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1384C3D6CA6;
	Wed,  7 Oct 2026 09:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791364849; cv=none; b=DcbWlA50kdhLjad2WAAR9DrhuGiDc1Ee221/6/jOWoyJ9haG2kpZdBJOIC81F/Twyj/3ICx2KpkPL26waNetZvPeZ1qtVVytf5KrLExBkKW4AIwTCzsHC026UFYHYZ9ZkPjZdDXOb1AdvInKBgQoeNmxYFqgzlocqT1eT8W9Bb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791364849; c=relaxed/simple;
	bh=v+1D+9UrP88OX6a6LoRq0OX7xVKDJcoL1NYXjlHElSY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sonTJBLu2aNWxJFBm+ak97Pn1codbO+2i2CXX5lEG19G+Y34IFNEkZSBT6X/LHJMY78JKaF9fYyus4L8R1lN/47Y04tSuTkZRlnFplUHngg6b85Ke/brWhEXENRcVgfLNMzGa8rudLYa9E47rVcPJq2uBU0htA+IW95FYOYXigM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdaF4TS4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdaF4TS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A5C1F0089B;
	Wed,  7 Oct 2026 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791364818;
	bh=G0OmIMHBW9HxWtN4WxeeRtKxTs/p/aeGkdt5RZ3zUsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HdaF4TS4YHzgwPcDsfxXECRlDce0qOcIWbpnQ7fVji75anEMpjOn0qO08PExchRsw
	 ng+NzUhBoYeXg8yIgST8y5Sqsvrqjf397YQOWL3xAWXvbW19aYaXAwcgLGgupgYknH
	 KbS90AKAn33xrhF6EJYsjiHX5J05unomoyaQryKThYAaeWxAkqY4AsfKp04cFIqZx/
	 Rld7eiZpE8kZUApixNrKtoLro7l/He7hPplR3vglKgrRWjrkTCs8dIcECThk9AAkpg
	 GxMcx0mwFQ1vhZPK2gjJMU2GS54nptog9Gp9+9KYZLYiPR+lB1952ZHD+ILGk+eccF
	 I+kbkHIQNBBBA==
Date: Wed, 7 Oct 2026 11:20:13 +0200
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-efi@vger.kernel.org,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v1 2/3] efi/libstub: Build the x86 stub from KBUILD_CFLAGS
Message-ID: <20261007092013.GB1504630@ax162>
References: <20261006204210.i.137-kees@kernel.org>
 <20261006204224.1536491-2-kees@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006204224.1536491-2-kees@kernel.org>

On Tue, Oct 06, 2026 at 01:42:22PM -0700, Kees Cook wrote:
> The x86 stub replaces KBUILD_CFLAGS with a short list of its own, so new
> kernel-wide compiler options go missing, unless explicitly remembered
> or when lacking them breaks the build, e.g. commit 5ff8ad3909524
> ("kbuild: Add '-fms-extensions' to areas with dedicated CFLAGS")
> did. Today, several still go missing that are provided to non-x86
> stub builds, e.g. -ftrivial-auto-var-init, -fzero-call-used-regs,
> -fstrict-flex-arrays=3, and the various kernel's warnings.
> 
> Flip the x86 option logic to match the other architectures. Since the
> x86 stub is linked into the decompressor rather than the kernel proper,
> remove the kernel code model, the i386 register calling convention,
> and the kernel's reduced stack alignment, along with the retpoline and
> return thunks and the call padding, which only the kernel provides,
> and disable kernel stack erasing as the other architectures do. The
> existing -mcmodel=small, -march=i386, and -fPIC still get overrides.
> Build with -fcf-protection=none, since nothing enables IBT while the
> stub runs: the firmware applies forward-edge CFI only to images that
> advertise it, which bzImage does not.
> 
> New flags that change code generation or semantics in a plain x86_64
> defconfig hardening.config stub:
> 
> Hardening:
> 	-ftrivial-auto-var-init=zero
> 	-fzero-init-padding-bits=all
> 	-fstrict-flex-arrays=3
> 	-fno-strict-overflow
> 	-fno-delete-null-pointer-checks
> 	-fno-allow-store-data-races
> 	-fno-jump-tables (from the default IBT config)
> 
> C semantics:
> 	-funsigned-char
> 	-fno-common
> 
> x86 code generation:
> 	-mno-sse2 -mno-3dnow -mno-avx -mno-sse4a
> 	 (stub already added -mno-mmx -mno-sse)
> 	-mno-80387 -mno-fp-ret-in-387 -mskip-rax-setup
> 	-falign-jumps=1 -falign-loops=1 -fmin-function-alignment=16
> 	-fomit-frame-pointer -fconserve-stack
> 	-fno-stack-clash-protection -fno-stack-check -fno-builtin-wcslen
> 
> Warnings (lots and lots, but notably):
> 	-Wall -Wextra -Wundef -Wmissing-prototypes
> 	-Wvla-larger-than=1 -Wimplicit-fallthrough=5
> 
> Present but with no effect, because the stub's later flags override them:
> 	-O2, overridden by -Os
> 	-fstack-protector-* flags, overridden by -fno-stack-protector
> 	-fno-PIE, overridden by -fPIC
> 	-fcf-protection=branch, overridden by -fcf-protection=none
> 	the stack-erase plugin, loaded and then disabled
> 
> Build tested ARCH=x86_64 defconfig hardening.config, plus retpolines,
> return thunks, call depth tracking, IBT, GCC plugins, and EFI mixed
> mode, with GCC 16.2.0 and Clang 24.0.0git, and ARCH=i386 defconfig
> hardening.config with GCC 16.2.0. Each booted through the EFI stub to
> userspace under QEMU with x64 and IA32 OVMF, the latter in mixed mode
> for x86_64.
> 
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>

Yeah, this has long been needed. Looking over the list of flags in the
.cmd files, I don't think there should be anything problematic. I'd love
to test this on one of my machines at home to make sure but the coaxial
line from my condo unit to the junction box is broken :) so I'll just
settle for:

Reviewed-by: Nathan Chancellor <nathan@kernel.org>

> ---
>  drivers/firmware/efi/libstub/Makefile | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 77a2b2d74f3f..1f588591f458 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -6,18 +6,22 @@
>  # enabled, even if doing so doesn't break the build.
>  #
>  
> -# non-x86 reuses KBUILD_CFLAGS, x86 does not
>  cflags-y			:= $(KBUILD_CFLAGS)
>  
> -cflags-$(CONFIG_X86_32)		:= -march=i386
> -cflags-$(CONFIG_X86_64)		:= -mcmodel=small
> -cflags-$(CONFIG_X86)		+= -m$(BITS) -D__KERNEL__ $(CC_FLAGS_DIALECT) \
> -				   -fPIC -fno-strict-aliasing -mno-red-zone \
> -				   -mno-mmx -mno-sse -fshort-wchar \
> -				   -Wno-pointer-sign \
> -				   $(call cc-disable-warning, address-of-packed-member) \
> -				   -fno-asynchronous-unwind-tables \
> -				   $(CLANG_FLAGS)
> +# x86 links the stub into the decompressor rather than the kernel proper, so
> +# drop the kernel's code model, calling convention, and stack alignment, and
> +# the mitigations that rely on thunks and patch sites only the kernel has.
> +cflags-$(CONFIG_X86)		:= $(filter-out -mcmodel=kernel \
> +				     -mregparm=3 -freg-struct-return \
> +				     -mpreferred-stack-boundary=% \
> +				     -mstack-alignment=% \
> +				     $(RETPOLINE_CFLAGS) $(RETHUNK_CFLAGS) \
> +				     $(PADDING_CFLAGS), $(cflags-y))
> +cflags-$(CONFIG_X86_32)		+= -march=i386
> +cflags-$(CONFIG_X86_64)		+= -mcmodel=small
> +cflags-$(CONFIG_X86)		+= -fPIC $(DISABLE_KSTACK_ERASE)
> +# Nothing enables IBT while the stub runs, so ENDBR would only take space.
> +cflags-$(CONFIG_X86)		+= $(call cc-option,-fcf-protection=none)

Note that post commit 454e00cf8ee5 ("kbuild: avoid re-running compiler
and linker probes") in the kbuild tree, this can become

  cflags-$(CONFIG_X86) += $(CONFIG_CC_OPT_CF_PROTECTION_NONE)

>  # arm64 uses the full KBUILD_CFLAGS so it's necessary to explicitly
>  # disable the stackleak plugin
> -- 
> 2.55.0
> 

-- 
Cheers,
Nathan
