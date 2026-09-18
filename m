Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6B545D908;
	Fri, 18 Sep 2026 05:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789710074; cv=none; b=GBV96ukPQaQ532ioWlYAtOAw2Mmg7g7p6zVrFGIoFf453s9vgKt+IwtHAQFMJ37NqnL53gnIP2gZhFTtHyRmzjW3dOUI4zSA/3vgP9nX4GGs6iorIaXaKPE3fTPgV+eO0sKI56dDx3swfaoOVL8zU3F/xtRjg6Qe1wEzaoQJlbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789710074; c=relaxed/simple;
	bh=q81s4VRJ10fHWXZi7mqz8BJjAODdW6bRd9tOdGWEU3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFKx73Uk0Ct8yuow5xNB8V8bfxsWBmMIXhxIdjZfbWprXjiyMGmfkyo2Vkf1rMlDiV5EfmQjCRE2PLD6FyU/ASkaSZo1xKC3NiQVoEEXstOQQg0gmSS5UsE+1ZBrqMiDiFd5k2hYJGzH/smQFU6ITd/A69VoBdxuwUrpx7Lz2Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mm2MU//K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mm2MU//K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B0C1F000FF;
	Fri, 18 Sep 2026 05:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789710071;
	bh=nHd6+0HC/1nPCk+6Tm6Uyj6WwdTzSmqKCRyfLZwz4Js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mm2MU//KnClCqSqTzNYerNrxjAq+FvG29dS83BnDmwvFqi3DX6rp174BcDccwAzMy
	 CnDZJF5NO67EZaqviRLLQizWwNt++tMwZVUv6rve6qhUHE5KkbcL7yoUn4QMwtcMb+
	 J7/I7DzTEVhddYQS1Hf8p5zoYucUAfWC6iMMd2cy6jJCHzuhcBimIpmeEeeEDGZ/aI
	 PaAGna5sA0SeZs/ylvheVEeDvmDFnUgqPDcFN5VSGJlo2kXwXfR3QccNRJvloa7vW2
	 xbeQjifYIbf4BE3igjVi0tGeJsmSDJeZdq55shnuTsF5lSqMT3vJqwEtY1mLnH5c51
	 AI80yPMRfMhAQ==
Date: Thu, 17 Sep 2026 22:40:58 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 11/20] kbuild: avoid re-running compiler and linker
 probes
Message-ID: <20260918054058.GA384222@ax162>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-11-9ecf4163ff36@kernel.org>
 <202609171154.BEA5134F7@keescook>
 <20260918012119.GC1585590@ax162>
 <202609172130.3DF0D66@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609172130.3DF0D66@keescook>

On Thu, Sep 17, 2026 at 09:44:24PM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 06:21:19PM -0700, Nathan Chancellor wrote:
> > While we could certainly try to cook something like this up, we could
> > also avoid the split across two files by just defining the flags in
> > Kconfig directly and using them in the Makefile through their symbol,
> > like we already do for -Wimplicit-fallthrough. For example, instead of
> > 
> >   config CC_HAS_STRICT_FLEX_ARRAYS
> >       def_bool $(cc-option,-fstrict-flex-arrays=3)
> > 
> >   KBUILD_CFLAGS += $(if $(CONFIG_CC_HAS_STRICT_FLEX_ARRAYS),-fstrict-flex-arrays=3)
> > 
> > We would just do
> > 
> >   config CC_STRICT_FLEX_ARRAYS
> >       string
> >       default "-fstrict-flex-arrays=3" if $(cc-option,-fstrict-flex-arrays=3)
> > 
> >   KBUILD_CFLAGS += $(CONFIG_CC_STRICT_FLEX_ARRAYS)
> > 
> > While we still get the duplication (and we could look at getting rid of
> > it with your cc-option-str idea or whatever), it is at least contained
> > to the same location, so out of sync issues should be much rarer. I do
> > diff Kconfigs so this might make certain issues with checks a little bit
> > more obvious if something changes on the compiler side.
> 
> Yeah, and note that cc-option-bit already exists. It's just a weird name
> is all and there isn't an ld-option-bit.

Ah, I see. I worry that the current cc-option-bit is not sufficient for
all options that we may want to test because it uses '-E' to stop after
preprocessing (whereas some options may need to get to code generation
to be validated properly) and it does not use $(CLANG_FLAGS) to properly
set the target (so we might not get consistent results). I wonder if we
would be better off refactoring cc-option-bit into cc-option-str that
shares most of the machinery of cc-option. Then we could just add
ld-option-str.

> As for naming conventions, I think "CC_OPT_" would be a good prefix. And
> this works today with no change:
> 
> config CC_OPT_STRICT_FLEX_ARRAYS
> 	string
> 	default "$(cc-option-bit,-fstrict-flex-arrays=3)"

This does look pretty nice.

> (do we need "def_string" now?)

def_string would certainly make these even nicer.

-- 
Cheers,
Nathan
