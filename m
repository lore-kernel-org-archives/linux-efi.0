Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CCC3D9DA1;
	Tue, 15 Sep 2026 15:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789484655; cv=none; b=ejYAVnRuZvV3VX3j/nTTIUFN5Axl56rdGYZkeUsOZSe6a/tGlHLSy2hYGZHO7tVdneiHxw8yObUme8LvtMJHoeMNuJ13xvf05GbwUiRkvh318v9R7dCgR08zfbSOXPBW3IM7YJkOKcKr3yffXmdpm3Y/eS0hIoL/ErQLC5v+Tzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789484655; c=relaxed/simple;
	bh=IZYowYo0tr99LV5bF5s2Q786jBuUYkEw4pS9QMyuqbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VHNp+NlDRMt/80ZGWAjRtlSbBcLMYoA74cEeUlx7ACrxZp7qVH9Dzfg5zm+ftYJd6fWMPI1YYCSAY/TfGCbGuKkv3BVIU7JGQKEj2xCT+uEBwyOuaEasO8XsDmy6QM/hA87bPNHJcq/salGMPkjoJKlpenKD1Ibu5Kssm2fsZZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfUJfxGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfUJfxGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445A51F000FF;
	Tue, 15 Sep 2026 15:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789484651;
	bh=6WCAfz85+ZGgRMN8wAwQXLQh8ReFwgRJPZyO/JsNeYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CfUJfxGo8VPDYjL6tBgfl6L002bEGl1ULF2dCRDxLcUo+ron9vtXHUBT/L1UTJo8L
	 U0iLglw63rY+yRq09BUmnCcoTd/5o8qIRnxuo2JlsFOAqKr9geNfwGfR1AickYadR1
	 eZ+UJH8NBVkcyKnuFPyAHxFthRRJgRf2DHU7c2yHI6ZgtsWCDAM9+Dp/WgT7KnklKF
	 xxwMgPPtPplf0k17pupUP4U4BTD5IWphakn+2wgwPt4Ob7KYYh4Fiufotq7wXJZle1
	 XndOOWOAK6nwCgJYzumwG2wlhaFBpVgHKhfhm0X9wnZqdojf8v+Yk3NqQjtqoeQ/bI
	 RWTqH0Scqd2sg==
Date: Tue, 15 Sep 2026 16:04:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Kees Cook <kees@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
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
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 17/21] objtool: decode instructions and resolve branch
 targets in parallel
Message-ID: <aqlau0-opF8yG-JU@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-17-39817ec5db23@kernel.org>
 <202609141112.F8983EE9C@keescook>
 <aqkR9Xqu-0Tem1zm@gremlin>
 <20260915122959.2348bf90@pumpkin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915122959.2348bf90@pumpkin>

On Tue, Sep 15, 2026 at 12:29:59PM +0100, David Laight wrote:
> On Tue, 15 Sep 2026 11:09:25 +0100
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > > > +static unsigned int decode_threads(unsigned long text_size)
> > > > +{
> > > > +	const long nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> > > > +
> > > > +	if (text_size < DECODE_THREADED_MIN_TEXT || nr_cpus < 2)
> > > > +		return 1;
>
> The text_size check ought to be before the sysconf() call.

This is bordering on a silly level of micro-optimisation :)

This is ~us runtime, run once. We can live with it.

>
> > > > +
> > > > +	return min_t(unsigned int, nr_cpus, DECODE_MAX_THREADS);
>
> Why min_t() -  you might as well make nr_cpus 'unsigned int'.

Except... sysconf() returns a long and -1 on error. Isn't min_t()
explicitly for cases like this?

>
> > > > +}
> > >
> > > No, anything using _SC_NPROCESSORS_ONLN internally is wrong, whether its
> > > pigz or objtool.
> >
> > Why? We shouldn't cap a 4 CPU box to 4 CPUs?
>
> You almost certainly don't want to use more...
> (Unless they end up waiting for disk)

Yup on the former.

>
> >
> > The idea is that the empirically obtained 16 core limit should naturally be
> > capped to the number of CPUs.
>
> The 'empirical' limit is very likely to be system dependant.

This same objection could be made against literally anything I do or do not
do, it's a little silly.

Every single cap like this is heuristic and limited. In any case - for
smaller machines, the cap will be CPU count, on larger machines 16 CPUs is
where there stops being an noticeable benefit.

Other solutions are strictly worse, this is a sensible, practical
engineering solution.

> There might also be situations where you don't want the build to run as fast
> as possible because the system is performing other workloads.

Umm what? It's 2026, schedulers are pretty good now :)

In any case with the changes here objtool doesn't dominate the runtime, so
it'll have little impact. So run make j=1 to your heart's content :)

> (Not to mention if you have had to add tracing to find a bug.)

This is almost an argument against parallelism in general.

>
> >
> > I guess in a world where make hands jobs off this could be dropped, though,
> > if the complexity there seems worthwhile.
>
> You need to pull tokens out of the make pipe :-)

Thanks, I understand what's required, as I said to Kees there's simply no
benefit for the added complexity.

Series like this can die by 1,000 cuts with all the nitpicks and what if's,
let's focus on the _significant_ improvements introduced here and keep
things in perspective please!

>
> David
>

--
Cheers, Lorenzo
