Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057D7368D4A;
	Sun, 13 Sep 2026 21:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789335053; cv=none; b=dEsuFXHbvOCFV68B2sbQeVeazVqhQFnld/5Q0HvF8t9aaIOxdrUKgelebwbk2/YMBHzNxWnjSLkZxbB/4olrbIF/PlnXABVKNp+nre0SJcMZbq0L2BF38yAHlFQ4mYvDZlI/ec1JeB0fb6ZYU33JAXgvVVg/AHgR5RIJJI3YzMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789335053; c=relaxed/simple;
	bh=zHj4TrfScp8NUQmY2H3hh9ODOhBU5G/V6DHM3N4sOLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jxqqqMJs13gYqkHHf8YnfaikdBTfi6BX9XIk2pI2c9IsCStz7nl/HlYXupC+KYhWTVMhVT2VlSS0QkesAQK2sqSWLBXmbW9uIPpdWBTgAVEBcj3xmo13XKxa/Lv1TjiZsT77/kzOxz/iEb/q8lSWPyjZd9ALyzgd5owy/6gJHP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AogI6zYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AogI6zYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D97D1F000FF;
	Sun, 13 Sep 2026 21:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789335051;
	bh=8Op6TT+ye7ilPzZZhA+0bF/cZnCKFVYCxqoH+Jt7ciM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AogI6zYE9Khh/gIeznHIfBrXAQbQqM+AaREGLZTqRZLUXl9A0qLUp9IGQpoYOxnfT
	 Oprg5UR25Yk95sS2NoceDjN8dTCPDlZedl/7TNdrQFaiPXp4pI6WxVjIRtyg6ghG9o
	 xhfO11NvrCEN8U6/RYoBgoSQhjru0JOW0O9RDtKvQta9cH4V1Ps/6dSAe4j/7IWR2J
	 OGS3s0ARLZc5A2jUPQYso8SxtcRzmH+F6XTUFnlGHKIcBp2b1AsMuYfRLZp98b9tr6
	 /1Xkwktlq11CX8GXfzTt/2uMWdKY/9D1nNe0QENXcuSOjkppbxgVch47KcNShfKS6M
	 oWYhL+Qadgcjg==
Date: Sun, 13 Sep 2026 22:30:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
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
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
Message-ID: <aqcTSgN7Qui-NYKS@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
 <20260911-impressive-heavy-bobcat-6ceeb1@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-impressive-heavy-bobcat-6ceeb1@l-nschier-aarch64>

On Fri, Sep 11, 2026 at 09:00:40PM +0200, Nicolas Schier wrote:
> On Tue, Sep 08, 2026 at 09:55:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Rust crates are compiled in a serial chain on the critical path - core,
> > bindings, kernel crates and then the drivers - each a rustc invocation.
> >
> > With CONFIG_RUST set and every rust driver enabled, the entire chain takes
> > around 25 seconds on a 128-thread machine, with the associated C code
> > taking 24 seconds.
> >
> > Each time a change is made to any of the bindings, it triggers a rebuild.
> >
> > Use the -Zthreads option to have rustc perform builds in parallel. This has
> > been available since rust 1.84 (rust-lang/rust#132282), and the kernel
> > requires rust 1.85 or above.
> >
> > A future -j/--jobs option is planned for
> > rustc:(rust-lang/compiler-team#1005), so check to see if this available and
> > if so use it.
> >
> > If the user's rustc supports neither, then it falls back gracefully and
> > neither are used.
> >
> > The threads are taken from make's jobserver, so a parallel build is not
> > oversubscribed. It was found that benefits level off at 8 threads (16 was
> > found to be around the same, and 32 slower).
> [...]
>
> > diff --git a/Makefile b/Makefile
> > index 997fc7ebe096..7d23d7b64be3 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1204,6 +1204,10 @@ KBUILD_RUSTFLAGS += --remap-path-prefix=$(srcroot)/= --remap-path-scope=macro
> >  endif
> >  endif
> >
> > +ifdef CONFIG_RUST
> > +KBUILD_RUSTFLAGS += $(if $(CONFIG_RUSTC_HAS_JOBS),-j8,$(if $(CONFIG_RUSTC_HAS_ZTHREADS),-Zthreads=8))
> > +endif
>
> Is there a reason for the 'ifdef CONFIG_RUST'?
>
> Hard-coding '8' feels a bit odd.  If some kind of KBUILD_RUST_JOBS would
> be used, it could allow users to disable or override the parallelism for
> rust.  Does it make sense to have rust parallelism configurable?

Have decided to go with a build var for v2 - KBUILD_RUST_THREADS=n - which
solves the default thread count, the instability issues and the confiigurability
all at once! :)

>
> --
> Nicolas

--
Cheers, Lorenzo
