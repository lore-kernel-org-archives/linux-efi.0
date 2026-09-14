Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CE33DA7D9;
	Mon, 14 Sep 2026 15:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789398546; cv=none; b=YgaFOHTuTg46lG4ZF+7WuWXTjcg7d5X9Nq9+szKBKOcm3l+vyY7iCGPw4xdADQrDumpqhNXJNfq2hE89dyXKzfrfxxzMTmTYvWMZrFlkMwwJo3hKe+7V87mgthPJRI6vg8MWYQs5tbOL/c1YGKfoHzMIOF1AE7NAxOhrMDhxD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789398546; c=relaxed/simple;
	bh=oMblGF1PmYRaqle4YPaaEqUlpIDejeN8jfSd3IyEo/E=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=eYjYu1MUzO4PmOsxppvIPenLg5LLgy4ERwzumqrNdICBWgDIw/OMKxDDznnGOltGH917kF8lQYSzUQKnGRfgAK+eYWv0vwbqjRWVrRRc8f4hBzRznArTVFrjBSJ8bEj4LLgINAdU1BmuHgkwejOhyMb7pQ/dvCCJhXhLqskOfWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b=AlmtH9ST; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b="AlmtH9ST"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stoffel.org;
 i=@stoffel.org; q=dns/txt; s=20250308; t=1789398143; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from :
 to : cc : subject : in-reply-to : references : from;
 bh=oMblGF1PmYRaqle4YPaaEqUlpIDejeN8jfSd3IyEo/E=;
 b=AlmtH9STTB3sBPP31THd4Ukf5Z6t561oZCkY6InocAjV6FJV0GlJpESrVaoEiZ4A2uvYj
 gSessr0w8EU13qxN0B+jYQ20yXsLhCqUZutbGy7AcGcD5CFenB+bVoo/1m8Bw/R1ZtoWetF
 sBmKOUI3nx0KxE7wUcDCF+5n4994xds9o7lSQH/T2399oBGJXN2k3kZ8PCGsCP8feOVSZt7
 E2jqE9cJAeF1HOKpro5FXdEZy3YI3ScbXELaBw6grc9sla2gt2x7VXc0k45gBGa5H3OmWN9
 QSHUKS/Lr8CJN8h1E+WssVpWqEPHuNKBoEAReWkV8A5H3NgyUYydzjMKYCNw==
Received: from quad.stoffel.org (unknown [24.177.6.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 96A101EC77;
	Mon, 14 Sep 2026 11:02:23 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id E573BA3288; Mon, 14 Sep 2026 11:02:22 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <27304.3198.867048.379684@quad.stoffel.home>
Date: Mon, 14 Sep 2026 11:02:22 -0400
From: "John Stoffel" <john@stoffel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
    Nathan Chancellor <nathan@kernel.org>,
    Nicolas Schier <nsc@kernel.org>,
    Nick Desaulniers <ndesaulniers@google.com>,
    Bill Wendling <morbo@google.com>,
    Justin Stitt <justinstitt@google.com>,
    Masahiro Yamada <masahiroy@kernel.org>,
    Alexey Gladkov <legion@kernel.org>,
    Thomas Gleixner <tglx@kernel.org>,
    Ingo Molnar <mingo@redhat.com>,
    Borislav Petkov <bp@alien8.de>,
    Dave Hansen <dave.hansen@linux.intel.com>,
    x86@kernel.org,
    "H. Peter Anvin" <hpa@zytor.com>,
    Paul Walmsley <pjw@kernel.org>,
    Palmer Dabbelt <palmer@dabbelt.com>,
    Albert Ou <aou@eecs.berkeley.edu>,
    Alexandre Ghiti <alex@ghiti.fr>,
    Arnd Bergmann <arnd@arndb.de>,
    Catalin Marinas <catalin.marinas@arm.com>,
    Will Deacon <will@kernel.org>,
    Mark Rutland <mark.rutland@arm.com>,
    Ard Biesheuvel <ardb@kernel.org>,
    Ilias Apalodimas <ilias.apalodimas@linaro.org>,
    Josh Poimboeuf <jpoimboe@kernel.org>,
    Peter Zijlstra <peterz@infradead.org>,
    Miguel Ojeda <ojeda@kernel.org>,
    Boqun Feng <boqun@kernel.org>,
    Gary Guo <gary@garyguo.net>,
    =?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
    Benno Lossin <lossin@kernel.org>,
    Andreas Hindborg <a.hindborg@kernel.org>,
    Alice Ryhl <aliceryhl@google.com>,
    Trevor Gross <tmgross@umich.edu>,
    Danilo Krummrich <dakr@kernel.org>,
    Daniel Almeida <daniel.almeida@collabora.com>,
    Tamir Duberstein <tamird@kernel.org>,
    Alexandre Courbot <acourbot@nvidia.com>,
    Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
    Jonathan Corbet <corbet@lwn.net>,
    Randy Dunlap <rdunlap@infradead.org>,
    Kees Cook <kees@kernel.org>,
    "Gustavo A. R. Silva" <gustavoars@kernel.org>,
    linux-kbuild@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    llvm@lists.linux.dev,
    linux-riscv@lists.infradead.org,
    linux-arch@vger.kernel.org,
    linux-arm-kernel@lists.infradead.org,
    linux-efi@vger.kernel.org,
    rust-for-linux@vger.kernel.org,
    linux-doc@vger.kernel.org,
    Jens Axboe <axboe@kernel.dk>,
    linux-hardening@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH v2 11/21] kbuild: avoid re-running compiler and linker
 probes
In-Reply-To: <20260914-build-speedup-v2-11-39817ec5db23@kernel.org>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
	<20260914-build-speedup-v2-11-39817ec5db23@kernel.org>
X-Mailer: VM 8.3.3snapshot under GNU Emacs 28.2 (x86_64-pc-linux-gnu)

>>>>> "Lorenzo" == Lorenzo Stoakes (ARM) <ljs@kernel.org> writes:

> Each kernel make invocation begins with ~30 compiler and linker runs each
> of which performs duplicate probe for a number of compiler and linker
> options.

> This is useless work - the compiler and its version is known, so use these
> to determine which options are available, once.

> A convention already exists for this - CC_HAS_xxx, LD_HAS_xxx in Kconfig
> files (for example, CC_HAS_COUNTED_BY), so convert these probes to Kconfig
> options where appropriate.

> This change avoids a sublte issue with ppc32 (big endian) - clang doesn't
                       ^^^^^^

subtle

> accept -fno-stack-clash-protection on this sub-target, so keep this option
> in the Makefile.

> With gcc and clang, defconfig and allmodconfig, the recorded command
> lines are unchanged, a build with nothing to do rebuilds nothing and W=1
> continues to function correctly.

> Doing this improves all builds, but has a particularly positive impact on
> no-op builds (builds where nothing has changed).

> Whole build, 128-thread Threadripper 9980X, best of N runs:

>                                          before   after     delta
>                                          -------------------------------
>   x86 defconfig, no-op make, gcc           0.78s    0.60s    -0.18s (-23%)
>   x86 defconfig, no-op make, clang         0.94s    0.66s    -0.28s (-30%)
>   x86 defconfig, touch mm/vma.c, gcc        8.6s     8.5s    -0.16s (-2%)
>   x86 defconfig, touch mm/vma.c, clang      8.0s     7.7s    -0.24s (-3%)
>   x86 defconfig, clean, clang              29.8s    29.4s    -0.37s (-1%)
>   x86 allmodconfig, no-op make, gcc        12.9s    12.7s    -0.23s (-2%)
>   x86 allmodconfig, no-op make, clang      14.2s    13.9s    -0.29s (-2%)
>   x86 allmodconfig, touch mm/vma.c, clang  32.2s    31.9s    -0.30s (-1%)

Are these deltas just per-patch, but cumulative with all the previous
patches applied?   

