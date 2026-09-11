Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F5C42EEC4;
	Fri, 11 Sep 2026 10:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789123318; cv=none; b=ENoSwDTm2el1VqvxfbfPctRUEcC2QMj8EPkohd8GfiSeC0uEM8evenaRImOJ/LjvWPnjH+QG9PVF+nCQiJcNZe1oj71CisjwqixwLooQADMcs63DhwJmH+RMPDheXsE70s71ZSD9D16ZUm6sjDxeevxSWLtThBLzcwMxjUmq8Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789123318; c=relaxed/simple;
	bh=5YCaSg6B8lnKNS5mnwM54lBHOHshfmcrbaZ2cubXQ4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JX2H7kzq6nu6BHrEn9IC5RMfJyAuoHN6sqgRcNhttkz5QPXPuzSFdJ/fQJxBOVXM48yJ4hJqpbtFWarJ9NVKm0YFsMahFZZriumXOyUPhjDfI4DpDXZBOeIPsfQeDgtTc3/dRMnNN1eoy68NxTbE1Hr4sGUvazymPAJI56XrdvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcs4lsBd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcs4lsBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E852A1F00893;
	Fri, 11 Sep 2026 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789123317;
	bh=MMJozD+RewnE2WYnIY4zmGHYgUsIL3AEVPRTDj0LFp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hcs4lsBdMwnW3lvB6exZIai5ol6Yll7bG/D1+ACDRwDpO3fOZPtNZtrr/wRrMfVnF
	 2j60pbtJ6hWpfKQa7KB2OZKJ6MVp/0vCxO6uHD6KrHWQqBZ6kEPkhf7pZQJr/102YE
	 T1jWWci85XBcjR4t7bz+BKek9UUwRB2J3+EJ11gmbc4zCByQt1yfpJBpmjxqNfMqkG
	 3ToKl+ijDkkohsVu6wnXupOLnIvcJUBY0ztyBT2+7I01TALqv+YgH4HIxdTJWXPF21
	 OCt+c8Um107UgPvZi5Npr/ihPA+ggNXAevh4vJJClnZvexnYba42/50f1AwJmO7j+o
	 2kw3fJzuWq5fA==
Date: Fri, 11 Sep 2026 11:41:43 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 13/23] modpost: hash module source per-file, not per-byte
Message-ID: <aqPYvKR_eRsFlEd-@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-13-5dc1ac01672d@kernel.org>
 <434a7a10-d83e-4402-be91-816bbbc15bb7@suse.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <434a7a10-d83e-4402-be91-816bbbc15bb7@suse.com>

On Thu, Sep 10, 2026 at 02:52:50PM +0200, Petr Pavlu wrote:
> On 9/8/26 10:55 PM, Lorenzo Stoakes (ARM) wrote:
> > modpost spends a long time md4 hashing module source at a per-byte
> > granularity.
> >
> > Fix this by doing this hashing per-file instead by accumulating a per-file
> > buffer in parse_file().
> >
> > All 11,189 .mod.c files and Module.symvers were confirmed to be identical
> > with this change applied.
> >
> > This is especially impactful for allmodconfig incremental builds (where
> > CONFIG_MODULE_SRCVERSION_ALL is set).
> >
> > Whole build, 128-thread Threadripper 9980X, best of N runs:
> >
> >                                          before   after     delta
> >                                          -------------------------------
> >   x86 allmodconfig, touch mm/vma.c, gcc    40.6s    38.2s     -2.4s (-6%)
> >   x86 allmodconfig, touch mm/vma.c, clang  36.2s    35.0s     -1.2s (-3%)
> >
> > Assisted-by: LLM
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  scripts/mod/sumversion.c | 56 +++++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 44 insertions(+), 12 deletions(-)
>
> Support for the module srcversion is being removed in "module: remove
> MODULE_VERSION() and srcversion" [1] and scripts/mod/sumversion.c should
> be gone completely.

Hmm, that series doesn't remove the script though, is that planned as a follow up?

I guess I can drop this patch from the series then :) Also patch 17 I think?

>
> [1] https://lore.kernel.org/linux-modules/20260731-module_ver_remove-v2-0-c9163858f382@linuxfoundation.org/
>
> --
> Thanks,
> Petr

--
Cheers, Lorenzo
