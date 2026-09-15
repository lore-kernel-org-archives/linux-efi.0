Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4803E4D2EC3;
	Tue, 15 Sep 2026 11:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789472167; cv=none; b=kAswy1JAT/UnrrNLBVprN3EdwcojInfe7HhwYmPRCT+BxVXpp6yfCrCvj0iNcYpmUObwYAaiEA7O2BK9OFOryJeiHN2uxs0BKFnhCFgFSX1h3EKefFvLXrOzBTgTOzGy5ahbfNm1uZ7s7hjLGs/yzXf4wAGHQI4SqCx5OKn98tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789472167; c=relaxed/simple;
	bh=f6k58a+kyyJlKOysXGIm7+YVKxFPsWG0XnA963ZSmGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P5wzn5BD/7W+UjIy7MF7NOm2JoIT8KFUT15vDVCMQ9KpsVDlXMyL9SH+mtnM6krC13Q23M7xcDkDMYu7S/m8vQA6lrd+1wpcQHA08t5v0IfrwEIKaoMGJ7RafOY4ChZ74aUOM37/Fs7nW1DLxXJKtdHHk1/ibMGBok33VoNa2pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GYZsbVig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GYZsbVig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1D91F00893;
	Tue, 15 Sep 2026 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472164;
	bh=4BVB43/k5lHtsFkUgtZDywdRjbEBMWb9Mg6O6YdeHrM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GYZsbVigjxwfzphIbqofaPFJmaKXOkEJuH9NfOFwlWENp60vpodSbVNNMVPrnsCGh
	 mKkYFPjcJBJCWstEr5ZbUWw1p8gupBALyutxo/nsXoXJJVjfsUUEDeTeRzg9vNDFKw
	 QyLxl+67I5PApcQALeqp8arjqQrJPg8lKGehuzOG7XGzc750cxvm391kPGZaHUEXVh
	 rRpJvi2VXfCOPb4wIvdWYnRC2MlJNBFBn7hGBAKR93OKepAk7efnXRPGiZufX/FUGN
	 bMk95QWIuEMEbgWtoC+OwCCABis9Vc8v3v1aLMq5PD8Vs1rzrsq653sDeKOiCR8bmb
	 RSzE6TAD8kDPw==
Date: Tue, 15 Sep 2026 12:35:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Kees Cook <kees@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
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
	linux-riscv@lists.infradead.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
Message-ID: <aqks-ZmauZMcOELA@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <202609140833.88C0E16E50@keescook>
 <CAHk-=whB0X28MNAg71it=1SfFyV7rB+PK3qajpRyWoxXHW81fw@mail.gmail.com>
 <7646eb0c-7c4a-4ec2-9562-66a74c4d9858@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7646eb0c-7c4a-4ec2-9562-66a74c4d9858@app.fastmail.com>

On Tue, Sep 15, 2026 at 10:53:51AM +0200, Arnd Bergmann wrote:
> On Mon, Sep 14, 2026, at 17:53, Linus Torvalds wrote:
> > On Mon, 14 Sept 2026 at 08:41, Kees Cook <kees@kernel.org> wrote:
> >>
> >> One area I think might solved via an LLM is the 3-pass kallsyms stuff.
> >> If we could get a deterministic kallsyms build in 1 pass, that would be
> >> very nice. A lot of people have tried, but it has eluded upstreaming.
> >
> > Even the three-pass one hasn't apparently always been entirely
> > deterministic. We've had random reports over the years of it failing
> > in some circumstances.
>
> This tends to break whenever a linker (rather than the compiler) starts
> creating a new type of symbols that show up in pass 2.
>
> > Maybe we've fixed it all, or maybe the failures just go imperceptibly
> > rare. Regardless, it has definitely been fragile.
>
> The rate seems to be once every few years, looking at the list
> of exceptions added to scripts/kallsyms.c (now scripts/mksysmap):
>
> efe6e3068067 ("kallsyms: fix nonconverging kallsyms table with lld")
> 516d980f8541 ("scripts/kallsyms: skip ppc compiler stub *.long_branch.* / *.plt_branch.*")
> b9b74be163a2 ("ARM: 8555/1: kallsyms: ignore ARM mode switching veneers")
>
> I'm sure there are other instances on architectures that get less
> build coverage.

Yeah, it's stuff like this that makes it more sensible in general to use
existing tooling where that makes sense, e.g. also the .mod.S stuff.

Though I also think dropping some of these arches would be a good idea ;)
*ahem*.

In any case, I think the bigger picture ideas like a single pass kallsyms is
stuff for the future.

The way I see it: grab the really low-hanging fruit (this series), then the
medium-hanging fruit, and only then enter the pits of hell to fight the
satanic hordes which clasp on to what remains.

>
>      Arnd

--
Cheers, Lorenzo
