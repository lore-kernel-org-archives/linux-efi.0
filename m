Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9115478859;
	Tue, 22 Sep 2026 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790067976; cv=none; b=jR7aQk2jrCWJa0+lYQY/Zm12J53fxWgf6QM/bXOXMGCPNWcO6F+yhEYIKP0ZVsBwnbKK1UgajBnVyVyVihuMr/hiTabMIIwifPY0LZlkhDmDvBeAK9oLLH9Q3bpSC6XdPTdfu4PqyCWWgREPxvsdP3GZfDWsje6kY5VfBxFnmAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790067976; c=relaxed/simple;
	bh=EioVh31ovcIoXKm70lu2jzPBUC1Ew7mE2jaz8o7SFLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABShdFIzavEkLw0cWsL2gDNwdIV3T9SghMAsLr8avWVIcvsP90nCS0hkJdD5I30jdLfv36EjqSHX86PFhxBo4RjyyIw6yD0bM6HH3pD/CM6Ho8b9DUkvKkCMu5R2mHJ1VnuNsPEH+b48vbk11FiUfza6KX7FOlO1au3KwAs/lgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGdwsJa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGdwsJa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069B31F000FF;
	Tue, 22 Sep 2026 09:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790067974;
	bh=CL9p8oAwo1crfQMWT3WgokRQnTrKkgMRfNiucR/BKyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FGdwsJa8/IRiDiXqu5im9UYEKsBW8xKPj8UeyC1zG50ICzIqoaS4sBV5uWR6ySljY
	 Wz1QwM7ElBxL98PaNnSCTjPhanEq8KXo+IkM7KxVyNgGKUB1r0GFZvHtEhtSofBU5c
	 4VTIrdtA6vzaIUg8etnNBBES2NLReY7mu8Xdo3wUU039vDzRbQBsxcv06PHQfhmuUd
	 Gz1UmGbN9kIDO7bpH2UzpB2zlu20T3+GJqJbBP4ibpnSmxA97SOaRunJBW3uINc6Ts
	 ajL0SgRxi2ONttf0op7dKynauL25bY890dZT7JNNwz06ehY0EDaZ+7z7MlqJ/FhK1i
	 VoPZDvngT8CnQ==
Date: Tue, 22 Sep 2026 10:05:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
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
Subject: Re: [PATCH v3 15/20] objtool: cache relocations, do less work,
 eliminate relocation hash
Message-ID: <arI0sqCSIJKjbu0C@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-15-9ecf4163ff36@kernel.org>
 <arG07kfxJCmnVPY4@jpoimboe>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arG07kfxJCmnVPY4@jpoimboe>

On Mon, Sep 21, 2026 at 09:16:21PM -0700, Josh Poimboeuf wrote:
> On Thu, Sep 17, 2026 at 05:06:25PM +0100, Lorenzo Stoakes (ARM) wrote:
> > This relies upon the entries within a section being sorted, which is the
> > case for all sections supplied to objtool by the link step during the
> > kernel build.
>
> This is wrong (or at least actively misleading).  Objtool doesn't *only*
> run on linked objects.  In some configs it runs on individual .o files.
> And GCC doesn't sort relocs:
>
>   Relocation section '.rela.text' at offset 0xc0d0 contains 724 entries:
>       Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
>       ...
>   0000000000005c50  0000009000000004 R_X86_64_PLT32         0000000000000000 _raw_spin_lock - 4
>   0000000000005c65  0000009100000004 R_X86_64_PLT32         0000000000000000 _raw_spin_unlock - 4
>   0000000000005c6d  0000019f00000004 R_X86_64_PLT32         0000000000000000 put_files_struct - 4
>   000000000000004d  0000008f00000004 R_X86_64_PLT32         0000000000000000 __x86_return_thunk - 4
>   0000000000000075  0000008f00000004 R_X86_64_PLT32         0000000000000000 __x86_return_thunk - 4
>   00000000000000cd  0000008f00000004 R_X86_64_PLT32         0000000000000000 __x86_return_thunk - 4
>
> (JMP target relocations are emitted in a second pass, for whatever
> reason)
>
> So the hash may actually be needed as a fallback after all.  Or some
> other scheme.

Ack, that's fair enough.

Definitely need something that isn't the linear scan as a truly worst case can
be horrible.

I think the hash can be avoided though, Do the read_relocs() without ordering,
track whether things are in order, on decode if sorted then just read from
relocs[], if not can allocate an order[] array and qsort() and build the index
over that.

So O(n lg n) at that point, but avoids bothering to sort for anything not looked
up, works similarly for added sections.

So still avoids all of the hash stuff, but efficient when things are actually
out of order.

>
> Either way it's overkill to have more than a single fallback.  No second
> fallback for "just in case".  Attempting to search an unhashed section
> (DWARF) can just be a fatal error instead of the "just in case"
> WARN+linear fallback thing.

Honestly this is what I instinctively preferred, but objtool is not my realm so
I worried there'd be some odd outlier thing that it'd somehow break!

>
> > @@ -1168,19 +1286,26 @@ static int read_relocs(struct elf *elf)
> >  				return -1;
> >  			}
> >
> > -			elf_hash_add(reloc, &reloc->hash, reloc_hash(reloc));
> >  			set_sym_next_reloc(reloc, sym->relocs);
> >  			sym->relocs = reloc;
> >
> >  			nr_reloc++;
> >  		}
> >  		max_reloc = max(max_reloc, nr_reloc);
> > +
> > +		/* DWARF relocs are never looked up, so are not worth indexing. */
> > +		if (is_dwarf_section(rsec->base))
> > +			continue;
>
> This DWARF reloc skipping is a standalone improvement, can you split
> this out to another patch?

Ack will do!

>
> --
> Josh

--
Cheers, Lorenzo
