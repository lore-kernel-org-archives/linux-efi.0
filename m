Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E3B3B634E;
	Thu, 17 Sep 2026 17:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666596; cv=none; b=dV1KAPh9B9BjqZwDne0G9qzSd6wdNRZE0BlMGtM3yXoKOBjXGyjj4Dzs3IbIlebibzwxI7XgCYIZ2hISXnDNnGjc3zLdwkiwW33Kns4D3nqBteIzDHq0ml1AR3kPirktHk9dmqaWqhBHK6ZmPWd4YF7YI+hFsL2qh6lQ6y46/RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666596; c=relaxed/simple;
	bh=qwgEKnrrYNwqoGULkP2UgUlFnrQ7ncNkJf5Zc57zVR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lt3kVQn3v9piuOYsjjtvRmPwkXLguetjteoeZEGr3Hxn11jXJX0XzeXctMz7ID8+tM62Y4ysrmgBC0oqblil6ts5acuS51E5RjApqvPpy3KT1j+hWwKEqIImO4RfKEB9mhWj+1fEIK9CinVeMef5kNeHyBJTKOztV4BraziJZSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L1SJOQU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L1SJOQU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9279B1F00893;
	Thu, 17 Sep 2026 17:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666594;
	bh=jpy/yjEj4aDooyvICNTbdTtEq9cxmPnAGXVj2NFxZEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L1SJOQU/7zwR2k1r6QQvFbRSb27nGC3gYV7j01JYcrg5+S9rs+/hLSEJEuJHxMTKJ
	 0fTVstSev5PwoNGUQ7/RLh3nO9HabXy9209Zn3Fcc1Yqqk30IqYiODTVrDJIB7nmYs
	 qN5agK3p4SVYFaZTx5zNlmgZs17aBLbUtrKaXz1b8p1aJQS7wNBwY93H9vSNsQG58A
	 Q9nW/cDcWh89WgjM99JxsOGYeAr4Va05Fm7DmR0ejnSn1DfF4etaEEcOAwoVPrCCdB
	 TbrkgAjCCEz99A4aDim3hXRBkQWuEvUY7vuK90fmeIP0DsRTLi8zsgGMhM1mhnbaxP
	 OkVSed7QJUM5Q==
Date: Thu, 17 Sep 2026 18:36:18 +0100
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
	Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 00/20] kbuild: significantly speed up kernel builds
Message-ID: <aqwkk7FcQ0XWeqJW@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <CAHk-=wjwtJQPW+MRAkQCcSGA1EZWehxBTUiEUUhdACCNHSKvTQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjwtJQPW+MRAkQCcSGA1EZWehxBTUiEUUhdACCNHSKvTQ@mail.gmail.com>

On Thu, Sep 17, 2026 at 10:15:26AM -0700, Linus Torvalds wrote:
> On Thu, 17 Sept 2026 at 09:06, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> >                 == defconfig FULL build ==
> >
> >                         before    after     delta
> >                       ----------------------------------
> > Threadripper, gcc        32.5s    26.3s     -6.1s (-19%)
> > Threadripper, clang      34.5s    27.2s     -7.3s (-21%)
> > EPYC, gcc                28.7s    20.6s     -8.1s (-28%)
> > EPYC, clang              39.8s    32.2s     -7.6s (-19%)
> > M2, gcc                 519.3s   512.4s     -6.9s (-1%)
> > M2, clang               634.5s   569.4s    -65.1s (-10%)
>
> There's something odd going on with that M2 gcc build. Why is it such
> an odd duck?

Ugh dear lord I think the LLM somehow corrupted the numbers... Let me
re-run those myself locally and come back with the actual times!

(I didn't do an allmodconfig out of pure impatience but might take the time
to do that too)

>
>              Linus

--
Cheers, Lorenzo
