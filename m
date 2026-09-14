Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FF414A04;
	Mon, 14 Sep 2026 08:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375838; cv=none; b=ntzRW4Y6MWfoOu4IfRn1hsBAxMLMy3TgeQj48olc8bS/gW5m4vpohoc1U6IjeVWNa8iAz4FvebOmlSqdExZZIQ1+MeEdN3xiLs6y//drk2CZm1udwehQ8GJMIGoVkW5c6Yds5kBS8hW2DraAdpFFh2dH7UR7PlAmP1gFN5Nv1S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375838; c=relaxed/simple;
	bh=/u1qpryDeZotR+AT2iPJ0qVJkaD0raKfBVzdpKLDnD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K1O4HazgQUs4AwDtJ+PCv+vxq2r6ox4Durmz14jFmWXNza3Eu0rD8g8pHKDX0DlebxAgBhfTIYX/OVzthj7Reg6ibYo6oezfjqffVZywFvOGkZBu43E34pCdvMeTSjdMztkiAcdTTAO/4s+NCeEwujOcERRLqJclow5KB6lg9zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7qapl7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7qapl7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844EC1F000FF;
	Mon, 14 Sep 2026 08:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789375827;
	bh=s7W/8xfx4osCl1Lc1GlKuxehRNgyA75NRBODMykdTPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J7qapl7YifCtTZdFcUZQU9IeKXjVmBkaQ9VjtULcBcQ3RaKbhWU8JAaiQmRqkdKKm
	 hqNf/9i3Dc4WzbUGIwhIePIDrDiySXRqXaG9pDOa+Hjyro3tEi4yaiiWGyS812WGyN
	 b2EQCnqmlNwudXTOYhCJaPCol03915fFzPYC9k/LCVFBS1hX0XDyZhzdE/0OU4LV5b
	 MB6GAYavpCzkyXPq7VAxXdC+qeojwd/PSMXzVevVGvmp6HLnmbpc6nR6haGOQ7/E2P
	 wC57EkSpIYiaeCGBBLgNDwkxVavc3YG1gdS5om9OysKadezOtX3E20Jaot9TwwSy6J
	 kB3FsBhHPVy5g==
Date: Mon, 14 Sep 2026 09:50:15 +0100
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
Subject: Re: [PATCH 15/23] modpost: emit module descriptors as assembly
Message-ID: <aqe0WGxQXUyFT_9Q@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-15-5dc1ac01672d@kernel.org>
 <CAHk-=wgAWpVHmR74jC7sbSJGQEHyaaN0awNfSz_SjPv3VGSYYA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgAWpVHmR74jC7sbSJGQEHyaaN0awNfSz_SjPv3VGSYYA@mail.gmail.com>

On Wed, Sep 09, 2026 at 07:59:55AM -0700, Linus Torvalds wrote:
> On Tue, 8 Sept 2026 at 13:58, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > modpost generates a descriptor for every module in the form of a
> > <module>.mod.c file with .modinfo strings, the __this_module descriptor,
> > exported symbol tables and (with CONFIG_MODVERSIONS set), the CRC of
> > imported symbols.
> >
> > These files are compiled like any other kernel C file with all of the
> > -include preamble, as well as including linux/module.h, header dependencies
> > generated by fixdep of a few hundred headers, an objtool run and if LTO is
> > being performed, a link is performed to generate native code.
>
> This kind of triggers the same reaction as the kallsyms code: I think
> not including <linux/module.h> is probably the biggest win in this
> all, and precomputing the offsets of the (few) structures that modpost
> uses then makes the whole end result fairly trivial in raw asm.

Right indeed :)

>
> Fine.
>
> BUT.
>
> You end up with things like this instead:
>
> > diff --git a/scripts/mod/module-offsets.c b/scripts/mod/module-offsets.c
>
> where it generates a header file for those asm scripts so that the asm
> generation can do things like
>
>         buf_printf(buf, "\t.size __this_module, %d\n",
> MOD_SIZEOF_struct_module);
>
> etc.
>
> But I - again - get the feeling that this is all going through AS as a
> silly way to generate an object file, and that there really isn't any
> obvious advantage to that side quest.

Well it seems the biggest advantage in doing assembly over directly
manipulating an object file is that you avoid any arch-specific nonsense,
as with kallsyms.

>
> Becuase no human ever wants to see that asm file, and it's no more
> legible than generating the object file directly would have been.
>
> So I get the feeling that it would again be more natural to just
> generate the object file directly when all those files really end up
> being are a few symbol definitions and a couple of fixed structures
> (is there anything but the magic "__this_module" thing and the modinfo
> unique ID thing?)
>
> And again - I feel like nobody sane would want to write that code. I
> certainly don't. But if this was at least partly automated anyway,
> going that extra step might not be all that horrific.
>
> I'll also be honest: part of why I do these suggestions is that I do
> think it would be faster to skip the intermediate assembler step, but
> a big part of it is that I don't love the random turds our build
> creates. Getting rid of the *.mod.c files would be a cleanup of our
> strange build.

Well the *.mod.c turds are flushed already, but replaced with smaller
*.mod.S ones instead :)

The LLM says the time taken per assembler step is ~7.5ms per .mod.S which
is .65s of wall time on the threadripper so it terms of a build it's into
the noise territory at least for a bigger box (plus obviously you won't go
to _zero_ cost by writing the object file directly).

Overall I think it's not _currently_ worth it as part of this work, but
it's something I can set the LLM on as a follow-up maybe? Could do a
'eliminate build artifacts' pass in general.


>
>              Linus

--
Cheers, Lorenzo
