Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0554457A6;
	Fri, 11 Sep 2026 11:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789125968; cv=none; b=JrZij5PcGXWhYlPjf2VkH5e0N1l7VK6GUPS15ns0ipzUw3iAS1YBVAOtahqbr6qfGKKGyGIoHjv9VDU0eGtQ4yvf9uX0AD2uk5Mhfc28gaG+/K0vvIdKC4ko4kMQHjt/bc2LCyvoW1Apa9zP76osmXYC2E57aGHU9BFKZnXAANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789125968; c=relaxed/simple;
	bh=limdG7iqTJH4ElLSnmTuuK3uee/BjGUPcvZqHysHW0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JAMdnHRHik4DrOojwkruasrerbhoweZgG1HDfmIzEeQbaGAu95j0QDtBqJCwra/xhwmcOzjB+egjGEYDxfHF2Z+Za0dg8qbNGy6aVy8zOGuc+ao/eUYgV572gNDPPe2XSshwoPCAFOrIEju25K/C9jCGqnoFMB7pr12IgtKjQcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovdJkn1+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovdJkn1+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E071F000FF;
	Fri, 11 Sep 2026 11:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789125952;
	bh=limdG7iqTJH4ElLSnmTuuK3uee/BjGUPcvZqHysHW0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ovdJkn1+n2Xa/HSnex3YjDFO2KbfhBxhc0ZdaLdHyehs1gqEr51Nzw2uwYipYaf+3
	 ShJd7JPRyZyDSCQfG1A/B1KlXaZIsedvL3nJMTxIhzKoTY8n59OEYX2qKsowcDVzF8
	 pu44Si6aULXKS8aAqrd9mM9S6BBNtnqbk81Eaaru496HCuu1b71N/gTwC45BRGxYg0
	 mj5FhIO3UbgDmDuo2E4Ezz5g76L6FGXyqaHbYCfq9tDi5eK3K0qQga4bPbTWgZmtub
	 eLBHaP6WpPrv35lwy0BOxJ32kvrvGPCDN617FVQ1ORpnq/7MZ3nMUdH3GBDnOksEhS
	 6Wc0bT7UpLvlQ==
Date: Fri, 11 Sep 2026 12:25:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Schier <nsc@kernel.org>, 
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
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
Message-ID: <aqPjmExe9j1fSNV0@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <CAKwvOdmdFdW8=y+s5NLoNeKz4LVbmW8tr+JqJ26wqYFJDdARFQ@mail.gmail.com>
 <aqFptJRjLZIL-NX7@gremlin>
 <CAKwvOdnMuwKxPB_SXDcwmrAiwZFXWUAgcS1TdAkW+bqhYEZ=ZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdnMuwKxPB_SXDcwmrAiwZFXWUAgcS1TdAkW+bqhYEZ=ZQ@mail.gmail.com>

On Wed, Sep 09, 2026 at 03:09:10PM -0700, Nick Desaulniers wrote:
> On Wed, Sep 9, 2026 at 7:17 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > On Tue, Sep 08, 2026 at 02:06:18PM -0700, Nick Desaulniers wrote:
> > > It would be cool if your LLM could generate any visualizations of
> > > what's going on during a build? Seeing what's serial vs parallelized
> > > in perhaps useful. Particularly when you can compare the before vs
> > > after.
> >
> > Great idea!
> >
> > I asked it to do exactly that, attached. Came out quite nice and sums it up
> > nicely :)
> >
> > It also provided an ASCII version:
>
> unreadable, but the pictures you attached are worth a thousand words.

:) Yeah I didn't think the ASCII was amazing either but fun that it tried ;) and
yeah I was surprised at how nice the graphic came out...!

> Particularly exciting are the speed ups to the usual edit+compile+run
> loop.

Yes! I never really expected that out of this!

I mean I didn't think there'd be such a big speed up in general, though I
expected at least to shave off a big chunk of the delta between compile + full
build on a defconfig clean build.

But the incremental/noop build improvements are really important to day-to-day
use.

>
> For the blue graph (the top one, first), any idea what that dip in the
> middle is? That's always what annoyed me.

That's ld -r of vmlinux.o, then modpost and objtool which are critical path
blockers on the rest of the build.

Before the series that was 23 seconds for allmodconfig on the threadripper, now
7s :)

There's still more objtool stuff that could be done that I opted not to do yet,
it takes 6s to run so dominating.

> --
> Thanks,
> ~Nick Desaulniers

--
Cheers, Lorenzo
