Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8104F5DE0;
	Thu, 17 Sep 2026 17:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666774; cv=none; b=N/uoIBUu3/VAWF8EQXud7GfnwwFDQloEIq4JMkOjkj5GaGpk2IxGIvA1XOK5WvoirkzHLrLg6jmGHW6JFqnFJ4WUPBdk1STc5v9IdSorYzWcARHdO1PrPfgSmImjwUU1SaV7kD4XFnDJjRSVUMzNQG/hrJ49Gr/2qPMaLkgLwF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666774; c=relaxed/simple;
	bh=iPA+p6LHuyiHGjo+hCD0P1OFvGR8+rWfCMP122YmU/E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t/yW1bVW+UK1e9cUhrlaAva8nj9T6U+FdXXnZ94YYO1UKpQyLCFjBj/T/y4Qhqx8WcZiRFIxo2NAwo/XWbQKs7kDEE9KOrkjyS0DQee3QIg78Kx1k9z+KVsFLQdJOLxdjNX2ljxtcU98DErLqyJcsp01qLiMYL4Oj8NOQixvgrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFFYB82J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFFYB82J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB21B1F000FF;
	Thu, 17 Sep 2026 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666773;
	bh=QiqLoLaMeHAvq9CreoMXDkPkVCQITFh+w2NQFDlDCNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UFFYB82JqIT2jZngugSLMZP4JXo5QIHBIIOCxt7FU+Nro2gIZV8nvb+n9AuluVPHg
	 hItERr0YpNLVZh//ikX/iGTSxIB4+6I+cLKGCb+9yO1Gn1gYvakRTHTK8UCFe9C6la
	 gQyYet+0VIcuaUGGlMo2UJuq3zYKloV7cy2iEzNGbDMkxA3YeIbiSRaeOHtPt2tTU+
	 nyHWcz0Roaay3mBigf5qypMT8EjFczv69Hu+7Yljzvhc4sIejovuvH+rjjJnIDTF9M
	 1CJwkbVf09DxQnfs7/xzR551PFlbxA+cMpBIzHpu19R2W1QO882vpP9tajV3swKbTu
	 ng6TxIpeHV7ag==
Date: Thu, 17 Sep 2026 18:39:18 +0100
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
Subject: Re: [PATCH v3 01/20] kbuild: do not allocate .modinfo in vmlinux
Message-ID: <aqwlKFJ27LSsFsb-@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
 <202609171002.8C0C739@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609171002.8C0C739@keescook>

On Thu, Sep 17, 2026 at 10:05:34AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> > +      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< $@.tmp; \
> > +                                    rm -f $@.tmp; \
> > +                                    sed -i 's/\x00\+$$/\x00/g' $@
>
> Oh, I just noticed this. I don't think the .tmp is needed. You can just
> use /dev/null for the outfile here: no need to write anything unused to
> disk; seems to work for binutils and llvm's objcopy.

Ack will fix up thanks!

>
> --
> Kees Cook

--
Cheers, Lorenzo
