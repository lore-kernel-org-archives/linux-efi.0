Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFC53164C7;
	Sat, 19 Sep 2026 17:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789837580; cv=none; b=GKTk19J5BOgVJCIPYg99/jSc86GW0VrKQh2f6Z9jqd+FqQqX8IvvywOh+U2VHUdr4kfwKA1j5vKTKLTOHi50gkKHpfGtslsmGOLE+shMuXhA7+EsclfzP3OKRms/eVOf14+DRd1HCbSZu6M0cqNy2Go5+X4Hpev0kf4wm6++OtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789837580; c=relaxed/simple;
	bh=J1nL3c2S2TDGdiCXRCCzm300dW12yTfvI6c0W5rdv0o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7jSqqz10IjJklSxXvg7JDQC4V+Z0PIJsEUP8FR2gYLjAi+jdmcHJZWqRrcdO9dCPVuR5epKnYK7tURg5POJO+ytK1Y3Sae6OYnXO2A/rZ9kbXXHJc7nUU7S5sqc1Nx5K16PbrWm+OhjXUCBY+X+XXpKLS7c9uY8oHQRuwMyZpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuPE8ruS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuPE8ruS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8F61F000FF;
	Sat, 19 Sep 2026 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789837576;
	bh=cp7IEETulhNNvTomwaQYYTkvWo5Eqhoj/wXmKoaFO4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MuPE8ruSDiY+vr36+JeUGuYdOnALa5QKrisi/BG1HaQa0xVradFpJv3oMaHTUZvIm
	 0Tm7pchQtDyar6Vd6MHTsOi/mbklaLyyfkIXrQenVx4rBCJIqsWJ4tlQ3bdSxQVoLf
	 s8u/0m7VN/uL0RdpAYtWIqGng7og3enVKJ6/vhiRURiipRleoi3sqA8ferDExbCxwJ
	 osJCO63da0Qo4R804Nxj2mWG5ihhWKifsa7vcTLWitso6eItpA5WbK4qLlKLpMrwo7
	 5pyWG0bGQyuwjT+HrRDkEs9k7SYKBJ2cgCnmAhUmdAvZwosbUc9tV67xLFAr3oTOFL
	 d4llrSotsYqhQ==
Date: Sat, 19 Sep 2026 18:06:01 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
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
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 09/20] kbuild: implement and use depcheck to check
 dependency timestamps
Message-ID: <aq7AwXTJyJF3tVh0@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-9-9ecf4163ff36@kernel.org>
 <202609171117.35BFDCC13@keescook>
 <aq6-KMkAx7q_xLO4@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq6-KMkAx7q_xLO4@gremlin>

On Sat, Sep 19, 2026 at 05:57:36PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 17, 2026 at 11:42:50AM -0700, Kees Cook wrote:
> > > [...]
> > > +static const struct dep *lookup_dep(const char *path)
> > > +{
> > > +	const unsigned int key = hash_str(path);
> > > +	struct dep *dep;
> > > +	struct stat st;
> > > +
> > > +	hash_for_each_possible(dep_table, dep, hnode, key) {
> > > +		if (!strcmp(dep->path, path))
> > > +			return dep;
> > > +	}
> > > +
> > > +	dep = xmalloc(sizeof(*dep) + strlen(path) + 1);
> > > +	strcpy(dep->path, path);
> > > +	dep->exists = !stat(path, &st);
> > > +	if (dep->exists)
> > > +		dep->mtime = st.st_mtim;
> >
> > I realize you only check "mtime" after an "exists" check, but I bristle
> > at leaving a time-stamp uninitialized. Can we just add an "else
> > dep->mtime = 0" here?
>
> Ack, done for v4!

Actually I think it's nicer to just make this xmalloc() an xcalloc() here,
dep->mtime is a struct timespec and setting that to zero gets ugly :)

>
> >
> > -Kees
> >
> > --
> > Kees Cook
>
> --
> Cheers, Lorenzo

--
Cheers, Lorenzo
