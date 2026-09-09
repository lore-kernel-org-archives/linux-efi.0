Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40CD3CFF49;
	Wed,  9 Sep 2026 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963753; cv=none; b=Dh4OWqKEQN8RzmGnUivd6LAR/3GlBulxds+ZE6ZsHT1nwS+08vErq1+QK+mxssXFgCe19Z0+tPPfsXO3KNjXlNHSR66CIi7qLTKNW5jmBis5B5kcFf4r4sMMs3swdJ1R77dzNrNinR7rEu6PDcgRDC3BCyNSmgFkvebI1NPnzuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963753; c=relaxed/simple;
	bh=xhaQtXKXvGz1RizoQa7SuL6Y+tbxk3SF34NiCq25TtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hu41MpNKw//ubixiRiqUpTfZdDjVmhImrcFGIYBzvlKHvUcwiWIZbaR/E6Wq+tYW/HZecHbTv4gOlu/tGiH4bGkEdrhTNGNOHM2g6T6PBV9IwVm1Wh6AWzOH9SlYki0I6Gv8rsJIWkB3EDqw5XtG0ag+IvwIANav76MW/AJZ0B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I3WQzUYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I3WQzUYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CED51F00A3A;
	Wed,  9 Sep 2026 14:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788963752;
	bh=Pk1B8WY2LVSwCYtQsLVOVpVrwdeq2SzwuwcAh4JLsyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I3WQzUYyylKqYJS5qmsgtV4gCaBjFEJYODcC8Ol3i3kBCe2qTrc5wzzZNNy4kF7ij
	 8pZMcrWK2JFQFt3KXt2LCmR0gY6JjzAAUj7SLD3O44QFr+LDHBDnSGzjJq2i1A5esv
	 WQ/mxgnq/ZIfTB3Sw6DGSX81V+jiVwk3Xg+uc6Vo5k3b/humXMJcjQ/TwY2F+Shm3v
	 R7yFCwfbbcoXINobG4EEvcVgDaAm1bZ5cKxJ84+SXKZqdc4B1YjEjMydoXY9AXcm2x
	 k9tQ6yabRw+huoALoDMWZNBCDcyVj6/awBwzLz7HZAXgAWaQCg/ZJBXt1SzsvNgMI4
	 IPvSDHhFEdzjQ==
Date: Wed, 9 Sep 2026 15:22:17 +0100
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
Message-ID: <aqFre1PzEBhrQDpZ@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
 <CANiq72m5C5tNKUWTYYerBt81KtqRLgr-S4c5XLUN1uY5n7mqiQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72m5C5tNKUWTYYerBt81KtqRLgr-S4c5XLUN1uY5n7mqiQ@mail.gmail.com>

On Tue, Sep 08, 2026 at 11:13:04PM +0200, Miguel Ojeda wrote:
> On Tue, Sep 8, 2026 at 10:59 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > A future -j/--jobs option is planned for
> > rustc:(rust-lang/compiler-team#1005), so check to see if this available and
> > if so use it.
>
> This is already implemented in nightly as far as I can tell. If it
> weren't, we shouldn't add it, even if planned.
>
> (By the way, could you please add Link tags for those URLs?)

Ack, will do.

>
> > +config RUSTC_HAS_JOBS
> > +       def_bool $(rustc-option,-j8)
> > +
> > +config RUSTC_HAS_ZTHREADS
> > +       def_bool $(rustc-option,-Zthreads=8)
>
> We can simplify using `RUSTC_VERSION` for these like we do elsewhere.

Ack also!

>
> Cheers,
> Miguel

--
Cheers, Lorenzo
