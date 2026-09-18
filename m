Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696F23BB138;
	Fri, 18 Sep 2026 14:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742174; cv=none; b=JjX6K8yOTvu7dC9rdVpkN40GXsuxO9XBTEHupboTWstb5VGoWrOW15+rkVmF45/JCy2TuxCu/FS/XWxBrhpnIBIQorPDxkyo9VWGeiwCPA6odXPdrdBHvVYh7wR+FueBdGTx6PTZhOzT7ewEVZgMP6NVgjHb2Ra98ka/d24Q8Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742174; c=relaxed/simple;
	bh=vYEk1Rs67C55hieXQ8EyjyO1XA6pmyMeNVRurUVcTyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bg0n5VQKWvloRYkSVs1EtVrpWF+XFPmqGNTjb0s9z9orRw6ztGwWi4LFTqriCricUhdD3uKPBKivtTRZ0pHm43BMFddk7C+b3SxXqU3ttxwJmFieKj4P/T7ExUKfCA6Hs4iBtcROSWIGx6h01ybJ36aH520xSvHOmyfgorcABp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kp6bVUAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kp6bVUAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD181F000FF;
	Fri, 18 Sep 2026 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789742173;
	bh=iy+YeJOq8ncVue9kKagO67d1wHr0X1BI7jS1wlHwKFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kp6bVUABBdit8x2HmWr4RJlsOX4CpxQbJSRoZwK/ALiD5H36OGaoVkBVHLa6pKaGu
	 i9kDvm+VAVQ+5N+yg4SGamQO+46oTWUMUEPPwLdQRjtKVIyiuL71DqfPFAd1UFsygH
	 WCGGxfRC8e/UQK6y/tagDorXGNS0w+oqCa/aavHFlrZ+C/St6RscsL4ptFWrQNOK2U
	 liPEhlIAyjO0xuH5Vvu6uioXNq+N0s0yDCXSJ4NmqRk6VZVGTLCfrkCuHTDkDgm9ZM
	 eeTwQ+wv7Tqyog1aY/KAeBtRr1DlEU6Yy72+A5ksv6Vdi+LmLwmuf4AEZnwW1t5Lca
	 GYaLTzfGj+YnA==
Date: Fri, 18 Sep 2026 15:35:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Kees Cook <kees@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Schier <nsc@kernel.org>, 
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
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 10/20] kbuild: move the toolchain checks into
 init/Kconfig.toolchain
Message-ID: <aq1MG8I1BsUUDFkx@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>
 <202609171149.6454DC6@keescook>
 <20260918010729.GB1585590@ax162>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918010729.GB1585590@ax162>

On Thu, Sep 17, 2026 at 06:07:29PM -0700, Nathan Chancellor wrote:
> On Thu, Sep 17, 2026 at 11:53:13AM -0700, Kees Cook wrote:
> > On Thu, Sep 17, 2026 at 05:06:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > Move them into their own file, sourced from the top of init/Kconfig, so
> > > that the next commit can add to them without growing init/Kconfig further.
> > >
> > > No functional change.
> > >
> > > Assisted-by: LLM
> > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  init/Kconfig           | 197 +-----------------------------------------------
> > >  init/Kconfig.toolchain | 198 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 199 insertions(+), 196 deletions(-)
> >
> > Yeah, totally right to move to a separate file. I think, however, I
> > would prefer this wasn't in init/ though. Kbuild uses scripts/ as its
> > Makefile.$topic dumping ground, and Kconfig.include also lives there. To
> > me, this new file should be scripts/Kconfig.toolchain instead. And
> > arguably, this should be included by the top-level Kconfig rather than
> > init/Kconfig...
> >
> > I defer to kbuild folks, though.
>
> We talked about this previously:
>
>   https://lore.kernel.org/aqPW1FsBVYHSWl1r@gremlin/
>
> I do feel like scripts/ is a better location given that these are really
> things internal to Kbuild but I also see where Lorenzo is coming from
> that scripts/ is a little weird for this to live for discoverability,
> especially if we want people to put checks here instead of in a Makefile
> directly. To be honest, it would be kind of nice to separate the Kbuild
> parts of scripts into their own directory to make it clear what Kbuild
> uses versus what users/contributors should use but that is obviously too
> big of a project to tackle as a prerequisite for this.

Yeah it just seemed really weird/surprising to me (in the sense of
'principle of least surprise') to put that in scripts/ and it doesn't seem
that traditionally anything else like this lives there.

But if you guys feel strongly enough I can put it there.

And agreed probably a 'third place' is the right way, but probably not
right as part of this series :)

>
> --
> Cheers,
> Nathan

--
Cheers, Lorenzo
