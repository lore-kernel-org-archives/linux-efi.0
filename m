Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6574EB84C;
	Thu, 17 Sep 2026 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666900; cv=none; b=X7kWeYGz3YgLoci7Kxer65Dhd9k40nAj1QBNiFpxFQHbrN11sjbfStV8e6/KYHpt7ognpEmoKoR0q3gV8JTbA+gvCxkAZS/cjX5sONbJoDIf4nSXM5XcOP8vVPaLm94kxNAjBiLxfT2WKMS72Yin0eX0DSd8SER3V1Gdq1jS0+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666900; c=relaxed/simple;
	bh=8U2+XmeG5Xq2jOoG1wwA14I9mRYbJ1aIXPTDRCZIMj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EM24pxh57wLYXBi8bKswO/zzwKHw5M1/MD3TkMnDrIPdlOnaKhRgy9bbSzKJK4bwjYuy0fatVdqR3GaWAVERrna/IXKXVi3NSSJ0QHDFIf21XPDO9rN8Gzfbyh9/7RXjj0BD0K+nD6O5NjF3+NKdyDRERBKYF4j7Dx7z3r81d4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WB36KjOw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WB36KjOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7202C1F00893;
	Thu, 17 Sep 2026 17:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666899;
	bh=vt7xldXW981Vs/3xttM71tth11TJJOnWXjFdN8oXwIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WB36KjOw/OL//N6jizHXsujpBTjNAWiAAoaPnfaeh/XOIirkqmGVTj/UH7olmLVri
	 GKKQQaqqIRE37gED19mdnpY+mDoOsgNbElRud0418CSQkGSF7mXE0BDc0b7WRjtSYs
	 4icfPjYTE9W1OI4NrzDPHN0M+jAgLG76KOhQ2ESZtKMON8MQvL3/O7xV9SCPakYhDw
	 O3jmy/4A1f3c20HNr0x08yqHyE2OZydqYtgvI53JK/ODOcIWr3wSqTnp5PPj/Jk2Zl
	 2oV1GJ3YELEFDXW6y73rX076iLwzGzB9BGV30bF0eZlFgY+AZOHFHV0HUISkJXQlV0
	 VPjicpdcQKK3w==
Date: Thu, 17 Sep 2026 18:41:23 +0100
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
Subject: Re: [PATCH v3 01/20] kbuild: do not allocate .modinfo in vmlinux
Message-ID: <aqwl59TrUqugElwk@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
 <202609170950.480F90A28@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609170950.480F90A28@keescook>

On Thu, Sep 17, 2026 at 09:52:32AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> > -# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
> > -# tools that expect vmlinux to have sufficiently aligned sections but the
> > -# additional bytes used for padding .modinfo to satisfy this requirement break
> > -# certain versions of kmod with
> > -#
> > -#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
> > -#
> > -# Strip the trailing padding bytes after extracting .modinfo to comply with
> > -# what kmod expects to parse.
>
> This comment still seems useful here (afaict the stripping is still
> happening with the "sed"). Maybe better to leave it, or future readers
> are left wondering what the sed is for?

Ack will restore!

>
> >  quiet_cmd_modules_builtin_modinfo = GEN     $@
> > -      cmd_modules_builtin_modinfo = $(cmd_objcopy); \
> > -                                    sed -i 's/\x00\+$$/\x00/g' $@; \
> > -                                    chmod -x $@
> > -
> > -OBJCOPYFLAGS_modules.builtin.modinfo := -j .modinfo -O binary
> > +      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< $@.tmp; \
> > +                                    rm -f $@.tmp; \
> > +                                    sed -i 's/\x00\+$$/\x00/g' $@
>
> Otherwise, looks good. With the comment back (or rewritten):
>
> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks!

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
