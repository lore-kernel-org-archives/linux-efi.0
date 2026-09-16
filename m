Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2586E521227;
	Wed, 16 Sep 2026 14:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789569049; cv=none; b=nMjtfvJCpuAXSIr2evgWLli/7+SCL0VxY+4Mfq+9JdqPOwlCl5oTnJkx1Z0p86cQvYy3rqAEJ8i1Ggd6tJtKaSZMHs4JQB6+rR3I7Me8JCOc/5RhP/ptArvMzIK3Eok1PIdQQZs1MSZWH8wHh0ta3wjvumgeSt5fM6svPFgzHfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789569049; c=relaxed/simple;
	bh=eidKeq4ulUavy98T6SGA6sf/tDZUFQd5Vg6vRS+1Nbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W4P5znVxjMmNVEYKbkgWpEL9DJJlhQCYULayjDGTfgctShJqRi688fZ+PtkYxKiZPPblIZPPthRDPadyW7+pk98sAaLjXCTabIjR85f0RtbWXBVY24fOKRcYXe0WkhNVzF/JXQMpPs22hyfX5yGcBNLttDddVj8vHEptcwo85iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LNOVW3P8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LNOVW3P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EF21F00893;
	Wed, 16 Sep 2026 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569046;
	bh=Sf2nPqPSoF8deq5OYrsGYaM5lP9Vq8plK7Qs1+50D6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LNOVW3P81mUBhRO0/pMJp0Fue9fjWU1wrtHSjWyAgH85HRAoZwM4kbPCQYpxU7+le
	 Pe8FJmVgN3hXMijiNFNO2rRTXlno2shHa9jXQ2hzkn+BCFm3WG5AOkg6/YXeTPuSrM
	 WvrIm64q2uPVC/8u1Pcrn9nUz5TG1foCGquzjdG0nCoyXrCzvC4zFdCQOjOyCOyNa8
	 /5pYj780rd7HwMC54yH0Hinwfk382BKUkcENW+jOObtYMdheFRmP/EszJ/jz7x5Opi
	 4ofgkbLAD4t4kUUCmGNoohdh3rRHHbNkvI3kCNSSmLZOp2jwQB/3fpRTGKh+NtIfy/
	 wrkiSsNDvPAig==
Date: Wed, 16 Sep 2026 15:30:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kees Cook <kees@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Bill Wendling <morbo@google.com>, 
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
Message-ID: <aqqn4eWZrywvSm2u@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>
 <202609141056.6AE2C82E@keescook>
 <aqkZvtAKWYf9-1ZW@gremlin>
 <202609150943.000EC9277@keescook>
 <CAKwvOdms6QWc7RMW6hJb3qzgmpK+aw40C7b_h7eG161ie_Y8ZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKwvOdms6QWc7RMW6hJb3qzgmpK+aw40C7b_h7eG161ie_Y8ZA@mail.gmail.com>

On Tue, Sep 15, 2026 at 10:56:01AM -0700, Nick Desaulniers wrote:
> On Tue, Sep 15, 2026 at 9:49 AM Kees Cook <kees@kernel.org> wrote:
> >
> > On Tue, Sep 15, 2026 at 11:44:01AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Mon, Sep 14, 2026 at 11:00:27AM -0700, Kees Cook wrote:
> > > > On Mon, Sep 14, 2026 at 10:22:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > > Module finalisation on allmodconfig builds consists of a large number of
> > > > > very short-lived jobs, and the make job dispatcher cannot possibly dispatch
> > > > > jobs fast enough.
> > > >
> > > > This "cannot possibly" sounds like a weird LLM language intensifier. I'd
> > >
> > > Again that's my writing actually, probably best to stop assuming LLM now ;)
> >
> > Apologies; whatever the opposite of the Turing Test is, I have failed.
> > :P The AIs are winning: humans are suspicious of each other now. :)
>
> Is there a term for this yet?  Cylon paranoia?

Haha, now you'll get me watching that series again... and it'll all
probably feel very prescient! ;)

>
> --
> Thanks,
> ~Nick Desaulniers

--
Cheers, Lorenzo
