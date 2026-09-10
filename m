Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECDB46EC70;
	Thu, 10 Sep 2026 11:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038068; cv=none; b=oG/IZHWCKvGz98a3KXWYOFBt3QuKVrYbkqKUw5VBfPM5jgrguX3t8SngDe0T4eJIYm+JR2pu3nTm+G1DL+mWy9fCv6HbAsoeDTIDKqq5wcqJHtBTLLu78/cY84qX+fNihVije4fvOFrQBZ3itl0NX5j3pVphmMDEbvxrlxuIVPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038068; c=relaxed/simple;
	bh=6Co7N08x8n3BIPqRfu42DAPzb966GwJUI+PwIAmaJy8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u1cKB8Br1Snsv1Uey7DuS/6s/eRGVYClRoGzWFJCCIil7aa6oZ4PLCqbQgmTpyQ+AyubjTkA4BPbHWNZMiyduX87xSsj6CSMeOjbPeCNFDxbrxm5EALA6hvHWYD7AXOp5PXA/malKxJ+50aNHhjJ3JLOCe5zAWUn2uNpPXtenmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjHfMNbg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjHfMNbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A131F000FF;
	Thu, 10 Sep 2026 11:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038066;
	bh=Ysr1aeZRruTO/kwpd2zBCB/fNXGYRvMbwiFBQZsaXX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GjHfMNbgWtZXVVvy4yrx1x7YF9AP8Mkzu4MlbWX7VmxRm6mAWLc8LgSERp1bsM8Km
	 CnvTgQrePYoKl4p0NLebsW2NiVhAdO2zkErs2FPVzEm81ikhbTZNMlrI9O78VSSEY5
	 GB/+eamdB4pr4CorF7GtvDp7uxnZ1C2g/ftMtcUejQ1eyZZ62naguabdSTu+5r3f5G
	 HI55m9alQspSOEkxuPadAmKxLi7xNxDtZHogQEam3ZPw2SU0occeQ7t9wplr8R9SkV
	 99O4PaCwWfiABccklZHYAViUdHa6Mu8mwlM3lO8H9TioVDN1ifQAh6OHZg3NZhRsLV
	 f9GUdaQ6/6IpA==
Date: Thu, 10 Sep 2026 12:00:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <nsc@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
Subject: Re: [PATCH 01/23] scripts/mksysmap: drop the MODULE_INFO() symbols
 from kallsyms
Message-ID: <aqKN0cfGeb15X8pv@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-1-5dc1ac01672d@kernel.org>
 <178898323844.67740.9621915831851570155.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178898323844.67740.9621915831851570155.b4-review@b4>

On Wed, Sep 09, 2026 at 09:47:18PM +0200, Nicolas Schier wrote:
> > Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
> > keeps .modinfo symbols out of System.map and kallsyms, which assumes unique
> > IDs have a format like '__UNIQUE_ID_modinfo123'.
> >
> > However, commit afb026b6d35c ("compiler: Tweak __UNIQUE_ID() naming"), sent
> > in the same cycle, changes this to '__UNIQUE_ID_modinfo_123'.
> >
> > As a result this regexp has never matched and every kernel since v6.18 has
> > carried one kallsyms entries for every MODULE_INFO() declaration in the
> > kernel whether the modules are compiled or not.
> >
> > That's 5,810 entries for an x86 defconfig build and 15,200 for arm64.
> >
> > On x86 defconfig that is 113 KiB of kallsyms tables and 32 KiB of bzImage,
> > and every lookup walks past them.
> >
> > Fix the pattern.
> >
> > Fixes: 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
> >
> > No measurable change in build time, the smaller tables are not on any path
> > the build waits for.
> >
>
> For consistency, it would be nice to have the 'Fixes:' trailer at the
> beginning of the trailer block (that is: here.)

Yeah sorry my screw up when rejigging the commit message :)

>
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > diff --git a/scripts/mksysmap b/scripts/mksysmap
> > index c4531eacde20..56a8b8bbdb37 100755
> > --- a/scripts/mksysmap
> > +++ b/scripts/mksysmap
> > @@ -83,7 +83,7 @@
> >  / _SDA2_BASE_$/d
> >
> >  # MODULE_INFO()
> > -/ __UNIQUE_ID_modinfo[0-9]*$/d
> > +/ __UNIQUE_ID_modinfo_[0-9]*$/d
> >
> >  # ---------------------------------------------------------------------------
> >  # Ignored patterns
>
> Thanks!
>
> Reviewed-by: Nicolas Schier <nsc@kernel.org>

Thanks!

>
> --
> Nicolas
>

--
Cheers, Lorenzo
