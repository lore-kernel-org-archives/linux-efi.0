Received: from mail-ed2-f6.google.com (mail-ed2-f6.google.com [74.125.228.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89034560AAF
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 14:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964538; cv=none; b=c157khydeQbSvhqtPYV05a3q0S56pRaWCDUDk1+ojtaBwZlFfXNoiMJykgM+e+PWrfqBOmMKQhPTjETno+Ump3BgNC8DYfBm+RCQUA+h1WnqUo69vvqieKppe9Bu175wP8h3hNO9RH6Z+upTzjlSTBCODEnFH3+zXDnGKBuCTfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964538; c=relaxed/simple;
	bh=C8wlVunptoThlz2K9sFX5JRkjNXNpZt+isVUJZEm52E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJcpqNCMUkuuYdpyyW0f8vf2i82m4v4OlW4sRnxCBFGS5bVEiikUAiraNZFn1I9ronDSevmU6LVS0jVf2Xv6qbx+ZcIZmGS3TClkhCIPvhlcV/Ulpb77XMv+QT0iQdVcMS1SUYs5xky/qwQfqQgxjTBTFP12leVv6esv7CSDJJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L1xe6jUQ; arc=none smtp.client-ip=74.125.228.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L1xe6jUQ"
Received: by mail-ed2-f6.google.com with SMTP id 4fb4d7f45d1cf-6a406d7afa8so2704009a12.0
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 07:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1788964534; x=1789569334; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tG9J5Co/VVYH+Cridb4B9lUnRMf0qj5TUZQIt0oEj84=;
        b=L1xe6jUQB67l0OFKf28/2YOXA7hezFgrl/LqTkkigFFMPOkCUE1G+ZLMDET1GTt2Bq
         TencobZcK8eZX1nxPDKkbMZZbvQpuDhavB0OVkeyVTdugjDLSU5wfWUi1i+axhRz4Hdq
         LJUCGYBKv0JbbzQ5MdOvu2jbzxZ0rx1US8jO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788964534; x=1789569334;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tG9J5Co/VVYH+Cridb4B9lUnRMf0qj5TUZQIt0oEj84=;
        b=i8iRc4JbZYAOTX47GkTp+s1+HaDeOV3S7LXm1PfdFU1TExcstlu90tVuiMZDlUVptI
         01f15DnAEACjvuJ6BlZuiay6d8Oe6yZ8Qkg0WIqJP+VR0EXddEegVBgL64PDki6381eP
         uqsgpIfZslOndYkZT6KxAXvUCZa9DD1v6CZWk1/5iVe/Jp8Fjm61qao6ylpI94+bdX9E
         39JYkHjk7iPKx0TMOnr7TBjAaN9JLNG3YPmmepIEPQFQeEBGESars/QsX1ei9O9pbyav
         goyFcW+GDURW2EXkfjpOVZXGy0bgIs6s1o1KD7uq4CbnRXWDSqV6rYTBUIkD6Nclip1k
         7SQg==
X-Forwarded-Encrypted: i=1; AKwUvByS/L9N3XzxDWo2DJiBtGVFcwn4UEMMguiEK9Hfi0/ndhvewJrsYJStnPt+ovjKfZifAPlIqIvUKMM=@vger.kernel.org
X-Gm-Message-State: AFuF++ljSYIlKAGcpihAL7d4ApFEtC7jiSB90+g7FAPRRIcbvoXoVA3L
	WWO141oHB0ZG3C7uwR1Y0ITZGS9Zw/K6NUWnG0O4NSlXjt1wnSukCxDCtKLWlbavjH9xL4s5T4t
	TAryhJVs6wA==
X-Gm-Gg: AYBFou2GJP/fnP1sYSnUDpI4Ssu80AWWh5qHAItJJCeI/m/8xHy1JJ7g2UHzgnCPJ5/
	783CASlap8/jNw6DIKR29yseGIoBSELpvCUIvH1yN3F1zcFKDpH2kovAmwNwK7xlvWD5seJ3lt/
	Zk+c3WdKV94LqFrQH+nEKtw/mi5Zf/KZ4AqDCQjxxaRNNfQkFsGVQXvdPovdLqysnWsF5OI7VvJ
	BahO0fvupwkY/3ng15qevx4F+SpQknM4rqw9cWiI4kjXIIHTsS6hxT7x7GAm8Kdz2hp8opVFmCR
	ZeeL5YVr0rBE2KWoFkBKKMoMo6h1bmXSoSZaCf4CpUuyuIqDJMSTZQIYDNe01O4ZTiC8o+k1wAM
	WwPkjmxvpjmbBPnpnVQv+UD4UudcbNzVMARFnJVk8WhC0gf4JCUuTyKs8qS6dLT5/01NvNIEsVq
	bzxhNTd9RW3NfpBCtz6OnHguU1tuvzusb0CIlwwhAi5/yhazR4XKptBO6D6Nck1RR2o7VztzvJO
	sRVtyOPD6zGPwh9j2F8eNi/S9bkr13PES+1yUCkmOWruHulQRLgwRRP6t4=
X-Received: by 2002:a05:6402:a0d9:b0:6a7:ee56:615c with SMTP id 4fb4d7f45d1cf-6a7ee5662efmr10975023a12.30.1788964533698;
        Wed, 09 Sep 2026 07:35:33 -0700 (PDT)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a995a42765sm973445a12.27.2026.09.09.07.35.33
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 07:35:33 -0700 (PDT)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a9983162dcso953795a12.1
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 07:35:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzvRlWw9HtAUbPC43s9tZ1c5xVmEYUuTymIApklJ2SXD26+kvWBH/yGsxLNz1oYGoh+ceAaiEAjrws=@vger.kernel.org
X-Received: by 2002:a05:6402:208a:b0:6a7:ee56:615d with SMTP id
 4fb4d7f45d1cf-6a7ee5662fbmr12667373a12.31.1788964533277; Wed, 09 Sep 2026
 07:35:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org> <20260908-build-speedup-v1-4-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-4-5dc1ac01672d@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Sep 2026 07:35:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgryL8XqjFcO=EQwKdqNn51BANiv16QiqYKCUdXxDQBmg@mail.gmail.com>
X-Gm-Features: AcwNN1VOdEagBQA5D63IF5vfBaLV4II6ehpTsThafIib6q5kHaeURBrIxknkBpc
Message-ID: <CAHk-=wgryL8XqjFcO=EQwKdqNn51BANiv16QiqYKCUdXxDQBmg@mail.gmail.com>
Subject: Re: [PATCH 04/23] kallsyms: output binary data to speed output and
 kallsyms assembly
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

I'm finally going through this series, because I do care about build
speed, so I love the concept.

However, I haven't actually applied it and tried it, I'm just reading
the patches.

And this one triggered something:

On Tue, 8 Sept 2026 at 13:56, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> kallsyms generates an assembly file that consists mostly of .byte entries
> containing compressed names, token strings and name-sorted sequence
> numbers.
>
> For an x86-64 build with 158k symbols that is a 37 MiB .S file which takes
> 0.57s to assemble each of the two to three times it is built over a kernel
> build.

It strikes me that this is clearly a bit faster, but it still seems to
be not really fixing the underlying silliness of that code.

Wouldn't it be much better to actually create an object file directly?
Afaik, the *only* think we ever do with that kallsyms-generated file
is to immediately assemble it into an object file, because the actual
asm file is useless to anybody.

And we already require libelf as part of the build, and we already
kind of do things like that with gendwarfksyms.

Don't get my wrong: I think going through an asm file was very much
the right thing originally: not every architecture used ELF in the
first place, and when scripting things like this the current situation
makes 100% sense.

And no sane human wants to deal with this kind of grotty detail and
spend the effort on writing an ELF file writer.

But when there's a LLM that was used to find these things and help fix
them up, and it's something this mechanical and the result really
isn't ever human-readable and never has been, I feel like the obvious
step would be to just ask the little helper bot to switch the whole
kallsyms to using libelf-devel and writing an object file directly.

I don't think anybody has any deep emotional ties to the current
kallsyms code and that horrific step of the kernel build, do they?

               Linus
