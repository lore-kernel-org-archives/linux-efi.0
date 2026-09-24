Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C399C4D09E8
	for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 23:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790293206; cv=none; b=dp6swqouMaceBYezPfGYabPkBAS3H/l/AQd57IVbhIQPVZp6YDs0rJbkZx6AZotd1twoGzJ1mgb9LiLM9l95tPzqTUTtoGs6xxazSEkIE9NERv1U5hgQWJqKtU2RYD/SO5cOW5eJQTlqyi99rvevH3LszAi/xm2X9lyDwlzrLQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790293206; c=relaxed/simple;
	bh=4h4cpDObZqi2JEPN69eOCH4YBG2slYUeYHjBIAENU48=;
	h=Content-Type:Date:Message-Id:Cc:Subject:From:To:In-Reply-To:
	 References:MIME-Version; b=oZ2W8gwYU4JSWesAgNW+foxNpmKs58gJvZ0xANX0ygqtwMLFAV/l80Mv592g3fpq/0cydnbTFRoFkWlfkXFzB7mqbR3cxX72lgZsm2El8GlF1cYrUIIy+Q5NNXphRvd1n/9pwQqfsE6mAeqYW3H3vDurezBCpUSXBVog9ZmXM1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZGFYs1jG; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZGFYs1jG"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4c08393b0so114957a12.0
        for <linux-efi@vger.kernel.org>; Thu, 24 Sep 2026 16:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790293204; x=1790898004; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gn5dD1CJfoor6GODqvLgahaKF8S1PUZ5xI0XuIL5LIc=;
        b=ZGFYs1jG/Xr4uwPy2133K5sF0poGH1omJ0ns5UwD8enApwiJPDDFi1gLMSA+UY+qrO
         6lyZmvL2zJXgrS4urBwMTV3vFSBosNfxEeAHC2L0cHJkMBE9Oj9QKSvAuXGCWTgwH0c7
         yWYOAFlZXJt9BDXnhQUwZElM3+pKqDf9ymR/77Qjhm4q2k9A8H7TmnWzDJf4Vw1zQ8Vz
         HgO06YL+sF+7Efo+udo1jYXz4T5XB+sMNcQcYJJG3eDGSkCa/UybsOWnOQ+yWqiUaJ9C
         yc+2TaftdirQziHgwjLgiQLYNZ+cgLnH7mjbZhOQnbR+1/zQ5qgml8qc2Dm7Da1OEro+
         myTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790293204; x=1790898004;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gn5dD1CJfoor6GODqvLgahaKF8S1PUZ5xI0XuIL5LIc=;
        b=nv3E6CNfOb+u5UcnRSeNKFXa4ugPqN3peWDcKcJpPlMqYsc3u0qFN+8m4/CV0qQWjU
         qQpNeZMbEb52grA85WjSDdZk2o8aowedThXi/UseCGeWOtpx6unfqLXoPd1Qf0lmFiuZ
         YtCtwewRXYesjt+FtXa9xCM+RG9yl5s/GP54K2dJOLZVswR+GXno8T+l9OWEshYrLyky
         A/oF4K3D9+Iyn/EW/1KdZ8/8LH3cHOOyJLpxz+dMPqVM9XNWbJAz4bhBwLLm+ry5USQN
         I6fLkV1LrYLueR6KXDMyH8KRGKg8aq66wUFv1lS0Si6GtBA/djenUGcm9H31IWRwMLkA
         pFHw==
X-Forwarded-Encrypted: i=1; AKwUvBzMbp5Cryy+1W9BHK5xjNYBOzjieVOzby3AvFM9ER5bE6l9MYEHY7vwZ6JaNmsKMKPtK3NVz/4BRso=@vger.kernel.org
X-Gm-Message-State: AFuF++leW7/W1KAKnmrFbvjHIv1WTPxUNgdSqQilKRxv+6bDz3gb4Omj
	UEJD4kn4V9T1TilJ9nLQnPQfr1/G+jT6gC1/3FZTYtSdtuGD/19RJ25A
X-Gm-Gg: AYBFou3hLRcw3qcWi4nH4lQlHPEwQSvTiSCy5/m5eMUOULxXdl5ilBiDZk4d7CZXHZR
	Nn5zsMAodIQ2KUiTQ/bsyq6gx3v5wRKsgs/CN1F8tLZy/HMzsBH04+ZIEaMj/2kAYBG0KUG+qLE
	zy24N2Ng9vhhjA6eTjn3A5IYiq4xAMBVv47h+HEvi6UXDU/kmDsJF+tbhGWH2BfAYoZ7HWA6y0N
	kFfzpljm3+sUBq/E6X9oQ2uIXbtuDTU4hxfU1HePt+VH2vu68E1QiGlwSJvhmEPm4PFqzBtP9pN
	BznrekLfnyz9OBbSMAEGfn6rVzIJ0Gcq8Lia0BgdU4SGBDI2SQSQupskAUs41BE9mpwZMu+tOkB
	hdqC0vJUgcrNeVDcnlUtT1WsUnRfA8e3Qro0+L9jPxirhwVQytcaLKRW2uHo3bP10hg6tGxpgrw
	7XbpKldKpI3j56Jb7a4GcvZfgT5Qxn7f+4kKBriPJ/l3gPVfZ+ShqSs/lL4jZw9ww39B6Nh66pq
	38w3oXo8atsQtHUiJWrEbCXyBQlqnQi8A8BWZ8+sa1t52ccp59k5fvmwDpoASr74cHOgfOJ+VFK
	xy0=
X-Received: by 2002:a17:90b:1648:b0:39e:6c69:34d8 with SMTP id 98e67ed59e1d1-3a098fc574cmr3554656a91.60.1790293203799;
        Thu, 24 Sep 2026 16:40:03 -0700 (PDT)
Received: from localhost ([153.61.198.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efaeb3sm909723a91.2.2026.09.24.16.40.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 16:40:03 -0700 (PDT)
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Sep 2026 23:40:01 +0000
Message-Id: <DLNXZ2WK7TPD.2RZBUNRS4FA4L@gmail.com>
Cc: "Leon Hwang" <leon.hwang@linux.dev>, "Ihor Solodrai"
 <ihor.solodrai@linux.dev>, "Josh Poimboeuf" <jpoimboe@kernel.org>,
 <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
 <llvm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
 <bpf@vger.kernel.org>, <linux-efi@vger.kernel.org>,
 <rust-for-linux@vger.kernel.org>, "Ben Cressey" <ben@cressey.dev>, "Florent
 Revest (Anthropic)" <florent.revest@linux.dev>
Subject: Re: [PATCH v2 6/9] arm64: cfi: Use
 CONFIG_ARM64_FUNCTION_PREFIX_NOPS for the type hash offset
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mark Rutland" <mark.rutland@arm.com>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nicolas Schier" <nsc@kernel.org>, "Nick Desaulniers"
 <ndesaulniers@google.com>, "Bill Wendling" <morbo@google.com>, "Justin
 Stitt" <justinstitt@google.com>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi"
 <memxor@gmail.com>, "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu"
 <song@kernel.org>, "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa"
 <jolsa@kernel.org>, "Emil Tsalapatis" <emil@etsalapatis.com>, "Puranjay
 Mohan" <puranjay@kernel.org>, "Xu Kuohai" <xukuohai@huaweicloud.com>, "Ard
 Biesheuvel" <ardb@kernel.org>, "Ilias Apalodimas"
 <ilias.apalodimas@linaro.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Daniel Almeida"
 <daniel.almeida@collabora.com>, "Tamir Duberstein" <tamird@kernel.org>,
 "Alexandre Courbot" <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, "Sami Tolvanen" <samitolvanen@google.com>, "Kees
 Cook" <kees@kernel.org>
In-Reply-To: <20260924-b4-arm64-callops-kcfi-v2-6-587865b6d991@linux.dev>
References: <20260924-b4-arm64-callops-kcfi-v2-0-587865b6d991@linux.dev> <20260924-b4-arm64-callops-kcfi-v2-6-587865b6d991@linux.dev>
X-Mailer: mkdraft (claude review draft; edit before sending)
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, Sep 24, 2026 at 10:35 PM Jose Fernandez (Anthropic) <jose.fernandez@linux.dev> wrote:
>  static inline void emit_kcfi(u32 hash, struct jit_ctx *ctx)
>  {
> -	if (IS_ENABLED(CONFIG_CFI))
> -		emit_u32_data(hash, ctx);
> +	if (!IS_ENABLED(CONFIG_CFI))
> +		return;
> +
> +	emit_u32_data(hash, ctx);
> +	for (int i = 0; i < CONFIG_ARM64_FUNCTION_PREFIX_NOPS; i++)
> +		emit(A64_NOP, ctx);
>  }

For the series:
Acked-by: Alexei Starovoitov <ast@kernel.org>

unrelated minor issue:
ctx.offset[] is counted from ro_image, but bpf_prog_fill_jited_linfo()
adds it to prog->bpf_func which is ro_image + cfi_get_offset().
So with CFI jited_line_info is already off by one insn.
After this patch it will be off by 4 or 6.
s390 does
	jit.addrs[i] -= cfi_get_offset();
before the call.
Would be great to send a follow up eventually.

