Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D447126D;
	Mon, 14 Sep 2026 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789400501; cv=none; b=MjtPYqY/hTV1epMisNxQqC1Cl3xxEORUmqRlgZPAoyKecYNnWiCMgnzdMdahB1Pr742F3W5R4g/j3s2y+SwJwYd+RBMGAXFqHZchwLxPGnnQA6/V1PR0efJrKZ2pGrLzcfmHURk4tktktNbY1Otuf8xx5HVoxISNVR3TbS1dTw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789400501; c=relaxed/simple;
	bh=1C11XBaWmlMwkcWzSZFuI1CdhCAjTwmTkCRbColifqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q5XWwjTfDIRMNXpDSOJqc2WVJIkiuB7EsHdD15jKJMH21B3z5Rewhw95TZKvQq5mEk3HJPUfBeruMKmbSP2Ygm0+Ngz7KX2hZDCnEFhGarcld8jtda93gTMu2mjP2fxlPF8c1M5AxpakOG2u0PADbC1fvVlrER4u7cY4pw9SauU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mXV5Pwoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mXV5Pwoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA81B1F00893;
	Mon, 14 Sep 2026 15:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789400500;
	bh=LlgemL/nYzkX38RnFaAaX6AJ/gCOHK0upUXgQVTNyVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mXV5PwooPI1WG5VI/r91KTvTitOS8mKo2hdWjhq8fQbgJe/U1VtQIvCZhBFeEdQKt
	 sJ/FeF7uTtkAzcHRc8f5Ll+aLRcYHhzklf6O/JXjMXPtD5OBoexg9d2a4PnvCcpEbl
	 W/dAeRct7RHYjVh5dIM7laA5XqDce+wFcD3gA75Af+ngIz6ah9LyD+WIr1XbTIjcS8
	 +iABBytm/WzGYmh7PTm+E7oZlMlYvz0OhAhPDkyiGjJ4DohAsKrTtwTGq4S9XWafHd
	 rItgUDmQjLg4/0Tf3JbQKE14I0mOX5K5QsN1iGeDTE9T/DqILWzH0KpIXD5cEG32KS
	 D9OnMl0TAmaOA==
Date: Mon, 14 Sep 2026 08:41:39 -0700
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
Subject: Re: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
Message-ID: <202609140833.88C0E16E50@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:21:59AM +0100, Lorenzo Stoakes (ARM) wrote:
> This series makes allmodconfig builds up to 36% faster, ...

This is very nice!

> incremental builds
> up to ~70% faster, and noop builds up to ~90% faster.

Some of the changes for this seem to add complexity that I'm not sure
is balanced against the gain? I am still looking through the series,
though, maybe I'll change my opinion. ;)

> 		== allmodconfig FULL build ==

Did you try Clang CONFIG_LTO=y builds?

> 			== LLM usage ==
> [...]
> I extensively audited and rewrote a lot of it, and heavily edited commit
> messages, the cover letter and comments.

I feel like the commit logs still need a lot of work. The LLM verbosity
problem appears in many of them, for example spending 80% of the commit
log describing every step of some process as background before getting
to the actual change. I think a human writing this would be much more
terse about the background. I have, however, been known to be too terse
in my own commit logs. :P

> [...]
> Nothing too controversial was included. There are further improvements that
> could be made, but they would either by very invasive (large scale C header
> changes) or generate diminishing returns.

One area I think might solved via an LLM is the 3-pass kallsyms stuff.
If we could get a deterministic kallsyms build in 1 pass, that would be
very nice. A lot of people have tried, but it has eluded upstreaming.

-Kees

-- 
Kees Cook
