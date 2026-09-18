Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D34B328B56;
	Fri, 18 Sep 2026 19:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789759669; cv=none; b=Eu0wOoA1enMpNmFtW/jX6a603fSPiFjQYIamqwx44i0kxyxSotx4MSYPBzPuoS2/yJO2qbKD1YcY8RKyZF8DE8At7QYEsMyt48aeKbL+qUrB848K4WS9FvLt+WNjgNV5wt683CZNC8lQk489jaVihnpEE1Uzqk9N8qHukcfsClU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789759669; c=relaxed/simple;
	bh=xc9TLOdz9Shm4TKmH/6pS1wap/ev01S/nSMVw3cWtfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eSLzqN7kKkNl1TMyZ6sKGyCPn5QUjRPKhNtR3jhJwukkGWOypTdhYSom1NZS7Hs1MsSeFDQQJXmg7bYLF4bNkT2sfGh03L6tx4D97APZfafaz6gGyHfyXTZvrSjo4ihReJN1eTPiaFmCsULqj0Aa5dZ+llvcESCgKYhyGp+ifHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=pa5ZU1ud; arc=none smtp.client-ip=212.42.244.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="pa5ZU1ud"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789759661; bh=xc9TLOdz9Shm4TKmH/6pS1wap/ev01S/nSMVw3cWtfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pa5ZU1udssDZ876Yy4o4IBichzZhOR7QEhjKH6E5ZP2IahZ2K/0W4pdO7vIJ1A67B
	 sN8QwI7QAqroUzatF/Q7twY+IVVg5NlKTTx+QhN91UdJxk/cCd7LNrD/HoQRCdKpm3
	 5o1BJlm50C8/qTKTo4bx7wDWWJ0ZpIYpSkxnnzV86DnQ7STHP4CciKh5eVXV/vaGqy
	 ycFLa4r6L3ZXuyu2Ks56AWocHYwiKR90SpVfuvRUKI21YoCoZoDNX/TQkFSBUErGmT
	 raLS6ipTgDZNBeO2QHtF+LVJTB0OoKhExntepvKWlTVwpv6dWg/+RNVqh1UcABk2/M
	 AUfyXKl3m9DbA==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aad90ad-03cd-7f0000032729-7f000001a22e-1
	for <multiple-recipients>; Fri, 18 Sep 2026 21:27:41 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 18 Sep 2026 21:27:41 +0200 (CEST)
Date: Fri, 18 Sep 2026 21:27:39 +0200
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
Subject: Re: [PATCH v3 05/20] kbuild: only emit vmlinux relocations when
 required
Message-ID: <20260918-rustling-coati-of-poetry-dcc9d9@l-nschier-aarch64>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-5-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-5-9ecf4163ff36@kernel.org>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789759661-32FE3EE1-8C64E93D/0/0
X-purgate-type: clean
X-purgate-size: 1573
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-03  mail-id: 482D3A0494  external: no

On Thu, Sep 17, 2026 at 05:06:15PM +0100, Lorenzo Stoakes (ARM) wrote:
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
>   x86 defconfig, touch mm/vma.c, gcc        9.5s     9.1s    -0.42s (-4%)
>   x86 defconfig, clean, gcc                30.1s    29.5s    -0.59s (-2%)
>   x86 allmodconfig, touch mm/vma.c, gcc    37.2s    35.8s     -1.4s (-4%)
> 
> Note that this has little impact on LLVM ld which performs this operation
> more efficiently.
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  Makefile                | 2 +-
>  scripts/link-vmlinux.sh | 5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
}

Reviewed-by: Nicolas Schier <n.schier@fritz.com>

-- 
Nicolas
