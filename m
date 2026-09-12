Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA829353EF7;
	Sat, 12 Sep 2026 22:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789253259; cv=none; b=LhY/6Di1ShqkCJwmKe2njc2UivAZfq2bqrgyqrGg9zd0D1jE+3AR2BujVulhflqwxLYOH35nCUzY/YqSi8T1775lZlIWgV7fbf+Yjk+6jpRvGZGaKRZFnWlkLQByDxqzZpxOLSi3jXF5+zgPZV3chvp02Ndt2CP3n35ofv1KfY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789253259; c=relaxed/simple;
	bh=WhpKhnaimmiDMo+7z3TyZxw7aAekk9TUYm3OZVPStwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RdxGMy4M6iEisGH3D5UO+INk8CTO8YCVD9/oh/YnLcdogOCTdCReZXvnK5zfuIlMEelYL/LsCggsIP65tFE6LoORuqAiGexI50V1rTt2bkSDSXp8X5l+VAHNCN1nrmeWd46R9Cwt33brImFoFP1AqL36pu+G+s1+N+A4DTDpMd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4ZfcMFm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4ZfcMFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7215B1F000FF;
	Sat, 12 Sep 2026 22:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789253257;
	bh=YTs0RHzOBARO9Zxd/72JxEwAoUlFgRlD7PJM9ViCXyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e4ZfcMFmvfYKUh71LAPoMcJrwB+EauX2idSlHvlrc7/TcwWF4y4so18J/fbY5lXYi
	 R7U55xnaXLAON7/zdmlPVdNgwj6zPMq1L2fBY8yKvOCgRckwkR0KzQNa2gxGw7uFfA
	 wm2T2BsSDlRNJ4H1wIXuFyyLsOUX42JzfBTZ57ZX668HEN5yhgzUyOYlE/vi9rRF1e
	 wxNzTDgBlwyw4kYH+U2DPdRNeBPA1JL+8gr8GbujAgHSSmzPofsMXi7mlmK5MX4lQM
	 Q9YMH4vqdH97Z9EK53Aaj452z+/sBIpyi8GFKK13J3KjBc/JY1me3oHi5xO3iHRUE4
	 jKTcBOzWYivwQ==
Date: Sat, 12 Sep 2026 15:47:33 -0700
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
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 18/23] objtool: cache relocations and function dead end
 state, do less work
Message-ID: <aqW4klkDI2P0aUn5@jpoimboe>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-18-5dc1ac01672d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908-build-speedup-v1-18-5dc1ac01672d@kernel.org>

On Tue, Sep 08, 2026 at 09:55:18PM +0100, Lorenzo Stoakes (ARM) wrote:
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                          before   after     delta
>                                          -------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        8.4s     8.1s    -0.28s (-3%)
>   x86 defconfig, touch mm/vma.c, clang      7.5s     7.1s    -0.41s (-5%)
>   x86 defconfig, clean, gcc                27.1s    26.8s    -0.34s (-1%)
>   x86 defconfig, clean, clang              26.6s    26.2s    -0.40s (-1%)
>   x86 allmodconfig, touch mm/vma.c, gcc    30.2s    28.4s     -1.8s (-6%)
>   x86 allmodconfig, touch mm/vma.c, clang  28.1s    26.0s     -2.1s (-7%)

Nice!

> @@ -305,7 +305,15 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
>  
>  static bool dead_end_function(struct objtool_file *file, struct symbol *func)
>  {
> -	return __dead_end_function(file, func, 0);
> +	if (!func)
> +		return false;
> +
> +	if (!func->dead_end_known) {
> +		func->dead_end = __dead_end_function(file, func, 0);
> +		func->dead_end_known = 1;
> +	}
> +
> +	return func->dead_end;
>  }

This bit seems like it should be a separate patch.  Though actually, it
can just be dropped as I have something similar brewing:

  https://lore.kernel.org/9d4b8ccfed745ac47a954aa2e1de62a85197122d.1788899473.git.jpoimboe@kernel.org

> -struct reloc *find_reloc_by_dest(const struct elf *elf, struct section *sec, unsigned long offset)
> +/* Should never be invoked, provided as a backstop. */
> +static struct reloc *find_reloc_linear(struct section *rsec,
> +				       unsigned long offset, unsigned int len)
>  {
> -	return find_reloc_by_dest_range(elf, sec, offset, 1);
> +	struct reloc *reloc, *first = NULL;
> +
> +	WARN("%s: linear scan for sec %s with %u relocs at offset %lu len %u",
> +	     __func__, rsec->name, sec_num_entries(rsec), offset, len);

Won't this be triggered for sections created with
elf_create_rela_section()?  I don't see where they set rsec->hashed.

> @@ -1147,6 +1307,28 @@ static int read_relocs(struct elf *elf)
>  
>  		rsec->base->rsec = rsec;
>  
> +		/* DWARF relocs are never looked up. */
> +		if (is_dwarf_section(rsec->base))
> +			continue;
> +		if (reloc_sec_in_order(rsec)) {
> +			rsec->sorted = true;
> +			continue;
> +		}
> +
> +		rsec->hashed = true;
> +		nr_hashed += sec_num_entries(rsec);
> +	}

Hm, I'm not sure whether hashing is even still needed, as compilers
generally emit sorted relocs.

> @@ -1592,6 +1799,7 @@ static int elf_alloc_reloc(struct elf *elf, struct section *rsec)
>  	}
>  
>  	rsec->nr_alloc_relocs = nr_alloc;
> +	copy_reloc_cache_to_hash(elf, rsec, nr_relocs_old);

Not all relocation appends go through this allocation code path.
It can return earlier in this function if the space has already been
allocated previously.  So this call probably belongs in
elf_create_reloc().

-- 
Josh
