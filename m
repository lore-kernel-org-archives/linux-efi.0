Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EB1155757;
	Sat, 12 Sep 2026 06:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195105; cv=none; b=Y6nJO5qM/3ZBSkf+Tc4MJne0fbZ8gGXDe0rUUZZQ1zpbW49cRcUpf8Wp0JuJxub/Ra5zV7Z9oO73FLP//cHcNHgc+ng02/2/d4lOAvcGqUgIqNKIrx06ccZmbPM0eDY9K3oUeF9Gr1qDZALg3SWpKqruI1NKcGd6KMaJSAksiLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195105; c=relaxed/simple;
	bh=7O2L6MPLk4QKInc8TYJDErn7oB62wbi1ZdHqf1IV8uc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z9QI1N1+wMtm2icYgIDgsu2EEt+FUAqqa2cPpUvAM3auegNRyagOUOYygCv5pT7uzp7JmKsf2woumqtSLFCGDvkxKwULQjiDSuzbhuF3R5n9jR3UGtypuXP7IYHlclr6WDkGBwr+vFLwGtbvQj1iOCavAWysNdSHBmSQPd8mM08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ca5YizZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ca5YizZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99C51F000FF;
	Sat, 12 Sep 2026 06:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195103;
	bh=3q+gqJaQNSw7zopShFjv5phABfd7Zt/zt8yj8tu/XRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ca5YizZ0qzpo3pPdor/zFBETaCj9tTA47MXV+adcyOxfoAK5jJWRrjHwKJq6edNt4
	 84Nw5a+Cy8TQc/+e/VDvplgzmJkOWW0IFOt4g60MXjG/sxK91CHEpdk5izKEEX4Qcf
	 snt+U7KB6899WBRmMmO+Ty1WFBadnQgS4SLsqfhKewEOSe09ZT/qEfAPKWRRRSqfpJ
	 ClrfBBgp6eiImJ4y70FLuIAQI8eTubMFsNEnSz7MJ7qDKm/M/EtRLUZaHlFdjozIiM
	 H1vUpC174tNMwd9Q3gLXfYAcFM73uN8S6lvOC0me1KqjeYLlsKIZnKPZDY/WrFvg4d
	 BfGKCl98KqLsg==
Date: Fri, 11 Sep 2026 23:38:11 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 23/23] kbuild: use pigz for gzip compression if available
Message-ID: <20260912063811.GA2002951@ax162>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-23-5dc1ac01672d@kernel.org>
 <178901395293.3971858.15429964442902485180.b4-review@b4>
 <aqPdP_0eh0OYY6gZ@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqPdP_0eh0OYY6gZ@gremlin>

On Fri, Sep 11, 2026 at 12:03:51PM +0100, Lorenzo Stoakes (ARM) wrote:
> Actually make KGZIP=foo will override this still. But it doesn't take an
> environment variable for make -e.
> 
> However, that's consistent with other variables there like KBZIP2 etc.
> 
> Probably the wording in the docs should be tweaked!

Hmmm, TIL, I thought := always overrode a value specified on the command
line but I guess not! I don't think there is anything that needs to be
clarified.

-- 
Cheers,
Nathan
