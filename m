Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB7F372B41;
	Tue, 15 Sep 2026 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789490996; cv=none; b=d4PR1Q982EI9dfD9o0uvBWd/kUxTcLsma5sR7uiaXr2Ki298KCbYOv+thfnJpqB41ZIw8lr4VILtJbFxYOyPNa0uRJL22NgIPsibORwUfqlFIv5LNnw0+zZwnint9dmpzIVW0HXUNvPINgOXNNLgEyjNuGIXj7Ex91W8uur6V9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789490996; c=relaxed/simple;
	bh=IwR8IlFOE6PSPcZfHECA/JijCdOBsbl5qQ9F+b4wUZU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9RNPT7MhyS4R8jzyjDcH/1Xv4s2xVidWvMLApNvlj1TTGAdhZwDy8YGjiTiUDGw0saFJEGqyKkJ2zOoTUxbtySn6/GvJVdLS6Gmz6QrgeUgEgpBgeVUxLhTgeJNEw84sXxgmmYWYG48MdU/W6+WCfMyaCpdGlgjNBEHSEkvgk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eopCimML; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eopCimML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA201F000FF;
	Tue, 15 Sep 2026 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789490994;
	bh=ZPoduYurjOSFdX2MA/IC1rIMtpjmo5SA4Yn6x4dnVcc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eopCimMLWecJrXWLsR7ihQavgXLke2UlIaFCZIuHOMGMRZ/oUOaUP37XVJe+Hrf6l
	 KJfPMz4CB1RLGbIfcjMRXnMcCDrTDOKiNgttsiyfoxbBif0iWU6RAHjxcmWKyApIIx
	 mbedXmufA5qFMHum6a4/+ehaPu4IZWEuqjpiUwP/mf2L11xuhGD/qU3JvUh88k6VMz
	 Nn00+ONModRc6bWnrxAGXXMH/jyXlwsAnXCQwdhQVCuYNLpqVignJh/umWO7DMzYNx
	 1FbIyqHv0slsSorFvnIY+n6Xrr4R0HnDH6ipSzxKwqcLZfVGw3OVr6sRMhOOzyAx9u
	 iSlOBJjPOilyQ==
Date: Tue, 15 Sep 2026 09:49:54 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 14/21] kbuild: batch module finalisation
Message-ID: <202609150943.000EC9277@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>
 <202609141056.6AE2C82E@keescook>
 <aqkZvtAKWYf9-1ZW@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkZvtAKWYf9-1ZW@gremlin>

On Tue, Sep 15, 2026 at 11:44:01AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 14, 2026 at 11:00:27AM -0700, Kees Cook wrote:
> > On Mon, Sep 14, 2026 at 10:22:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > Module finalisation on allmodconfig builds consists of a large number of
> > > very short-lived jobs, and the make job dispatcher cannot possibly dispatch
> > > jobs fast enough.
> >
> > This "cannot possibly" sounds like a weird LLM language intensifier. I'd
> 
> Again that's my writing actually, probably best to stop assuming LLM now ;)

Apologies; whatever the opposite of the Turing Test is, I have failed.
:P The AIs are winning: humans are suspicious of each other now. :)

> > rather a concrete description of the problem, not this kind of
> > (redundant?) vagueness.
> 
> In the very next paragraph I say:
> 
> 	For allmodconfig x86-64 this can be on the order of ~22,000 jobs of
> 	a few milliseconds in duration each.
> 
> You did also say that the commit messages were over-long, so there's a
> trade-off here :)

Right, sorry, I meant I understand the need to collapse the jobs
together, I was just trying to understand where the "128" came from.

> But in more detail, allmodconfig tree (~11k modules on x86-64), best of 2,
> make modules with *.ko *.mod.o deleted:
> 
>     modules per chunk    instances    wall
>     -----------------    ---------    ------
>                     1        11171    10.22s
>                     2         5586     6.72s
>                     4         2793     4.97s
>                     8         1397     4.26s
>                    16          699     4.05s
>                    32          350     4.05s
>                    64          175     4.07s
>                   128           88     4.05s
>                   256           44     4.03s
>                   512           22     4.18s
> 
> which I think makes things clearer.
> 
> So realistically 32 - 256 is the right sort of range. You also have to take
> into account the fact that you might be building fewer modules.

This answers it, thank you!

> The argument for 128 is that this is the mid-point of where the graph
> flattens off for a larger number of modules.
> 
> For a smaller number, you're going to have a single dispatch or less and
> the delta won't be that much anyway.

Understood. I guess I'm trying to better understand the chosen balance
point. Does machine CPU count matter at all for this? i.e. "16" is the
first one to hit the 4 second line, can that be "better" than 128 for
smaller system (or fewer modules)? I'm trying to consider CIs and such
that are bounded to 8 or fewer threads, etc.

> So it's very much a sensibly derived empirical value.
> 
> I'll update the commit message to give this rationale there.

Thanks!

-Kees

-- 
Kees Cook
