Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238A37F006;
	Fri, 16 Oct 2026 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792169099; cv=none; b=IqtqERFyZZTi/0MmwoCtAyyw/kSthJSDHXzLeXgAdk2dTfu9MAwKYF645zjWeRYjeOndb40+q9D15jxY+FkRxvs9QUpvzSAnHUn/j3QZGXVb/MbwRYVBiDlGV2UUDT8KofsoYrsr5afKVerRHzXN0ImHy9vyJyX6UckFUGOmtAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792169099; c=relaxed/simple;
	bh=VfWTephl8pf2SRTSLnrpj8mX4tB8jBBntqEfoI1/V+o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RQH3QsGttsBsP7Sw4+/wgDvQ4Pvw35HjbF945M0dj1YZiO3oDLiM5uQ++e1wgPHVvywDnVz3n2jBDHwh5YMHHCytm8IGkY864VIj2vyNJEtTJ7PBSGuXWnk9BO4dSJXbUFCoIzBEQUVOkeiSfj/Mf4GS4RCUkU28ViuSJAngyus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHEARvLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHEARvLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C781F000C5;
	Fri, 16 Oct 2026 16:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792169097;
	bh=k2PPYvoZtUDSB0QpI8y8nVKIfHe5I595bZB7KIFYEN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZHEARvLfZu4O/g6Nyh0bXYaTzR2KpzPxcMjSlF8WaiY/AYMp8ZUEmePIH0x36U+AV
	 dkGwRrXAcFPcowGe92stgaKYD7QbEfeew/4welqoD2TdO8E3G7pWh4Akq9DgiIX+yY
	 y7j2qTukGvCvUuXxqMnQU8W0m4veYSXueEI9aC/y0saah/MBrQvwOds90nNz56BGRz
	 +QdA3dTRZZDcbLU9t9fTB+48//FTEt8/i35gzhvPAtyFMgY64PRofFRMPgv6Ez/dmW
	 OX3dQA2Arl+QnBRQMKaCABNa+ahDxt+2Czw0mPgyVccH7WW3sgmmy1U8zy7PM0Rdoo
	 WUGmNlCnL+E9g==
Date: Fri, 16 Oct 2026 17:44:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
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
	Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 13/22] modpost: cache section relocation mismatch state
Message-ID: <atJSEhfOu-LWWHr_@gremlin>
References: <20260923-build-speedup-v4-0-73128809a4a4@kernel.org>
 <20260923-build-speedup-v4-13-73128809a4a4@kernel.org>
 <d17b00f9-2a6c-425f-9697-6bc8f31f7a7a@suse.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d17b00f9-2a6c-425f-9697-6bc8f31f7a7a@suse.com>

On Thu, Oct 15, 2026 at 05:42:45PM +0200, Petr Pavlu wrote:
> On 9/23/26 7:18 PM, Lorenzo Stoakes (ARM) wrote:
> > For every relocation modpost invokes check_section_mismatch() to determine
> > whether there is any kind of mismatch between the source and destination,
> > and if so which classification applies.
> >
> > Each time it does this it invokes section_mismatch() which iterates
> > through the sectioncheck[] array every time it's called.
> >
> > When walked a relocation section the source is fixed and there aren't many
> > targets, so the same names are looked up over and over again.
> >
> > Therefore cache not only mismatch categorisation but also whether a
> > mismatch even exists for a given section and look up the sections in the
> > cache.
> >
> > Special indices (undefined, absolute, common) take the uncached path as
> > before.
> >
> > This results in very significant speed ups for allmodconfig incremental
> > builds.
> >
> > modpost is on the serial tail of every build that links vmlinux.
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 defconfig, touch mm/vma.c, gcc        8.5s     8.3s    -0.14s (-2%)
> >   x86 defconfig, touch mm/vma.c, clang      7.7s     7.6s    -0.13s (-2%)
> >   x86 allmodconfig, touch mm/vma.c, gcc    33.9s    29.4s     -4.5s (-13%)
> >   x86 allmodconfig, touch mm/vma.c, clang  31.9s    27.9s     -4.0s (-13%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> This looks mostly ok to me. Below are some nits you might want to
> consider addressing.

Thanks! :)

>
> > ---
> >  scripts/mod/modpost.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 64 insertions(+), 2 deletions(-)
> >
> > diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> > index 75374c64b8cc..0fd43c8a89ea 100644
> > --- a/scripts/mod/modpost.c
> > +++ b/scripts/mod/modpost.c
> > @@ -1155,12 +1155,67 @@ static void check_export_symbol(struct module *mod, struct elf_info *elf,
> >  			 name);
> >  }
> >
> > +/*
> > + * mismatch_cache[section index] ->
> > + *   0 - uncached.
> > + *  -1 - no mismatch.
> > + *  >0 - mismatch index + 1.
> > + */
> > +static int *mismatch_cache;
>
> It might be cleaner to maintain this cache per elf_info, since it
> logically belongs to the processing of an individual ELF file. This
> would also be consistent with the existing symsearch cache, which uses
> elf::symsearch.

Ack, makes sense, moved the decl inside elf_info.

>
> The description could use 'to_secndx' instead of 'section index' to
> clarify whether it refers to the source or destination section of
> a relocation.

Ack, updated for v5.

>
> > +
> > +static void init_mismatch_cache(unsigned int num_sections)
> > +{
> > +	mismatch_cache = xcalloc(num_sections, sizeof(*mismatch_cache));
> > +}
> > +
> > +static void reset_mismatch_cache(unsigned int num_sections)
> > +{
> > +	memset(mismatch_cache, 0, num_sections * sizeof(*mismatch_cache));
> > +}
> > +
> > +static void free_mismatch_cache(void)
> > +{
> > +	free(mismatch_cache);
> > +	mismatch_cache = NULL;
> > +}
> > +
> > +static const struct sectioncheck
> > +*cache_mismatch(unsigned int secndx, const struct sectioncheck *mismatch)
>
> Similarly here, s/secndx/to_secndx/.

Ack, done.

>
> > +{
> > +	if (!mismatch) {
> > +		mismatch_cache[secndx] = -1;
> > +		return NULL;
> > +	}
> > +
> > +	mismatch_cache[secndx] = (mismatch - sectioncheck) + 1;
> > +	return mismatch;
> > +}
> > +
> > +static const struct sectioncheck *get_section_mismatch(const char *fromsec,
> > +		const struct elf_info *elf, unsigned int secndx)
>
> s/secndx/to_secndx/, and the fromsec and elf arguments could be swapped
> for consistency with the rest of the code.

Ack, done.

>
> > +{
> > +	int cached;
> > +
> > +	if (secndx >= elf->num_sections)
> > +		return section_mismatch(fromsec, sec_name(elf, secndx));
> > +
> > +	cached = mismatch_cache[secndx];
> > +	if (cached < 0)
> > +		return NULL;
> > +	if (cached > 0)
> > +		return &sectioncheck[cached - 1];
> > +
> > +	return cache_mismatch(secndx,
> > +			      section_mismatch(fromsec, sec_name(elf, secndx)));
> > +}
> > +
> >  static void check_section_mismatch(struct module *mod, struct elf_info *elf,
> >  				   Elf_Sym *sym,
> >  				   unsigned int fsecndx, const char *fromsec,
> >  				   Elf_Addr faddr, Elf_Addr taddr)
> >  {
> > -	const char *tosec = sec_name(elf, get_secindex(elf, sym));
> > +	const unsigned int to_secndx = get_secindex(elf, sym);
>
> The const qualifier can be dropped from the to_secndx definition to
> match the usual kernel style.

Ack, done.

>
> --
> Thanks,
> Petr

Thanks for the review!

--
Cheers, Lorenzo
