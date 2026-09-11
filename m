Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E5B372ED0;
	Fri, 11 Sep 2026 18:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789152837; cv=none; b=VUxWP8OCBXQBpm8OcVJT3g0nWS/R1y5OBd/dLfeMmGJqyC9+WJxZHSb0BCdIEBoAtdjDodv195JngGI5KzaMVlrFFzKCKNhP8S2yrto1QabuTCvzvJeTbuuN0alr+8QenRtrCabZscZcPBEKIUG60pLIo6cFEFnWUTbOQ4WBsJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789152837; c=relaxed/simple;
	bh=XAdePXDwU7itFaNIZ0P2WvILa3tvExnDTd0fO9CB49Y=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Wbl3UoUaZZDLchT9RAPnmJQ1j0MuPEVSur9RAuo3vSQcX4HFlbaxFfjzbDntnGNBJpwntjh8jJIVJmbPIu1jT/jqbw5rCBwkkmfaM1eyuRXm3TGJN8cUAVQ+atiXOZW7vWPWl/wKks8ntpoSP0TmcOnznDjp4KItxkSskobH6xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Pn1311WD; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Pn1311WD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789152737; x=1789757537; i=markus.elfring@web.de;
	bh=k2xterIyc7NfuEiAjvJir2Q84H7EAp4IgM+eTMJ3ekY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:Subject:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Pn1311WDWoYYJ5yRs7kvRKJtxL9h7DNz7ynKbuSv448jciO1uMCiD25RteXBQD4y
	 2kKMZlt3vRuAER9m8mLyJHQiuXebcFwiZqU4oFyYm3x2JsEwXDAi+ffM7RVpnd1dy
	 2lfyU3vOb2/wLnmeaSDBSrsBrkEidGO1QsLRYVGKv7O47LyAoEkyoryTWfdZRqzoU
	 nwqzuwqlIu5rj7ZbkCwe+mfCX89D5tryofz9ggZfeAaQcb19D4rea25sY+Tgp/9Rg
	 WUIw+cO9/z3s34fSpTa9fflBh0F2+dN3wHpa+pT8KPbLmVo/rxz3HqzKa6eR9BjtP
	 khSHGC3qzV+9HTjjbg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N3Gga-1wfMEF01Bq-015OHo; Fri, 11
 Sep 2026 20:52:17 +0200
Message-ID: <d1a291c6-3401-4c54-9337-6456d18a006d@web.de>
Date: Fri, 11 Sep 2026 20:52:00 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [PATCH 08/23] kallsyms: reimplement mksysmap in C
To: Lorenzo Stoakes <ljs@kernel.org>, linux-kbuild@vger.kernel.org,
 x86@kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Courbot <acourbot@nvidia.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Alexey Gladkov <legion@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Benno Lossin <lossin@kernel.org>,
 Bill Wendling <morbo@google.com>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Boqun Feng <boqun@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Danilo Krummrich <dakr@kernel.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Gary Guo <gary@garyguo.net>,
 "H. Peter Anvin" <hpa@zytor.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Justin Stitt <justinstitt@google.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <masahiroy@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nsc@kernel.org>,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>,
 Tamir Duberstein <tamird@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Will Deacon <will@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-arch@vger.kernel.org,
 llvm@lists.linux.dev, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, Jens Axboe <axboe@kernel.dk>
References: <20260908-build-speedup-v1-8-5dc1ac01672d@kernel.org>
Content-Language: en-GB, de-DE
In-Reply-To: <20260908-build-speedup-v1-8-5dc1ac01672d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:uHq+4xme1zwTlolhjokYlMZFIrEC1qXlpWv0iUGaWCIw+RDnBDh
 BFRYe/xzuyD/qvHHsekt1u+xrs1OinaMIZqqLinxZ3AW8pn7MgMBoRm8PUJJAxM18qlotOO
 990dAdbsdsXReGDQ/8VMsVRDBY9ly8qM0L+D75Pr9wkWACG47evvQWtfLNvvI/FR5dty4pu
 ll38ahG0Y5Ju0mXpA1J5w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:HBju8oYOLFo=;OJOKCu5MbaezwtKn8xWhJ4fxA5m
 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

=E2=80=A6
> +++ b/scripts/kallsyms-sysmap.c
> @@ -0,0 +1,269 @@
=E2=80=A6
> +void sysmap_write(const struct sysmap *map, FILE *out)
> +{
> +	size_t i;
> +
> +	for (i =3D 0; i < map->nr_syms; i++) {
> +		const struct sysmap_symbol *s =3D &map->syms[i];
> +
> +		fprintf(out, "%0*llx %c %s\n", map->addr_width, s->addr, s->type,
> +			s->name);
> +	}
> +}
=E2=80=A6

How do you think about to achieve more complete error detection?
https://cmu-sei.github.io/secure-coding-standards/sei-cert-c-coding-standa=
rd/rules/error-handling-err/err33-c/
https://cwe.mitre.org/data/definitions/252.html

Regards,
Markus
