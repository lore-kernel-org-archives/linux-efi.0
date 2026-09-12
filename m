Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427A035DA6C;
	Sat, 12 Sep 2026 06:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195888; cv=none; b=sV6ZeZyttGPbIHYs5vCJlwV+e9rP6j7sJ73kmpsRW/E2KlIilEqvV3pJbYEfm8LOYy3wBXzkDHXlw+TVQi0xS1+pSlVluNEbsaDaTQgjKAiX7iYgZlHN2/sOJ401VgJUqrbbBVbomVqI59C+EHr0SHCsT1ndd6pZh02BmiHaGCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195888; c=relaxed/simple;
	bh=TZbRdAU8qt37+Yww0aqvfclqS6X66BELnbHqdg/D0Ug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qp1Ke/OL0Xa6ypsSQYSR47Y0/3rXVUPo0dwnng9nNEVVLNept91IK8uRnSf1b95c5YowwDNc70rxdtYTdIj5I+if2lUYOltg+Huuxog3+4L4nTs5zwCBPvO8zUsj/OUqpJ6wbqs7NJoAJNLP90BiNGGFr/IQFYdYjStPGgRXNw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DYvw6gso; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DYvw6gso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F80C1F00899;
	Sat, 12 Sep 2026 06:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789195886;
	bh=Z84vkdbwNxegmhKm0R2xQmDE2xY7DFVW66Efhf6koos=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DYvw6gsoELRpV5Zk+nFitNkGdpp3UJB0K40yABvAnHcpoDfpPU0Nq4c5Fiym6+0tc
	 Cv9OSGENrXpxlFgyuf6k53fnSRr+CmYeI6T6dJ6P5Ml/WDOnei5VdVHvF4JPU7Y9ZF
	 5XiwvX9GNoeUHljzvqtQcPHoj5XT+gy3TmoVjlkgJsImc24jZiABBSRchLj4l7jRX5
	 02pnk5YMkj3u2wVrYE80CAwP/0lZ2djYSOyK4f0OtAFLXwnQ56nGXE4inKKI93Xkuz
	 Kc1RWE9iupig6wVtHR44XSzmGtQLiEKLs8565qMeUCMRwBOnPY0xceyW6RZujvW/kn
	 2ocP8MdjyhWMw==
Date: Fri, 11 Sep 2026 23:51:14 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <20260912065114.GC2002951@ax162>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <aqPW1FsBVYHSWl1r@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqPW1FsBVYHSWl1r@gremlin>

On Fri, Sep 11, 2026 at 11:26:36AM +0100, Lorenzo Stoakes (ARM) wrote:
> It feels like init is the right place, having actual substantive Kconfig entries
> in scripts/ feels a bit weird.

Yeah, that is valid.

> I can add an extra patch to move existing entries over before adding these in in
> the next patch?

Yes, sounds perfect.

> > I also worry about backsliding and growing cc-option checks. Should we
> > update the documentation to state that it is preferrable for these
> > checks to live in Kconfig so that they can be properly cached?
> 
> Yeah makes sense. I can add a patch to update the docs too?

Yeah, sounds good to me!

-- 
Cheers,
Nathan
