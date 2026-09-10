Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BF33C10B0;
	Thu, 10 Sep 2026 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038004; cv=none; b=YC8KIBB/4Oe8Cbtx0uPDjFCJRv6eSO4YSwtvCjJZtJ05lHNFnzCgAGI958nXy91EVT7maxRNqm5bEh7RMULJ7eoJpZdw+gbsRhw3oxItlFGTdQLMTKeBApipf2g4iPyt00RBX1/jDFsHvEM+9Ru3nDFsKATGtVh61Nb+u61MWVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038004; c=relaxed/simple;
	bh=jqL0GtlTc/rqKOGoRk1Zi8UVUamCx++PEdF2Dryjl4g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PN0sF+EQsWKqN2n9jE7mVQaVQyz0EAfQynqguqd20Oyx5PxNLYKMa7WGEoSLJFw6ceTknFCIo0cxxRbXZyMfdv4sf15LSPJMxb53DVWtivC7hR/5o+U2vtmm1BGRTuY05Jc8TMpz5LscbJCSUUNu0oiZNfdPnPtuOWnUpYoETWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBG2Xis6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBG2Xis6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6E31F00898;
	Thu, 10 Sep 2026 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038003;
	bh=rH49KjocGWRkJ+AZJQhcm2lj6KEBkusUet19acjfj5c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XBG2Xis6aC2x/TFiRhgODNHYxMsm9AepijpQMJLiqGJS2lxSLsxOf+CTbdiEH9Fg7
	 WR7MjDDhyRRBUsOFpbxeN9nm4odVyTHdNN2h+M+AOb8VZsSMhCIMfBNtqb9j7yhu9F
	 9E80Yd1DWtWvPL6hdktW9e+aJ2MKlEz3IxuD82KF3or9xnpT5GRh28m13ae5AzDEdK
	 GTqk0D/qMhaSfCzPZ3Hq7mA6hZajZ8baL4mU1jblluQrILkPVl0XG54BRP+o8PpLFb
	 bQvtujHLityCH1kc2rr1NQxKpn+fgba64Qzq43EdmJc41t6NlWX1VyB1G1BN+80GJ1
	 G6CWH17PIcZJQ==
Date: Thu, 10 Sep 2026 11:59:48 +0100
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
Subject: Re: [PATCH 09/23] kbuild: do not allocate .modinfo in vmlinux
Message-ID: <aqKNKBt2RX-cFKtP@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-9-5dc1ac01672d@kernel.org>
 <178901395291.3971858.229822965899686230.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901395291.3971858.229822965899686230.b4-review@b4>

On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
> > Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
> > placed MODULE_INFO() strings in the .modinfo section in vmlinux.unstripped,
> > however it left the section allocatable, so it gets assigned an address and
> > on arm64, arm and riscv, the section is tagged as PT_LOAD.
> >
> > This is useless as the data is ultimately stripped anyway.
> >
> > Doing this results in a lot of unnecessary work - each pass copies the
> > whole file, 450 MIB with relocations for an x86 allmodconfig build and 250
> > MiB for an arm64 allmodconfig build.
> >
> > This adds ~0.7s on the serial tail of every build for arm64 and ~0.2s for
> > x86 (the tail is single-threaded work done after parallel work has
> > finished).
> >
> > Nothing requires .modinfo to exist at an address, so fix this by using
> > --dump-section which prevents the allocation.
> >
> > Image, bzImage, System.map and modules.builtin.modinfo are unchanged and
> > the stripped vmlinux differs only in its program headers.
> >
> > The objcopy passes are on the serial tail of every build that links
> > vmlinux, no-op builds are unchanged.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 defconfig, touch mm/vma.c, gcc        8.9s     8.8s    -0.16s (-2%)
> >   x86 defconfig, touch mm/vma.c, clang      8.1s     7.9s    -0.20s (-2%)
> >   x86 defconfig, clean, gcc                27.6s    27.5s    -0.13s (0%)
> >   x86 defconfig, clean, clang              27.2s    27.0s    -0.18s (-1%)
> >   x86 allmodconfig, touch mm/vma.c, gcc    42.0s    41.6s    -0.40s (-1%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> > index b2988aa12f66..7be9e0321867 100644
> > --- a/include/asm-generic/vmlinux.lds.h
> > +++ b/include/asm-generic/vmlinux.lds.h
> > @@ -855,7 +855,7 @@
> >  		KLP_SYMID
> >
> >  #define MODINFO								\
> > -		.modinfo : { *(.modinfo) . = ALIGN(8); }
> > +		.modinfo (INFO) : { *(.modinfo) . = ALIGN(8); }
> >
> >  #ifdef CONFIG_GENERIC_BUG
> >  #define BUG_TABLE							\
> > diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
> > index 4b54aaeca65d..1fc7a0ca8eaf 100644
> > --- a/scripts/Makefile.vmlinux
> > +++ b/scripts/Makefile.vmlinux
> > @@ -90,11 +90,9 @@ remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel.*'
> >
> >  remove-symbols := -w --strip-unneeded-symbol='__mod_device_table__*'
> >
> > -# To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
> > -# it is necessary to remove the PT_LOAD flag from the segment.
> > +# none of the removed sections is allocated, so no segment is left empty
>
> I think we could just drop this comment, I don't think it is
> particularly helpful

Ack!

>
> >  quiet_cmd_strip_relocs = OBJCOPY $@
> > -      cmd_strip_relocs = $(OBJCOPY) $(patsubst %,--set-section-flags %=noload,$(remove-section-y)) $< $@; \
> > -                         $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $@
> > +      cmd_strip_relocs = $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $< $@
> >
> >  targets += vmlinux
> >  vmlinux: vmlinux.unstripped FORCE
> > @@ -103,21 +101,11 @@ vmlinux: vmlinux.unstripped FORCE
> >  # modules.builtin.modinfo
> >  # ---------------------------------------------------------------------------
> >
> > -# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
> > -# tools that expect vmlinux to have sufficiently aligned sections but the
> > -# additional bytes used for padding .modinfo to satisfy this requirement break
> > -# certain versions of kmod with
> > -#
> > -#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
> > -#
> > -# Strip the trailing padding bytes after extracting .modinfo to comply with
> > -# what kmod expects to parse.
> > +# use --dump-section to include non-allocated sections
>
> Same thing here, I am not sure anyone will question '--dump-section'
> here. Otherwise, this seems reasonable. I was curious about the $@.tmp
> until I read the objcopy manual but that probably is not worth a
> comment.

Ack too.

>
> I can probably take this one faster than the rest if you want to put it
> early in the stack since it is pretty low hanging fruit and earlier it
> gets exposure to -next, the better.

Sure sounds good, the sooner we get these in -next the better.

I was planning to go through feedback/sashiko (+ give a bit more time for people
to respond) before doing a v2, but I guess you could put this to -next as-is,
given v2 will just be stripping comments here (as it stands anyway!)

>
> --
> Cheers,
> Nathan
>

--
Cheers, Lorenzo
