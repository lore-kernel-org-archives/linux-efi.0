Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C79233D6E6;
	Tue, 15 Sep 2026 11:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789470088; cv=none; b=ULweyweWg3/c4GFFOj2P3JiN39YIGgFZIATMGDohFmuESluep6uujch7kjYSWhVMnOjeZWZC58fg2/St1Qr6HCPwK5wi7M5SvObB8iKv3AC2QXr/jZFwNg1RVixhfSCPoNQzzjUY2u5/ZkgzlkVRk3RDvldu0vSfdXPp1pfujhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789470088; c=relaxed/simple;
	bh=gY9EJkbCr3NCyt+2eN4TRNFmygy7qNzFbmztkbUoUhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtZdCBELYxTw8LW3+2f6AYt+FpNZ5Yy5KuBk8InqbggODr2Ev5w2VduMLaANz9sgjo8FmaLxzh4S6c/Y5+bOApXjtcXMCbqe/Mw770GYV4ZXKEzU9bieZZOToSbFUi5T96BdUCQLGd0M1pd5KvAxGRn0rQ57+TOmG9kMm4l9eqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mc3PV4Wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mc3PV4Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BAE1F000FF;
	Tue, 15 Sep 2026 11:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789470086;
	bh=ZvqUeKCU1dKmmVba4tQNzefSMi1mI5HcwktsDzzTxQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mc3PV4Wgo5o9iOphUm7YhSoqarFhqhHoKUhlZ8EfxphzdYUX454A2pjapcNhWbLfC
	 jI9ZlWkHTbW6unDY4x3Htp1aLjzANzXAkEyQv2+a83T/zVKQijKbl0NaPmgOm3p9Cz
	 e6bz1QL8Rvp4PFJskRZamOsOiAQPtXHL791oxWBdRbgfJ/iE/Z0bnImCLgQpsuBaZ1
	 k/3jYP8SPUJsDpVcMEnPIfcXUChX78R722NbXsQ1Eg6lKV2JvRQ2PwIz64gPui/icT
	 w3j3bzzU0Cl8Qk3uebX+ZkTO0gD/HTEksDpW5VlS/jRzbwd+l/RwqJaNwxeZprh+f/
	 gE488uPZpb30Q==
Date: Tue, 15 Sep 2026 12:01:12 +0100
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
Message-ID: <aqklJxyNPal2ou-e@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-11-39817ec5db23@kernel.org>
 <27304.3198.867048.379684@quad.stoffel.home>
 <aqgRXk6DXyAah488@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgRXk6DXyAah488@gremlin>

> On Mon, Sep 14, 2026 at 11:02:22AM -0400, John Stoffel wrote:
> > > This change avoids a sublte issue with ppc32 (big endian) - clang doesn't
> >                        ^^^^^^
> >
> > subtle
>
> Oops!
>
> I love that I ran this through AI review several times and it missed
> something as simple as this :)

(Fixed for v3 along with a few other typos :)

--
Cheers, Lorenzo
