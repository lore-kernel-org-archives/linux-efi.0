Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61B13DA7D9;
	Tue, 15 Sep 2026 07:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789456274; cv=none; b=UamB+Zh7Z1QF99IaEIg9Xbrw2Uj9syzy/yI0XR94vG0eHi6aMNjGov+topOKVFYSxNKNk+G/p5qMVBcMfOlA6CkLR+HR2h/Jy0k0VaIiDLXnOtpMmeiNJlbR323GLzNq9QqfK1Sw7mOFYOEzR41LfXSNVf5fP6Vv8csVK4AxexY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789456274; c=relaxed/simple;
	bh=6i4/RL05AsH0u8lSSfOYmVcdaEig/sADLhJUw3fG/kQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UCrRTci0jFRpY6kZ1qUgZEFVzCGwJTCEiB89sc6n3kyQmyOls9RAC6QXXOXEENnhxUXvJYjIFXAjfouMdxasgfHY0HlX2+gxS/KDzDwSu0SQEQrBTb26RNC8foV/0zaOciGozkieODrX329iF6pgk9RdNtQONRa1u4WOQ8Qhru0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=JuuGrPJz; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="JuuGrPJz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789456226; x=1790061026; i=markus.elfring@web.de;
	bh=6i4/RL05AsH0u8lSSfOYmVcdaEig/sADLhJUw3fG/kQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=JuuGrPJzd97qqbQdO2Ezk7sxB+6OXf4M07QJfz4umUXP/7o97LrF7WsXYv/P0Ftd
	 wbKiS4yj2B2z4dxjLIh6mHks5oHjaOgiuu/kynTRXO+gDjuGvcqQMSWChvm3Xx8Pm
	 iWPXcx35/NkDbh91BODPQn8yz6FknQ38pYeNtIMUcCfvbyJ9o9k05mahHoqauwhxb
	 8u3k5zucMkcJ4R07U/8Oygh0EOziZOLUyd/Fpc5fhh6uXJWlaPdsQIiMriCD1q+7w
	 oKFilLlH1FtDU9jyx70nnnuLamn4/70JtQUA7/aiGC7/TVUG0VKURufOUe279XvrO
	 Ck4OiHlZnZibXPn3Bw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MsrhU-1wmMUE0WU4-011EVF; Tue, 15
 Sep 2026 09:10:26 +0200
Message-ID: <381ad17b-72e6-4368-8876-29495f4b423e@web.de>
Date: Tue, 15 Sep 2026 09:10:06 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 03/21] kallsyms: output binary data to speed output and
 kallsyms assembly
To: David Laight <david.laight.linux@gmail.com>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kbuild@vger.kernel.org
Cc: x86@kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
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
 Trevor Gross <tmgross@umich.edu>, Will Deacon <will@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-arch@vger.kernel.org, llvm@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 Jens Axboe <axboe@kernel.dk>
References: <20260914-build-speedup-v2-3-39817ec5db23@kernel.org>
 <cda4d320-599d-41c8-a37f-827688b552f9@web.de>
 <20260914224432.7ed40d48@pumpkin>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260914224432.7ed40d48@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:z9QsGsd064Uaid2dUAwEK/Gc8rGYeRnLz9MLfvAMTSbhw+M8uKw
 4y3MBC02CYo8KNID/LyixydftWnhIHnQ1LXK/L1nGPT2Go5Z58+PcZZJzwzKcilkhBFFVHW
 ff1gjZqSuE2zy1cOY7OcVqsHgluaJg+Mjgbe2a2V5Fj97DxgVABZ4LOtouJxOnux5HRUMl+
 NGqE4hiTEAAnupsDTbMXg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:vX1ImXBe8w8=;prPyxlMg8EeUTeIzMX/la0ABKWc
 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
 COp4leFAhxaGu08CbA5NjV

>> I suggest to avoid return value ignorance a bit more.
>> https://cmu-sei.github.io/secure-coding-standards/sei-cert-c-coding-sta=
ndard/rules/error-handling-err/err33-c/
>> https://cwe.mitre.org/data/definitions/252.html
>=20
> And I suggest you do some real coding...
> The error is sticky and can be checked using ferror().

Are there further warnings to reconsider also according to unchecked and u=
nused return values?


> Code that looks at the return value from fprintf() fwrite() etc is very
> often broken because the only time they can actual fail is when the
> buffer is flushed during close.

Is this a special implementation detail?


> Adding error checks to every call just make the code unreadable.
Some developers got used to corresponding programming possibilities.
Interests might grow also for aspect-oriented software development,
doesn't it?

Regards,
Markus
