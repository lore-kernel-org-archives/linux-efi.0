Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7492630E0D5;
	Thu, 10 Sep 2026 04:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789014041; cv=none; b=GqfaIrZtcrnY2ZaOg+dQJHyN1P7HIhHDm6keb3Bi2fEYTqvWX69xID3i3/fNzK1ZowPywJVpRiV8qfI4rdvynZH4QVW9alTCQBwFWUVys+gkeTLU9gx8O4NjAVQBcmxkSBbVqTSSmx3pTWX864sMVz4ynhR4aAID9tVIOO1OfKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789014041; c=relaxed/simple;
	bh=a5vCGhYhznJBlAMg4zpoxcfM/5J2iEIIOrHpjRAzbMw=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=X1qm6hdw8eZHVYIPpKagicbb/PsJo0Ry3TvnKuYmEIhYNrbvvqodZeS1EVlNqYsFrxpprQshc80ntqYnjxWQ4TrkGWD2qEM/6IjFcFKv5nsYyYvcHaWzDHEdl/0i+cBF2KAA/PkWNp5H0Mjp5fXKr7o7rtTje3C60hhjhoW4wTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbGauKZR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbGauKZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE1D1F00898;
	Thu, 10 Sep 2026 04:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789014039;
	bh=hkHaj3ZDY+GSiiQATaD5l0BDY5zlIy2Z0yK6RtmhmEw=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kbGauKZREquije9DUIiTkfeZg0qIjFXk2gcbTwlmC+7OtseDZctgB3M3HK1V2D81x
	 n3r9cLIbTPlFFkueISLJEGjql/IqWAnhXZ1j1ZzU3a/NaRxNjf3DvnvKhrKyhL7OIk
	 oS4EDj6blPSq5tgmLWRgRikxHXdtMg8AU4PKJLjdDGS3i1JBttxQr37jNhMl0aPD9W
	 Er0QhBk6mbH0lpgEqy/3CneXCNIBJ6qxXZEdEdd8buyYao7i2IO3ItR7snQuSf4Ew9
	 S7LJmPNpX+6K44V4HVaoUEXusz583gyhhUDa3Ez2uboX2AHQjj+VH+pwUjL7aPcHh6
	 RL7H57msT+0Ow==
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 09/23] kbuild: do not allocate .modinfo in vmlinux
From: Nathan Chancellor <nathan@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260908-build-speedup-v1-9-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-9-5dc1ac01672d@kernel.org>
Date: Wed, 09 Sep 2026 21:19:12 -0700
Message-Id: <178901395291.3971858.229822965899686230.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4511; i=nathan@kernel.org;
 h=from:subject:message-id; bh=a5vCGhYhznJBlAMg4zpoxcfM/5J2iEIIOrHpjRAzbMw=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFmL9I8nHrvkaPxN3ne7cs6Dons1x3siyrZP4+nb3N17W
 fVCwTnPjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARl3OMDI9djia9e6p1fv3C
 HuPmopkCPkZ7BDpj+kwvPGDPkFN/9peR4ajAj7uTPi8/1fz8Qc+TyH19LwrFHzgl/00KYAifJbW
 OmRsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

> Commit 3e86e4d74c04 ("kbuild: keep .modinfo section in vmlinux.unstripped")
> placed MODULE_INFO() strings in the .modinfo section in vmlinux.unstripped,
> however it left the section allocatable, so it gets assigned an address and
> on arm64, arm and riscv, the section is tagged as PT_LOAD.
> 
> This is useless as the data is ultimately stripped anyway.
> 
> Doing this results in a lot of unnecessary work - each pass copies the
> whole file, 450 MIB with relocations for an x86 allmodconfig build and 250
> MiB for an arm64 allmodconfig build.
> 
> This adds ~0.7s on the serial tail of every build for arm64 and ~0.2s for
> x86 (the tail is single-threaded work done after parallel work has
> finished).
> 
> Nothing requires .modinfo to exist at an address, so fix this by using
> --dump-section which prevents the allocation.
> 
> Image, bzImage, System.map and modules.builtin.modinfo are unchanged and
> the stripped vmlinux differs only in its program headers.
> 
> The objcopy passes are on the serial tail of every build that links
> vmlinux, no-op builds are unchanged.
> 
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                          before   after     delta
>                                          -------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        8.9s     8.8s    -0.16s (-2%)
>   x86 defconfig, touch mm/vma.c, clang      8.1s     7.9s    -0.20s (-2%)
>   x86 defconfig, clean, gcc                27.6s    27.5s    -0.13s (0%)
>   x86 defconfig, clean, clang              27.2s    27.0s    -0.18s (-1%)
>   x86 allmodconfig, touch mm/vma.c, gcc    42.0s    41.6s    -0.40s (-1%)
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index b2988aa12f66..7be9e0321867 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -855,7 +855,7 @@
>  		KLP_SYMID
>  
>  #define MODINFO								\
> -		.modinfo : { *(.modinfo) . = ALIGN(8); }
> +		.modinfo (INFO) : { *(.modinfo) . = ALIGN(8); }
>  
>  #ifdef CONFIG_GENERIC_BUG
>  #define BUG_TABLE							\
> diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
> index 4b54aaeca65d..1fc7a0ca8eaf 100644
> --- a/scripts/Makefile.vmlinux
> +++ b/scripts/Makefile.vmlinux
> @@ -90,11 +90,9 @@ remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel.*'
>  
>  remove-symbols := -w --strip-unneeded-symbol='__mod_device_table__*'
>  
> -# To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
> -# it is necessary to remove the PT_LOAD flag from the segment.
> +# none of the removed sections is allocated, so no segment is left empty

I think we could just drop this comment, I don't think it is
particularly helpful

>  quiet_cmd_strip_relocs = OBJCOPY $@
> -      cmd_strip_relocs = $(OBJCOPY) $(patsubst %,--set-section-flags %=noload,$(remove-section-y)) $< $@; \
> -                         $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $@
> +      cmd_strip_relocs = $(OBJCOPY) $(addprefix --remove-section=,$(remove-section-y)) $(remove-symbols) $< $@
>  
>  targets += vmlinux
>  vmlinux: vmlinux.unstripped FORCE
> @@ -103,21 +101,11 @@ vmlinux: vmlinux.unstripped FORCE
>  # modules.builtin.modinfo
>  # ---------------------------------------------------------------------------
>  
> -# .modinfo in vmlinux.unstripped is aligned to 8 bytes for compatibility with
> -# tools that expect vmlinux to have sufficiently aligned sections but the
> -# additional bytes used for padding .modinfo to satisfy this requirement break
> -# certain versions of kmod with
> -#
> -#   depmod: ERROR: kmod_builtin_iter_next: unexpected string without modname prefix
> -#
> -# Strip the trailing padding bytes after extracting .modinfo to comply with
> -# what kmod expects to parse.
> +# use --dump-section to include non-allocated sections

Same thing here, I am not sure anyone will question '--dump-section'
here. Otherwise, this seems reasonable. I was curious about the $@.tmp
until I read the objcopy manual but that probably is not worth a
comment.

I can probably take this one faster than the rest if you want to put it
early in the stack since it is pretty low hanging fruit and earlier it
gets exposure to -next, the better.

-- 
Cheers,
Nathan

