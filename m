Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481F331ECE;
	Sat, 19 Sep 2026 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829153; cv=none; b=XMKmYtGpVhHG2Uw1KY/3jOvzjGU35i/tUiB/xmbA1MoAgn4JutlETePGOBKTyon8WSTX/5zPkzwdAbW0sZmlSFwwrXUnLWvXQPST9mI18N+JWwyy1WC0aEq8DK8TuiBBHt+KPyvR+siXp6Bv2lsiZlhh4dXZNECrD15DOPZli8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829153; c=relaxed/simple;
	bh=yKFjZGVuLKL+wLssnNWu5ofZJmRwSwShekFn0cj/2PY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U1TXadtbhPSNIiiL5eTKkONQ7bFaIlVu3czPe8xz7vmg/g85MEPmJbLg8L+zx0cc5/WuzLfdgGtEJoKfC1WrTYo7NI0esWuzR80uApsHTXaCuWhMo9rksdd1Z7OSKKaWinBbPx7+4jVEXqavMfvlxcI2LxEi07gp5fIX67oamTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O58txMja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O58txMja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB431F000FF;
	Sat, 19 Sep 2026 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789829151;
	bh=yKFjZGVuLKL+wLssnNWu5ofZJmRwSwShekFn0cj/2PY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O58txMjar5lAsfa7kUjOSXJ2YRXgvUxC3UypZSJgPNilujVfOGvlYFRc6J6q0oCgz
	 tHuDGKgXF76cMg8B4t3RVxRJxLnPIZIsNf2lMP7LYjJStrRrCryXvI3yaAug9WgDFr
	 uSzlIXhwyLMUNfcZVh/qvDfV3HO2AQJBmksh7zqFnC4n4G9rdu3ya3wS+b0fU8o1EH
	 HSRoaeb3d3/0DzJ4xnyocQZFMhIxN07X8dv3s5u1NAYuNgdq+GooFzeHWeROwDPSIV
	 WnohxBmuPIlUXEfLutlDxQbDuYVvmdAV1QZ9fs+isk2iDSSuD2D7e/jXo4cPbDksqx
	 64iZLGMq83FuA==
Date: Sat, 19 Sep 2026 15:45:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <n.schier@fritz.com>, Kees Cook <kees@kernel.org>, 
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
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 10/20] kbuild: move the toolchain checks into
 init/Kconfig.toolchain
Message-ID: <aq6gB7BY9wiFEsQ3@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>
 <202609171149.6454DC6@keescook>
 <20260918010729.GB1585590@ax162>
 <aq1MG8I1BsUUDFkx@gremlin>
 <20260918-athletic-agile-echidna-114f16@l-nschier-aarch64>
 <20260918211248.GB235304@ax162>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918211248.GB235304@ax162>

On Fri, Sep 18, 2026 at 02:12:48PM -0700, Nathan Chancellor wrote:
> On Fri, Sep 18, 2026 at 09:54:27PM +0200, Nicolas Schier wrote:
> > On Fri, Sep 18, 2026 at 03:35:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Thu, Sep 17, 2026 at 06:07:29PM -0700, Nathan Chancellor wrote:
> > > > On Thu, Sep 17, 2026 at 11:53:13AM -0700, Kees Cook wrote:
> > > > > Yeah, totally right to move to a separate file. I think, however, I
> > > > > would prefer this wasn't in init/ though. Kbuild uses scripts/ as its
> > > > > Makefile.$topic dumping ground, and Kconfig.include also lives there. To
> > > > > me, this new file should be scripts/Kconfig.toolchain instead. And
> > > > > arguably, this should be included by the top-level Kconfig rather than
> > > > > init/Kconfig...
> > > >
> > > > I do feel like scripts/ is a better location given that these are really
> > > > things internal to Kbuild but I also see where Lorenzo is coming from
> > > > that scripts/ is a little weird for this to live for discoverability,
> > > > especially if we want people to put checks here instead of in a Makefile
> > > > directly. To be honest, it would be kind of nice to separate the Kbuild
> > > > parts of scripts into their own directory to make it clear what Kbuild
> > > > uses versus what users/contributors should use but that is obviously too
> > > > big of a project to tackle as a prerequisite for this.
> > >
> > > Yeah it just seemed really weird/surprising to me (in the sense of
> > > 'principle of least surprise') to put that in scripts/ and it doesn't seem
> > > that traditionally anything else like this lives there.
> > >
> > > But if you guys feel strongly enough I can put it there.
> >
> > yeah, then I'd also slightly favor scripts/ for now.
>
> Alright, I think scripts/Kconfig.toolchain wins then :)

Ack, will switch it out for v4!

>
> --
> Cheers,
> Nathan

--
Cheers, Lorenzo
