Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E94353E313;
	Tue, 22 Sep 2026 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082579; cv=none; b=H9mCJO9Bl7E44XAhl8KQQ255pKRuyPZ6hptAoBIjsQBVZH6Cez+8+GQ8I8Ntia2fiHWhkv97xIR9PHjLTY1fTR3AhjV3xUV8mgMzCV1zWgxC7ON2SzOuHTpTyRDUAiChfvylV+cfzm2I3injNp+kVUX1gNLR1Bp9lYcyqPHa+ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082579; c=relaxed/simple;
	bh=AgYRKeGx6YrxHo5tLOfYUAdJiIfBFhEsQpTA/20bgCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmCsgFVgTlNW0Lx7HUbYewalUroonFo1ztFGFVBlssabeCxOG+THkLsdIZE3+Y8GchhmM3dXNO5fQihxhQL8LGkoud+YbggHqdrktmPke4L+LNEUgilT48jMdyZvSy0KpzBrbNn8yM1ejhNEmOj3w8h+FzBMeBmEmGxDkAEh7G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtUom7eB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtUom7eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 037D31F000FF;
	Tue, 22 Sep 2026 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790082578;
	bh=AgYRKeGx6YrxHo5tLOfYUAdJiIfBFhEsQpTA/20bgCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MtUom7eBTFRpDBmC5PC16C5qIL5Ywu9NH+SE0K9c1jgXsItXNIbsoXLlqLDE9nyLi
	 fD7w9uOE4hQ6p5C3WrqxT9iCd0Ti9bY1Yp11pFK8cfEu4cnBoF7cmLzyf7YGb6puUL
	 ACqI1nfguAjSKdnRWZ4sCh5yWXK6a8eUMMQdhCtTvyURYIw0gBPNcz4vv6YhkLixLP
	 tucoL78ZEps4VrU6pRz+AsOmtwsdrdrlTDmZVX01Ew2uILwbH/zWwnPkDwKfCO6QOS
	 DpTalaKpOS69IVpTTWiDFgWTYeUf916M1x0zOQ/73Ce0EJamJnVZsGD0S0GuuSE19p
	 nfnZlw89sqKgA==
Date: Tue, 22 Sep 2026 14:09:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
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
Subject: Re: [PATCH v2 13/21] modpost: emit module descriptors as assembly
Message-ID: <arJ9QwpjQq5Z512z@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-13-39817ec5db23@kernel.org>
 <95baacfb-d8d9-4d2f-bc89-592df6f6f8e3@suse.com>
 <arEZrFmXeCO4hZpP@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arEZrFmXeCO4hZpP@gremlin>

On Mon, Sep 21, 2026 at 12:57:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 21, 2026 at 01:25:09PM +0200, Petr Pavlu wrote:
> > If the <module>.mod.S files are fully self-contained and do not even use
> > something like KBUILD_MODNAME, would it be possible to name them
> > <module>.mod.s and skip the C preprocessor as well?
>
> Ack will do for v4!
>

Unfortunately this broke because the build passes flags that are only
meaningful to the preprocessor (esp. on an LLVM=1 build) and
-Qunused-arguments was removed from kbuild in commit 8d9acfce3332 ("kbuild:
Stop using '-Qunused-arguments' with clang") purposefully.

And some flags are needed and others not so keeping track of which is which
just for this is asking for things to be fragile/break, esp. on the rando
arches.

The win here isn't very much overall so I think I will revert this change
for v4.

(All your other requests have already been applied for v4 :)

--
Cheers, Lorenzo
