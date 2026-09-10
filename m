Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6772E3A9871;
	Thu, 10 Sep 2026 04:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789014032; cv=none; b=AeoSc+pD0J5Hpl2nc/ysCeQmUkqqrPEEiZnm97T7v7+gLaGqj5nqPe/CO/bByYM3gFVleMVDJAjLoI9wzIYsbKf9rPIyFcfmB0lTfs8gUVd11wVbv1zsxMEAl1/OsFQ09tujqV4OFVLRkcfhX8He7OhHYeo+055XvYhqnJossn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789014032; c=relaxed/simple;
	bh=1LFSzvqpCVNNJ9TQXhcT9L2wj+5Vsf0qujUp2w7rHOI=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=sbuy+hHztGfWmH4Y8+mTfCgV42X86wqRUXmB1qeigBPL4dusWpoFUECgPz/h9rn+bpjgbi++qZuoAoZs3jx2IeXzliKyiEvG0Ou9suSPHunxTvIa1J7+2iHbxgcdyR2bPGvjU8ZUX+zRQx7rX3SSprxWyjCed7M0fDntlA6LMhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWgIgGMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWgIgGMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BD31F00893;
	Thu, 10 Sep 2026 04:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789014029;
	bh=VKklRIsIxfcoqhL1bLbYjXtyVgG12YsgMkjcgJHF19w=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ZWgIgGMpyJn8Q23MKsmUyrNiPnuYsuNq5Ku3nu7xOfiGaIP/fA/vz3QWqfKaDkgJ7
	 6HuSxa38Cnsby5LJui4B1xPYy8/rn6EGaTgai9SPpMEVHvn6ee2YTCsUVqQmN6bc86
	 ZPjRgz5a3k3wmx1cqiVM8fG/YHegIBIZnjil2lsQpb/nzBGoVnvf9xv08TkLxLUHgC
	 Ttci1rqJUVBFT6aAGuNRyIQJ3uKuKyISYAbIJXV5B5pHGHyBEM2Mql04RPifUAZNCH
	 IHXSesZbThqRTT8Fh7hVHk5QQMpOGHhk1vBBZ/xHZy4p8FKLPMcGjwLmDyM2UBQaXv
	 IdzkSKQ0Jd3jw==
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 06/23] kbuild: only emit vmlinux relocations when
 required
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
In-Reply-To: <20260908-build-speedup-v1-6-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-6-5dc1ac01672d@kernel.org>
Date: Wed, 09 Sep 2026 21:19:12 -0700
Message-Id: <178901395291.3971858.16666031836463650276.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3738; i=nathan@kernel.org;
 h=from:subject:message-id; bh=1LFSzvqpCVNNJ9TQXhcT9L2wj+5Vsf0qujUp2w7rHOI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFmL9I83l26TUGp7eTXM6JyC2iTRNbqhVz+eVzdjnHf+2
 O3fh9PqOkpZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBEEvMZ/il/Pq+9/aDFQnsJ
 2SnLJn1+MP3wvNVbOWz2pOzhOJQTtO02w38v5XOfk6x2C7PslDO5JXYr9VP6nyuaxQqL9k/5vzQ
 nV4kZAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

> A kernel build consists of more than one linking pass on vmlinux.o and
> vmlinux, at minimum two, and with CONFIG_KALLSYMS and BTF enabled on x86-64
> for example there are 5 such stages.
> 
> For architectures that build their own relocation tables (x86, riscv, mips,
> s390), vmlinux is linked with the --emit-relocs parameter specified.
> 
> However, this is only required on the final vmlinux link.
> 
> Symbol tables of trial links preceding it don't need it because they
> already check that System.map matches kallsyms symbols on each build.
> 
> GNU ld is slow at emitting relocation tables, so this results in a
> reduction in build time.
> 
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                          before   after     delta
>                                          -------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        9.8s     9.4s    -0.43s (-4%)
>   x86 defconfig, clean, gcc                28.6s    28.1s    -0.47s (-2%)
>   x86 allmodconfig, touch mm/vma.c, gcc    44.0s    42.7s     -1.3s (-3%)
> 
> Note that this has little impact on LLVM ld which performs this operation
> more efficiently.
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> diff --git a/Makefile b/Makefile
> index 9bd226726358..de095b11e20a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1266,8 +1266,10 @@ LDFLAGS_vmlinux += --orphan-handling=$(CONFIG_LD_ORPHAN_WARN_LEVEL)
>  endif
>  
>  ifneq ($(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS),)
> -LDFLAGS_vmlinux	+= --emit-relocs --discard-none
> +LDFLAGS_vmlinux	+= --discard-none
> +LDFLAGS_vmlinux_relocs := --emit-relocs
>  endif
> +export LDFLAGS_vmlinux_relocs
>  
>  # Align the architecture of userspace programs with the kernel
>  USERFLAGS_FROM_KERNEL := --target=%
> diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
> index fcae1e432d9a..4b54aaeca65d 100644
> --- a/scripts/Makefile.vmlinux
> +++ b/scripts/Makefile.vmlinux
> @@ -64,7 +64,8 @@ ARCH_POSTLINK := $(wildcard $(srctree)/arch/$(SRCARCH)/Makefile.postlink)
>  
>  # Final link of vmlinux with optional arch pass after final link
>  cmd_link_vmlinux =							\
> -	$< "$(LD)" "$(KBUILD_LDFLAGS)" "$(LDFLAGS_vmlinux)" "$@";	\
> +	$< "$(LD)" "$(KBUILD_LDFLAGS)" "$(LDFLAGS_vmlinux)" "$@"	\
> +	   "$(LDFLAGS_vmlinux_relocs)";					\
>  	$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) $@, true)
>  
>  targets += vmlinux.unstripped .vmlinux.export.o
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 970ca10f8fa9..09c5222ccb94 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -32,6 +32,7 @@ LD="$1"
>  KBUILD_LDFLAGS="$2"
>  LDFLAGS_vmlinux="$3"
>  VMLINUX="$4"
> +LDFLAGS_vmlinux_relocs="$5"
>  
>  is_enabled() {
>  	grep -q "^$1=y" include/config/auto.conf
> @@ -96,6 +97,11 @@ vmlinux_link()
>  		ldflags="${ldflags} ${wl}--strip-debug"
>  	fi
>  
> +	# Only the final link actually requires the relocations.
> +	if [ "${output}" = "${VMLINUX}" ] && [ -n "${LDFLAGS_vmlinux_relocs}" ]; then
> +		ldflags="${ldflags} ${wl}${LDFLAGS_vmlinux_relocs}"
> +	fi
> +

We don't use LDFLAGS_vmlinux_relocs anywhere else, so do we even need
this whole dance to just end up with the equivalent of

  if [ "${output}" = "${VMLINUX}" ] && is_enabled CONFIG_ARCH_VMLINUX_NEEDS_RELOCS; then
    ldflags="${ldflags} ${wl}--emit-relocs"
  fi

which would make this diff much simpler?

That being said, Sashiko makes a comment that may be relevant, have not
verified though:

  https://sashiko.dev/#/message/20260908-build-speedup-v1-6-5dc1ac01672d@kernel.org

-- 
Cheers,
Nathan

