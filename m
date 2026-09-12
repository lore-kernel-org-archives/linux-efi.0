Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E35A4369A;
	Sat, 12 Sep 2026 06:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195491; cv=none; b=uPwhF4sB+5/bdohzOaeohnRphr1tAWA6uZW09pZAB2S0YiCOEDFRR3b7oN7O0nENo54zjdRRyElX7OJsLqEhIu5AtGTj5eWGTTOV3h1uBZSY6QL1lVfkz8/+0DgF0pAvdjbfVW4i2Q5YDLJfiIp7kb5rNtc8LwOkLOrcHBMaVO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195491; c=relaxed/simple;
	bh=tTNhIt/2Ld9YNVw0GTkyuXYb619+hSzvboXagJI0tSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knXrBgn7BgDYx9ngMwt6O1IC8wj2ZNBAgmC+2BaThC9zne0flzkeIz+taOS+GEm9kW6XQKcNuzo3bSklTVw3HOQUzUrpot3gSHc94lg0UcNGXuGD7wLBuHxYd0d6YvY9XTh11HRFzMabF648DVsBosY0zmD8pTz0nsGWjlnaYvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N2Bi/5zE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N2Bi/5zE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D3F1F000FF;
	Sat, 12 Sep 2026 06:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195489;
	bh=KxaeJYmz4IdI2IIHmqchQdajHKy6Zs771P/FPguuVpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N2Bi/5zE6FzP7AovVq0ROouwmcr2zpuMYJ/ewjhq59jZqei0S8amk2jxC+/ZgjWP3
	 AaptvB9VAe75PdStlXkwI7l0RBz8KeqgNl0kz8LaX+a7d1yKSshQvXTkAouGOOpcDC
	 TRW3uqQNZuzDEMe3zlQPptV7QN2T6eFI88tLETBhUCOrdX8ZVRvO4lhBbrOURfPKfP
	 kDNyvjYJbYySIJtdnNEwgU1kLZtxQxsTd4EQsWGkC5BWh2pEuCBuG2VqiU6REavtIb
	 cGh8BTVzx6Xl6W38We3zbRZWqORKPwWtkab+G5KjlOinAcw5F32Mq3vdvWXFklGJDy
	 4fUlbAi0mw5jg==
Date: Fri, 11 Sep 2026 23:44:37 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
Message-ID: <20260912064437.GB2002951@ax162>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <a4167b18-f1ea-48bb-9287-210bdd4f35eb@broadcom.com>
 <aqPlUt6aIvof2LcM@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqPlUt6aIvof2LcM@gremlin>

On Fri, Sep 11, 2026 at 12:28:34PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 09, 2026 at 02:58:59PM -0700, Florian Fainelli wrote:
> > On 9/8/26 13:55, Lorenzo Stoakes (ARM) wrote:
> > > A typical kernel build consists of a frustratingly large amount of time
> > > spent stuck in single-threaded bottlenecks.
> > >
> > > It turns out that there's a lot we can do about this and doing so
> > > significantly impacts kernel build times.
> > >
> > > This series makes allmodconfig builds up to 36% faster, incremental builds
> > > up to ~70% faster, and noop builds up to ~90% faster.
> > >
> > > Builds are faster across the board on every device I tested.
> > >
> > > Machines used for perf testing:
> > >
> > > * Threadripper -   x86, AMD Threadripper 9980X, 64 cores, 128 threads
> > > * EPYC         -   x86, 2 socket EPYC 9754, 256 cores, 512 threads
> > > * M2           - arm64, 2022 M2 macbook pro, 8 cores, 8 threads
> > >                          (4 perf, 4 efficiency)
> >
> > My AMD EPYC 9454P server shows an improvement in the order of 13% using the
> > arm64's defconfig and make -j97. Thanks for doing this!
> 
> Nice thanks! Good to confirm others are seeing the benefits :)

I see similar gains on an 80-core Ampere Altra system

  6h 21m 42s -> 5h 31m 15s (-13.22%)

and a 32-core AMD system.

  3h 38m 55s -> 3h 13m 18s (-11.7%)

The build matrices were different between machines but it is good to see
similar numbers across different environments.

-- 
Cheers,
Nathan
