Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9631443CEF3;
	Fri, 11 Sep 2026 10:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122628; cv=none; b=o7D6dh/L6yz7SYbgbvQnUcLsmt/FBE+h9Io+FAZPUXc7mOmIZcHET4WoLx8qdbBRfOwJxameO2VrudbtjzHLAbaHTDZNhaY5pY7BM+fqGgxt2l2Ao/ndTLcb0vEMFvj61475WFiAK/WaicCWWGQz6EI/ln3mRzhiqvSrBGrG0GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122628; c=relaxed/simple;
	bh=fJLjHJ4Zesn9ZGCkyFCEtE1u8yd+UsBqa01I0/KBdbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PadOpuUSiNZVvQ4OF7IT1EKZ5hyLbInk0q++rKCEe8ZnqbB7x/KCoMsPcGUluwdwk9BtPAlv0l1XnpSczKa4GaQ8KpZMf9V+m2vvRj7uhJC/DzNsfcPEcPK+S4BfSYt6ACE1M0hJgPqKQW21Dg3gguG5YJw0nGl5a4xR7B84Koc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JZS/pO7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JZS/pO7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4EE1F00893;
	Fri, 11 Sep 2026 10:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789122626;
	bh=HvFCGCANaLFVV/N2IK8KH4LaOjgAeqgCzbjmvYneKXY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JZS/pO7H1pqAZlMiQfD69ngRhDMlBggb2cf7WXqq35hVdt6EJaURUBtmC4djm7YlO
	 xyjg+nnrOjmg2UqBoa2RhbyP0vDv4NP7gutpfcXXNf8+8Jb7DARVGX5NbEmBeqrkhL
	 J6WFa/UqRcOepTtPh7h7pANQKHrW3T9qJbQmAr+uJbt8OZbzEiWD4+lu0YVWY2Y7Vc
	 ybOd5FOj4FYTQ20nMKw8qnkWY/MsN/C3euDfdcLLm0itz4z6/liMd1loce9nvjp4nb
	 on/xsdRR27N/vMX5OG+ddPelyz4EOT6o95KJVuDyPXA1MiXZ9sjuF6rqvoqse3QloP
	 7P4oppuiKyBBw==
Date: Fri, 11 Sep 2026 11:30:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: Nathan Chancellor <nathan@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <aqPXj1nDQ06KRhf4@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>

On Thu, Sep 10, 2026 at 05:42:35PM +0200, Nicolas Schier wrote:
> On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index 8583d9f06c52..3c92c87254a3 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -144,6 +144,44 @@ config CC_HAS_ASSUME
> > >  config CC_HAS_NO_PROFILE_FN_ATTR
> > >  	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
> > >
> > > +config CC_HAS_ZERO_INIT_PADDING_BITS
> > > +	def_bool $(cc-option,-fzero-init-padding-bits=all)
> > > +
> > > +config CC_HAS_NO_STACK_CLASH_PROTECTION
> > > +	def_bool $(cc-option,-fno-stack-clash-protection)
> > > +
> > > +config CC_HAS_NO_ADDRSIG
> > > +	def_bool $(cc-option,-fno-addrsig)
> >
> > I am generally in favor of this proposal since I think these checks
> > should be cached by Kconfig where possible to clear up running them
> > twice. That said, I wonder if we should pick a better dumping ground for
> > these checks other than init/Kconfig. Maybe init/Kconfig.tools or
> > scripts/Kconfig.tools or something?
>

(Sorry hadn't seen you'd replied also!)

> Yes, skimming through the patch, I thought about that, too.  Moving more
> cc option checks to Kconfig will make building out-of-tree kmods with a
> different compiler more dangerous.  Maybe we will have to make the
> warning in Makefile's prepare (external kmods) target a bit louder.

I guess this bit can be a follow up potentially?

>
> > I also worry about backsliding and growing cc-option checks. Should we
> > update the documentation to state that it is preferrable for these
> > checks to live in Kconfig so that they can be properly cached?
>
> Sounds good, yes.

I can add a doc update as part of this series, unless you guys want to handle
separately?

>
> --
> Nicolas

--
Cheers, Lorenzo
