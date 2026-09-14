Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090B940F73A;
	Mon, 14 Sep 2026 08:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375182; cv=none; b=E3roJ2IGx6w6AeGf6wYXQI3JKw0Z0J5dTp1ZLPFNDHrwtKLVfmNlhluF4X8+OK96+3xeVdfFFEgH4Ajjm+XXkw+21dQGJdzb/WvWfEkVsd9KDn/ugx4bsWranpnbo/G4CY5fiCOp+6qQn9zrxWu+CE2yaSBGTAAOB3Hulbl0iQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375182; c=relaxed/simple;
	bh=X9ccbuizLz1EysOH1zYI1yu3mvRakiZWz+1iAu+7FRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HBY8B7aN4zXDszQo9eBd3/uvnL5QyvVeHlRgazCfp+cltiEbDXMyz2x3rNHeX0TcquxLnxBh+E/hFUvZqILkbZ12VZC7T5vcUBqypwCLsphLGPoYzL9h43IJ4HsdwXv+dYQWRnvzW4AtslWBYM3Vk5xTczx3OnBm/QeGWCJOU34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtOnJVD8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtOnJVD8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878331F000FF;
	Mon, 14 Sep 2026 08:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789375177;
	bh=rS4XOBcUtwKENV4jM3ibNn5S3wPyCfS2oQz6c/8iiMM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UtOnJVD8WGecVcQv9j2Ub+bq38G6FEuXaCKAT7l2Hfy24vagwvUQdnPxGDsVz7d1P
	 JjzS1whi3pCkAXygpEOUYFHPSeEB3klfMHd64Mubo+KsZKx988BrA3ZQICNbW5y5SP
	 X39ue6vRPpVup5zhF1qk2ql5aas2CoScZOhCRhDyuLFjSzKpyhnTscAkBfsWSHHExh
	 DWzWtQ35DrzUEC8ggpJsO4SsR2jhwBym26MFS/Y/CD79YQSGr3nnL/g6iAQYXgBv9w
	 2pmxw3U69YIZe1sAYSu7BXe3qf9Ecl1yHkZRqPSgjurDfa/ASZzcBt4dpN1sNHwCfx
	 R+Km9B/45rCTQ==
Date: Mon, 14 Sep 2026 09:39:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
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
Message-ID: <aqewl-H-IzjIt8uD@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-4-5dc1ac01672d@kernel.org>
 <CAHk-=wgryL8XqjFcO=EQwKdqNn51BANiv16QiqYKCUdXxDQBmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgryL8XqjFcO=EQwKdqNn51BANiv16QiqYKCUdXxDQBmg@mail.gmail.com>

On Wed, Sep 09, 2026 at 07:35:16AM -0700, Linus Torvalds wrote:
> I'm finally going through this series, because I do care about build
> speed, so I love the concept.
>
> However, I haven't actually applied it and tried it, I'm just reading
> the patches.
>
> And this one triggered something:
>
> On Tue, 8 Sept 2026 at 13:56, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > kallsyms generates an assembly file that consists mostly of .byte entries
> > containing compressed names, token strings and name-sorted sequence
> > numbers.
> >
> > For an x86-64 build with 158k symbols that is a 37 MiB .S file which takes
> > 0.57s to assemble each of the two to three times it is built over a kernel
> > build.
>
> It strikes me that this is clearly a bit faster, but it still seems to
> be not really fixing the underlying silliness of that code.
>
> Wouldn't it be much better to actually create an object file directly?
> Afaik, the *only* think we ever do with that kallsyms-generated file
> is to immediately assemble it into an object file, because the actual
> asm file is useless to anybody.
>
> And we already require libelf as part of the build, and we already
> kind of do things like that with gendwarfksyms.
>
> Don't get my wrong: I think going through an asm file was very much
> the right thing originally: not every architecture used ELF in the
> first place, and when scripting things like this the current situation
> makes 100% sense.
>
> And no sane human wants to deal with this kind of grotty detail and
> spend the effort on writing an ELF file writer.
>
> But when there's a LLM that was used to find these things and help fix
> them up, and it's something this mechanical and the result really
> isn't ever human-readable and never has been, I feel like the obvious
> step would be to just ask the little helper bot to switch the whole
> kallsyms to using libelf-devel and writing an object file directly.
>
> I don't think anybody has any deep emotional ties to the current
> kallsyms code and that horrific step of the kernel build, do they?

No, but I wonder if it's really worth going all the way. And I did ask the LLM
about this too (of course :)

The way it works now there's still a bunch of .long offset entries in the
assembly which can actually be put into the binary file (the series generates a
binary file for the byte tables and includes using .incbin).

So mostly it's binary already.

If we tried to generate an ELF file directly there'd be complications (LLM says
e_flags and fun with arch-specific ABIs, plus arch's relocation type for
_text-relative base).

I don't think there'd be much of a win for the added complexity (and I am
nervous of fiddling with arch-specific stuff), BUT, can definitely put
those remaining .long entries in the binary too so the assembly is
absolutely minimal.

LLM says there's 200k of those, so does seem worthwhile, I'll do that for
v2!

>
>                Linus

--
Cheers, Lorenzo
