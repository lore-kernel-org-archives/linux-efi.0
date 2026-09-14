Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A8B35C6A7;
	Mon, 14 Sep 2026 20:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789417033; cv=none; b=ahqVw4arB/9IbXJls1DTYfarJLVB9FAVpR5fBA90ypr8d3PVNhCROQblDqI/vcTzqFL2uyMDjaKSJpG7bq7PriIHA0q/BjHm1J7RtE+ahBjOftDJRMDcA3JAmaAtiEqMuPYTGxk67kBaMFNDC3kw1xRMJvbK+WteGpMfV+678Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789417033; c=relaxed/simple;
	bh=l43bCuvT7rHBNQVPVWWF9wtw5PQNF0GNtDVbSpoy6N8=;
	h=Message-ID:Date:MIME-Version:To:References:Subject:From:Cc:
	 In-Reply-To:Content-Type; b=XJ386R6k49TqM50vJGUu0rRWTfacKkHX6ta7WQvubsFSSL5mCzhQ+LxBsM9zRcc31sRvauJG0KolB3y29SaIsgpt+U3st4TvILAOFU5slgkoX0g+IXBcAoR4EG1EzDDz/j0v7N+Zgv3PlqpzkMygujLt9q5Azv7vl6J9Fosacs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=j9/unOnZ; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="j9/unOnZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1789416979; x=1790021779; i=markus.elfring@web.de;
	bh=/OeoI3I3mTzQeIpxNN1ihFr58i9zgH7dzRy93a4mRvc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:References:
	 Subject:From:Cc:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=j9/unOnZmsYOZQaZn/CSzRNc1Rnp9KNTNoKf2sDDXWeetqJA4kudVuANVAjc3U+T
	 Y2Oj7Vy8UIGVMbS3icYOJdFuZbJ+a+oAG8z1dzoXhxjTqUSSKYd+oe3jUKtJevWJH
	 32beGnzmMrcq2p6oVX47PpNW6Vm1zYfTo+mISpffL0i/LFPp0thBP69j5ScXJvURP
	 e8Q+fVXq67KQTeMkxiVetwEjQ+zLe8hN9JaDGpPSthBlW7Jg71vsvIUHtzXaKbBPZ
	 h0lCTuaQg8UlNHsJwW4cC7B3HRZ3YWr6eTihikW8XDT3qmzEqEBzR0wzuPlP6i2NZ
	 FrSN4u3m/LzdY7hUAQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MQPdr-1xSOoN451V-00JQAd; Mon, 14
 Sep 2026 22:16:19 +0200
Message-ID: <cda4d320-599d-41c8-a37f-827688b552f9@web.de>
Date: Mon, 14 Sep 2026 22:16:12 +0200
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
References: <20260914-build-speedup-v2-3-39817ec5db23@kernel.org>
Subject: Re: [PATCH v2 03/21] kallsyms: output binary data to speed output and
 kallsyms assembly
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-arch@vger.kernel.org, llvm@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 David Laight <david.laight.linux@gmail.com>, Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260914-build-speedup-v2-3-39817ec5db23@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UV/hp/4O9Al1JA5dTapA8AqqYlEBVdnaBiPcklvQQOmNbR3yH96
 /cth1YvwYjx9HrzsLAFAgcScfqO1fM8cECg0vpVzvgsTSLWOsnKtCtDWgHSAxmsJN42U31Z
 tyyRDmkN/0gioE+WXTzaXA7jWlyc63ChkjbgNLAXt0BZX2k1IVyEgXJIqLWL9twwTJyPy9/
 Bhd9JtolM6wojkon7/5dQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dCZXeIx/2xM=;gC9Cv1SxlpXQPRDs9MJcrBP54Gy
 +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

=E2=80=A6
> +++ b/scripts/kallsyms.c
=E2=80=A6
> @@ -413,26 +438,24 @@ static void write_src(void)
>  		/* Encode length with ULEB128. */
>  		if (table[i]->len <=3D 0x7F) {
>  			/* Most symbols use a single byte for the length. */
> -			printf("\t.byte 0x%02x", table[i]->len);
> +			fputc(table[i]->len, out_bin_file);
>  			off +=3D table[i]->len + 1;
>  		} else {
>  			/* "Big" symbols use two bytes. */
> -			printf("\t.byte 0x%02x, 0x%02x",
> -				(table[i]->len & 0x7F) | 0x80,
> -				(table[i]->len >> 7) & 0x7F);
> +			fputc((table[i]->len & 0x7F) | 0x80, out_bin_file);
> +			fputc((table[i]->len >> 7) & 0x7F, out_bin_file);
>  			off +=3D table[i]->len + 2;
>  		}
> -		for (k =3D 0; k < table[i]->len; k++)
> -			printf(", 0x%02x", table[i]->sym[k]);
> +		fwrite(table[i]->sym, 1, table[i]->len, out_bin_file);
> =20
>  		/*
>  		 * Now that we wrote out the compressed symbol name, restore the
> -		 * original name and print it in the comment.
> +		 * original name for the comments below.
>  		 */
>  		expand_symbol(table[i]->sym, table[i]->len, buf);
>  		strcpy((char *)table[i]->sym, buf);
> -		printf("\t/* %s */\n", table[i]->sym);
>  	}
> +	write_incbin(out_bin_name, bin_start, bin_pos(out_bin_file));
>  	printf(".size kallsyms_names, . - kallsyms_names\n");
>  	printf("\n");
> =20
=E2=80=A6

I suggest to avoid return value ignorance a bit more.
https://cmu-sei.github.io/secure-coding-standards/sei-cert-c-coding-standa=
rd/rules/error-handling-err/err33-c/
https://cwe.mitre.org/data/definitions/252.html

Regards,
Markus
