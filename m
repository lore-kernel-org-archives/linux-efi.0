Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664A502D77;
	Thu, 17 Sep 2026 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668703; cv=none; b=SZ7UM6dFARECh7pC2V7GzAzSkEkIBB2ClM2VYKSlpJf7RrlK7WI1g4ARRWZBiqUoaLhws30Cg0Tt5sAQyy7Hi8t+sWhU79DMmdzlYzy5E4FpuXYuACMPgNctyah+FEw2V+WX4l1Mi4nAL4bIq8liKMvcAKwD7GU8k6oKptGYwnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668703; c=relaxed/simple;
	bh=wuIz/X3kPZ4FCOB5fTlN6NsGPHwOHZTOZDcEDKG3TTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QUqkSFe60MGtP2yG2xiahz3/hncNJ2DiAijZ05YkUL+hKCbdYt38y9/KzvLZgN+izLtvf536qBruRJoRKlEizNF+7A4nrxe9lZCI0UWHeRT7GHR9l39F2OG3eo7UznQ+5jUWUa+mKiN5OfE3fFF0rcMka8JP+e6Q3QFwHcoIbww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yd1VSsre; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yd1VSsre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FBB1F0089A;
	Thu, 17 Sep 2026 18:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789668702;
	bh=KivQhtsO8a4itzEQWZwvcU0vaLM0EC3b+zcpo+5cxFA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Yd1VSsrews+KOBN0uKtnIdnZ1G8CVssbrPM08Gw35Vri29zJuBn5FKU3BGM09J/YT
	 ez6WOpuKLqbRXy2mEU+yrWFZWOdLsOGEJHcrg46gtRII0MYNvTU3ZpBSIkgm5fqeG7
	 DtoigLn0myERRymKYpPutd36aESFAKs1EljepOhcZI3BUu+T65G/uepm2XbWi722Pe
	 N0THyeTnDWjGILEUOpLpk+HIUgicl8OAvLhrVHsTfJjVAK9blGwpgqF4FxzR4jEvX6
	 KfzLy+gnOGm8DLjpR827SCTwuDWK1Y8RXPONMg1MDxP5t06lQbpC94vGwhZr8tuY/W
	 zK0rO7XmGemMg==
Date: Thu, 17 Sep 2026 11:11:41 -0700
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
Subject: Re: [PATCH v3 08/20] kbuild: cache list, composite object state per
 object
Message-ID: <202609171110.438BC7477A@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-8-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-8-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> Fix the issue by caching this data and looking it up instead of getting it
> over and over again.

Nit: I would describe this as "calculate these once". It _is_ caching,
but I think with Makefiles there is an implication the "caching" means
"write to disk". But maybe that's just me.

> This has a particularly large impact on allmodconfig builds.

Love it. :)

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
