Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D697D51E451;
	Wed, 16 Sep 2026 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572390; cv=none; b=ol2euLNY0YNoVInDADZgepj7iPNBjKHwk3QOBwE6LsABHXlPiOXqROavNKYQwq+SgFzYsdGF7OAtyf1u885dP3zLE16HJR8mjutN/4Tfy/UmPzYXwUmYkq9Mwl0RorYyMfNOnPRBwAxLkrWlS2dkyCOqEwStQzhl+zSQYPZ0Sz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572390; c=relaxed/simple;
	bh=vrhMev+visgbmxdi9X/v5ueu14DSwTLcyTMlv1PSJtM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kwPtmTUTkR+dhkyUL3TXg3qfX539vyBUQnHjiofq9FqSyQYpVgoFFTS13cORK9+/KPnq0lZZ0UY8sXTUJSa3mbgKCMDHfcYtn5+gVNNu67F0M/D8hPk9oA5T0cZQoXFK2ELtd8lzWXU/JaGpeeDDuYGLaTbDqtMwDTc4b5+/L+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EJdACsO7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EJdACsO7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6A01F000FF;
	Wed, 16 Sep 2026 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572384;
	bh=Y+l8sfyIUuoSX7bvFT29PJKYy6pbMBQgbtlLWzXcthY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EJdACsO7go97Dcl6jB4OywafQ3eiab7ESVij2PWxOTnsLO9wrPdoLJ65aFi5XAuTE
	 jzSq6VV0JBKz1MaEsvOiy6+TzKdsDFcab8YWndkxmEqHPiqZgnR0C6fkfGMO5Gi6z9
	 veGK6uTYh+HKeyObu3XIaHrO51mGxvSn5BkBgAPSDXdQpryhc12cOk1yDjuecotRa3
	 Tk2Atdjk3sPAeCSZkjqZ4ONFPDGSKxu8BXtUSvJbpW+IVuB9i6PswRbTLZgREFikky
	 r1zHhlRQ0vUnMY7rMLbQcgDm4EAn1ygs8//LlG0rS/Lc5WENUhggVeZMv9NbT5yRTy
	 346Oidb/gvxoA==
Date: Wed, 16 Sep 2026 16:26:10 +0100
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
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <aqqxmTLnQMr8MKNL@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609151758.BA5732348@keescook>
 <aqqqZfa8Q4D5dBt5@gremlin>
 <202609160805.0DE45DB@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609160805.0DE45DB@keescook>

On Wed, Sep 16, 2026 at 08:09:14AM -0700, Kees Cook wrote:
> On Wed, Sep 16, 2026 at 04:03:39PM +0100, Lorenzo Stoakes (ARM) wrote:
> > This is clearly the way forward, will do that in v3, thanks! :)
>
> Great! I'm really excited to see this (and the other stuff in this
> series) land; I spend _so_ much time waiting on builds. :P

Tell me about it, I've thought the build had _clear_ low-hanging fruit on
the single-threaded path for some time now, but who's got the time right?

I'd say the LLM solved that, but I've been putting in serious human hours
in making this series at least somewhat upstreable, so it turns out the LLM
_makes you think_ it can be done without the timesink, and then makes the
timesink happen anyway ;)

>
> > [Oh and on precedent, it seems the arm64 FIT image builder,
> >  scripts/make_fit.py, uses pigz already if available :>)]
>
> Oh nice find!

LLM found it :P but then I did a shameful:

$ git grep pigz master
master:scripts/make_fit.py:    'gzip': CompTool('.gz', 'pigz,gzip'),

And thought about how I failed to do the obvious thing (how this stuff can
make you lazy... :)

>
> --
> Kees Cook

--
Cheers, Lorenzo
