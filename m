Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609A535C6B2;
	Fri, 11 Sep 2026 18:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151146; cv=none; b=hTR3n1TJ8FfMDKFfzwQjvt/hDDCzKPQlNrZ20Ogw87FoCpy/60lc9+R/7odPCTBWNpvOR5TRuPuRY8Nedb9LMhM5WX3j5mUaA5EAphxE+4scI88NmCRomNRJ5Y4KvseBufWIWXjUkb0zIcKdhy4bBd7fKSAPDIfHhINgcm3OZ8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151146; c=relaxed/simple;
	bh=GkMDfaiKqcg6wNo9HFZUrY6MjHcj3UzMmujQXp5hqko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiUkCpdmak0tfokiKYwROW7ftkNbslPFxzNMcH/ihJrLKYbayWONul5P6IntXmsdottqROsbMFAoDauPFc38oz42UXA8/kLomXBsVqoQDRNHA1uQm+EZr2JDu9kbl6N5dKNBssu5p+/mNaIObaCGXa9kI1rAGO19T1HEinDa1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V/QuD7RK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V/QuD7RK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF181F000FF;
	Fri, 11 Sep 2026 18:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789151145;
	bh=McB2i4WG3qj3jgvtyEEzwZVFRWbrW+2vNGQO4jJcnEw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V/QuD7RKHTWhky3dgb6PVRJNvxWnkze0kt4kkrpUnCYoPR2W7r5F4K2sjrh7TCfss
	 3ahJS7dH3z937W49lrR506NxxwHhwI7zdRL6r32SGdlPGna39Rpd+/8rNoR29ffA/j
	 UVSXzAGjyvuBP1ddhf9lUq9UVY9KejS9z7yop3ddDfhfsHmy2ebKxvWsoDTbtYtpPH
	 2EQmQxGv0R8uinJ5AuwYTYO0/VrdPdDWzjtZjDh4ANe9EnGlPpC3NQn91JHsCLyMS4
	 p/V7dx1LnhW4eNnz1YJP70OKAqj3ALNE8aIfNZa1yGBV5DzFRtttI6lrWcB+hRAAH0
	 T3mOd8cIXS22A==
Date: Fri, 11 Sep 2026 19:25:32 +0100
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
Message-ID: <aqRHk6WtdLz0cpVU@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <aqPXj1nDQ06KRhf4@gremlin>
 <20260911-mottled-gerbil-of-abracadabra-bacb17@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-mottled-gerbil-of-abracadabra-bacb17@l-nschier-aarch64>

On Fri, Sep 11, 2026 at 08:10:26PM +0200, Nicolas Schier wrote:
> On Fri, Sep 11, 2026 at 11:30:12AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 10, 2026 at 05:42:35PM +0200, Nicolas Schier wrote:
> > > On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
> > > > > diff --git a/init/Kconfig b/init/Kconfig
> > > > > index 8583d9f06c52..3c92c87254a3 100644
> > > > > --- a/init/Kconfig
> > > > > +++ b/init/Kconfig
> > > > > @@ -144,6 +144,44 @@ config CC_HAS_ASSUME
> > > > >  config CC_HAS_NO_PROFILE_FN_ATTR
> > > > >  	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
> > > > >
> > > > > +config CC_HAS_ZERO_INIT_PADDING_BITS
> > > > > +	def_bool $(cc-option,-fzero-init-padding-bits=all)
> > > > > +
> > > > > +config CC_HAS_NO_STACK_CLASH_PROTECTION
> > > > > +	def_bool $(cc-option,-fno-stack-clash-protection)
> > > > > +
> > > > > +config CC_HAS_NO_ADDRSIG
> > > > > +	def_bool $(cc-option,-fno-addrsig)
> > > >
> > > > I am generally in favor of this proposal since I think these checks
> > > > should be cached by Kconfig where possible to clear up running them
> > > > twice. That said, I wonder if we should pick a better dumping ground for
> > > > these checks other than init/Kconfig. Maybe init/Kconfig.tools or
> > > > scripts/Kconfig.tools or something?
> > >
> >
> > (Sorry hadn't seen you'd replied also!)
> >
> > > Yes, skimming through the patch, I thought about that, too.  Moving more
> > > cc option checks to Kconfig will make building out-of-tree kmods with a
> > > different compiler more dangerous.  Maybe we will have to make the
> > > warning in Makefile's prepare (external kmods) target a bit louder.
> >
> > I guess this bit can be a follow up potentially?
>
> yes, sure.
>
> > >
> > > > I also worry about backsliding and growing cc-option checks. Should we
> > > > update the documentation to state that it is preferrable for these
> > > > checks to live in Kconfig so that they can be properly cached?
> > >
> > > Sounds good, yes.
> >
> > I can add a doc update as part of this series, unless you guys want to handle
> > separately?
>
> I don't think it has to be part of the series, it's long enough already.
> But if you want to prepare some docmentation about the preference of
> cc-option checks, feel free to go ahead or not.

Ack, thanks!

>
> Kind regards
> Nicolas

--
Cheers, Lorenzo
