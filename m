Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E164B66F8;
	Tue, 15 Sep 2026 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789494877; cv=none; b=NwexmxrGSWX3wj7h/gcOLXQicCZKlRomflBTOs8sXdmW/HU/jkIPuUh9v+fSRboug1SCALYpjuoPHZfuDSQarWCEnXqssmWV0Rvr1qHIJn9uN0Q5P3f/IuSNpAhCVDhi+IHwdzs/L/wUaZZxSK0cpZudgKgMODrWuKsRcwDq3to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789494877; c=relaxed/simple;
	bh=Idqr9Wrn4izplbq3MGcSCLnFdXVLB68EJNvOywwiksM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eueSAGPkYDQJDsTneTYm/BxVA3kf0Qw5P5f2vRzBeubF0983fm3QHU5xY6fklTPPcKp5ETUCMRbP9nEdD9eaTcRRi/gOTf36kUt8F2PLxgkzBH/lwSuagoxsye9cnjjsPgpndZlKEPh/4xTaJDaB68bKWl5TR70WwaBaUgyt/iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmsHSJAD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmsHSJAD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93B41F000FF;
	Tue, 15 Sep 2026 17:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789494874;
	bh=dd8IONVWTgWB4zisBjzXmLEaDZAjBCMpoK1NcYYsi/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JmsHSJADWdCM9TPjIXNO+o6w0DzQXA7CfDF+dQVIuhRqwFsDgVeYg88AEwpCfiHYQ
	 23IguvcICwICMGuBFbRe+l/zRzDFuKBAeqlEqv6I0v2PL4qrSultoLA1eKOSLTSfCy
	 fVJJf23iY395gzjTPmknAhJOtmVoXZzNveLJWzceI5HOGPJDVq1MTYWNyaD0ydEAok
	 ZokmcrnGlJuJ9DNcCYokev16q6ZU50u1HPC5TTWzDLiWnkuE+av2uVPIEuaEIZ9uHN
	 938xOZMn7HcDht8+Jt9Fzje9YE1jFmnfv4Arh8/23jpCiZnY3a97CRWQFB/gjSwiT5
	 zdAOOfGl4pLPg==
Date: Tue, 15 Sep 2026 18:54:19 +0100
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
Subject: Re: [PATCH v2 14/21] kbuild: batch module finalisation
Message-ID: <aql6EsHUZGGMNQuf@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>
 <202609141056.6AE2C82E@keescook>
 <aqkZvtAKWYf9-1ZW@gremlin>
 <202609150943.000EC9277@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609150943.000EC9277@keescook>

On Tue, Sep 15, 2026 at 09:49:54AM -0700, Kees Cook wrote:
> On Tue, Sep 15, 2026 at 11:44:01AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 14, 2026 at 11:00:27AM -0700, Kees Cook wrote:
> > > On Mon, Sep 14, 2026 at 10:22:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > Module finalisation on allmodconfig builds consists of a large number of
> > > > very short-lived jobs, and the make job dispatcher cannot possibly dispatch
> > > > jobs fast enough.
> > >
> > > This "cannot possibly" sounds like a weird LLM language intensifier. I'd
> >
> > Again that's my writing actually, probably best to stop assuming LLM now ;)
>
> Apologies; whatever the opposite of the Turing Test is, I have failed.
> :P The AIs are winning: humans are suspicious of each other now. :)
>
> > > rather a concrete description of the problem, not this kind of
> > > (redundant?) vagueness.
> >
> > In the very next paragraph I say:
> >
> > 	For allmodconfig x86-64 this can be on the order of ~22,000 jobs of
> > 	a few milliseconds in duration each.
> >
> > You did also say that the commit messages were over-long, so there's a
> > trade-off here :)
>
> Right, sorry, I meant I understand the need to collapse the jobs
> together, I was just trying to understand where the "128" came from.
>
> > But in more detail, allmodconfig tree (~11k modules on x86-64), best of 2,
> > make modules with *.ko *.mod.o deleted:
> >
> >     modules per chunk    instances    wall
> >     -----------------    ---------    ------
> >                     1        11171    10.22s
> >                     2         5586     6.72s
> >                     4         2793     4.97s
> >                     8         1397     4.26s
> >                    16          699     4.05s
> >                    32          350     4.05s
> >                    64          175     4.07s
> >                   128           88     4.05s
> >                   256           44     4.03s
> >                   512           22     4.18s
> >
> > which I think makes things clearer.
> >
> > So realistically 32 - 256 is the right sort of range. You also have to take
> > into account the fact that you might be building fewer modules.
>
> This answers it, thank you!
>
> > The argument for 128 is that this is the mid-point of where the graph
> > flattens off for a larger number of modules.
> >
> > For a smaller number, you're going to have a single dispatch or less and
> > the delta won't be that much anyway.
>
> Understood. I guess I'm trying to better understand the chosen balance
> point. Does machine CPU count matter at all for this? i.e. "16" is the
> first one to hit the 4 second line, can that be "better" than 128 for
> smaller system (or fewer modules)? I'm trying to consider CIs and such
> that are bounded to 8 or fewer threads, etc.

I would say no, because the parallel aspect is coming from the jobserver in
each chunk, not from the chunk count, so the CPUs are busy whatever the
chunk size.

And the size is balancing the start-up against the cost that grows with the
number of targets in each, so there's an equilibrium that's reached and
past that you don't really gain anything, and that doesn't change with CPU
count.

>
> > So it's very much a sensibly derived empirical value.
> >
> > I'll update the commit message to give this rationale there.
>
> Thanks!

NP, Already done with all the other changes queued up for v3 :)

I will give time for more feedback before respinning though!

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
