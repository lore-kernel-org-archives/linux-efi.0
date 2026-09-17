Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AED6503910;
	Thu, 17 Sep 2026 17:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667340; cv=none; b=J5VDhes3XaBg6tWUEUnXZO803DWDUzYU2kgxFDfRmLWt38wCNZPFWwjshlrCXPwJ6/t0wjrUcUxuDIkODcAmeOewEmcyQaQ71eZkvyzXhwRJLRjHmupeF8DJxR3J6l79aPOlCUZNWXXCsTbpIzU4/hsRF6Pv0Pi7sLQl3l5d0N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667340; c=relaxed/simple;
	bh=b00Vorfeep9JHiSxxxh7OqOFdTYydUaD3AcYG3JSQ0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JP/cdtY/82/sHdE2T0BHeJKkWf7B0xigm/dZRWSnKH1FpupwF+ko525dI5PFzAGxvWM0KO0HumXoPVvVm0JBQrDAW+u1nHODMlrEstX+SF+zMdGyUrwMCQDGJ2vEMt2imeCTih/YMsACaupNkR1tWpViHEO3BW09MhrxkAn99MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eD0v9cqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eD0v9cqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532FE1F00893;
	Thu, 17 Sep 2026 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789667338;
	bh=cLEPRaYpBPlArN2n02K1AD2Rlu0XR0AJhYbLviaj3qM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eD0v9cqdgBAUzVJbc7kjrlV3qCR0kIq2aRz9aYFnLytwcEsSYKq8AluHxvetYtYbi
	 7A6jDrDOhHLKiWdG/zGXUSUrGGkmq+2NIdJAoBC2vo5dyhN1GmVOMBkqW/TPCnu09T
	 plevC+hdjuYu0ZTywktA34FPhUC0ZkyRHQilYNmJKdi01T+gMm7Twyn6vHwCwevFb6
	 DHdLJMHYPF08eGJb8lwsYjrxI+26lBYj0DabQZJg1vueFR/rhEtITeWNNSCYgkbGci
	 pS1y+BJjp4iJElZdF0b2xnd9QHQ60hebn+u/fyQRTVmo1T8bOtLHQas6z1jrLhmj07
	 Iu0V34hWVATXA==
Date: Thu, 17 Sep 2026 18:48:43 +0100
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
Subject: Re: [PATCH v3 05/20] kbuild: only emit vmlinux relocations when
 required
Message-ID: <aqwnmGawAQWDI25v@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-5-9ecf4163ff36@kernel.org>
 <202609171039.A9B14A02A@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609171039.A9B14A02A@keescook>

On Thu, Sep 17, 2026 at 10:41:50AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:15PM +0100, Lorenzo Stoakes (ARM) wrote:
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
> >   x86 defconfig, touch mm/vma.c, gcc        9.5s     9.1s    -0.42s (-4%)
> >   x86 defconfig, clean, gcc                30.1s    29.5s    -0.59s (-2%)
> >   x86 allmodconfig, touch mm/vma.c, gcc    37.2s    35.8s     -1.4s (-4%)
> >
> > Note that this has little impact on LLVM ld which performs this operation
> > more efficiently.
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  Makefile                | 2 +-
> >  scripts/link-vmlinux.sh | 5 +++++
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 0f1b80100b47..dd4c10afbb7f 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1263,7 +1263,7 @@ LDFLAGS_vmlinux += --orphan-handling=$(CONFIG_LD_ORPHAN_WARN_LEVEL)
> >  endif
> >
> >  ifneq ($(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS),)
> > -LDFLAGS_vmlinux	+= --emit-relocs --discard-none
> > +LDFLAGS_vmlinux	+= --discard-none
> >  endif
>
> Nit: I think a comment here is worth adding, like in link-vmlinux.sh.
> They're separate files, and it's kind of weird that ...NEEDS_RELOCS
> doesn't actually add --emit-relocs here unless you go find how
> --emit-relocs is used later.

Ack will add!

>
> >
> >  # Align the architecture of userspace programs with the kernel
> > diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> > index 970ca10f8fa9..ed5ff97c0667 100755
> > --- a/scripts/link-vmlinux.sh
> > +++ b/scripts/link-vmlinux.sh
> > @@ -96,6 +96,11 @@ vmlinux_link()
> >  		ldflags="${ldflags} ${wl}--strip-debug"
> >  	fi
> >
> > +	# Only the final link actually requires the relocations.
> > +	if [ "${output}" = "${VMLINUX}" ] && is_enabled CONFIG_ARCH_VMLINUX_NEEDS_RELOCS; then
> > +		ldflags="${ldflags} ${wl}--emit-relocs"
> > +	fi
> > +
> >  	if [ -n "${generate_map}" ];  then
> >  		ldflags="${ldflags} ${wl}-Map=vmlinux.map"
> >  	fi
>
> But yeah, otherwise, another "don't generate something that doesn't get
> used" improvement. :)

Yes :) it's funny how simple a lot of these changes are

- Don't do work you don't need to
- Cache stuff so you don't have to look it up again (a variant on the first
  one)
- Do other work at the same time

>
> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks!

>
> --
> Kees Cook

--
Cheers, Lorenzo
