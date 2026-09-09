Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0C6577E49;
	Wed,  9 Sep 2026 14:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964005; cv=none; b=WRoyaqM1b/PlWqwnNaiMrNEkhjknI07b1U6T7qHXI0ircY2DP/EgvsVgjl1QKXP5TjbubgjmKXso99qD4yoLPXQoel0Hb85TcWDxSKmpHqb+48WKPVn5GSgiHnVlY3ZpdVz+sQVPVcd04RgNt3yBwNUPVYAtcoX36lEpDjCHcvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964005; c=relaxed/simple;
	bh=gic5TB1gjIu6RSleeqefVviRlVsBU2B+Giz1F9TOV84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dtuhUtDytp44y6oUezukNcuYCRaf7jg/V1Sj3yNunir/RfITnoHQlH46rb1IamXpc70ie5y13LUhIfQcKW8WlsrwW74ieeqfOaOtoxzlIU6/yAjilCvBIc1vDT5O3DQ2I/jXjncVx+25xRP+7cMzFaMsC2dUJjGiyBpPiSPvIOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJGsxqSP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJGsxqSP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5935C1F00A3E;
	Wed,  9 Sep 2026 14:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788964003;
	bh=gic5TB1gjIu6RSleeqefVviRlVsBU2B+Giz1F9TOV84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hJGsxqSPGASMshdRSJCdjqaV2MTHzCBOelFMCkNds3SUKI1cp6lgYYL9WvlWqpKiY
	 u+Kr8fJtqUm+2F0r5r+yWto5EILdK28AmJteGlYqyv06gteJ/wga1IEVp7sbb09ZMa
	 nDUytFsFJVzuptuOydFiRQr9qOr4s+rVgAcsjl1yHrkj9q81/ZBU8Q4w71vItIdb7Q
	 6FKrgP0eG1rOEQkj4gVKSakS0M+h2v/B/FCSAMQ+KSwhdA7w5QK8j1eIsAjVFXEOpa
	 ot1NILoh0llV+mv2GC1wRWyTS2CYE2y9cXqBghpj95qgm3Bs0kubAcZIAqnS0JByoE
	 cjOuGdB7tC82A==
Date: Wed, 9 Sep 2026 15:26:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: =?utf-8?B?QmrDtnJu?= Baron <bjorn3_gh@protonmail.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
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
	Gary Guo <gary@garyguo.net>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
Message-ID: <aqFsNv9MDwYq9kbL@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
 <t8iID_-Rgtrxxg-f1ZfdOg1xmm7YedvOT4pgDFEXKxoIeu29-JooZ3SSlbze088O0kLSOdgP7xN_Bo9Xm_lO1x51Gd-gIgT-tFPfwM_gCEw=@protonmail.com>
 <CANiq72=rUrjFD8dHggtO5g0D5Yu-LjO4s7t=+yoKtteD56KfXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72=rUrjFD8dHggtO5g0D5Yu-LjO4s7t=+yoKtteD56KfXw@mail.gmail.com>

On Wed, Sep 09, 2026 at 02:59:13PM +0200, Miguel Ojeda wrote:
> On Wed, Sep 9, 2026 at 12:22 PM Björn Baron <bjorn3_gh@protonmail.com> wrote:
> >
> > There are still several known reproducibility issues for the parallel
> > frontend[1] and at least until fairly recently there were also deadlock
> > issues and incorrect errors[2], so I would not recommend enabling it without
> > an explicit request from the user. Perhaps even only allow it on nightly
> > rustc for now, then you don't need to check which of the two spellings of
> > the flag is supported.
>
> Thanks a lot for taking a look Björn.
>
> If there are still major issues even in nightly, then I would say
> let's not add it yet -- some users/CIs are testing with nightly
> routinely, so it is probably best to avoid surprises for them. (If
> someone wants to test the flag, they can still pass it manually.)
>
> On the other hand, if there are no major issues left and it is just
> reproducibility issues, then I guess we could add it to help figure
> those issues out and avoid surprises later on.

Yup, I am encouraged by 'until fairly recently' on that ;) so maybe just
bump version requirement to whatever this recently was?

>
> > By the way, currently backend parallelism is entirely disabled due to the
> > usage of --emit obj (which forces -Ccodegen-units=1). For -O2/3 builds
>
> Yeah, we even set `-Ccodegen-units=1` explicitly at the moment, so we
> would need to change that too (and likely make it an option, because
> normally end users will want the best results, while developers may
> want speed of iteration).
>
> Cheers,
> Miguel

--
Cheers, Lorenzo
