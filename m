Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F9D47C0E6;
	Thu, 10 Sep 2026 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789054965; cv=none; b=uqZpHhWW4VhWb3IYUuUn0vlNNivFRNnFgYtKLdVf+qlml2jIDTPAS/tqp805UoR9gyXwDah9y62aBfUCPjFM1JTI6uTSgv32DbvidOvzz0QKq+qhkIck+okeqxtbyJV1lzQgTyCPCjC1MvWKQFV3hMy3q9QZIGq1tVKi2fZ5R9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789054965; c=relaxed/simple;
	bh=LK8bkV1Vz0floem0tDs4fowSkN+VH/bI8JorqlPfxFI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEhI2adnYKEjFaB2+xveoEcnm1S+SPsbE1Uz9LCU86YqeHWXdnnTHw21RWTjXLKf1N5Y8vJuBOuJjYv6HhJjzDQLqleeHV6ioNF47LrlwLAPTvUIWxJ4UlRqZPeVL81F9unhRwSSjy4rQdcpyB9WRSVG3eRdwXDjVwb4Kh3i6S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=m2t/gCBQ; arc=none smtp.client-ip=212.42.244.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="m2t/gCBQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789054956; bh=LK8bkV1Vz0floem0tDs4fowSkN+VH/bI8JorqlPfxFI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m2t/gCBQ5Ji+klRB77okzADkIBpOjucABpFdn1joI6CGFroNQ2dok89iTW7zlsgDJ
	 OhupApf9LKIRvcGE2XGbdgRc1L/Cyu778E8qiCt5Mx3N/HSwPKfTDWrLuQBULuYETh
	 DEpZTMKIWNIB95kcOEYyM+KTdXBA1kly0af9dVc2J1yCQpvugpbSIq04iHmdW/EGZ3
	 Y4A/qaU5/ks6TeFtBhGFS/mS3OdzSq+oJRGgjHfaRsaS82LquTqTSeUDZk3Yd/dQog
	 lg48YsTm0IrzSWtTPbK8Ble4vH9U4bTyk8isOlH6ribTe1cTR6+aKHV2VGyYR9cK7K
	 zTVgF+ct8Jfhw==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aa2cfec-6dc7-7f0000032729-7f000001a7b2-1
	for <multiple-recipients>; Thu, 10 Sep 2026 17:42:36 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Thu, 10 Sep 2026 17:42:36 +0200 (CEST)
Date: Thu, 10 Sep 2026 17:42:35 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
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
	Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 12/23] kbuild: avoid re-running compiler and linker probes
Message-ID: <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6NJv2EjhorC/TYUZ"
Content-Disposition: inline
In-Reply-To: <178901395292.3971858.13236774094648272066.b4-review@b4>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789054956-F1CDF0BC-4895A414/0/0
X-purgate-type: clean
X-purgate-size: 2705
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-03  mail-id: 9AB3CA045E  external: no


--6NJv2EjhorC/TYUZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 8583d9f06c52..3c92c87254a3 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -144,6 +144,44 @@ config CC_HAS_ASSUME
> >  config CC_HAS_NO_PROFILE_FN_ATTR
> >  	def_bool $(success,echo '__attribute__((no_profile_instrument_functio=
n)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
> > =20
> > +config CC_HAS_ZERO_INIT_PADDING_BITS
> > +	def_bool $(cc-option,-fzero-init-padding-bits=3Dall)
> > +
> > +config CC_HAS_NO_STACK_CLASH_PROTECTION
> > +	def_bool $(cc-option,-fno-stack-clash-protection)
> > +
> > +config CC_HAS_NO_ADDRSIG
> > +	def_bool $(cc-option,-fno-addrsig)
>=20
> I am generally in favor of this proposal since I think these checks
> should be cached by Kconfig where possible to clear up running them
> twice. That said, I wonder if we should pick a better dumping ground for
> these checks other than init/Kconfig. Maybe init/Kconfig.tools or
> scripts/Kconfig.tools or something?

Yes, skimming through the patch, I thought about that, too.  Moving more=20
cc option checks to Kconfig will make building out-of-tree kmods with a=20
different compiler more dangerous.  Maybe we will have to make the=20
warning in Makefile's prepare (external kmods) target a bit louder.

> I also worry about backsliding and growing cc-option checks. Should we
> update the documentation to state that it is preferrable for these
> checks to live in Kconfig so that they can be properly cached?

Sounds good, yes.

--=20
Nicolas

--6NJv2EjhorC/TYUZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEDv+Fiet06YHnC6RpiMa8nIiabbgFAmqiz+cACgkQiMa8nIia
bbgNERAAgCLMWkWnCF5POqjQiZGkZbm/i9SwwH2BVVg0H8Bf+O6WGCZ4YiM0NOu7
6d9EZV95NkDD36Y3vCEaq1/GclFeUn2ET6HEprS7tQsmYbcofxLYoQuMV/5Si/18
jJBz3eksIZYRAnSFGG6K1+Hq3u63l3cV5TmRaquZg76LwJkTjCNsFmfT2wxHP40y
LmkyOsw9NiHo2Bm75Bz8ds7EVqHU/wPxCAWBuiw6ervOrw4RR7PURz61DaBGIuOc
9B/HnhACn44debha9z9dUTsDIsPsK2sftFLfgJvD8c1V8vj6D1uhX7Fx/hXRElRA
srsyf2q67EuQ8hKIU8sch6rKkD9slQJd0/w2XNQsONffnO9RghF+Qu8dzo9mUusZ
l1vYg30SglV5c7m1FlgCvvmvJSppryu6zZw4FgzOUTfcxt6l+VXTm9jaigCWPXbT
KAYgvQqNVVgkIAg2WDqyiVTeWQxrxo9ctf3m/6srxI4/AkuGZV/XU2m1QiQJxQ5/
rdm3WGYjD/gVrLPBr6oIoPWDSgP7C4U4kSuZGq1jWAhPeqaa691z+Z5WbRVoVDO/
SEc1cIdDE88/z8QwIEsgmaXaVhnaCiW66Npfh9zP1J+/pQV3kvU4kf9CIEQ6QMDf
MPfl1Si0rJA9thzauvNi6Mu6JsUi9FPz7+Oen1Y22eMfv2st6Sc=
=TUj9
-----END PGP SIGNATURE-----

--6NJv2EjhorC/TYUZ--
