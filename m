Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7F447F795
	for <linux-efi@vger.kernel.org>; Wed,  9 Sep 2026 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788968252; cv=none; b=Yq1eRPwVzh2iA+I+6HMHoi6tpL8fuZmNW+/7rl8cCh1uxOLaTTXPVeARw+sWMJJFWbJOApwyvz+s6llvsvhgp8ZkS1Vm7z/PE9E+qduGUGvftFL/hARNTIpQnCZb1gHfosNoWcfs+sVAZg6P1w5toCXgvSG8u0FLusPh6aRO79A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788968252; c=relaxed/simple;
	bh=tlXMq73KJhLbqOa3sBQb6U+eAptv38yQqOaGm+TCraA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZaqGc0x5jM5Aob3eDi48GHu8Cb8MwaMtvBs0SiupDlH2RJ5gNGzNyMWVPuvOBZ2z9SQ1KHvo56BdoUWv1qHkeYhYsiLdCZ8Lf5WWiG6q4MAwNwjw4OCb30uhoKDSujLpo4cgVGwryTBg8YPJjh8OKT7tM29QWB+ZztJ2YrW64Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MqvaKTZQ; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MqvaKTZQ"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f0b1fso183210066b.2
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 08:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1788968248; x=1789573048; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B7MDRo1IEz0/ztB5k2AgA6IiU/moC5VF/pQ54TqLA70=;
        b=MqvaKTZQ8jWTLjEaYtIw3pD39fHkAjH3DbeArNucFFXEnIxZgB05AeC6+kOToLaVEV
         bnGeiSBBGAVhHxhvOWWi0jtedu6uk4PQjCt47uMzUCoWdzFq+rQB5TY7MIYPIDJiK5MN
         Sw5urVZ9l78mUIxx8fi90kv9vwChqfDDztyZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788968248; x=1789573048;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B7MDRo1IEz0/ztB5k2AgA6IiU/moC5VF/pQ54TqLA70=;
        b=aUDdpKgNw9ENPm/2acSlSpZ579HX3PkiZ2KOJD1zGuKiAXoDi7uEc6pUwqbrg8B8Uf
         J/8IGt/AiZsjvWvwqZA/9u6ikjSZx5SPBTbWQd0WA7rrrf37BYTTugsIQio7YCoHzxr+
         z/Ye/TRHacLoduH4hcMwXeC2QSmZ07etl8dUVbHOr1inpxs9k10LyTupDHMJFqOIRUbY
         CSQB6dL3V6ExXwiHXMCGP90WByKekt1xw+1PPRZRgcHRusAfp9DSTdLf5G6uzTbvoJo3
         3zCwZq+qosdXRhPiHPZkl9Jkm3lK6T/rdt1GweAPZ/yKKFevOtuczsgSFenqQICwIvbX
         qOrA==
X-Forwarded-Encrypted: i=1; AKwUvBwzZmnfIKTxrRWys3rPcSgmKVcYsosKkmjlNrNRjEYzZV831XB71WgoWdOBgrl/mq1GHTMe5Xpk9Qg=@vger.kernel.org
X-Gm-Message-State: AFuF++nGVKN3BLw06lLFtE+qbnbRNzM+tyTSMLOZor1xskYsCBQi4y5y
	kZdYvoqWOLUsI/anOfwp8eSytqCrNEWVKpFFCqQeM4GgaC6muyzM26u5puH7cUqM1ZDLYj7TvCG
	P/jLvJ02JZBCU
X-Gm-Gg: AYBFou0/ZhHYUpevFTUa4fSxTIxYA0iOVQiEujUksw8aV7f+zdXcdBM7EzYx09SaxPT
	UqOi73r0UPxCOw6/smxNZ4FdjxPgKYdvUZZETiQMdPdKZ7yh/hOdnPnc6Hq/fGjuI8ajylNoqJs
	enV+K1GGVsd6ohtyOvg0mygjyvAgkkjF3rKaHwUZy+d728jbzPEcytzv/5Y6x4VPSJMU/CoGeUg
	J26FDMNs8ABipfg8HSRUH3yHGtjpgsPbQTnKQX4Fy+XgluzdcNHbQxg5Zd0TV0eHVbYAS3LYgbU
	V7q7Mg5XFPlCRXg0TDOfziNYhnl26Y3/bT1fz/+wY8cJavsu61g1piuHMgWrNe+5oQxZ8AgoUsK
	ervWxHra+DdjWWVuagUfbJTD47BgD/L9IIgRThS57fTNpdpFvk9DYnJpruqd/reiQ8hEO2jOkUM
	QO8q3AfaQgU8X+4M1NYTlVo+UTkigqq6cVcVxk1wXFmcFKDhB+GWGi48S9uWKn4EIL2BgIfvcdD
	ePpyzSBu/9DxNeqkZX9UoJIOoF6zLJBrEeYp/KKz4gEb12e
X-Received: by 2002:a17:907:3e0c:b0:c25:6c9a:88bc with SMTP id a640c23a62f3a-c292b1942d5mr574486666b.19.1788968248103;
        Wed, 09 Sep 2026 08:37:28 -0700 (PDT)
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com. [74.125.228.76])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c28e4579395sm534626866b.48.2026.09.09.08.37.27
        for <linux-efi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2026 08:37:27 -0700 (PDT)
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a996c8adf3so1247871a12.1
        for <linux-efi@vger.kernel.org>; Wed, 09 Sep 2026 08:37:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw1mjJMSP3c1XMvhEPyk7ivHMfg+9rAhyP0/hqqrwjBg9DDnAvgUy/fNLgTYTCYGEmyFfjQpRe4RUI=@vger.kernel.org
X-Received: by 2002:a05:6402:3817:b0:6a6:58e:f84b with SMTP id
 4fb4d7f45d1cf-6a98dfd77b1mr5256449a12.9.1788968246832; Wed, 09 Sep 2026
 08:37:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
In-Reply-To: <20260908-build-speedup-v1-0-5dc1ac01672d@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Sep 2026 08:37:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wieaheq8rXSps3xRZpNNMQMEj9BH5gU+Dh4q_ZgokO51Q@mail.gmail.com>
X-Gm-Features: AcwNN1XKEJS_S8eITIntw19v_mcHyut1QfPlZfjowWaI1qZq5Mivgkqwhzm7f_s
Message-ID: <CAHk-=wieaheq8rXSps3xRZpNNMQMEj9BH5gU+Dh4q_ZgokO51Q@mail.gmail.com>
Subject: Re: [PATCH 00/23] kbuild: significantly speed up kernel builds
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

On Tue, 8 Sept 2026 at 13:55, Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> A typical kernel build consists of a frustratingly large amount of time

.. you're preaching to the choir.

>                 == allmodconfig FULL build ==
>
>                         before    after     delta
>                       ----------------------------------
> Threadripper, gcc       345.3s   275.2s    -70.1s (-20%)

Well, that's certainly very encouraging. We should do this. I sent out
some emails as just reactions to individual patches, but I have no
numbers to back any of those emails up, and I never actually applied
this series to my tree - they were all based on reading the patches
themselves.

That said:

> An LLM was used to first determine where the bottlenecks were then to
> figure out how to improve them.
>
> It generated a lot of code, much of it hideous.

This made me scared to look at the patches originally, and I held off
in fear that the patches would be horrible and this build time
improvement would be hugely controversial garbage code.

But:

> I extensively audited and rewrote a lot of it, and heavily edited commit
> messages, the cover letter and comments.

None of the patches look at all horrible to me. You clearly excised
the hideous parts. All of my reactions were of the type "this could
probably be taken _further_" rather than me throwing my hands up in
disgust.

So the Rust parallelism thing clearly isn't ready based on feedback
from that quarter, but the rest looked safe and innocuous. I'm all for
merging this, although it should obviously go in through the right
channels. Mostly the kbuild tree, although some of it clearly would be
other cases - the objtool change in particular is fairly substantial
and needsobjtool people to approve. It didn't look all that
contentious, but still..

Anyway, I'd love for this all to go in. Build times are a pet peeve of mine.

              Linus
