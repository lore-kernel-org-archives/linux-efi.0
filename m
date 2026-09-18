Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95723D3CEF;
	Fri, 18 Sep 2026 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761273; cv=none; b=M7TGXoDmwlGmiskbtg/PoYVa/fr4zPGFPoSGWjNmdSuS2u3JYcR9y5/CuSx3pTgCInjVQrhQDtOFtdHgEuVctktxhqmDvpzLUcML1zLKigO9vp50bQBTg0sIL8/m/igx28fwxUOpwJY5+BV2ZNjWvqmHX6wqanz9/UND8A+9NbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761273; c=relaxed/simple;
	bh=JKkgIua3kpizh32NNqU1zVU4J9KvaFpPPrVmLN48emc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqs3kEQl4VGtM5iuh0z7t1EGY9lfOGVbBzEULQctsb/C5NdBBP57MPALwdqLEhftrMr14MZyRpKgYV9hXYQVNoS1+4HxnY/ALQULAiE0BZ+dPB1s9UvRcXDqfTy8tP1xQ8choNjyXTNZcmnujb9O376H/F2yYCRsbNsp0VoohNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=Y3Haz+T+; arc=none smtp.client-ip=212.42.244.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="Y3Haz+T+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789761269; bh=JKkgIua3kpizh32NNqU1zVU4J9KvaFpPPrVmLN48emc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y3Haz+T+fPTF6wAuhVZOXAxXZs67ULnV0g8BUG/DktxFVFrFAEr9eqX03SQrnV+vT
	 YZueGMLvfoe2AYpfP6aT9j2htVca0pIvRKlNddMMoHijDk+es3NOe66e0B/y/xSUpL
	 /ilOPtZp6TpJDHcJ8o5kk36gU04zB8RfdXt/gLj8a75Ty00NmsGG52Y/fUwxxpHzAI
	 /y2MRARUAhBeHzAHGfdXPJAklS2kpSf0phtNA0dGkDpFupKcxzbmLraYa7mL+oS91w
	 GvwQapwwZ1bNu6Kl1f6DPnr1MEwIZIclBDxMRjA/cxhzUAML+Cqv/JshxhDN/h/s9T
	 KtJb3aIuDhn8w==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aad96f4-03cd-7f0000032729-7f000001ad04-1
	for <multiple-recipients>; Fri, 18 Sep 2026 21:54:28 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 18 Sep 2026 21:54:28 +0200 (CEST)
Date: Fri, 18 Sep 2026 21:54:27 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
	linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 10/20] kbuild: move the toolchain checks into
 init/Kconfig.toolchain
Message-ID: <20260918-athletic-agile-echidna-114f16@l-nschier-aarch64>
References: <20260917-build-speedup-v3-0-9ecf4163ff36@kernel.org>
 <20260917-build-speedup-v3-10-9ecf4163ff36@kernel.org>
 <202609171149.6454DC6@keescook>
 <20260918010729.GB1585590@ax162>
 <aq1MG8I1BsUUDFkx@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <aq1MG8I1BsUUDFkx@gremlin>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789761268-177ACEE1-09F10706/0/0
X-purgate-type: clean
X-purgate-size: 2499
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-03  mail-id: EE9C1A02D1  external: no

On Fri, Sep 18, 2026 at 03:35:57PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 17, 2026 at 06:07:29PM -0700, Nathan Chancellor wrote:
> > On Thu, Sep 17, 2026 at 11:53:13AM -0700, Kees Cook wrote:
> > > On Thu, Sep 17, 2026 at 05:06:20PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > > Move them into their own file, sourced from the top of init/Kconfig=
, so
> > > > that the next commit can add to them without growing init/Kconfig f=
urther.
> > > >
> > > > No functional change.
> > > >
> > > > Assisted-by: LLM
> > > > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > > ---
> > > >  init/Kconfig           | 197 +------------------------------------=
-----------
> > > >  init/Kconfig.toolchain | 198 +++++++++++++++++++++++++++++++++++++=
++++++++++++
> > > >  2 files changed, 199 insertions(+), 196 deletions(-)
> > >
> > > Yeah, totally right to move to a separate file. I think, however, I
> > > would prefer this wasn't in init/ though. Kbuild uses scripts/ as its
> > > Makefile.$topic dumping ground, and Kconfig.include also lives there.=
 To
> > > me, this new file should be scripts/Kconfig.toolchain instead. And
> > > arguably, this should be included by the top-level Kconfig rather than
> > > init/Kconfig...
> > >
> > > I defer to kbuild folks, though.
> >
> > We talked about this previously:
> >
> >   https://lore.kernel.org/aqPW1FsBVYHSWl1r@gremlin/
> >
> > I do feel like scripts/ is a better location given that these are really
> > things internal to Kbuild but I also see where Lorenzo is coming from
> > that scripts/ is a little weird for this to live for discoverability,
> > especially if we want people to put checks here instead of in a Makefile
> > directly. To be honest, it would be kind of nice to separate the Kbuild
> > parts of scripts into their own directory to make it clear what Kbuild
> > uses versus what users/contributors should use but that is obviously too
> > big of a project to tackle as a prerequisite for this.
>=20
> Yeah it just seemed really weird/surprising to me (in the sense of
> 'principle of least surprise') to put that in scripts/ and it doesn't seem
> that traditionally anything else like this lives there.
>=20
> But if you guys feel strongly enough I can put it there.
>=20
> And agreed probably a 'third place' is the right way, but probably not
> right as part of this series :)

yeah, then I'd also slightly favor scripts/ for now.

Kind regards,
Nicolas
