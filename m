Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFBF48125C;
	Tue, 15 Sep 2026 10:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789469057; cv=none; b=B18uUeWYu/Af7jyJuJwgiE3g8tInNXwf3eNF50nYtf1y2+ZdOgFHAl6QDqz5bKw0sME09JXAIn9xtM6IZntP9ATd6Y43CzhqHdi69AUZfzn9DjlqJtn9KTuKMUaPV4VaJ8zszKhUEuiUnqMEL+m7ewfoFepuK81MEa2kdxZCl5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789469057; c=relaxed/simple;
	bh=b6c3JYoc+w5EEpNyoNB9KUGB91ElnPEyAcmxG0RJU58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DDF8vXLEXgmSX2Dheh4LqlFp7lYecqAmqtK3Bqd6joZYm1spTErmsCm6afjpyFt7TLnuoWN7/I6DMADq0UvlXf0M23osJnCFkEbbGO680NCz11KmJsOJ74paWOHJtIL2ZUPHz65I+nP42Y+Qzqo2k6LuVrrmT8Kwr9pvZnBylbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUToMrdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUToMrdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B602B1F000FF;
	Tue, 15 Sep 2026 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789469055;
	bh=TX67wToN/vV4eRD0qfWhTbazK7mBj1488P8wyNJ2Z0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mUToMrdFqpeuheHAXi+Pj/C8B/wZ416xsc1z+zaIAr2kYrfLWdLP9vYofremSY/hL
	 b/Zvg44C1l7bbJ1HRRxXPUwmtSGgW4OV0+wNhOY3eqwgUkqxgAAk1tFhJJW+v+L8m1
	 lwj57hY24E7NydH0vUQZp9n1HYwfzif+2V7uCr4No8tdoVJKJZeqULh8GS5e50N+Ec
	 4vpem0My//+hAumuuN7z6e17rNWHOuvkI0nbsIqVFmAq420l7jNd8vFnbh8BtrPWr9
	 qmhteJUsi0b0VFt189BXSM2Ge6jlRDfpRVdDjKIoUBcqwlhsXJoKgBW4Vyno6cw3fQ
	 ga53PG7fyFWcQ==
Date: Tue, 15 Sep 2026 11:44:01 +0100
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
Subject: Re: [PATCH v2 14/21] kbuild: batch module finalisation
Message-ID: <aqkZvtAKWYf9-1ZW@gremlin>
References: <20260914-build-speedup-v2-0-39817ec5db23@kernel.org>
 <20260914-build-speedup-v2-14-39817ec5db23@kernel.org>
 <202609141056.6AE2C82E@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609141056.6AE2C82E@keescook>

On Mon, Sep 14, 2026 at 11:00:27AM -0700, Kees Cook wrote:
> On Mon, Sep 14, 2026 at 10:22:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> > Module finalisation on allmodconfig builds consists of a large number of
> > very short-lived jobs, and the make job dispatcher cannot possibly dispatch
> > jobs fast enough.
>
> This "cannot possibly" sounds like a weird LLM language intensifier. I'd

Again that's my writing actually, probably best to stop assuming LLM now ;)

> rather a concrete description of the problem, not this kind of
> (redundant?) vagueness.

In the very next paragraph I say:

	For allmodconfig x86-64 this can be on the order of ~22,000 jobs of
	a few milliseconds in duration each.

You did also say that the commit messages were over-long, so there's a
trade-off here :)

But I think best to expand it a bit if it's not clear.

The general idea is that each job is so short (ms) that the work of
dispatching them exceeds the time doing the work, so you need to shard
things.

And the work of dispatching is heavy - each modfinal instance means it has
to process ~22k .cmd files of every .mod.o and .ko.

I will update the commit message to reflect this.

As a result, we need to batch these (see below).

>
> > [...]
> > Fix this by splitting modules.order into chunks of 128 at a time, run in
> > parallel.
>
> Why "128"? This seems tied to the 128-thread test machine, but ends up

Honestly Kees :) you really think I'd let a hardcoded-to-my-machine
variable through to the point of being called out in the commit msg? :P

No, that's not what this is.

> getting hard-coded, but this choice of value needs some rationale, IMO.

The rationale bit is fair enough, I thought it was somewhat implied but
it's a heuristically-determined value which determines how best to shard
the jobs.

So, it's about both getting parallelism and batching up to offset this job
dispatch overhead, there's naturally an equilibrium.

Emperically:

  modules per chunk   32     64    128    256    512
  wall time         4.05s  4.07s  4.05s  4.03s  4.18s

But in more detail, allmodconfig tree (~11k modules on x86-64), best of 2,
make modules with *.ko *.mod.o deleted:

    modules per chunk    instances    wall
    -----------------    ---------    ------
                    1        11171    10.22s
                    2         5586     6.72s
                    4         2793     4.97s
                    8         1397     4.26s
                   16          699     4.05s
                   32          350     4.05s
                   64          175     4.07s
                  128           88     4.05s
                  256           44     4.03s
                  512           22     4.18s

which I think makes things clearer.

So realistically 32 - 256 is the right sort of range. You also have to take
into account the fact that you might be building fewer modules.

The argument for 128 is that this is the mid-point of where the graph
flattens off for a larger number of modules.

For a smaller number, you're going to have a single dispatch or less and
the delta won't be that much anyway.

So it's very much a sensibly derived empirical value.

I'll update the commit message to give this rationale there.

>
> --
> Kees Cook

And for avoidance of doubt, it's ME replying to things :P I deal with a LOT
of AI slop in mm so am quite sensitive to doing things right here (TM).

--
Cheers, Lorenzo
