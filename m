Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E196495048;
	Tue, 15 Sep 2026 11:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789473502; cv=none; b=re0guxtOKnUFDBiPYJBALjLn1ZVdv8VSyKU8OSqS0hubUn6KO0Vw6hFdyWb3PnDDeHq4ut6Tetpm48FUmmMXhJoBgp0PtK2RtAkXy3FOa/h0ysYrf6lgH91G8yVgTpBqdxV5JZch12IHxHea0qZksSus/3HGXKjZsGAknMGQQnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789473502; c=relaxed/simple;
	bh=QA8zwAoolKTPM25sBgdo58tGELS5tC+ij7uhJxavzjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DrPQSaLm7fLg8z9MB6vOzGQha4UOLg7urPs6MJtKkCdFZtTPh3oWjcgcxnj0h47Ka+0+yO9+RPibKZ5UvWaxSmWFUgG45obMWPL0oXER/Tk8eCYw4uLcTrJLmc24P0qRnDWARCIehNTr1siQ+0qKEPOionDS/nYzDazZ9wkNhp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrCTlWuj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrCTlWuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EBA1F000FF;
	Tue, 15 Sep 2026 11:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789473501;
	bh=jlX8Yrsnfl7deC4qnmmV5NCpDXqR14GNWi2FZvg8+jE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IrCTlWujJ6nrzWR+kPElXgrplKR56V6WHeWWuPOUliQNc2EyivO33TLnPPz8rfLyd
	 k88kypZAu/qjMeNrQ811FOAXJBmQDSOix2pyOY/x4jM4YumgSk11AyXYI3nb1GaMb/
	 cKV4ELQNL9Hc5yAAA9nrg40m1XlqvJTZymo8EyPnbEC7HDmNCGf9nS/jE4eGBEHGNH
	 OASPNxuETHcj7kQOGDaogiKcS/n2iRUy/nYmg6ZAQyWKNgAx9toAxZWJasN3L/YRTP
	 tOgxJoqOAtmjQdN0oSUwjzjs66GznaaahuRcshoM7dapuGX/OrmyTJbin2BisCJOR1
	 BPf8ccBp31CiA==
Date: Tue, 15 Sep 2026 12:58:10 +0100
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
Subject: Re: [PATCH v2 20/21] kbuild: build rust crates in parallel with the
 rest of the build
Message-ID: <aqkv9SqIdh0qKPFc@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>
 <202609141133.7CA979C89@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609141133.7CA979C89@keescook>

On Mon, Sep 14, 2026 at 11:37:54AM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:22:19AM +0100, Lorenzo Stoakes (ARM) wrote:
> > Care is taken to ensure that external rust modules can still be built
> > against the tree - make modules_prepare ... (where ... are other goals)
> > will build rust/ first.
> > [...]
> >  prepare: prepare0
> >  ifdef CONFIG_RUST
> >  	+$(Q)$(CONFIG_SHELL) $(srctree)/scripts/rust_is_available.sh
> > -	$(Q)$(MAKE) $(build)=rust
> >  endif
> >
> >  PHONY += remove-stale-files
> > @@ -1760,6 +1763,12 @@ modules: modules_prepare
> >  # Target to prepare building external modules
> >  modules_prepare: prepare
> >  	$(Q)$(MAKE) $(build)=scripts scripts/module.lds
> > +ifdef CONFIG_RUST
> > +# Ensure rust/ is built before any external rust module which will rely upon it.
> > +ifneq ($(filter modules_prepare,$(MAKECMDGOALS)),)
> > +	$(Q)$(MAKE) $(build)=rust
> > +endif
> > +endif
>
> As far as I can see, nothing orders this recipe against the tree build,
> which also descends into rust/ through "obj-$(CONFIG_RUST) += rust/"
> in Kbuild, while $(build-dir) only depends on prepare. Before this
> patch that was fine, because prepare had already built rust/ by the
> time either of them ran. Now "make -jN modules_prepare all" can have
> two make processes building rust/ at the same time, and so can
> "make -jN rustdoc all" or "make -jN rusttest all", whose recipes also
> run "$(MAKE) $(build)=rust". That means two rustc runs writing the same
> objects in rust/ ...

Ack.

It seems make can't order two independent sub-makes, so will change the patch so
it skips the modules_prepare rust build when a goal that builds the tree* is
present, as they all descend into rust/ themselves.

I checked the change against:

	$ make modules_prepare
	$ make modules_prepare scripts
	$ make -j128 modules_prepare all

+ confirmed they all built rust/ once only for each.

* LLM says: all, vmlinux, modules, image targets, dtbs, rustdoc, rusttest

So, fixed in v3 :)

>
> > +# Rust code elsewhere in the tree depends upon rust/.
> > +ifdef CONFIG_RUST
> > +$(KBUILD_RUST_DIRS): | rust
> > +endif
> > [...]
> > +export KBUILD_RUST_DIRS := drivers lib mm samples
>
> Doesn't this make all of drivers/, lib/, mm/ and samples/ wait for rust/?
> That's a lot of stall: drivers/ is most of the tree. I think then a
> CONFIG_RUST build has most of its C work waiting on the rust chain;
> only the other top-level directories start early? This didn't create new
> build delays for those configurations?

Yeah good point.

For a defconfig+rust clean build on 128 threads the other top-level directories
were done at ~14s while rust ran to ~18.6s, so there was 4-5 of idle.

However the patch improves things by net -3.9s regardless.

This is really only a big box issue though. With fewer threads the rest of the
tree takes longer so it has no impact on the build.

(An aside - this kind of trade-off is what the series is all about really - the
 'serial tail' - i.e. the single threaded stuff that _overlaps_ the end of the
 build is what slows you down.)

Since this _still_ gives you a significant speed up on bigger boxes, I think
it's fine as-is.

The LLM says a fix for this would need significant work - a cross-instance lock
and an on-demand rust/ build. So I think best as a follow-up?

>
> --
> Kees Cook

--
Cheers, Lorenzo
