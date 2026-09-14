Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE49B38C421;
	Mon, 14 Sep 2026 18:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411434; cv=none; b=YpTF9zIZ1XLYLLF4ms5CWCJFa1CCpVZfUIph0jEM7a+T/t+7UstYFk8ww4CZZ9sO4wKAl9nbLp4531tMjYbR+GaLdJ3H+VzsWcRrg3AeNMb9/B956vvV4AQuvCx3PsVGOYIb2VdK4th+UkFmumwXVbKPX8gtdZWxVGAQBI7BA/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411434; c=relaxed/simple;
	bh=zy03KGEW1YeeekDBJmyUfQNa60AVoG7T/gD0XbgBOzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4rLH0S4YaTtqNBbt7XKh1/6zL7hHuxhR78X5X5+WVBir4yd2IcTG15ZqRgcUCQski4VAVWTLnACyhl0DH/3I+tc6w9ZhvWLB+vyKVUxzOU83kYSUYI1vrwc/+TP6dmLSBcJt3uUQJw9UQk1wiK88PfCBoV9Cq+16VskWfW9fUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G0/xHYvA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G0/xHYvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCFB61F000FF;
	Mon, 14 Sep 2026 18:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789411430;
	bh=bo6GJLiDf9mVwm6AXXi7iuVJHoavl3dsdCOXGh6V4XE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G0/xHYvAtQ4HOxtFGJbJlA22cMjDZl+N56G9hsoC0tQv8qT6/15zEdvADlDxeYuQh
	 ae8Q6N4X+AKq3TVZGTbZs+4oj+vIEXo4zgpz9hevYG1TM/+/i/QF6MM11pZBxxyVq0
	 vraPPnQ7ZUCWXbPqXPeQbWc8N1vmP5oiVA5uoJav1ICknNtIaaUdkQaW70pDvAs5vE
	 974HTKmZo3bFjISiUMqs3buCdhMg059Qh11CETtTBafCHxBYrVccHqoUfj37NZD6rk
	 zB9+I7SuAegOhvn9/uOVYU9JJ+Kw272HbWhBcTsqzySDRKTHj2bpbmSHp8inaUBp/U
	 YZD68D5G/qndA==
Date: Mon, 14 Sep 2026 11:43:50 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
Subject: Re: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
Message-ID: <202609141139.AEF875252@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <202609140833.88C0E16E50@keescook>
 <aqg5nvRy9nuvC78L@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqg5nvRy9nuvC78L@gremlin>

On Mon, Sep 14, 2026 at 07:25:28PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Mon, Sep 14, 2026 at 08:41:39AM -0700, Kees Cook wrote:
> > Did you try Clang CONFIG_LTO=y builds?
> 
> I tried a CONFIG_LTO_CLANG_THIN in order to check that the *.mod.S stuff
> worked correctly, all working correctly.

Okay, thanks! I did the same just now too. It seems to be just fine.

> I can try to get some profiling numbers for thin and full if you want?

Mostly I wanted to know if it worked still, and I guess for profiling,
I'd want to make sure it didn't regress how long it took to build. :)

> Well I rewrote the majority of them, so this is a stinging critique of my
> commit message writing I guess :)

Oops! Sorry. I'll go through them again, but I felt like the objtool
commit logs were very long, but perhaps it is justified. ;)

> (N.B. I have had feedback like that on a fair few human-written commit
> messages of mine lately so there might be some validity to that ;)

And as I said, I get told I'm often too terse, so perhaps my sensing
here is broken. :P

> > One area I think might solved via an LLM is the 3-pass kallsyms stuff.
> > If we could get a deterministic kallsyms build in 1 pass, that would be
> > very nice. A lot of people have tried, but it has eluded upstreaming.
> 
> "going from three passes to one would save around 8s on an allmodconfig
> build and 2 to 3s on defconfig, out of tails that are currently roughly 25s
> and 8s." says the LLM :) so that actually does seem worthwhile.

It's what I'm always staring at when I do incrementals. ;)

> But I think best as a follow up?

Yeah, I would imagine it'd be separate. (I think a few of these sets of
changes could be landed separately too, like the pigz work.)

-- 
Kees Cook
