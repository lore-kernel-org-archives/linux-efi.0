Received: from mail-43166.protonmail.ch (mail-43166.protonmail.ch [185.70.43.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E024B66E7;
	Wed,  9 Sep 2026 10:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788949370; cv=none; b=YurhwLquXCDP8BGiiKed+L+g2blBW7HEqSJvWbho+ijnt1T2x5EzE2XtYloljPlyn1cNy0HyQeV+f93G+9FZfg1F6Xfof/2bJCWXZnxZZdrwtpT5LrWENyNjoLhQEiGERD6Sx/rhmwhe2c+DZbt/XhAwUhcx86zxiYxWxW2WrGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788949370; c=relaxed/simple;
	bh=cErN04XR2kGv1i2GRA/Gp+JKA/qXMFpcoKDT3eXGf48=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=poPLmjLpFNYB5tHYUd9LJVeOI6KT003L7BkprtX2tNAJvqnpkLkvVtCkrKduj+H/wT7Tclg1iG1FAPKt5hQOZDNit2/JrtQO7nhc3Brl58GFs0t0sWJQQSrf8DXOtJoJNxT3L48VkSJafBaUAMBIpbDBQytqQpK69BK16qHdFd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=FyZ5TvMu; arc=none smtp.client-ip=185.70.43.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="FyZ5TvMu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1788949360; x=1789208560;
	bh=cErN04XR2kGv1i2GRA/Gp+JKA/qXMFpcoKDT3eXGf48=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FyZ5TvMuM3Xxv5Uzhar57D+/F/CzbQI9Nc7boZjPQ6zKjeTnMXkpNyBP7JbAk+bz/
	 q87GN3qkrPsh1ksLlzQBUNR1zoF7toF94y+UZQcH7gkMNVfAx7WuX2WqtjsyXoUnPw
	 eSLBsKpAMAWXivq0KUr3IsQdh8ETLkW8Y8JqBFnLmNtmmWuuApOv6Vr/Xvk255Wh7u
	 NqrFComiGwqy/7YMvXKEfuvq+yDiVGQmWKKbv1wX9fnHmUoYeZrm4v7Ig+C9PdRmfI
	 yYIR7L8jXMECk5SfckftB0rSpEtgOduxZPyUm+yeG06lBUgdWoT6jAthkIQOmPoYMh
	 qC+n7EC8R2fEw==
Date: Wed, 09 Sep 2026 10:22:33 +0000
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
From: =?utf-8?Q?Bj=C3=B6rn_Baron?= <bjorn3_gh@protonmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
	<boqun@kernel.org>, Gary Guo <gary@garyguo.net>, Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
Message-ID: <t8iID_-Rgtrxxg-f1ZfdOg1xmm7YedvOT4pgDFEXKxoIeu29-JooZ3SSlbze088O0kLSOdgP7xN_Bo9Xm_lO1x51Gd-gIgT-tFPfwM_gCEw=@protonmail.com>
In-Reply-To: <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org> <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
Feedback-ID: 27884398:user:proton
X-Pm-Message-ID: 6e566d54cdb8b110ebbfb62f2bd2ea449ab508ec
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tuesday, September 8th, 2026 at 22:59, Lorenzo Stoakes (ARM) <ljs@kernel=
.org> wrote:

> Use the -Zthreads option to have rustc perform builds in parallel. This h=
as
> been available since rust 1.84 (rust-lang/rust#132282), and the kernel
> requires rust 1.85 or above.
>=20
> [..]
>=20
> Generated output was confirmed byte-for-byte identical.

There are still several known reproducibility issues for the parallel
frontend[1] and at least until fairly recently there were also deadlock
issues and incorrect errors[2], so I would not recommend enabling it withou=
t
an explicit request from the user. Perhaps even only allow it on nightly
rustc for now, then you don't need to check which of the two spellings of
the flag is supported.

By the way, currently backend parallelism is entirely disabled due to the
usage of --emit obj (which forces -Ccodegen-units=3D1). For -O2/3 builds
enabling backend parallelism may have a bigger impact than frontend
parallelism. And it would make incremental compilation for rustc a lot more
effective as editing a single function would no longer need to codegen all
functions in a crate again, only those inside the same codegen unit.
Getting it working would require using --emit link to produce rlibs and
then linking those rlibs in the place of the raw object files. Rlibs are
just static libraries containing some extra rustc specific info that will
be ignored by the linker (no guarantees about this, but there are no
guarantees --emit obj can be linked without missing symbols either and I
don't know of any reason why we would change it right now. It would hurt
compile times due to needing to repackage all rlibs before rustc runs
linking.). I tried implementing this a couple of years ago, but back then
if I recall correctly either binutils ar or llvm-ar was unable to produce a
thin archive referencing members of another archive like Kbuild expects to
do. I'm not familiar enough with Kbuild to know how to skip the thin
archive production.

Link: https://github.com/rust-lang/rust/issues/?q=3Dis%3Aissue%20state%3Aop=
en%20label%3AA-parallel-compiler [1]
Link: https://github.com/rust-lang/rust/issues/?q=3Dis%3Aissue%20state%3Acl=
osed%20label%3AA-parallel-compiler [2]
