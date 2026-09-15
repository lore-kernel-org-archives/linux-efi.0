Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9BC1A9F8C;
	Tue, 15 Sep 2026 11:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470933; cv=none; b=bboSx9kysrfkZhwbmx26Z1gVrTYaXLP43n70vyHveVoFkuOqFIxojoKUckBWAwautyB1gDe1wTczXvLeWP0gZEG42JPTvJi5WQXKwgAJICs9c10ZjHI/5TvosHIrZ4jhnHF6BiKO3rORhByoiRAEsEcO1iyrtJYKN+LmP+T0Pu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470933; c=relaxed/simple;
	bh=CF9ILI9YM/ucBOuS3A2BK2pXreguJU8zji6+GHWCn/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qZgDZzNvhRju9g3L7aRdORgiVOkGayODT6FTeWDgq8fDyINJuI2RHs/GKItzie2HLsmlG38kiyUz8N6bGjS2Cvat39hca35xsiJlZwcdBnEp0jXaHmiC1noal9abqSQbFlqijUG8KVRTXuZDSElV1Nkb8Mt/6tK/HOqg+3/lbXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HrcUwFpy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HrcUwFpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510AF1F000FF;
	Tue, 15 Sep 2026 11:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470927;
	bh=CF9ILI9YM/ucBOuS3A2BK2pXreguJU8zji6+GHWCn/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HrcUwFpyn8QxcQDzf1FyVXGhUv9Lvg+4uU5E5bksCbsM9xdWQVrx98pc4yo5aA+mL
	 /smED3Qg96hQ77uOKN5kSpRex+1sMKBAgSH6rVtHuRG0KSweeezfj9161+GZyDIhxu
	 rqyDXPog32TZyUFO9M96tfLSTMSBb1ZwlW2nJ0jhRptBBwghRvEysKhjWr0fcJnc3b
	 ZUCY6fuqbEWIqEpyTj0PILNuJcstedkZMTgj+LfmOeuWZPF1Jd3xSB24NDrnq7CNmo
	 fXjIYvRnslBc73/r7L63E9zDh4vwZ+MVJCsTHtoyA4LPCvTionLdwhARWG6BtGpp7Z
	 9MAWzvtJ/r/pA==
Date: Tue, 15 Sep 2026 12:15:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
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
	Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 18/21] kbuild: rust: optionally parallelise rustc
 front end
Message-ID: <aqknp-KvE9woa760@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-18-39817ec5db23@kernel.org>
 <CANiq72naY0=iBaxfbWQaPv_06X4SjFSix4NybDQdht33+Tcs0g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72naY0=iBaxfbWQaPv_06X4SjFSix4NybDQdht33+Tcs0g@mail.gmail.com>

On Tue, Sep 15, 2026 at 07:32:02AM +0100, Miguel Ojeda wrote:
> On Mon, Sep 14, 2026 at 10:24 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Rust crates are compiled in a serial chain on the critical path - core,
> > bindings, kernel crates and then the drivers - each a rustc invocation.
>
> This confused the LWN article... :)

Sorry :)

>
> There is a critical path in the graph, indeed, and doing it in
> `prepare` is painful, but to clarify: each crate is already built in
> parallel with others where possible, and the fact that each crate is
> built by one `rustc` is unrelated, plus the flag this patch proposes
> is also unrelated to that.

Ack. And the other rust changes help maximise the parallelisation
that exists :)

>
> I guess the LLM was trying to add context to the numbers below, but it
> looks like it will easily confuse readers.
>
> > Each time a change is made to any of the bindings, it triggers a rebuild.
>
> This seems oddly focused (i.e. not sure why `bindings` is mentioned in
> particular). It is also at least independent of this patch, i.e. it
> will remain true regardless of the patch.
>
> > rustc has a parallel front end, enabled with -Zthreads, available since
> > rust 1.84 [0] and therefore on every rustc the kernel supports.
> >
> > It is not yet stable and its output is not reproducible, so it cannot be
> > used by default - stabilisation is being worked on [1].
>
> Not sure what it means by "by default". In any case, the main issue
> with the flag is that it has had issues recently, not so much the fact
> that it is unstable.
>
> > Add optional build parameter KBUILD_RUST_THREADS, which when set passes
> > that many threads to rustc.
> >
> > Observed build time changes with KBUILD_RUST_THREADS=8 (rustc 1.98, clang):
>
> I assume the improvements are most notable due to the work being on
> `prepare`, i.e. there is no other work available. When that is
> relaxed, this should be way less needed. Though it will be still very
> nice to have for full Rust rebuilds, like when changing the compiler
> versions often, due to `core` mainly (e.g. I have to do that often, so
> I would like it :).

Yup that stalling is the key issue.

I mean KRUSTFLAGS=-Zthreads=8 gives you a way to achieve that, I'll stick
that into my scripts locally for now too I think as I've found it to be
completely stable at least on my machine (TM).

But definitely a TODO to pin for you guys once this is stabilised - it
makes a big difference so when a. stabilised and b. kernel required minimum
version has the stabilised feature -> easy to switch on :)

>
> In any case, I am not sure about adding a Kbuild variable already for
> this at the moment, especially with that name, i.e. it is not really
> "threads" but "frontend jobs" and the flag will not be called that in
> the future anyway.
>
> And if someone wants to risk their kernel builds, then they can
> already pass the flag today...

I agree, best to drop this in general, done for v3 already. I've updated
the cover letter to say that KRUSTFLAGS=-Zthreads=8 is what was done with
the build.

>
> (We probably also want to know what the flag will finally do before
> committing to particular names, e.g. whether it affects
> codegen/reproducibility in any way. But perhaps Kbuild doesn't mind
> having new variables that may be replaced soon.)

I don't think it's too egregious either way tbh, but in any case dropping
this for now is the way to go.

>
> Thanks!
>
> Cheers,
> Miguel

--
Cheers, Lorenzo
