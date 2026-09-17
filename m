Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2713F5172C3;
	Thu, 17 Sep 2026 16:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664286; cv=none; b=UYqculujt1dKgXloQsdwxRqS25kOsWylMOIgSgpfOHvxPVeMmgunIFhpChqxbr5P0/u9B9OA2i3R3DYOo3yr2duSrY8VFO45tVSNoLIq7snvVfDKZETrQxDtTUxjQU1LhzUs8MszGya85F60/EZrS0p5Dh6YG1K00CxCqpXxfxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664286; c=relaxed/simple;
	bh=KU+UbWVWGVDzP2/5478+tNX+uvyBl8kvMYviNDdFHKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p7t1QfL1P72HTyI6pQcuMgKaOZQvNpkFMm3wHLWB9vGmDZCKCU0SBAekhrhGVhDE2deq9WAulX7Vj5VvHeWUrbcVSr5l/fkEr0X41kbDEMDigna2sUf1FTcoKC0+9cGp97Xh0bN+PYB4zZkcetyZ+54xrqySFxVhlNZQ+KVh80g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FijdV8dz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FijdV8dz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0FBE1F00893;
	Thu, 17 Sep 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664285;
	bh=G6M1hxOvYoy7f6OFIyTNAjYyoJ8doAT9R3t/RnO+5wE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FijdV8dzZR2foaEFvspQUWKw1vTW1Az7WPXaE1AnyErCZpDibf9TS+0SVBRczfVXq
	 51yGbrxoI2hkrwpUKheNe44X5at4kUaTkptcr34f9l29GQUmKr49sxZmE7zWmdFj70
	 ToWvPKEy6RdQZV38xRki41NcNNA311huD54DX91tIdQzds9LtsNYVkVPU7JAIpchh1
	 Xrmfo/xCNNmjhgEgtJM6k6/Aswi959TzbgjltpBsIQweHbEBmQpWA8M3jMptitEsEc
	 XNV5BKRrbk6whmGYeGr5yQ9CznqcLlvEj6OFEM+Ge0XByu2XWAR4v26+LVunA5ljIs
	 CrIqaoayngHTQ==
Date: Thu, 17 Sep 2026 09:58:04 -0700
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
Subject: Re: [PATCH v3 20/20] kbuild: compress the kernel with pigz if
 available
Message-ID: <202609170955.C6EABD8C@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-20-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-20-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:30PM +0100, Lorenzo Stoakes (ARM) wrote:
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  Documentation/kbuild/kbuild.rst   | 17 +++++++++++++++++
>  Documentation/process/changes.rst |  8 ++++++++
>  Makefile                          |  5 ++++-
>  kernel/Makefile                   |  6 +++++-
>  scripts/Makefile.lib              |  4 ++--
>  scripts/jobserver-exec            |  3 ++-
>  tools/lib/python/jobserver.py     | 13 +++++++++++++
>  7 files changed, 51 insertions(+), 5 deletions(-)

Awesome; I love it. (I may send a follow-up to improve the PARALLELISM
token so things can define the fallback instead of the hard-coded "1",
but there is only one place I found where that might be useful, and it
will be totally separate from this.)

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
