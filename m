Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2674713C9C4;
	Mon, 14 Sep 2026 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411079; cv=none; b=MsepIHyGGc1X6itoL0pk+vKs5PiW/QYKQ2uO/hYTXTXfHoJ4/l8VIqJPxUnL89iuVdiOcUPCdqsjY0Qwvwb19OOU3gVpmFpdeGiOy+OoqVSqNuh0TPLITWhtjuf6oDLpKobeWpUFHsWZKS+avvt668cWdSJ698/IboVZaAsv+OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411079; c=relaxed/simple;
	bh=SjZhDK0nqC8Zf70N+lOhNCSuAoux/KPPcpOxFpCchJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kvle6ksgH74A8km/lXKkQsMEmSVqH5QaJ2pJCfhAU88gdv2di/gF+4L2InDsBgMgdLF/i8AUr7T7ML64p5YGqUJjbzCWsBzO6lc5WcCjDcN3E2jvkzNGEbmv5NHjo9u5vFIGnLi2P/etOItPpL434ABnf5rVgLuaTwLkq6twGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fG+V7yzl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fG+V7yzl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2811F000FF;
	Mon, 14 Sep 2026 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411074;
	bh=TOeAKXfv/9Zy/Vfek9QqwXZIIUS3I0SElaU0l07Cf5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fG+V7yzlO/w0vfzga+Er1Im9w2nHQjGIE6fv/TcE9yZN36AcVaiP2eUfJDKBas6On
	 RFQ/MFy1HF88siOyqxgZmP7n353ap4t60XaHQhej2n7EEy0y8CU1JCQ4YVVihSjaDC
	 Bfi9nJWUmjg/GkyX4dXIEssOZ4wsxkyBjZzeiIIJIEy34FGa4X8vievIYjeAOaij/p
	 Jwt8bVmiMB/Mbdant7+aLCkTFR32BG08p1eflMNYApfK35ofOF+o5rgQ67xfqHu607
	 Prx2UzuIbDPwMzgAqVndZnJMOen14O0sM1o80y2ItrBJL/QPa++KMVODvol6LUxWey
	 Bw8hYleVDBFsg==
Date: Mon, 14 Sep 2026 11:37:54 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 20/21] kbuild: build rust crates in parallel with the
 rest of the build
Message-ID: <202609141133.7CA979C89@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:22:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> Care is taken to ensure that external rust modules can still be built
> against the tree - make modules_prepare ... (where ... are other goals)
> will build rust/ first.
> [...]
>  prepare: prepare0
>  ifdef CONFIG_RUST
>  	+$(Q)$(CONFIG_SHELL) $(srctree)/scripts/rust_is_available.sh
> -	$(Q)$(MAKE) $(build)=rust
>  endif
>  
>  PHONY += remove-stale-files
> @@ -1760,6 +1763,12 @@ modules: modules_prepare
>  # Target to prepare building external modules
>  modules_prepare: prepare
>  	$(Q)$(MAKE) $(build)=scripts scripts/module.lds
> +ifdef CONFIG_RUST
> +# Ensure rust/ is built before any external rust module which will rely upon it.
> +ifneq ($(filter modules_prepare,$(MAKECMDGOALS)),)
> +	$(Q)$(MAKE) $(build)=rust
> +endif
> +endif

As far as I can see, nothing orders this recipe against the tree build,
which also descends into rust/ through "obj-$(CONFIG_RUST) += rust/"
in Kbuild, while $(build-dir) only depends on prepare. Before this
patch that was fine, because prepare had already built rust/ by the
time either of them ran. Now "make -jN modules_prepare all" can have
two make processes building rust/ at the same time, and so can
"make -jN rustdoc all" or "make -jN rusttest all", whose recipes also
run "$(MAKE) $(build)=rust". That means two rustc runs writing the same
objects in rust/ ...

> +# Rust code elsewhere in the tree depends upon rust/.
> +ifdef CONFIG_RUST
> +$(KBUILD_RUST_DIRS): | rust
> +endif
> [...]
> +export KBUILD_RUST_DIRS := drivers lib mm samples

Doesn't this make all of drivers/, lib/, mm/ and samples/ wait for rust/?
That's a lot of stall: drivers/ is most of the tree. I think then a
CONFIG_RUST build has most of its C work waiting on the rust chain;
only the other top-level directories start early? This didn't create new
build delays for those configurations?

-- 
Kees Cook
