Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659A737E304;
	Sun, 13 Sep 2026 19:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327875; cv=none; b=D6nJdn2PX9bSywEzJkMBDVKRCi6qkwduRyN88OadvNfkUgKVOqOa+mTaASk+dmzuVST0EHJyDaTIk7ZyPv9EzueyCFz7cX7hc3d4OBydDlLvVG3pDDPFzqLYpITrWnjgTjdcnogysj11RYVdidN+8jwo63nioPV5nRsqSZsyKEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327875; c=relaxed/simple;
	bh=rr13TkHZbL+ldb0nKaKTxHEakLfgTDRH/kuczdJfGBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6pMDYRGYfcwOhd0qFz05fVuqcGMdIGccSpoKNBdOZka5LtY2jh0qtkuFdfaE0SiIknlETMAPOVrxok8zms8p0WqkKiVzpFKsn1ZDPRAmW/iVjW6tKMqYyqCr14L3vJrewLah9S0T3rumtBKp1+E9VWYbTqFZ3RGkC74sfcKuIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1b0+diD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1b0+diD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B371F000FF;
	Sun, 13 Sep 2026 19:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789327873;
	bh=rr13TkHZbL+ldb0nKaKTxHEakLfgTDRH/kuczdJfGBw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R1b0+diD7lxfHcPKqbPTo/SFC1cctdEtdFH+R74FwSTC5XlCdna70LwTQQaHy2XNU
	 dMnJp/LBuyuVEkyZmtOG2myPc7/nu5717JrPIelrdjByI55ps9Vw0Bi+UG/cTPso+z
	 gNxS0Qmtap1DH08ZsH88HCZkKblQ1qSlPoE64MUmXLxLop7fvSbOgNNUvJGaa60gB9
	 V0mP0W+nFWlsFSA4FtbxiuIjFH8AtbX2NGRBxmfUFe0nF2LNaj/Z/6LH/HGiXNSzWV
	 X36Tx9nz2McE/FE1Xd99zgzIfOzx0u6I8DgPRQ12RTRBbsdnFBeXikqXFadoBjIoIl
	 rwjQ3pCYuGh6w==
Date: Sun, 13 Sep 2026 20:31:00 +0100
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
Subject: Re: [PATCH 23/23] kbuild: use pigz for gzip compression if available
Message-ID: <aqb4fos8X3eDX_jD@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-23-5dc1ac01672d@kernel.org>
 <178901395293.3971858.15429964442902485180.b4-review@b4>
 <aqPdP_0eh0OYY6gZ@gremlin>
 <20260912063811.GA2002951@ax162>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912063811.GA2002951@ax162>

On Fri, Sep 11, 2026 at 11:38:11PM -0700, Nathan Chancellor wrote:
> On Fri, Sep 11, 2026 at 12:03:51PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Actually make KGZIP=foo will override this still. But it doesn't take an
> > environment variable for make -e.
> >
> > However, that's consistent with other variables there like KBZIP2 etc.
> >
> > Probably the wording in the docs should be tweaked!
>
> Hmmm, TIL, I thought := always overrode a value specified on the command
> line but I guess not! I don't think there is anything that needs to be
> clarified.

Yeah, news to me too :))

I did slightly tweak the doc so I didn't make a claim that wasn't valid on
KGZIP re: env vars :)

>
> --
> Cheers,
> Nathan

--
Cheers, Lorenzo
