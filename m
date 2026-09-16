Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40793254B0;
	Wed, 16 Sep 2026 14:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789569212; cv=none; b=QrQM17LBQIIbp2+jCF+INlFh0kpQcjK1Ie6R2fG0x6non9+4OaCWj8RKg8uXY3gFtLl/1oGD+PuR6KJawYtmCKbiHfUANvE03w8eDAvif6W7/T0vLDnVYJvB5c14o+RGm8MEznZ1tHuX+UKVQw1nt0SZ7N1tmz+LcdgCKelGO+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789569212; c=relaxed/simple;
	bh=UhMCiLnG8Ugj9w6K6IXYARcIsxqAigoIYBvU7UTHP7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rXia72202b5KXaRoPfA0vDtLH/hwSHVwI16fWIjDa8IypruNRRKkWwOQJZqj7yOcPnaOJQtPkHwBCqebYIlY4MtHZOR4h99sFzlqvKN9vlKzcfs8nz9JowpPOYZzMPQeD1n7d6qPrZI63eOwUnbqRIMBGsTvmvL9cn5QDX4wI0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KB+vtMog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KB+vtMog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE971F000FF;
	Wed, 16 Sep 2026 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789569210;
	bh=PFRgUz13CKX8U9AELJWTu+7kgzvYnFqa7uF4pRvkbcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KB+vtMogVxZRbbWdVaraL4Bow/O7cpdrceW8JwdKjOqho7N4jMsp6eQnMKyWxuKIQ
	 2JMLKxvzFMQyAjfZF/Xg/6NK6cM98R35gw17eIR9bO8V5BlHaPdRR3vNTT5SiS+ow4
	 Nq4TgKmxUNpvdqxstKoY2Bly2Co8I8TMAFB6kfseLHZjc3suLJDrq/tet28rC/79PU
	 st+RcejV9HVggHtq1mGITBXWNI6YITiCKd4z8BHsNWl+5DBF3f8dW9T0sVHE93sHl3
	 DZIj6/SPsL0paVgMnEfQTutiq72aKiWJR7RI9Xb0HUgqlzJFfoRmqnCzbGuAvt7Coi
	 uSWXBjxNm37Zg==
Date: Wed, 16 Sep 2026 15:33:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Desaulniers <ndesaulniers@google.com>, 
	Kees Cook <kees@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
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
	linux-riscv@lists.infradead.org, Linux-Arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <aqqogpgRog7CEJbo@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609140844.FA7E848A@keescook>
 <aqk9gakQhxToLnDI@gremlin>
 <202609150955.A51C9F7A20@keescook>
 <CAKwvOdmgeyqivO4pVa=30XDWpXvdRzBR8f13rfuPzDx=LJ1Tsw@mail.gmail.com>
 <90006ad1-73df-4bd0-a434-61875edd5bb9@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <90006ad1-73df-4bd0-a434-61875edd5bb9@app.fastmail.com>

On Tue, Sep 15, 2026 at 08:02:38PM +0200, Arnd Bergmann wrote:
> On Tue, Sep 15, 2026, at 19:47, Nick Desaulniers wrote:
> > On Tue, Sep 15, 2026 at 10:31 AM Kees Cook <kees@kernel.org> wrote:
> >> On Tue, Sep 15, 2026 at 03:30:43PM +0100, Lorenzo Stoakes (ARM) wrote:
> >> a)
> >> My main concern is the lack of respecting the -j make argument. In my
> >> mind, this is a blocker, because it means a build will now _always_ spin
> >> up max CPUs (not what -j has limited it to), and for CIs, shared compute
> >> systems, or whatever, this violates the requested parallelism level. For
> >> example, if I'm doing a long-running Coccinelle replacement in one tree
> >> (which uses half the CPUs), any builds I launch I'm asking for the other
> >> half of my CPUs to be used so they don't thrash my cache.
> >>
> >> This is the kind of "why are all the CPUs spinning up?" question I
> >> helped track down with commit 51e46c7a4007 ("docs, parallelism: Rearrange
> >> how jobserver reservations are made") forever ago.
> >
> > Parse -j from MAKEFLAGS (https://stackoverflow.com/a/76517886),
> > forward it to pigz?
>
> That still has a potential O(n²) problem: if one builds N kernels
> with a top-level jobserver on N CPUs, and they all take the same
> amount of time, you end up with N pigz processes each trying to use
> N cpus at the same time. Ideally we'd use the equivalent of
> -flto=auto in the compiler, which respects jobserver settings,
> but I don't think pigz supports this at the moment.

Hmm this is a good point :) though I see Kees has made a suggestion that
could solve all of these concerns!

>
>       Arnd

--
Cheers, Lorenzo
