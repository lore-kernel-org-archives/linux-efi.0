Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DFAC49B5C5;
	Mon, 14 Sep 2026 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789399496; cv=none; b=qXg1hoyTWZMLDPmGWUGAC5o82I3HUrXQnKSYixtpHPPzTb/zyAmJ6iX1Wck0AHm18s/dUTl79HdS3/HsGpB9n6C2mppXMM+1Y/NfVzOcEHwBCLfUjlde7eutABbT5wdFyqSR+DRprAiRD9qvjG/UXwzWzMJ8kPU1Z+3VPy/d3hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789399496; c=relaxed/simple;
	bh=jfKIlrnTmBvLbSkuzoW7nwMNniJMwOJsHByASfjaE18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXc0xh2RcYDd5bfQFuX2s5yepb0vle9QSTd3kGa+HjuhzDwtW4S+7BmBdED/ZsvocwbfYFjirKbse/apAwgYghbwgclv83Tue1+T9n1DGpjo/YBPaDyu16uQtNg3hdUYhnNv3moTRwBCzj2Zba9WHVUVLwPhkzPEFuy7MSYWvZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6by0sBS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6by0sBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D28771F000FF;
	Mon, 14 Sep 2026 15:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399495;
	bh=WL86cKdk/ZUM1qTOZj4B+L+bc1frQqDRCUlhlSxv/JQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D6by0sBSuPsWnPY/q+3+4xxuX6qvTRutko6G8MFgm2Cgx7icFf77LFko08xgOogFa
	 Q7hoHM9IO7d/MfeE/M35aFQUHhgNS8dCHhTb2vdRWWhepoRdkSG+3aIrGEpcO2uL1O
	 SGeyDR+u4PbiXRNjfxFaz4YYPqI/uqF6Q1hTc37azbSMl2Z+PG2xV7V/wVVpLW1+5N
	 jKCFeGb0EYtA5i/SCA7hk6dbkuVRO9cq3VEyZas+X47IL8Eijo12e4khM0fl5mUJV2
	 Hg+16wB7QyUOYfGnlM4ppjr1ZK+lmVnEEdNmQ/oqGVaJ3hUpBtr7eI85g02Pn16I33
	 zLHsGFg95m+vg==
Date: Mon, 14 Sep 2026 16:24:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: John Stoffel <john@stoffel.org>
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
	Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 11/21] kbuild: avoid re-running compiler and linker
 probes
Message-ID: <aqgRXk6DXyAah488@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-11-39817ec5db23@kernel.org>
 <27304.3198.867048.379684@quad.stoffel.home>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27304.3198.867048.379684@quad.stoffel.home>

On Mon, Sep 14, 2026 at 11:02:22AM -0400, John Stoffel wrote:
> >>>>> "Lorenzo" == Lorenzo Stoakes (ARM) <ljs@kernel.org> writes:
>
> > Each kernel make invocation begins with ~30 compiler and linker runs each
> > of which performs duplicate probe for a number of compiler and linker
> > options.
>
> > This is useless work - the compiler and its version is known, so use these
> > to determine which options are available, once.
>
> > A convention already exists for this - CC_HAS_xxx, LD_HAS_xxx in Kconfig
> > files (for example, CC_HAS_COUNTED_BY), so convert these probes to Kconfig
> > options where appropriate.
>
> > This change avoids a sublte issue with ppc32 (big endian) - clang doesn't
>                        ^^^^^^
>
> subtle

Oops!

I love that I ran this through AI review several times and it missed
something as simple as this :)

>
> > accept -fno-stack-clash-protection on this sub-target, so keep this option
> > in the Makefile.
>
> > With gcc and clang, defconfig and allmodconfig, the recorded command
> > lines are unchanged, a build with nothing to do rebuilds nothing and W=1
> > continues to function correctly.
>
> > Doing this improves all builds, but has a particularly positive impact on
> > no-op builds (builds where nothing has changed).
>
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
>
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 defconfig, no-op make, gcc           0.78s    0.60s    -0.18s (-23%)
> >   x86 defconfig, no-op make, clang         0.94s    0.66s    -0.28s (-30%)
> >   x86 defconfig, touch mm/vma.c, gcc        8.6s     8.5s    -0.16s (-2%)
> >   x86 defconfig, touch mm/vma.c, clang      8.0s     7.7s    -0.24s (-3%)
> >   x86 defconfig, clean, clang              29.8s    29.4s    -0.37s (-1%)
> >   x86 allmodconfig, no-op make, gcc        12.9s    12.7s    -0.23s (-2%)
> >   x86 allmodconfig, no-op make, clang      14.2s    13.9s    -0.29s (-2%)
> >   x86 allmodconfig, touch mm/vma.c, clang  32.2s    31.9s    -0.30s (-1%)
>
> Are these deltas just per-patch, but cumulative with all the previous
> patches applied?
>

Per-patch. I let the threadripper do builds for a LONG time to accumulate
these... :)

--
Cheers, Lorenzo
