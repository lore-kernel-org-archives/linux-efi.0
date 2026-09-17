Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3D24D37B6;
	Thu, 17 Sep 2026 14:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789655588; cv=none; b=n9kV0DMe6dm+uLPmxaSAUXOpyWhCZI9YRiqv1E2ANIa0UkS3wtvYX2BW1DJIw/LlX/dAmrvdE8/jfGw9bnAn3agXgSa8C8u7n/ubnHO4nLGuYC3ZE04bJfSXmr1TrjSRHoaUOnD7R6GQMjFXxYpoa8bnWm/MX9fTHIdDoyIGQx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789655588; c=relaxed/simple;
	bh=/7b9Dge+Xpm43JDEKx4r2OMUe578e0wRvbBLaw5dZ98=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gBftSpmGs1LjPai13FEsalLQT5ITT+IS/JVUYCtdZ72t0H5it3r1GMEtkUHOpdaFnK964oKGOoeTdi3JuXEXo9fF6rJfQLUOcNYmQ5ri+H2QgLDnCEwcFwtggpT2EQYlrF4OUN86aFuWIakcBGoWesrbUiswJfOWbzR1yHjSvig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4w3XnKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4w3XnKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F561F000FF;
	Thu, 17 Sep 2026 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789655586;
	bh=I2ExORUgMX+BoF88CQ1iPiIm+UZCCdszdxXlk48uD6I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h4w3XnKm6CpCBPP6zxny3WxSdq5eHBOnoxot5LhCUHJeGcoeuU7IaQSIAvaInWz8g
	 oHRzCzcN2u5rXZnA8BwBN5B5MY03vwci3WigqJqDc1kf6T86OrB4ddM/4HDTZZQWoV
	 MP2s55Oe1E1FrVud9JJWXPXpFBCgyVUhIsI7VkIlePqbXJN52WONNSdUfXggIJ9j0N
	 U5i9lY0iDsScv6yl2/amtlJJYtlYjnw9GuXokt+SVh3xhwljkgeUCImquvwQHO3LCD
	 gu2VPG0CaGQHuN2mxx+azKf+oE90lG4FG0Nkd1LvBYZbZPRFv6nU4BhGP3iIyXfp05
	 vN8bbHIolSSrQ==
Date: Thu, 17 Sep 2026 15:32:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <aqv5_utZj5Ma76OD@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609151758.BA5732348@keescook>
 <081b2b60-e295-4cd7-b201-d996a88c5f28@app.fastmail.com>
 <202609160809.78E97DC34F@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609160809.78E97DC34F@keescook>

On Wed, Sep 16, 2026 at 08:27:09AM -0700, Kees Cook wrote:
> On Wed, Sep 16, 2026 at 08:38:33AM +0200, Arnd Bergmann wrote:
> > On Wed, Sep 16, 2026, at 03:06, Kees Cook wrote:
> > > On Mon, Sep 14, 2026 at 10:22:20AM +0100, Lorenzo Stoakes (ARM) wrote:
> > >
> > > Makefile:
> > >
> > > KPGZIP	:= $(if $(shell command -v pigz 2>/dev/null),$(PYTHON3)
> > > $(abs_srctree)/scripts/jobserver-exec
> > > $(abs_srctree)/scripts/parallel-gzip,gzip)
> > >
> > > and the same scripts/parallel-gzip:
> > >
> > > 	#!/bin/sh
> > > 	exec pigz -p ${PARALLELISM:-1} "$@"
> > >
> > > And then replace the /boot/ KGZIP uses with KPGZIP. Then we don't need
> > > to change modules, config_data, new users, nor cmd_gzip, etc, which all
> > > continue to use the regular KGZIP and the "use python" part for the
> > > KPGZIP case becomes is a 1-time cost?
> >
> > Nice, I like the idea and this this will work. I didn't know about
> > scripts/jobserver-exec, but this does seem like a perfect fit.
> >
> > I checked the other compression tools we support, and found that
> > zstd is another one that has built-in support for parallel
> > compression, so we probably want to have it there as well.
>
> Follow-up idea:
>
> Having to make a dedicated wrapper script to use jobserver-exec is a bit
> clunky, so maybe the ergonomics need to be improved there slightly?
> Maybe we can add a simple template thingy to
> tools/lib/python/jobserver.py's "run" to replace, say, '%PARALLELISM%'
> automatically, then it becomes:
>
> KPGZIP	:= $(if $(shell command -v pigz 2>/dev/null),$(PYTHON3) \
> 		$(abs_srctree)/scripts/jobserver-exec \
> 		pigz -p %PARALLELISM%

Nice, that seems like a good little cleanup will fold that in, do some checks
then send the v3 out soon :)

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
