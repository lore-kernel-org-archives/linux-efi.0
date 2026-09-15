Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337283C1090;
	Tue, 15 Sep 2026 14:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482656; cv=none; b=ErHIs0fpctOCYER1tEyoG9bOckpgLeTK1OuDHR3QXonGCMEIc5flL24PiE/WFTG9BDstLxw3N3FCxFAR0C0TndbHlVtMkt4T5tV4A0nO2XmDlmfUPyAE2gpNYMHM6MiW5JgYZql9I+cPLNgTaEf2faGgiup2Kw5zk0mVXzrby6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482656; c=relaxed/simple;
	bh=moIPUmoig2JAgKqAA6UrukBxyXWK3E849Xq6gng+scw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVv8ze4yORKlGr1hj9mmYZqa2lg4UN0zSEqf71uOdyRlidz7HOntZYie7JC60DmS6rON/XQJhzk+vsmJvFeBFHPc3myDhPn0MLw5yYuC0JgsWs37K0UDxt0QRECTvcsC5yEMm9Ty+2JprnSeCIqnKD54YDcm+I8afJm7EzM3498=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ExS+veNg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ExS+veNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75D01F000FF;
	Tue, 15 Sep 2026 14:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482654;
	bh=C8lwuOuhj9txlc80fCv3H4oifLhv4WSxNGb/qOtVudM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ExS+veNgBdz30FclQpYaSCTexz90mRkZ4TxP0L0gy1RFIR6zbpI4Dikj4vA4P/AXO
	 t/OeNJSnMmU40l2yi2IYcES7gZP7EQSHLVgAVDU85kj/8mL+llrLyBIfZS0WEp98qz
	 I4U7fawy4JaSj9S5OnGVb+wb//Agn/A0wpOa6phj0QtDBo5ywXKqv9zqMTN6TWNR4U
	 rsAfoE3JGOXAg1scCoJgia/HWwS8t8a+WJLjyr+sCr0S5GULThAMjvcA3cOsfFH0co
	 87e14KinXUO7LY8fcGAkmTAPBtlSakU1p1pRIwGhCIC38zvMGAqMmENgla+q9vrc7S
	 Fu6OaBPBfXB7g==
Date: Tue, 15 Sep 2026 15:30:43 +0100
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
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <aqk9gakQhxToLnDI@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609140844.FA7E848A@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202609140844.FA7E848A@keescook>

On Mon, Sep 14, 2026 at 09:39:07AM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:22:20AM +0100, Lorenzo Stoakes (ARM) wrote:
> > On a 128-core Threadripper, gzip -9 of a 36 MiB x86-64 vmlinux.bin takes
> > 1.6s, and with pigz it takes 0.09s, so the performance increase is
> > significant.
>
> Neat! I wanna go learn how pigz accomplishes this -- I thought the
> problem with gzip was a common lookup table. Anyway...

Yeah not sure on the details :)

>
> > --- a/Documentation/kbuild/reproducible-builds.rst
> > +++ b/Documentation/kbuild/reproducible-builds.rst
> > @@ -76,6 +76,22 @@ include generated files.  You should ensure the source tree is
> >  pristine by running ``make mrproper`` or ``git clean -d -f -x`` before
> >  building a source package.
> >
> > +Compression tools
> > +-----------------
> > +
> > +The compressed kernel image, compressed modules and packages are produced
> > +using the program named by the make variable ``KGZIP`` (described in
> > +Documentation/kbuild/kbuild.rst).
> > +
> > +It defaults to ``pigz`` if installed (a parallel implementation of gzip),
> > +or ``gzip`` otherwise.
> > +
> > +The generated output between two invocations of identical builds with
> > +either of the default tools will be byte-for-byte equivalent.
> > +
> > +However, for reproducible builds, ensure the same tool is used on all build
> > +hosts, as different tools may generate different output from one another.
> > +
> >  Module signing
> >  --------------
> >
>
> This doc update seems totally unneeded? Having the same build tools for RB
> is already a known requirement. I don't think anything new is added here?

Ack that's fair enough, will drop the doc update.

>
> > diff --git a/Makefile b/Makefile
> > index 790ef23c5e8a..38c0cdc9f591 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -561,7 +561,7 @@ PERL		= perl
> >  PYTHON3		= python3
> >  CHECK		= sparse
> >  BASH		= bash
> > -KGZIP		= gzip
> > +KGZIP		:= $(if $(shell command -v pigz 2>/dev/null),pigz,gzip)
>
> I think the more idiomatic way to do this is:
>
> KGZIP := $(call try-run,command -v pigz,pigz,gzip)

try-run is defined in scripts/Makefile.compiler which is only included ~200
lines after KGZIP is set.

That'll also set up and tear down a temp dir for a probe that doesn't need
that, so I think it's fine as it is.

>
> However, parallelism needs to be set. We can't let it eat all CPUs: it
> needs to respect the -j make option (and make its CPU reservation known
> to "make"), which we already have a solution for in
> scripts/jobserver-exec.

The only place where it's invoked is vmlinux.bin at the end of the serial
tail, where all the tokens would be free anyway.

So I don't think it really buys anything at all?

Using jobserver-exec would also put python3 and two wrapper scripts in
front of every gzip in the build including tar -I "$(KGZIP)" when packaging
and some arm and m68k scripts too.

(For the module zips it's already constrained to a single process.)

Overall I think it's less complexity and really no delta to just invoke it
as normal.

It's designed as drop-in so it makes sense to use it as that.

>
> However, I would actually argue that given such an improvement we should just
> make pigz explicitly required and not optional. It is packaged everywhere:
>
>   │ Debian / Ubuntu              │ ✅          │ pigz (main)
>   │ Fedora                       │ ✅          │ pigz 2.8 (current)
>   │ RHEL / CentOS / Rocky / Alma │ ✅ via EPEL │ pigz — not in base/AppStream
>   │ openSUSE / SLE               │ ✅          │ pigz
>   │ Arch Linux                   │ ✅          │ pigz (extra)
>   │ Alpine                       │ ✅          │ pigz
>   │ Gentoo                       │ ✅          │ app-arch/pigz 2.8
>
> Only RHEL appears a little glitchy, but likely they would trivially move
> it to base since it's already packaged, but off in EPEL.

Definitely not something for this series, the fallback is one invocation of
command -v and I don't really want to break RHEL either :)

If, once this has landed, we want to go that way then it's simple enough
for us to change it.

>
> So, I would say that pigz would be best run as something like:
>
>   KGZIP := $(PYTHON3) $(abs_srctree)/scripts/jobserver-exec $(abs_srctree)/scripts/parallel-pigz
>
> with scripts/parallel-pigz being something like:
>
> 	#!/bin/sh
> 	exec pigz -p ${PARALLELISM:-1} "$@"
>
> > --- a/scripts/Makefile.modinst
> > +++ b/scripts/Makefile.modinst
> > @@ -145,8 +145,10 @@ endif
> >  #
> >  # Compression
> >  #
> > +# Modules are compressed in parallel by make itself, so keep the compressor
> > +# single-threaded when it is pigz.
> >  quiet_cmd_gzip = GZIP    $@
> > -      cmd_gzip = $(KGZIP) -n -f $<
> > +      cmd_gzip = $(KGZIP) $(if $(filter pigz,$(notdir $(firstword $(KGZIP)))),-p 1) -n -f $<
> >  quiet_cmd_xz = XZ      $@
>
> Then this could be:
>
> 	cmd_gzip = SINGLE_THREADED=1 $(KGZIP) -n -f $<

This is already achieved for the modinst case with a one-liner in any case.

>
> and we patch scripts/jobserver-exec:
>
> diff --git a/scripts/jobserver-exec b/scripts/jobserver-exec
> index 21b319e6c9a5..8b953148ee9f 100755
> --- a/scripts/jobserver-exec
> +++ b/scripts/jobserver-exec
> @@ -5,6 +5,7 @@
>  Determines how many parallel tasks "make" is expecting, as it is
>  not exposed via any special variables, reserves them all, runs a subprocess
>  with PARALLELISM environment variable set, and releases the jobs back again.
> +If SINGLE_THREADED is set, nothing is reserved and PARALLELISM is 1.
>
>  See:
>      https://www.gnu.org/software/make/manual/html_node/POSIX-Jobserver.html#POSIX-Jobserver
> diff --git a/tools/lib/python/jobserver.py b/tools/lib/python/jobserver.py
> index 0b1ffdf9f7a3..fc38c5020b22 100755
> --- a/tools/lib/python/jobserver.py
> +++ b/tools/lib/python/jobserver.py
> @@ -29,6 +29,11 @@ $claim child to do the actual work.
>  The end goal here is to keep the total number of build tasks under the
>  limit established by the initial ``make -j$n_proc`` call.
>
> +Setting the ``SINGLE_THREADED`` environment variable skips the reservation
> +entirely and runs the command with ``PARALLELISM=1``. This is meant for callers
> +that run many short commands in parallel themselves, where each one should use
> +only the job slot it already holds.
> +
>  See:
>      https://www.gnu.org/software/make/manual/html_node/POSIX-Jobserver.html#POSIX-Jobserver
>  """
> @@ -68,6 +73,13 @@ class JobserverExec:
>          self.is_open = True  # We only try once
>          self.claim = None
>          #
> +        # SINGLE_THREADED asks for no reservation at all: the command runs
> +        # with PARALLELISM=1, using only the slot its caller already holds.
> +        #
> +        if os.environ.get('SINGLE_THREADED'):
> +            self.claim = 1
> +            return
> +        #
>          # Check the make flags for "--jobserver=R,W"
>          # Note that GNU Make has used --jobserver-fds and --jobserver-auth
>          # so this handles all of them.
>
> --
> Kees Cook

--
Cheers, Lorenzo
