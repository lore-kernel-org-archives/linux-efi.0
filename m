Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B663815DF;
	Sun, 13 Sep 2026 19:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789328046; cv=none; b=fi4tvDAVlkFeJe+fo046LJx99Q7eJ0/xGpTwEljMXRtz1uLcJypjZyW15qPBzoNjZkvg17jDQmlyoJ2D+BZ4USGYdQgaIsV3xZz8+eUrjsLVQLX+a0mWF5ch5ovFtFx0mfRyTjsvR5vd6kHaECMv54e5cOYJoafHdN/pFBtj/ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789328046; c=relaxed/simple;
	bh=ihRq8fDT4OZKIB9xCqYCafCIOXLGYHNnq0xU1QOg+dQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OXbM6Z4Ur7DeQLUjgJEZ6ByUZwBdbnYNZ1Wb2b2X1hHWiB+MEPj5rCBNeJAKWcKhhDb7yxv+Iq3iwxuuQURswzFT/71WrCK6gH+ZGA3Ipbzue2RKyfBwfNWjsqfgkV7aNRTo4CTlfCF/Qmnh54a/r8NAdCwnj6R+O38pAcSST/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=doV3JQJn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="doV3JQJn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1431F000FF;
	Sun, 13 Sep 2026 19:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789328044;
	bh=TAc05xvgn4LKDrgbz0GLZNdUmWjvRTBn7gzs88HyjCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=doV3JQJncRbnUY2eEWrDW4AdrECsCyPYHDG1VByES6rKjnzl81FXpw2DcYXgziOW/
	 nMJBkmNScb9f1ENw6Bjgf/a1No+jBwmIt2dT3iQevY1tZwlMrN6H5sFlHfvKs7tzfV
	 WJ3soUXFBJa89Fv6+4LRFkc2g4e/IiKpktf4IDbQe/o0+oXGLX8qdBKOZAnZ9xRO6N
	 LtOrIQ9Fl6Sma7vkpBWKyjpX/WlZO3pNnbeBWskijXbt/0ypclVD35UHKaKnVHeJVy
	 0B5OFfDlcjYZ3s+Gy/wRv99Wvu9JpCAFrKlh5/7HYFNVRMX6gnd392A6XiHgiMicFK
	 KCwPvRaRCG52g==
Date: Sun, 13 Sep 2026 20:33:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
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
Subject: Re: [PATCH 06/23] kbuild: only emit vmlinux relocations when required
Message-ID: <aqb6G026mVrnnDm8@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-6-5dc1ac01672d@kernel.org>
 <178901395291.3971858.16666031836463650276.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901395291.3971858.16666031836463650276.b4-review@b4>

On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
> > A kernel build consists of more than one linking pass on vmlinux.o and
> > vmlinux, at minimum two, and with CONFIG_KALLSYMS and BTF enabled on x86-64
> > for example there are 5 such stages.
> >
> > For architectures that build their own relocation tables (x86, riscv, mips,
> > s390), vmlinux is linked with the --emit-relocs parameter specified.
> >
> > However, this is only required on the final vmlinux link.
> >
> > Symbol tables of trial links preceding it don't need it because they
> > already check that System.map matches kallsyms symbols on each build.
> >
> > GNU ld is slow at emitting relocation tables, so this results in a
> > reduction in build time.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 defconfig, touch mm/vma.c, gcc        9.8s     9.4s    -0.43s (-4%)
> >   x86 defconfig, clean, gcc                28.6s    28.1s    -0.47s (-2%)
> >   x86 allmodconfig, touch mm/vma.c, gcc    44.0s    42.7s     -1.3s (-3%)
> >
> > Note that this has little impact on LLVM ld which performs this operation
> > more efficiently.
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > diff --git a/Makefile b/Makefile
> > index 9bd226726358..de095b11e20a 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1266,8 +1266,10 @@ LDFLAGS_vmlinux += --orphan-handling=$(CONFIG_LD_ORPHAN_WARN_LEVEL)
> >  endif
> >
> >  ifneq ($(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS),)
> > -LDFLAGS_vmlinux	+= --emit-relocs --discard-none
> > +LDFLAGS_vmlinux	+= --discard-none
> > +LDFLAGS_vmlinux_relocs := --emit-relocs
> >  endif
> > +export LDFLAGS_vmlinux_relocs
> >
> >  # Align the architecture of userspace programs with the kernel
> >  USERFLAGS_FROM_KERNEL := --target=%
> > diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
> > index fcae1e432d9a..4b54aaeca65d 100644
> > --- a/scripts/Makefile.vmlinux
> > +++ b/scripts/Makefile.vmlinux
> > @@ -64,7 +64,8 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
> >
> >  # Final link of vmlinux with optional arch pass after final link
> >  cmd_link_vmlinux =							\
> > -	$< "$(LD)" "$(KBUILD_LDFLAGS)" "$(LDFLAGS_vmlinux)" "$@";	\
> > +	$< "$(LD)" "$(KBUILD_LDFLAGS)" "$(LDFLAGS_vmlinux)" "$@"	\
> > +	   "$(LDFLAGS_vmlinux_relocs)";					\
> >  	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
> >
> >  targets += vmlinux.unstripped .vmlinux.export.o
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index 970ca10f8fa9..09c5222ccb94 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -32,6 +32,7 @@ LD="$1"
> >  KBUILD_LDFLAGS="$2"
> >  LDFLAGS_vmlinux="$3"
> >  VMLINUX="$4"
> > +LDFLAGS_vmlinux_relocs="$5"
> >
> >  is_enabled() {
> >  	grep -q "^$1=y" include/config/auto.conf
> > @@ -96,6 +97,11 @@ vmlinux_link()
> >  		ldflags="${ldflags} ${wl}--strip-debug"
> >  	fi
> >
> > +	# Only the final link actually requires the relocations.
> > +	if [ "${output}" = "${VMLINUX}" ] && [ -n "${LDFLAGS_vmlinux_relocs}" ]; then
> > +		ldflags="${ldflags} ${wl}${LDFLAGS_vmlinux_relocs}"
> > +	fi
> > +
>
> We don't use LDFLAGS_vmlinux_relocs anywhere else, so do we even need
> this whole dance to just end up with the equivalent of
>
>   if [ "${output}" = "${VMLINUX}" ] && is_enabled CONFIG_ARCH_VMLINUX_NEEDS_RELOCS; then
>     ldflags="${ldflags} ${wl}--emit-relocs"
>   fi
>
> which would make this diff much simpler?

Nice, big simplification then :) fixed up for v2.

>
> That being said, Sashiko makes a comment that may be relevant, have not
> verified though:
>
>   https://sashiko.dev/#/message/20260908-build-speedup-v1-6-5dc1ac01672d@kernel.org

Yeah checked and not relevant :) I cc'd you on my
mostly-for-my-own-record-keeping reply to sashiko on that one :)

>
> --
> Cheers,
> Nathan
>

--
Cheers, Lorenzo
