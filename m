Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64AC55D874
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 12:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788958770; cv=pass; b=iWVKuoomr7f6PwW8YBd12xCmun+1l5rXdr/xcEo2XRN5Eq+df2IC3t2BYu0quBJ1RyafPackONxQcEYFXgFpfl9mUCO+IXTz1ekkZ+l+hsH+kZLGr+WF4AF8TJFmAXuMcCCVjH+UMKij7ad2tr4hs6FyYD0KxK8iv9c2P5DHrxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788958770; c=relaxed/simple;
	bh=i1HbAAmLLEsFjOnWR9bXHueuoEhrvxEd4xap4Bi/h/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AAQcxf2tHvwc+2OE1sCJNZiXsKm68AgNjefM3FnEEGt8g43LdOwhFKrkxclOr0M9zC5BK7DAwzKZJPqZNh7WlCxwELdIeJWOBx5edMJB8NSzJL75UN3CsLRDBsQhaXaECo2ZM4nC0Jt1EmGS0Vb8PTaMdf2a646q6AGpYthQzQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b8jdgobp; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b8jdgobp"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39666bed442so1001013a91.3
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 05:59:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788958767; cv=none;
        d=google.com; s=arc-20260327;
        b=nv8Ki1pp4pdBDoZ2GTgtyF3BiQqljnB+tPk36iwoFAor0dFj+M+jlhjezd9lqsUDyd
         P5evhejc1sFsBEy4TzIHrI8dSzYj9NO+INqCrtgJPLluRu+4dMmAg8m+l9F8yUBj6rsR
         UwSqV1PpoqUcP4DPgasjvMn7dgZnflX9eDV50OrX6eF9JsVMgCnAKChO6upLvsRZEot/
         6oPx9x35zoyDMTy1KzKIHrPFP+cBzFfBdU3Dff5TipumeH4ieQJkMv2E4k0PFlGdeBvw
         2xJtAHynw+ax09q4gyXVP/86dq+vpWZMVbzWoIzyVsryWBT5pCGnfcwiberpLOJKiCkk
         irJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i1HbAAmLLEsFjOnWR9bXHueuoEhrvxEd4xap4Bi/h/A=;
        fh=d/WhZQRq/PJ/2b+0wQL/xoyyZn5Q4Whh5PWo56toK7E=;
        b=G/bdCTv0tkugNnudTJW+DCnfswqolZHqRvZPvlaBj0yWG7VRpFTzizqyO8mj6GKj4w
         0p4rgMkS24pcJV2aj8wM5cYxrVGaLb7yqlM0hF2GMpFawYOdgtM3lPAOMV+tEdomog6w
         D2y/zvsyp6rY82UnSJJMsQU/lVjlEbDQYSaRwbgd2pWQQNPjd5KJ6vEC72XM6USJU0k7
         HUJ5uoHsn6FNjvACzgl3kcTdXU7w96fgQPeH82ReEA76n+maqVsJmE9ldGyQBphaM9Jk
         Nw9hesmY+tcjWKFf61HwwiGtOS2f50bGivPja/+2gVsl16eRGJcM45MWA1Rz+fybGMZ1
         UaIQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788958767; x=1789563567; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=i1HbAAmLLEsFjOnWR9bXHueuoEhrvxEd4xap4Bi/h/A=;
        b=b8jdgobpf6iJotPCt++6HS1J65D8oOCUtiAvw7bxOnm30uNVMENIz+xN63rhab1PO0
         6SWPMFrF0x9OzBV7nwBlofsQ5UfThkTqMOmSPh92d3YqDnSXPLgxyDRWyGwrZEIKgLQa
         egJuvXBIulCz1E5U4g1z5I8qK6yWEnim27+7z20Bb8G1gx9a2ePzK8MgZKNGIwPT4GlF
         zNT1HFz/e4tw/lmQQGBBUVDnsB/ao0ANBTLj74hLGxuScKDR3huGLbWQl9+eBdN/gA2S
         Y6P6TaJV9MdyCXmG6zWs09pjhSMycM/SMVSA463TU8mBqC4DxhQtCT9Erw9liO2TDGpJ
         rhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788958767; x=1789563567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i1HbAAmLLEsFjOnWR9bXHueuoEhrvxEd4xap4Bi/h/A=;
        b=FVs5JombDClcenWiXyuFz9kW+B0hkfxgwSNE5Oxj4DGvza94iTuDWqJGUFJ3INu4sN
         GEuEXRLv8Il9+pbUrtSRrLq0p/JGnna8PVnaZiCHEtRT0nkxMnkVMX4CcL3/w5mioZML
         VGL9o8P6ByvigMQOoqi2zW8tYzk2eJefgk6DV6ULRKfyEq5wHb+fWs5dAoKkYUX+M3tR
         mxjPhzsbtUecZ227sU19JD8DAG3S3BEnK50Uf9Zbh8GvhVWsp5C62axnonwTkJu3xgrg
         mKdlYoIgy4mobVZfCSxTI2PrJSOmyUzzvD//nngTjNdTZ5Nq4cyn/SPHT1ueCPej0Z7U
         sosA==
X-Forwarded-Encrypted: i=1; AKwUvBwi0jDOL7zRsrylI35oxfPPWIssLMFuMC/zPp4J1usEUf/33pR5IYy1e+xOg3q3q8nJGxze262VU6E=@vger.kernel.org
X-Gm-Message-State: AFuF++lQhS6Ep7yASoW6+0Njnwc4TFRCtX4f0LXJ19Hj/mS7cudDfCWw
	h9eXsDtF407joHNjHPtHMrNkQvZnzNQBsEMyapxlZQGmqtAB20dyYU0QofkjbCKzp48qsdjX/Dm
	5LOOhNNbFHrIVrAP14T6efWhaAVb4ZXA=
X-Gm-Gg: AYBFou3cBQdOjW/FK2lj/J8eWqdmomGbeF7GE1w/YGjnc0rdJIwlQ7jFOV5UlRLtPRK
	WP3R8TbF6WG6XZBmEFY31EGPUDhZhFvBoYz529lRxSTjthMZ6m7ADxteFgLYN48y2y5Q+bQwjJ1
	ncDkd760JHJBnT4tDaotIT1ZsvnG4AIfQZwRwFr1wieEIOSPCvW6Uy9+JlWk1P3OTKpxGoRijTI
	dIugPpHRXgpI2SPl8XB/kqm1FEK/So/X99/kvjx/CBOyFZWbxig8deAW8nBqCXzqoBHkQ90qugw
	r2z1aRvT9vSQHmojqKqz9vdP53Z8m1oYQoyyNVKGQbTj0MrTZvT8cCQuTdgjQONreFUVccXrEGZ
	hs+p6nXsX3xdoLPYDalMXeqh9HxQDlwAGPKXdXe3k148zIkDU9Ai3QDQTTVtzpkNDEn55Ppbk7F
	M4GjRelC7GFuJF6c7kd5Jv9MMuNMJbntichpXjyz05Yqt+O+mk1eE=
X-Received: by 2002:a17:90b:2888:b0:398:cee0:67dc with SMTP id
 98e67ed59e1d1-39b2699849cmr33697284a91.5.1788958766896; Wed, 09 Sep 2026
 05:59:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
 <20260908-build-speedup-v1-20-5dc1ac01672d@kernel.org> <t8iID_-Rgtrxxg-f1ZfdOg1xmm7YedvOT4pgDFEXKxoIeu29-JooZ3SSlbze088O0kLSOdgP7xN_Bo9Xm_lO1x51Gd-gIgT-tFPfwM_gCEw=@protonmail.com>
In-Reply-To: <t8iID_-Rgtrxxg-f1ZfdOg1xmm7YedvOT4pgDFEXKxoIeu29-JooZ3SSlbze088O0kLSOdgP7xN_Bo9Xm_lO1x51Gd-gIgT-tFPfwM_gCEw=@protonmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 9 Sep 2026 14:59:13 +0200
X-Gm-Features: AcwNN1Vwugoxsn23N3HKo79fRO4c4hCKpdWpUEii2k3VTwCoJF2DILgisLp6T0w
Message-ID: <CANiq72=rUrjFD8dHggtO5g0D5Yu-LjO4s7t=+yoKtteD56KfXw@mail.gmail.com>
Subject: Re: [PATCH 20/23] kbuild: rust: parallelise rustc front end
To: =?UTF-8?B?QmrDtnJuIEJhcm9u?= <bjorn3_gh@protonmail.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
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
	Gary Guo <gary@garyguo.net>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-doc@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 12:22=E2=80=AFPM Bj=C3=B6rn Baron <bjorn3_gh@protonm=
ail.com> wrote:
>
> There are still several known reproducibility issues for the parallel
> frontend[1] and at least until fairly recently there were also deadlock
> issues and incorrect errors[2], so I would not recommend enabling it with=
out
> an explicit request from the user. Perhaps even only allow it on nightly
> rustc for now, then you don't need to check which of the two spellings of
> the flag is supported.

Thanks a lot for taking a look Bj=C3=B6rn.

If there are still major issues even in nightly, then I would say
let's not add it yet -- some users/CIs are testing with nightly
routinely, so it is probably best to avoid surprises for them. (If
someone wants to test the flag, they can still pass it manually.)

On the other hand, if there are no major issues left and it is just
reproducibility issues, then I guess we could add it to help figure
those issues out and avoid surprises later on.

> By the way, currently backend parallelism is entirely disabled due to the
> usage of --emit obj (which forces -Ccodegen-units=3D1). For -O2/3 builds

Yeah, we even set `-Ccodegen-units=3D1` explicitly at the moment, so we
would need to change that too (and likely make it an option, because
normally end users will want the best results, while developers may
want speed of iteration).

Cheers,
Miguel
