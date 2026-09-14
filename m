Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8298741A91E;
	Mon, 14 Sep 2026 22:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424594; cv=none; b=UTcnC1gRCVhcBVyF/0Swyjth2jXdiImXWY57Cd8M8zWfecc2FgLrFYrmplwDi2w7A8TQYDINuPK8RGELwKt9kLPZCH2f9/5TSiqwzhyIKxKMMmBLxUbmVRyutK/dOcOntX2fFrTHL/lI8hO0FikFO9wIKZ6pO8xnfUsQZbG3hso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424594; c=relaxed/simple;
	bh=Bi89MHYHOLYWpNpNJwfRbRBytm+OSTO/mUdD0V17mFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryyRpnIITpjo09QcKhD3aZQXR3Lpn3wh2/UVELQIbwJBUQSxCdRvFojliE0sfhQEM78FGialjEPvXEu7H+rjv4098U1rOrk6lbSJ6FysDi91w+VN24faq6ezSHDWXLfSEx9o1LeLPld0CcqL3nwE6761XpdHKM8+U/jLk8JqZD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mhzzpIjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mhzzpIjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F201F00893;
	Mon, 14 Sep 2026 22:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424593;
	bh=RRU+yJML1OMM4sdrHKCW6nAyxyoRhK5ooyzt6zbz5EA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mhzzpIjt8ICc0v+9pwXJLGyUo6/4W86Z9Rd1H/nQJGbazdtLE1Dircqquu9iu2efd
	 FnFEeSd8Y2RIPZ43wFwVrX43cYp0Sv0pszmycH5HIWO/hHXzN2FQTBI+CgVh2fEhcA
	 cUizGTL1e5OKK9RyZcUuVM/i59uYEOlNvO23SwXcgW0vdOz7OPrXqcIdhhOxvIGRhW
	 LW1F5LwtIFv6MXdFHdRieN3hkXyESVONyHVUaDYgtKSVnwmy7eQOpON9jAxZSjHiQV
	 s+POBLypUYfj7pp2JnzJxWrCGyqwD5qAJWYkgMf0hOCyAO/85IzEZcyDiU9jgtmViX
	 DSFJ+F+2XszCA==
Date: Mon, 14 Sep 2026 15:23:09 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 15/21] objtool: cache relocations, do less work
Message-ID: <aqhmhmgrnN3Mw8yG@jpoimboe>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-15-39817ec5db23@kernel.org>
 <aqhLhVMkNzf_4oJw@jpoimboe>
 <CAHk-=wiB9MX7vBDQ+WHTUVfSYubLhR-PbABewscqTsxRhg-LbQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wiB9MX7vBDQ+WHTUVfSYubLhR-PbABewscqTsxRhg-LbQ@mail.gmail.com>

On Mon, Sep 14, 2026 at 01:06:37PM -0700, Linus Torvalds wrote:
> Talking about "getting rid of the hashing": the instruction hashing is
> obviously a big deal judging by the hash size expansion in that other
> patch.
> 
> Do we actually look up all instructions by hash in the first place?
> From a quick glance, it looks like almost every user of "find_insn()"
> is looking for just certain *kinds* of instructions: calls, branches,
> returns, endbr.  And branch targets.
> 
> Maybe stack updates? I didn't check.
> 
> Yet we seem to hash them all - even if they are just some random
> ALU-only instruction that is in the middle of a function and never a
> target of anything and has no impact on any code flow.
> 
> So the question becomes: do we actually need to hash those
> instructions at all? Are they ever actually looked up?
> 
> I don't know this codebase at all, so maybe that's just a really
> stupid question. Feel free to look at me condescendinly, shake your
> head and say "Poor Linus has lost the plot".
> 
> [ And yes, I see that whole "next_insn_same_sec()" thing, which
> obviously *does* look up all the instructions when you iterate over
> that function, but it strikes me that using a hash table for that is a
> bit strange when the natural way to do it would be with juyst a
> "struct instruction *next" field instead.. ]
> 
> So if hashing was such a big deal that it showed up clearly on
> profiles, maybe the answer isn't just a "make the hash table larger".
> If a "next" field were to not only make the hash table much smaller,
> but also mean that next_insn_same_{func,sec}() would become a "follow
> one pointer", mayeb hashing would become rather cheaper?
> 
> Stupid? Or maybe "not completely stupid, but too painful to change"?

The find_insn() in next_insn_same_sec() is a bit odd, that was itself
part of a performance optimization, but yes, a 'next' pointer could be
used instead.  Though, IIRC, that instruction struct is the biggest
overall user of memory, and it just barely fits inside a cache line
boundary, which we do take advantage of by putting them in adjacent
blocks.

But as you alluded to, find_insn() has a lot more users beyond just
next_insn_same_sec(), like finding jump targets, alternatives, annotated
instructions, and quite a bit more.  Determining in advance which subset
of instructions need to be hashed is likely somewhere between "too
painful to change" and "not feasible" IMO.

There might be more efficient ways to structure the considerable amount
of data, like replacing "struct instruction" with "struct basic_block"
or so, but it's hard to know whether that would be a net positive.

At least the current design is a somewhat tolerable balance of
CPU/memory usage and maintainability.  Peter and I already fixed most of
the major performance issues, so I'm not overly motivated to squeeze the
last remaining juice of performance, especially if it's going to hurt
maintainability (maintainer bandwidth is also a precious resource).

-- 
Josh
