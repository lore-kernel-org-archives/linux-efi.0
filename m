Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659FD418A2D;
	Mon, 14 Sep 2026 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376284; cv=none; b=bwH7cCEYSET3LTOoNUE/x1yUsN58qxmAfnIzwQWEsOoNoorT8ytZxMloQZB8Hg42Irsf+wAWZgwvqJofkddgNZSUCakCifkUng0AMmtgUiPB2jAuwRXSLhE29MyAn/N4hOWue7AuvDWwtYi35yn7oGNZbsb0b0G1oAZ0rYgS1Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376284; c=relaxed/simple;
	bh=BINx8gFYvVaebZ/aP+DUglTYwKJqjTa2XesGjsIMg7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WGtjBf54iTC463yz+sfG8bztZU9bpxQWE69oT6iPHod2GxEgTIXUcHQxuHC1otmQNGXaBpq/05DnPNjRAn+Q0xpzIQm40tDkGkw6oYIAkEWhrpCX/iJILtL1JHeSrpgcEKvkmgtMwnAqn5XTTL/LtCJZh8TGSmzQXrDHQ7AB25U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=advzK3Ge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="advzK3Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787DC1F000FF;
	Mon, 14 Sep 2026 08:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789376273;
	bh=U1K11A9+RHasMnoG3wmtnu891cbuAryY4EeC4FZJwns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=advzK3GeU+AhH/w8zqSqeooS4JmzOok/9Ne52l7+V6aQ4xdJG/jTmyMoxQuE3m95V
	 laE2LueDRdWJiQ6g6RwMHTi/WqxyJSM1Ifapd0SIx6U62DcUQTTKw+RFEz+Iy9UB6r
	 0Gh1LH17vZszJk9MrhF5NL/W54R4sZvqTQAfTWqifeIKyRfSoxaJr16KHPm54Q8QqJ
	 Cm/VHV524fjvDtfToVtDeFI6BZoYgmdR7hrbHtzZcvVfZTBMUIHVPIwR5mxCsABlLk
	 DX0HrLqfi9TqsSv8JBv8bH17v2suBWU80P9duFOYDfteVYainLvUDfcSMTixwlA5hb
	 xeb+9i3bkQC/A==
Date: Mon, 14 Sep 2026 09:57:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/23] kallsyms: output binary data to speed output and
 kallsyms assembly
Message-ID: <aqe2XF_TOUk2nRFg@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-4-5dc1ac01672d@kernel.org>
 <CAHk-=wgryL8XqjFcO=EQwKdqNn51BANiv16QiqYKCUdXxDQBmg@mail.gmail.com>
 <aqewl-H-IzjIt8uD@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqewl-H-IzjIt8uD@gremlin>

On Mon, Sep 14, 2026 at 09:39:26AM +0100, Lorenzo Stoakes (ARM) wrote:
> ...BUT, can definitely put
> those remaining .long entries in the binary too so the assembly is
> absolutely minimal.
>
> LLM says there's 200k of those, so does seem worthwhile, I'll do that for
> v2!

OK, correction, it turns out this isn't possible :) LLM found commit
a081b5789255 ("kallsyms: Get rid of kallsyms relative base") which makes every
offset a relocation against _text, which means these have to be kept in the
assembly separately.

It takes .18s to parse those ~200k lines so it's not really a big deal :)

In any case it's not a huge time sink on build so it's no big deal to keep this
as it is.

>
> >
> >                Linus
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo
