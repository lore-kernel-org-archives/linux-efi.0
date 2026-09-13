Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3EB361943;
	Sun, 13 Sep 2026 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789317414; cv=none; b=s+cQzpMS4Rxy0vmtGg62nCgYWnk0mQ2XWjhP0E3XyOR/W116v1pKkZWO8YJl/n7ZISQj2bzXxXmgsMjJOFDfZJHmU9SdxJblRSUSlnlo2OT63qt7ogkJAcLNd/g4HK0hHuPDo9PIPHFsY1QzX0ZM42evp51sauicxZas6zJRUnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789317414; c=relaxed/simple;
	bh=3cetiHmsplFWJ+S96Qjna0YXLC/+Qhfff+MJkaGC2AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EpmnLeEtkx4/mzmFJyM+n0YBQKZFTs77RculjMXbDdW+rBFE2a5m/jWK+H1rWdtBtO+JjkEdBsSG2E0A/j49G4+Ku/g4rsFc4UU8h8H3VEOKDqmmIto68cMEMvQfbAAbNLQK8k18cGajLhB8YtX6YpDtpdSk/CRXGjeoRnUuJxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMRn/4Gg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMRn/4Gg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2A71F000FF;
	Sun, 13 Sep 2026 16:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789317413;
	bh=4B9lPYJZx2WtDB/f5GYcYiGdJjQEGc2VffrdMkBYbGc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VMRn/4Ggw0dXaUy1jNqG3n3Y3lFltR1JKKPxPddcpiouSI90FL6bJhQ0xjuXhlNvp
	 QO1eJQCBNg+tmWZk87cuALgFzNb/l7wfaiANKKcLbSXgtVUrkWdkNh64DthcliwB3k
	 0oxm7Ms59/P2/kAKOj9iBsmBiBTunJMFV80yf35hbkPAs4+FIHmmbL3vZJD6FpvmxZ
	 mHQ7218RLoe2DdnCFuFPUqEz4+gu0Hl6ff15ZY13jwu8GRfFcoVd5HkF51bunsZjp/
	 xGN3TJ3cymEhnAkRu8EhgLboTMnYMtazjxkrpjpzHNudJWLJHnoXfwaiSJEJt+1Gbn
	 Meb3psVdxKrCA==
Date: Sun, 13 Sep 2026 17:36:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yann Droneaud <yann@droneaud.fr>
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 17/23] modpost: perform srcversion hashing in parallel
Message-ID: <aqbP9ewBMAGAXbQB@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-17-5dc1ac01672d@kernel.org>
 <4e447b33-574e-425e-bc92-2b728128cf18@droneaud.fr>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e447b33-574e-425e-bc92-2b728128cf18@droneaud.fr>

On Sat, Sep 12, 2026 at 01:50:00PM +0200, Yann Droneaud wrote:
> Hi,
>
> Le 08/09/2026 à 22:55, Lorenzo Stoakes (ARM) a écrit :
> > modpost does a lot of single-threaded work hashing files from each object's
> > .cmd file.
> >
> > This makes the build slower than it needs to be, so do this work in
> > parallel.
>
>
> If you're going parallel, it would be nicer to do it under make's jobserver
> supervision.

Ack, though this patch is going to be dropped due to mod versions being removed
upstream.

>
>
> > This is egregious for allmodconfig builds - for instance x86-64 can end up
> > opening 200,000 files individually and hashing them all serially.
> >
> > Parallelise this operation by maintaining a thread pool for the hashing
> > work.
> >
> > Combined with the per-file hashing commit this cuts modpost's run time
> > nearly in half for an allmodconfig build.
> >
> > Module.symvers and every *.mod.S are byte for byte the same.
> >
> > modpost is on the serial tail of every allmodconfig build, however
> > defconfig does not set CONFIG_MODULE_SRCVERSION_ALL and is unchanged.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                           before   after     delta
> >                                           -------------------------------
> >    x86 allmodconfig, touch mm/vma.c, gcc    33.4s    30.2s     -3.2s (-10%)
> >    x86 allmodconfig, touch mm/vma.c, clang  31.1s    28.1s     -3.0s (-10%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >   scripts/mod/Makefile     |  1 +
> >   scripts/mod/modpost.c    | 72 ++++++++++++++++++++++++++++++++++++++++++++++--
> >   scripts/mod/modpost.h    |  2 ++
> >   scripts/mod/sumversion.c |  3 +-
> >   4 files changed, 74 insertions(+), 4 deletions(-)
> >
>
> Regards.
>
>

--
Cheers, Lorenzo
