Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446244AE8DA;
	Tue, 15 Sep 2026 16:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789491123; cv=none; b=HcCXSfSnlSahGq6e4WUveKxk7CEE2HHh23pSy1HcFbcW5o05kEjMyNsswyVjEdwIYMn/jh06A8xNBI9uKILfscROBuUqQ21RuTcGYKULa4PdMj23he/STx2/ow9ybkZ58CMyxLOpGjKIJ4flRY1u+d4OsA7iNH9+KtzNZl7W8mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789491123; c=relaxed/simple;
	bh=/UR+2Iq7w8FYlaxEN7+1nLp8xgJdzaPnKXZV2EHPGQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeUcQ5lVhnKUmho1BuCAp+iyMM+LvM576nbeR5jOBYa1j+h72TwA0FKbn84bVoXYfbcjdwTMaqWNsvHMkfEiMm5GGbsBQjTHCiu1or/eaKRZRfglxqx66ezcL3zF0Op/xr0nV9Mh+uc/fjzvfWkz6/eivj6ckZ/K3eVV9OD3scA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2gPH+LF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2gPH+LF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E231F000FF;
	Tue, 15 Sep 2026 16:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789491122;
	bh=AAegg1HqQc2zlyPsCFndE7BU31mvGmt6H10k5+2dIJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I2gPH+LFzLYZALBDt0ClbZdP2ilKcDCHRUfiBdPm3idQOsDqpB7q84aLX1rNrpsIi
	 wqf4NIRZrAMGKEqi89jARH+zbeojQb+KDUw89DWC124dgGma0vkuOyh7VKF0jaex++
	 b57xMMAACGyAnBWTbpAotn+pMoUc4jo98m/cRL6VnMgiAuTr01RxuVn3RxfhUqUF2V
	 HDTTUD4Q37fkbMXjP61re8NqNAxmKlEzdXEOYIYEP0ixfcH/BkcKa66oKfC9x6HBgf
	 1HGcQYQ/iY9/7C56XCgwfGL8/S8XFNbJezbtToRJkfqoCvtrHQsII7a2j185CneqPi
	 WT5WUhI+hl6tw==
Date: Tue, 15 Sep 2026 09:52:01 -0700
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
Subject: Re: [PATCH v2 20/21] kbuild: build rust crates in parallel with the
 rest of the build
Message-ID: <202609150951.73C4F16EFB@keescook>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>
 <202609141133.7CA979C89@keescook>
 <aqkv9SqIdh0qKPFc@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkv9SqIdh0qKPFc@gremlin>

On Tue, Sep 15, 2026 at 12:58:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> Since this _still_ gives you a significant speed up on bigger boxes, I think
> it's fine as-is.
> 
> The LLM says a fix for this would need significant work - a cross-instance lock
> and an on-demand rust/ build. So I think best as a follow-up?

Sure! And I defer to the Rust folks on all of this. I just wanted to
note the possibly unintended behavioral change there. Thanks for
examining it!

-- 
Kees Cook
