Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0051E3B5304;
	Wed, 16 Sep 2026 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572436; cv=none; b=NsPS/hEHndv4sOI76IuLYSrnXQahxl8arm4uKGSmfEEI5tQ4IBLQcfQ0SNjlMglrLyhhM98bVLNlKorXTgBOvZXMo0G5As91zof2mC646zuCahY6ymmJp0uJcdk6GgiQZZtVKBYbzMsZo+rQIawgnQP93cELkNjkynxaGicpgqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572436; c=relaxed/simple;
	bh=fQV4rSiHmdiI0jtkCgcO0ezwkrfUrjLXCKAPjBp4W1k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnAO7wubbuaFMSWuEmvgcL1GAfR4PM54ehFpO8EKMgdTRPv5Y0tskNotDC7fQRLQg9OboQevytxumGlZYhScHkJTWCALZmPvWax+nhEq6X8no7r+FYZJOX7gP8rMmNjDBFxujp09bD1ljSz4wIAE2UeK0XMFxj0AmmEtz629tZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K4zyDQK3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K4zyDQK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E251F000FF;
	Wed, 16 Sep 2026 15:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572430;
	bh=UkRbXLbpw+AP2jr8iP96phPK0XDdfYv/MOHvNo1E1vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K4zyDQK3PDEMTdWFvmeoWoqSY4bftx/jIM47m+e5m/CxuUgT2ZlxOgrpbi8scn6zA
	 QVKN7ZD9SORGKm3IBe/NE6t27UzhPfsBm/WZe+N7lz8+tNzpq09wAFnfd0tXjv81xh
	 8rvuaPTitkf5DvhUxl5/uIMlCntdrSUBTbc0Nl9wCiBCLt0ysG9RDdTG7UNBtFuv+N
	 vx4N/BEQJLgSIglrxXmmd/2SbmxnmWg7UK0VPlxcFsCJ8072505DSOwvaGsjM7tV+d
	 dNbIGqX8V6mt4oDoL+ZGWrk110WemqKgp5jhPvmlaWG38bbsOuVV/b72clK+giRlzw
	 R8h3G0UoIzEGg==
Date: Wed, 16 Sep 2026 08:27:09 -0700
From: Kees Cook <kees@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
	Linux-Arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 21/21] kbuild: use pigz for gzip compression if
 available
Message-ID: <202609160809.78E97DC34F@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-21-39817ec5db23@kernel.org>
 <202609151758.BA5732348@keescook>
 <081b2b60-e295-4cd7-b201-d996a88c5f28@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <081b2b60-e295-4cd7-b201-d996a88c5f28@app.fastmail.com>

On Wed, Sep 16, 2026 at 08:38:33AM +0200, Arnd Bergmann wrote:
> On Wed, Sep 16, 2026, at 03:06, Kees Cook wrote:
> > On Mon, Sep 14, 2026 at 10:22:20AM +0100, Lorenzo Stoakes (ARM) wrote:
> >
> > Makefile:
> >
> > KPGZIP	:= $(if $(shell command -v pigz 2>/dev/null),$(PYTHON3) 
> > $(abs_srctree)/scripts/jobserver-exec 
> > $(abs_srctree)/scripts/parallel-gzip,gzip)
> >
> > and the same scripts/parallel-gzip:
> >
> > 	#!/bin/sh
> > 	exec pigz -p ${PARALLELISM:-1} "$@"
> >
> > And then replace the /boot/ KGZIP uses with KPGZIP. Then we don't need
> > to change modules, config_data, new users, nor cmd_gzip, etc, which all
> > continue to use the regular KGZIP and the "use python" part for the
> > KPGZIP case becomes is a 1-time cost?
> 
> Nice, I like the idea and this this will work. I didn't know about
> scripts/jobserver-exec, but this does seem like a perfect fit.
> 
> I checked the other compression tools we support, and found that
> zstd is another one that has built-in support for parallel
> compression, so we probably want to have it there as well.

Follow-up idea:

Having to make a dedicated wrapper script to use jobserver-exec is a bit
clunky, so maybe the ergonomics need to be improved there slightly?
Maybe we can add a simple template thingy to
tools/lib/python/jobserver.py's "run" to replace, say, '%PARALLELISM%'
automatically, then it becomes:

KPGZIP	:= $(if $(shell command -v pigz 2>/dev/null),$(PYTHON3) \
		$(abs_srctree)/scripts/jobserver-exec \
		pigz -p %PARALLELISM%

-Kees

-- 
Kees Cook
