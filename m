Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC622392836;
	Tue, 15 Sep 2026 11:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470559; cv=none; b=LJobL75msx+Bt+GjaReYkUlTbeike0Z6GH+nQXXs6FPIRti+DctKNKA2BsDHMzzymoiMx9FTz2i2cLHWluXsxm71xbBhJkTTbWPHXyDMXTcgbDYgSEleAnAsSpGwrPaeGPIyb9J58Abupedw7PAvsCrQ2PC+ebJGhVZ9lk2nK2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470559; c=relaxed/simple;
	bh=Ht+VueHHQDuGb9oo32upfSf1ZdnvEKZ3Bdh5MAm5suk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gh8vrvuyvHqK//MPPdqIQBR3I2f3aG+L9/wDX+855v7Z+s3Oysb5EuNunb8EEUtsbvMwY8SUHTBp+fg6dMhNjwJYdwKe73+cSCVdmQuBK1jHZX9OMtgIsdo0eKwiUA/aJlKkhJOuLG5IHlCaKh9yvl7CpfO9SYyGLWmnfIwO0gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKcX7vyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKcX7vyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BDF1F000FF;
	Tue, 15 Sep 2026 11:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470558;
	bh=Ht+VueHHQDuGb9oo32upfSf1ZdnvEKZ3Bdh5MAm5suk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AKcX7vyo+Nhqh7POFqhvuc9JWBX784D5R/DAbqihHERmisp/ytEs71fMztlOW2a6Q
	 rTX7dxF3H8IE91qdd9WaLYViK/e2+q8CJ/0xQ8h0P5FjdNAFURUFMxZQS6JQRwWaqw
	 59gc6EPseMu1StBwQHlyITJwOnsUk4T0cZkYKTjIZ/qU/ETG4ZkKI/evbXJCH/uAQB
	 CK/6i5BRN3flYByF+/nmrpWB5Tij6+nGj805Xis7a5lL0mwpjKKYdCHfsC3niQxHB8
	 aZoLue0h4eTWvkACvH6N6u1HpJmAvm3IIs6g99qn11U4nvX9bqqGnPF4ZnVUJcItSU
	 ox6T8P9hfDOSw==
Date: Tue, 15 Sep 2026 12:09:04 +0100
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
Subject: Re: [PATCH v2 18/21] kbuild: rust: optionally parallelise rustc
 front end
Message-ID: <aqknMMdLXG-gW1jd@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-18-39817ec5db23@kernel.org>
 <202609141124.F24B6F77@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609141124.F24B6F77@keescook>

On Mon, Sep 14, 2026 at 11:32:14AM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:22:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> > The threads are taken from make's jobserver, so a parallel build is not
> > oversubscribed. It was found that benefits level off at 8 threads (16 was
> > found to be around the same, and 32 slower).
>
> I think it's worth noting that this comes from rustc itself (it has
> built-in support for the make jobserver). See commit ecab4115c44c
> ("kbuild: mark `rustc` (and others) invocations as recursive").
>
> What happens when there is no jobserver, e.g. "make" without -j, or
> "make -j1"?
>
> > [...]
> > rustc has a parallel front end, enabled with -Zthreads, available since
> > rust 1.84 [0] and therefore on every rustc the kernel supports.
> >
> > It is not yet stable and its output is not reproducible, so it cannot be
> > [...]
> > +The number of threads rustc's parallel front end may use, passed to it as
> > +``-Zthreads``. Unset by default, as the parallel front end is not yet
> > +stable and its output is not reproducible. The gain levels off at 8
> > +threads.
>
> Okay, unstable, not reproducible.
>
> > Generated output was confirmed byte-for-byte identical.
>
> But this says otherwise? I am confused. Reproducible or not?

Well, we can set all of this aside as, based on Miguel's feedback, I think
dropping this commit is best :)

>
> --
> Kees Cook

--
Cheers, Lorenzo
