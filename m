Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D931A363C48
	for <linux-efi@vger.kernel.org>; Sun,  6 Sep 2026 16:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788713823; cv=pass; b=PJCDoKrr4HB5CU1EZdCS5daq3nT9l5zKyOxyAVxFU9UXaOgQq+N65s/aiPG1lxceULD7EdZO+pdslVMB6xHAnKJ2fomo2hLvEZ9bQ1rJH1qmMj13Y23GuXec1pyUC81qlKiavcIiqtpxz6qRqPPIhpQ9PtvJMCfSiux+nCzQnUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788713823; c=relaxed/simple;
	bh=jLbNWAYKOjUjCxKPAnKQtbCBXntzd3CfPr6hFf0UbZI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jpc0LCwIZDKd3XbsZESIYyhtYWCyiJTkw/d7h2RUr/9Bm0M/NUIBKu8AbnVmVIjHuNSkwE6KjSJV0HY/Vx29GMo141/qs5ce+Q2ZurVVNS5TRSCZJNja7WW4BSTJVFtD/HOWjNd84sNNbkYeTC4Yk7QTz3/BLCfPB3FybvwSSOY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjHPtZQt; arc=pass smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjHPtZQt"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39666e7c9efso175587a91.3
        for <linux-efi@vger.kernel.org>; Sun, 06 Sep 2026 09:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788713821; cv=none;
        d=google.com; s=arc-20260327;
        b=CA99R849Sh2mGf28VIvKrPoQl3wUkPV1M5pljhJzcslaJVzvRJyMPodWYXySvdCUYy
         CxBmdW7QVUZPMGp699tQZvfx8+rJ4F4LSTNx7CovQOB0ig9V0OB3rD+oL+T7PldXdyEx
         d6Ill1Y3jPwJWGxj/ywnIxIugdg7iL2wHYXBLI7vYmcByRef6ncusHxfgGXnsl6gJeYR
         BXmJphCbWqAWpznLUGDB1Xp1/+OYMr9ZB0DUetGGDgSvNCezbnz8jQ9s3Sw+d2WWGwUN
         7oNRZ/FBvtGFr0kADTIhZm04nMrxU3DCyMnEv8d19PBEXXeq7txvoJt7QOqRXFSmQAz/
         0mSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jLbNWAYKOjUjCxKPAnKQtbCBXntzd3CfPr6hFf0UbZI=;
        fh=YQoQAgXofbYp9HirJx4X/tSulgJAD6/1V0fHl7Pm7Go=;
        b=Xwokx0eYEdrejDAay6PGnzsnIaUI+SLv/afH5weIpSRP9lrpp9ew+fUJNQYZIZsPNz
         QBfglPMFBGy3sXhi2rGBlI2InyXA29gy4I9q09ha9OC74qPK89UmRbhR8IOJdGKGgAVo
         AIcmVq/F+NTl93Qjy/ogLDQx/0t9L0orRQ5obsCsho+V57Y6558r+elXrMmWMokJ0ldR
         5EMmCFURfrXMQljcSCkxkxiT7HbnkyD+zvrslD9nt9AlIBaz/YU8E12RtpBo3Ts159s8
         vBccrnrDoB6HKQleMmaB6ETHwBZXqW3ByvxyDz6HwVgCd8h5XrYnuKTWNar0wFOVjM5Q
         pWVw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788713821; x=1789318621; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jLbNWAYKOjUjCxKPAnKQtbCBXntzd3CfPr6hFf0UbZI=;
        b=UjHPtZQtZlfn+jMBdsesbKV9hhN0VxB45TUW8NF6jsIj/u6sMjuVZl/S6vNiEMAdHB
         Te+UXjaLTopyZrVKblQ6F2RdO17BiDzp8YSjJWd1LjGv8/lpVMX/mJq6tjMcQBGE+lh3
         gkbl212FSvMq4hzn08kjNsXAWfz8CFVxj8DwBvGDcA2V9pboEq4SigdRgrpS5P3lbPAR
         WaeQlpczdSbYO4EXZkRcm/d2DFhfIccQOCyUcacVGnAtc0aqHvm4nD/lvAQStGw+ys2S
         nEMr3QPCYz3NCaB4lrh+lVRBv1NLXl63CMfDijyK5BqBSV6Pp1fy8GFAFtzsiR1Bm/Qi
         cjSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788713821; x=1789318621;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jLbNWAYKOjUjCxKPAnKQtbCBXntzd3CfPr6hFf0UbZI=;
        b=V7CnXa+53GW40utpHxMyPQ0z3cxjpgpisjhacpiGsSamHglPDadnlCrBSuhnT19c6k
         igLcD9RS0+ptnpQ5/96FnjZsuC8RFU2RS7PaO6g+j2AgKc7HrvavXDfn2bLyhF6mMTZR
         VlNlhPSuB3x5YJTrTVaslf0cY0NMksGBV0XMF8wV8sWIC4NfkPMz9n68HAEpv0smU2NN
         hMvvPK+OMzHcwlFLAqzbyE4lcCr028I9DL/d5AAkTWb3/S5o18B8/LaUnIRQNfhgr8jy
         ISkK4jPELum0hFqpTsh0RkAUU5l7u4kMhYJuXjqMwaK0tEBSgbFeuH9r7LGYz1zP7Ptm
         yHvA==
X-Forwarded-Encrypted: i=1; AKwUvBwW2+JLA4eyO+ItQ9WnCLmo9NVKChnhczFZcL8dkT4pRFsVnOQrhTVY5Hb5tTIy4PSdEYgNvOIlDho=@vger.kernel.org
X-Gm-Message-State: AFuF++kIPMC54ta04QcpjUBZd/nkhfHD/RL1Lf5DCWZJDCETa5fADoV/
	HZdcwZDmZdo08JolyOJyU55p1ZMGA8S7jPvvbnUFaDiJr8lSKmEMiDftEjzubINIvicm+HO6tDZ
	DRGDM13XBR4nd3G61ivSYFFj50dauSCw=
X-Gm-Gg: AYBFou2OBEgyxbr3D9NbYHbh7W4kKuZ9aFgB7DRc3aAbAhMy0rsB7V1tiKN5lg9ZXmP
	+Sb3EQlV2gevMlw+YukBJur8eoUj3pb1NuGcrlvPbSd0SjOt32BnQcSq9dmVilhurtRiq7IlhEf
	pWvmth2YcG+XWb23m31/C/tSE/OEU1BZXh69J1U8s+wma4s6IxBQdoPpxf4Q62Yg4zG6qiHujGS
	Qi1Qwp6Blp2ZDwMG//RkfRl8/tE4PbvubUlfkYxzpQdY5I0CWRzDRINsqtYpyZrvp1l4x6lHzm3
	bT7pPSA49h1zn4v8s9Z6i6ouhwM6ETtRSKIktV2132OWO6S9s+/palbsY2GC2fsKbJY1EjDO7Of
	wX+HOgJXa26Ja7nv3M2dbV+weVj38jHiEWQH936mIOWAApit+m2TEfm3Xmuch1pb7wMMzrPOl
X-Received: by 2002:a17:90b:384d:b0:398:bac0:238e with SMTP id
 98e67ed59e1d1-39b3d8377camr12050791a91.6.1788713821151; Sun, 06 Sep 2026
 09:57:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904-b4-arm64-callops-kcfi-v1-0-ce6687739b0c@linux.dev> <20260904-b4-arm64-callops-kcfi-v1-8-ce6687739b0c@linux.dev>
In-Reply-To: <20260904-b4-arm64-callops-kcfi-v1-8-ce6687739b0c@linux.dev>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 6 Sep 2026 18:56:47 +0200
X-Gm-Features: AcwNN1Vz7OHfpHx7W0dFC3jg8glvxcm1hmRiClFLpwy0F6DpBbL1JHHuwRxDDvo
Message-ID: <CANiq72=xOrSXBBdmrKYfX1=qgF37LRAMzMJd4GJkXaYHMVe9yQ@mail.gmail.com>
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

On Fri, Sep 4, 2026 at 3:20=E2=80=AFAM Jose Fernandez (Anthropic)
<jose.fernandez@linux.dev> wrote:
>
> +# bindgen generates no code, and its libclang may predate the section
> +# argument of -fpatchable-function-entry that a kCFI kernel with CALL_OP=
S
> +# passes on arm64.
> +bindgen_c_flags =3D $(filter-out -fpatchable-function-entry=3D%,$(c_flag=
s))

In general, one should be using the same version (we warn otherwise
early in the build), but yeah, it is just a warning for now and it is
nice to try to remain a bit flexible.

Now, if we are going to filter this out for Clang, should we just
filter it out for GCC too? i.e. outside the `ifdef`?

By the way, "generates no code" sounds a bit strange, since `bindgen`
generates source code...

Thanks!

Cheers,
Miguel
