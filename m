Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67771381EB9;
	Fri, 18 Sep 2026 01:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789693667; cv=none; b=bhmzFq/hp6ITpm/QpTKdgj72UA+JwAwhPeJqevWpRkz8b7mQizSYrGBWmfJkwUMkngNSOuA563Wal4wPvInPWBv/82yXVkrGu+mTY4Sv6cj8CkIBRN8WzLJaCpfJ3LcenUfN3nXSu5pA7U8hk4wjajxZrhrOj30PNMjwvMS5Ypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789693667; c=relaxed/simple;
	bh=zd4n6T+KNJlcv49XYrrNuIpekHrLVb254IIMObQi4Ng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=icy2gm3h0MtVzBuJG2AfHXoannwRL9yjbjE3KxAsaz0B2vnfFVD/xst6mkpCLs1ScE+DVurJaczqFAUPViYveEcDW3PDSpSVt/2WsPkOwBd+2KhtkP0jFrXG09Ss+2ch46lKK9qRBifmnp9CaCXg53aGYs65a1kqNFnm93tX7fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5cWkWse; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5cWkWse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B681F00893;
	Fri, 18 Sep 2026 01:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789693662;
	bh=4K9MjrbYytfjUKZsWDZQNZLjwWqitvV2RncrKp6V+PA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k5cWkWseKfeadwsaVPXCsS8lvGsd+tdSmPOrVtqEMbk75KqTkD4zy+7En6LhD2ywa
	 DaRsd83TwV0mOIZho690nEmO3idWB8XQkIziKwCh0GcwjjjU70EpJbTmEi/cF0GuaP
	 /7/pXwyCpUq0e7QXW37qfDqLOT7I2G7zCvNO2mNiHwQarbF5EybADwKGrWUy41EbBI
	 zTDD9URKYYpbd/eKGmEPGtH9D9AREbGz+aRY2dyE64e+faqRl2rwDc8cmsA58OEqGc
	 WurYI1M8cJohHT6NtQSs49BdhFIdDtVANA86k0AT2mqjHWvvHIV+ycSb20M+TACXFn
	 um2yh7n0v+EZQ==
Date: Thu, 17 Sep 2026 18:07:29 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
Subject: Re: [PATCH v3 10/20] kbuild: move the toolchain checks into
 init/Kconfig.toolchain
Message-ID: <20260918010729.GB1585590@ax162>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>
 <202609171149.6454DC6@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609171149.6454DC6@keescook>

On Thu, Sep 17, 2026 at 11:53:13AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Move them into their own file, sourced from the top of init/Kconfig, so
> > that the next commit can add to them without growing init/Kconfig further.
> > 
> > No functional change.
> > 
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  init/Kconfig           | 197 +-----------------------------------------------
> >  init/Kconfig.toolchain | 198 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 199 insertions(+), 196 deletions(-)
> 
> Yeah, totally right to move to a separate file. I think, however, I
> would prefer this wasn't in init/ though. Kbuild uses scripts/ as its
> Makefile.$topic dumping ground, and Kconfig.include also lives there. To
> me, this new file should be scripts/Kconfig.toolchain instead. And
> arguably, this should be included by the top-level Kconfig rather than
> init/Kconfig...
> 
> I defer to kbuild folks, though.

We talked about this previously:

  https://lore.kernel.org/aqPW1FsBVYHSWl1r@gremlin/

I do feel like scripts/ is a better location given that these are really
things internal to Kbuild but I also see where Lorenzo is coming from
that scripts/ is a little weird for this to live for discoverability,
especially if we want people to put checks here instead of in a Makefile
directly. To be honest, it would be kind of nice to separate the Kbuild
parts of scripts into their own directory to make it clear what Kbuild
uses versus what users/contributors should use but that is obviously too
big of a project to tackle as a prerequisite for this.

-- 
Cheers,
Nathan
