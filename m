Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87BE34F474;
	Thu, 17 Sep 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667136; cv=none; b=rVlp+5sIr6y22WdAxdLPjMlwL4Db0UHGoWyAsZ6nj/BF/3Y/ojWhtw1sKK5rdXsD9NA3T1BZu5H+bi6ZMx/ED2eJqSDUmWJYpd3pwtxNlxcyfHIe51YIM0gxmn9GBkIul70pxFnBkA+mNb58Vt0Gd0hCohaJ3bEaVA+KdQfNWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667136; c=relaxed/simple;
	bh=ZFNcVemUd5TTIgA5fEcaE69ZFOXNqQnOTSKr2hMzmg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JeWPGSefzqX6dZoxTP7NonkrwWszT+EbBQLfNe3Yjs7PYyOniuoC8kJN0i1PS6BTXcg9ZbsAoXU8gNWT1yYuvONBxTDzte/SLbyWlUYtLvJDwPnLTH8EciJ8sXk+S96j3vCgN3H9TVCDlSCFAwKf8OgpzVLriu5uP8T/gNXeZNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nwVYzVYc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nwVYzVYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3749E1F000FF;
	Thu, 17 Sep 2026 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789667134;
	bh=/67ejzYXgxSwTNvDwid/KxkPY4CobchRa5W9WA5tfWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nwVYzVYcDBJJuvbcsETvIfvZwQseDq4uN7MKCanumUo5HnLpTIA6cHQ0mqGwkTeCj
	 cMI4P3VX6x5KAD2napX8cdbanbG7b55YOTMHnzb9mYhh3NSOGQ5tua7RV/J2czUk6B
	 WZo9E+25y/wQIArtKgRMyvcb/WpgfJ+W6TlL8tEPyK4w7HsqgxuGwEu+FT71PF4L9a
	 /B8E8mRyeqDZfn0CKv8NyuO6fVrSAO/1wQrbDvwm6UGoO+BLAv2I9aQbKBwblIi+cr
	 lIgLcbq+HCyAMUML6/47H8N/73feOraDVNo+lB6sKLxXzzUUYvBTf5S5hf7vDkjI13
	 9KYGO2xl+Aagg==
Date: Thu, 17 Sep 2026 18:45:19 +0100
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
Subject: Re: [PATCH v3 02/20] kallsyms: index symbols by token to speed up
 table compression
Message-ID: <aqwmdL1jbfPczpbU@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-2-9ecf4163ff36@kernel.org>
 <202609171019.5DD874E@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609171019.5DD874E@keescook>

On Thu, Sep 17, 2026 at 10:27:32AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:12PM +0100, Lorenzo Stoakes (ARM) wrote:
> > diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
> > index 494852ade6d8..350d118c3b9e 100644
> > --- a/scripts/kallsyms.c
> > +++ b/scripts/kallsyms.c
> > @@ -58,12 +58,47 @@ static unsigned int table_size, table_cnt;
> >  static int all_symbols;
> >  static int pc_relative;
> >
> > +/* A dynamic array of symbols, encoded by symbol index. */
> > +struct sym_arr {
> > +	unsigned int *sym_indexes;
> > +	unsigned int cnt, cap;
> > +};
> > +
> >  static int token_profit[0x10000];
> > +static struct sym_arr token_syms[0x10000];
>
> Nit: since you're refactoring too, can 0x10000 be a #define so it's not
> open-coded 3 places? (find_best_token() uses the value too, though
> arguably it should actually just use ARRAY_SIZE(token_profit) instead).

Sure, will do!

And yeah ARRAY_SIZE() makes sense there also.

>
> > [...]
> > -static void compress_symbols(const unsigned char *str, int idx)
> > +static void compress_symbols(const unsigned char *str, int compressed_chr)
> >  {
> > -	unsigned int i, len, size;
> > +	const unsigned int token_idx = sym_token_index(str, 0);
> > +	struct sym_arr *arr = &token_syms[token_idx];
> > +	unsigned int sym_idx, j, len, size;
> >  	unsigned char *p1, *p2;
> >
> > -	for (i = 0; i < table_cnt; i++) {
> > +	/* Iterate through all symbols this token is found in and compress. */
> > +	for (j = 0; j < arr->cnt; j++) {
> > +		sym_idx = arr->sym_indexes[j];
> >
> > -		len = table[i]->len;
> > -		p1 = table[i]->sym;
> > +		len = table[sym_idx]->len;
> > +		p1 = table[sym_idx]->sym;
> >
> > -		/* find the token on the symbol */
>
> Why drop this comment? It's a little redundant to "find_token", but I
> always question comment _removal_ when it's not solving an inaccuracy.

Sometimes I lose track which bits are mine/the LLM's, but I don't love
comments that don't add all that much, and I also berate the LLM about
writing the literally worse comments I've ever seen in my life so could
have been either me or it...

Anyway, will restore!

>
> > [...]
> > @@ -536,11 +643,14 @@ static void compress_symbols(const unsigned char *str, int idx)
> >
> >  		} while (p2);
> >
> > -		table[i]->len = len;
> > +		table[sym_idx]->len = len;
> >
> > -		/* increase the counts for this symbol's new tokens */
>
> Same question here: the comment is still valid?

Ack will restore!

>
> Otherwise, looks good to me.
>
> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks!

>
>
> --
> Kees Cook

--
Cheers, Lorenzo
