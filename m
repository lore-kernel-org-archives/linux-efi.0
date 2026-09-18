Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86B2494811;
	Fri, 18 Sep 2026 19:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789758881; cv=none; b=nt2QB8jKV2gn7TnUcGlqcEMal0yb59ioW9Pj9hFhhIZ+JdfXIu3KafRNQRdh6ls3QLxO0tyyOprinSjL3BzanQjXQYoqpSNZVoB8VAITNkKncvFn4XmlEe0Ov68z7wrKhLAr1jH7vYzwTLOv2M5Bc3CtZlt+af/m1M0uFMASQy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789758881; c=relaxed/simple;
	bh=1jzcMguIKA5Is93mmoKDoFmH31Cg2L7H6JApxy7LOZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCdFY6acYTgj1Jr1EvadShGEJD0E1DNtQFOHVVfqBFVNWev4eeil81zNEV5i4P6QxjgvQKjBw2JtjYeys1dcLxex2bi+UKM8AY6+oVsBPgQ04qXBxcFQHtRnB43G5Nr8RUU0ExEXscpmZTse+mlNBUTEsL+eCZnb2ZRnjvcOgHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=iBvlivrQ; arc=none smtp.client-ip=212.42.244.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="iBvlivrQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789758868; bh=1jzcMguIKA5Is93mmoKDoFmH31Cg2L7H6JApxy7LOZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iBvlivrQxoQVIHimQxNZwvRd0auQnJ2cPYzcf290Gf4rAfq8fQ2otWjes9JeDDVOp
	 9COorSKA8vsE3iFyF1sfG/9oTUzSzrP53FcBlUVHjsNLG9T+7V+4dQ3hfkHI7fTIVm
	 593kNAFWpPYrvZM/jUo3fNC9lYRinwYFoQEPX4mvgebtHcg+q0/jtPkBOqmycudB5h
	 lvIMmcnbp2bzPo2XZvx7ZrQ7jQ1t22IlI2k7ztxPumNk/OSxuesoeZCK/V7PWxcyih
	 T2d17vKvLAtj149Sa0VK3IjL7v6HgkKxjM2do6f5PI+WEYP/REwe6UuFcKm3AGm/bC
	 anYFuFsiSaK5w==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aad8d94-0449-7f0000032729-7f000001b58c-1
	for <multiple-recipients>; Fri, 18 Sep 2026 21:14:28 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 18 Sep 2026 21:14:28 +0200 (CEST)
Date: Fri, 18 Sep 2026 21:14:27 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 04/20] kbuild: do not sort nm output where the order
 is irrelevant
Message-ID: <20260918-scrupulous-squirrel-from-nibiru-f017b4@l-nschier-aarch64>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-4-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-4-9ecf4163ff36@kernel.org>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789758868-39FD9965-1B3E940B/0/0
X-purgate-type: clean
X-purgate-size: 2955
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-01  mail-id: AB603A07F0  external: no

On Thu, Sep 17, 2026 at 05:06:14PM +0100, Lorenzo Stoakes (ARM) wrote:
> Unless instructed otherwise, nm sorts by name.
> 
> There are places where this is unnecessary - an invocation from
> scripts/sorttable every vmlinux link, scripts/check-function-names.sh run
> after every vmlinux.o link, and the x86 VOFFSET and ZOFFSET listings
> between vmlinux and bzImage.
> 
> Both GNU nm and llvm-nm accept the same '-p' parameter to disable sorting
> in these instances, so use that to prevent this unnecessary work.
> 
> Each nm run on its own, x86-64, median of 5:
> 
>                              GNU nm 2.47              llvm-nm 22
>                           before  after   delta    before  after   delta
>   defconfig
>   sorttable, nm -S vmlinux 0.080s 0.039s -0.041s   0.265s 0.113s -0.152s
>   check-function-names.sh  0.072s 0.033s -0.039s   0.244s 0.102s -0.142s
>   VOFFSET                  0.077s 0.034s -0.043s   0.261s 0.113s -0.148s
>   ZOFFSET                  0.007s 0.005s -0.002s   0.005s 0.005s  0.000s
>   TOTAL                                  -0.125s                 -0.442s
> 
>   allmodconfig
>   sorttable, nm -S vmlinux 0.156s 0.063s -0.093s   0.539s 0.223s -0.316s
>   check-function-names.sh  0.149s 0.054s -0.095s   0.537s 0.217s -0.320s
>   VOFFSET                  0.146s 0.052s -0.094s   0.524s 0.221s -0.303s
>   ZOFFSET                  0.007s 0.005s -0.002s   0.006s 0.004s -0.002s
>   TOTAL                                  -0.284s                 -0.941s
> 
> llvm-nm appears to be a lot slower than GNU nm, so these builds naturally
> improve the most.
> 
> The four run one after another in the serial tail of every build that links
> vmlinux so impact kernel builds directly.
> 
> In an allmodconfig the decompressor is built in parallel while the modules,
> so only the two before the vmlinux link contribute to build time.
> 
> The build outputs remain unchanged.
> 
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                           before    after     delta
>                                         ---------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        9.7s     9.5s    -0.18s (-2%)
>   x86 defconfig, touch mm/vma.c, clang      9.3s     9.0s    -0.27s (-3%)
>   x86 defconfig, clean, gcc                30.3s    30.1s    -0.16s (-1%)
>   x86 defconfig, clean, clang              31.7s    31.2s    -0.55s (-2%)
>   x86 allmodconfig, touch mm/vma.c, clang  36.4s    35.8s    -0.67s (-2%)
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/x86/boot/Makefile            | 2 +-
>  arch/x86/boot/compressed/Makefile | 2 +-
>  scripts/check-function-names.sh   | 3 ++-
>  scripts/link-vmlinux.sh           | 2 +-
>  4 files changed, 5 insertions(+), 4 deletions(-)
> 

Thanks!

Reviewed-by: Nicolas Schier <n.schier@fritz.com>

-- 
Nicolas
