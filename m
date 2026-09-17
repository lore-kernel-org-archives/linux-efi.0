Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9284FD26E;
	Thu, 17 Sep 2026 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664736; cv=none; b=mdsFYxx+a1nbKMBDg9RhU08Gfbtp2nDFCVkQhmF950I3wiz+KJinAQcAiMGmWpXTZqTV1I5+doqhL3GkJDRlclAFEUqJhEQDKSWpr9u3Mpv+a6MQSdCQ5SlVH/YHQ3wvpo3IDiBnqbvcErcNPs0jjKqrsMnSajiwAXEyYROr1tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664736; c=relaxed/simple;
	bh=UfjtGGVZB8Zjt9N1LslczdhI/ntAStI5UUlb12rDfAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i8RKsszx5qUWsFP4WA9ZPt6ftyQZUVFDU1vSSF4Rb8Rg7K3CFMABlrkTf2mNq/tmkKjFw1ZEi5jZQ0fGgv3syOTNkBrYstJEmWoywvLyG0MmMm6xQ/PjWXr7dRb1BhprnIPBgDGl9huTSut97X7ubCE44Ao3UHCOowSXk1j1GUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a1oY5QbB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a1oY5QbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA4D1F00893;
	Thu, 17 Sep 2026 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664735;
	bh=9T6Ai0DaSY41m9xsiEy+SvRmsf3fqO2EjjY5HGGOdHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a1oY5QbBgj0PgVTxIAleOAevncrWdI0JjDRKRIjUk+L7L0Qclrqrv/W6tH1fiTwbn
	 jcLKeMW+4oZiygidx8l8R1v9pjrdcr2hgTaP4n61WG3Jjoiyn1z8s1izXab8yOTxSx
	 rZj6mayKixcNOV1Q1vLTDtSa1iiLwGhudrq1Jj1HJGFGF6LPjeLei7ldBzZZlateWj
	 XYA33AViCuP9r6hvgJjnNStdeSBGzmCJzcD39hRRcu+RkgR28pi1TEFEoen/Bj8J0w
	 MCd1iy582tIarlE019Chz91CYupTlf7jXjPVYiBjYrBPmrVjc+STbQYOjEkXJpI0Lz
	 0BMVtVLMfj2zQ==
Date: Thu, 17 Sep 2026 10:05:34 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 01/20] kbuild: do not allocate .modinfo in vmlinux
Message-ID: <202609171002.8C0C739@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-1-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> +      cmd_modules_builtin_modinfo = $(OBJCOPY) -O binary -j .modinfo --dump-section .modinfo=$@ $< $@.tmp; \
> +                                    rm -f $@.tmp; \
> +                                    sed -i 's/\x00\+$$/\x00/g' $@

Oh, I just noticed this. I don't think the .tmp is needed. You can just
use /dev/null for the outfile here: no need to write anything unused to
disk; seems to work for binutils and llvm's objcopy.

-- 
Kees Cook
