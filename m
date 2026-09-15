Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093A54AA41D;
	Tue, 15 Sep 2026 12:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789474800; cv=none; b=jDoSWggbbGOWhiMjXEq9Zcr7Om1ghdciFjMEwPtbink+Clr5X86173UjfgPIw3XtSXud9CsEd1kzY6A90GKMXSecvlsbbj1n//88prFlBBuOyqm7JdPqRBHSdCkc+Es+rUnqvnIgF1yFmNMryiGfYS0d1PnYC5mAbQ/z1GXXeGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789474800; c=relaxed/simple;
	bh=ghiprE2YXma8S3nktjyL8fwG3J/XUPLemnD4oo5P+kE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNAPtXNQUXG+FxAbTDadVNDEWX5vBZRlDbdqmIDsdBnljxT/AOch3u40OE2Xe4pahBnZAUShtQft1gZsUna8+hiWLAk1p04YtrIdKYCknHu/3hYNBl0U7jg6GaEsQQV+VFgBB+xgU5hc4v2tP7GjPfIkcluaJYh2SVh3xvfQGaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aJkjiwac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aJkjiwac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB21F00898;
	Tue, 15 Sep 2026 12:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789474798;
	bh=irsOopNYGA95wlUnsSfuDWFIZCHRgYLO94HlrHa0Li4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aJkjiwacf+E3+/VX3Ka0dJYUKcDcH/WmCT2qlONGQk7th6drv0kb35aefPiv70I4r
	 j5cnblmWg1FLPE25yvXTuNiBzpXaORmzEC00G/PiZdjagcizt5UJp/wddBuoarohnF
	 0wqSuq1R4tT5ve05rzDzt7Kf2M0fA4X8wRpWYrkRf+ggUA2fQhajxQ5O+MHIMmPAmf
	 PRuDgCNO2h823BwR7J1Dj+xleC5rdQxAN27QkF5/NI1pCJXdSI6Hk2HYlelyx+6kpc
	 0Ln3Ink87xvrVta5mpAcqlIPk3cST0i9+D8zpl+tcyBuss5WdoiZCBIv1/oEhGZet8
	 ABWELFo9uzCrQ==
Date: Tue, 15 Sep 2026 13:19:47 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Peter Zijlstra <peterz@infradead.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 15/21] objtool: cache relocations, do less work
Message-ID: <aqk2bTOw_Scb8spw@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-15-39817ec5db23@kernel.org>
 <aqhLhVMkNzf_4oJw@jpoimboe>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqhLhVMkNzf_4oJw@jpoimboe>

On Mon, Sep 14, 2026 at 12:44:13PM -0700, Josh Poimboeuf wrote:
> On Mon, Sep 14, 2026 at 10:22:14AM +0100, Lorenzo Stoakes (ARM) wrote:
> > +static struct reloc *find_reloc_sorted(struct section *rsec,
> >  				       unsigned long offset, unsigned int len)
> >  {
> > -	struct reloc *reloc, *r = NULL;
> > -	struct section *rsec;
> > -	unsigned long o;
> > +	struct reloc *relocs = rsec->relocs;
> > +	const unsigned int nr_relocs = sec_num_entries(rsec);
> > +	const unsigned long cache_idx = reloc_cache_index(offset);
> > +	unsigned int reloc_idx, i;
> >
> > -	rsec = sec->rsec;
> > -	if (!rsec)
> > +	if (cache_idx >= reloc_cache_nr_windows(rsec))
> > +		return NULL;
> > +
> > +	reloc_idx = rsec->reloc_cache[cache_idx];
> > +
> > +	/*
> > +	 * Scan through all relocations covered by cache entry to find the
> > +	 * first at or after offset. Relocations are sorted by offset.
> > +	 */
> > +	for (i = reloc_idx; i < nr_relocs; i++) {
> > +		struct reloc *reloc = &relocs[i];
> > +		const unsigned long curr_offset = reloc_offset(reloc);
> > +
> > +		if (curr_offset >= offset)
> > +			break;
> > +
> > +		reloc_idx++;
> > +	}
> > +
> > +	/* Nothing found, or the first candidate lies beyond the range. */
> > +	if (reloc_idx >= nr_relocs ||
> > +	    reloc_offset(&relocs[reloc_idx]) >= offset + len)
> >  		return NULL;
> >
> > +	/* If there are duplicate entries, return the last. */
>
> Hm, for consistency with the others, shouldn't this be returning the
> *first* match?

Ack you're right.

It was pedantically trying to recreate what the hash did exactly but no section
has two relocations at one offset anyway, so have updated to return the first
and removed the special casing.

>
> > +/* If there are multiple matches, return the first one in the range. */
> > +struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
> > +				       unsigned long offset, unsigned int len)
> >  {
> > -	return !strncmp(sec->name, ".debug_", 7);
> > +	struct section *rsec = sec->rsec;
> > +
> > +	if (!rsec)
> > +		return NULL;
> > +
> > +	if (rsec->sorted)
> > +		return find_reloc_sorted(rsec, offset, len);
> > +
> > +	if (rsec->hashed)
> > +		return find_reloc_hash(elf, rsec, offset, len);
> > +
> > +	return find_reloc_linear(rsec, offset, len);
>
> I'm not sure there's much benefit in having two fallbacks (hashed +
> linear) instead of one.  If the vast majority of reloc sections are
> sorted, then hopefully a single (linear) fallback would be fine,
> assuming no major performance regressions.  That would help contain the
> complexity.

Ack, and it turns out we don't even need to fallback for growth either after all
- relocations objtool appends actually arrive in offset order anyway.

So we can indeed just get rid of the hash entirely :)

So now v3 fallbacks to linear if there's anything out of order (belts + braces
I'm not sure anything will do that now actually but good to have to be safe),
annnd no hash :)

Have tested locally and confirmed output is byte-identical for vmlinux.o for
gcc/clang allmodconfig and defconfig, also tested klp-build and that's all
working too for livepatch stuff.

>
> BTW, I found another initialization bug: klp-post-link.c uses
> elf_create_section() to create a reloc section, so it missing the
> initialization of rsec->hashed in elf_create_rela_section().  But that's
> moot if we just get rid of the hashing.

Thanks, with the hash gone that's now moot as you say :)

>
> --
> Josh

--
Cheers, Lorenzo
