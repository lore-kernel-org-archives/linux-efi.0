Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3245E412294;
	Tue, 15 Sep 2026 10:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466981; cv=none; b=OEZbQzWfjPx5Em6125ARuMPBdibxw+Fqj7CJLwNwdP99V+VkQYwEosQSkEpAbcp2MpTSTe4mjlPbctdJfrIkdZZ5a/inU3j1xCeqUnr+Uqej0x2u0AuUc+5aW6L9NNHEWYLOCU5Na5HIGO59EM3JDPjnRid1jjhaK8GsrNBEkzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466981; c=relaxed/simple;
	bh=sU13gsIPUMKUUtL+qE3bab68IEWBsOM0qs/yA9Hs9x0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnIPh522vrTCUiO9Lo5JJIcyVSCnXTQQ2hkpSiDbW7lAKomqn7vpsVK4jUITRPbLNvbYy/d5m3UWN9kO+xApMS7X5d3r8jGxQzbgojtQ1sruvT1MI9LHrDhk+9MaNVviZy804pZnhrLwtTHTIrnWZq0qt0F8gItipxuEwPYdzng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B494kHSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B494kHSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449E81F0089B;
	Tue, 15 Sep 2026 10:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789466979;
	bh=qEaRhFWvrYZ8Js/oY4HcGJ8ME90lEWxqY3aLTqH5KyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B494kHSs2gB2n5O4XU5l5u4V/Q/sS++B6kGyBZOR535KU1TWDZmwMMYCGp5O+FFLE
	 xxT0t0QsTYnsS3G12slf9EspLZLdWzI+D1IKJNiA5Ok00xFOxdhbVZLW89Y2V4ayrC
	 s6LOyYyFWPV1X0R6ewuA/oDLo2FfJdbws9raBUSysfLvEaus/W7wtlk2a0FesZFRN6
	 kOBAVKiwCZY3+W0BAdIR/QQna09maOGiFxgH8LqpSIgkIglLfQPn0ntPnjejywJycD
	 DaZ9+wwtk+XVvb6Ck559Q41rkc81kQE6wUEUTlTFiotHQyZSReT61+ZA3L/k3pLVDm
	 1FxU7Bt0z8Jqg==
Date: Tue, 15 Sep 2026 11:09:25 +0100
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
Subject: Re: [PATCH v2 17/21] objtool: decode instructions and resolve branch
 targets in parallel
Message-ID: <aqkR9Xqu-0Tem1zm@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-17-39817ec5db23@kernel.org>
 <202609141112.F8983EE9C@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609141112.F8983EE9C@keescook>

On Mon, Sep 14, 2026 at 11:20:37AM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:22:16AM +0100, Lorenzo Stoakes (ARM) wrote:
> > Threads are only created for objects with 8 MiB or more of text, meaning
> > that runs involving smaller objects remain unaffected.
> > [...]
> > objtool on vmlinux.o is on the serial tail of every build that links
> > vmlinux, no-op builds are unchanged.
>
> This isn't limited to vmlinux.o, though? With CONFIG_X86_KERNEL_IBT
> (default y on x86_64), delay-objtool is set in scripts/Makefile.lib, and
> objtool then runs on every multi-object module, in the middle of the
> parallel part of the build. In an x86_64 allmodconfig build here,
> amdgpu.o has 46.2 MiB of executable text and i915.o has 10.2 MiB, so
> each of those objtool runs gets 16 threads on top of the -jN jobs that
> are already running.

Ack, will fix in v3 to limit to only the --link run without --module, which
is how vmlinux.o is processed, leaves modules as they are.

>
> Any parallelism added need to be handled by the make jobserver, not
> hard-coded anyway.

I'm not sure that really gains us anything - at the point of doing the
vmlinux.o processing (which with the above change is all that is being done
now) everything's idle so the jobserver would just hand over the same 16
threads.

It'd need quite a bit of work to interact with it too with added complexity
+ some overhead so would have to check impact on perf here.

You did complain about added complexity also ;) if you insist I can try.

>
> > [...]
> > +/* Only an object this large, e.g. vmlinux.o, is decoded on several threads. */
> > +#define DECODE_THREADED_MIN_TEXT	SZ_8M
> > +/* Only decoding and the branch passes are threaded, so more gains nothing. */
> > +#define DECODE_MAX_THREADS		16
> > +#define DECODE_RANGES_PER_THREAD	4
>
> I just don't think a size-based approach is going to work. And any max
> parallelism needs a rationale.

A rationale was provided:

	Threading is limited to decoding and the jump pass, so the gain
	flattens out at 16 threads and any further threads were found to
	only add overhead.

	When performing an allmodconfig build, the clang invocation of
	objtool when processing vmlinux.o took 5.93s on 1 thread, 4.56s on
	8, 4.51s on 16 and 4.63s on 128.

Let me know what you feel was missing there? These things inevitably have
to be somewhat heuristic.

The size threshold is about paying for too many threads for no real gain,
and now (for v3) the code is limited to a --link operation only, that'll
only really stop a tinyconfig vmlinux.o :)

>
> > +static unsigned int decode_threads(unsigned long text_size)
> > +{
> > +	const long nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
> > +
> > +	if (text_size < DECODE_THREADED_MIN_TEXT || nr_cpus < 2)
> > +		return 1;
> > +
> > +	return min_t(unsigned int, nr_cpus, DECODE_MAX_THREADS);
> > +}
>
> No, anything using _SC_NPROCESSORS_ONLN internally is wrong, whether its
> pigz or objtool.

Why? We shouldn't cap a 4 CPU box to 4 CPUs?

The idea is that the empirically obtained 16 core limit should naturally be
capped to the number of CPUs.

I guess in a world where make hands jobs off this could be dropped, though,
if the complexity there seems worthwhile.

>
> > [...]
> > +static int add_jump_destinations(struct objtool_file *file)
> > +{
> > +	return run_insn_ranges(file, add_jump_destinations_range);
> > +}
>
> I haven't examined this myself yet, but my LLM doesn't like this,
> saying:
>
>   For an internal sibling call, add_jump_destination() calls
>   add_call_dest(file, insn, dest_sym, true), and add_call_dest() calls
>   annotate_call_site(), which for --hack-noinstr profiling calls, and for
>   __fentry__ calls with --mcount --mnop, does set_reloc_type() and
>   elf_write_insn() on file->elf. The per-range shadow gives each thread
>   its own lists, but the struct elf is shared, and both helpers write to
>   the section and mark it changed without any locking.
>   add_call_destinations() is kept serial because "annotating a call site
>   rewrites instructions the dead end walks read", so it looks like this
>   path needs the same care: a lock, or deferring those writes until the
>   threads have been joined. This is from reading the code; I haven't hit
>   a failure. Was the thread sanitizer run mentioned in the cover letter
>   done with those objtool options enabled?
>
> So, take it with a grain of salt. ;)

I mean sashiko is hallucinating at a rate >50% on this series, so pinches
of salt all round :) I do think frontier models with a good amount of
checking + e.g. Chris Mason's review-prompts are helpful to rein in stuff.

Anyway I had mine check it ;) and I also have a beefy threadripper sitting
around for bounding reality on this stuff and it all came back clean:

	Those writes go to the thread's own instruction bytes and its own
	relocation, the only shared state touched is the section and elf
	"changed" flags, which every writer sets to true, and the mcount
	case for a sibling call is a warning path. The v2 sanitizer run
	used the gcc allmodconfig options, which lack
	--mcount/--mnop/--cfi/--fineibt, so I reran it on the clang
	allmodconfig vmlinux.o with its full option set: zero reports, the
	jump pass included.

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
