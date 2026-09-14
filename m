Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5AB385D8E;
	Mon, 14 Sep 2026 18:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410736; cv=none; b=hCgxWav00xixAnW1OHdILFemqIltfiMMvLpIBp6UQOKdU8ZVE+/6z4u8dhngz89IKeialhPh/VXXTLsiLnTPw6D/MnmMQ303uJ7YJPkrZFv8q2ymZoh6De1smbKl9mxByyEpDRrH+UsLxEJOXoH+o0jSCu73gQabrgaUcTiY0ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410736; c=relaxed/simple;
	bh=D2+hleGXIMDN227b5SNY36r7EzpYxCREKmva1l2nkHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nv8YZUORR9KkQpXQ/WxoTj3VMl+zvfVc2n39giYCHlYb0Y6+D3kxMYM2GCbMVC4KO3pp3+2BpscVskTrOBXfn6wq98hR9khr9LkrLhYntrHeByGvSPP754tz3+vq/JimqnucM5Zpg1JJtP++O3vjMIlNvziOFEn6pm35sRfBwlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LT1cFNgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LT1cFNgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DB41F00893;
	Mon, 14 Sep 2026 18:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789410734;
	bh=qh1ZerciXS6mhhgUbgOWtjBtb3wIfa62KF3pRdi9HRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LT1cFNgkvbD3eoVT/UaBEH3+r1ZmImzoNjg1sB0fKgYfiWphX+2k3leDEJjTKPvkI
	 UCeZKsCtpOsU1Qh6ZRgd9PGKscvkwgEZ/CXkgLZsggzcTd3LcxREE5AMbc7rSZ176a
	 7gNUxLvYBfZ5rTEMblheppVavtWDrYGJ9aihGEv2SwKX80uE2nVnkBoFYyryneR1eY
	 l99LJZaV59sYUO8uU85RDxazHEX6uhwHzX4FGdH4s0ESmZYKyjLD5malFkq7HqRZYp
	 MO93SpFQpfLWTJCfXhlr1iU+iBNmOcV7d+vp6+IkNPD3Hj/IjfJ9MaHA5ebXh1WWUJ
	 +Cz7fAfk/ogdA==
Date: Mon, 14 Sep 2026 11:32:14 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 18/21] kbuild: rust: optionally parallelise rustc
 front end
Message-ID: <202609141124.F24B6F77@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-18-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-18-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:22:17AM +0100, Lorenzo Stoakes (ARM) wrote:
> The threads are taken from make's jobserver, so a parallel build is not
> oversubscribed. It was found that benefits level off at 8 threads (16 was
> found to be around the same, and 32 slower).

I think it's worth noting that this comes from rustc itself (it has
built-in support for the make jobserver). See commit ecab4115c44c
("kbuild: mark `rustc` (and others) invocations as recursive").

What happens when there is no jobserver, e.g. "make" without -j, or
"make -j1"?

> [...]
> rustc has a parallel front end, enabled with -Zthreads, available since
> rust 1.84 [0] and therefore on every rustc the kernel supports.
> 
> It is not yet stable and its output is not reproducible, so it cannot be
> [...]
> +The number of threads rustc's parallel front end may use, passed to it as
> +``-Zthreads``. Unset by default, as the parallel front end is not yet
> +stable and its output is not reproducible. The gain levels off at 8
> +threads.

Okay, unstable, not reproducible.

> Generated output was confirmed byte-for-byte identical.

But this says otherwise? I am confused. Reproducible or not?

-- 
Kees Cook
