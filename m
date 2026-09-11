Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D1225776;
	Fri, 11 Sep 2026 10:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789122200; cv=none; b=ACIfmTGYrrtk0hcEzmRraUgDP2IFuxD/3RprG1OiN8N+EKpRE7U9ucT1CZbX/yLXEEVApro+VamNLjLB2xteacd7VKTw0VzJ6ht8JzOiTeHXxAjohiMxBo22St4I3WpMkEFFyVYLa0jGgQG+fobpi136QUEabLp/ZZH0PMcNcto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789122200; c=relaxed/simple;
	bh=HIFlS1LY1mC5BFrUNBFgOTON86ZtDR4pEglNBgmIAog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TUVd8NSxXKPr2hc3w+njRaTvSCY48YzIVpr1vL31JtKvPz01ytxy6uGrQgmdRQGEhhuaFSiHY93oT66hmVozPy+wq0PqKEnZGVghsXjlrU7ohO05DM2swI+ceOG8kQQh4cctNDQEkt+5VJjz94woXVM5N5QcFuQOdKx1He03//Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YHie+TAs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YHie+TAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821D71F000FF;
	Fri, 11 Sep 2026 10:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789122198;
	bh=8ECrevmQ6/PJeWeSr3u1OcXApUW19sxOeBWTobGlU0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YHie+TAswX/1aTgWgK4V8FqGIGQyk2pjS1A1OkW+sR0kayG1RAqxnwsXqUbCxOAQO
	 2dCSLuBLe93EhOuUc1H6hVk8Q7GPwn2vEnK7YUsPr3zY3BNR7W6PoedUmczYZgRt9z
	 Kon71kSs6gBnP6mZcl5cYeaKUE5eIx3Yr2SpiPUx88wPRcRPwK8EI4sBinltZjzYl8
	 7Grhprcd+aZsmUWiFAZysee/k9upqETMTRXWHXu5Q4rnmHbelj8dby6YhhkhhRA9Oj
	 3XTQgtbwjesb4obq4GOE9nLymizEPZc7kSxnFGKA/fGWycbu/zhjw8uC2ClK7m1O77
	 PF0cGOECPDBGw==
Date: Fri, 11 Sep 2026 11:23:04 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
Subject: Re: [PATCH 16/23] kbuild: batch module finalisation
Message-ID: <aqPWcnRVABgH0V8t@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-16-5dc1ac01672d@kernel.org>
 <20260910-nondescript-fierce-wapiti-de1cea@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-nondescript-fierce-wapiti-de1cea@l-nschier-aarch64>

On Thu, Sep 10, 2026 at 05:48:53PM +0200, Nicolas Schier wrote:
> On Tue, Sep 08, 2026 at 09:55:16PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Module finalisation on allmodconfig builds consists of a large number of
> > very short-lived jobs, and the make job dispatcher cannot possibly dispatch
> > jobs fast enough.
> >
> > For allmodconfig x86-64 this can be on the order of ~22,000 jobs of a few
> > milliseconds in duration each.
> >
> > However per-job cost grows with the variables the instance holds, here the
> > savedcmd_* of every .mod.o and .ko read back from the .cmd files, since it
> > walks them all to build each child's environment.
> >
> > This makes module finalisation very inefficient when large numbers of
> > modules are being built.
> >
> > Fix this by splitting modules.order into chunks of 128 at a time, run in
> > parallel.
> >
> > Each instance holds only its own modules' variables and the top-level one
> > reads no per-module .cmd files at all, the same rules serve both levels,
> > and an instance is told its chunk with modfinal-first=<index>.
> >
> > "make modules" with every *.mod.o and *.ko deleted goes from 28.9s to 15.9s
> > with clang 22. No-op "make modules" goes from 5.6s to 4.8s, as checking the
> > 22,000 targets is spread over the chunks too.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 allmodconfig, no-op make, gcc         1.9s     1.2s    -0.74s (-39%)
> >   x86 allmodconfig, no-op make, clang       2.4s     1.6s    -0.77s (-32%)
> >   x86 allmodconfig, clean, gcc            304.5s   291.4s     -13.1s (-4%)
> >   x86 allmodconfig, clean, clang          301.7s   297.0s     -4.7s (-2%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  scripts/Makefile.modfinal | 26 +++++++++++++++++++++++++-
> >  scripts/mod/sumversion.c  |  4 ++--
> >  2 files changed, 27 insertions(+), 3 deletions(-)
> >
> > diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> > index 75e9effdf02c..858fa798090b 100644
> > --- a/scripts/Makefile.modfinal
> > +++ b/scripts/Makefile.modfinal
>
> [...]
> > diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
> > index 2cbadd3cd97d..5501d6aa0bea 100644
> > --- a/scripts/mod/sumversion.c
> > +++ b/scripts/mod/sumversion.c
> > @@ -249,7 +249,7 @@ static int parse_comment(const char *file, unsigned long len)
> >  /* FIXME: Handle .s files differently (eg. # starts comments) --RR */
> >  static bool stop_char[256];
> >
> > -static void init_stop_chars(void)
> > +static void sumversion_init(void)
> >  {
> >  	static bool done;
> >  	int chr;
> > @@ -274,7 +274,7 @@ static int parse_file(const char *fname, struct md4_ctx *md)
> >  	len = strlen(file);
> >  	if (!len)
> >  		goto out_file;
> > -	init_stop_chars();
> > +	sumversion_init();
> >  	buf = xmalloc(len); /* File output buffer. */
> >
> >  	for (i = 0; i < len; i++) {
> >
> > --
> > 2.55.0
> >
>
> (I have only skimmed through, not yet reviewed this patch.)
>
> The change in sumversion.c seems to be wrong here.

Ugh yeah this is a merge conflict artifact that I thought I had fixed but
clearly not :) Will fix up on respin.

>
> --
> Nicolas



--
Cheers, Lorenzo
