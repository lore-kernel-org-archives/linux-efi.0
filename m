Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B43F329E;
	Tue, 22 Sep 2026 04:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051258; cv=none; b=llPc7/PCQRUv+b/Cw2H+XiJjC9KHO0C+pxq/0pOYQJP5DcsscTPtrVjNqMopuZ287MXEGK+3sNaCyUS9fGp5KFou00RnxW7OMdzwb1QxqMJ9o6BszRYIv3+SIYS67VkuZ6u/HVXFnm+RDnN5lodqbV195Mjq6X6eIodKooNp8NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051258; c=relaxed/simple;
	bh=HhudhUK5yzn8hhCT6NM2I9TPL8fH9kTRoXbU8Ec24+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rpw9TmcJ5KtZb53ACH1Vo5Qhb+K0H95UCsgrIrZryMfwIqSYgHm7j3Uag20cBwJXa/l81/b1L3O5pkWb8uCD0dT8TYiSOqUa47n+bI7qrM8mBmrj8nAr2kvDK29wQJ0KnBNyI+PB1Xnbox85u5pjkV6fWXhwE+0oa5st6BAvFGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXA4r0PH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXA4r0PH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0961F000FF;
	Tue, 22 Sep 2026 04:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790051256;
	bh=dG15CqrnbAsOXWaUpYt6BDYQSM8cnW2c3KA5Prsjavo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MXA4r0PH3HgT3iDgDRuDNJmWk/ZUsYEcSUJgSYAhpCjtRahhxqjcteIyBCizLYuR0
	 bBcv4s83G+WwaXS5KJIdHDIYvBEBAngTAH1AaI0rrEoQcEKpcNfu3zSGwNVgguzjMh
	 1InYjz1c3D/m00ZJZGR8MhjhkI+oOV8ibVQ8HUEQ8RzM2H7mHeFtHzZsVntWowVopS
	 2ZQ4NnVHqPr8zHY3I3ZDAhrTkSgT+St3c/kIcL9PMtgwMk5+lHZuOMccwaQxqBZhQj
	 U2y7anUp4MeMk91bn7KDUqq6BkJW/ggpJujiZoPQkT92dO4tVzXyTjeUJjh6lxoukO
	 9/QiAbsZRdy+w==
Date: Mon, 21 Sep 2026 21:27:33 -0700
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
Subject: Re: [PATCH v3 17/20] objtool: decode instructions and resolve branch
 targets in parallel
Message-ID: <arICcrXVFLVzO-Jx@jpoimboe>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-17-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-17-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:27PM +0100, Lorenzo Stoakes (ARM) wrote:
> During a kernel build objtool is used to decode vmlinux.o's instructions
> and resolve every jump and call destination.
> 
> This forms a large part of the work objtool does during the build process,
> and it is all done in serial.
> 
> Decode these in parallel at a function granularity to speed things up, but
> limit this to invocations that pass --link, and only where the there is 8
> MiB or more text to justify it.
> 
> In practice this limits this to processing vmlinux.o in the kernel build
> and modules are processed as they were before.
> 
> Only the instruction hash is shared between the threads and nothing is ever
> removed from it, so an insertion is a compare-and-swap on the bucket head.
> 
> Threading is limited to decoding and the jump pass, so the gain flattens
> out at 16 threads and any further threads were found to only add overhead.
> 
> When performing an allmodconfig build, the clang invocation of objtool when
> processing vmlinux.o took 5.93s on 1 thread, 4.56s on 8, 4.51s on
> 16 and 4.63s on 128.
> 
> Therefore cap the thread count at 16 or the number of CPUs, whichever is
> fewer.
> 
> The output of objtool before and after this change was confirmed to be
> byte-for-byte identical for x86_64 defconfig and allmodconfig with gcc and
> clang, and for a loongarch defconfig, where objtool runs on every object.
> 
> On a 128-thread machine, objtool on the clang allmodconfig vmlinux.o goes
> from 5.2s to 4.4s (6.5s to 4.4s together with the previous two patches),
> and on defconfig from 1.99s to 1.38s.
> 
> objtool on vmlinux.o is on the serial tail of every build that links
> vmlinux, no-op builds are unchanged.
> 
> Whole build, 128-thread Threadripper 9980X, best of N runs:
> 
>                                          before   after     delta
>                                          -------------------------------
>   x86 defconfig, touch mm/vma.c, gcc        8.2s     7.7s    -0.55s (-7%)
>   x86 defconfig, touch mm/vma.c, clang      7.3s     6.9s    -0.44s (-6%)
>   x86 defconfig, clean, gcc                28.6s    28.2s    -0.47s (-2%)
>   x86 defconfig, clean, clang              29.1s    28.7s    -0.45s (-2%)
>   x86 allmodconfig, touch mm/vma.c, gcc    25.7s    23.7s     -2.0s (-8%)
>   x86 allmodconfig, touch mm/vma.c, clang  24.1s    22.5s     -1.6s (-7%)
> 
> Assisted-by: LLM
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  tools/objtool/Makefile  |   2 +-
>  tools/objtool/check.c   | 717 ++++++++++++++++++++++++++++++++++++------------
>  tools/objtool/objtool.c |  14 +-
>  3 files changed, 546 insertions(+), 187 deletions(-)

This is an interesting patch, but I'm not really convinced it's worth
the pain.

-- 
Josh
