Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0063A48C5;
	Fri, 18 Sep 2026 21:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789765983; cv=none; b=rRQkxkG1yerbtp1sxVyj8ILpXIu+Q5lxT4TxsMlAJbU0Brhhv8ZrBSKdLFJeIvYVSH6tc7CmBpPLvjBE2NoO2R2gjMQKYhpASnuNiA3Zu+MwuK+S1up1TL+sPMjHhPRUZlw6kT/HFabbVG0IG2x3rCuJ5n40Q2ZyPuVDjUhyaYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789765983; c=relaxed/simple;
	bh=hcxaFczrVEQ8ayTOiOQuTrm7eYLoHpDzZG0CttnLiSE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bLKZ0jbFGmBCpT7OLRlrkyEGcy1zc3XYDF5jc4MlTjVAxz0OSTrIakFBtOi8srqks2q49z3Ru6ap/qrV3tNfWwNsyhjY2841elln80o6/KQb6PloTxvBIlqXtla1jPxCPPqB5iwF/oGsyfuTs+AFz8G4GFnJ1jpTrA1fXMUbO4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnEBlLRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnEBlLRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1671F000FF;
	Fri, 18 Sep 2026 21:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789765981;
	bh=6c/6Gbzu0QafG2PGiTmgDgiVijnAAiazNGXxKOPq+eM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QnEBlLRxxVZclXDxEqcd7TZb9Rck7tFuArt1fESypBLN3Shpq0J3GrJczzjqtBya+
	 k+QVWcZ9DM87K3TtdZyievVgppQjBBkrEcHCYUSUnvMjJauVJiRld8WH9t4626IEYT
	 JW+cFhYsJI8GdTCCcgLJGL47S4vppJekH44o4DM9qUOmAfw6L4p6hgGy2iP68nrBEp
	 71EeyLbJZ/HHcZH2XC7eQu83TeyUcUslnWjGGnKhfdEoZQtvHE5ljWkbRbWoQFDmVW
	 5HkXeH5vto0/fysXrXdsfrSAABnRjbLTU6NM5cbUJDMjRtDA75UD+36pS54v9e8Z3Q
	 ZNypsY6t7jWpw==
Date: Fri, 18 Sep 2026 14:12:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Kees Cook <kees@kernel.org>,
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
Message-ID: <20260918211248.GB235304@ax162>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>
 <202609171149.6454DC6@keescook>
 <20260918010729.GB1585590@ax162>
 <aq1MG8I1BsUUDFkx@gremlin>
 <20260918-athletic-agile-echidna-114f16@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-athletic-agile-echidna-114f16@l-nschier-aarch64>

On Fri, Sep 18, 2026 at 09:54:27PM +0200, Nicolas Schier wrote:
> On Fri, Sep 18, 2026 at 03:35:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Sep 17, 2026 at 06:07:29PM -0700, Nathan Chancellor wrote:
> > > On Thu, Sep 17, 2026 at 11:53:13AM -0700, Kees Cook wrote:
> > > > Yeah, totally right to move to a separate file. I think, however, I
> > > > would prefer this wasn't in init/ though. Kbuild uses scripts/ as its
> > > > Makefile.$topic dumping ground, and Kconfig.include also lives there. To
> > > > me, this new file should be scripts/Kconfig.toolchain instead. And
> > > > arguably, this should be included by the top-level Kconfig rather than
> > > > init/Kconfig...
> > >
> > > I do feel like scripts/ is a better location given that these are really
> > > things internal to Kbuild but I also see where Lorenzo is coming from
> > > that scripts/ is a little weird for this to live for discoverability,
> > > especially if we want people to put checks here instead of in a Makefile
> > > directly. To be honest, it would be kind of nice to separate the Kbuild
> > > parts of scripts into their own directory to make it clear what Kbuild
> > > uses versus what users/contributors should use but that is obviously too
> > > big of a project to tackle as a prerequisite for this.
> > 
> > Yeah it just seemed really weird/surprising to me (in the sense of
> > 'principle of least surprise') to put that in scripts/ and it doesn't seem
> > that traditionally anything else like this lives there.
> > 
> > But if you guys feel strongly enough I can put it there.
> 
> yeah, then I'd also slightly favor scripts/ for now.

Alright, I think scripts/Kconfig.toolchain wins then :)

-- 
Cheers,
Nathan
