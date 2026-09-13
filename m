Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2102E35A3BF;
	Sun, 13 Sep 2026 20:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789329780; cv=none; b=DF8ptgcIGPp4JEIz6pM3QT2yr0lPcWTHsE5nmQIPpWXNUZxK6jO7mzfavGpfmU0AKKh3+2iz94p3jZSGA2XZ/wZOzokP7L4YNOG9pZGdDDoEOjvZPZ8Vn5Yrov6yh0gJaV9VBFbvj5i+Ks2+H0T7vJOIV4tZ7O+iv1RBFhBazm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789329780; c=relaxed/simple;
	bh=+lVv1ffdcE8MPPnIU0GPodu3dsa72DF3Oy1AUF3Zyu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tvu2XABTFy0rmDkj72dfqg2MhIFWOJElc5VydSiZdmb3p75uiHmz4lrXZwLB6MGnvDwItMxRa4iFNY9vKEKpJt7HkMFZkNJqoEg+UDyRsRstlkPoBkXlR1pWFM12dGxxSaReP74BrwbO+saaZ1fHCEiR4g8uw/siVJtPTt5YNsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlDGsq4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlDGsq4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9299F1F000FF;
	Sun, 13 Sep 2026 20:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789329778;
	bh=FIkAWUWlN6IulmoamTUqkqG8+2dVERWLnANwGikeBxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HlDGsq4/UmYfY5watxSUp7cF5BqBu/g1fAq4lP+77QRdJlpCZqGH4mQ52EiBUPykr
	 Cd0+VHZFXQUlRaRYDhuLoSpQ6FEq0qzmKfJBGEVC9mszdpLneVm8nzdWMjqYWt+YJs
	 jWXqr77zpV3n3Eg0kcjyUT2JBjO+NPlDBxPLNxWlRmlG2ft3w25fXSmaWC6wnopsJU
	 XXVX1gLesBdp5t4hb9bolEagqKfVnSVlUcSLdX9Bw7PA4bFOXWSYqSKsNLE0uRQDfM
	 Tm+p4o7rMkUbztOOJig9dDty0W0F+k/TWF4/7FArPHjjsrjsRaye8GzyFHaa+x3sQv
	 isR4zk4sqpvIg==
Date: Sun, 13 Sep 2026 21:02:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <n.schier@fritz.com>, 
	David Laight <david.laight.linux@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
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
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <aqcAqth2Bhx7J9BT@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <20260911183333.1df0f2e2@pumpkin>
 <20260911-invaluable-indigo-seal-e31aec@l-nschier-aarch64>
 <aqRGYXKDzXZMXmmp@gremlin>
 <20260912071128.GD2002951@ax162>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912071128.GD2002951@ax162>

On Sat, Sep 12, 2026 at 12:11:28AM -0700, Nathan Chancellor wrote:
> On Fri, Sep 11, 2026 at 07:24:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> > I mean this is a problem that already exists for any flags already specified in
> > Kconfig.
> >
> > Out-of-tree modules are historically something that we don't go to great lengths
> > to support and haven't historically worried about breaking, either.
> >
> > I'm sure distros can find ways around this if a problem were to arise. But I
> > don't think it's something to worry about all that much.
> >
> > I expect a _lot_ of these, in any case, would only require the compilers to be
> > within a fair few major versions of one another anyway.
>
> Yeah, while I know distributions will try to maintain a stable kernel
> ABI to allow updating modules without updating the main kernel, I would
> be very very surprised if they guaranteed compatability when building
> external modules with a compiler different from the main kernel. If so,
> I think they get to pick up the pieces :)
>
> One issue that I found with my test matrix building with LLVM is that
> cc-option in Kconfig does not guarantee use of either '-m32' / '-m64' or
> '-mbig-endian' / '-mlittle-endian' to properly flip these options, which
> could result in a flag being set (or not set) when it should be. For
> example, building ARCH=powerpc pmac32_defconfig results in
>
>   clang: error: argument unused during compilation: '-fno-stack-clash-protection' [-Werror,-Wunused-command-line-argument]
>   make[4]: *** [scripts/Makefile.build:193: kernel/bounds.s] Error 1
>
> because the 64-bit PowerPC little endian target supports this flag in
> the PowerPC LLVM backend but the 32-bit big endian target does not.

Ack, reproduced locally thanks!

I had the LLM probe every flag the patch moves in both directions with
clang across ppc32/64 BE and LE, x86 -m32, mips 32/64, rv32, s390x, arm and
arm64 BE and with gcc -m32.

(We really have to stop supporting some of this stuff...!)

It seems that only -fno-stack-clash-protection is problematic for
ppc32/clang.

So in v2 I'll keep that probe in the Makefile and move the rest, have
confirmed that fixes the problem.
>
> I am not really sure what the best way to avoid this would be off the
> top of my head... it might be safer to start with moving only the
> warning flags to Kconfig since that is a truly frontend query.

Given the testing above I think we _should_ be OK :)

>
> --
> Cheers,
> Nathan

--
Cheers, Lorenzo
