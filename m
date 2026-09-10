Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AB233BBD9;
	Thu, 10 Sep 2026 04:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789014051; cv=none; b=q9ZYRI1OamT3Fu7McRrVlvkLGNFkSlAH6owHjnGCJ58hdmjcp4ENvSWN1n7YHx61Bm6MgXeQUV9d7lSCtKQepNYbGDBKnLoWVcctoADn+EZjeaWz/IhDwnQDuSrQcPJMslYKM8WRpfg2itvPQ2DDBSU2MUkZ7d5fr1JgU1GUywU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789014051; c=relaxed/simple;
	bh=PWiw9iigt6rbD24ZiXxyBJD+qyI0ktZsDX7chEfK3i0=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=r/qshWhnI48fjcJM1IM/4WpWscKaoNkZaTNOUeaqu+JcwN+GbwkiwZIW8pV+Ix2XpZzFAXfj+zxvRN+mEuSsYJUvd7SYNypWcQNE5/HIgx8VfS+7KFMsdvT0+2LxUUGxwzWKtZnwV4J5LJ4Y9nEEKr4pXvFnp9y4p6yTQTnW/iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=es4M0/QT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="es4M0/QT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F691F00893;
	Thu, 10 Sep 2026 04:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789014049;
	bh=sVnWQ51WrfoFI804Uojkgp91AQJuBmgpY4bZ4Li+s74=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=es4M0/QTiG4ahU0BcReuAku5aYImRV/KAZWfavvmFadQPm0NvssN4qmaLiAhLyFG6
	 ZnvzUo6HcefiA7H0nYcvga8yrJaV4wVeIRh5a4x2VWUk6A5ow0ETRHTcshs3zBi2Jo
	 KTtshaWtkM5mONIQvT+haAgVuRJbwMx1WMkM3VkCS0C2d/AoIZA5PnIomQwNPA38PO
	 KCe/3bdGUIUULjEFJF7eqIZY1oxssyaEASLROK8BnIiGquz5vHbz3SFnTE0ehgHZrb
	 gIR7oA7zdRfeEPY9sOVE7/gll9FzkzySbYUKYWZKJiG+SJ+z5WwNaULDFIkWh6zw4t
	 zVdTHTBsABlRA==
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker
 probes
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
In-Reply-To: <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
Date: Wed, 09 Sep 2026 21:19:12 -0700
Message-Id: <178901395292.3971858.13236774094648272066.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1169; i=nathan@kernel.org;
 h=from:subject:message-id; bh=PWiw9iigt6rbD24ZiXxyBJD+qyI0ktZsDX7chEfK3i0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDFmL9I+HVjSWnBZlzVKOa5oX+FnylCyTxbw5wa+7Nz1cw
 rF2m7V1RykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjI9ssMf0XnqmYkzWoSsKnm
 vZ243ifarPT8junpy1OunxI+dq45rZrhn1pVh/7jbINDKyYe9C1fGv58u2r6EXkVToFLH3UXTNh
 WyggA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

> diff --git a/init/Kconfig b/init/Kconfig
> index 8583d9f06c52..3c92c87254a3 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -144,6 +144,44 @@ config CC_HAS_ASSUME
>  config CC_HAS_NO_PROFILE_FN_ATTR
>  	def_bool $(success,echo '__attribute__((no_profile_instrument_function)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
>  
> +config CC_HAS_ZERO_INIT_PADDING_BITS
> +	def_bool $(cc-option,-fzero-init-padding-bits=all)
> +
> +config CC_HAS_NO_STACK_CLASH_PROTECTION
> +	def_bool $(cc-option,-fno-stack-clash-protection)
> +
> +config CC_HAS_NO_ADDRSIG
> +	def_bool $(cc-option,-fno-addrsig)

I am generally in favor of this proposal since I think these checks
should be cached by Kconfig where possible to clear up running them
twice. That said, I wonder if we should pick a better dumping ground for
these checks other than init/Kconfig. Maybe init/Kconfig.tools or
scripts/Kconfig.tools or something?

I also worry about backsliding and growing cc-option checks. Should we
update the documentation to state that it is preferrable for these
checks to live in Kconfig so that they can be properly cached?

-- 
Cheers,
Nathan

