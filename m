Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351A932143D;
	Mon, 14 Sep 2026 17:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789405295; cv=none; b=IYVhGHb2XqlffrXvI8+n/PKW5GYqcqSaxwMaQ/JLEtc+W0Hq1glnZ59OWHcMLKRvE9+aDD93HAz3hi0ATySpmX4QbaVo8ENp7i8uv/l8HPyu4DmNeohe2iijreDeFx7sIgJ5JV9A082zN9DIE+H0oFPcZJy/KAkidPqX3PYGpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789405295; c=relaxed/simple;
	bh=+FAWVHdMZteQR4U3PWSHxXwSw0I30zDv6DHTjcR9Lkg=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=NzmlOwYb//MrODbtt5infZrPYlvwPvkRoW7xpMorbpBXVRaH/Rf2t33/xI7AoYA0AtoXOFvtX4ldafjcoxJim+1v9rzK3cb9HU/jIAw/Ip4nsq1LjhmBspqrC2JhnzsTH22n3K+LapGwczrXx74ydHAlLN07dAe9EkqnOshGR68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=AIVtcrvN; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="AIVtcrvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789405291; x=1790010091; i=markus.elfring@web.de;
	bh=+FAWVHdMZteQR4U3PWSHxXwSw0I30zDv6DHTjcR9Lkg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=AIVtcrvNGPq5wDS4chE9vpJI9xwqd09LikOclM5LTfsfn7xzshXxOOAAsYViyneS
	 RDLe6MJWTPsyQF8UXkdoFStbf8/Kn85kRNI07DVJ7ptBqz1dOcBVL/I3OVyZ+yYeW
	 zIheRkk5g4IkbXTqw5RrMDUB7TrXsmWOy7vSTS7VFoHfPFDlQ4v4OLSYl8XbyhuFy
	 DVQbOmlfpw09aV9M+y2sosNaoy39wBfd/7vWi4AOSjFy7piFRoP7bmw3AVCKeG8jr
	 5LWGwvNizExaXTujrEZNErbdpj3OhhmDxe9DBBpqmzR4+PWHUlUS1tf3yXCrPmQfg
	 xt220c/voe1IgO+drQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MpU1u-1wRa2Y1t3k-00kq18; Mon, 14
 Sep 2026 19:01:30 +0200
Message-ID: <acd1cdc6-71e2-4fab-9d56-0df704c66b81@web.de>
Date: Mon, 14 Sep 2026 19:01:26 +0200
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
X-Provags-ID: V03:K1:OVbNFCPrp2lwo8qoPIjvLpRQGh0MTzc/0FlBpHdLKzU6RUI0Ot8
 +EqxbhlOfdsqXKgnhdCskOTz/f1eIbeDeaw3ZqKwEJvm0pzGCfHl2liQgkquMvrNv9/ysf3
 hTIFA/of+Hn1SuZaMKxw4IsIYEYSI5H+xJVH6sZAqqhvkmKh+0d2OikM0AqwpHzTb2GSiUq
 i/xrQEO+aOzgdIGksgfHA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Hx3gTUJrCmw=;CThha3odVGxLtL7cynA051xApg6
 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
 Bxo5InWKPI=

> mksysmap is a sed script consisting of 30 patterns which link-vmlinux.sh
> uses to generate *.syms files, and which kallsyms is then called against=
 to
> generate *.kallsyms files, with the final vmlinux build ultimately
> generating System.map.
=E2=80=A6
> This is unnecessary, instead have kallsyms simply read the ELF file
> directly making use of the existing elf-parse library in scripts/.
=E2=80=A6

Are there further opportunities for parallel data processing for an improv=
ed
processing pipeline in this software area?

Regards,
Markus
