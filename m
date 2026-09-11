Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2936E38DC71;
	Fri, 11 Sep 2026 19:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789153247; cv=none; b=EpqNYhlgopS0qUGJzi6XnyyfSJTdt4NjIV9yo9iOBKwuDuqcFUb+KpCS16r77x3AeM8fo/DZNE3PLszv6QU7180iLSNBe6SttyIptKvBsi26+9on6yapBaNZVA9H5dI9yStWZhysTolfWK8SWDd2n24zRu05DsT5nc63Qg3NJgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789153247; c=relaxed/simple;
	bh=U7ek17ewJSjncfJmFJyagh0BYwbFrs14o0h4aRXgvWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PMX5K8K1bNWf8gESeHs/v/acdCTWlFnWNWFahuzKeDZ/0RAWpeVEVyeMr/hVBBtyE3w3y+q0NDH6FeTqcey3gQTDdWU9CZa4c017f0lUogWn6ngBlGEHcLkSYC3GzjF1MHwExmeTNe8S1lNeKUjnT1DTjETex7TEY2bMs6qHVGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=NIykgXGt; arc=none smtp.client-ip=212.42.244.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="NIykgXGt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789153240; bh=U7ek17ewJSjncfJmFJyagh0BYwbFrs14o0h4aRXgvWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NIykgXGt8va9dimaVsp85Ph4Lf7pd6XWnrdykh6l34G3WP8CS3WhPvZy9/QghHsod
	 2g7gSr0GnpwYuXqZt9HpfvLzoH6wfWYdEoJhWzvrKryQK9nkuM49hSw2x5mML0e1vj
	 yxSr2/0pm6sa3w8cnIylI45IPB7gyLLFpK1/1d4Xrz0o6YrVqx9XIPo9r8C/h8c5qP
	 k5hXuctundU1Eu0Yv7MceKlrhcxlTWrzdajqKWLZXxNbTHGheoFA15vqxKex35ywy/
	 Wp5QToYM2jPUrmYPLc+USGo4VLJ6Xw2EC1ij0cyeF7FUsebSrKixKlaqrsUA6OVpu4
	 015MX/cN7Hj3g==
Received: from [2001:bf0:244:244::78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aa44fd8-0449-7f0000032729-7f0000018a32-1
	for <multiple-recipients>; Fri, 11 Sep 2026 21:00:40 +0200
Received: from mail-auth.fritz.com (unknown [IPv6:2001:bf0:244:244::78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 11 Sep 2026 21:00:40 +0200 (CEST)
Date: Fri, 11 Sep 2026 21:00:40 +0200
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
Message-ID: <20260911-impressive-heavy-bobcat-6ceeb1@l-nschier-aarch64>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789153240-3E7E2965-9B10CB31/0/0
X-purgate-type: clean
X-purgate-size: 1792
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-01  mail-id: 9436CA0635  external: no

On Tue, Sep 08, 2026 at 09:55:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> Rust crates are compiled in a serial chain on the critical path - core,
> bindings, kernel crates and then the drivers - each a rustc invocation.
> 
> With CONFIG_RUST set and every rust driver enabled, the entire chain takes
> around 25 seconds on a 128-thread machine, with the associated C code
> taking 24 seconds.
> 
> Each time a change is made to any of the bindings, it triggers a rebuild.
> 
> Use the -Zthreads option to have rustc perform builds in parallel. This has
> been available since rust 1.84 (rust-lang/rust#132282), and the kernel
> requires rust 1.85 or above.
> 
> A future -j/--jobs option is planned for
> rustc:(rust-lang/compiler-team#1005), so check to see if this available and
> if so use it.
> 
> If the user's rustc supports neither, then it falls back gracefully and
> neither are used.
> 
> The threads are taken from make's jobserver, so a parallel build is not
> oversubscribed. It was found that benefits level off at 8 threads (16 was
> found to be around the same, and 32 slower).
[...]

> diff --git a/Makefile b/Makefile
> index 997fc7ebe096..7d23d7b64be3 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1204,6 +1204,10 @@ KBUILD_RUSTFLAGS += --remap-path-prefix=$(srcroot)/= --remap-path-scope=macro
>  endif
>  endif
>  
> +ifdef CONFIG_RUST
> +KBUILD_RUSTFLAGS += $(if $(CONFIG_RUSTC_HAS_JOBS),-j8,$(if $(CONFIG_RUSTC_HAS_ZTHREADS),-Zthreads=8))
> +endif

Is there a reason for the 'ifdef CONFIG_RUST'?

Hard-coding '8' feels a bit odd.  If some kind of KBUILD_RUST_JOBS would 
be used, it could allow users to disable or override the parallelism for 
rust.  Does it make sense to have rust parallelism configurable?

-- 
Nicolas
