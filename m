Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44D4AFE08;
	Fri, 11 Sep 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.42.244.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789150247; cv=none; b=EqjKMxjboHAEHGB9QK109mDr4946Lmh/jendB/0leT06/IZ8MlHebjNIJmUdGmPV99tKp6JxTh49tut6lTkoXiGNdD0OOxzRcYD4g8bZzzbKsLrR0V1uB0P696KnNF+CeQ9YuOM+aybzvsU/wGFq5lgI6rneR+MZ1LHUmcgebi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789150247; c=relaxed/simple;
	bh=HiXUwfB+4U/xUpyEGVb/EMeam4+iG8adYAIKsP37yh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MI2i2LwTqrkWevB/DA7Ks+LCc4ZCnB3ApFg0Z8iUAmOIzYnt6pCKkdX4L+FQGqM74s1eQa4O8G8Wz8jfjsEcDoO1QoL7r0Fxb6y2b8UEn4alrkilKKspJTd8A9OmMA8ok5WK2iwZVqnEsuS5sSL4R3VMWmmugRPEss1E0bEHVUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com; spf=pass smtp.mailfrom=fritz.com; dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b=hR+36mzQ; arc=none smtp.client-ip=212.42.244.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fritz.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fritz.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fritz.com header.i=@fritz.com header.b="hR+36mzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fritz.com; s=mail;
	t=1789150227; bh=HiXUwfB+4U/xUpyEGVb/EMeam4+iG8adYAIKsP37yh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hR+36mzQyixe5THHS68Z7oZZlRIG+Ih3UoLL1BWcc1NKiHu5yfuvvZ3PeA8HsaaZM
	 wpqKNgAnhSoLeoOyyesVQrqn/GY9K8f5+aevV7RXvVGhSStcQ7VkeKrLQjj6x94QMP
	 bj5Mk8xS1JwoSKDhzLKC2qy15uZyyr9WI9dQ55ZEMhAq4RZcgj5FgoVbR4DaqHSq5Z
	 J6YPaTOtocigcccnEQy5vXqhN0RJJwBJEmkMfeokD07s3b8D6hERPE+UmNWFIbBIDQ
	 CpF9zDCxgqafA2mNB0r6jjir20f3LIolX/B4doBNUVqwmyCG317UaapcsrukyZzjYq
	 M4A5nOMB9H82Q==
Received: from [212.42.244.78] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.57.1)
	(envelope-from <n.schier@fritz.com>)
	id 6aa44413-6dc7-7f0000032729-7f000001d950-1
	for <multiple-recipients>; Fri, 11 Sep 2026 20:10:27 +0200
Received: from mail-auth.fritz.com (unknown [212.42.244.78])
	by mail.avm.de (Postfix) with ESMTPS;
	Fri, 11 Sep 2026 20:10:27 +0200 (CEST)
Date: Fri, 11 Sep 2026 20:10:26 +0200
From: Nicolas Schier <n.schier@fritz.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
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
Message-ID: <20260911-mottled-gerbil-of-abracadabra-bacb17@l-nschier-aarch64>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-12-5dc1ac01672d@kernel.org>
 <178901395292.3971858.13236774094648272066.b4-review@b4>
 <20260910-translucent-sweet-sidewinder-7acacb@l-nschier-aarch64>
 <aqPXj1nDQ06KRhf4@gremlin>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="iQrCf81kTXDdOy/g"
Content-Disposition: inline
In-Reply-To: <aqPXj1nDQ06KRhf4@gremlin>
Organization: FRITZ! Technology GmbH
x-ms-reactions: disallow
X-purgate-ID: 149429::1789150227-F94CE0BC-0719254D/0/0
X-purgate-type: clean
X-purgate-size: 3410
X-Notice: Whitelisted
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-pfmilter: host: postfix-mx-03  mail-id: B7F39A0438  external: no


--iQrCf81kTXDdOy/g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 11, 2026 at 11:30:12AM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Sep 10, 2026 at 05:42:35PM +0200, Nicolas Schier wrote:
> > On Wed, Sep 09, 2026 at 09:19:12PM -0700, Nathan Chancellor wrote:
> > > > diff --git a/init/Kconfig b/init/Kconfig
> > > > index 8583d9f06c52..3c92c87254a3 100644
> > > > --- a/init/Kconfig
> > > > +++ b/init/Kconfig
> > > > @@ -144,6 +144,44 @@ config CC_HAS_ASSUME
> > > >  config CC_HAS_NO_PROFILE_FN_ATTR
> > > >  	def_bool $(success,echo '__attribute__((no_profile_instrument_fun=
ction)) int x();' | $(CC) -x c - -c -o /dev/null -Werror)
> > > >
> > > > +config CC_HAS_ZERO_INIT_PADDING_BITS
> > > > +	def_bool $(cc-option,-fzero-init-padding-bits=3Dall)
> > > > +
> > > > +config CC_HAS_NO_STACK_CLASH_PROTECTION
> > > > +	def_bool $(cc-option,-fno-stack-clash-protection)
> > > > +
> > > > +config CC_HAS_NO_ADDRSIG
> > > > +	def_bool $(cc-option,-fno-addrsig)
> > >
> > > I am generally in favor of this proposal since I think these checks
> > > should be cached by Kconfig where possible to clear up running them
> > > twice. That said, I wonder if we should pick a better dumping ground =
for
> > > these checks other than init/Kconfig. Maybe init/Kconfig.tools or
> > > scripts/Kconfig.tools or something?
> >
>=20
> (Sorry hadn't seen you'd replied also!)
>=20
> > Yes, skimming through the patch, I thought about that, too.  Moving more
> > cc option checks to Kconfig will make building out-of-tree kmods with a
> > different compiler more dangerous.  Maybe we will have to make the
> > warning in Makefile's prepare (external kmods) target a bit louder.
>=20
> I guess this bit can be a follow up potentially?

yes, sure.

> >
> > > I also worry about backsliding and growing cc-option checks. Should we
> > > update the documentation to state that it is preferrable for these
> > > checks to live in Kconfig so that they can be properly cached?
> >
> > Sounds good, yes.
>=20
> I can add a doc update as part of this series, unless you guys want to ha=
ndle
> separately?

I don't think it has to be part of the series, it's long enough already. =
=20
But if you want to prepare some docmentation about the preference of=20
cc-option checks, feel free to go ahead or not.

Kind regards
Nicolas

--iQrCf81kTXDdOy/g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEDv+Fiet06YHnC6RpiMa8nIiabbgFAmqkRAoACgkQiMa8nIia
bbh/KQ//Samyl3M+cgoMbxZIs/cR+MwpyWz5bB6lThR5UVELLhuPCTUNC7vWi1ML
vr3kXdcn7sXCBHA4hoe7PhlINVSGc5kaWiIyry21IPlsJ0ekFdPF8B40PL80yjk8
y/uU49y0qpRVqTKgSw75t2oyL5boj5TPFwfPRQT8UY3WtvNFyWWLqxP1sq2H15Rb
8PF/3F1o5b2TdURepbF3drc33OzpVoHQBe+4OWezT8HKe6wsvTlUcpxhnt5eMp3D
pVCVlxwL4SL0l5JC6gUkCq9DcCL8SltfEvUdAPQbcRCyz6ZgME/zI9Cic7j1b3fn
tyRHMX+hGWWeDvOpIj7iued1yGWB67DmNfsTeQi7VYR8nFF421w48w8WbVZZV6i2
8m4dzzmQE7+k574d98GJVHQHR150J1j5OnktE4no2ncIlywpYgnnPFV6dQgjl5ZW
wlLDK8Hb/224l9Iedak4vWld3VMCNTjn72dDV9LSZzsioM/xNqZc/0tKBnOa67F8
kbMjM6J4jcmUxuAEWqnSxhBv4t5TFWL9C1nVduQten5kqNWvYdyRuo9AQoeCyRmc
74nUR4m7g8oCKCGxDYB0oymnuE7HwmtMAQYsq99gZiUVenSZfHl2SXoEdQlWsaTl
Lr54hkpu2IMqPkMg1EPuCi4U+4x1GAt2mcZAsPaFTXV4lMKhfjg=
=hl7O
-----END PGP SIGNATURE-----

--iQrCf81kTXDdOy/g--
