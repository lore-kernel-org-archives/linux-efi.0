Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA6337DEB5;
	Mon, 14 Sep 2026 19:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789415062; cv=none; b=FJ/89jlq8QuVwqsewigpzRc6lsFiY51+e/BStOxmiLbX6kAmUBb9jIwQzbQnpyaX/SZuAbqdjx/HN6Ol+XqREJXZ8CK5NYJya5BkPaXr4yfWuvYiFMIJdN0gv8DfTlvGG6XmW/UWytvb1DBm5qFdTpNJfCV/4aiO8Hlx7eqIXo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789415062; c=relaxed/simple;
	bh=ti730hswioEnORd+T1M71+ijIsAXicoqvmkG3id3SrY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7Re57Vvhn1gH3IuNvTpkSKu1SQzkmP9PTucNCdjwuNF/D6ong0DGCEpjzFjibDpej/gTI2uZr9IIf5kaRno68adtWnj6/mJFFh7INxyP3tRrhBKA/m3DgTHJDDXCyowWi71I3bQyNnCCJSiIP94MqlEzR9I2CPvBKP9TMMdsSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSVXXg/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSVXXg/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606951F000FF;
	Mon, 14 Sep 2026 19:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789415057;
	bh=dEVqT/wbNr31VyaEi+ztvayta7Xn2Rd4Y437aZNZCvc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MSVXXg/qNgC9jq49BVmWZXFQh+9kpMKjQO+QRQUfSbv6WEMmHAyi1VR8/qhBIc5Mk
	 FfzjtS+MXmB1xdh0Yyyh/Fjgp0ghmpwSXzQ0HEfDW+auxGwVSYmxpW4HB3r7VPvk5x
	 ErOLy9eT8sBkMrdbsQGLv17beikH75L4sttmQL+HW5l2DD14MHccpS79cnl93N3Kgj
	 YcoOTrNJBTL7kKo32pNKgOEHALdfPOmaxCkbBoOVpON2WHEvSq+bZqYcfQk2AIBKMG
	 u5i84u03A14NXZUXVTa7uw2gHUp7GtggszhR53KXX6mdi43GlMuW9bZTSp2IMAiwQt
	 MtZMVAIfFDB2g==
Date: Mon, 14 Sep 2026 12:44:13 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
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
Message-ID: <aqhLhVMkNzf_4oJw@jpoimboe>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-15-39817ec5db23@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260914-build-speedup-v2-15-39817ec5db23@kernel.org>

On Mon, Sep 14, 2026 at 10:22:14AM +0100, Lorenzo Stoakes (ARM) wrote:
> +static struct reloc *find_reloc_sorted(struct section *rsec,
>  				       unsigned long offset, unsigned int len)
>  {
> -	struct reloc *reloc, *r = NULL;
> -	struct section *rsec;
> -	unsigned long o;
> +	struct reloc *relocs = rsec->relocs;
> +	const unsigned int nr_relocs = sec_num_entries(rsec);
> +	const unsigned long cache_idx = reloc_cache_index(offset);
> +	unsigned int reloc_idx, i;
>  
> -	rsec = sec->rsec;
> -	if (!rsec)
> +	if (cache_idx >= reloc_cache_nr_windows(rsec))
> +		return NULL;
> +
> +	reloc_idx = rsec->reloc_cache[cache_idx];
> +
> +	/*
> +	 * Scan through all relocations covered by cache entry to find the
> +	 * first at or after offset. Relocations are sorted by offset.
> +	 */
> +	for (i = reloc_idx; i < nr_relocs; i++) {
> +		struct reloc *reloc = &relocs[i];
> +		const unsigned long curr_offset = reloc_offset(reloc);
> +
> +		if (curr_offset >= offset)
> +			break;
> +
> +		reloc_idx++;
> +	}
> +
> +	/* Nothing found, or the first candidate lies beyond the range. */
> +	if (reloc_idx >= nr_relocs ||
> +	    reloc_offset(&relocs[reloc_idx]) >= offset + len)
>  		return NULL;
>  
> +	/* If there are duplicate entries, return the last. */

Hm, for consistency with the others, shouldn't this be returning the
*first* match?

> +/* If there are multiple matches, return the first one in the range. */
> +struct reloc *find_reloc_by_dest_range(const struct elf *elf, struct section *sec,
> +				       unsigned long offset, unsigned int len)
>  {
> -	return !strncmp(sec->name, ".debug_", 7);
> +	struct section *rsec = sec->rsec;
> +
> +	if (!rsec)
> +		return NULL;
> +
> +	if (rsec->sorted)
> +		return find_reloc_sorted(rsec, offset, len);
> +
> +	if (rsec->hashed)
> +		return find_reloc_hash(elf, rsec, offset, len);
> +
> +	return find_reloc_linear(rsec, offset, len);

I'm not sure there's much benefit in having two fallbacks (hashed +
linear) instead of one.  If the vast majority of reloc sections are
sorted, then hopefully a single (linear) fallback would be fine,
assuming no major performance regressions.  That would help contain the
complexity.

BTW, I found another initialization bug: klp-post-link.c uses
elf_create_section() to create a reloc section, so it missing the
initialization of rsec->hashed in elf_create_rela_section().  But that's
moot if we just get rid of the hashing.

-- 
Josh
