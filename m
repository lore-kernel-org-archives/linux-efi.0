Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEFD48A8C5;
	Mon, 14 Sep 2026 16:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789403689; cv=none; b=IvrdwnDK6jYqjtcJL9UXom6Zv4deWlOCKKqyY2jl4+wRd+BRTqNaogFmju9ESHHHlr4FmyKzCmXPKk1MaJNPrs/2lk0u0x1UjxNTKhhgXLeC6hv/rW0NnwDnwyWiaqIzzbrtHPKm3VVT4NHJpBl8xhw6y3sM3DuZDVETDv2T1qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789403689; c=relaxed/simple;
	bh=XAdePXDwU7itFaNIZ0P2WvILa3tvExnDTd0fO9CB49Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ZcwOBkR7rKzBGX5corxOFcQ35idBYOD+3pyNsdnKrDKmE87GUYEKEEhhqgCLnOL1yYkF2G27dg5dVYICHx3ZSUCV4XDcOWDePAahsKGpgzR7DEJUJYIlKTa4W6J2e0njauEawHH3p5qU+HoYUHDrb7iU9gW0F/eLK6tfv8DjkGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=mlsH7U8w; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="mlsH7U8w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789403630; x=1790008430; i=markus.elfring@web.de;
	bh=k2xterIyc7NfuEiAjvJir2Q84H7EAp4IgM+eTMJ3ekY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mlsH7U8w1jmIefiKN/HV+GjRNxLsaoUkb/xSy6usbMc0Zo6yb3GfGDQ7dBVdkZDu
	 zFeSqMjIIO00qvUWdT3jucN/qIc4oLDkkM54LUsSDCDcCaxDix4kwNd7SnQNLQbiB
	 GajxEMF/KRih09oF8qLNGY05JqKUjoSOSYL9xjP2urLv5iEU3MzMGBcm+chHyuuQs
	 5ww2VXNgTe5WaYnjNGrUnIKeW8O14HUzN48TzibQTKbryiUHcJPVtM8WDgC2L1KR9
	 C02MDRnjBnvWooiBQ/sDx+kFFBZOSFoDvOAX6N2o2zLIRcWyEBAqYBK9BGkD0ijB9
	 a30ywIIt75amKnBfBA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1Md6y1-1wXv4P17Yp-00eorI; Mon, 14
 Sep 2026 18:33:50 +0200
Message-ID: <a6e334e7-8420-4e5a-b54f-2e017d221ad1@web.de>
Date: Mon, 14 Sep 2026 18:33:42 +0200
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
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Justin Stitt <justinstitt@google.com>,
 Kees Cook <kees@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
 Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <masahiroy@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nsc@kernel.org>,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>,
 Tamir Duberstein <tamird@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, Will Deacon <will@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-arch@vger.kernel.org, llvm@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Jens Axboe <axboe@kernel.dk>
References: <20260914-build-speedup-v2-7-39817ec5db23@kernel.org>
Subject: Re: [PATCH v2 07/21] kallsyms: reimplement mksysmap in C
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260914-build-speedup-v2-7-39817ec5db23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2gC+/Kg/xSfwLU/hHleEmaf7kmBrkt2SIZGmOQ0rCfSqXclCZLc
 w7dQ+Eh0uB1xUSPrb4h6G3Bdxj3dOBFYnllbOgfrQMSaG7ILUBS/+ufZaDt40QIIuCE8yH3
 GGmFRwAKw9tPnUQ+KdB7AAWCChEtqmGUPTysCcguI45S62p2i9UgDjS1QCs1OGSW0aKg/wp
 ipuLsiPNNUt0D0hJ1/few==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:7KLsyzV8mlY=;iFHfcyhSUhNolow4Bhhi+C1Vtnt
 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
 M=

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
