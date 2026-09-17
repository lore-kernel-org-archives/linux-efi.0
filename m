Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26ECF4F3ECD;
	Thu, 17 Sep 2026 17:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666699; cv=none; b=NAog+43uBsTpcg8BTZITTbAlgSCxytYSnH/ZYhmVREfYhiAoHLLggzUCmhTGQOv4alrCGtNrZuFICYULpXLo7CEOeccDLkzgU2lC6Do0ithAYiMeXug1LP8mSYa7MUKBmd/a4y9gR73fyPQbfQ5ILuyKKNypRRLDtwkoLdPocLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666699; c=relaxed/simple;
	bh=ib+6vMcBODm6E3iiubO5VCEhaUtJLVMGFlGllm8pKio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sW7ClXmFuiaPGs/HLwsSJKXI3elI1sSj89Z3UBU7mvU22Ud2KBYVr2oUJ56cy+1d4t0+gR+pZP2x8B+hRtTbX6MDaUQixxJvURXQpLggOtMpAmMBZzYrTy3s77BilFWYsbzNXZAPWmiCQTRS1oYP4df3y/wANphciFn9m7FrILw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XgLFJVXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XgLFJVXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27881F00893;
	Thu, 17 Sep 2026 17:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666698;
	bh=82QCZLgXlq3HllOhKT6Yb32CPb39AXzdv4Gsai45+qc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XgLFJVXqk8vF1LPiVrJpWUF8Q92lD5fXYMKKuIpVn+ggLnA9Lf2zOZ71ydWLEGoex
	 smxQka5WZDFeG8/bNwItz2gvXCrURqWsk5f76lRF19Ud0EETjGcJYLgBWg/LEKcv0t
	 HHItlqD56kd+oAb18jweq8RqXi6A1Yw/Vo5wH+CevBBCj8Mp3H27emgA3LJXxegCfv
	 LbVnHMQqXuiXvLX/SppuXO5DRggt/BvIV8fT2niy80ULZndR9nDgyowx2AzmaUeCn4
	 Z/u8lbw6SDwSuxGWm+PUMUjDNKB2z5FHkEj0kqIT0bdSu6qKiarZMYQEQjj8ojFh9X
	 rAjj3hYLF9SDw==
Date: Thu, 17 Sep 2026 10:38:17 -0700
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
Subject: Re: [PATCH v3 04/20] kbuild: do not sort nm output where the order
 is irrelevant
Message-ID: <202609171037.7D690D3CE6@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-4-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-4-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> There are places where this is unnecessary - an invocation from
> scripts/sorttable every vmlinux link, scripts/check-function-names.sh run
> after every vmlinux.o link, and the x86 VOFFSET and ZOFFSET listings
> between vmlinux and bzImage.
> [...]
>                                           before    after     delta
>                                         ---------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        9.7s     9.5s    -0.18s (-2%)
>   x86 defconfig, touch mm/vma.c, clang      9.3s     9.0s    -0.27s (-3%)
>   x86 defconfig, clean, gcc                30.3s    30.1s    -0.16s (-1%)
>   x86 defconfig, clean, clang              31.7s    31.2s    -0.55s (-2%)
>   x86 allmodconfig, touch mm/vma.c, clang  36.4s    35.8s    -0.67s (-2%)
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Not a huge boost, but it's a trivial change with a deterministic improvement.

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
