Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF5F30C146;
	Fri, 18 Sep 2026 04:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789706666; cv=none; b=kmWezw9TxTtbELslxAYLZCaetbZypWKjbXIDZbhDWvkJcjBNzm1wZv+JOlOYgkFMRbuF5G2M4JAY1uzkrhTPTAMbGYl3u2P77pgEQpN54H+5suiNZqhAq8gYUEJok+4akwKvhrHzQ158UCzT6YtinNmraiQz7WRqpaI3stbliHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789706666; c=relaxed/simple;
	bh=nRntUvG8VfqjqmV6gXAQEPBy9XEX9TT0/57eELrdPC0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8h86vK21yBtnR+CjzxHxAMkjUUg69FGNv+o0lA+dQi41Yf2/Asy5PqXa19FP+UlJVcz1V6Dxz2X2HmeZ+F7v9rnLL8ZOaaDsuf+TzuwikzKs2KoxzIFywzA3PUU45RT4qcw/pIla7Px9C43jXGNkVPv9bkZDz3VuGi3lG9+/zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRJTfYRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRJTfYRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98C41F00893;
	Fri, 18 Sep 2026 04:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789706664;
	bh=bqZx/AptVhZLcudKvv7eqc5S9GWWoF0mLVu5mPMuXVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hRJTfYRamoTrmtZroOVByfenuYfGDp7MAxXhTqbsJrtj0eHWEbinP0LsZWILEq+XD
	 OikV6J85b7zSxwh87Jb/ngzwEe6TQTPZxtT9eHmp/66v0Gc75aPTGTthkiqQLOdlYe
	 qYTEfEURoLvzbT9rOGpjjnSsMmQWWjtMDvS8dZoc5ls+HJcvM9EDRA1tJjv4BNpzKk
	 j7xKqxF2anKKWQ67STCZVhSh5UZ5d+MNO5B66dAmPxWJgfVu+5+V3BTAONMkZxsyu+
	 FphLF7BOAaSJ1VxHjt5+8ncx7gpMmCitABngv2FjDsJH7Nyc5mgeR7imudcUYsMgbc
	 i/8dYQEK1Smgw==
Date: Thu, 17 Sep 2026 21:44:24 -0700
From: Kees Cook <kees@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
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
Message-ID: <202609172130.3DF0D66@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-11-9ecf4163ff36@kernel.org>
 <202609171154.BEA5134F7@keescook>
 <20260918012119.GC1585590@ax162>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918012119.GC1585590@ax162>

On Thu, Sep 17, 2026 at 06:21:19PM -0700, Nathan Chancellor wrote:
> While we could certainly try to cook something like this up, we could
> also avoid the split across two files by just defining the flags in
> Kconfig directly and using them in the Makefile through their symbol,
> like we already do for -Wimplicit-fallthrough. For example, instead of
> 
>   config CC_HAS_STRICT_FLEX_ARRAYS
>       def_bool $(cc-option,-fstrict-flex-arrays=3)
> 
>   KBUILD_CFLAGS += $(if $(CONFIG_CC_HAS_STRICT_FLEX_ARRAYS),-fstrict-flex-arrays=3)
> 
> We would just do
> 
>   config CC_STRICT_FLEX_ARRAYS
>       string
>       default "-fstrict-flex-arrays=3" if $(cc-option,-fstrict-flex-arrays=3)
> 
>   KBUILD_CFLAGS += $(CONFIG_CC_STRICT_FLEX_ARRAYS)
> 
> While we still get the duplication (and we could look at getting rid of
> it with your cc-option-str idea or whatever), it is at least contained
> to the same location, so out of sync issues should be much rarer. I do
> diff Kconfigs so this might make certain issues with checks a little bit
> more obvious if something changes on the compiler side.

Yeah, and note that cc-option-bit already exists. It's just a weird name
is all and there isn't an ld-option-bit.

As for naming conventions, I think "CC_OPT_" would be a good prefix. And
this works today with no change:

config CC_OPT_STRICT_FLEX_ARRAYS
	string
	default "$(cc-option-bit,-fstrict-flex-arrays=3)"

(do we need "def_string" now?)

-- 
Kees Cook
