Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106DD3BE643;
	Tue, 15 Sep 2026 12:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475070; cv=none; b=a6OEZY3cmehSKuPeRmdt1fSHVbHAuBizUI6GXH/y4i+OxGcnaZWcAbSH+ee19sxbGp/B7+KV7PIIouRKQPxLZRf1oC9bcK4zUwuYzdGo5VA0zuaDvdbC6stiFtW83kCUDjyIHtf3EoktvlygCpFXrkTpt4hfF6HeWiEvkT6Fbh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475070; c=relaxed/simple;
	bh=TSFEmHMwC9d9SfXIP/P00kOktCoad+yxGsvpdbTiTwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QPdl4g5wm99CXD2gsFiBLO/gtJ4rXBqgtQTlhuRvYEuslN2KVP6d0HLVpTZ96uI2DRBcF4HkLwCjF1wDIe0tP2LttCio1J0pq0YaWe4J6LkSFAQIxP5vEan+azv8JwG2pJHCChfh4OiGpqFcBlbeIhBnmslIB+Td6R9cD7pyuEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VSaS7F8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VSaS7F8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965111F00893;
	Tue, 15 Sep 2026 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789475068;
	bh=oybH7eUIXKQPekIV7WrspdJ7cyHg8nnBvzsloGcaUcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VSaS7F8OJuNuEs3hoUYH76UztTiKslXOl7yAzD2g4gLjW+wKdODE4ANHrYphBLvcC
	 dGQy3ey9t5efNqzisI0bUxDeGSY5PMDK/ax9/0NQvgRzWjcV7F7EvSP2B/s6DK3yVq
	 LFk4eZeHY6yXs4Bdceq1zyCgKeMUHsFp59hbk5m8WeQ+Fb5DlCQHi/TGx8gXJTsZ5g
	 4PAd+0aC9GXETgFVdHQurW/S48n9SVPZKOb37fkbk6zWKNxSbX4MCdrWfrI+5lw5mV
	 ic86w///f180dvzmes95xRX+VFp+twm4uFnIt2UCdpXtQU6L7BYsK4DvAH5U2Nt83Z
	 YRdnbbuTH1zuw==
Date: Tue, 15 Sep 2026 13:24:17 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, 
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
Message-ID: <aqk4Oani0H0Wpxs1@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-15-39817ec5db23@kernel.org>
 <aqhLhVMkNzf_4oJw@jpoimboe>
 <CAHk-=wiB9MX7vBDQ+WHTUVfSYubLhR-PbABewscqTsxRhg-LbQ@mail.gmail.com>
 <aqhmhmgrnN3Mw8yG@jpoimboe>
 <CAHk-=wj3BKkCYtmfs5sORF_+Oumv2Gc8D+YxkMp9W2-mvLS=Ug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj3BKkCYtmfs5sORF_+Oumv2Gc8D+YxkMp9W2-mvLS=Ug@mail.gmail.com>

On Mon, Sep 14, 2026 at 03:30:19PM -0700, Linus Torvalds wrote:
> On Mon, 14 Sept 2026 at 15:23, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > There might be more efficient ways to structure the considerable amount
> > of data, like replacing "struct instruction" with "struct basic_block"
> > or so, but it's hard to know whether that would be a net positive.
>
> Yeah, I was thinking that you'd only hash instructions as you find
> them if they are obvious "I need this instruction", and then try to
> hash them *again* if they are branch targets (and just have a "already
> hashed" flag).
>
> That way random number instructions would not be on the hash - unless
> they become branch targets.
>
> And you wouldn't ever really have to track any complicated decisions
> (like that whole "basic block" thing - I agree that it's painful,
> because the shape of a basic block will change over time as you find
> branch targets).
>
> But not a big deal. More an idle thought brought on by that other
> patch that changed the hash table size, and this discussion that was
> talking about the hashing - or not hashing - of sections.
>
> So more of a "if it is easy and straightforward" kind of thing.

Obviously I defer to Josh on this, but it seems from what he said it's
probably a little involved and maybe tricky to figure out how much impact
it might have.

Anyway v3 drops the relocation hash altogether so 1 out of 2 ain't bad ;)

>
>              Linus

--
Cheers, Lorenzo
