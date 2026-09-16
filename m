Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034A3370ADF;
	Wed, 16 Sep 2026 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789567486; cv=none; b=DE+WQWJruGycAbRhDFf/NQlcCG/baBS5eWg7U9haT7YE//3Q/gvjoHnT0B1xzhHK8DBhLURmxf8cHrHKB8EI4vW4qcBGuIr7RdUyPWFBYNmZPZZ1H8sciVnh79089fl6EHbEkXA/z9KuuUmjxmsSlYK1sRtw1qw+Fq1o/GUoo8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789567486; c=relaxed/simple;
	bh=4p4hgcvw6kWcyC6EnxN9LbmyJCJrpBQ7Z3d+76JOY14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YqGGp5oYOPnCKqWn+Il049s6QV4oa0YTDWAjdyDLiZil6NgcwUZjsG+2yIAI6XC78nTyi+QD+ewG/jAa/sOMfzvhbldIoph6dMA0exFgn/Q4yKyfZ3wA0yMxxQ7pfhX6Zt/JuG6eOJSarbIQOyffsOdcl4+Jp9j2nIOZHxkGdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEqrNXj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEqrNXj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72A01F000FF;
	Wed, 16 Sep 2026 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789567484;
	bh=4p4hgcvw6kWcyC6EnxN9LbmyJCJrpBQ7Z3d+76JOY14=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QEqrNXj4hIJ+yI04UbRRbzBwkfAPGXGTc0IPJzRUfJ08hVbqxoA11qyOaeocRMZze
	 QMDTNlNgZ7H/6jCbW4jc7XIIj+3crpYh6RQPGu/2+kV+9chxN+NMfi19lT+PZsz3q6
	 kJeTiFOZocvpahWB6/2aLwybCEhF1VgXISs4r9MysIyyIWac/3X2Q1aqa9WzRyv759
	 cq+oXi0EGQRTc0SkQkEwyDO6JX4YcPiIFG/z5UYYYaSOeB4TcDU3wzHNgcPxPEuoeH
	 jyMHgQXRuDCjNHXLen/ynlZVk+jaxndcRdCxn72EKgpqHgdOxG8Z/1xMe2pcVmDJv5
	 uz3X+qN5sZ83w==
Date: Wed, 16 Sep 2026 15:04:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kees Cook <kees@kernel.org>
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
	Randy Dunlap <rdunlap@infradead.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 20/21] kbuild: build rust crates in parallel with the
 rest of the build
Message-ID: <aqqhzqgYV5MTYAzo@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-20-39817ec5db23@kernel.org>
 <202609141133.7CA979C89@keescook>
 <aqkv9SqIdh0qKPFc@gremlin>
 <202609150951.73C4F16EFB@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609150951.73C4F16EFB@keescook>

On Tue, Sep 15, 2026 at 09:52:01AM -0700, Kees Cook wrote:
> On Tue, Sep 15, 2026 at 12:58:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Since this _still_ gives you a significant speed up on bigger boxes, I think
> > it's fine as-is.
> >
> > The LLM says a fix for this would need significant work - a cross-instance lock
> > and an on-demand rust/ build. So I think best as a follow-up?
>
> Sure! And I defer to the Rust folks on all of this. I just wanted to

Yes indeed as do I :)

I _think_ this change should be a lot more viable than the -Zthreads one
though :)

> note the possibly unintended behavioral change there. Thanks for
> examining it!

No worries!

>
> --
> Kees Cook

--
Cheers, Lorenzo
