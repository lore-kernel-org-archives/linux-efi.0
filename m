Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D75F47276D;
	Thu, 10 Sep 2026 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789039291; cv=none; b=qwQ5E0XzfV0bORbCZiOlImjeq1+I0xw5DtzscRTqls6yi8jhry9pM6NiMA33lL6Gu4tT858+iZItKFHstmsrYkLi92GmsszzUMreuDlCyH7/ciCVThcQfCm5Ta2ly77xUtl0vtdV6nvyC1ucjTq3u8OStC6V3GlSL8vi9E+kkRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789039291; c=relaxed/simple;
	bh=FPzIvtgmhSbpU/1pbVMJisRzxaJmuZeATD8N0wykZxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRVvF7JFQf1ChKPKCJSa1dC6T36LbypTv95uGrntjNcc7WTbg1IXT+DtGEJJtg01dKxRxenotDY0fNYXwTnxA1tKEI+vTXG8N3UkVRrELHq8OQgHNHIb8YGvnzg5Mp+Z1vWx0/35LzHEHb9qYm3Xqqm8Y9G9CMsLJPYiF6RHDVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kxzxAAUf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kxzxAAUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A6961F000FF;
	Thu, 10 Sep 2026 11:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789039290;
	bh=FPzIvtgmhSbpU/1pbVMJisRzxaJmuZeATD8N0wykZxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kxzxAAUfjYsWGUsxd77ZTX3tE3JJL5QVTDc0CoN+OGKRsVNwA8taMOgIhooTrG+RC
	 dwnR0jlai7SFJ9MxapDb8HTbs0SXwe63sPA/OQ/0HAk1p7qxIZg1fRSVJLlU43nCZl
	 Mml1FPN4smCiHdGL3gQjgRXgL7F0ej45TsSHiztJsSrADV6hX4RtKmnD4TJJ1Dzofo
	 Gab0hIcgNwLcYSZC7AW89krjF+d3XB7egDqIdHoeNNEN08xRs1nHZuRVFuOeNEI+kY
	 bBFtt8tpbGAdUJvjTV6Y77zp96xkeUlxIhcC8wn68YMAfyNhQ1MqRixMbJb/Ya78xq
	 WbSFvnPTAlwnQ==
Date: Thu, 10 Sep 2026 12:21:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
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
Message-ID: <aqKO4idury5TND0u@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-2-5dc1ac01672d@kernel.org>
 <178901395289.3971858.3678831513020211615.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901395289.3971858.3678831513020211615.b4-review@b4>

On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
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
>
> Same comments as before.

Yeah sorry same screw up!

>
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Same thing, is this worth taking to stable? Truthfully, you could

Ack I think it's probably worth it yes like patch 1.

> probably send these two changes separately from the series so that we
> could send them to Linus with the other pending Kbuild fixes, unless
> there are objections from Linus or Nicolas on taking that route? Shaving
> two patches off of an ~20 patch series is a 10% reduction so seems worth
> it?

Patch 8 relies on 1 + 2, so as long as that ordering was enforced then that's
OK.

I mean if these go as hotfixes then we naturally get that ordering of cousre!

>
> I'll review some of the other low hanging fruit now so that we can start
> chunking this series out, since I too care deeply about build times.

Thanks!

>
> --
> Cheers,
> Nathan
>

--
Cheers, Lorenzo
