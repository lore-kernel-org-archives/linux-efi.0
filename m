Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6143CA486
	for <linux-efi@vger.kernel.org>; Tue,  8 Sep 2026 21:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788902000; cv=pass; b=VNAfvrWc0GHYUvnAhx6wvUg+21aQgfWJ5tcf/xV3tKK/QwfMaa9ltQX/11Yjlxrq39U1RMgyvJDDdCspBL6GkSK1KWPg7aMEvsGcReIesoWRTzKDF7GEiFVl+NY02mR+wMb8SABq0d+TslobiA58TDYd8JV5ElsP/POl4yzorFA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788902000; c=relaxed/simple;
	bh=ABcg7txfjreOEvrgYloSz7dmSAX99sKg32JTqnOhFhM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iG4oPeo+i/wdEa01HkpvOoMycK7a2yr+zEVBLETRc0XoEpEnLDRhsJhMgvmP8O1QdL6tpLYSKDaWBN04qcIZd2AKrbHokaMYwMvlL5K/rmjPd4EDqgyn+h6ak6kpxzP4L93roh61PEla1EvTJjKdqzFNeCElf3axe1LUJu3KXUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kPf6ZmPD; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kPf6ZmPD"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc46895f82dso161016a12.3
        for <linux-efi@vger.kernel.org>; Tue, 08 Sep 2026 14:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788901998; cv=none;
        d=google.com; s=arc-20260327;
        b=LdAWXto5Hspz06iT5CT6sKruXs2I4eO7Lsi6eHIeJy34G854BbpaqoFMzkfJscfWDn
         klUG/5FspLgCDdJzlZ4AnULe1HVvNKhI00mc6V9hoXlSI7LQKXyv9YdsaDKtJ1AXZ1/U
         HADRZX7d8b4duBWW+x/AFSjGNgBEvLyO7Ne+x/vGPt4vge5jk6e7GEIcil+5i9pNchZV
         Xlf+1G3Rqxjad1+eeaBCzS67i3UrfhYkol0vR7I43KducnCUb47T5lrU4eOn/UV2+J07
         2shEvg3eAHP1ZzQ1nvNBJUz7bEb5pQapydzTSW3Ts6W3NX8oYqZrazAQs2aKm7t35cv4
         cN3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0fhQV0gw/THBej21ZRoleMpcrYInoRUuBgF9MHF69Ek=;
        fh=p6KYON6JZd8MAsxjyBEYcaKdvse8xZ8YwG82UAMFW8w=;
        b=fwyL1hvJvXnLUKT/+yTybmlKTr2jZSH0wkU/spa1iHthczNLbubouj8tjXkm6fvhfp
         VZHfurQcbrKzjrse4mF6f/kSJC+SbsFh73VbYNbhRxFX9y00tVWCi7fWbxkWRQIEPEmb
         alE2wEkZQ39hp5h/Xy/nOp3BNwRnKwb4CSQV4NVI1Ts2N5pJF8ip7HJpZALraT5Xj3D6
         L0173wbk1x5KVJ39sWpmtBlHJvWF0JV179LcCR6z1mRkKYgXu6MZLOZu0Umn4a907/RF
         awGF7yOr/N9oW73Ttt3o/gJWdfzuUtkuiAx1ZX8ERORJzEjKdKpRS1ld5bg6Auv254BJ
         tdgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788901998; x=1789506798; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0fhQV0gw/THBej21ZRoleMpcrYInoRUuBgF9MHF69Ek=;
        b=kPf6ZmPD2v4AefzfbB96CY/1Ro8ul1IcFijnGdxXVXzXHHTesc60tRNbKo2R6qNiCV
         COm6UKvfUu6Q7EJ03xDCsbtZZbD+boDtakiCuWcq39IiGKN4AWNMMaVstLpEFMUY9fs/
         fA3Ai9ETukyNfyw4rNxQfgzC3yRmNdwLUvg5cs5n0LI7BG+oMLyNjugmjmLMSwmDxeii
         iJ9ESmD+qArHzXwghsJnFKtjbvVeFcor+5i9UXIjBUduxGmJNTr6bn/S+Vu/qGuE5X55
         I4+dUgYq6dDOehzn331667NXRaNpuSHWvSLVHlvtNcNxcI1Le57wdyswdbpjKOR//hsO
         L2cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788901998; x=1789506798;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0fhQV0gw/THBej21ZRoleMpcrYInoRUuBgF9MHF69Ek=;
        b=WMa8eo5K32OjnCtXY/xXtAIEev9AMPOddCfle7S9P4XOT9+h28YZdc0DtzO8LdH+rr
         xBsz9v/bQdsdqWXQSyC/zgvyT/b2NJp8fudUtmW1ovATlcFLK/hCPDFE51Y8ftm3kHUv
         4Jp7KBZALX4dBfISv22S61eFeelcndqgtFY3iMQzSCwDkEAB1XBIfvrFcCSLAlaqf3vG
         +8nSQsrN4Ntat6mBNrpaTOYvNqlT4abvZzjIlJY06E055gfN9Ae6Uw7J3zwXcewS0yQt
         cHNa7B/pRzZ50jlph8qcBp8srFJisCM7xy0JN1h/BuhOMqPU8Mnx6CRi8eV9+YOT4gWh
         dSKw==
X-Forwarded-Encrypted: i=1; AKwUvByRA60hxjZhJKrvEcHtSH+W8hoHd1+gbIdqtNUdON+A4xC0kjyZZKAXMq8uSCudGcgcPsupQIV8lkw=@vger.kernel.org
X-Gm-Message-State: AFuF++lGBhWZjNtRsgmGSG9V03NkZwix9M+Ro8cDCkGp38M+VJYYyM3G
	9qoKb8fiHhSCzbtFjhmNrHjK97I0a7hPELAL02PHZsD8nWEZsWOUSv4f52ZoXNnRwPVLWYkUEst
	yk7sxgP3ySjUFyXCDkwtX68E3EXsebBM=
X-Gm-Gg: AYBFou2NvD4JM9hyiH4TZ84w9ORCBhfrLj/hroZA2cj1zC/s+Q6RQwIEsRrDRoynYxm
	ckRfCVMV8f6Gep/DMrAwQOPA2zfQey9dwdZ9G53kUFsnoTa2FMywmzSsFnpisl8Y6rF8WTuZt2l
	M+VA4RvaUMWlRlh/djrTCIH4Jg8FGaN2la94IJvLaEfv2pYgn2b/z9t1XbAeTkk7xJvyFrJbOR7
	5NlB7Q3LqBskem3+/bnaAuXciZ+iX9g6wtL4wrd6fuQUPKn4E9dBl6Z98STAyg+1MHvm765a5dT
	ipo8fz4Ip43I2fpoF3DrUYy5KM1hEWEDAoZ0KAAbAqX/exiq9NgHW6cKO2Hk1HlFBN5TCug7Ho/
	znNsITFWbzwyhgEOMe2RGtQw+TrrLISu7g2se6ZoySFBg1woJeeWNiDDn72XG3w2ESe6Rumr0dE
	kEYfUiDXA22DZg0QjsJkXifQlEY+d0L31i46Js8qxYTDL6kzhFlaU=
X-Received: by 2002:a17:90b:3882:b0:396:a47f:d38f with SMTP id
 98e67ed59e1d1-39b268ce386mr30178901a91.3.1788901997757; Tue, 08 Sep 2026
 14:13:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org> <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 8 Sep 2026 23:13:04 +0200
X-Gm-Features: AcwNN1U58TdOwuasMFef5tH_3N3xyJMe8mAu14nPZtzZCuWKC0n_7MgG3XQZVuw
Message-ID: <CANiq72m5C5tNKUWTYYerBt81KtqRLgr-S4c5XLUN1uY5n7mqiQ@mail.gmail.com>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Alexey Gladkov <legion@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
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
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 10:59=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> A future -j/--jobs option is planned for
> rustc:(rust-lang/compiler-team#1005), so check to see if this available a=
nd
> if so use it.

This is already implemented in nightly as far as I can tell. If it
weren't, we shouldn't add it, even if planned.

(By the way, could you please add Link tags for those URLs?)

> +config RUSTC_HAS_JOBS
> +       def_bool $(rustc-option,-j8)
> +
> +config RUSTC_HAS_ZTHREADS
> +       def_bool $(rustc-option,-Zthreads=3D8)

We can simplify using `RUSTC_VERSION` for these like we do elsewhere.

Cheers,
Miguel
