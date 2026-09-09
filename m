Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5FC569F04;
	Wed,  9 Sep 2026 16:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971435; cv=none; b=LCj1cz5pEydsngfoVNIH2iAbTHMy4GcLGUAG3Pdwsg6MamIJW671n/mobnZXFH5sK4ex9ZVel1tRRawLkjy2fT4DA574yvXbi564cPcMDifL+zwhD6x7sIppRttbHblmNQXq8+XjWnngEfWKhL4OM4gKl5jeJycQ5uBMPr0/qOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971435; c=relaxed/simple;
	bh=wWzKtrFidTzm1N7slbL3klzIb0Qo2W2SWXnk1Ha8gms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sPRggIgSGkWPOos/H5UBqeByDwT2NbXy8bfqZ1pTRA36y5Tus4ZP9y4BWmOkesmxYIvgLBbHzui0u2RU8osJBIn0tZj/sbjWQqkgkg8B4FIe918ZUagq2MJhqx2Bm+JHGgG6+Pdng5Hipi3K5eCEJkD077D1Xr0k8C/Cf0A3fUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dcYf5Ku6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dcYf5Ku6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFE61F000FF;
	Wed,  9 Sep 2026 16:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788971434;
	bh=Kz7rWeqwh7ufJDv87BxiJfD/gwwv4aMAp/7XS3gBPEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dcYf5Ku63ij8aECQoJafs4Ipg1pK9oXj9HMZSoM3ml9RYUs9bgWbI892r15HKD+aq
	 TO6FjMT8mTQhfp+iMomWORtQlAM3jIsyaPwYZSaHoJn7R/JGCghwy4f2f0niwav6ni
	 eBJdRLPFcGRmhIBelQgMN8TiQon3ZGk+0ZjUxsPj6ZoUq1f644nJlygEq9jKwgJozp
	 ivMzm6l0Cf1qm0bdrELXOXxe7OHf/vwZsgJpnbZUDSpqIhRXP81TW35ZC+juNo5mm5
	 w8CyZDKbmN2fe9Tm4ZiwdQMSYdgzFqNx03fbVBS+oujn39g8U1gp6xIrrIUpTbPfjZ
	 fo6l8mjP/fXXQ==
Date: Wed, 9 Sep 2026 17:30:19 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
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
Message-ID: <aqGG1iSwF7SyY7d6@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <CAHk-=wieaheq8rXSps3xRZpNNMQMEj9BH5gU+Dh4q_ZgokO51Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wieaheq8rXSps3xRZpNNMQMEj9BH5gU+Dh4q_ZgokO51Q@mail.gmail.com>

On Wed, Sep 09, 2026 at 08:37:10AM -0700, Linus Torvalds wrote:
> On Tue, 8 Sept 2026 at 13:55, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > A typical kernel build consists of a frustratingly large amount of time
>
> .. you're preaching to the choir.

:) Yeah, it's something that's annoyed me for a long time too.

>
> >                 == allmodconfig FULL build ==
> >
> >                         before    after     delta
> >                       ----------------------------------
> > Threadripper, gcc       345.3s   275.2s    -70.1s (-20%)
>
> Well, that's certainly very encouraging. We should do this. I sent out
> some emails as just reactions to individual patches, but I have no
> numbers to back any of those emails up, and I never actually applied
> this series to my tree - they were all based on reading the patches
> themselves.

Thanks, will have a read through those!

I do recommend trying them locally ;)

It makes a surprising difference to defconfig even. (Though you need pigz
installed for the full effect)

>
> That said:
>
> > An LLM was used to first determine where the bottlenecks were then to
> > figure out how to improve them.
> >
> > It generated a lot of code, much of it hideous.
>
> This made me scared to look at the patches originally, and I held off
> in fear that the patches would be horrible and this build time
> improvement would be hugely controversial garbage code.
>
> But:
>
> > I extensively audited and rewrote a lot of it, and heavily edited commit
> > messages, the cover letter and comments.
>
> None of the patches look at all horrible to me. You clearly excised
> the hideous parts. All of my reactions were of the type "this could
> probably be taken _further_" rather than me throwing my hands up in
> disgust.

Thanks! :)

I made sure to audit everything it came up with patch-by-patch, got it to
rework the horrors then rewrote large chunks of what it came up with.

>
> So the Rust parallelism thing clearly isn't ready based on feedback
> from that quarter, but the rest looked safe and innocuous. I'm all for

Sure, happy to drop anything like that.

Though based on what Miguel said it _might_ be ok perhaps with a nightly
gate on it? Will see what he/Bjorn say.

> merging this, although it should obviously go in through the right
> channels. Mostly the kbuild tree, although some of it clearly would be
> other cases - the objtool change in particular is fairly substantial
> and needsobjtool people to approve. It didn't look all that
> contentious, but still..

Agreed, it definitely needs some eyes on it, especially the trickier bits.

>
> Anyway, I'd love for this all to go in. Build times are a pet peeve of mine.

Yeah, it'd be nice to see this benefit everyone!

Am happy to iterate on it as needed to get it upstream.

>
>               Linus

--
Cheers, Lorenzo
