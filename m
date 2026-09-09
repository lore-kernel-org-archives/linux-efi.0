Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DA0569F1A
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968032; cv=none; b=LxBSbqhPvcupyEhQTyBTdeCsHXfnYZD6I7BptvUsfDosrYFKrfgChAVNHxB6oDBavL52/oCf9kKMASyv8OOsxSA2yOMNI1qCpWMNEbdz7hv7S0n+W0q701N01QyMnwsMjLLvpWZHg0UMFJxCIe5oYtypCXlCeltvqhYvnw8CDsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968032; c=relaxed/simple;
	bh=qF8PC9Ug90yk/PrOmZBC0YqOzOPUdR+ADtjc56MP5mA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EmoA7N9/FkQdjO+Y9uciDTBgE2T8qZqAr3oPNNRk/t9faxf8RzumHuKMZolbTNVCYKU3ZWK11HGorvzLTosHKXClop+BRDUxLuyLrZ+Zfj9hTBoQrTPN8K7WF6+y6hJlntEb43KNwjQ9dlssNp2mcylYdiH+rtwmX5yhvZx28Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V845b/Dl; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V845b/Dl"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b89a0e69dfso1701e87.3
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 08:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1788968028; x=1789572828; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9JHU6Yr48iRYl83IyQpODgW1j4SilTECHHS/aRaqSbs=;
        b=V845b/DlkIRTxiAVEiekmMmfn7niugLKTJLV5FH7Y5hnWq9CYstkw34cxnATMnzO0c
         3ekDDCvmBt5vSV6odAi24rkphXt7VbTI7gzJTj9cpvYSDvBto1Vo5KP/ow5ccGw/PDo7
         ukypo6huCJoMDyxgz06MQCCipnbSSHWcnKdCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788968028; x=1789572828;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9JHU6Yr48iRYl83IyQpODgW1j4SilTECHHS/aRaqSbs=;
        b=oF46Flst/RPsKTP7rIZJYiDYsYhZVu7vNiJU0So8EZTESGUeut2K2dEBUlH43L1OrV
         5jTpe1hzaLQb7HOn+u8I5A7hhgN+/9HeoXgeBwMSfv38d5K/kgc9oztbr/n90RzRO569
         hCYItM5DBDcSWzo5M/YpCYmxV5QQkerokQF8jYjb77TUOXcQGK189hHwcllrHa2FNakA
         VJvbb9aJRnSD/eBTxyl/WDJ1WQCq3TLjP/lCgqHaPEoSboEkGV/rakLjpNjnbL/8KQ0A
         LqE5nbQO/QFlXw6mKL1Ju6rufChXMjm0eclJOLl53Gol9BChkx2yaFjfUkFoUcx4PCOE
         tLpA==
X-Forwarded-Encrypted: i=1; AKwUvBx3/yqD7p2Vzf4X4h2Lpk1Ju+IAeZ0x7RXrmiaqmH8GbWBtQVqeOAnP5iwxJW8wcsQWw80KpbtG5kw=@vger.kernel.org
X-Gm-Message-State: AFuF++l7y2fwq8ZUNYzu/VwfFESxaPaUJovm72o4rT+uhEVAkerXGpKS
	DWDLP1WGDeYID5Z5Fx5T9DhxGyRQ6tHLGgkMh42pFv4pwyJdhZNOJxtSHTp2BXLEFtm2TmFhERT
	J5D5GTH9ZVUzY
X-Gm-Gg: AYBFou3r1uxOurtPPpk1G4P5WRV/5GunubBtlv69cg07rAjZDCDLcqSr6auiZy0Kg/+
	PBYdZjhPqCJV/cu+IGl1Lisa7ggIjIRUjUwWM4xGPb933C78TXiEHNC0Gjjb13LTvykUePiSQ/5
	klwYURn1ynmY6EWgUPB90IeEBBRBJm3iHe2TJGMCEQvVpuGtPwQqaUlGicuwsjKSniFuXKFNstW
	bcIl/Ow0PsNaQpJhDmIy8Eh6kATB2dDQDi8+21UQSoRIUS8QDXPKft2kPj5JEo5MalHStqW+d4j
	St3CzmUutWvGQV8tYIMaeDSRI9vNGhedWNKFSYKfbd4C7mkLaTGvfArwRH4us8SYqj0wxZbH/WY
	2CqvJo2+hc5FghsVoMrUYqEvwIoRRZWVxBVnfDymtFqdgVyc5/sK5+eboeNYz71COqFZPy9VZL0
	lJLnHd7ea2hQ6uLhUzkKzykL2o+TgwQDeAVhBsBGNqiiZ2aEehfNQ4iAaYmDUx1aWTy8ZakgNLd
	6jPy2R++U3k73VbR4nVmmRx5v93soa9LeqJetAb
X-Received: by 2002:a05:6402:43ce:b0:6a9:8db2:5c61 with SMTP id 4fb4d7f45d1cf-6a99cd344f4mr702747a12.45.1788966391122;
        Wed, 09 Sep 2026 08:06:31 -0700 (PDT)
Received: from mail-ed2-x10.google.com (mail-ed2-x10.google.com. [2a00:1450:4864:33::10])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e68c3b2esm7427474a12.11.2026.09.09.08.06.30
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 08:06:30 -0700 (PDT)
Received: by mail-ed2-x10.google.com with SMTP id 4fb4d7f45d1cf-6a9984f9adcso514653a12.0
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 08:06:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxIcbmA1aH3SHO5KH7ozdgWYsET5sgZol6umF7+4MfnVXZUmBx0ExmP7AP80+TjgFu9UjM2+1ArleI=@vger.kernel.org
X-Received: by 2002:a17:907:728f:b0:c25:8e4f:6d84 with SMTP id
 a640c23a62f3a-c2941868b12mr66185066b.2.1788966011712; Wed, 09 Sep 2026
 08:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org> <20260908-build-speedup-v1-15-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-15-5dc1ac01672d@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Sep 2026 07:59:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgAWpVHmR74jC7sbSJGQEHyaaN0awNfSz_SjPv3VGSYYA@mail.gmail.com>
X-Gm-Features: AcwNN1XmVo334b1UP-lcj3CPx7zvteJ2HddEJqKkfbem-zQh2qUu9HycJHabLtk
Message-ID: <CAHk-=wgAWpVHmR74jC7sbSJGQEHyaaN0awNfSz_SjPv3VGSYYA@mail.gmail.com>
Subject: Re: [PATCH 15/23] modpost: emit module descriptors as assembly
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Alexey Gladkov <legion@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Arnd Bergmann <arnd@arndb.de>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Sept 2026 at 13:58, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> modpost generates a descriptor for every module in the form of a
> <module>.mod.c file with .modinfo strings, the __this_module descriptor,
> exported symbol tables and (with CONFIG_MODVERSIONS set), the CRC of
> imported symbols.
>
> These files are compiled like any other kernel C file with all of the
> -include preamble, as well as including linux/module.h, header dependencies
> generated by fixdep of a few hundred headers, an objtool run and if LTO is
> being performed, a link is performed to generate native code.

This kind of triggers the same reaction as the kallsyms code: I think
not including <linux/module.h> is probably the biggest win in this
all, and precomputing the offsets of the (few) structures that modpost
uses then makes the whole end result fairly trivial in raw asm.

Fine.

BUT.

You end up with things like this instead:

> diff --git a/scripts/mod/module-offsets.c b/scripts/mod/module-offsets.c

where it generates a header file for those asm scripts so that the asm
generation can do things like

        buf_printf(buf, "\t.size __this_module, %d\n",
MOD_SIZEOF_struct_module);

etc.

But I - again - get the feeling that this is all going through AS as a
silly way to generate an object file, and that there really isn't any
obvious advantage to that side quest.

Becuase no human ever wants to see that asm file, and it's no more
legible than generating the object file directly would have been.

So I get the feeling that it would again be more natural to just
generate the object file directly when all those files really end up
being are a few symbol definitions and a couple of fixed structures
(is there anything but the magic "__this_module" thing and the modinfo
unique ID thing?)

And again - I feel like nobody sane would want to write that code. I
certainly don't. But if this was at least partly automated anyway,
going that extra step might not be all that horrific.

I'll also be honest: part of why I do these suggestions is that I do
think it would be faster to skip the intermediate assembler step, but
a big part of it is that I don't love the random turds our build
creates. Getting rid of the *.mod.c files would be a cleanup of our
strange build.

             Linus
