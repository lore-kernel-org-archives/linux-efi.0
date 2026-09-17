Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2C3C8C5E;
	Thu, 17 Sep 2026 19:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789673209; cv=none; b=Z+yZI0oWU6suOASWhtUl/fSlogTo0WlfxAOvSeN5EjnlogORXrHhLiOOsiiNoQMwoGjToEGL1veafMfdhhryXhlzk768zWy7AyQJWlaTqZ8vbGU8OR62hXHFUn1wqVJXJ2KLJ/z4c+TVqIxUBXQ3TymtiZ0yO7cetd4LZ/pzBkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789673209; c=relaxed/simple;
	bh=sLNR1VrVQrg5fZCZqzVgyN90HNPd9kpNh4iWmwIstVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAwNutOUaUDh3u+PZSsuw6cxRddPZCsSaL79s49Qhtm4BwCVAC6xKcQXNFxY4Vfa9NyZx7J38MjKGpbSbnPm9//9//DmCScHQPcif4q4O6EvMUVdOmnXjJcNSuhtYyr2JDI7nhK5vyqKgy795A2BVCn+d9kR8lBX1DyIRX936vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA0+ZurD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA0+ZurD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43BEE1F00893;
	Thu, 17 Sep 2026 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789673208;
	bh=tKOCZwNuNXOngsboEdPOUV9vT2nY2ya3k2ROGwA7c6Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NA0+ZurDlEpVuuCDIkpnrqgQBFewSXi8OY2zE80Fn2mcwapiTZTUaN8FcSQ/8eGhH
	 nWFnaSmZLxyBeDWmJBstaZ4rW+XEzaRpW4W/NTbFnQMUDq0gkayC9qQGfQOStZP4Nv
	 I70w6VaTsiMRSQFspGg3kO2C8EWhdcz7aWxn0H/WkEnpaHOLr0PsISd6Re9s9ZdV2T
	 TPmMcPMT3rBFBRFl015oY9/BHwhGxaeUASAxazYyIF5/I4vIDcAFdjGn7423mtpHl8
	 wsQpIGdpn9W4s5uffjjCKUDDk2VijedCAfZ+MAEA0EESn/X/3FZCd4ae7lLRXVpMG9
	 KOCbhKCUHM3+g==
Date: Thu, 17 Sep 2026 12:26:48 -0700
From: Kees Cook <kees@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
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
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 11/20] kbuild: avoid re-running compiler and linker
 probes
Message-ID: <202609171154.BEA5134F7@keescook>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-11-9ecf4163ff36@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-build-speedup-v3-11-9ecf4163ff36@kernel.org>

On Thu, Sep 17, 2026 at 05:06:21PM +0100, Lorenzo Stoakes (ARM) wrote:
> Each kernel make invocation begins with ~30 compiler and linker runs each
> of which performs duplicate probe for a number of compiler and linker
> options.
> 
> This is useless work - the compiler and its version is known, so use these
> to determine which options are available, once.
> 
> A convention already exists for this - CC_HAS_xxx, LD_HAS_xxx in Kconfig
> files (for example, CC_HAS_COUNTED_BY), so convert these probes to Kconfig
> options where appropriate.

Yeah, I agree about the rationale here.

It does, however, now drive a long-time annoyance of mine to the top of
mind: the repetition of the compiler command-line options in two places:
the Kconfig and the Makefile. I dislike that pattern so much that I really
really worked hard to use cc-option instead where ever I possibly could
(though it continued to add to my growing concern about the repetition
of running those checks all the time, so I'm motivated to see something
like what you have here actually land).

But I would really like to find a way to avoid the duplication. It's
fragile and it's weird and it's split across 2 files that don't always
have an obvious relationship. I really don't like it. And with it being
used for things that are "detected" (i.e. not part of always required
builds), that fragility means typos may go unnoticed, etc.

We've had a need for some kind of kconfig "append to a list" logic that
we've been working around in places, e.g. include/linux/lsm_count.h for
how "count the list of enabled LSMs" got dealt with. If we could have
had:

config LSM_LIST
	list
	separator " "

config SECURITY_SELINUX
	...
	append_to LSM_LIST
	...

We could just parse CONFIG_LSM_LIST directly. And I think we can do the
same with this:

config CC_OPTION_LIST
	list
	separator " "

config CC_OPTION_ZERO_INIT_PADDING_BITS
	string
	default "$(cc-option-bit,-fzero-init-padding-bits=all)"
	append_to CC_OPTION_LIST

And the dump all of it into the Makefile in one via CONFIG_CC_OPTION_LIST

(And we'd need to implement ld-option-bit. Though really I think
cc-option-bit should be renamed to cc-option-str or something)

But even without the new "list" Kconfig type, it'd be nicer to use the
cc-option-bit string default method and dump all the newly created
CC_OPTION_... strings into the makefile manually. The "append_to" idea
could be a follow-up.

-Kees

-- 
Kees Cook
