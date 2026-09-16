Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E396C3368B7;
	Wed, 16 Sep 2026 01:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789520767; cv=none; b=gMKVvJVL/A+Hg4AD5p1Gwwu9pLAJ62ZvCAqkYDdpluVVA62wBcu4anmzNWAUbwESKe56xNfZCmdvnIk7LSPCSuq6g916UqOjjnkMMjajP9oV17RNfkiq1RVlR2/E+CHcBdDhzykqOBL1QJ+Po4xZ+SBd1zr4CBKPhDUPKoRAFOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789520767; c=relaxed/simple;
	bh=Saf9w/qoU4P4L+eoRXMaLuF8LHIiH0+7eiiF2u0xKxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TvwtQm1Abl/QMqbTkfgfEypNPkHpdmDcXz1qLOqg1j/AKtV+0p/vAF43SjL8FivWgjiHuoaPZy+oxqyetk20p6me7mIoq1HTjPRXH1pXtNWCZMOVGC18Uo2mMS4PDRba+L7V7YNqxw+T0vqyFcG2XZ/y+gq2Z6uQwjWCzhlvy6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AH7a/Zx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AH7a/Zx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75431F00898;
	Wed, 16 Sep 2026 01:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789520765;
	bh=XvgNiNkqBk6+kkXqTrzqW7sJYsvtakfLRPDEyhDg7Hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AH7a/Zx22fCnj33kUljdAwOHOUB6dl3lKvMgl39S8dfLFFpjmDAaW7aDoy2lCXff3
	 Zo5MdcsT9MVBmf7RLpdu82PWxH+JojNmdB3QU8us1QpIAD7fzrNCMEQUBFDPoCmVVH
	 v64SNvGRvvxsBLc8xfHi2oNua4PEqxDdKLcX3VVlpXjL4N84lDvzPXSLk1zwfUBqDC
	 nmtEMH2BW2uTaL8N30L/XGO7Tufc7TIYAa1z299zYRAmx4fX0IqrXdw2LMtGQGZgiC
	 EmB9ZWdwrChtSsjs57wQqaPMI5KKrLLVc4HWuYUtR+CTCpfaRt9iJx0l0wdcqoCnv+
	 qCNr4m7E8ofTQ==
Date: Tue, 15 Sep 2026 18:06:05 -0700
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
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <202609151758.BA5732348@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:22:20AM +0100, Lorenzo Stoakes (ARM) wrote:
> diff --git a/Makefile b/Makefile
> index 790ef23c5e8a..38c0cdc9f591 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -561,7 +561,7 @@ PERL		= perl
>  PYTHON3		= python3
>  CHECK		= sparse
>  BASH		= bash
> -KGZIP		= gzip
> +KGZIP		:= $(if $(shell command -v pigz 2>/dev/null),pigz,gzip)
>  KBZIP2		= bzip2
>  KLZOP		= lzop
>  LZMA		= lzma

I had another idea that I think solves both my concerns (limits
to parallelism, new surprise users) and your concerns (complexity,
single-threaded when needed)... how about:

Makefile:

KPGZIP	:= $(if $(shell command -v pigz 2>/dev/null),$(PYTHON3) $(abs_srctree)/scripts/jobserver-exec $(abs_srctree)/scripts/parallel-gzip,gzip)

and the same scripts/parallel-gzip:

	#!/bin/sh
	exec pigz -p ${PARALLELISM:-1} "$@"

And then replace the /boot/ KGZIP uses with KPGZIP. Then we don't need
to change modules, config_data, new users, nor cmd_gzip, etc, which all
continue to use the regular KGZIP and the "use python" part for the
KPGZIP case becomes is a 1-time cost?

-Kees

-- 
Kees Cook
