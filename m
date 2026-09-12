Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D340364057;
	Sat, 12 Sep 2026 06:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789195237; cv=none; b=H9bh+ErezQcVWR66/l/wTxGQSu9mkYzI5RQy5f8qaHq2NayETc3J+RNpGO4wznlbzTzaAEseSK+Aaec4BKDW7MAHA1DKfecvXWrsu/OLBcDHhCGdu2zgcrb1aTsAXetw4nCdk0ToWkEgQHWmm/JAtP4o0IQgGHPBz9i8R2vZ5N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789195237; c=relaxed/simple;
	bh=73HcASfa9ubeRiLJbUYncqLlIecHiGYPMdxwy/pdStY=;
	h=Message-ID:Date:MIME-Version:References:Subject:From:To:Cc:
	 In-Reply-To:Content-Type; b=ZxZvnOIZAgeeO60GEUpPYlqxtYHyftU5luTQqM47VGwjF8DB6K3IbNANe+2jsHnPhWvWfRXH3nS9jqUUNHIVmw+2JCNgAwbbE79MePJs48cDh3kM5p+mjwfToqcFRN//dUOau2CniftBPkiV+5c9J0N23waS6mJv37CtIUBt9rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=TmVrjWWJ; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="TmVrjWWJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789195155; x=1789799955; i=markus.elfring@web.de;
	bh=YR7j9dMzXkMJqHtY3oDYzaidmdHYz1OQ0ntKtT7L6Lc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:References:
	 Subject:From:To:Cc:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=TmVrjWWJ2HIA/iUTT9irx56gzQSJVy7yKMWIUPGRIsBbbSRp3Uk3BE3h2GJYPJEE
	 NdKWrKFGzjysGONE0cz3/ST1IqJtH+oQHZRDRcFGI1ff3iA0UOIleD3cbJtOxjQLD
	 jnKXu2suLN5CG/D7Mv3cFCXkgGpNFc0nMxKX3r4fn2hLkhEuQBvNVp9DV23CwnLpz
	 ZnUOPQ19u68AhmaoiGX8QHindTNX6AiraLF0OdVGkVJ87ae0vMw1sPabndAEJ5M9b
	 fBqaLYbo5PZ/pCHJDY3xgNMHSv2s7qvOr7gUh03h3sqXEjGYelCvE8vxBT7d+Tb7Z
	 WP4IY9dIMbDMOOUeCg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MActo-1wyed91YyW-001OV8; Sat, 12
 Sep 2026 08:39:15 +0200
Message-ID: <ddf95d77-6f52-4439-a04a-d9a3e6fb47c0@web.de>
Date: Sat, 12 Sep 2026 08:38:56 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
References: <20260910102903.1b211f6b@pumpkin>
Subject: Re: [4/23] kallsyms: output binary data to speed output and kallsyms
 assembly
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
To: David Laight <david.laight.linux@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kbuild@vger.kernel.org,
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
In-Reply-To: <20260910102903.1b211f6b@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:WsMucXgwoU9JngjBdXMXeUaEmOopaD9uzD8XhMzRUT7vfovIHCD
 zuubIXWx2LMkeS2CERjkSJTAZuTQ/REtZMk0SBcxfCUh7xVV4Phwd+sZWQflZWcfgVyvjMF
 6b+MpmOgMP3iUGDLxUQINWyTXOxrqRpVITv8zYQf4+BKtD5nDbRie6MReWVDxUyKmFax/XE
 L70qJw5e8Y96DONsVCd3w==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JsgKGa/1rvw=;6hY24DWifUZtjMh9JPP/vB2DI9Z
 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

=E2=80=A6
> > +++ b/scripts/kallsyms.c
=E2=80=A6
> > +static void write_bin(FILE *file, const void *data, size_t len)
> > +{
> > +	if (fwrite(data, 1, len, file) =3D=3D len)
> > +		return;
> > +
> > +	perror("kallsyms: write");
> > +	exit(EXIT_FAILURE);
> > +}
>=20
> It is pretty pointless checking the return value from fwrite().
> Most of the time it is just doing a memcpy().
> Instead call fflush() and the ferror() prior to the fclose().
> (Or just rely on fclose() giving you that error status.)

How does such a development view fit to other known programming advices?
https://cmu-sei.github.io/secure-coding-standards/sei-cert-c-coding-standa=
rd/rules/error-handling-err/err33-c/
https://cwe.mitre.org/data/definitions/252.html

Regards,
Markus
