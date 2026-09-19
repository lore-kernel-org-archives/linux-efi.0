Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC91D2222D0;
	Sat, 19 Sep 2026 17:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789839853; cv=none; b=hPtEii4PHq5KQM8ondfxHDFM7JXEto0+Aa1kK4OCEonfjhcFuu8DZJuZALAA0gL5yCktnY3PBoSq3Co8/kNsdsfWV183vE6UtQQg8LBG9Vor9qMeBA3q9rhko3pYE1mQUi7xrMplkrCPg3szQ2h+Osb0XPYuNtzkxzmOsQLScvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789839853; c=relaxed/simple;
	bh=v6VvYmFiXlar1IemoKJGxYAnY7TIsrPjnrZVgumjnuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qo22SkpA8vgnspFLZugPpEQq+YAAIdPxDhcMGhX3CbAsSMTEKMbeS9XcTarnBcQ8zmUajT1I08uxPRmJIhTvfdY5WP6BV2VmnFldxzXO7nYiRZ/5Omb6R9ZeaQ596boyH6o2W25LbtVbgfiKWjoV1xSaJSnJNurzFSE+5YIkHfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyjIipdw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyjIipdw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72A11F000FF;
	Sat, 19 Sep 2026 17:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789839852;
	bh=plN+c/BYldO0ndQ5BcS5qGCDo4Hxnvos4lynYvhEHTo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UyjIipdw0tt8GXYTTY85zRh5fU/oDzYyGbnpiDXd9mc0DxbAGXWMNiiFraMESgiUt
	 I3SeGIMBcWTmorAmEhrShRdjbTRy2V9HjHkTI37D1HrVNj/9uHppjSHx0X9TD9jmqt
	 a8Nlc8m16jqnatgXe4mxAcSNuRy9loWMrE41gywF2Pj12ABb4US7KQnBV5W74MhQME
	 7k46wJDeQnMlIoYaZYlgL40fc6u1R1aGw0yvB6NgLzDsGhVtrMrAN0ry8iTi+MhDnR
	 EIA4u46W2q6JXXRJDK4wqs7opyUEVzX9nxLDiU4cQoABSxoZ7Uks175IbBpTLFZAIf
	 t1gZFBEcSPIvQ==
Date: Sat, 19 Sep 2026 18:43:58 +0100
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
Subject: Re: [PATCH v3 20/20] kbuild: compress the kernel with pigz if
 available
Message-ID: <aq7Jp_mKucBsuXff@gremlin>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-20-9ecf4163ff36@kernel.org>
 <202609170955.C6EABD8C@keescook>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202609170955.C6EABD8C@keescook>

On Thu, Sep 17, 2026 at 09:58:04AM -0700, Kees Cook wrote:
> On Thu, Sep 17, 2026 at 05:06:30PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  Documentation/kbuild/kbuild.rst   | 17 +++++++++++++++++
> >  Documentation/process/changes.rst |  8 ++++++++
> >  Makefile                          |  5 ++++-
> >  kernel/Makefile                   |  6 +++++-
> >  scripts/Makefile.lib              |  4 ++--
> >  scripts/jobserver-exec            |  3 ++-
> >  tools/lib/python/jobserver.py     | 13 +++++++++++++
> >  7 files changed, 51 insertions(+), 5 deletions(-)
>
> Awesome; I love it. (I may send a follow-up to improve the PARALLELISM

Thanks! :)

> token so things can define the fallback instead of the hard-coded "1",
> but there is only one place I found where that might be useful, and it
> will be totally separate from this.)

Ack, seems like it's open season on improving this stuff now which is good
I think!

I also believe there is more performance to be got in future series ;)

>
> Reviewed-by: Kees Cook <kees@kernel.org>

Thanks! :)

>
> --
> Kees Cook

--
Cheers, Lorenzo
