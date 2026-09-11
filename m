Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93D53C10A0;
	Fri, 11 Sep 2026 11:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789126153; cv=none; b=EwYrbwGMbCTigbYckgYyO4OW2KXdqZ+K3pJZjxIiBPUgDJt7MVnkB5w1V6pbR7iO1E4OdyDtXcO9xCgzjEUQhaM2ISPEnXMnJqOL24M+WAxrulFE9SvhKRWqKR2koEi9wVYxGeP/fOkNjvwDnDUKXFWhXvOUN4IwAWJXzhGO1tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789126153; c=relaxed/simple;
	bh=XMxz3xWwdRk7Fg5cORCddjoeCBzF69+zQWbsu3cN3+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9kham9cd21ryJ0Z5kbp27mzinT0xRW93AScn1EDUX0V2BDLD3PZkVoXwenRKMYtDVetBwBqjPQ8kmA1lcqExuorLy2Gj8jnuU6UGq730M+IKMjW/zk0WescWo9IkTnfoj7J/NOVr3Z+OvLG3QzNqxCX5PB94aYz2fh9XyG1UTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XcaafniE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XcaafniE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41AB41F00893;
	Fri, 11 Sep 2026 11:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789126128;
	bh=TdwEh7wUoEZtB1Tewr8qRCnFQlC7xBSTZiMIf5U/rjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XcaafniETDZ2wSKshYLr6RtM3Sy36Vvk9x/PRAb7U5Vsd5tHji8Y5MUvTIcmc6tXq
	 43fsW07NSMowcy2CrrI6dSrbNTz4TevR+A9k/LA5KmAmkrf8lxCwnKmxc/M+aNiWS4
	 2OxL8+5hczzpmlY07cIZ9csCmNw9hGd934G1GxWVY6Uc9NpWxYoM+y27Ufsh8MqTkS
	 YHWkS9RKL7qg1Hfhlo3MZPpecwBlKy6O8hFerGRfFlGex5bH9O0EzMCuoBG5z+YTez
	 JT7aoNeua+A+sFXxwhF2OKCeUdt2ixwEaGX96dYDlPPBkDkLgL9XEGI3L09PlHhW5Z
	 2hH322CB8yvTA==
Date: Fri, 11 Sep 2026 12:28:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Florian Fainelli <florian.fainelli@broadcom.com>
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
Message-ID: <aqPlUt6aIvof2LcM@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <a4167b18-f1ea-48bb-9287-210bdd4f35eb@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4167b18-f1ea-48bb-9287-210bdd4f35eb@broadcom.com>

On Wed, Sep 09, 2026 at 02:58:59PM -0700, Florian Fainelli wrote:
> On 9/8/26 13:55, Lorenzo Stoakes (ARM) wrote:
> > A typical kernel build consists of a frustratingly large amount of time
> > spent stuck in single-threaded bottlenecks.
> >
> > It turns out that there's a lot we can do about this and doing so
> > significantly impacts kernel build times.
> >
> > This series makes allmodconfig builds up to 36% faster, incremental builds
> > up to ~70% faster, and noop builds up to ~90% faster.
> >
> > Builds are faster across the board on every device I tested.
> >
> > Machines used for perf testing:
> >
> > * Threadripper -   x86, AMD Threadripper 9980X, 64 cores, 128 threads
> > * EPYC         -   x86, 2 socket EPYC 9754, 256 cores, 512 threads
> > * M2           - arm64, 2022 M2 macbook pro, 8 cores, 8 threads
> >                          (4 perf, 4 efficiency)
>
> My AMD EPYC 9454P server shows an improvement in the order of 13% using the
> arm64's defconfig and make -j97. Thanks for doing this!

Nice thanks! Good to confirm others are seeing the benefits :)

> --
> Florian
>

--
Cheers, Lorenzo
