Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E79A4E56FD;
	Wed, 16 Sep 2026 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567418; cv=none; b=k0g4RCErPqElinwcQsvouEu+R2vFkolmkRGwZLnexHdkxV+8s6WKnu9Kty+0YevUBZJ7p5CezEW4WUlaaXSCTMaWaAP+KLBhgWDkv8CW9/FWRUiEjA6WuSwo/aBywdlEF49d+ZAWMryv+XQ+pHbLcgtU62Ew96wkrBzhSzaxx80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567418; c=relaxed/simple;
	bh=TkXVw7bC4g65duQjFd6vedB6h/ilVBg8U3NCSCJYqFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sq1Rz2k8OaHP57cx7lmqSDtPp/9i98WX7fxJwIeuUsxLKq/0KQUqhlAtrHER083n1bMnC4TqsIpZ2uzgL/hH9b5g1M0WeC6iuWlOvpHp2K8xP0DYdEJi/GQvsbZblFcXHynS4wP8MZc7UN/Hq8tTBVtBF4pLBG6Xzu9smyBtZPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7RWrddx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7RWrddx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7105E1F000FF;
	Wed, 16 Sep 2026 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567417;
	bh=hO1YRILVaBOqm+dWq6qCTgxEbPpdVWHsaZacHfjUT/A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f7RWrddxO53t7XqQWGQqpP3lfBJi6WfPwofmEdM57qil6qIChEXUlmwKor5h6kBoa
	 9GtiaQGHN39ej2oq8F37LOrKCVhmvTOQjKW6hJb7MLQQEBdL7Wp00+3QWKwZvAomyS
	 NoKwMiPOeftTdpj8xAtWPVc7gLXBtJhue+mreMUdP9rjPp5itv0EZmpo1EcFGFuaOg
	 6wBCD6BMMJuwTQfzHiqvbcCmwd3OrUYtvR6xVydAwVB94b6TjTf4NHDOAN6iJkQ1H5
	 JA+OYVYfyUjxkHRwB6C+LIyIx3AxkqaUGC2gvED56T6jLRNYsj01r7C5w9ImRppKs6
	 qi9QEBSo801MQ==
Date: Wed, 16 Sep 2026 15:03:21 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gary Guo <gary@garyguo.net>
Cc: Kees Cook <kees@kernel.org>, 
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
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 20/21] kbuild: build rust crates in parallel with the
 rest of the build
Message-ID: <aqqhKFuclruH3lXn@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>
 <202609141133.7CA979C89@keescook>
 <aqkv9SqIdh0qKPFc@gremlin>
 <DLGKLQ9LJPBG.3QU14CCO1Y6Q@garyguo.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLGKLQ9LJPBG.3QU14CCO1Y6Q@garyguo.net>

On Wed, Sep 16, 2026 at 08:42:41AM +0100, Gary Guo wrote:
> On Tue Sep 15, 2026 at 12:58 PM BST, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Sep 14, 2026 at 11:37:54AM -0700, Kees Cook wrote:
> >> On Mon, Sep 14, 2026 at 10:22:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> >> > +# Rust code elsewhere in the tree depends upon rust/.
> >> > +ifdef CONFIG_RUST
> >> > +$(KBUILD_RUST_DIRS): | rust
> >> > +endif
> >> > [...]
> >> > +export KBUILD_RUST_DIRS := drivers lib mm samples
> >>
> >> Doesn't this make all of drivers/, lib/, mm/ and samples/ wait for rust/?
> >> That's a lot of stall: drivers/ is most of the tree. I think then a
> >> CONFIG_RUST build has most of its C work waiting on the rust chain;
> >> only the other top-level directories start early? This didn't create new
> >> build delays for those configurations?
> >
> > Yeah good point.
> >
> > For a defconfig+rust clean build on 128 threads the other top-level directories
> > were done at ~14s while rust ran to ~18.6s, so there was 4-5 of idle.
> >
> > However the patch improves things by net -3.9s regardless.
> >
> > This is really only a big box issue though. With fewer threads the rest of the
> > tree takes longer so it has no impact on the build.
> >
> > (An aside - this kind of trade-off is what the series is all about really - the
> >  'serial tail' - i.e. the single threaded stuff that _overlaps_ the end of the
> >  build is what slows you down.)
> >
> > Since this _still_ gives you a significant speed up on bigger boxes, I think
> > it's fine as-is.
> >
> > The LLM says a fix for this would need significant work - a cross-instance lock
> > and an on-demand rust/ build. So I think best as a follow-up?
>
> If we do it we're basically reinventing a new build system. Not saying that
> Kbuild isn't one already :)

:)

I mean arguably make is a seriously limiting factor in improvements (the other
might be... C headers... but that's a whole other kettle of fish ;)

>
> Best,
> Gary
>

--
Cheers, Lorenzo
