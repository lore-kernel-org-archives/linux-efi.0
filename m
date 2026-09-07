Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC26430797
	for <linux-efi@vger.kernel.org>; Mon,  7 Sep 2026 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809599; cv=pass; b=hPyiYvDIvd0gA6gcduNVKovo9ku0ajdT9fZlbzFMgUX/EhFGeiG4BITeLELVV/KBO+jVVgkUMUG1OzRSr4YNeuPSEvWBxp9yCZAxAb9+949x10uAE+LN8C0F3IvEglvjogUKMewWfKMhFnDjbzP2IZx+Q9QvdWpO5ETVBv/TSuA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809599; c=relaxed/simple;
	bh=LbkJYZrKBAOtEAIquwnyRiPsYzlue46mhX6agZEqU8A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BRiRLAUFsrqXaVS61oe4V0G9YvMaKDKLV/IICH8gf9pUuNme4Pp1grE+WyLXsDnrY04VhFNX96ijdbotwytFlEcPgdIjBLMb6NXGV9YHzRFqz+mBGxuaJLBqHQkiBikbwaQZ1Lr9i8vbmTTlK6UdqPzNN++zw/98dQEUOn15Ck8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iK0qYj5j; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iK0qYj5j"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39666bed443so1005166a91.0
        for <linux-efi@vger.kernel.org>; Mon, 07 Sep 2026 12:33:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788809597; cv=none;
        d=google.com; s=arc-20260327;
        b=h7IhsHqvjn49msWSxDRxZvisCuAcrzdLcyEtXAK2l9WvhFOC+ls4IFGam11LJ9kmHY
         DV41jkdqJSbun17k9KrKA6+C/NW6b5nb2ibefWlALD2u81paJyRh4oXJW3c2H+PDrxj5
         tfKQjq8Fq39wT1LDr1pA9dnmZkWRYEPIEKc97xoXhe8Ajc7m9MaWNE3X4ng0xPbq7pEw
         3d9Cl4QhUS8XuVGKrehulBWLzEVd/RgQuAhCtvRcQD2ICsY3TTd8NfOAgZ5TYStqizTL
         fn4+RolyPfuNFIfE9TRUgT2gedZR5sfBrJlfJLWunOwb3uRTzDSOwWqjSJ/5draLgzrM
         MMgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LbkJYZrKBAOtEAIquwnyRiPsYzlue46mhX6agZEqU8A=;
        fh=sTwOjg2NR6qYdNuT8DbdmYiQ7ZXT5vpVJ51pARqhfw4=;
        b=rblK1QG8g7jGI9zBgNTgUBNvF02EE+gbJURD7bq8KVFQX3F7PyhvI1LUpDQl9YV4aK
         ZqEkBLVQFsYrprfy9eAV7mD+auw9Yn5HAnazGME5qcOkFdEJPGKOmS2QgyqKXrh7JBg4
         f+OkruZBO7jIcFSIGrq2zb6HmuS997SkThEFM5q80gthZdtxLucmTvtvFiQKFJsFuoGX
         TqNfcFnzYL/bh/MBQNX1GHFokFypfGgawNj/USRP1rZRK9r4G4o4PIio5D1xLBoX/jhe
         XNOYDhWaFuV4KFStBjTBN3iIPcjQKKF1RWXMtwy8dnmWIaE5+WYZCEYUUyL4SE6APOxk
         fRwQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788809597; x=1789414397; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LbkJYZrKBAOtEAIquwnyRiPsYzlue46mhX6agZEqU8A=;
        b=iK0qYj5js7h9LqZ16ntFi4pR+coNw+J1DIsxddLy2bybdXua8s7AhsQh5PKG4aPy8k
         cWfcsot8Jd3QOFo9QOMLhxclr26W+2bFQXUQb/5htv9RCQ75k/nTYOvsiDpAh9ZC1h0P
         17HYrGhBkPAcaFKfVJDBRota6XZwJTFU94U1d0QKrv1bCLj5OM6vuETU3sDAU1WcF6/P
         XwKGZTES39HLJn7EPOvbTJ556I3rp76dCWF5AVgyuUSKXaJklfe1ypw/YLdAV2Pt4o8p
         oIt3UyGz4+F70fE+3rhKKK66OxHCacES0jUQHDbVEe3CfUFb1qgvkTLFywu8+KyEsrhR
         Wz6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788809597; x=1789414397;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LbkJYZrKBAOtEAIquwnyRiPsYzlue46mhX6agZEqU8A=;
        b=jrz/FR+r4xtmQvrNfLVGGSJHbkBsU28zQqwQKhtZHc4bTo4gO8uh4mAWe8Coo09aOG
         iHPlP4LjTLgr2sYjfiQS657GCM2R+hnBtpY8bFYUpEx+aQK/IzSbejEK9B60+9e+qPpF
         NH8URALhLnguk28gzWjb6dzvzDVZGOcWb+Du2AtczQKnzjZMzyk9RgBW8oaTD2g7CRyq
         4/ubxMqDqAQzqrEjYUTkMtRGEMuqGVGtC/aWoJ3f9toeWMyaYP6rKJyWN8WmbvghYeVY
         hzEEZE3KlwRts8/qFJDkeRnYH8TESF3r4gF8GShtQKjmhoNLmOhNiMYm63KIewq0fbLM
         WvAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzN/IOA4rfJkhq9C1VgKxCB9gCE9shqcb2m7FWEpvK1JmKyBqh5y+1n3u2hNBfljvoqYyShpqwsmLE=@vger.kernel.org
X-Gm-Message-State: AFuF++kGP0kQVRu4qHCpzp0Iv8vzOGgf6yC6rIpae4yI5fkQEswjyqNg
	F7QR7M5tXRFASx+P6T+j19lNhqU8G8zWYtUbe3dJkAqWv8Sk6adxIFf6VVCJKDLBwd29ZqRk1Wi
	ClZCgRbtd77Mu+MiPr/fkhgXTtYAlcc0=
X-Gm-Gg: AYBFou2XT7JYBkixPminwp5AqQHnX/1UkBM2tA/r1OIf4nTX1lI4p4B0x0dL2mmai+s
	WCvb64ys8IuX3BVNFnOPmxJcfx8OxvG34bwTl1azJfM6O2AA3/FK1Pmw45ypCgEaV5cX3z37Crr
	JA68pxcYFqFOify2LM42S8QxF9OXeg6pfvuAV4a6cZaVPbI0O2kFNq44LKrNfaLDYD96Z4fH8Tq
	vge+22+LjaXpSBQZPNBxdEElTH4+SBh68kyZkBMSG+d1k2GHUitfoNmULK8c9IZRz/+lFzHxMwF
	CCLutntiF0MuAsFoNfb1Glg/2Bbt8ouK4ZW7qUJPfAsj8U0xUe289Zhp+mn/XJdAhx5MjAMMITb
	//h2MawzHwiu1JyocINBqjpB6EoG0tPiuDVELZCF2bespUfAUPFaBO7gc51u/3A==
X-Received: by 2002:a17:90b:1e04:b0:396:463e:2eeb with SMTP id
 98e67ed59e1d1-39b264b24e2mr23088437a91.0.1788809597288; Mon, 07 Sep 2026
 12:33:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev>
 <20260904-b4-arm64-callops-kcfi-v1-8-ce6687739b0c@linux.dev>
 <CANiq72=xOrSXBBdmrKYfX1=qgF37LRAMzMJd4GJkXaYHMVe9yQ@mail.gmail.com> <ap3Z-YDtzmdtMiMk@linux.dev>
In-Reply-To: <ap3Z-YDtzmdtMiMk@linux.dev>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 7 Sep 2026 21:33:03 +0200
X-Gm-Features: AcwNN1UJ5AD1nmjaRgagxZvj3fkfuD3Z7c-j0Zc231NENpcPq2HjO9j40kxIvNk
Message-ID: <CANiq72mVXNmqh-RdOunFLBKRwMgYHFBqJOP7NbXrd8WHPb3sAw@mail.gmail.com>
Subject: Re: [PATCH RFC 8/8] arm64: ftrace: Allow CALL_OPS on kCFI kernels
 built with Rust
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Xu Kuohai <xukuohai@huaweicloud.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Sami Tolvanen <samitolvanen@google.com>, Kees Cook <kees@kernel.org>, 
	Leon Hwang <leon.hwang@linux.dev>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, bpf@vger.kernel.org, 
	linux-efi@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	Ben Cressey <ben@cressey.dev>, "Florent Revest (Anthropic)" <florent.revest@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 6, 2026 at 11:24=E2=80=AFPM Jose Fernandez (Anthropic)
<jose.fernandez@linux.dev> wrote:
>
> # Do not pass -fpatchable-function-entry to bindgen: its libclang may not
> # support the section argument (Clang >=3D 21), and parsing does not need=
 it.

Thanks! Hmm... Not sure if "parsing" is the right word, i.e. a flag
change could still make `bindgen` parse and generate code fine but not
match the ABI of the C compiler.

i.e. I guess I would have expected something like "...: its libclang
may not support the section argument (Clang >=3D 21) and the removal of
the flag does not change the ABI" or similar.

Cheers,
Miguel
