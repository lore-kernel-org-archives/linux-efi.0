Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2034766A9
	for <linux-efi@vger.kernel.org>; Fri,  4 Sep 2026 12:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524315; cv=pass; b=VTXSum2Lqd5ZN0bYL1D8rwQohorP1fpce65EWDucqq4/Yw8WUxWezNCqu5WkUhffYiAEq2en8EclHnteO8jkIQhrluM4nfyQZXq9fyhtLgc12MNE8ijTFtIUF8r7MdIJik7/qnsj1MkYMSstBTG/TIYBgqiKHkud+8ybBjabz8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524315; c=relaxed/simple;
	bh=eO4W0pBpUA1VKwgA7pWUVcs1Sx0AhhcRANb40uA3yFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B5YOkYBIuH79IJ80CrgrFuGrGG8TQFGTJXBdWKsOKbEvKMdps42DO+FyqiVP8sS3W11nAH4x+HwB5ssYgx2W5HilUdYI7FJ7K7QU5GanZ4tlaBo7pAz5rmN9ICh6EFlKGAn9etODHoLvHT0n1AEHZitVyIldjlxnDqas4MaMiSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WMNauiri; arc=pass smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WMNauiri"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d5862bc921so2231875ad.1
        for <linux-efi@vger.kernel.org>; Fri, 04 Sep 2026 05:18:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788524313; cv=none;
        d=google.com; s=arc-20260327;
        b=MCgHG1RyZvb/EqO67HpSRo7Os6EIQQY2Proh8vkHluQCnWP8f4Y4PTjK8WLwzIJ3g7
         mkRI7DvuDO9D23pSFRyF6se56uGjD2mO2Mf0ZEKS9eWeCocNIVZzq3RwloAbxVGJZJEp
         j017CXv9vkmG4BhwNp4lSLAhgaHRwlXLnTDMD2Pfd00zDDyh0FldSFH8NxXDfnwgcRrx
         dSjtw62VJaC7rgRqLcCwvCocrS2Hw8IwLIQZn79ixnHMAYnRj4LjQuhagzaCQuXbIDAz
         WlGFG7cMfBR5cMxXLTWac8lOiUUmY33hrKSCygKIoaYjke/eLnGXW5mp55KwVjnn84ls
         +BZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eO4W0pBpUA1VKwgA7pWUVcs1Sx0AhhcRANb40uA3yFU=;
        fh=TuAL5fXo5VEDMHvDFdNNZkYLtt9DK55h1u6zJ7ndZhs=;
        b=qAvrE+80T7gPlUFD0Fhvzlcc0pFiTtTNN++fQ0IOE1bIanpXfDhUIiU9Aoh6SgJWsl
         bbkXDvh/4ri57vT+7K/V6Dsu68e39KT29U6CyTricmr6BdnYH2aRzunyHpra73BfsWbq
         4Dru864+hjKZFelagc4RTm3cvyMPbLGOyz8s6qdiPIsXGaVMmGj6lMDy/HniI4b9VM5J
         bEQAxBHvKGrMFYofxoNTA+Z5NTdRGCdUj7YSIjRTPosRnldwpyrU3EZdRMnb0+XLCSWA
         yBlZd4RB45NwsYjpGJhXtRbA1VLouYqoU2cb9q3VBWmllgHQ0LkEM/NyH4bKaE2PqzRg
         PNzg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788524313; x=1789129113; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eO4W0pBpUA1VKwgA7pWUVcs1Sx0AhhcRANb40uA3yFU=;
        b=WMNauiripi6Md2Q3C3KkcuWrocOGGRafMxbYDlATW6HV68aOBusr3FL4eXVoF4vhsX
         DO7Jgfmeno5zhnwRWIgfHvrvUM+3XTG/xFulQb6uxqGbEytQPlf+GGxxMKD983IfwasK
         JZ8dP4XrZbEY8oiEzvYHXjbMf5wbZHBRAbESh+IxlSqcdT149S3ok0u273lxbuoHsZB5
         x3PySqQZGNcJbPkCUFb2OKLEFffWYo+K3UUed1DYlevwTlbFIAr1+u029uYrVRygQ4ml
         OkrtFQlxk0wYKPBPPf39rZeJx4CxE/88YUpd0GyCLyKaJbRs/qop3EUiAQiviishSpQw
         WkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788524313; x=1789129113;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eO4W0pBpUA1VKwgA7pWUVcs1Sx0AhhcRANb40uA3yFU=;
        b=ZcTjT55m7BI7MiNVodvHDw4lS/F2dHtbxr85irRCcuzqRJOuFlEm4N8d2q9D0Ffuqk
         9K2NEexZY/gpUulUIXxtRVS+/GfjriomCweNlPwOH431YciB2//cu59puUJyjcKuuLD0
         s/he7grQr+fDVPbEEYeQ6QLBvaC7LRzPbb0vOR6dyILz7GqYKnRaCrXWk3rmY52+IQCQ
         qPA06WO1VQV7UsfsK9/qz62vI7j0rzeJp3o3SCXOVEgj5QjAKabw5BtX/Knlx8jfH1BJ
         reVi8/zt1kdjhcYMMR8n4YMN90NX+wAlP8qeAB9NE+/UHbd4kM1FU2rEzpHGZr2E5QF1
         Rh9g==
X-Forwarded-Encrypted: i=1; AKwUvBzIek1lUTi7P0ZcPzbGQVcCOZzPAtbZHwYEVFc5R6/I/M3LmKXVzzz2vVjIqfnDqYYl6Lx0fQ3fbO8=@vger.kernel.org
X-Gm-Message-State: AFuF++m5IsC7Zz1Wr/LVvEL6zT7pxLsPIsHzBat/rTznrwwir2nS0XFK
	k3hdph+ad+Nd6bl/bViA1itLkc0hhizSEnjEFUmCG20WrG7Hu0ruV+wWSYoKki+S7DTitbLvalF
	ls+nLlpdU7BNXzHL4F9VGZdazWFWUWOU=
X-Gm-Gg: AYBFou2IucEKQGi80nClhT5isN9qSeOM9/nNDiTkx005lTe59G6JlQaE56EqnKBI9/O
	GAawP2aegrnJDeHVE5DvokUbVCPc2pKK4k2Ht6MKLcu8e6uG83oJ1kJwv7uACheJMqzZLdcM05h
	TQets0ivhiYl6nllf24uegUy9o6HCIPYIEx5CMXXUCyF0+9b7isXcaVa2lsUsaSdTj3Pvq/acg7
	ueFcIBG4qCCrN3tOHsfT6rk1yKMNtlB1zRMl9OF7+hRpETdIwpKxN6RLFMB1Kb6r2h4/BvnuMeK
	j+DgnU7wIFNK2Va8i4Tw563oNxd+8Ab3rQaHiawYUZY9pHu9pAxNzLh4Haa+tGBF5r5ulneCnmB
	0dqAukUr5aIr5Fp/kk7qAP4LWor8zZowCog628KKrg+m97u8yYUUVAo/8IEev
X-Received: by 2002:a17:90b:5404:b0:396:d28e:b52 with SMTP id
 98e67ed59e1d1-39b26229b5dmr5722108a91.3.1788524312944; Fri, 04 Sep 2026
 05:18:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev> <20260904-b4-arm64-callops-kcfi-v1-6-ce6687739b0c@linux.dev>
In-Reply-To: <20260904-b4-arm64-callops-kcfi-v1-6-ce6687739b0c@linux.dev>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 4 Sep 2026 14:18:19 +0200
X-Gm-Features: AcwNN1W-BJa7t0_HMwRoOS4jQPgmmEa3lTrRn_StsdokzqumkRB4EleU3vHebmI
Message-ID: <CANiq72kg3Z5rB28H4Ck+EzqQgiRSSowBMe3YW6p_iNwOG_dzWA@mail.gmail.com>
Subject: Re: [PATCH RFC 6/8] arm64: ftrace: Support CALL_OPS on kernels built
 with kCFI
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

On Fri, Sep 4, 2026 at 3:20=E2=80=AFAM Jose Fernandez (Anthropic)
<jose.fernandez@linux.dev> wrote:
>
> Gate CALL_OPS under CFI on ARM64_CFI_PERMITS_CALL_OPS, which needs
> clang 21 or newer and RUST off. rustc has its own flag for the prefix
> NOPs and this patch does not pass it, so Rust functions would have no
> prefix and a different hash offset.

Why doesn't the patch pass the flag to `rustc`?

(Looking at later patches) Ah, is it because you defer it to the last patch=
?

Thanks!

Cheers,
Miguel
