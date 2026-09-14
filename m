Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3415381AEC;
	Mon, 14 Sep 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789410344; cv=none; b=cASfl/RnAbWlFqAUKQLEj+9EtSPsN6E1FE2vSlze2F7R6OLvmOO5J7uewQP1//DVGpX098ox5QPdhWEeMo2QnDNV7PUC4vHyibogWPIjiWleS5TPTq9sSL6e+P3ktQhfgnsrrkKIOGqxqbyYaMD/4xiexOaZnKNeBad/CQv3fO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789410344; c=relaxed/simple;
	bh=MSUBVHA6SYh17/zAEeD87cDOzMUOc+7X634FG+Ct7Z4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mr198+unIVqkt+iTymd+8GHCnCR6QFycFjMOfG53mBwhYyaqUtFYU2NMK0cKnVMdU69JVhJPF/9ol/YbcXznbOsqBrlwfKYLMTIF35P11eiRj1HyEOO7JBNaMYm04eClg+IMOewZe9CxyVwrIwtcPMctGOjyY9/1Miw/cL4ukRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2dDa3GW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2dDa3GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B441F000FF;
	Mon, 14 Sep 2026 18:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789410342;
	bh=9IjIObR5k7PGYTYmWhdlK+kKKQoR6O9Er2obIa/1gz4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k2dDa3GWuYsEUnYiCf2cNfMemYcH7gF3w4RpJHc2SMwIB5QPObhfRBuDl1VaCDzjL
	 BxXofrG6qAndbrAnP95A3BGbc1OISuGgaajL6XQ62mHcCgCY9EOWv3admkl0lwU+vL
	 hpyp4zxo4Wje0UrueF070IivC/uHeW+s1/HsvLFQarY26cIjMucKYU6kpouAmy3Y6c
	 HuCxDzF4jbAYEqCbEATfP88AL4mkR/cw02/lnYKsbxBYFPEoqheJPHlxRGw4831Eht
	 /lw/vvJEoS92HnR1Lk1Cp/C5yeN9G1gNVIwr1aqddQzN3MSGyo+7UmY1bfcT68b6Go
	 8XUQstSyQmoUA==
Date: Mon, 14 Sep 2026 19:25:28 +0100
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
Subject: Re: [PATCH v2 00/21] kbuild: significantly speed up kernel builds
Message-ID: <aqg5nvRy9nuvC78L@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <202609140833.88C0E16E50@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609140833.88C0E16E50@keescook>

On Mon, Sep 14, 2026 at 08:41:39AM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:21:59AM +0100, Lorenzo Stoakes (ARM) wrote:
> > This series makes allmodconfig builds up to 36% faster, ...
>
> This is very nice!

Thanks :)

>
> > incremental builds
> > up to ~70% faster, and noop builds up to ~90% faster.
>
> Some of the changes for this seem to add complexity that I'm not sure
> is balanced against the gain? I am still looking through the series,
> though, maybe I'll change my opinion. ;)

Well, I aggressively stripped all the commits that had a bad RoI on that.

And a lot of these are additive over 21 commits.

So, unfortunately, hacking away at what seem like low cost commits will eat
away at the overall result.

I really did work hard to cut the fat where I could, believe me going
through what remained and a. figuring out what it did, b. rewriting a lot
of the code and c. rewriting commit messages (ahem ;) was NOT fun :)

So I was happy to swing the axe as it saved me in terms of what little
sanity remains ;)

>
> > 		== allmodconfig FULL build ==
>
> Did you try Clang CONFIG_LTO=y builds?

I tried a CONFIG_LTO_CLANG_THIN in order to check that the *.mod.S stuff
worked correctly, all working correctly.

I can try to get some profiling numbers for thin and full if you want?

>
> > 			== LLM usage ==
> > [...]
> > I extensively audited and rewrote a lot of it, and heavily edited commit
> > messages, the cover letter and comments.
>
> I feel like the commit logs still need a lot of work. The LLM verbosity
> problem appears in many of them, for example spending 80% of the commit

Well I rewrote the majority of them, so this is a stinging critique of my
commit message writing I guess :)

> log describing every step of some process as background before getting
> to the actual change. I think a human writing this would be much more
> terse about the background. I have, however, been known to be too terse
> in my own commit logs. :P

I mean no, I did write nearly all of them. So I guess err... yeah :)

The testing results and perf numbers are generated and maybe I missed some
bits but generally this is so.

Anyway, I am known to be critical on-list on occasion, so if you dish it
out you have to take it - if you point out specific commit messages that
need work then I can try to put commit msgs on a diet :)

(N.B. I have had feedback like that on a fair few human-written commit
messages of mine lately so there might be some validity to that ;)

>
> > [...]
> > Nothing too controversial was included. There are further improvements that
> > could be made, but they would either by very invasive (large scale C header
> > changes) or generate diminishing returns.
>
> One area I think might solved via an LLM is the 3-pass kallsyms stuff.
> If we could get a deterministic kallsyms build in 1 pass, that would be
> very nice. A lot of people have tried, but it has eluded upstreaming.

"going from three passes to one would save around 8s on an allmodconfig
build and 2 to 3s on defconfig, out of tails that are currently roughly 25s
and 8s." says the LLM :) so that actually does seem worthwhile.

But I think best as a follow up?

I'd like to land the really low-hanging fruit before maybe digging in to
what else we can cut out :)

>
> -Kees
>
> --
> Kees Cook

--
Cheers, Lorenzo
