Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0423947F2F7;
	Tue, 15 Sep 2026 11:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789471001; cv=none; b=ZlAr46vHxHwelmHyfzlbwyC6K52aXAJwZ9UxiOLqAZRWD7x5P2vXs0Uwv0p4iyfPVBIkZhHw1v+hPPWBmtyyam2cCP5yRTPrLi4rJ/Jjhz6OrFLA3SQ5ZuBuKGBTEIJK62W41SCamOpb6ueJTc+WWeawIx42nu7HhTfbLr6SV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789471001; c=relaxed/simple;
	bh=8jGKX9lxad0nC5LwC+m3/xZlEuIw43z0LUda/hlK958=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XkemP/FZOM9cMn9WGK8XwtLVQvVenCTlE9y8z5tTFp9hSxxwIBoho8sS0BAdDYx0Qzj8vq/37gfHlR1ONmUA1hmqrdDnfE4ADCHFU7YcQVWNktxAAJfifnyIBMXAsPkHEP1gUKCnTfXR6q81ySKol9b6um8lsiaySy+fEfvM9LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q++L+p3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q++L+p3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C04A1F000FF;
	Tue, 15 Sep 2026 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470999;
	bh=8jGKX9lxad0nC5LwC+m3/xZlEuIw43z0LUda/hlK958=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q++L+p3WYA6AP7ADzOymmxif7GVxlUsd1TMY/VWqmWYAk0XvwziMicEQbz+6DNao7
	 XcPR++La0+G90EC9iwDjmpnkVeOifjMFofsHBu77Xi5mnhjyguFYPGvKBIUrquwQCI
	 iiCNgS0iUL+FOLtDfRnYLFB+s6SvqNFqz3K69R94xTah6cUkSNdn52CWUZue0M+5dj
	 +CrqVU1SNkWozON17mn8scd2A3/hV0UD6WFULz9ATw+O6zePrJc7pOK13WWXtgy/yq
	 DD0zN4DWDoecYccw8W4FesguEdT1rAdhHxZy1ZHBQenSINumCyPKtJXWVqnfdmsQoZ
	 Uqd2TxsmCMfLg==
Date: Tue, 15 Sep 2026 12:16:25 +0100
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
Subject: Re: [PATCH v2 18/21] kbuild: rust: optionally parallelise rustc
 front end
Message-ID: <aqko2URTMBpa2wDr@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-18-39817ec5db23@kernel.org>
 <202609141124.F24B6F77@keescook>
 <aqknMMdLXG-gW1jd@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqknMMdLXG-gW1jd@gremlin>

On Tue, Sep 15, 2026 at 12:09:04PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 14, 2026 at 11:32:14AM -0700, Kees Cook wrote:
> > On Mon, Sep 14, 2026 at 10:22:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > The threads are taken from make's jobserver, so a parallel build is not
> > > oversubscribed. It was found that benefits level off at 8 threads (16 was
> > > found to be around the same, and 32 slower).
> >
> > I think it's worth noting that this comes from rustc itself (it has
> > built-in support for the make jobserver). See commit ecab4115c44c
> > ("kbuild: mark `rustc` (and others) invocations as recursive").
> >
> > What happens when there is no jobserver, e.g. "make" without -j, or
> > "make -j1"?
> >
> > > [...]
> > > rustc has a parallel front end, enabled with -Zthreads, available since
> > > rust 1.84 [0] and therefore on every rustc the kernel supports.
> > >
> > > It is not yet stable and its output is not reproducible, so it cannot be
> > > [...]
> > > +The number of threads rustc's parallel front end may use, passed to it as
> > > +``-Zthreads``. Unset by default, as the parallel front end is not yet
> > > +stable and its output is not reproducible. The gain levels off at 8
> > > +threads.
> >
> > Okay, unstable, not reproducible.
> >
> > > Generated output was confirmed byte-for-byte identical.
> >
> > But this says otherwise? I am confused. Reproducible or not?

On this though - the lack of reproducibility was the reports in the rust world
of the -Zthreads flag sometimes resulting in that.

I never observed that locally at all, and so locally it was all byte-for-byte
identical.

It could have been worded better :)

>
> Well, we can set all of this aside as, based on Miguel's feedback, I think
> dropping this commit is best :)
>
> >
> > --
> > Kees Cook
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo
