Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377344AD4B5;
	Fri, 11 Sep 2026 18:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789151105; cv=none; b=QNsH910ngB6MJvwRqohIlvdDg2YPmQBDe9uQJNY0nU7WFuVzbmTVXAKRnnTagidONzwPL2tgww4+/vF4uuw4X+wDPMVG3y9JN/aHoFYIqKf///yd71gB5LvSo4f8hc8j2HU1sgSE3cAbdeDH/P4E2iTq2iaHkvPUdS/MORiTBI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789151105; c=relaxed/simple;
	bh=8i6j2kj0J2WWxOx2+kQFd3c8jjZ5eNeBsSQ7ZDg5KOs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TLGTKBa88oKwQ4Mc6iHZUlMTsgIoBFbmZS5SgP5Qwf1CdY8qX7pHPfeneSy7W0V8POYt2YEhiFKCowcnDrOT7aB1r6vEiCqkhxGPgHLytFkDx7IJmcWK/CjNcT+NwwhQuaP2u+zKQOviN0SYLjWW7GZLJC9prdVzTrF0g4zfZcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RlyhOewu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RlyhOewu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91F51F000FF;
	Fri, 11 Sep 2026 18:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789151103;
	bh=KKNF1BR24z2hq8JFatue1wvWlNPndjqBIvnaGAC0Uqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RlyhOewuf7WxDS24cLgcR2lbriVrR+lDPmqXJfTUdN7HYmOtPDB7j29KJoKmkpr7u
	 9dqd9F2fStdlb21DzGnuUfNIyWROL1gANAZJ0qjYWB/6XSgAE66XdKzhjEvztMH6y/
	 WNkeO+nCbxN55cNXSDyzriyPcgD6rjPOPIYw0L/X8Mo9q2WLBD6vR9suM9BrdAOCwm
	 cE91VtBDpXsIt+yE63okTLAec+OzU8mjS9nuLiDwWrUoQHXbcg+8fewCBFye1Z/s/i
	 Cf5IKRquZU9fbuPpaiB3MB88n5PvmtmvjQc+S508IpZltqFEuRdIU52lhVvEaAEoVf
	 0f7uPMOW2n9yg==
Date: Fri, 11 Sep 2026 19:24:50 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nicolas Schier <n.schier@fritz.com>
Cc: David Laight <david.laight.linux@gmail.com>, 
	Nathan Chancellor <nathan@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
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
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <aqRGYXKDzXZMXmmp@gremlin>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <20260911183333.1df0f2e2@pumpkin>
 <20260911-invaluable-indigo-seal-e31aec@l-nschier-aarch64>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911-invaluable-indigo-seal-e31aec@l-nschier-aarch64>

On Fri, Sep 11, 2026 at 08:17:57PM +0200, Nicolas Schier wrote:
> On Fri, Sep 11, 2026 at 06:33:33PM +0100, David Laight wrote:
> > On Thu, 10 Sep 2026 17:42:35 +0200
> > Nicolas Schier <n.schier@fritz.com> wrote:
> >
> > ...
> > > Yes, skimming through the patch, I thought about that, too.  Moving more
> > > cc option checks to Kconfig will make building out-of-tree kmods with a
> > > different compiler more dangerous.  Maybe we will have to make the
> > > warning in Makefile's prepare (external kmods) target a bit louder.
> >
> > One problem is that distributions have a nasty habit of shipping kernels
> > that are compiled with a different compiler version to they actually
> > ship as a compiler.
> > In some cases the versions are clearly the same - but the version
> > strings differ.
>
> yeah, I guess you hit the mark.

I mean this is a problem that already exists for any flags already specified in
Kconfig.

Out-of-tree modules are historically something that we don't go to great lengths
to support and haven't historically worried about breaking, either.

I'm sure distros can find ways around this if a problem were to arise. But I
don't think it's something to worry about all that much.

I expect a _lot_ of these, in any case, would only require the compilers to be
within a fair few major versions of one another anyway.

>
> --
> Nicolas

--
Cheers, Lorenzo
