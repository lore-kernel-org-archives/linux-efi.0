Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7414D3E6DD5;
	Fri, 11 Sep 2026 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789124868; cv=none; b=uRm4jzd2U7144+bYNKWidk62DCiTu7+TGx8s47DiuFnGc5r6Y1gwPxO60fZZ9sRyinW1/5mhmzQZDDWQffseclvnySh/5vbryheb91ovLeuveT9mr7QV/nu0Ed/urrwLcyg42zziFz7y5tgZgRXh4tuTbGGC+Z0bc1w+C0hhJds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789124868; c=relaxed/simple;
	bh=yO45x7AXLTj3WWFrgYQ+IwH22lfnqqSjC5quj1AL0xc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2l6Yt4C9QWTETqxtY6QgY+/XBk6MApzmdCEi7RfpeUsY5XiSMLW0TyJjRmSVWeweqZhEgtNfdtgOfEx6XjZsLI6oUv9jiipujd71W1QlirQyV8Urd+qjn+bhrEzpE9mhs88zDh/623fcRMjBLWNzVtVnkmTgeY1S+v6Kattx/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KlLFzFzT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KlLFzFzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EBE1F000FF;
	Fri, 11 Sep 2026 11:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789124866;
	bh=Z5R803ok1N64Ij6e5RkKmHntxHwo36WmfqVksyW2/68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KlLFzFzTtoiQED3sQ3DsMJCH+1mi0zd/dFk1bMVb+RZOLDMmx2idq+ShAlvvNCCGH
	 +4BH7qu/502qk53259LY2fT0Ymt0PhtfCi0ySB2n8UTySbJysyjNfPoTSVikixqJdb
	 nfrPg/4QBYca6OhlKFZ2PWNUxKx3ghY5pW6PNItyvaccebNyPSbZX4HuGLZ/lEqpz9
	 BzSWA4IhilFr0kezEwfkkFNkw315kBshFBPCuSPu+b/KEdPAkO5CJmOR/jtFftmmOS
	 j5Eab5IVrLiRyYdYzIk4KfGIcjrzE/+F84eslzHqRWdZgO+0xjUUeVyfVQkzlTLrln
	 77KDB1L9c/CNg==
Date: Fri, 11 Sep 2026 12:07:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: David Laight <david.laight.linux@gmail.com>
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
Subject: Re: [PATCH 04/23] kallsyms: output binary data to speed output and
 kallsyms assembly
Message-ID: <aqPgauP9sWKtWtc4@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-4-5dc1ac01672d@kernel.org>
 <20260910102903.1b211f6b@pumpkin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910102903.1b211f6b@pumpkin>

On Thu, Sep 10, 2026 at 10:29:03AM +0100, David Laight wrote:
> On Tue, 08 Sep 2026 21:55:04 +0100
> "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > kallsyms generates an assembly file that consists mostly of .byte entries
> > containing compressed names, token strings and name-sorted sequence
> > numbers.
> >
> > For an x86-64 build with 158k symbols that is a 37 MiB .S file which takes
> > 0.57s to assemble each of the two to three times it is built over a kernel
> > build.
> >
> > Each time it is generated it also takes kallsyms a similar amount of time
> > to output it.
> >
> > Avoid this overhead by instead outputting this data as binary and importing
> > it into the assembly using the .incbin directive.
> >
> > Tables that are wider than a byte remain part of the assembly to ensure
> > endianness and relative relocations are performed correctly.
> >
> > With this change, the output assembly file shrinks from 37 MiB to 9.8 MiB,
> > with a 2.6 MiB binary data file alongside it, and the object remains
> > identical.
> >
> > The generated binary file is deleted correctly on build clean along with
> > all other ephemeral data.
> >
> > On an x86-64 system with CONFIG_KALLSYMS_ALL set:
> >
> >                        before   after    delta
> >   scripts/kallsyms     0.24s    0.18s    0.06s
> >   assemble             0.57s    0.16s    0.41s
> >
> > Per kallsyms invocation/assembly, for a total of 0.47s time saving upon
> > invocation.
> >
> > An incremental build on the same system was reduced from 11.15s to 9.65s,
> > indicating a total of 1.5 seconds saved over the build.
> >
> > The kallsyms runs and their assembly are on the serial tail of every build
> > that links vmlinux, no-op builds are unchanged.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 defconfig, touch mm/vma.c, gcc       10.8s     9.9s    -0.92s (-8%)
> >   x86 defconfig, touch mm/vma.c, clang     10.7s     9.5s     -1.2s (-11%)
> >   x86 defconfig, clean, gcc                29.5s    28.7s    -0.81s (-3%)
> >   x86 defconfig, clean, clang              29.7s    28.6s     -1.1s (-4%)
> >   x86 allmodconfig, touch mm/vma.c, gcc    45.3s    44.0s     -1.3s (-3%)
> >   x86 allmodconfig, touch mm/vma.c, clang  42.9s    40.2s     -2.7s (-6%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  scripts/kallsyms.c      | 97 ++++++++++++++++++++++++++++++++++++++-----------
> >  scripts/link-vmlinux.sh |  2 +-
> >  2 files changed, 77 insertions(+), 22 deletions(-)
> >
> > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > index 350d118c3b9e..61c5eb537ed4 100644
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -5,7 +5,10 @@
> >   * This software may be used and distributed according to the terms
> >   * of the GNU General Public License, incorporated herein by reference.
> >   *
> > - * Usage: kallsyms [--all-symbols] in.map > out.S
> > + * Usage: kallsyms [--all-symbols] [--pc-relative] in.map out.bin > out.S
> > + *
> > + *      The byte tables go to out.bin and are pulled into out.S with .incbin;
> > + *  wider tables stay assembler source for endianness and relocations.
> >   *
> >   *      Table compression uses all the unused char codes on the symbols and
> >   *  maps these to the most used substrings (tokens). For instance, it might
> > @@ -102,7 +105,7 @@ static void sym_arr_free(struct sym_arr *arr)
> >
> >  static void usage(void)
> >  {
> > -	fprintf(stderr, "Usage: kallsyms [--all-symbols] in.map > out.S\n");
> > +	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--pc-relative] in.map out.bin > out.S\n");
> >  	exit(1);
> >  }
> >
> > @@ -319,6 +322,40 @@ static void output_label(const char *label)
> >  	printf("%s:\n", label);
> >  }
> >
> > +static void write_bin(FILE *file, const void *data, size_t len)
> > +{
> > +	if (fwrite(data, 1, len, file) == len)
> > +		return;
> > +
> > +	perror("kallsyms: write");
> > +	exit(EXIT_FAILURE);
> > +}
>
> It is pretty pointless checking the return value from fwrite().
> Most of the time it is just doing a memcpy().
> Instead call fflush() and the ferror() prior to the fclose().
> (Or just rely on fclose() giving you that error status.)

Ack, will fix up in v2.

>
> David

--
Cheers, Lorenzo
