Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102D0472F9B;
	Thu, 24 Sep 2026 23:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790292327; cv=none; b=eeL84LAhCBwsAHRUtmyZ29Li2jrzzdeGiyZ0kkXtHAFoMFku/0fP6v6ioCYWMcXN6NRuu2jRB7CvfjtXBT4R42HfK1uK0LbbKADiyDJU7znhtYscTGtQb9UymVhqSgLTRyOwTb3pZc2riS1Nk99zBx9vHHmj4dGP0UG5M9L70EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790292327; c=relaxed/simple;
	bh=4ofZeZsPS10nkCfHIRsXboOLeOhyBF/VHKJZ7Rw5NG8=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=Dm1QHlq2Fw8ytwhZuLBo6VIv2bsFQaqYlD2r0OnfUQ/PxlZiP08JV85wlxLXy+8I9P8BbwXrQ4nhVizVnPrjDz5qqQ4lp6SCUMZ+VlTk4CURY7N5ng/wTBv3/F08ErJoFe84LK4CJVgV9D8SI3o5y1Jd+kqaCVmLROz7Cs/zl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lP9j5O93; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lP9j5O93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0CA1F000FF;
	Thu, 24 Sep 2026 23:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790292322;
	bh=oiSH4uRWisdHYTr3/mGtD/pllD4YffCL5fwheMZHNIU=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=lP9j5O93+YowN/Tcd7aIj5PvNSSnjX2SiIj7OhnDjJ1Clynyctsv0jkIS280PDVb0
	 XiAsKgY55sUL7a6XBMdJZydf5QD8nVZ1qRChXLtuxB65oXWXkMKA/TlJWODHoG98Rt
	 orVge3h5wawvidyXkV7NkWdLz955zq+Jw+814n4xTANjgtDJ7VGwEFLKePz0T3etNv
	 sgAK9QcHRPSzYAqSDYnbKMYjJuOeVicOzQnxU0hhR/vTSLGKLxNfcTm4AqX0kpFOmh
	 zPAaknpUuEFBeGyV0GY/4mytOiSG9uYhbaADU89v+k8KzcehYbGezTF8Ltc4C6j+xL
	 luNqp+Y5jrelQ==
Content-Type: multipart/mixed; boundary="===============0374088084302990559=="
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <e3ab0833252a329c1ede5118136e151249ea328127785dafddd328066f8d782c@mail.kernel.org>
In-Reply-To: <20260924-b4-arm64-callops-kcfi-v2-9-587865b6d991@linux.dev>
References: <20260924-b4-arm64-callops-kcfi-v2-9-587865b6d991@linux.dev>
Subject: Re: [PATCH v2 9/9] arm64: ftrace: Allow CALL_OPS on kCFI kernels built with Rust
From: bot+bpf-ci@kernel.org
To: jose.fernandez@linux.dev,rostedt@goodmis.org,mhiramat@kernel.org,mark.rutland@arm.com,mathieu.desnoyers@efficios.com,nathan@kernel.org,nsc@kernel.org,ndesaulniers@google.com,morbo@google.com,justinstitt@google.com,catalin.marinas@arm.com,will@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,puranjay@kernel.org,xukuohai@huaweicloud.com,ardb@kernel.org,ilias.apalodimas@linaro.org,ojeda@kernel.org,boqun@kernel.org,gary@garyguo.net,bjorn3_gh@protonmail.com,lossin@kernel.org,a.hindborg@kernel.org,aliceryhl@google.com,tmgross@umich.edu,dakr@kernel.org,daniel.almeida@collabora.com,tamird@kernel.org,acourbot@nvidia.com,work@onurozkan.dev,samitolvanen@google.com,kees@kernel.org
Cc: leon.hwang@linux.dev,ihor.solodrai@linux.dev,jpoimboe@kernel.org,live-patching@vger.kernel.org,linux-kernel@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-kbuild@vger.kernel.org,llvm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,bpf@vger.kernel.org,linux-efi@vger.kernel.org,rust-for-linux@vger.kernel.org,ben@cressey.dev,florent.revest@linux.dev,jose.fernandez@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 24 Sep 2026 23:25:15 +0000 (UTC)

--===============0374088084302990559==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index afa566e0fa86..cad2bdf3456f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -282,11 +282,16 @@ config CC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
>  	# https://github.com/llvm/llvm-project/pull/131230
>  	def_bool $(cc-option,-fpatchable-function-entry=1$(comma)1$(comma).discard.patchable_function_entries)
>
> +config RUSTC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
> +	# The section argument needs Rust 1.98.0 or later:
> +	# https://github.com/rust-lang/rust/pull/157445
> +	def_bool $(rustc-option,-Zpatchable-function-entry=1$(comma)1$(comma).discard.patchable_function_entries)
> +
>  config ARM64_CFI_PERMITS_CALL_OPS
>  	def_bool y
>  	depends on CFI
>  	depends on CC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
> -	depends on !RUST
> +	depends on !RUST || RUSTC_HAS_PATCHABLE_FUNCTION_ENTRY_SECTION
>
>  config ARM64_FUNCTION_PREFIX_NOPS
>  	int
> diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
> index 653c1ed6ef38..b23430e2b856 100644
> --- a/arch/arm64/Makefile
> +++ b/arch/arm64/Makefile
> @@ -152,6 +152,9 @@ ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_CALL_OPS),y)
>  			 -DCC_USING_PATCHABLE_FUNCTION_PREFIX=$(prefix_nops)
>      KBUILD_CFLAGS += $(CFI_PREFIX_CFLAGS)
>      export CFI_PREFIX_CFLAGS
> +    # Rust functions are not patched by ftrace, but they are called indirectly
> +    # from C and make indirect calls themselves, so they need the same prefix.
> +    KBUILD_RUSTFLAGS += -Zpatchable-function-entry=$(prefix_nops),$(prefix_nops),.discard.patchable_function_entries
>    endif
>  else ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_ARGS),y)
>    KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
> diff --git a/rust/Makefile b/rust/Makefile
> index da1a7409d984..b402ab768f72 100644
> --- a/rust/Makefile
> +++ b/rust/Makefile
> @@ -511,7 +511,12 @@ endif
>  # prototypes for functions like `memcpy` -- if this flag is not passed,
>  # `bindgen`-generated prototypes use `c_ulong` or `c_uint` depending on
>  # architecture instead of generating `usize`.
> -bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
> +#
> +# Do not pass -fpatchable-function-entry to bindgen: its libclang may not
> +# support the section argument (Clang >= 21), and removing the flag does not
> +# change the ABI.
> +bindgen_c_flags_final = $(filter-out -fpatchable-function-entry=%, \
> +	$(bindgen_c_flags_lto)) -fno-builtin -D__BINDGEN__
                            ^^^^

This isn't a bug, but could the commit message mention that bindgen's C
flags now drop -fpatchable-function-entry on all architectures, not just
arm64 with CFI?

The change applies whenever any architecture passes -fpatchable-function-entry
in CFLAGS (x86 CALL_PADDING, riscv, powerpc, loongarch, parisc, and arm64
ftrace). The reason for filtering it out (bindgen's libclang may be older
than the kernel's Clang and may reject the section argument) is documented
in the code comment, but the commit message only describes the arm64 kCFI
pieces.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/36069841267
--===============0374088084302990559==--
