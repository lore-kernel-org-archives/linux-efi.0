Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED662931D5;
	Mon, 14 Sep 2026 16:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789404942; cv=none; b=Qi6CQDCCz9w4JI5d0OLy7MoURVOxJgqO2EPeVtJW20b6seh54+d6gxEU2t/bgsfP6B69qTylc+N6Bun3zYcB74ApHqMbjyMP1jpDgzLM3lXiQ+RSm4OV8c3btp/UYu8nFNzxHfcFl+blaVhOgs5tPt27q+oAXrunmWMQpai19Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789404942; c=relaxed/simple;
	bh=cfGyAJju6IAwBmefv/KJLcbaUaGMqKCDKs/VreyqDYY=;
	h=Message-ID:Date:MIME-Version:Cc:References:Subject:From:To:
	 In-Reply-To:Content-Type; b=mD1rZNB6g31rk9/xcFy3tKGYhYrLqUUET7dAe5itjFI0HYiWAH6W52OltO7fX0Fj6hMcvzr1ojamy/eeZS/nMOqJkzC+LNU/WmE36cFHFrw4Z1buVXk+c+ctv3eEJfoQlAb1DgfCLS1wRHn5Qq+KMrwfv/iXsZWQvJZ5Qnf4EaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=uaA0JV3y; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="uaA0JV3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789404883; x=1790009683; i=markus.elfring@web.de;
	bh=F7+KY2shoyEWIdNt+YNDCfGAVPmZB0w+L+5YoQdBcCs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Cc:References:
	 Subject:From:To:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=uaA0JV3yNAZ50s9+BumSZ8ycrhPnWtCMQueRwQ2JO5RzZHsq1oNLl/kXywRTJY4P
	 9hot1KO1KuS0WgtB6G/PBmMxwXh9noSo7TAykucplDNXjZUozsch8psgz+ME/3zfM
	 i6rLroaUaVsrF5PCgsIAtSkS1R/iBhkrVyIT8hqWCdHJn1tOoFrDFCSVsqhz1XPWE
	 BgIcGiL4fFOJo29WB0Yp2n3jXpWKrdn8HMeoyabaO0a2vQ1S0vSq3glwZUUJp+05w
	 wlLS9nRjKI5/IBuZLICkyPNUoiV0oUuaLIKY1Yn0ZtBC4Qs+KE0bG9ev6xaHO3WFH
	 fmJcEII+kef7OeasQw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MZjET-1xLKUf1Zvb-00QqCo; Mon, 14
 Sep 2026 18:54:42 +0200
Message-ID: <84bd884c-648d-46e0-87fe-087acff0e58b@web.de>
Date: Mon, 14 Sep 2026 18:54:33 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
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
In-Reply-To: <20260914-build-speedup-v2-7-39817ec5db23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:/uOxbnXdA/7xBd7j9q7Ycyj0CrKvkU2/Jz94I6TScLeRmxR21iS
 x02ekrEkCvtsiVhcPCLQZ48WMjkqt4odxFFWL3bOPnPqdd2xtQTxHTteka1bRrxaRd4Wvxg
 L2bx6eAhmfeJ5MNOaxEqm/4kXa0mjWtxju7GBpEnjoo7a0mMh78ertRoKC3YP11/jRr3E1Z
 57e/rrtlMoRfM2SBHYGbw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:reHoXF3L2AU=;1U24L8dwH6KwXmW5tru75+ze7Q9
 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

=E2=80=A6
> +++ b/scripts/kallsyms.c
=E2=80=A6
> @@ -838,13 +834,33 @@ int main(int argc, char **argv)
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
cumentation/process/coding-style.rst?h=3Dv7.3-rc3#n572

Regards,
Markus
