Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA78C44839E;
	Fri, 11 Sep 2026 19:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789154209; cv=none; b=NZWjD2twoHBOuzhpFqobka1TBgnWkVj/cfrGYBnoZsaL2bNGBCj+O+Jl/QBmrITTmQsWypJQXe2HWN7DUKFPkk1xySG8ARaq9XolLp58hId1MIJU4/6+sUA8DhMLyJhlfBe/j6LJiv5xGzTUnUu8TLkDvMoG6Anyk43l2G6xGEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789154209; c=relaxed/simple;
	bh=/OPifpwNBBwCsqW4NVO3v9FiQUIof82RXBe74H8BPjU=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=VTjOoq27PouuSKLyBTFzkusMidq8pVFEazb+br/IvJin6U6CQ2VfZ1dXcqxdczX556wSgjc1HB9UCpeCVXUON4GdDN71rplY0GlqPLWvRgbvzYE1nE2uldL6zwVMp2tv8Sl+EQ58wdLEKEINqK+/WCkhkBRhZBjSPhj32TsjXIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=qaJn5ijU; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="qaJn5ijU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789154127; x=1789758927; i=markus.elfring@web.de;
	bh=crOTx8FOU7qIu5wbIdCS1jM6sx3HEoR0Ko592oa1O2g=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=qaJn5ijUKOFFT0F86RNGE8NmQMTa8UMZRAHa5GQ29pr6yvNNxjN37LiIvqIRo+3t
	 EzuD4UrDDICuNNtqi1f0ZeKB0327FdIM1DiG8PiSiJg/CHt6f+vsu3z98mbOfjV5V
	 xh2yex1IPYQSjal2pDMSMuDdtlTpJeApdjZEIpdBu8G1YyQOOThDomLz4L5Az/7rw
	 RH9rVTZrTwk1p32aRGgMBCXNmWcdJdggDyPnFXQw5cJ+jMOOfmIRn71h6U/KBBYxO
	 5gJC1qatwR58tEsBps/Y5eeDyAjpJX+6udND8M/4M1AdgwFtihVM/aQ8cqTojmvbH
	 x3bqOIAvfVN1ZEfXoQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Mr7am-1wR7LU3BNG-00iMoa; Fri, 11
 Sep 2026 21:15:27 +0200
Message-ID: <12c3cc91-1809-4e32-9b2a-41eb692495df@web.de>
Date: Fri, 11 Sep 2026 21:15:22 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
Subject: Re: [PATCH 08/23] kallsyms: reimplement mksysmap in C
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260908-build-speedup-v1-8-5dc1ac01672d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/x+OsbmElVwf5Xr46t9ZEbCOBO3JA8QaryZZvSUZB7UYRmY8q/J
 ngNPu1O18XT4ijr15o/tTU5dy9vLzvBJM8EoqYrAS9DyeBt6Ur8Bk0Uln7pIUk+t032R0DD
 R+OPOh2Z6s8PSS1DT+X6NI5EkGMWXwNlVHgeOFBwkAWKY/qPSip+IHCAduR2no0eePXt0RV
 zB8K+3EuSvdH+1PbscbcQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:I5utK3vWekU=;GG9Vm3PSSlEvthedOdYocq24T4r
 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
 U=

=E2=80=A6
> +++ b/scripts/kallsyms.c
=E2=80=A6
> @@ -852,13 +848,33 @@ int main(int argc, char **argv)
=E2=80=A6
> +	in =3D argv[optind];
> +	if (sysmap) {
> +		sysmap_out =3D fopen(sysmap, "w");
> +		if (!sysmap_out) {
> +			perror(sysmap);
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	if (optind + 1 =3D=3D argc) {
> +		read_elf(in, sysmap_out);
> +		if (fclose(sysmap_out)) {
> +			perror(sysmap);
> +			exit(EXIT_FAILURE);
> +		}
> +		return 0;
> +	}
> +
>  	out_bin_name =3D argv[optind + 1];
>  	out_bin_file =3D fopen(out_bin_name, "w");
>  	if (!out_bin_file) {
=E2=80=A6



How do you think about to avoid a bit duplicate source code
by using a goto chain?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv7.3-rc2#n572

Regards,
Markus
