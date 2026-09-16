Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2253331A66;
	Wed, 16 Sep 2026 15:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789571035; cv=none; b=M0ZuazFoJMn8P7jD4oqHcrLPZkp/eQfCsSqnnSNpxeSmF40Zv+xO149CQ0Fp67+OhoJyplI5LyYgQ82OIyBxQkAznqgbuhLzBHLzoXb44kiu4tu7CzrvXFmAmyUfsC50mf/4R7tyWpmKK5UX4/BZp3v06j/8FF79SFhhCThpY2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789571035; c=relaxed/simple;
	bh=ivTw1Y0pX9s+p0MElR8MJ98H6wOFlQU6YGM/Qsoj8hI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FgjWUzIG3H0MUgT18gxREKq66BC9qAg0U3jfoP9qQL3uyjiQULQzsL3ERxZ+Brbg3BJbrY8Vd0to23N3zZ7L2bYJUuaBrBD1+0ybgqpU4r/jlywuQy3fgIpx/dHdjN6HduJHO80B4FSdPwox0AShPVR8HnvLKPDO6BAETuwcpt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hNp9TR4h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hNp9TR4h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BFE1F00893;
	Wed, 16 Sep 2026 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789571034;
	bh=dOv2mUj4IfQe2urPrSpRQzq0891uSiUaHQT6Owxb4wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hNp9TR4hNEa31Lc0OIBbkJdyzLUfzEaSCShJwRUZAyIVBedJucVpionSLbHbhuA12
	 A4LYcd84p8E1yUX+oNnZHXrq7AxrE66qITT8dSJ5yoVQlbjgAVXl4pn9Uv35wr8WDE
	 X6oCqN9iRGTROffI+elLc579AyLZU5pXOTmYO2A5vo4/B68mYilbKrCFbOTZbDxokz
	 rdwtI5djw+jX5yinhipJqexpdkRFsYN21LTdQ7uhn1fk7jnwEWNsUyMLAMYEmMM61E
	 5H7OUlp5zB0ThL+tfxTTww/QqiALf9VJCzMFbYRE6ZjfI5X7IDi/CCJt8YPEk4V11i
	 Rrp4tMEu4icXA==
Date: Wed, 16 Sep 2026 16:03:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
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
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <aqqqZfa8Q4D5dBt5@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609151758.BA5732348@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609151758.BA5732348@keescook>

On Tue, Sep 15, 2026 at 06:06:05PM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:22:20AM +0100, Lorenzo Stoakes (ARM) wrote:
> > diff --git a/Makefile b/Makefile
> > index 790ef23c5e8a..38c0cdc9f591 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -561,7 +561,7 @@ PERL		= perl
> >  PYTHON3		= python3
> >  CHECK		= sparse
> >  BASH		= bash
> > -KGZIP		= gzip
> > +KGZIP		:= $(if $(shell command -v pigz 2>/dev/null),pigz,gzip)
> >  KBZIP2		= bzip2
> >  KLZOP		= lzop
> >  LZMA		= lzma
>
> I had another idea that I think solves both my concerns (limits
> to parallelism, new surprise users) and your concerns (complexity,
> single-threaded when needed)... how about:
>
> Makefile:
>
> KPGZIP	:= $(if $(shell command -v pigz 2>/dev/null),$(PYTHON3) $(abs_srctree)/scripts/jobserver-exec $(abs_srctree)/scripts/parallel-gzip,gzip)

That's nice :) Keeps things simple, separates out the jobserver-exec execution
(which it turns out is no big deal also), and abstracts the idea of 'parallel
gzip'.

Let's do this.

>
> and the same scripts/parallel-gzip:
>
> 	#!/bin/sh
> 	exec pigz -p ${PARALLELISM:-1} "$@"
>
> And then replace the /boot/ KGZIP uses with KPGZIP. Then we don't need
> to change modules, config_data, new users, nor cmd_gzip, etc, which all
> continue to use the regular KGZIP and the "use python" part for the
> KPGZIP case becomes is a 1-time cost?

Yeah that's really nice.

This is clearly the way forward, will do that in v3, thanks! :)

[Oh and on precedent, it seems the arm64 FIT image builder,
 scripts/make_fit.py, uses pigz already if available :>)]

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
