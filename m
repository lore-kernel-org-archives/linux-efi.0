Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0804D43AB0;
	Sat, 19 Sep 2026 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789829307; cv=none; b=Z4nrSEIBpb9HV1A5hxGshe22qPKwSJyE/dQ0tj+qAzmBWe3U8Hjoyra/vADevOodxmGA/dwsdnCEBkdDHQVrW40DTFLEU5HnQg65kH4Z7zLE+tRNWJUPiIi7DGYlXBnSunxUcaZmUhqr3EUP9JUlzYeR1IEAhhXChw2WNIX8Jz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789829307; c=relaxed/simple;
	bh=o1ZQ7MH5wDXQsKPIVArWrFcpJvDeJlfsiVlJBRwpoXM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O1232K40fN2AYWFNXK+6AdwkcprhFBCXN5vODrtcb8VM9N0iksjzkl/RE2sHdjD7ofRVcMGt64BAH6pAOxy8F7dmdTU/IjizWTJHf2E7enYUoBloPA0SDCv1EkmNgnw4akzpEjuVEvPWNb42BrlLKMISqdoJyIgVQcTfpKwJ+PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lm2k/vQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lm2k/vQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34C71F000FF;
	Sat, 19 Sep 2026 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789829305;
	bh=o1ZQ7MH5wDXQsKPIVArWrFcpJvDeJlfsiVlJBRwpoXM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lm2k/vQkpX7W0rWLi5B6K5eTJR1tZUnSWZJ1Ng+jIx3YZF9kLqPaBrTmlJSsCX9nh
	 EuvRaBKJEEywI1N9lA1+7Ys7i3UdEigSw0oiv6tq1drO2Ro5ZD/N6xNN/PdGENyiry
	 OQze/hFxIhrCHYmcl3+sCa2wi/yoXq0DmLmIj16j+oHTE4uRFAk74RVtHyd4ldYTZf
	 IvdGdbPsJQiKDu0USoB8Ug/yRfNtvtJou/1NlysRZYAbRYTkXoHFZkW/B/7TV1HbsP
	 RKA2Vfq/eOWP6HnxXeDQnh98UFWvAUENLTjQPoGih+Xd6pZ8oFkDU/0ix1EBwESNRN
	 EJSaX1urbuaAw==
Date: Sat, 19 Sep 2026 15:48:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: Kees Cook <kees@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
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
Subject: Re: [PATCH v3 08/20] kbuild: cache list, composite object state per
 object
Message-ID: <aq6gjULjd5uP-AVA@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-8-9ecf4163ff36@kernel.org>
 <202609171110.438BC7477A@keescook>
 <20260918-godlike-devious-perch-707bf6@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-godlike-devious-perch-707bf6@l-nschier-aarch64>

On Fri, Sep 18, 2026 at 09:51:26PM +0200, Nicolas Schier wrote:
> On Thu, Sep 17, 2026 at 11:11:41AM -0700, Kees Cook wrote:
> > On Thu, Sep 17, 2026 at 05:06:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > Fix the issue by caching this data and looking it up instead of getting it
> > > over and over again.
> >
> > Nit: I would describe this as "calculate these once". It _is_ caching,
> > but I think with Makefiles there is an implication the "caching" means
> > "write to disk". But maybe that's just me.

Ack!

>
> +1
>
> Reviewed-by: Nicolas Schier <n.schier@fritz.com>

And thanks! (also to Kees :)

>
> --
> Nicolas

--
Cheers, Lorenzo
