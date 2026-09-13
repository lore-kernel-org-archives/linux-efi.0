Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BAF31E858;
	Sun, 13 Sep 2026 16:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789316861; cv=none; b=XMRAPv0pwjs3hZyd4AKCJoq/+Nz+PRIM4+u0BKXLFzPPnXIqycmcLtX0bfEWUA04BFqSCxToklijdCvXRQLlcE1zJnBseG1U3L5K46iwnJsRhsJwiH9U6lHXJCwmQNXgVDGX0VMaGBj3mNOUlRQMprhyYOS5RKXd785F2fx6oyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789316861; c=relaxed/simple;
	bh=O/e6CfAS9RNEQqaHGYKaIdIIqALc4dIkdCyGZZYAd/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kfKHsjgqdZ7hANXu4s2o/+LGrxSwEo6Ibj4OWrYH5OAvzn/FEDbznzC/8iHNsO5I8bX1IyDNdfMGrVsYZ/V/s7iZEbouoDtGJDvI3ZRMH8Vpi0R/+gTD+tugM/VusEy+Telv1f0U7onnXg8zfLLfumztaBILax1BXys1nwgWS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S1T5EvtI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S1T5EvtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049D11F000FF;
	Sun, 13 Sep 2026 16:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789316859;
	bh=A34XyoS7noGhiNdA0/AU98h7WFkZVbNZsRjK3AbUsrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S1T5EvtIkopSpnh+GD+zu8g4AJduDGp4esWSo99SyJNqgNpcU1UVbfy4cZhHMNB0i
	 LHSz2WYMWir3RbcYjKe/iPRdEa+j0hhJUnM/Y2wcjhDmtHgIgTt+SMBRaE+EKNHur3
	 tISbPphKo+YKH1t2eW+TWtim9ts6B0icsa2UF204ftWrTdf6+U35adxnq+u1RGPUgE
	 6+NK6KcfQtUATUK4NjWOw4HkQ4OuKPR6xoMhT8hU+MSm/FZJUMH6cEFCc/BLLAKkax
	 hFL/+6sEynaqO3hN0xSh2fX2eW7avxvzNLOpeFKX5TxXn2w7A57CIRGSGoV88TZ2qI
	 B5QZhmpvaMAEQ==
Date: Sun, 13 Sep 2026 17:27:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Schier <nsc@kernel.org>, 
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
Message-ID: <aqbO2wNPeBiLDwAB@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <a4167b18-f1ea-48bb-9287-210bdd4f35eb@broadcom.com>
 <aqPlUt6aIvof2LcM@gremlin>
 <20260912064437.GB2002951@ax162>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912064437.GB2002951@ax162>

On Fri, Sep 11, 2026 at 11:44:37PM -0700, Nathan Chancellor wrote:
> On Fri, Sep 11, 2026 at 12:28:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Wed, Sep 09, 2026 at 02:58:59PM -0700, Florian Fainelli wrote:
> > > On 9/8/26 13:55, Lorenzo Stoakes (ARM) wrote:
> > > > A typical kernel build consists of a frustratingly large amount of time
> > > > spent stuck in single-threaded bottlenecks.
> > > >
> > > > It turns out that there's a lot we can do about this and doing so
> > > > significantly impacts kernel build times.
> > > >
> > > > This series makes allmodconfig builds up to 36% faster, incremental builds
> > > > up to ~70% faster, and noop builds up to ~90% faster.
> > > >
> > > > Builds are faster across the board on every device I tested.
> > > >
> > > > Machines used for perf testing:
> > > >
> > > > * Threadripper -   x86, AMD Threadripper 9980X, 64 cores, 128 threads
> > > > * EPYC         -   x86, 2 socket EPYC 9754, 256 cores, 512 threads
> > > > * M2           - arm64, 2022 M2 macbook pro, 8 cores, 8 threads
> > > >                          (4 perf, 4 efficiency)
> > >
> > > My AMD EPYC 9454P server shows an improvement in the order of 13% using the
> > > arm64's defconfig and make -j97. Thanks for doing this!
> >
> > Nice thanks! Good to confirm others are seeing the benefits :)
>
> I see similar gains on an 80-core Ampere Altra system
>
>   6h 21m 42s -> 5h 31m 15s (-13.22%)
>
> and a 32-core AMD system.
>
>   3h 38m 55s -> 3h 13m 18s (-11.7%)
>
> The build matrices were different between machines but it is good to see
> similar numbers across different environments.

Nice, yes for sure!

>
> --
> Cheers,
> Nathan

--
Cheers, Lorenzo
