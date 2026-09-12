Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028E637204A;
	Sat, 12 Sep 2026 07:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197101; cv=none; b=MXMzX/ttIah7wdSp9F+CSPQUCGd4VB93rvJMrFogLQg6BAt0pJO5uAIGp913hSXQLuJ93oMPhVvlf1EaivkQrmwDNX/FNf7sv/fXdWMuOmGfV2+sqgeapLVev1gpitxrTnaKYtmDCVwyH5RfeHPe8juDA333DvO5i0+7UFTMl2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197101; c=relaxed/simple;
	bh=Mw/2FuMBzyRbpnBdDwqyc0WoQo+XQ75T+sKeuIrxxWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VI9IScGGtikWtgv0awfbG+L/7Go7baQAr5O6U3lojL2uzbdM1ru3wc6EXxrGFx41RDELiFe+hxvS8n4PS8aIpx+XVNa1vAukvH1nQUOE2/Lc4e9lKx/UxGoUuG5R/sKSJSPsCryrZIcopyAKRqRqSLDrb9uMQcxiXcnbdMVwM1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eFWkhuVd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eFWkhuVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744F31F00893;
	Sat, 12 Sep 2026 07:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789197099;
	bh=4/WwgIbj2JMFSxLBJaTQNiKL//gze4K2SPN+E9vGKnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eFWkhuVdsLkYkirfy95jHDEmcj/iqcwLeOP2AYho268voIwJ7tppVk54oT9Pqaw7/
	 UbBk+Y5+6aO4UN8SVP5qsv+q9Oc8y4oxgCWc9xe9hOKC6TDKfGnf8Z95DLdbu/SMvg
	 pD1N5hre4CopVGJaKrTfyHoPMiS27zD9jBfCjawuTS8HCCS7y4Av0jQpUwNvp/86Vy
	 eHcMQbOwt2VuTSGRTCOvMZx6PbSNAUjNo3ckHBRAivHVzuTmgvftg5LZVSgfeTfVfC
	 +raEmQN52zFlbmq/l9cIs3x5uorPACERQ0byHB6VSAgijLL7sRQpxk+VUBVhtH9gON
	 EKnbCFfiMLxcg==
Date: Sat, 12 Sep 2026 00:11:28 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nicolas Schier <n.schier@fritz.com>,
	David Laight <david.laight.linux@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <20260912071128.GD2002951@ax162>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <20260911183333.1df0f2e2@pumpkin>
 <20260911-invaluable-indigo-seal-e31aec@l-nschier-aarch64>
 <aqRGYXKDzXZMXmmp@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqRGYXKDzXZMXmmp@gremlin>

On Fri, Sep 11, 2026 at 07:24:50PM +0100, Lorenzo Stoakes (ARM) wrote:
> I mean this is a problem that already exists for any flags already specified in
> Kconfig.
> 
> Out-of-tree modules are historically something that we don't go to great lengths
> to support and haven't historically worried about breaking, either.
> 
> I'm sure distros can find ways around this if a problem were to arise. But I
> don't think it's something to worry about all that much.
> 
> I expect a _lot_ of these, in any case, would only require the compilers to be
> within a fair few major versions of one another anyway.

Yeah, while I know distributions will try to maintain a stable kernel
ABI to allow updating modules without updating the main kernel, I would
be very very surprised if they guaranteed compatability when building
external modules with a compiler different from the main kernel. If so,
I think they get to pick up the pieces :)

One issue that I found with my test matrix building with LLVM is that
cc-option in Kconfig does not guarantee use of either '-m32' / '-m64' or
'-mbig-endian' / '-mlittle-endian' to properly flip these options, which
could result in a flag being set (or not set) when it should be. For
example, building ARCH=powerpc pmac32_defconfig results in

  clang: error: argument unused during compilation: '-fno-stack-clash-protection' [-Werror,-Wunused-command-line-argument]
  make[4]: *** [scripts/Makefile.build:193: kernel/bounds.s] Error 1

because the 64-bit PowerPC little endian target supports this flag in
the PowerPC LLVM backend but the 32-bit big endian target does not.

I am not really sure what the best way to avoid this would be off the
top of my head... it might be safer to start with moving only the
warning flags to Kconfig since that is a truly frontend query.

-- 
Cheers,
Nathan
