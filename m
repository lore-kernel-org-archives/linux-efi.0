Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D1433F58B;
	Mon, 14 Sep 2026 18:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410039; cv=none; b=XLQSudMG/1YHupmi6hi+0UKUFnJecPJf9DW4Pnz7VabcUfKNfpLHG+dcfCYF16tA2sE8BiVlqVlaFIQTez9zC+m02SxrmKnbWRxVqwIbTL/E6S50psQtMuX6QP0H52PFoj5VPpPxIcATvfU3FozpWN8Ro9Uq6IIjgXzwJ3NS3XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410039; c=relaxed/simple;
	bh=MEaXe9dupgJ0dG2A4T12VxNnwmrUzDtVuI12PJzSipA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fY0r2LZLz3OajUNOe1Nsg6fDB17Yvsw+UjnQxHxnR9pjsxiIOk5hwlS+aYAINIWQOuiRQgkb1fIhVpqf4XpMoOC6Vnoe2vHEOOOa4gey4Oedf441eH1PKwy8sTfY0SwFwkswDtq7oOCXQTbaRuE9fmAIkmzxRTcr51vEP+jfZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvldngbW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvldngbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789F21F000FF;
	Mon, 14 Sep 2026 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789410037;
	bh=X5/3wKCFByuy6e88F7rJyETuzHjSkMYrTqWcd9TEpQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bvldngbWosfU/oHiD8GXR3NP8txBLkmvDyR35wKlhJg+vzFmj3e7GATldnngsX08t
	 oRUkhLRYqRHhKT1VXPRELWKtThYQ4sClvZMhzkuquvXfjtMbrRSDyAIVxSKroZPP37
	 9UUlco+kYFfTJDzvlDruBR7Lqyc+gQH+HCHCZT13MiObRuC5PPDF6dnD91+8ai9DOd
	 3O+/4AfL73gs8zMBf1t8sTrzSja6GUM2z1mdK+2uzYKpeUo2fR+7bSz6QCmIqb4EmS
	 Bv5yAYn0TNBiyVoGZNQUiZPKKvV1k+xmTw/SJ7i7XarsjfMwhBisfmrUenRJgmLD44
	 bvfiJnF+AUgag==
Date: Mon, 14 Sep 2026 11:20:37 -0700
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
Subject: Re: [PATCH v2 17/21] objtool: decode instructions and resolve branch
 targets in parallel
Message-ID: <202609141112.F8983EE9C@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-17-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-17-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:22:16AM +0100, Lorenzo Stoakes (ARM) wrote:
> Threads are only created for objects with 8 MiB or more of text, meaning
> that runs involving smaller objects remain unaffected.
> [...]
> objtool on vmlinux.o is on the serial tail of every build that links
> vmlinux, no-op builds are unchanged.

This isn't limited to vmlinux.o, though? With CONFIG_X86_KERNEL_IBT
(default y on x86_64), delay-objtool is set in scripts/Makefile.lib, and
objtool then runs on every multi-object module, in the middle of the
parallel part of the build. In an x86_64 allmodconfig build here,
amdgpu.o has 46.2 MiB of executable text and i915.o has 10.2 MiB, so
each of those objtool runs gets 16 threads on top of the -jN jobs that
are already running.

Any parallelism added need to be handled by the make jobserver, not
hard-coded anyway.

> [...]
> +/* Only an object this large, e.g. vmlinux.o, is decoded on several threads. */
> +#define DECODE_THREADED_MIN_TEXT	SZ_8M
> +/* Only decoding and the branch passes are threaded, so more gains nothing. */
> +#define DECODE_MAX_THREADS		16
> +#define DECODE_RANGES_PER_THREAD	4

I just don't think a size-based approach is going to work. And any max
parallelism needs a rationale.

> +static unsigned int decode_threads(unsigned long text_size)
> +{
> +	const long nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> +
> +	if (text_size < DECODE_THREADED_MIN_TEXT || nr_cpus < 2)
> +		return 1;
> +
> +	return min_t(unsigned int, nr_cpus, DECODE_MAX_THREADS);
> +}

No, anything using _SC_NPROCESSORS_ONLN internally is wrong, whether its
pigz or objtool.

> [...]
> +static int add_jump_destinations(struct objtool_file *file)
> +{
> +	return run_insn_ranges(file, add_jump_destinations_range);
> +}

I haven't examined this myself yet, but my LLM doesn't like this,
saying:

  For an internal sibling call, add_jump_destination() calls
  add_call_dest(file, insn, dest_sym, true), and add_call_dest() calls
  annotate_call_site(), which for --hack-noinstr profiling calls, and for
  __fentry__ calls with --mcount --mnop, does set_reloc_type() and
  elf_write_insn() on file->elf. The per-range shadow gives each thread
  its own lists, but the struct elf is shared, and both helpers write to
  the section and mark it changed without any locking.
  add_call_destinations() is kept serial because "annotating a call site
  rewrites instructions the dead end walks read", so it looks like this
  path needs the same care: a lock, or deferring those writes until the
  threads have been joined. This is from reading the code; I haven't hit
  a failure. Was the thread sanitizer run mentioned in the cover letter
  done with those objtool options enabled?

So, take it with a grain of salt. ;)

-Kees

-- 
Kees Cook
