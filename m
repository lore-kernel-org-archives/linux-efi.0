Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BDA46AF16;
	Thu, 10 Sep 2026 11:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789038297; cv=none; b=Q+mjTE0EtHpOY+2C7TbBMsvM+1WfpTtLmILKsAGHW2yBJemOnHBIzIoPbfZs2QL7N7ko/mNnDjFzXU/onvuwqOWW9SmnXiw9/NITWZ4YFYWB8Se+w6T++o/IBvgetk+jR6I9t7fAjKJbxRBnEkZGac0CvkEUUyfDmSeFphFYmnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789038297; c=relaxed/simple;
	bh=1im50MvfCntX5uK7c0W8zCwLdojckAYXiSk2UfllKYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azaIxK5AHDaso25pc0YJwhkCb6cDR9guAqPfapCMYBbBkPEbvliND66472tn5cN+yT16Q1ZL0dnDIBd+tIdZX9OiGGDzvNbFX1bl1CBfBZYr9pKDg2ejV/K/Nn//DgRQwyhOR+KNOPCj44cC6uPj0qy6he+84UZTt5DQXjkXfa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jMOnMmGX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jMOnMmGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69E01F000FF;
	Thu, 10 Sep 2026 11:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038293;
	bh=usywb2M9MHTVZc0djo6iTxHgi+vEkptg9Xr+YU4YHmA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jMOnMmGXuK3NecCI//t0B9t6h8lLIPnp2kYuAR9vWHEn/MuY+pjzkOBop0UbgSASM
	 xH0R9KjV0E+1AJzUtqZ5zNEKoZkveC5dg+b4HABq4E+r8MXFhNtjL2Z9n6cW6FWdDU
	 NHBB13DHLG0wMaNMc/VfTs/Hz9FAwySXxnd2nVaPJVpyw61rCQPqwBxzg97Nzl7hai
	 OP3E+ogHRTRW0ND/UJQriEVZteW2XfOPKrr5xa5ax3+qyKlTZgjsB1w7ygQLCSEBt9
	 67XaWRLr5yWAVBWdmcDzumbwtr1lxG8awzsqXPwKJk02w95xQfvh+4AjA0bE3zlNqj
	 rVpSi2NyZUUDg==
Date: Thu, 10 Sep 2026 12:04:39 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <nsc@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 02/23] scripts/mksysmap: fix escape of '$' in the __pi_
 pattern
Message-ID: <aqKOnMJdM0XxQHpd@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org>
 <178898323844.67740.17554063026930604280.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178898323844.67740.17554063026930604280.b4-review@b4>

On Wed, Sep 09, 2026 at 09:47:18PM +0200, Nicolas Schier wrote:
> > Commit b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
> > converted scripts/mksysmap from a shell script to a sed script.
> >
> > However an error was made - escaping of '$' required \\ escaping in shell
> > but only \ in a sed script.
> >
> > This was mostly corrected in commit 7a6c355b55c0 ("scripts/mksysmap: Fix
> > escape chars '$'"), but this fix missed arm64 PIE namespace local symbols
> > like __pi_$x and __pi_$d which appear in System.mapand /proc/kallsyms:
> >
> > $ grep __pi_\\$ /proc/kallsyms | sort -u
> > 0000000000000000 d __pi_$d
> > 0000000000000000 t __pi_$x
> >
> > Fix the escaping properly.
> >
> > Fixes: b18b047002b7 ("kbuild: change scripts/mksysmap into sed script")
> >
> > No measurable change in build time.
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >
> > diff --git a/scripts/mksysmap b/scripts/mksysmap
> > index 56a8b8bbdb37..856b26ba2ac0 100755
> > --- a/scripts/mksysmap
> > +++ b/scripts/mksysmap
> > @@ -35,7 +35,7 @@
> >  / __efistub_/d
> >
> >  # arm64 local symbols in PIE namespace
> > -/ __pi_\\$/d
> > +/ __pi_\$/d
> >  / __pi_\.L/d
> >
> >  # arm64 local symbols in non-VHE KVM namespace
>
> (Move 'Fixes:' to trailer block)

Yeah similar screw up. I think it was when perf times were appended
per-patch but then then ended up on the fix patches + I yanked them bit
didn't correct the tags, ugh!

>
> Reviewed-by: Nicolas Schier <nsc@kernel.org>

Thanks! :)

>
> --
> Nicolas
>

--
Cheers, Lorenzo
